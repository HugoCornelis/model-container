//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parsersupport.c 1.87 Thu, 15 Nov 2007 13:04:36 -0600 hugo $
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


#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/defsym.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/lexsupport.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/algorithmset.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


/// current parser context

static PARSERCONTEXT *pacCurrentContext = NULL;


/// root parser context

static PARSERCONTEXT *pacRootContext = NULL;


/// index to data

static int iParserContextData = -1;

/// void data

static void **ppvParserContextData = NULL;

/// \def default size of parser context void data stack

#define SIZE_PARSERCONTEXTSTACK	100


/// index to container data

static int iParserContainerData = -1;

/// container element

static struct symtab_Vector **ppvectParserContainerData = NULL;

#define SIZE_PARSERCONTAINERSTACK	100


/// index to algorithm data

static int iParserAlgorithmData = -1;

/// algorithm data

static void **ppvParserAlgorithmData = NULL;

#define SIZE_PARSERALGORITHMSTACK	100



static void ParserChangeContext(PARSERCONTEXT *pac);

static int
ParserContextPrepare
(PARSERCONTEXT *pac, struct symtab_HSolveListElement *phsle);

static int ParserContextRepair(PARSERCONTEXT *pac);


/// 
/// \arg pacContext parser context
/// \arg phsle symbol table element
/// 
/// \return int : success of operation
/// 
/// \brief Add symbol to private or public model list.
///
/// \details 
/// 
///	Depending on parser state, a call is made ParserAddPrivateModel()
///	or ParserAddPublicModel().
/// 

int ParserAddModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = 1;

    //- get parser state

    int iState = ParserContextGetState(pacContext);

    //- if parsing private models

    if (iState == PARSER_STATE_PRIVATEMODELS)
    {
	//- add private model

	bResult = ParserAddPrivateModel(pacContext, phsle);
    }

    //- else if parsing private models

    else if (iState == PARSER_STATE_PUBLICMODELS)
    {
	//- add public model

	bResult = ParserAddPublicModel(pacContext, phsle);
    }

    //- else

    else
    {
	//- register error

	NeurospacesError
	    (pacContext, "ParserAddModel()", "Called in wrong parser state");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pacContext parser context
/// \arg phsle symbol table element
/// 
/// \return int : success of operation
/// 
/// \brief Add symbol to current private model list
/// 

/* static */
int ParserAddPrivateModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = 1;

    //- get pointer to currently parsed file

    struct ImportedFile *pif = ParserContextGetImportedFile(pacContext);

    //- get pointer to defined symbols in that file

    struct DefinedSymbols *pdefsym = ImportedFileGetDefinedSymbols(pif);

/*     //- set flag : is public model */

/*     SymbolSetFlags(phsle, FLAGS_HSLE_PRIVATE); */

    //- add symbol as private model

    bResult = DefSymAddPrivateModel(pdefsym, phsle);

    //- look at type of symbol

    switch (phsle->iType)
    {
    //- otherwise

    default:
    {
	//- give diagnostics : add of symbol

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_SYMBOLADD,
	     "ParserAddPrivateModel()",
	     "Add Private Model(%s,%s)",
	     SymbolHSLETypeDescribe(phsle->iType),
	     SymbolName(phsle));

	break;
    }
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pacContext parser context, may be NULL
/// \arg phsle symbol table element
/// 
/// \return int : success of operation
/// 
/// \brief Add symbol to current public model list
///
/// \details 
/// 
///	Generates events for TYPE_HSLE_D3SEGMENT, TYPE_HSLE_CELL
/// 
///	If no parser context is given, it defaults to the current context.
/// 

/* static */
int ParserAddPublicModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = 1;

    /// currently parsed file

    struct ImportedFile *pif = NULL;

    /// currently defined symbols

    struct DefinedSymbols *pdefsym = NULL;

    //- if no parser context given

    if (!pacContext)
    {
	//- set to current context

	pacContext = pacCurrentContext;
    }

/*     //- set flag : is public model */

/*     SymbolSetFlags(phsle, FLAGS_HSLE_PUBLIC); */

    //- don't look at symbol type

    if (0)

    switch (phsle->iType)
    {

    //- for single segment

    case HIERARCHY_TYPE_symbols_segment:
    {
	//- generate events for segment

	ParserEventGenerate
	    (EVENT_TYPE_SEGMENT | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a cell

    case HIERARCHY_TYPE_symbols_cell:
    {
	//- generate events for cell

	ParserEventGenerate
	    (EVENT_TYPE_CELL | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a population

    case HIERARCHY_TYPE_symbols_population:
    {
	//- generate events for population

	ParserEventGenerate
	    (EVENT_TYPE_POPULATION | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a connection

    case HIERARCHY_TYPE_symbols_connection:
    {
	//- generate events for connection

	ParserEventGenerate
	    (EVENT_TYPE_CONNECTION | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a projection

    case HIERARCHY_TYPE_symbols_projection:
    {
	//- generate events for projection

	ParserEventGenerate
	    (EVENT_TYPE_PROJECTION | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a network

    case HIERARCHY_TYPE_symbols_network:
    {
	//- generate events for network

	ParserEventGenerate
	    (EVENT_TYPE_NETWORK | EVENT_ACTION_CREATE,
	     phsle,
	     &pacContext->pist);

	break;
    }

    }

    //- get pointer to currently parsed file

    pif = ParserContextGetImportedFile(pacContext);

    //- get pointer to defined symbols in that file

    pdefsym = ImportedFileGetDefinedSymbols(pif);

    //- add symbol as public model

    bResult = DefSymAddPublicModel(pdefsym, phsle);

    //- don't look at symbol type

    if (0)

    switch (phsle->iType)
    {

    //- for single segment

    case HIERARCHY_TYPE_symbols_segment:
    {
	//- generate events for segment

	ParserEventGenerate
	    (EVENT_TYPE_SEGMENT | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a cell

    case HIERARCHY_TYPE_symbols_cell:
    {
	//- generate events for cell

	ParserEventGenerate
	    (EVENT_TYPE_CELL | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a population

    case HIERARCHY_TYPE_symbols_population:
    {
	//- generate events for population

	ParserEventGenerate
	    (EVENT_TYPE_POPULATION | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a connection

    case HIERARCHY_TYPE_symbols_connection:
    {
	//- generate events for connection

	ParserEventGenerate
	    (EVENT_TYPE_CONNECTION | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a projection

    case HIERARCHY_TYPE_symbols_projection:
    {
	//- generate events for projection

	ParserEventGenerate
	    (EVENT_TYPE_PROJECTION | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    //- for a network

    case HIERARCHY_TYPE_symbols_network:
    {
	//- generate events for network

	ParserEventGenerate
	    (EVENT_TYPE_NETWORK | EVENT_ACTION_ADD,
	     phsle,
	     &pacContext->pist);

	break;
    }

    }

    //- look at type of symbol

    switch (phsle->iType)
    {
    //- otherwise

    default:
    {
	//- give diagnostics : add of symbol

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_SYMBOLADD,
	     "ParserAddPublicModel()",
	     "Add Public Model(%s,%s)",
	     SymbolHSLETypeDescribe(phsle->iType),
	     SymbolName(phsle));

	break;
    }
    }

    //- return result

    return(bResult);
}


/// 
/// \return PARSERCONTEXT * : allocated parser context, NULL for failure
/// 
/// \brief Allocate new parser context
/// 

PARSERCONTEXT *ParserContextCalloc(void)
{
    //- set default result : failure

    PARSERCONTEXT *pacResult = NULL;

    //- allocate parser context

    pacResult = (PARSERCONTEXT *)calloc(1, sizeof(PARSERCONTEXT));

    //- initialize parser context

    ParserContextInit(pacResult);

    //- return result

    return(pacResult);
}


/// 
/// \return void
/// 
/// \brief Clear parser context
/// 

void ParserClearContext(void)
{
    //- sanity test current context

    if (!pacCurrentContext)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     3, //pacCurrentContext->pcParser,
	     "Warning : Erasing erased parser context\n",
	     NULL);
    }

    //- set parser context

    pacCurrentContext = NULL;
}


/// 
/// \return void
/// 
/// \brief Clear root parser context
/// 

void ParserClearRootContext(void)
{
    //- sanity test current root context

    if (!pacRootContext)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     3, //pacCurrentContext->pcParser,
	     "Warning : Erasing erased root parser context\n",
	     NULL);
    }

    //- clear root context

    pacRootContext = NULL;

    //- clear root imported file

    ImportedFileClearRootImport();
}


/// 
/// \arg pac new parser context
/// 
/// \return void
/// 
/// \brief Set new parser context
/// 

static void ParserChangeContext(PARSERCONTEXT *pac)
{
    //- set parser context

    pacCurrentContext = pac;
}


/// 
/// \return symtab_Vector *  : popped container element
/// 
/// \brief Pop container element
/// 

struct symtab_Vector * ParserContextActualContainer(void)
{
    //- set default result : from array

    struct symtab_Vector * pvectResult
	= ppvectParserContainerData[iParserContainerData];

    //- return result

    return(pvectResult);
}


/// 
/// \return void * : popped data
/// 
/// \brief Pop data
/// 

void * ParserContextActualState(void)
{
    //- set default result : failure

    void *pvResult = NULL;

    //- set result : last pushed data

    pvResult = ppvParserContextData[iParserContextData];

    //- return result

    return(pvResult);
}


/// 
/// \arg pac parser context
/// 
/// \return struct symtab_HSolveListElement * : actually defined symbol
/// 
/// \brief Get symbol being defined
/// 

struct symtab_HSolveListElement *ParserContextGetActual(PARSERCONTEXT *pac)
{
    //- set result : from context

    struct symtab_HSolveListElement *phsleResult = pac->phsleActual;

    //- return result

    return(phsleResult);
}


/// 
/// \arg pac parser context to initialize
/// 
/// \return void
/// 
/// \brief Initialize parser context
/// 

void ParserContextInit(PARSERCONTEXT *pac)
{
    //- zero out parser context

    memset(pac, 0, sizeof(*pac));

    //- erase stack

    PidinStackInit(&pac->pist);

    //- register stack as rooted

    PidinStackSetRooted(&pac->pist);
}


/// 
/// \return symtab_Vector *  : popped container element
/// 
/// \brief Pop container element
/// 

struct symtab_Vector * ParserContextPopContainer(void)
{
    //- set default result : failure

    struct symtab_Vector * pvectResult = NULL;

    //- set result : pop last pushed data

    pvectResult = ppvectParserContainerData[iParserContainerData];

    //- decrement index to data

    iParserContainerData--;

    //- return result

    return(pvectResult);
}


/// 
/// \return void *  : popped algorithm state
/// 
/// \brief Pop algorithm state
/// 

void * ParserContextPopAlgorithmState(void)
{
    //- set default result : failure

    void * pvResult = NULL;

    //- set result : pop last pushed data

    pvResult = ppvParserAlgorithmData[iParserAlgorithmData];

    //- decrement index to data

    iParserAlgorithmData--;

    //- return result

    return(pvResult);
}


/// 
/// \return void * : popped data
/// 
/// \brief Pop data
/// 

void * ParserContextPopState(void)
{
    //- set default result : failure

    void *pvResult = NULL;

    //- set result : pop last pushed data

    pvResult = ppvParserContextData[iParserContextData];

    //- decrement index to data

    iParserContextData--;

    //- return result

    return(pvResult);
}


/// 
/// \arg pvect (generic) container element
/// 
/// \return int : success of operation
/// 
/// \brief Push container element
/// 

int ParserContextPushContainer(struct symtab_Vector * pvect)
{
    //- set default result

    int bResult = TRUE;

    //- allocate parser stack if necessary

    if (!ppvectParserContainerData)
    {
	ppvectParserContainerData
	    = (struct symtab_Vector **)
	      calloc
	      (SIZE_PARSERCONTAINERSTACK,
	       sizeof(struct symtab_Vector * ));
    }

    //- increment index to data

    iParserContainerData++;

    //- register void data

    ppvectParserContainerData[iParserContainerData] = pvect;

    //- return result

    return(bResult);
}


/// 
/// \arg pv algorithm state info
/// 
/// \return int : success of operation
/// 
/// \brief Push algorithm state
/// 

int ParserContextPushAlgorithmState(void *pv)
{
    //- set default result

    int bResult = TRUE;

    //- allocate parser stack if necessary

    if (!ppvParserAlgorithmData)
    {
	ppvParserAlgorithmData
	    = (void **)calloc(SIZE_PARSERALGORITHMSTACK, sizeof(void *));
    }

    //- increment index to data

    iParserAlgorithmData++;

    //- register void data

    ppvParserAlgorithmData[iParserAlgorithmData] = pv;

    //- return result

    return(bResult);
}


/// 
/// \arg pv date to push
/// 
/// \return void
/// 
/// \brief Push data
/// 

int ParserContextPushState(void *pv)
{
    //- set default result

    int bResult = TRUE;

    //- allocate parser stack if necessary

    if (!ppvParserContextData)
    {
	ppvParserContextData
	    = (void **)calloc(SIZE_PARSERCONTEXTSTACK, sizeof(void *));
    }

    //- increment index to data

    iParserContextData++;

    //- register void data

    ppvParserContextData[iParserContextData] = pv;

    //- return result

    return(bResult);
}


/// 
/// \arg pac parser context to use for qualification, may be NULL
/// \arg pc filename to qualify
/// 
/// \return char * : qualified filename, NULL for failure
/// 
/// \brief qualify a filename suitable for import functions
///
/// \details 
/// 
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for directories and environment.
///	if no parser context is given, qualification with directories of
///	previous parsed files will not be done.
/// 

char *ParserContextQualifyFilename(PARSERCONTEXT *pac, char *pc)
{
    //- set default result

    char *pcResult = NULL;

    //- if no parser context given, we try to use the current context

    if (!pac)
    {
	pac = pacCurrentContext;
    }

    //- try qualify to current working directory

    if (pac)
    {
	pcResult
	    = ParserContextQualifyToParsingDirectory(pac, pc);
    }

    //- try to qualify to current parser context (configuration)

    if (!pcResult)
    {
	pcResult
	    = ParserContextQualifyToConfiguration(pac, pc);
    }

    //- otherwise

    if (!pcResult)
    {
	//- try to qualify with environment

	pcResult = ParserContextQualifyToEnvironment(pc);
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg pac parser context to use for qualification
/// \arg pc filename to qualify
/// 
/// \return char * : qualified filename, NULL for failure
/// 
/// \brief qualify a filename using parser context configuration.
///
/// \details 
/// 
///	See NeurospacesQualifyToConfiguration().
/// 

char *ParserContextQualifyToConfiguration(PARSERCONTEXT *pac, char *pc)
{
    //- set result: forward to neurospaces

    char *pcResult = NeurospacesQualifyToConfiguration(pac->pneuro, pc);

    //- return result

    return(pcResult);
}


/// 
/// \arg pac parser context to use for qualification
/// \arg pc filename to qualify
/// 
/// \return char * : qualified filename, NULL for failure
/// 
/// \brief qualify a filename using parser contexts to get intended dir
///
/// \details 
/// 
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for directories, if file not found,
///	returns NULL.
/// 

char *ParserContextQualifyToParsingDirectory(PARSERCONTEXT *pac, char *pc)
{
    //- set default result

    char *pcResult = NULL;

    PARSERCONTEXT *pacLoop = NULL;

    int iDirectory = -1;

    //- calculate directory length from previous parser contexts

    iDirectory = 0;

    /// \note should not be dependent on root context ?

    /// \note root context can still be NULL here, meaning that 
    /// \note the given pac is the first import.
    /// \note We must not depend on this knowledge, but it is
    /// \note necessary to do a safety check.

    pacLoop = pacRootContext;

/*     pacLoop = pac; */

    while (pacLoop)
    {
	char *pcDirectory = ParserContextGetDirectory(pacLoop);

	if (pcDirectory)
	{
	    iDirectory += strlen(pcDirectory);
	}
/* 	pacLoop = pacLoop->pacPrev; */
	pacLoop = pacLoop->pacNext;
    }

    //- allocate result

    pcResult = (char *)calloc(sizeof(char), 1 + iDirectory + strlen(pc));

    if (pcResult)
    {
	pcResult[0] = '\0';

	//- loop over parser context from root to this

	/// \note should not be dependent on root context ?

	/// \note root context can still be NULL here, meaning that 
	/// \note the given pac is the first import.
	/// \note We must not depend on this knowledge, but it is
	/// \note necessary to do a safety check.

	pacLoop = pacRootContext;

	while (pacLoop)
	{
	    //- get directory

	    char *pcDirectory = ParserContextGetDirectory(pacLoop);

	    //- if rooted dir

	    if (pcDirectory[0] == '/')
	    {
		//- replace directory names

		strcpy(pcResult, pcDirectory);
	    }

	    //- else

	    else
	    {
		//- add directory names

		strcat(pcResult, pcDirectory);
	    }

	    //- next context

	    pacLoop = pacLoop->pacNext;
	}

	//- add filename

	strcat(pcResult, pc);
    }

    //- test existence of file

    {
	FILE *pf = fopen(pcResult, "r");

	if (!pf)
	{
	    free(pcResult);

	    pcResult = NULL;
	}
	else
	{
	    fclose(pf);
	}
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg pac parser context to use for qualification
/// \arg pc filename to qualify
/// 
/// \return char * : qualified filename, NULL for failure
/// 
/// \brief qualify a filename using current environment.
///
/// \details 
/// 
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for environment variables and
///	current directory (where application was started, 
///	if in all these cases file not found, returns NULL.
/// 

char *ParserContextQualifyToEnvironment(char *pc)
{
    //- set default result

    char *pcResult = NULL;

    //- loop over the known environment variables

    char *ppcLibraries[] =
	{
	    "NEUROSPACES_NMC_USER_MODELS",
	    "NEUROSPACES_NMC_PROJECT_MODELS",
	    "NEUROSPACES_NMC_SYSTEM_MODELS",
	    "NEUROSPACES_NMC_MODELS",
	    NULL,
	};

    int i;

    for (i = 0 ; ppcLibraries[i] ; i++)
    {
	//- get environment var

	char *pcModels = getenv(ppcLibraries[i]);

	//- if found

	if (pcModels)
	{
	    //- append filename

	    int i = strlen(pcModels);

	    if (pcModels[i - 1] == '/')
	    {
		pcResult = (char *)malloc(1 + i + strlen(pc));

		strcpy(pcResult, pcModels);

		strcat(pcResult, pc);
	    }
	    else
	    {
		pcResult = (char *)malloc(2 + i + strlen(pc));

		strcpy(pcResult, pcModels);

		pcResult[i] = '/';
		pcResult[i + 1] = '\0';

		strcat(pcResult, pc);
	    }

	    //- test existence of file

	    {
		FILE *pf = fopen(pcResult, "r");

		if (!pf)
		{
		    free(pcResult);

		    pcResult = NULL;
		}

		//- if exists

		else
		{
		    //- break loop

		    fclose(pf);

		    break;
		}
	    }
	}
    }

    //- last test : existence of given file in current directory

    if (!pcResult)
    {
	FILE *pf = fopen(pc, "r");

	if (pf)
	{
	    fclose(pf);

	    pcResult = (char *)malloc(1 + strlen(pc));
	    strcpy(pcResult, pc);
	}
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg pac parser context
/// \arg phsle symbol being defined
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	Previous actual symbol
/// 
/// \brief Set symbol being defined.
/// 

struct symtab_HSolveListElement *
ParserContextSetActual
(PARSERCONTEXT *pac, struct symtab_HSolveListElement *phsle)
{
    //- set result : previous symbol

    struct symtab_HSolveListElement *phsleResult
	= ParserContextGetActual(pac);

    //- overwrite actual

    pac->phsleActual = phsle;

    //- return result

    return(phsleResult);
}


/// 
/// \arg pac parser context
/// \arg pif imported file
/// 
/// \return void
/// 
/// \brief Set imported file attached to parser context
/// 

void ParserContextSetImportedFile(PARSERCONTEXT *pac, struct ImportedFile *pif)
{
    char *pcFilename = NULL;
    char *pcDirectory = NULL;

    int iFilename = -1;
    int iDirectory = -1;

    //- set imported file

    pac->pifInParse = pif;

    //- reset line number

    pac->iLineNumber = 1;

    //- get filename from imported file

    pcDirectory = ImportedFileGetQualified(pif);

    //- filename starts at end of directory part

    pcFilename = strrchr(pcDirectory, '/');

    //- if no directory part

    if (!pcFilename)
    {
	//- register : no directory part

	iDirectory = 0;

	pcFilename = pcDirectory;

	//- get length of filename

	iFilename = strlen(pcFilename);
    }

    //- else

    else
    {
	//- calculate lengths of two parts

	pcFilename++;

	iDirectory = pcFilename - pcDirectory;

	iFilename = strlen(pcFilename);
    }

    //- allocate and copy directory and filename

    pac->pcDirectory = (char *)malloc(1 + iDirectory);
    strncpy(pac->pcDirectory, pcDirectory, iDirectory);
    pac->pcDirectory[iDirectory] = '\0';

    pac->pcFilename = (char *)malloc(1 + iFilename);
    strcpy(pac->pcFilename, pcFilename);
}


/// 
/// \arg pac parser context
/// 
/// \return struct symtab_IdentifierIndex * :
/// 
///	name of popped element, NULL for failure
/// 
/// \brief Pop current element name
/// 

struct symtab_IdentifierIndex * 
ParserCurrentElementPop
(PARSERCONTEXT *pac)
{
    //- set result : pop from stack

    struct symtab_IdentifierIndex * pidinResult
	= PidinStackPop(&pac->pist);

    //- return result

    return(pidinResult);
}


/// 
/// \arg pac parser context
/// 
/// \return void
/// 
/// \brief Pop all current element names (empties element stack)
/// 
/// \note  See ParserContextPrepare() for more info on this function.
/// 

void ParserCurrentElementPopAll(PARSERCONTEXT *pac)
{
    //- init stack

    PidinStackInit(&pac->pist);
}


/// 
/// \arg pac parser context
/// \arg pidinName new current element name
/// 
/// \return int : success of operation
/// 
/// \brief Set new current element name.
/// 
/// \note  See ParserContextPrepare() for more info on this function.
/// 

int ParserCurrentElementPush
(PARSERCONTEXT *pac, struct symtab_IdentifierIndex *pidinName)
{
    //- set result : push onto stack

    int bResult = PidinStackPushAll(&pac->pist, pidinName);

    //- return result

    return(bResult);
}


/// 
/// \return void
/// 
/// \brief Finish parsing, clean up
/// 

void ParserFinish(void)
{
    //- if we are in root context

    if (pacRootContext == pacCurrentContext)
    {
/* 	//- generate finish event */

/* 	/// \note current context should contain root here */

/* 	ParserEventGenerate(EVENT_ACTION_FINISH, NULL, &pacCurrentContext->pist); */
    }
}


/// 
/// \arg pac parser context, NULL for default root context.
/// \arg pcQualified qualified filename of file to parse.
/// \arg pcRelative relative filename of file to parse.
/// \arg pcNameSpace name space for imported models
/// 
/// \return int : success of operation
/// 
/// \brief import file, parse if necessary
///
/// \details 
/// 
///	Import the given file, if it is not yet imported, parse it with the
///	given parse() function via a call to ParserParse().
///	Link the parsed file (newly parsed or cached) as a dependency file
///	for the file currently in parse.
///	pcNameSpace is the name space for the imported models, it is linked
///	into the structure of defined symbols. It must not be freed 
///	afterwards.
/// 

int
ParserImport
(PARSERCONTEXT *pac,
 char *pcQualified,
 char *pcRelative,
 char *pcNameSpace)
{
    //- set default result : failure

    int bResult = FALSE;

    //- apply defaults:

/*     //- root parser context if none give */

/*     if (!pac) */
/*     { */
/* 	pac = pacRootContext; */
/*     } */

    //- get pointer to symbol table

    struct Symbols *psym = pac->pneuro->psym;

    struct ImportedFile *pifToParse = NULL;

    //- give diagnostics

    ParserMessage
	(pac,
	 LEVEL_GLOBALMSG_FILEIMPORT,
	 "ParserImport()",
	 "->Dependency file(%s)",
	 pcQualified);

    //- try to lookup file in symbol table

    pifToParse = SymbolsLookupImportedFile(psym, pcQualified, pac);

    //- if not found

    if (!pifToParse)
    {
	/// \note I first add the file to the symbol table to avoid
	/// circular dependencies.

	//- if add file to symbol table

	bResult
	    = (pifToParse = SymbolsAddImportedFile(psym, pcQualified, pcRelative, pac))
	      != NULL;

	if (bResult)
	{
	    //- get pointer to imported file

	    struct ImportedFile *pif
		= ParserContextGetImportedFile(pac);

	    //- get pointer to defined symbols in that file

	    struct DefinedSymbols *pdefsym
		= ImportedFileGetDefinedSymbols(pif);

	    //- increment number of dependencies

	    DefSymIncrementDependencyFiles(pdefsym);

/* 	    //- register parse function */

/* 	    ImportedFileSetParseMethod(pifToParse, parse); */

	    //- parse file

	    bResult = ParserParse(pac, pifToParse);

	    //- if parse ok

	    if (bResult)
	    {
		//- allocate element for dependency files list

		struct DependencyFile *pdf
		    = DependencyFileCallocNameSpaceImportedFile
		      (pcNameSpace, pifToParse);

		//- queue element into dependency list

		//! respect ordering

		HSolveListEntail
		    (&pdefsym->hslDependencyFiles,
		     &pdf->hsleLink);
	    }
	}

	//- else

	else
	{
	    //- register error : unable to import given file

	    /// \note this is also an internal error

	    NeurospacesError
		(pac,
		 "ParserImport()",
		 "Could not import %s",
		 pcQualified);
	}
    }

    //- else

    else
    {
	struct DependencyFile *pdf = NULL;

	//- get pointer to imported file

	struct ImportedFile *pif
	    = ParserContextGetImportedFile(pac);

	//- get pointer to defined symbols in that file

	struct DefinedSymbols *pdefsym
	    = ImportedFileGetDefinedSymbols(pif);

	//- increment number of dependencies

	DefSymIncrementDependencyFiles(pdefsym);

	//- allocate element for dependency files list

	pdf
	    = DependencyFileCallocNameSpaceImportedFile
	      (pcNameSpace, pifToParse);

	//- queue element into dependency list

	HSolveListEnqueue
	    (&pdefsym->hslDependencyFiles,
	     &pdf->hsleLink);

	//- set result: ok

	bResult = TRUE;

	//- give diagnostics : cached symbols

	ParserMessage
	    ((PARSERCONTEXT *)pac,
	     LEVEL_GLOBALMSG_SYMBOLREPORT,
	     "ParserImport()",
	     "%s is cached"
	     "(public model list not yet)",
	     ImportedFileGetQualified(pifToParse));
    }

    //- give diagnostics

    ParserMessage
	((PARSERCONTEXT *)pac,
	 LEVEL_GLOBALMSG_FILEIMPORT,
	 "ParserImport()",
	 "->End(%s)",
	 pcQualified);

    //- return result

    return(bResult);
}


/// 
/// \arg pacContext parser context to search for symbol
/// \arg pidin namespaced hierarchical name to search for
/// 
/// \return struct symtab_HSolveListElement *
/// 
///	source of dependency, NULL if not found.
/// 
/// \brief lookup a dependency symbol
///
/// \details 
/// 
///	Gives pointer into another pif struct its public model symbols,
///	Structure returned is read-only.
///	This function is a wrapper around SymbolLookup().
/// 

struct symtab_HSolveListElement *
ParserLookupDependencyModel
(PARSERCONTEXT *pacContext, struct symtab_IdentifierIndex *pidin)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get pointer to currently parsed file

    struct ImportedFile *pif = ParserContextGetImportedFile(pacContext);

    //- get pointer to defined symbols in that file

    struct DefinedSymbols *pdefsym = ImportedFileGetDefinedSymbols(pif);

    //- look up symbol in dependency symbols

    phsleResult
	= DefSymLookup
	  (pdefsym,
	   IdinName(pidin),
	   IdinName(pidin->pidinNext),
	   FLAG_SYMBOL_DEPENDENCY);

    //- return result

    return(phsleResult);
}


/// 
/// \arg pcIdentifier name of private model to search
/// 
/// \return struct symtab_HSolveListElement * : 
/// 
///	private model, NULL for failure
/// 
/// \brief lookup a private model
///
/// \details 
/// 
///	Lookup a private in current active private models
/// 

struct symtab_HSolveListElement *ParserLookupPrivateModel(char *pcIdentifier)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get pointer to currently parsed file

    struct ImportedFile *pif
	= ParserContextGetImportedFile(pacCurrentContext);

    //- get pointer to defined symbols in that file

    struct DefinedSymbols *pdefsym
	= ImportedFileGetDefinedSymbols(pif);

    //- lookup private model in current context

    phsleResult
	= DefSymLookup(pdefsym, NULL, pcIdentifier, FLAG_SYMBOL_PRIVATEMODEL);

    //- return result

    return(phsleResult);
}


/// 
/// \arg pcIdentifier name of public model to search
/// 
/// \return struct symtab_HSolveListElement * : 
/// 
///	public model, NULL for failure
/// 
/// \brief lookup a public model
///
/// \details 
/// 
///	Lookup a public in current active public models
/// 

struct symtab_HSolveListElement *ParserLookupPublicModel(char *pcIdentifier)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get pointer to currently parsed file

    struct ImportedFile *pif
	= ParserContextGetImportedFile(pacCurrentContext);

    //- get pointer to defined symbols in that file

    struct DefinedSymbols *pdefsym
	= ImportedFileGetDefinedSymbols(pif);

    //- lookup private model in current context

    phsleResult
	= DefSymLookup(pdefsym, NULL, pcIdentifier, FLAG_SYMBOL_PUBLICMODEL);

    //- return result

    return(phsleResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ParserLookupSymbol() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	ppist.........: element context, may be NULL */
/* ///	pidin.........: idin describing symbol to lookup, may be NULL */
/* /// */
/* /// \return struct symtab_HSolveListElement * : symbol, NULL for failure */
/* /// */
/* /// \brief lookup a symbol */
/// \details 
/* /// */
/* ///	ppist gives current element context, if not given (NULL), the current */
/* ///	parser context is used as current element context. */
/* ///	If pidin is NULL, try lookup symbol pointed to by ppist. */
/* /// */
/* /// ************************************************************************** */

/* struct symtab_HSolveListElement * */
/* ParserLookupSymbol */
/* (struct PidinStack *ppist, struct symtab_IdentifierIndex *pidin) */
/* { */
/*     //- set default result : failure */

/*     struct symtab_HSolveListElement *phsleResult = NULL; */

/*     //- element to lookup */

/*     struct PidinStack pistToSearch; */

/*     //- current place in pidin stack to search : first entry */

/*     int iToSearch = 0; */

/*     //- if no element context */

/*     if (!ppist) */
/*     { */
/* 	//- take from current parser context */

/* 	ppist = &pacCurrentContext->pist; */
/*     } */

/*     //- if element context is rooted */

/*     if (PidinStackIsRooted(ppist)) */
/*     { */
/* 	//- copy to element to search */

/* 	pistToSearch = *ppist; */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- root the element to search with current parser context */

/* 	pistToSearch = pacCurrentContext->pist; */

/* 	//- append with element to search */

/* 	if (!PidinStackAppendCompact(&pistToSearch, ppist)) */
/* 	{ */
/* 	    return(NULL); */
/* 	} */
/*     } */

/*     //- if pidin given */

/*     if (pidin) */
/*     { */
/* 	//- push pidin */

/* 	if (!PidinStackPushCompactAll(&pistToSearch, pidin)) */
/* 	{ */
/* 	    return(NULL); */
/* 	} */
/*     } */

/*     //- get pointer to searched symbol */

/*     phsleResult */
/* 	= ImportedFileLookupHierarchical */
/* 	  (pacCurrentContext->pifInParse, */
/* 	   &pistToSearch, */
/* 	   0); */

/*     //- return result */

/*     return(phsleResult); */
/* } */


/// 
/// \arg pacContext parser context
/// \arg iPriority priority of given message
/// \arg pcContext descriptive string for parsing context (unused)
/// \arg pcMessage stdargs message to log
/// 
/// \return int :  0 : continue parsing, msg logged
///		  1 : continue parsing, no msg logged
///		 -1 : stop parsing
/// 
/// \brief log a message from any of the parsing functions
///
/// \details 
/// 
///	iPriority is compared with the verbosity option given on the command
///	line, if higher, the message is written to stdout.
/// 
///	Does some parsing logging, calls NeurospacesMessage()
/// 

int ParserMessage
(PARSERCONTEXT *pacContext,
 int iPriority,
 char *pcContext,
 char *pcMessage,
 ...)
{
    //- set default result : continue parsing

    int bResult = 0;

    /// tmp var

    char pc[100];

    /// stdargs list

    va_list vaList;

    int i;

    //- if no parser context given

    if (!pacContext)
    {
	//- parser context defaults to current context

	pacContext = pacCurrentContext;
    }

    /// \todo neurospaces should not be accessed here

    //- if exclusive priority on

    if (pacContext->pneuro->pnsc->nso.iFlags & NSOFLAG_EXCLUSIVEVERBOSE)
    {
	//- if priority level does not match clo verbosity level

	if (iPriority != pacContext->pneuro->pnsc->nso.iVerbosity)
	{
	    //- no logging, continue parsing

	    return(1);
	}
    }

    //- else (assuming normal options)

    else
    {
	//- if priority level lower than clo verbosity level

	if (iPriority < pacContext->pneuro->pnsc->nso.iVerbosity)
	{
	    //- no logging, continue parsing

	    return(1);
	}
    }

    //- get start of stdargs

    va_start(vaList, pcMessage);

    //- do indentation according to nesting level

    sprintf
	(pc,
	 "%i,%-12.12s,%i\t||",
	 pacContext->iNestingLevel - 1,
	 ParserContextGetFilename(pacContext),
	 ParserContextGetLineNumber(pacContext));

    NeurospacesMessage(iPriority, 1, pc, NULL);

    for (i = 0; i < pacContext->iNestingLevel; i++)
    {
	NeurospacesMessage(iPriority, 0, "  ", NULL);
    }

    //- give diagnostics

    NeurospacesMessage(iPriority, 0, pcMessage, vaList);

    NeurospacesMessage(iPriority, 2, "\n", NULL);

    //- end stdargs

    va_end(vaList);

    //- return result

    return(bResult);
}


/// 
/// \arg pacContext parser context
/// \arg palgi algorithm instance to disable.
/// \arg pcName name of algorithm to import
/// \arg pcInstance name of algorithm instance to create
/// 
/// \return int : success of operation
/// 
/// \brief disable a loadable algorithm
///
/// \details 
/// 
///	Does some parsing logging, calls AlgorithmDisable()
/// 

int ParserAlgorithmDisable
(PARSERCONTEXT *pacContext,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance)
{
    //- set default result : failure

    int bResult = FALSE;

    //- import algorithm

    bResult = AlgorithmInstanceDisable(palgi, pcName, pacContext) != FALSE;

    //- if success

    if (bResult)
    {
	//- give diagnostics : disable of algorithm

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	     "ParserAlgorithmDisable()",
	     "Disable Algorithm(%s)",
	     pcInstance);
    }

    //- else

    else
    {
	//- give diagnostics : failed disable of algorithm

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	     "ParserAlgorithmDisable()",
	     "Failed disable Algorithm(%s)",
	     pcInstance);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pac parser context
/// \arg phsle symbol to handle
/// \arg palgi algorithm instance that should handle given symbol.
/// \arg pcName name of algorithm to import
/// \arg pcInstance name of algorithm instance to create
/// 
/// \return int : success of operation
/// 
/// \brief Call algorithm instance handler on given symbol.
/// 

int
ParserAlgorithmHandle
(PARSERCONTEXT *pac,
 struct symtab_HSolveListElement *phsle,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance)
{
    //- set default result : ok

    int iResult = TRUE;

    //- give diagnostics : handle of symbol by algorithm

    ParserMessage
	(pac,
	 LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	 "ParserAlgorithmHandle()",
	 "AlgorithmInstance(%s) handles %s",
	 pcInstance,
	 "(no context)");

    //- prepare the parser context stack

    if (!ParserContextPrepare(pac, phsle))
    {
	iResult = FALSE;
    }

    //- ask algorithm to handle symbol

    if (!AlgorithmInstanceSymbolHandler(palgi, pac))
    {
	iResult = FALSE;
    }

    /// \todo register outcome of instance symbol handler in instance symbol

    //- repair the parser context stack

    if (!ParserContextRepair(pac))
    {
	iResult = FALSE;
    }

    //- give diagnostics : handle of symbol by algorithm

    /// \todo we do no the context here, right ?
    /// \todo its symbolic name is in pac I assume, have to double check.

    ParserMessage
	(pac,
	 LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	 "ParserAlgorithmHandle()",
	 "AlgorithmInstance(%s) handled %s",
	 pcInstance,
	 "(no context)");

    //- return result

    return(iResult);
}


/// 
/// \arg pacContext parser context
/// \arg pcName name of algorithm class to import
/// \arg pcInstance name of algorithm instance to create
/// \arg ppar algorithm instantiation parameters.
/// \arg palgs algorithm symbol.
/// 
/// \return struct AlgorithmInstance * 
/// 
///	instance of imported algorithm, NULL for failure.
/// 
/// \brief import a algorithm
///
/// \details 
/// 
///	Does some parsing logging, calls AlgorithmImport()
/// 

struct AlgorithmInstance *
ParserAlgorithmImport
(PARSERCONTEXT *pacContext,
 char *pcName,
 char *pcInstance,
 struct symtab_Parameters *ppar,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- instantiate algorithm

    palgiResult
	= AlgorithmSetInstantiateAlgorithm
	  (pacContext->pneuro->psym->pas,
	   pacContext,
	   pcName,
	   pcInstance,
	   ppar,
	   palgs);

    //- if success

    if (palgiResult)
    {
	//- give diagnostics : import of algorithm

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	     "ParserAlgorithmImport()",
	     "Import Algorithm(%s -> %s)",
	     pcName,
	     pcInstance);
    }

    //- else

    else
    {
	//- give diagnostics : failed import of algorithm

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	     "ParserAlgorithmImport()",
	     "Failed Import Algorithm(%s -> %s)",
	     pcName,
	     pcInstance);

	//- signal error to neurospaces

	NeurospacesError
	    (pacContext,
	     "ParserAlgorithmImport()",
	     "Failed Import Algorithm(%s -> %s)",
	     pcName,
	     pcInstance);

    }

    //- return result

    return(palgiResult);
}


/// 
/// \arg pacParserContext parser context
/// \arg pifToParse parse request
/// 
/// \return int : success of operation
/// 
/// \brief serve a new parse request
///
/// \details 
/// 
///	Filename of file to parse and parsing function must both be given in
///	pifToParse.
/// 
///	1. associate current lexical state with the given parser context
///	2. open file (in pifToParse)
///	3. construct and link new parser context
///	4. switch to new lexical state (beginning of given file)
///	5. parse file with parse function in pifToParse
///	6. unswitch to old lexical state
///	7. restore to old parse context
/// 

int ParserParse
(PARSERCONTEXT *pacParserContext,
 struct ImportedFile *pifToParse)
{
    //- set default result : failure

    int bResult = FALSE;

    FILE *pFILE = NULL;

    //- store current lexical buffer on topmost stack node

    LexAssociateWithParseContext
	(&((PARSERCONTEXT *)pacParserContext)->pyyBuffer);

    //- if file can be opened

    char *pcFilename = ImportedFileGetQualified(pifToParse);

    pFILE = fopen(pcFilename, "r");

    if (pFILE)
    {
	//- allocate for new parser context

	PARSERCONTEXT *pacContext = ParserContextCalloc();

	//- register globals with symbol table

	pacContext->pneuro = pacParserContext->pneuro;

	//- set nesting level

	pacContext->iNestingLevel \
	    = ((PARSERCONTEXT *)pacParserContext)->iNestingLevel + 1;

	//- put pifToParse in parser context

	ParserContextSetImportedFile(pacContext, pifToParse);

	//- lexical switch to selected file

	LexFileSwitch(&pacContext->pyyBuffer, pFILE);

	//- link parser contexts

	pacContext->pacPrev = pacParserContext;
	pacParserContext->pacNext = pacContext;

	//- set current parser context

	ParserChangeContext(pacContext);

	//- parse given file

/* 	bResult = pifToParse->parseMethod(pacContext); */

	/// \note note: one global parse function here

	bResult = parserparse(pacContext) == 0;

	//- unswitch the lexical analyzer

	//! if we don't do this check, we get a crash, but I would
	//! anyway expect pyyBuffer never to be NULL here ...

	if (((PARSERCONTEXT *)pacParserContext)->pyyBuffer)
	{
	    LexFileUnswitch(((PARSERCONTEXT *)pacParserContext)->pyyBuffer);
	}

	//- set current parser context back to previous

	ParserChangeContext(pacContext->pacPrev);

	//- unlink parser context

	pacParserContext->pacNext = NULL;

	//- if previous lexical analyzer context

	if (pacContext->pyyBuffer)
	{
	    //- remove association

	    LexAssociateRemove(&pacContext->pyyBuffer);
	}

	//- remove parser context

	free(pacContext);

	//- close file

	fclose(pFILE);
    }

    //- else

    else
    {
	//- diagnostics : file not found etc.

	fprintf
	    (stderr,
	     "Error opening file %s\n",
	     ImportedFileGetQualified(pifToParse));
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pac parser context.
/// \arg phsle symbol needed for preparation.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \details 
/// 
///	Prepare the context stack of the parser, such that regular
///	context operations can be done with the stack
///	(PidinStackLookupTopSymbol() etc.).  You must call
///	ParserContextRepair() after calling this function.  Currently
///	this function takes the context stack, and takes care that the
///	given symbol is regarded as the top symbol of the context
///	under the assumption that they are being parsed.  This is
///	needed because the function ParserCurrentElementPush() and
///	related only push pidins, without their corresponding symbols
///	such that you can use that function to keep context (perhaps
///	the symbols are not defined or complete yet at the time the
///	function is called).
/// 
///	This function is called as a preparation before calling symbol
///	algorithm handlers.
/// 
/// \note 
/// 
///	This function does some dirty things in the most clean way
///	possible...
/// 
///	You must call ParserContextRepair() after calling this
///	function.
/// 

static int
ParserContextPrepare
(PARSERCONTEXT *pac, struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int iResult = TRUE;

    //- get current context

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    //- set element we are handling

    PSymbolSerialStackPush(&ppist->symsst, phsle);

    //- update caches or ...

    if (!PidinStackUpdateCaches(ppist))
    {
	//- ... set failure

	iResult = FALSE;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pacContext parser context
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \details 
/// 
///	Repair a parser context stack after algorithm handling.
/// 

static int ParserContextRepair(PARSERCONTEXT *pac)
{
    //- set default result : ok

    int iResult = TRUE;

    //- get current context

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    //- remove the element we were handling

    struct symtab_HSolveListElement *phsle
	= PSymbolSerialStackPop(&ppist->symsst);

    //- if it cannot be found

    if (!phsle)
    {
	//- set failure

	iResult = FALSE;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pac new parser context
/// 
/// \return void
/// 
/// \brief Set new parser context
/// 

void ParserSetContext(PARSERCONTEXT *pac)
{
    //- sanity test current context

    if (pacCurrentContext)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     0, //pacCurrentContext->pcParser,
	     "Warning : Erasing parser context\n",
	     NULL);
    }

    //- set parser context

    pacCurrentContext = pac;
}


/// 
/// \arg pac new root parser context
/// 
/// \return void
/// 
/// \brief Set new root parser context
/// 

void ParserSetRootContext(PARSERCONTEXT *pac)
{
    //- sanity test current root context

    if (pacRootContext)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     0, //pacCurrentContext->pcParser,
	     "Warning : Erasing root parser context\n",
	     NULL);
    }

    //- register context as root context

    pacRootContext = pac;

    pacRootContext->iState |= PARSER_FLAG_ROOTCONTEXT;

    //- register root imported file

    ImportedFileSetRootImport(pacRootContext->pifInParse);
}


/// 
/// \return void
/// 
/// \brief Initialize parsing
/// 

void ParserStart(void)
{
    //- if we are in root context

    if (pacRootContext == pacCurrentContext)
    {
/* 	//- generate start event */

/* 	/// \note current context should contain root here */

/* 	ParserEventGenerate(EVENT_ACTION_START, NULL, &pacCurrentContext->pist); */
    }
}


