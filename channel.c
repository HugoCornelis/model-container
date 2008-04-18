//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: channel.c 1.87 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/channel.h"
#include "neurospaces/segmenter.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/attachment.h"

#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


static int ChannelTable_READ(struct symtab_Channel *pchan,char *pcFilename);


//d
//d test type(pchannel) == struct symtab_Channel * at compile time
//d

#define CompileTimeTestChannel(pchan)					\
do {									\
    struct symtab_Channel chan;						\
    (pchan) == &chan;							\
} while (0)


//d
//d check if genesis style object present
//d

#define ChannelHasGenesisObject(pchan)					\
({									\
    CompileTimeTestChannel(pchan);					\
    ((pchan)->dechan.genObject.iType != 0);				\
})


/// **************************************************************************
///
/// SHORT: ChannelCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Channel * 
///
///	Newly allocated channel, NULL for failure
///
/// DESCR: Allocate a new channel symbol table element
///
/// **************************************************************************

struct symtab_Channel * ChannelCalloc(void)
{
    //- set default result : failure

    struct symtab_Channel *pchanResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/channel_vtable.c"

    //- allocate channel

    pchanResult
	= (struct symtab_Channel *)
	  SymbolCalloc(1, sizeof(struct symtab_Channel), _vtable_channel, HIERARCHY_TYPE_symbols_channel);

    //- initialize channel

    ChannelInit(pchanResult);

    //- return result

    return(pchanResult);
}


/// **************************************************************************
///
/// SHORT: ChannelCreateAlias()
///
/// ARGS.:
///
///	pchan.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
ChannelCreateAlias
(struct symtab_Channel *pchan,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Channel *pchanResult = ChannelCalloc();

    //- set name and prototype

    SymbolSetName(&pchanResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pchanResult->bio.ioh.iol.hsle, &pchan->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_channel);

    //- return result

    return(&pchanResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: ChannelGetEquation()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: struct symtab_HSolveListElement * : 
///
///	channel equation, NULL if none, -1 for failure
///
/// DESCR: get channel equation
///
/// **************************************************************************

static int 
ChannelEquationChecker
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if equation

    if (instanceof_equation(phsle))
    {
	//- set result : ok

	*(struct symtab_HSolveListElement **)pvUserdata = phsle;

	//- set result : abort traversal

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}

struct symtab_HSolveListElement *
ChannelGetEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : NULL

    struct symtab_HSolveListElement *phsleResult = NULL;

    //v result from traversal

    int iTraversal;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   NULL,
	   NULL,
	   ChannelEquationChecker,
	   (void *)&phsleResult,
	   NULL,
	   NULL);

    //- traverse channel children, check for equation

    iTraversal = TstrGo(ptstr,&pchan->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if failure

    if (iTraversal == 0)
    {
	//- set result : failure

	phsleResult = (struct symtab_HSolveListElement *)-1;
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ChannelGetGenesisObject()
///
/// ARGS.:
///
///	pchan.: channel to check
///
/// RTN..: struct descr_genesis_object * : genesis object, NULL for failure
///
/// DESCR: get channel genesis object
///
/// **************************************************************************

struct descr_genesis_object *
ChannelGetGenesisObject(struct symtab_Channel *pchan)
{
    //- set default result : failure

    struct descr_genesis_object *pgenResult = NULL;

    //- if not valid

    while (pchan && !ChannelHasGenesisObject(pchan))
    {
	//- get channel prototype

	pchan = (struct symtab_Channel *)SymbolGetPrototype(&pchan->bio.ioh.iol.hsle);
    }

    //- if valid

    if (pchan && ChannelHasGenesisObject(pchan))
    {
	//- set result

	pgenResult = &pchan->dechan.genObject;
    }

    //- return result

    return(pgenResult);
}


/// **************************************************************************
///
/// SHORT: ChannelGetIncomingVirtual()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: struct symtab_HSolveListElement * : 
///
///	incoming attachment, NULL if none, -1 for failure
///
/// DESCR: get channel incoming attachment.
///
/// **************************************************************************

static int 
ChannelIncomingVirtualChecker
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if attachment

    if (instanceof_attachment(phsle))
    {
	//- if incoming attachment

	if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
	{
	    //- set result : ok

	    *(struct symtab_HSolveListElement **)pvUserdata = phsle;

	    //- set result : abort traversal

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }

    //- return result

    return(iResult);
}

struct symtab_HSolveListElement *
ChannelGetIncomingVirtual
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : NULL

    struct symtab_HSolveListElement *phsleResult = NULL;

    //v result from traversal

    int iTraversal;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   NULL,
	   NULL,
	   ChannelIncomingVirtualChecker,
	   (void *)&phsleResult,
	   NULL,
	   NULL);

    //- traverse channel children, check for equation

    iTraversal = TstrGo(ptstr,&pchan->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if failure

    if (iTraversal == 0)
    {
	//- set result : failure

	phsleResult = (struct symtab_HSolveListElement *)-1;
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ChannelHasEquation()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: int : TRUE if channel contains an equation.
///
/// DESCR: Check if channel contains an equation.
///
/// **************************************************************************

int ChannelHasEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- check for equation and return if found

    return(ChannelGetEquation(pchan,ppist) != NULL);
}


/// **************************************************************************
///
/// SHORT: ChannelHasMGBlockedGMAX()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: int : TRUE if channel MG block dependent
///
/// DESCR: Check if channel conductance is blocked by magnesium.
///
/// **************************************************************************

int
ChannelHasMGBlockGMAX
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if GMAX present

    struct symtab_Parameters *pparGMAX
	= SymbolFindParameter(&(pchan->bio.ioh.iol.hsle), "G_MAX", ppist);

    if (pparGMAX)
    {
	//- if GMAX is function

	if (ParameterIsFunction(pparGMAX))
	{
	    //- get function

	    struct symtab_Function *pfunGMAX
		= ParameterGetFunction(pparGMAX);

	    //- if function name is MGBLOCK

	    if (strcmp(FunctionGetName(pfunGMAX), "MGBLOCK") == 0)
	    {
		//- set result : ok

		bResult = TRUE;
	    }
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ChannelHasNernstErev()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: int : TRUE if channel has nernst
///
/// DESCR: Check if channel Erev nernst-equation controlled
///
/// **************************************************************************

int ChannelHasNernstErev
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if Erev present

    struct symtab_Parameters *pparErev
	= SymbolFindParameter(&(pchan->bio.ioh.iol.hsle), "Erev", ppist);

    if (pparErev)
    {
	//- if Erev is function

	if (ParameterIsFunction(pparErev))
	{
	    //- get function

	    struct symtab_Function *pfunErev
		= ParameterGetFunction(pparErev);

	    //- if function name is NERNST

	    if (strcmp(FunctionGetName(pfunErev), "NERNST") == 0)
	    {
		//- set result : ok

		bResult = TRUE;
	    }
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ChannelInit()
///
/// ARGS.:
///
///	pchan.: channel to init
///
/// RTN..: void
///
/// DESCR: init channel
///
/// **************************************************************************

void ChannelInit(struct symtab_Channel *pchan)
{
    //- initialize base symbol

    BioComponentInit(&pchan->bio);

/*     //- initialize channel specific lists */

/*     HSolveListInit(&pchan->dechan.hslEquations); */

/*     HSolveListInit(&pchan->dechan.hslVirtuals); */

    //- set type

    pchan->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_channel;
}


/// **************************************************************************
///
/// SHORT: ChannelParameterScaleValue()
///
/// ARGS.:
///
///	pchan...: channel to scale value for
///	ppist...: context of given element
///	dValue..: value to scale
///	ppar....: parameter that specify type of scaling
///
/// RTN..: double : scaled value, FLT_MAX for failure
///
/// DESCR: Scale value according to parameter type and symbol type
///
/// **************************************************************************

double
ChannelParameterScaleValue
(struct symtab_Channel *pchan,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = FLT_MAX;

    //- get channel parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if conductance

    if (0 == strcmp(pcName,"G_MAX"))
    {
	//v parent segment

	struct symtab_HSolveListElement *phsle = NULL;

	//- copy context stack

	struct PidinStack *ppistComp = PidinStackDuplicate(ppist);

	//- loop

	do
	{
	    //- pop element

	    PidinStackPop(ppistComp);

	    //- get top symbol

	    phsle = PidinStackLookupTopSymbol(ppistComp);

	    //t this is a realy hack, to solve need to revisit all of
	    //t pidinstack and make it more consistent with:
	    //t
	    //t root symbols
	    //t rooted pidinstacks
	    //t namespaces
	    //t namespaced pidinstacks
	    //t
	    //t see also pool.c for a comparable hack.
	    //t

	    if (instanceof_root_symbol(phsle))
	    {
		phsle = NULL;
	    }
	}

	//- while not segment and more symbols to pop

	while (phsle && !instanceof_segment(phsle) && PidinStackTop(ppistComp));

	//- if found segment

	if (phsle && instanceof_segment(phsle))
	{
	    //v surface

	    double dSurface;

	    //- get segment diameter

	    double dDia
		= SymbolParameterResolveValue(phsle,"DIA",ppistComp);

	    //- if spherical

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsle))
	    {
		//- calculate surface

		dSurface = dDia * dDia * M_PI;
	    }

	    //- else

	    else
	    {
		//- get segment length

		double dLength
		    = SymbolParameterResolveValue(phsle,"LENGTH",ppistComp);

		//- calculate surface

		dSurface = dDia * dLength * M_PI;
	    }

	    //- scale conductance to surface of segment

	    dResult = dValue * dSurface;
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: ChannelReceivesSpikes()
///
/// ARGS.:
///
///	pchan.: channel to check
///	ppist.: context of channel
///
/// RTN..: int : TRUE if receives spikes
///
/// DESCR: Check if channel receives spikes
///
/// **************************************************************************

int ChannelReceivesSpikes
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- check for incoming attachment and return if found

    return(ChannelGetIncomingVirtual(pchan,ppist) != NULL);
}


/// **************************************************************************
///
/// SHORT: ChannelSetTableParameters()
///
/// ARGS.:
///
///	pchan......: channel to set table parameters for
///	pcFilename.: filename of table to read
///
/// RTN..: int : success of operation
///
/// DESCR: Initialize tabulated channel.
///
///	Call ChannelSetup() after all bindable I/O relations have been 
///	assigned.
///
/// **************************************************************************

int
ChannelSetTableParameters
(struct symtab_Channel *pchan,struct ParserContext *pac,char *pcFilename)
{
    //- set default result : ok

    int bResult = TRUE;

    //- qualify filename

    pcFilename = ParserContextQualifyToParsingDirectory(pac,pcFilename);

    //- init channel

    pchan->dechan.iType = TYPE_CHANNEL_TABLEFILE;
    pchan->dechan.pcFilename = pcFilename;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ChannelSetup()
///
/// ARGS.:
///
///	pchan......: channel to setup
///
/// RTN..: int : success of operation
///
/// DESCR: Setup tabulated channel
///
///	Reads tables according to bindable I/O relations
///	Sets power parameters and indices in genesis structure.
///
/// NOTE.: needs HH parameters, these have to be hardcoded.
///
/// **************************************************************************

int ChannelSetup(struct symtab_Channel *pchan,struct ParserContext *pac)
{
    //- set default result : ok

    int bResult = TRUE;

    int ttype = -1;

    //- if tabulated channel

    if (pchan->dechan.iType == TYPE_CHANNEL_TABLEFILE)
    {
	//- allocate & read channel data

	ChannelTable_READ(pchan,pchan->dechan.pcFilename);
    }

    ttype = pchan->dechan.genObject.iType;

    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
    {
	struct neurospaces_tab_channel_type *chan1
	    = pchan->dechan.genObject.uElement.tabchan;

	struct symtab_Parameters *ppar = NULL;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Xpower",NULL);
	chan1->Xpower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Ypower",NULL);
	chan1->Ypower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Zpower",NULL);
	chan1->Zpower = ppar ? ParameterValue(ppar) : 0.0 ;

	//! not used at the moment

	chan1->instant = 0;

	break;
    }
    case CHANNEL_TYPE_DOUBLE_TABLE:
    {
	struct neurospaces_tab2channel_type *chan2
	    = pchan->dechan.genObject.uElement.tab2chan;

	struct symtab_Parameters *ppar = NULL;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Xpower",NULL);
	chan2->Xpower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Ypower",NULL);
	chan2->Ypower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Zpower",NULL);
	chan2->Zpower = ppar ? ParameterValue(ppar) : 0.0 ;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Xindex",NULL);
	chan2->Xindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Yindex",NULL);
	chan2->Yindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle),"Zindex",NULL);
	chan2->Zindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );

	//! not used at the moment

	chan2->instant = 0;

	break;
    }
    case CHANNEL_TYPE_CURRENT:
    {
	struct neurospaces_tab_current_type *curr
	    = pchan->dechan.genObject.uElement.tabcurr;

	struct symtab_Parameters *ppar = NULL;

	fprintf(stderr,"tabulated current not implemented\n");

	break;
    }
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ChannelTable_READ()
///
/// ARGS.:
///
///	pchan......: channel to print symbols for
///	pcFilename.: filename of table to read
///
/// RTN..: int : success of operation
///
/// DESCR: Initialize tabulated channel
///
/// **************************************************************************

static int
ChannelTable_dims
(struct descr_genesis_object  *genObject,
 int *itype,
 int *ntype);

static int
ChannelTable_ptrs
(struct descr_genesis_object  *genObject,
 int i,
 int bConcen,
 struct neurospaces_interpol_struct	**ipolA,
 struct neurospaces_interpol_struct	**ipolB,
 struct neurospaces_interpol2d_struct	**ipol2A,
 struct neurospaces_interpol2d_struct	**ipol2B);

static int
GenObjectSetup
(struct descr_genesis_object  *genObject);

static int
Interpol1DAllocateTable
(struct neurospaces_interpol_struct *ipol,
 int xdivs);

static int
Interpol2DAllocateTable
(struct neurospaces_interpol2d_struct *ipol,
 int xdivs,
 int ydivs);

static int tabiread(FILE *fp,int doflip);

static double tabfread(FILE *fp,int doflip);

static int ChannelTable_READ(struct symtab_Channel *pchan,char *pcFilename)
{
    int	i,j,k,n=0,ttype,itype,ntype,doflip;
    int	dsize,isize;
    char	version;
    FILE	*fp = NULL;
    struct neurospaces_tab_channel_type	*chan1;
    struct neurospaces_tab2channel_type	*chan2;
    struct neurospaces_tab_current_type	*curr;
    struct neurospaces_interpol_struct *ipolA,*ipolB;
    struct neurospaces_interpol2d_struct *ipol2A,*ipol2B;
    double	v,*A,*B;
    int	tabiread();
    double	tabfread();

    int bConcen = FALSE;

    dsize=sizeof(double);
    isize=sizeof(int);

    //- remember if channel has concen input

    bConcen = SymbolHasBindableIO(&pchan->bio.ioh.iol.hsle,"concen",0);

    /* open the file */
    if (!(fp = fopen(pcFilename,"r"))) {
	//Error();
	printf(" can't open file '%s'\n",pcFilename);
	return(FALSE);
    }
    /* read header: in versions 1-3 this was an integer, now it is a byte */
    for (i=0; i<4; i++) {
	fread(&version,1,1,fp);
	if (version>0) break;
    }
    if ((version<1)||((version==2)&&(ttype==CHANNEL_TYPE_CURRENT))||(version>4)) {
	//Error();
	printf(" can't read file '%s': wrong version #%d\n",pcFilename,version);
	fclose(fp);
	return(FALSE);
    }
    if (version>=4) {
	/* test for binary type */
	fread(&v,dsize,1,fp);
	doflip=(v!=4.0);
    } else {
	doflip=0;
    }

    //- read type of channel

    i = tabiread(fp,doflip);

    pchan->dechan.genObject.iType = i;

    ttype = i;
    if (i!=ttype) {
	//Error();
	printf(" can't read file '%s': wrong object type (%d)\n",pcFilename,i);
	fclose(fp);
	return(FALSE);
    }

    //- initialize genesis interface object

    GenObjectSetup(&pchan->dechan.genObject);

    //- read number of gates in file

    i = tabiread(fp,doflip);

    n = i;
    if (i!=n) {
	//Error();
	printf(" can't read file '%s': wrong number of tables (%d)\n",pcFilename,i);
	fclose(fp);
	return(FALSE);
    }

    //- loop through all the gates

    for (i = 0 ; i < n ; i++)
    {
	//- get dimensions of tables according to element type

	ChannelTable_dims(&pchan->dechan.genObject,&itype,&ntype);

	//- read dimension for current table

	k = tabiread(fp,doflip);

	//itype = k;

	if (k!=itype) {
	    //Error();
	    printf("can't read file '%s': wrong dimension of table (%d: %d)\n",pcFilename,itype,k);
	    fclose(fp);
	    return(FALSE);
	}

	//- read type of table, no clue what this is about

	k = tabiread(fp,doflip);

	//ntype = 2;

	if (k!=ntype) {
	    //Error();
	    printf("can't read file '%s': wrong type of table (%d: %d)\n",pcFilename,ntype,k);
	    fclose(fp);
	    return(FALSE);
	}

	//- get pointers to rate tables which should be read

	ChannelTable_ptrs(&pchan->dechan.genObject,i,bConcen,&ipolA,&ipolB,&ipol2A,&ipol2B);

	//- if single dimension

	if (itype==1)
	{
	    //- read table sizes, calc number of entries in a table

	    k = tabiread(fp,doflip);

	    ipolA->xdivs = k;
	    ipolB->xdivs = k;

	    if ((k!=ipolA->xdivs) || 
		((ttype<CHANNEL_TYPE_CURRENT)&&(k!=ipolB->xdivs))) {
		//Error();
		printf("can't read file '%s': wrong xdivs for table (%d: %d)\n",pcFilename,k,ipolA->xdivs);
		fclose(fp);
		return(FALSE);
	    }

	    ipolA->xmin=tabfread(fp,doflip);
	    ipolA->xmax=tabfread(fp,doflip);
	    ipolA->dx=tabfread(fp,doflip);
	    ipolA->invdx=1.0/ipolA->dx;

	    //- allocate interpol tables

	    Interpol1DAllocateTable(ipolA,ipolA->xdivs);

	    if (ntype>1) {
		ipolB->xmin=ipolA->xmin;
		ipolB->xmax=ipolA->xmax;
		ipolB->dx=ipolA->dx;
		ipolB->invdx=1.0/ipolA->dx;

		Interpol1DAllocateTable(ipolB,ipolB->xdivs);
	    }

	    //- read the tables

	    A=ipolA->table;
	    if (ntype>1) B=ipolB->table;
	    k=ipolA->xdivs;
	    for (j=0; j<=k; j++) {
		*A++=tabfread(fp,doflip);
		if (ntype>1) *B++=tabfread(fp,doflip);
	    }
	}

	//- else (two dimensions)

	else
	{	/* itype==2 */
	    /* read table sizes */

	    //- read table sizes, calc number of entries in a table

	    k = tabiread(fp,doflip);

	    ipol2A->xdivs = k;
	    ipol2B->xdivs = k;

	    if ((k!=ipol2A->xdivs) || ((n>1)&&(k!=ipol2B->xdivs))) {
		//Error();
		printf(" can't read file '%s': wrong xdivs for table (%d: %d)\n",pcFilename,k,ipol2A->xdivs);
		fclose(fp);
		return(FALSE);
	    }
	    ipol2A->xmin=tabfread(fp,doflip);
	    ipol2A->xmax=tabfread(fp,doflip);
	    ipol2A->dx=tabfread(fp,doflip);
	    ipol2A->invdx=1.0/ipol2A->dx;

	    k = tabiread(fp,doflip);

	    ipol2A->ydivs = k;
	    ipol2B->ydivs = k;

	    if ((k!=ipol2A->ydivs) || ((ntype>1)&&(k!=ipol2B->ydivs))) {
		//Error();
		printf(" can't read file '%s': wrong ydivs for table (%d: %d)\n",pcFilename,k,ipol2A->ydivs);
		fclose(fp);
		return(FALSE);
	    }
	    ipol2A->ymin=tabfread(fp,doflip);
	    ipol2A->ymax=tabfread(fp,doflip);
	    ipol2A->dy=tabfread(fp,doflip);
	    ipol2A->invdy=1.0/ipol2A->dy;

	    //- allocate interpol tables

	    Interpol2DAllocateTable(ipol2A,ipol2A->xdivs,ipol2A->ydivs);

	    if (ntype>1) {
		ipol2B->xmin=ipol2A->xmin;
		ipol2B->xmax=ipol2A->xmax;
		ipol2B->dx=ipol2A->dx;
		ipol2B->invdx=1.0/ipol2A->dx;
		ipol2B->ymin=ipol2A->ymin;
		ipol2B->ymax=ipol2A->ymax;
		ipol2B->dy=ipol2A->dy;
		ipol2B->invdy=1.0/ipol2A->dy;

		Interpol2DAllocateTable(ipol2B,ipol2B->xdivs,ipol2B->ydivs);
	    }

	    //- read the tables

	    for (j=0; j<=ipol2A->xdivs; j++) {
		A=ipol2A->table[j];
		if (ntype>1) B=ipol2B->table[j];
		for (k=0; k<=ipol2A->ydivs; k++) {
		    *A++=tabfread(fp,doflip);
		    if (ntype>1) *B++=tabfread(fp,doflip);
		}
	    }
	}
    }

    fclose(fp);

    return(TRUE);
}


static int
ChannelTable_dims
(struct descr_genesis_object  *genObject,
 int *itype,
 int *ntype)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
	*itype=1;
	*ntype=2;
	break;

    case CHANNEL_TYPE_DOUBLE_TABLE:
	*itype=2;
	*ntype=2;
	break;

    case CHANNEL_TYPE_CURRENT:
	*itype=2;
	*ntype=2;
	break;
    }

    return(0);
}

static int
ChannelTable_ptrs
(struct descr_genesis_object  *genObject,
 int i,
 int bConcen,
 struct neurospaces_interpol_struct	**ipolA,
 struct neurospaces_interpol_struct	**ipolB,
 struct neurospaces_interpol2d_struct	**ipol2A,
 struct neurospaces_interpol2d_struct	**ipol2B)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
    {
	struct neurospaces_interpol_struct	**ppipolA = NULL;
	struct neurospaces_interpol_struct	**ppipolB = NULL;

	struct neurospaces_tab_channel_type	*chan1 = genObject->uElement.tabchan;

	short int *pbAllocated = NULL;

	if (/* chan1->X_alloced &&  */(i==0)) {
	    ppipolA = &chan1->X_A;
	    ppipolB = &chan1->X_B;
	    pbAllocated = &chan1->X_alloced;
	} else if (/* chan1->Y_alloced &&  */(!bConcen) && ((i==0)||(i==1))) {
	    ppipolA = &chan1->Y_A;
	    ppipolB = &chan1->Y_B;
	    pbAllocated = &chan1->Y_alloced;
	} else if (bConcen/* chan1->Z_alloced */) {
	    ppipolA = &chan1->Z_A;
	    ppipolB = &chan1->Z_B;
	    pbAllocated = &chan1->Z_alloced;
	}

	//! could do sanity check here on pbAllocated

	if (!(*ppipolA))
	{
	    *ppipolA
		= (struct neurospaces_interpol_struct *)
		  calloc(1,sizeof(struct neurospaces_interpol_struct));
	}
	if (!(*ppipolB))
	{
	    *ppipolB
		= (struct neurospaces_interpol_struct *)
		  calloc(1,sizeof(struct neurospaces_interpol_struct));
	}

	//- remember allocation has been done

	*pbAllocated = TRUE;

	//- set result pointers

	*ipolA = *ppipolA;
	*ipolB = *ppipolB;

	break;
    }
    case CHANNEL_TYPE_DOUBLE_TABLE:
    {
	struct neurospaces_interpol2d_struct	**ppipol2A = NULL;
	struct neurospaces_interpol2d_struct	**ppipol2B = NULL;

	struct neurospaces_tab2channel_type	*chan2 = genObject->uElement.tab2chan;

	short int *pbAllocated = NULL;

	if (/* chan2->X_alloced &&  */(i==0)) {
	    ppipol2A = &chan2->X_A;
	    ppipol2B = &chan2->X_B;
	    pbAllocated = &chan2->X_alloced;
	} else if (/* chan2->Y_alloced &&  */(!bConcen) && (i<2)) {
	    ppipol2A = &chan2->Y_A;
	    ppipol2B = &chan2->Y_B;
	    pbAllocated = &chan2->Y_alloced;
	} else if (bConcen/* chan2->Z_alloced */) {
	    ppipol2A = &chan2->Z_A;
	    ppipol2B = &chan2->Z_B;
	    pbAllocated = &chan2->Z_alloced;
	}

	//! could do sanity check here on pbAllocated

	if (!(*ppipol2A))
	{
	    *ppipol2A
		= (struct neurospaces_interpol2d_struct *)
		  calloc(1,sizeof(struct neurospaces_interpol2d_struct));
	}
	if (!(*ppipol2B))
	{
	    *ppipol2B
		= (struct neurospaces_interpol2d_struct *)
		  calloc(1,sizeof(struct neurospaces_interpol2d_struct));
	}

	//- remember allocation has been done

	*pbAllocated = TRUE;

	//- set result pointers

	*ipol2A = *ppipol2A;
	*ipol2B = *ppipol2B;

	break;
    }
    case CHANNEL_TYPE_CURRENT:
    {
	struct neurospaces_tab_current_type	*curr = genObject->uElement.tabcurr;

	if (i==0) {
	    *ipol2A=curr->G_tab;
	    *ipol2B=curr->I_tab;
	}
	break;
    }
    }

    return(0);
}

static int
GenObjectSetup
(struct descr_genesis_object  *genObject)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
	genObject->uElement.tabchan
	    = (struct neurospaces_tab_channel_type *)
	      calloc(1,sizeof(struct neurospaces_tab_channel_type));
	break;

    case CHANNEL_TYPE_DOUBLE_TABLE:
	genObject->uElement.tab2chan
	    = (struct neurospaces_tab2channel_type *)
	      calloc(1,sizeof(struct neurospaces_tab2channel_type));
	break;

    case CHANNEL_TYPE_CURRENT:
	genObject->uElement.tabcurr
	    = (struct neurospaces_tab_current_type *)
	      calloc(1,sizeof(struct neurospaces_tab_current_type));
	break;
    }

    return(0);
}

static int
Interpol1DAllocateTable
(struct neurospaces_interpol_struct *ipol,
 int xdivs)
{
    ipol->table = (double *)calloc(xdivs + 1,sizeof(double));

    ipol->allocated = 1;

    return(0);
}

static int
Interpol2DAllocateTable
(struct neurospaces_interpol2d_struct *ipol2,
 int xdivs,
 int ydivs)
{
    int i;

    ipol2->table = (double **)calloc(xdivs + 1,sizeof(double*));

    for (i = 0 ; i <= xdivs ; i++)
    {
	ipol2->table[i] = (double *)calloc(ydivs + 1,sizeof(double));
    }

    ipol2->allocated = 1;
}

/* reads integer value from file and flips it if needed */
static int tabiread(FILE *fp,int doflip)
{
int     n=sizeof(int);
int	val1,val2;
char  	*pval1,*pval2;

	if (doflip) {
	    fread(&(val1),n,1,fp);
	    pval1=(char *)(&(val1))+n-1;
	    pval2=(char *)(&(val2));
	    for (;n>0;n--) *pval2++=*pval1--;
	} else {
	    fread(&(val2),n,1,fp);
	}
	return(val2);
}

/* reads double value from file and flips it if needed */
static double tabfread(FILE *fp,int doflip)
{
int     n=sizeof(double);
double	val1,val2;
char  	*pval1,*pval2;

	if (doflip) {
	    fread(&(val1),n,1,fp);
	    pval1=(char *)(&(val1))+n-1;
	    pval2=(char *)(&(val2));
	    for (;n>0;n--) *pval2++=*pval1--;
	} else {
	    fread(&(val2),n,1,fp);
	}
	return(val2);
}

