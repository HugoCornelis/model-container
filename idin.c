//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: idin.c 1.31 Wed, 14 Nov 2007 16:12:38 -0600 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"


#include "neurospaces/components/vectorconnection.h"


/* Character for delimiting multiple wildcard paths */

/* #define	WCP_DELIM	',' */

/* test op codes */
#define BAD	-1
#define NOP	0
#define GT	1
#define LT	2
#define GE	3
#define LE	4
#define EQ	5
#define NE	6
#define AND	7

#define NUMMODE		0
#define STRMODE		1
#define CLASSMODE	2
#define ISAMODE		3


static Test *AddTest(PathInfo *pinfo);

static void ClearPinfo(PathInfo *pinfo);

static void GetPathInfo(char *path, PathInfo *pinfo);

static int LocateOp(char **str);

static char *GetIdent(char *str, char *ident);

static char *NextDelimiter(char *s);

static char *CloseDelimiter(char *s);

static int MatchWildcard(char *s, char *pattern);

static char *LocalPath(char *path, char *local);

static int CheckOptions(struct PidinStack *ppist, PathInfo pinfo);

/* static void FillList(Element *parent, ElementList *resultlist, int blockmode, PathInfo	pinfo); */

static int start(char *path);

static Test *AddTest(PathInfo *pinfo)
{
    Test *test;

    test = (Test *)calloc(1,sizeof(Test));
    /*
    ** insert into list
    */
    test->next = pinfo->test;
    pinfo->test = test;
    return(test);
}

static void ClearPinfo(PathInfo *pinfo)
{
    Test *test;
    Test *nexttest;

    if(pinfo== NULL) return;
    for(test=pinfo->test;test;test=nexttest){
	nexttest = test->next;
	free(test);
    }
    pinfo->test = NULL;
}

static void GetPathInfo(char *path, PathInfo *pinfo)
{
    char	tmp[100];
    char	*pathstr;
    char 	*str;
    char	field_id;
    int	op;
    Test	*test;
    char		ident[100];

    /*
    ** initialize the pinfo fields
    */
    strcpy(pinfo->path,path);
    pathstr = pinfo->path;
    pinfo->test = NULL;
    /*
    ** look for the [ delimiter indicating a modifier
    */
    while ((pathstr = NextDelimiter(pathstr))) {
	pathstr++;
	pathstr = GetIdent(pathstr,ident);
	/*
	** INDEX
	*/
	if(*ident == '\0'){
	    /*
	    ** an empty modifier is a shorthand for all indices 
	    ** which is equivalent to no index checking
	    ** The NOP is needed to prevent the default index 0
	    ** from being added when no index is specified.
	    */
	    test = AddTest(pinfo);
	    test->field_id = 'i';
	    test->op = NOP;
	    pathstr = CloseDelimiter(pathstr);
	    continue;
	} 
	if(*ident >= '0' && *ident <= '9'){
	    /*
	    ** index notation
	    */
	    if(strchr(ident,'-')){
		/*
		** shorthand index range notation
		*/
		test = AddTest(pinfo);
		test->field_id = 'i';
		test->op = GE;
		sscanf(ident,"%f-",&test->value);
		test = AddTest(pinfo);
		test->field_id = 'i';
		test->op = LE;
		sscanf(strchr(ident,'-'),"-%f]",&test->value);
	    } else {
		/*
		** a number alone is shorthand for an index equality comparison
		*/
		test = AddTest(pinfo);
		test->field_id = 'i';
		test->op = EQ;
		sscanf(ident,"%f]",&test->value);
	    }
	    pathstr = CloseDelimiter(pathstr);
	    continue;
	}
	/*
	**  TYPE   [TYPE=objname]
	*/
	if((strcmp(ident,"TYPE") == 0) ||
	   (strcmp(ident,"OBJECT") == 0)){
	    /*
	    ** get the operator
	    */
	    if((op = LocateOp(&pathstr)) == BAD){
		printf("illegal operator in the path specification '%s'\n",
		       ident);
		break;
	    }
	    /*
	    ** add the new type test to the list
	    */
	    test = AddTest(pinfo);
	    test->op = op;
	    test->field_id = 't';
	    str = test->name;
	    /*
	    ** get the type name
	    */
	    while(*pathstr != ']' && *pathstr != '\0'){
		*str = *pathstr;
		str++;
		pathstr++;
	    }
	    *str ='\0';
	    pathstr = CloseDelimiter(pathstr);
	    continue;
	}
	/*
	**  ISA   [ISA=objname]
	*/
	if(strcmp(ident,"ISA") == 0){
	    /*
	    ** get the operator
	    */
	    if((op = LocateOp(&pathstr)) == BAD){
		printf("illegal operator in the path specification '%s'\n",
		       ident);
		break;
	    }
	    /*
	    ** add the new type test to the list
	    */
	    test = AddTest(pinfo);
	    test->op = op;
	    test->field_id = 'o';
	    str = test->name;
	    /*
	    ** get the type name
	    */
	    while(*pathstr != ']' && *pathstr != '\0'){
		*str = *pathstr;
		str++;
		pathstr++;
	    }
	    *str ='\0';
	    pathstr = CloseDelimiter(pathstr);
	    continue;
	}
	/*
	**  CLASS   [CLASS=classname]
	*/
	if(strcmp(ident,"CLASS") == 0){
	    /*
	    ** get the operator
	    */
	    if((op = LocateOp(&pathstr)) == BAD){
		printf("illegal operator in the path specification '%s'\n",
		       ident);
		break;
	    }
	    /*
	    ** add the new class test to the list
	    */
	    test = AddTest(pinfo);
	    test->op = op;
	    test->field_id = 'c';
	    str = tmp;
	    /*
	    ** get the class name
	    */
	    while(*pathstr != ']' && *pathstr != '\0'){
		*str = *pathstr;
		str++;
		pathstr++;
	    }
	    *str ='\0';
	    pathstr = CloseDelimiter(pathstr);
/* 	    /* */
/* 	    ** lookup the class name */
/* 	    * */
/* 	    if((test->value = ClassID(tmp)) == INVALID_CLASS){ */
/* 		Error(); */
/* 		printf("invalid class '%s'.\n",tmp); */
/* 	    } */
	    continue;
	}
	/*
	**  RANGE   [x,y,z=value]
	*/
	if((strcmp(ident,"x") == 0) ||
	   (strcmp(ident,"y") == 0) ||
	   (strcmp(ident,"z") == 0)){
	    field_id = *ident;
	    /*
	    ** get the operator
	    */
	    if((op = LocateOp(&pathstr)) == BAD){
		printf("illegal operator in the path specification '%s'\n",
		       pathstr);
		break;
	    }
	    /*
	    ** add the new test to the list
	    */
	    test = AddTest(pinfo);
	    test->op = op;
	    test->field_id = field_id;
	    /*
	    ** get the range value
	    */
	    sscanf(pathstr,"%f]",&test->value);
	    pathstr = CloseDelimiter(pathstr);
	    continue;
	}
	/*
	**  FIELD   [field=value]
	*/
	/*
	** get the operator
	*/
	if((op = LocateOp(&pathstr)) == BAD){
	    printf("illegal operator in the path specification '%s'\n",
		   ident);
	    break;
	}
	/*
	** add the new field test to the list
	*/
	test = AddTest(pinfo);
	test->op = op;
	test->field_id = 'f';
	/*
	** get the field name
	*/
	strcpy(test->name,ident);
	/*
	** get the field value
	*/
	sscanf(pathstr,"%f]",&test->value);
	pathstr = CloseDelimiter(pathstr);
	continue;
    }
    /*
    ** check for the default indexing case of 0
    */
    if(pinfo->test == NULL){
	test = AddTest(pinfo);
	test->field_id = 'i';
	test->op = EQ;
	test->value = 0;
    }

    /*
    ** clear the extra stuff at the end of the path
    ** by searching for the first option delimiter and zeroing it
    */
    if((pathstr = strchr(pinfo->path,'['))){
	*pathstr = '\0';
    }
}

/*
** returns the op code and leaves the string pointer at the first
** location following the op string
*/
static int LocateOp(char **str)
{
    /*
    ** skip to the first valid op character
    */
    while(**str != '\0' && 
	**str != ']' && 
	**str != '[' && 
	**str != '=' &&
	**str != '&' &&
	**str != '<' &&
	**str != '>' &&
	**str != '!'){
	(*str)++;
    }
    if(**str == '='){
	(*str)++;
	return(EQ);
    }
    if(**str == '!' && *((*str)+1) == '='){
	(*str)++;
	(*str)++;
	return(NE);
    }
    if(**str == '<' && *((*str)+1) == '>'){
	(*str)++;
	(*str)++;
	return(NE);
    }
    if(**str == '<' && *((*str)+1) == '='){
	(*str)++;
	(*str)++;
	return(LE);
    }
    if(**str == '>' && *((*str)+1) == '='){
	(*str)++;
	(*str)++;
	return(GE);
    }
    if(**str == '>'){
	(*str)++;
	return(GT);
    }
    if(**str == '<'){
	(*str)++;
	return(LT);
    }
    if(**str == '&'){
	(*str)++;
	return(AND);
    }
    return(BAD);
}

static char *GetIdent(char *str, char *ident)
{
    /*
    ** skip to the first valid op character
    */
    while(*str != '\0' && 
    *str != ']' && 
    *str != '[' && 
    *str != '=' &&
    *str != '<' &&
    *str != '>' &&
    *str != '!'){
	*ident = *str;
	ident++;
	str++;
    }
    *ident = '\0';
    return str;
}

static char *NextDelimiter(char *s)
{
    if(s == NULL) return(NULL);
    while(*s != '[' && *s != ']' && *s != '\0'){
	s++;
    }
    if(*s == '['){
	return(s);
    }
    if(*s == ']'){
/* 	Error(); */
	printf("missing '[' delimiter\n");
	return(NULL);
    }
    return(NULL);
}

static char *CloseDelimiter(char *s)
{
    if(s == NULL) return(NULL);
    while(*s != '[' && *s != ']' && *s != '\0'){
	s++;
    }
    if(*s == ']'){
	return(s+1);
    }
    if(*s == '['){
/* 	Error(); */
	printf("missing ']' delimiter\n");
	return(s);
    }
    return(s);
}

static int MatchWildcard(char *s, char *pattern)
{
    char *wild;
    int last_len;
    int first_len;
    int wild_len=1;

    /*
    ** the pattern can be of the form a#b
    ** or a???b
    */
    if((wild = strchr(pattern,'?')) != NULL){
	/*
	** if it is the single character match then check for length
	** requirements
	*/
	if(strlen(s) != strlen(pattern)){
	    return(0);
	}
	while(*(wild +wild_len) == '?'){
	    wild_len++;
	}
    } else
	if((wild = strchr(pattern,'#')) == NULL){
	    /*
	    ** just do simple matching
	    */
	    return(strcmp(s,pattern) == 0);
	}
    first_len = (int)(wild - pattern);
    last_len = (int)strlen(wild+wild_len);
    /*
    ** match the first part of the pattern
    */
    if(strncmp(s,pattern,first_len) != 0){
	return(0);
    }
    /*
    ** match the last part of the pattern
    */
    if(strncmp(s + strlen(s) - last_len, wild+wild_len,last_len) != 0){
	return(0);
    }
    return(1);
}

/*
** Search for / which separate levels in the tree.
** Terminate the local path at the separator and return the
** string starting at the separator character
*/
static char *LocalPath(char *path, char *local)
{
    /*
    ** copy the path up to the separator into local_path
    */
    while (*path != '/' && *path != '\0') {
	*local = *path;
	path++; 
	local++;
    }
    *local = '\0' ;
    /*
    ** return the string following the separator
    */
    if(*path != '\0')
	return(path+1);
    else
	return(NULL);
}


static int CheckOptions(struct PidinStack *ppist, PathInfo pinfo)
{
    Test 	*test;
    int 	reject = FALSE;
    float 	val;
    char 	*strval;
    char 	*str;
    int 	mode;

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    for(test=pinfo.test;test;test=test->next){
	mode = NUMMODE;
	switch(test->field_id){
/* 	case 'i':			/* INDEX * */
/* 	    val = element->index; */
/* 	    break; */
	case 'o':			/* ISA object */
	    mode = ISAMODE;
	    break;
/* 	case 't':			/* TYPE * */
/* 	    strval = element->object->name; */
/* 	    mode = STRMODE; */
/* 	    break; */
/* 	case 'x':			/* X * */
/* 	    val = element->x; */
/* 	    break; */
/* 	case 'y':			/* Y * */
/* 	    val = element->y; */
/* 	    break; */
/* 	case 'z':			/* Z * */
/* 	    val = element->z; */
/* 	    break; */
	case 'c':			/* CLASS */
	    mode = CLASSMODE;
	    break;
	case 'f':			/* FIELD */
	    val = SymbolParameterResolveValue(phsle, ppist, test->name);
/* 	    str = ElmFieldValue(element,test->name); */
/* 	    if(str == NULL){ */
/* 		/* */
/* 		** doesnt have the field */
/* 		* */
/* 		return(0); */
/* 	    } */
/* 	    val = Atof(str); */
	    break;
	default:
	    return(0);
	    /* NOTREACHED */
	    break;
	}
	switch(mode){
/* 	    /* */
/* 	    ** check object isa */
/* 	    * */
/* 	case ISAMODE: */
/* 	    reject = ElementIsA(element, test->name); */
/* 	    if (test->op == EQ) */
/* 		reject = !reject; */
/* 	    break; */
	    /*
	    ** check string fields
	    */
/* 	case STRMODE: */
/* 	    switch(test->op){ */
/* 	    case EQ: */
/* 		if(strcmp(test->name,strval) != 0){ */
/* 		    reject = TRUE; */
/* 		} */
/* 		break; */
/* 	    case NE: */
/* 		if(strcmp(test->name,strval) == 0){ */
/* 		    reject = TRUE; */
/* 		} */
/* 		break; */
/* 	    } */
/* 	    break; */
	case CLASSMODE:
	    switch(test->op){
	    case EQ:
		if (0 != strcmp(SymbolHSLETypeDescribeNDF(phsle->iType), test->name))
		{
		    reject = TRUE;
		}
		break;
	    case NE:
		if (0 == strcmp(SymbolHSLETypeDescribeNDF(phsle->iType), test->name))
		{
		    reject = TRUE;
		}
		break;
	    }
	    break;
	case NUMMODE:
	    /*
	    ** check numeric fields
	    */
	    switch(test->op){
	    case EQ:
		if(val != test->value){ 
		    reject = TRUE; 
		}
		break;
	    case NE:
		if(val == test->value ){ 
		    reject = TRUE; 
		}
		break;
	    case GE:
		if(val < test->value ){
		    reject = TRUE;
		}
		break;
	    case LE:
		if(val > test->value){
		    reject = TRUE;
		}
		break;
	    case LT:
		if(val >= test->value){
		    reject = TRUE;
		}
		break;
	    case GT:
		if(val <= test->value){
		    reject = TRUE;
		}
		break;
	    case AND:
		if(!((int)val & (int)(test->value))){
		    reject = TRUE;
		}
		break;
	    }
	}
	if(reject) return(0);
    }
    return(1);
}

/*
** use the path specification to fill the element list
**
** blockmode parameter now has two functions.  The previous function
** of blocking inclusion of elements under a blocked element remains
** under control of the (blockmode&0x1) bit.  In addition, the
** (blockmode&0x2) bit controls inclusion of elements which are
** components of an extended object.  When the bit is set, component
** elements are visible.
*/

#ifdef FillList
static void FillList(Element *parent, ElementList *resultlist, int blockmode, PathInfo	pinfo)
{
    ElementStack 	*stk;
    Element 	*element;

    /*
    ** CASE: .
    */
    if(strcmp(pinfo.path,"^") == 0){
	if((element = RecentElement()) != NULL &&
	   ((blockmode&0x2) || VISIBLE(element))){
	    AddElementToList(element,resultlist);
	}
	return;
    }
    /*
    ** CASE: .
    */
    if(strcmp(pinfo.path,".") == 0){
	AddElementToList(parent,resultlist);
	return;
    }
    /*
    ** CASE: ..
    */
    if(strcmp(pinfo.path,"..") == 0){
	AddElementToList(parent->parent,resultlist);
	return;
    }
    /*
    ** CASE: 	##
    */
    if(strcmp(pinfo.path,"##") == 0){
	/*
	** fill the list with all descendents of the parent
	*/
	stk = NewPutElementStack(parent);
	while ((element = NewFastNextElement(blockmode,stk))) {
	    if(CheckOptions(element,pinfo)){
		AddElementToList(element,resultlist);
	    }
	}
	NewFreeElementStack(stk);
	return;
    }
    /*
    ** CASE: 	#
    */
    if(strcmp(pinfo.path,"#") == 0){
	for(element=parent->child;element;element=element->next){
	    if(!(blockmode&0x1) || (IsEnabled(element))){
		if ((blockmode&0x2) || VISIBLE(element))
		    if(CheckOptions(element,pinfo)){
			AddElementToList(element,resultlist);
		    }
	    }
	}
	return;
    }
    /*
    ** Handle partial string matching
    **
    ** CASE:		a#b a?b
    */
    if(strchr(pinfo.path,'#') || strchr(pinfo.path,'?')){
	for(element=parent->child;element;element=element->next){
	    /*
	    ** check the name
	    */
#ifdef FIXBLOCKMODE
	    if(!blockmode || (IsEnabled(element))){
#endif
		if ((blockmode&0x2) || VISIBLE(element))
		    if(MatchWildcard(element->name,pinfo.path)){
			if(CheckOptions(element,pinfo)){
			    AddElementToList(element,resultlist);
			}
		    }
#ifdef FIXBLOCKMODE
	    }
#endif
	}
    } else {
	/*
	** Normal case without wildcards
	*/
	for(element=parent->child;element;element=element->next){
#ifdef FIXBLOCKMODE
	    if(!blockmode || (IsEnabled(element))){
#endif
		/*
		** check the name
		*/
		if ((blockmode&0x2) || VISIBLE(element))
		    if(*pinfo.path == '\0' || strcmp(element->name,pinfo.path) == 0){
			if(CheckOptions(element,pinfo)){
			    AddElementToList(element,resultlist);
			}
		    }
#ifdef FIXBLOCKMODE
	    }
#endif
	}
    }
}
#endif

static int start(char *path)
{
    char *local = (char *)malloc(strlen(path)+1);

    PathInfo pinfo;

    /*
    ** go through all of the parents
    */
    GetPathInfo(local,&pinfo);

    int i;

/*     for(i=0;i<parentlist->nelements;i++){ */
/* 	parent = parentlist->element[i]; */
/* 	FillList(parent,childlist,blockmode,pinfo); */
/*     } */

    ClearPinfo(&pinfo);
}

#undef BAD
#undef NOP
#undef GT
#undef LT
#undef GE
#undef LE
#undef EQ
#undef NE
#undef AND


/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin, NULL for failure
/// 
/// \brief Allocate a new idin symbol table element
/// 

struct symtab_IdentifierIndex * IdinCalloc(void)
{
    //- set default result : failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- allocate idin

    pidinResult
	= (struct symtab_IdentifierIndex *)
	  calloc(1, sizeof(struct symtab_IdentifierIndex));

    //- return result

    return(pidinResult);
}


/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin, NULL for failure
/// 
/// \brief Allocate a new idin symbol table element
/// 

struct symtab_IdentifierIndexSelector *
IdinSelectorCalloc(void)
{
    //- set default result : failure

    struct symtab_IdentifierIndexSelector *pidinResult = NULL;

    //- allocate idin

    pidinResult
	= (struct symtab_IdentifierIndexSelector *)
	  calloc(1, sizeof(struct symtab_IdentifierIndexSelector));

    pidinResult->iFlags = FLAG_IDENTINDEX_SELECTOR;

    //- return result

    return(pidinResult);
}


/// 
/// \arg pc sprintf format, NULL for a default, %i gets count.
/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin with a count in the name, NULL for
///	failure.
/// 
/// \brief Allocate a new idin, give unique name using a counter.
/// 
/// \note  Do not exceed 50 chars with format.
/// 

struct symtab_IdentifierIndex * IdinCallocUnique(char *pcFormat)
{
    //- set default result : failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    static int iUnique = 0;

    char pcUnique[1000];

    //- get a format

    char *pcDefaultFormat = "unique[%i]";

    if (!pcFormat)
    {
	pcFormat = pcDefaultFormat;
    }

    //- generate unique string

    sprintf(pcUnique, pcFormat, iUnique);

    iUnique++;

    //- allocate idin

    pidinResult = IdinCalloc();

    pidinResult->pcIdentifier = (char *)calloc(1, 1 + strlen(pcUnique));

    strcpy(pidinResult->pcIdentifier,pcUnique);

    pidinResult->iFlags |= FLAG_IDENTINDEX_UNIQUE;

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin original id to create alias for.
/// \arg iCount count to make the created id unique.
/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin, NULL for failure.
/// 
/// \brief Create an alias id.
/// 
/// \note  not sure what to do with flags.
/// 

struct symtab_IdentifierIndex *
IdinCreateAlias(struct symtab_IdentifierIndex *pidin, int iCount)
{
    //- default result: failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- create a useful name, hopefully unique

    /// \note client needs to check for uniqueness

    char pc[1000];

    sprintf(pc, "%s_%i", pidin->pcIdentifier, iCount);

    char *pcName = calloc(1, 1 + strlen(pc));

    if (!pcName)
    {
	return(NULL);
    }

    strcpy(pcName, pc);

    //- create result

    pidinResult = IdinNewFromChars(pcName);

    //- copy some members

    pidinResult->iFlags = pidin->iFlags;

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin IdentifierIndex list to get name for
/// \arg pcName: string receiving result
/// 
/// \return void
/// 
///	pcName: string receiving result
/// 
/// \brief get name of IdentifierIndex list
/// 
/// \todo
/// 
/// Fields are not separated with a field separator but with a symbol
/// separator, this needs to be fixed.
/// 

void IdinFullName(struct symtab_IdentifierIndex *pidin, char *pcName)
{
    //- if first idin is rooted

    if (IdinIsRooted(pidin))
    {
	//- first characters come from root symbol

	pcName[0] = ((char *)(SYMBOL_ROOT))[0];

	pcName++;
    }

    //- loop over idin list

    while (pidin)
    {
	//- if pidin has identifier

	if (!(pidin->iFlags & FLAG_IDENTINDEX_NOIDENTIFIER))
	{
	    //- copy name of idin

	    strcpy(&pcName[0], IdinName(pidin));

	    pcName = &pcName[strlen(IdinName(pidin))];

	    //- add seperator

	    pcName[0] = ((char *)(SYMBOL_CHAR_SEPERATOR))[0];

	    pcName++;
	}

	//- go to next idin

	pidin = pidin->pidinNext;
    }

    pcName[-1] = '\0';
}


/// 
/// \arg pidin IdentifierIndex struct to get name for
/// 
/// \return char * : name of IdentifierIndex struct, NULL for failure
/// 
/// \brief get name of IdentifierIndex struct
///
/// \details 
/// 
///	Return value is pointer to symbol table read only data
/// 

char * IdinName(struct symtab_IdentifierIndex *pidin)
{
    //- set default result : no name

    char *pcResult = NULL;

    //- if pidin is legal pidin

    if (IdinIsPrintable(pidin))
    {
	//- if points to parent

	if (IdinPointsToParent(pidin))
	{
	    pcResult = IDENTIFIER_SYMBOL_PARENT_STRING;
	}

	//- if points to current

	else if (IdinPointsToCurrent(pidin))
	{
	    pcResult = IDENTIFIER_SYMBOL_CURRENT_STRING;
	}

	//- if pidin has identifier

	else if (!(pidin->iFlags & FLAG_IDENTINDEX_NOIDENTIFIER))
	{
	    //- set result from pidin name

	    pcResult = pidin->pcIdentifier;
	}
    }

    //- else

    else
    {
/* 	//- check if this code is triggered */

/* 	/// \note triggered during complete traversals. */

/* 	*(int *)0 = 0; */

	/// \note the lesser this code is triggered, the better.

	static char pcName[30] = "";

	/// \todo gives a warning on 64bit machines.

	sprintf(pcName,"CONN %i",(int)pidin);

	//- set result : illegal pidin (from connection ?)

	pcResult = pcName;
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg pc name of idin
/// 
/// \return struct symtab_IdentifierIndex * : new idin
/// 
/// \brief Create idin with given name (no copy).
/// 

struct symtab_IdentifierIndex *IdinNewFromChars(char *pc)
{
    //- allocate

    struct symtab_IdentifierIndex *pidinResult = IdinCalloc();

    //- set name

    IdinSetName(pidinResult, pc);

    if (strcmp(pc, IDENTIFIER_SYMBOL_PARENT_STRING) == 0)
    {
	IdinSetFlags(pidinResult, FLAG_IDENTINDEX_PARENT);
    }

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin a pidin.
/// \arg pfile file to print to, NULL is stdout.
/// 
/// \return void.
/// 
/// \brief print pidin to a file.
/// 

void IdinPrint(struct symtab_IdentifierIndex *pidin, FILE *pfile)
{
    if (!pfile)
    {
	pfile = stdout;
    }

    char pc[1000];

    IdinFullName(pidin, pc);

    fprintf(pfile, pc);
}


