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
//' Copyright (C) 1999-2007 Hugo Cornelis
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


//v current parser context

static PARSERCONTEXT *pacCurrentContext = NULL;


//v root parser context

static PARSERCONTEXT *pacRootContext = NULL;


//v index to data

static int iParserContextData = -1;

//v void data

static void **ppvParserContextData = NULL;

//d default size of parser context void data stack

#define SIZE_PARSERCONTEXTSTACK	100


//v index to container data

static int iParserContainerData = -1;

//v container element

static struct symtab_Vector **ppvectParserContainerData = NULL;

#define SIZE_PARSERCONTAINERSTACK	100


//v index to algorithm data

static int iParserAlgorithmData = -1;

//v algorithm data

static void **ppvParserAlgorithmData = NULL;

#define SIZE_PARSERALGORITHMSTACK	100


//f local functions

static void ParserChangeContext(PARSERCONTEXT *pac);

static int
ParserContextPrepare
(PARSERCONTEXT *pac, struct symtab_HSolveListElement *phsle);

static int ParserContextRepair(PARSERCONTEXT *pac);


/// **************************************************************************
///
/// SHORT: ParserAddModel()
///
/// ARGS.:
///
///	pacContext.: parser context
///	phsle......: symbol table element
///
/// RTN..: int : success of operation
///
/// DESCR: Add symbol to private or public model list.
///
///	Depending on parser state, a call is made ParserAddPrivateModel()
///	or ParserAddPublicModel().
///
/// **************************************************************************

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

	bResult = ParserAddPrivateModel(pacContext,phsle);
    }

    //- else if parsing private models

    else if (iState == PARSER_STATE_PUBLICMODELS)
    {
	//- add public model

	bResult = ParserAddPublicModel(pacContext,phsle);
    }

    //- else

    else
    {
	//- register error

	NeurospacesError
	    (pacContext,"ParserAddModel()","Called in wrong parser state");
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserAddPrivateModel()
///
/// ARGS.:
///
///	pacContext.: parser context
///	phsle......: symbol table element
///
/// RTN..: int : success of operation
///
/// DESCR: Add symbol to current private model list
///
/// **************************************************************************

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

/*     SymbolSetFlags(phsle,FLAGS_HSLE_PRIVATE); */

    //- add symbol as private model

    bResult = DefSymAddPrivateModel(pdefsym,phsle);

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


/// **************************************************************************
///
/// SHORT: ParserAddPublicModel()
///
/// ARGS.:
///
///	pacContext.: parser context, may be NULL
///	phsle......: symbol table element
///
/// RTN..: int : success of operation
///
/// DESCR: Add symbol to current public model list
///
///	Generates events for TYPE_HSLE_D3SEGMENT, TYPE_HSLE_CELL
///
///	If no parser context is given, it defaults to the current context.
///
/// **************************************************************************

/* static */
int ParserAddPublicModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = 1;

    //v currently parsed file

    struct ImportedFile *pif = NULL;

    //v currently defined symbols

    struct DefinedSymbols *pdefsym = NULL;

    //- if no parser context given

    if (!pacContext)
    {
	//- set to current context

	pacContext = pacCurrentContext;
    }

/*     //- set flag : is public model */

/*     SymbolSetFlags(phsle,FLAGS_HSLE_PUBLIC); */

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

    bResult = DefSymAddPublicModel(pdefsym,phsle);

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


/// **************************************************************************
///
/// SHORT: ParserContextCalloc()
///
/// ARGS.:
///
/// RTN..: PARSERCONTEXT * : allocated parser context, NULL for failure
///
/// DESCR: Allocate new parser context
///
/// **************************************************************************

PARSERCONTEXT *ParserContextCalloc(void)
{
    //- set default result : failure

    PARSERCONTEXT *pacResult = NULL;

    //- allocate parser context

    pacResult = (PARSERCONTEXT *)calloc(1,sizeof(PARSERCONTEXT));

    //- initialize parser context

    ParserContextInit(pacResult);

    //- return result

    return(pacResult);
}


/// **************************************************************************
///
/// SHORT: ParserClearContext()
///
/// ARGS.:
///
/// RTN..: void
///
/// DESCR: Clear parser context
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserClearRootContext()
///
/// ARGS.:
///
/// RTN..: void
///
/// DESCR: Clear root parser context
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserChangeContext()
///
/// ARGS.:
///
///	pac...: new parser context
///
/// RTN..: void
///
/// DESCR: Set new parser context
///
/// **************************************************************************

static void ParserChangeContext(PARSERCONTEXT *pac)
{
    //- set parser context

    pacCurrentContext = pac;
}


/// **************************************************************************
///
/// SHORT: ParserContextActualContainer()
///
/// ARGS.:
///
/// RTN..: symtab_Vector *  : popped container element
///
/// DESCR: Pop container element
///
/// **************************************************************************

struct symtab_Vector * ParserContextActualContainer(void)
{
    //- set default result : from array

    struct symtab_Vector * pvectResult
	= ppvectParserContainerData[iParserContainerData];

    //- return result

    return(pvectResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextActualState()
///
/// ARGS.:
///
/// RTN..: void * : popped data
///
/// DESCR: Pop data
///
/// **************************************************************************

void * ParserContextActualState(void)
{
    //- set default result : failure

    void *pvResult = NULL;

    //- set result : last pushed data

    pvResult = ppvParserContextData[iParserContextData];

    //- return result

    return(pvResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextGetActual()
///
/// ARGS.:
///
///	pac.: parser context
///
/// RTN..: struct symtab_HSolveListElement * : actually defined symbol
///
/// DESCR: Get symbol being defined
///
/// **************************************************************************

struct symtab_HSolveListElement *ParserContextGetActual(PARSERCONTEXT *pac)
{
    //- set result : from context

    struct symtab_HSolveListElement *phsleResult = pac->phsleActual;

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextInit()
///
/// ARGS.:
///
///	pac...: parser context to initialize
///
/// RTN..: void
///
/// DESCR: Initialize parser context
///
/// **************************************************************************

void ParserContextInit(PARSERCONTEXT *pac)
{
    //- zero out parser context

    memset(pac,0,sizeof(*pac));

    //- erase stack

    PidinStackInit(&pac->pist);

    //- register stack as rooted

    PidinStackSetRooted(&pac->pist);
}


/// **************************************************************************
///
/// SHORT: ParserContextPopContainer()
///
/// ARGS.:
///
/// RTN..: symtab_Vector *  : popped container element
///
/// DESCR: Pop container element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserContextPopAlgorithmState()
///
/// ARGS.:
///
/// RTN..: void *  : popped algorithm state
///
/// DESCR: Pop algorithm state
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserContextPopState()
///
/// ARGS.:
///
/// RTN..: void * : popped data
///
/// DESCR: Pop data
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserContextPushContainer()
///
/// ARGS.:
///
///	pvect..: (generic) container element
///
/// RTN..: int : success of operation
///
/// DESCR: Push container element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserContextPushAlgorithmState()
///
/// ARGS.:
///
///	pv..: algorithm state info
///
/// RTN..: int : success of operation
///
/// DESCR: Push algorithm state
///
/// **************************************************************************

int ParserContextPushAlgorithmState(void *pv)
{
    //- set default result

    int bResult = TRUE;

    //- allocate parser stack if necessary

    if (!ppvParserAlgorithmData)
    {
	ppvParserAlgorithmData
	    = (void **)calloc(SIZE_PARSERALGORITHMSTACK,sizeof(void *));
    }

    //- increment index to data

    iParserAlgorithmData++;

    //- register void data

    ppvParserAlgorithmData[iParserAlgorithmData] = pv;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextPushState()
///
/// ARGS.:
///
///	pv..: date to push
///
/// RTN..: void
///
/// DESCR: Push data
///
/// **************************************************************************

int ParserContextPushState(void *pv)
{
    //- set default result

    int bResult = TRUE;

    //- allocate parser stack if necessary

    if (!ppvParserContextData)
    {
	ppvParserContextData
	    = (void **)calloc(SIZE_PARSERCONTEXTSTACK,sizeof(void *));
    }

    //- increment index to data

    iParserContextData++;

    //- register void data

    ppvParserContextData[iParserContextData] = pv;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextQualifyFilename()
///
/// ARGS.:
///
///	pac.: parser context to use for qualification, may be NULL
///	pc..: filename to qualify
///
/// RTN..: char * : qualified filename, NULL for failure
///
/// DESCR: qualify a filename suitable for import functions
///
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for directories and environment.
///	if no parser context is given, qualification with directories of
///	previous parsed files will not be done.
///
/// **************************************************************************

char *ParserContextQualifyFilename(PARSERCONTEXT *pac,char *pc)
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


/// **************************************************************************
///
/// SHORT: ParserContextQualifyToConfiguration()
///
/// ARGS.:
///
///	pac.: parser context to use for qualification
///	pc..: filename to qualify
///
/// RTN..: char * : qualified filename, NULL for failure
///
/// DESCR: qualify a filename using parser context configuration.
///
///	See NeurospacesQualifyToConfiguration().
///
/// **************************************************************************

char *ParserContextQualifyToConfiguration(PARSERCONTEXT *pac, char *pc)
{
    //- set result: forward to neurospaces

    char *pcResult = NeurospacesQualifyToConfiguration(pac->pneuro, pc);

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextQualifyToParsingDirectory()
///
/// ARGS.:
///
///	pac.: parser context to use for qualification
///	pc..: filename to qualify
///
/// RTN..: char * : qualified filename, NULL for failure
///
/// DESCR: qualify a filename using parser contexts to get intended dir
///
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for directories, if file not found,
///	returns NULL.
///
/// **************************************************************************

char *ParserContextQualifyToParsingDirectory(PARSERCONTEXT *pac, char *pc)
{
    //- set default result

    char *pcResult = NULL;

    PARSERCONTEXT *pacLoop = NULL;

    int iDirectory = -1;

    //- calculate directory length from previous parser contexts

    iDirectory = 0;

    //! should not be dependent on root context ?

    //! root context can still be NULL here, meaning that 
    //! the given pac is the first import.
    //! We must not depend on this knowledge, but it is
    //! necessary to do a safety check.

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

	//! should not be dependent on root context ?

	//! root context can still be NULL here, meaning that 
	//! the given pac is the first import.
	//! We must not depend on this knowledge, but it is
	//! necessary to do a safety check.

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


/// **************************************************************************
///
/// SHORT: ParserContextQualifyToEnvironment()
///
/// ARGS.:
///
///	pac.: parser context to use for qualification
///	pc..: filename to qualify
///
/// RTN..: char * : qualified filename, NULL for failure
///
/// DESCR: qualify a filename using current environment.
///
///	Return value is obtained using malloc() and should be free()d.
///	Qualification means checking for environment variables and
///	current directory (where application was started, 
///	if in all these cases file not found, returns NULL.
///
/// **************************************************************************

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

		strcpy(pcResult,pcModels);

		strcat(pcResult, pc);
	    }
	    else
	    {
		pcResult = (char *)malloc(2 + i + strlen(pc));

		strcpy(pcResult,pcModels);

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


/// **************************************************************************
///
/// SHORT: ParserContextSetActual()
///
/// ARGS.:
///
///	pac....: parser context
///	phsle..: symbol being defined
///
/// RTN..: struct symtab_HSolveListElement * :
///
///	Previous actual symbol
///
/// DESCR: Set symbol being defined.
///
/// **************************************************************************

struct symtab_HSolveListElement *
ParserContextSetActual
(PARSERCONTEXT *pac,struct symtab_HSolveListElement *phsle)
{
    //- set result : previous symbol

    struct symtab_HSolveListElement *phsleResult
	= ParserContextGetActual(pac);

    //- overwrite actual

    pac->phsleActual = phsle;

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextSetImportedFile()
///
/// ARGS.:
///
///	pac....: parser context
///	pif....: imported file
///
/// RTN..: void
///
/// DESCR: Set imported file attached to parser context
///
/// **************************************************************************

void ParserContextSetImportedFile(PARSERCONTEXT *pac,struct ImportedFile *pif)
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

    pcDirectory = ImportedFileGetFilename(pif);

    //- filename starts at end of directory part

    pcFilename = strrchr(pcDirectory,'/');

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
    strncpy(pac->pcDirectory,pcDirectory,iDirectory);
    pac->pcDirectory[iDirectory] = '\0';

    pac->pcFilename = (char *)malloc(1 + iFilename);
    strcpy(pac->pcFilename,pcFilename);
}


/// **************************************************************************
///
/// SHORT: ParserCurrentElementPop()
///
/// ARGS.:
///
///	pac....: parser context
///
/// RTN..: struct symtab_IdentifierIndex * :
///
///	name of popped element, NULL for failure
///
/// DESCR: Pop current element name
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserCurrentElementPopAll()
///
/// ARGS.:
///
///	pac....: parser context
///
/// RTN..: void
///
/// DESCR: Pop all current element names (empties element stack)
///
/// NOTE.: See ParserContextPrepare() for more info on this function.
///
/// **************************************************************************

void ParserCurrentElementPopAll(PARSERCONTEXT *pac)
{
    //- init stack

    PidinStackInit(&pac->pist);
}


/// **************************************************************************
///
/// SHORT: ParserCurrentElementPush()
///
/// ARGS.:
///
///	pac.......: parser context
///	pidinName.: new current element name
///
/// RTN..: int : success of operation
///
/// DESCR: Set new current element name.
///
/// NOTE.: See ParserContextPrepare() for more info on this function.
///
/// **************************************************************************

int ParserCurrentElementPush
(PARSERCONTEXT *pac,struct symtab_IdentifierIndex *pidinName)
{
    //- set result : push onto stack

    int bResult = PidinStackPushAll(&pac->pist,pidinName);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserFinish()
///
/// ARGS.:
///
/// RTN..: void
///
/// DESCR: Finish parsing, clean up
///
/// **************************************************************************

void ParserFinish(void)
{
    //- if we are in root context

    if (pacRootContext == pacCurrentContext)
    {
/* 	//- generate finish event */

/* 	//! current context should contain root here */

/* 	ParserEventGenerate(EVENT_ACTION_FINISH,NULL,&pacCurrentContext->pist); */
    }
}


/// **************************************************************************
///
/// SHORT: ParserImport()
///
/// ARGS.:
///
///	pac.........: parser context, NULL for default root context.
///	pcFilename..: file to parse
///	pcNameSpace.: name space for imported models
///
/// RTN..: int : success of operation
///
/// DESCR: import file, parse if necessary
///
///	Import the given file, if it is not yet imported, parse it with the
///	given parse() function via a call to ParserParse().
///	Link the parsed file (newly parsed or cached) as a dependency file
///	for the file currently in parse.
///	pcNameSpace is the name space for the imported models, it is linked
///	into the structure of defined symbols. It must not be freed 
///	afterwards.
///
/// **************************************************************************

int
ParserImport
(PARSERCONTEXT *pac,
 char *pcFilename,
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
	 pcFilename);

    //- try to lookup file in symbol table

    pifToParse = SymbolsLookupImportedFile(psym,pcFilename,pac);

    //- if not found

    if (!pifToParse)
    {
	//! I first add the file to the symbol table, this also gets around
	//! circular dependencies. 

	//- if add file to symbol table

	bResult
	    = (pifToParse = SymbolsAddImportedFile(psym,pcFilename,pac))
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

/* 	    ImportedFileSetParseMethod(pifToParse,parse); */

	    //- parse file

	    bResult = ParserParse(pac,pifToParse) == 0;

	    //- if parse ok

	    if (bResult)
	    {
		//- allocate element for dependency files list

		struct DependencyFile *pdf
		    = DependencyFileCallocNameSpaceImportedFile
		      (pcNameSpace,pifToParse);

		//- queue element into dependency list

		HSolveListEnqueue
		    (&pdefsym->hslDependencyFiles,
		     &pdf->hsleLink);
	    }
	}

	//- else

	else
	{
	    //- register error : unable to import given file

	    //! this is also an internal error

	    NeurospacesError
		(pac,
		 "ParserImport()",
		 "Could not import %s",
		 pcFilename);
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
	      (pcNameSpace,pifToParse);

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
	     ImportedFileGetFilename(pifToParse));
    }

    //- give diagnostics

    ParserMessage
	((PARSERCONTEXT *)pac,
	 LEVEL_GLOBALMSG_FILEIMPORT,
	 "ParserImport()",
	 "->End(%s)",
	 pcFilename);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserLookupDependencyModel()
///
/// ARGS.:
///
///	pacContext.: parser context to search for symbol
///	pidin......: namespaced hierarchical name to search for
///
/// RTN..: struct symtab_HSolveListElement *
///
///	source of dependency, NULL if not found.
///
/// DESCR: lookup a dependency symbol
///
///	Gives pointer into another pif struct its public model symbols,
///	Structure returned is read-only.
///	This function is a wrapper around SymbolLookup().
///
/// **************************************************************************

struct symtab_HSolveListElement *
ParserLookupDependencyModel
(PARSERCONTEXT *pacContext,struct symtab_IdentifierIndex *pidin)
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


/// **************************************************************************
///
/// SHORT: ParserLookupPrivateModel()
///
/// ARGS.:
///
///	pcIdentifier..: name of private model to search
///
/// RTN..: struct symtab_HSolveListElement * : 
///
///	private, NULL for failure
///
/// DESCR: lookup a private model
///
///	Lookup a private in current active private models
///
/// **************************************************************************

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
	= DefSymLookup(pdefsym,NULL,pcIdentifier,FLAG_SYMBOL_PRIVATEMODEL);

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
/* /// RTN..: struct symtab_HSolveListElement * : symbol, NULL for failure */
/* /// */
/* /// DESCR: lookup a symbol */
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

/* 	if (!PidinStackAppendCompact(&pistToSearch,ppist)) */
/* 	{ */
/* 	    return(NULL); */
/* 	} */
/*     } */

/*     //- if pidin given */

/*     if (pidin) */
/*     { */
/* 	//- push pidin */

/* 	if (!PidinStackPushCompactAll(&pistToSearch,pidin)) */
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


/// **************************************************************************
///
/// SHORT: ParserMessage()
///
/// ARGS.:
///
///	pacContext.: parser context
///	iPriority..: priority of given message
///	pcContext..: descriptive string for parsing context (unused)
///	pcMessage..: stdargs message to log
///
/// RTN..: int :  0 : continue parsing, msg logged
///		  1 : continue parsing, no msg logged
///		 -1 : stop parsing
///
/// DESCR: log a message from any of the parsing functions
///
///	iPriority is compared with the verbosity option given on the command
///	line, if higher, the message is written to stdout.
///
///	Does some parsing logging, calls NeurospacesMessage()
///
/// **************************************************************************

int ParserMessage
(PARSERCONTEXT *pacContext,
 int iPriority,
 char *pcContext,
 char *pcMessage,...)
{
    //- set default result : continue parsing

    int bResult = 0;

    //v tmp var

    char pc[100];

    //v stdargs list

    va_list vaList;

    int i;

    //- if no parser context given

    if (!pacContext)
    {
	//- parser context defaults to current context

	pacContext = pacCurrentContext;
    }

    //t neurospaces should not be accessed here

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

    va_start(vaList,pcMessage);

    //- do indentation according to nesting level

    sprintf
	(pc,
	 "%i,%-12.12s,%i\t||",
	 pacContext->iNestingLevel,
	 ParserContextGetFilename(pacContext),
	 ParserContextGetLineNumber(pacContext));

    NeurospacesMessage(iPriority,1,pc,NULL);

    for (i = 0; i < pacContext->iNestingLevel; i++)
    {
	NeurospacesMessage(iPriority,0,"  ",NULL);
    }

    //- give diagnostics

    NeurospacesMessage(iPriority,0,pcMessage,vaList);

    NeurospacesMessage(iPriority,2,"\n",NULL);

    //- end stdargs

    va_end(vaList);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserAlgorithmDisable()
///
/// ARGS.:
///
///	pacContext.: parser context
///	palgi......: algorithm instance to disable.
///	pcName.....: name of algorithm to import
///	pcInstance.: name of algorithm instance to create
///	pcInit.....: init string of algorithm, only for diag's
///
/// RTN..: int : success of operation
///
/// DESCR: disable a loadable algorithm
///
///	Does some parsing logging, calls AlgorithmDisable()
///
/// **************************************************************************

int ParserAlgorithmDisable
(PARSERCONTEXT *pacContext,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance,
 char *pcInit)
{
    //- set default result : failure

    int bResult = FALSE;

    //- import algorithm

    bResult = AlgorithmInstanceDisable(palgi,pcName,pacContext) != FALSE;

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


/// **************************************************************************
///
/// SHORT: ParserAlgorithmHandle()
///
/// ARGS.:
///
///	pac........: parser context
///	phsle......: symbol to handle
///	palgi......: algorithm instance that should handle given symbol.
///	pcName.....: name of algorithm to import
///	pcInstance.: name of algorithm instance to create
///	pcInit.....: init string of algorithm
///
/// RTN..: int : success of operation
///
/// DESCR: Call algorithm instance handler on given symbol.
///
/// **************************************************************************

int
ParserAlgorithmHandle
(PARSERCONTEXT *pac,
 struct symtab_HSolveListElement *phsle,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance,
 char *pcInit)
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

    //t register outcome of instance symbol handler in instance symbol

    //- repair the parser context stack

    if (!ParserContextRepair(pac))
    {
	iResult = FALSE;
    }

    //- give diagnostics : handle of symbol by algorithm

    //t we do no the context here, right ?
    //t its symbolic name is in pac I assume, have to double check.

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


/// **************************************************************************
///
/// SHORT: ParserAlgorithmImport()
///
/// ARGS.:
///
///	pacContext.: parser context
///	pcName.....: name of algorithm class to import
///	pcInstance.: name of algorithm instance to create
///	pcInit.....: init string of algorithm
///	ppar.......: algorithm instantiation parameters.
///	palgs......: algorithm symbol.
///
/// RTN..: struct AlgorithmInstance * 
///
///	instance of imported algorithm, NULL for failure.
///
/// DESCR: import a algorithm
///
///	Does some parsing logging, calls AlgorithmImport()
///
/// **************************************************************************

struct AlgorithmInstance *
ParserAlgorithmImport
(PARSERCONTEXT *pacContext,
 char *pcName,
 char *pcInstance,
 char *pcInit,
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
	   pcInit,
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
	     "Import Algorithm(%s -> %s(%s))",
	     pcName,
	     pcInstance,
	     pcInit);
    }

    //- else

    else
    {
	//- give diagnostics : failed import of algorithm

	ParserMessage
	    (pacContext,
	     LEVEL_GLOBALMSG_ALGORITHMIMPORT,
	     "ParserAlgorithmImport()",
	     "Failed Import Algorithm(%s -> %s(%s))",
	     pcName,
	     pcInstance,
	     pcInit);

	//- signal error to neurospaces

	NeurospacesError
	    (pacContext,
	     "ParserAlgorithmImport()",
	     "Failed Import Algorithm(%s -> %s(%s))",
	     pcName,
	     pcInstance,
	     pcInit);

    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ParserParse()
///
/// ARGS.:
///
///	pacParserContext.: parser context
///	pifToParse.......: parse request
///
/// RTN..: int : success of operation
///
/// DESCR: serve a new parse request
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
/// **************************************************************************

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

    pFILE = fopen(ImportedFileGetFilename(pifToParse),"r");

    if (pFILE)
    {
	//- allocate for new parser context

	PARSERCONTEXT *pacContext
	    = (PARSERCONTEXT *)malloc(sizeof(PARSERCONTEXT));

	//- initialize parser context

	ParserContextInit(pacContext);

	//- register globals with symbol table

	pacContext->pneuro = pacParserContext->pneuro;

	//- set nesting level

	pacContext->iNestingLevel \
	    = ((PARSERCONTEXT *)pacParserContext)->iNestingLevel + 1;

	//- put pifToParse in parser context

	ParserContextSetImportedFile(pacContext,pifToParse);

	//- lexical switch to selected file

	LexFileSwitch(&pacContext->pyyBuffer,pFILE);

	//- link parser contexts

	pacContext->pacPrev = pacParserContext;
	pacParserContext->pacNext = pacContext;

	//- set current parser context

	ParserChangeContext(pacContext);

	//- parse given file

/* 	bResult = pifToParse->parseMethod(pacContext); */

	//! note: one global parse function here

	bResult = parserparse(pacContext);

	//- unswitch the lexical analyzer

	LexFileUnswitch(((PARSERCONTEXT *)pacParserContext)->pyyBuffer);

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
	     ImportedFileGetFilename(pifToParse));
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserContextPrepare()
///
/// ARGS.:
///
///	pac...: parser context.
///	phsle.: symbol needed for preparation.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR:
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
/// NOTE.:
///
///	This function does some dirty things in the most clean way
///	possible...
///
///	You must call ParserContextRepair() after calling this
///	function.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserContextRepair()
///
/// ARGS.:
///
///	pacContext.: parser context
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR:
///
///	Repair a parser context stack after algorithm handling.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserSetContext()
///
/// ARGS.:
///
///	pac...: new parser context
///
/// RTN..: void
///
/// DESCR: Set new parser context
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserSetRootContext()
///
/// ARGS.:
///
///	pac...: new root parser context
///
/// RTN..: void
///
/// DESCR: Set new root parser context
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ParserStart()
///
/// ARGS.:
///
/// RTN..: void
///
/// DESCR: Initialize parsing
///
/// **************************************************************************

void ParserStart(void)
{
    //- if we are in root context

    if (pacRootContext == pacCurrentContext)
    {
/* 	//- generate start event */

/* 	//! current context should contain root here */

/* 	ParserEventGenerate(EVENT_ACTION_START,NULL,&pacCurrentContext->pist); */
    }
}


