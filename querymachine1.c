//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: querymachine.c 1.231 Fri, 07 Dec 2007 11:59:10 -0600 hugo $
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



#if !defined(__APPLE__)
#include <malloc.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>


#ifdef HAVE_LIBHISTORY
#ifdef HAVE_LIBREADLINE
#ifdef HAVE_LIBCURSES
#define USE_READLINE
#endif
#endif
#endif


#ifdef USE_READLINE

#ifdef	__cplusplus
extern "C" {
#endif

#include <readline/readline.h>
#include <readline/history.h>

#ifdef	__cplusplus
}
#endif

#endif


#include "neurospaces/algorithmset.h"
#include "neurospaces/biolevel.h"
#include "neurospaces/cachedconnection.h"
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/root.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/coordinatecache.h"
#include "neurospaces/exporter.h"
#include "neurospaces/function.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/namespace.h"
#include "neurospaces/parameters.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/projectionquery.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/workload.h"


#include "neurospaces/symbolvirtual_protos.h"


#ifndef MIN
#define MIN(x,y) ((x) <= (y) ? (x) : (y))
#endif

#ifndef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#endif


static void QueryMachinePrompt(void);

static void QueryMachineInitReadLine();


/// \struct query association: associates a query machine command with
/// a function callback, and perhaps with a readline completion
/// callback.

typedef struct QueryHandlerAssociation
{
    /// enter command

    char *pcCommand;

    /// query handler

    QueryHandler *pfQueryHandler;

#ifdef USE_READLINE

    /// completion type
    ///
    /// -1 : no completion
    ///  0 : default completion (readline's filename completion)
    ///  1 : completion with ->pfCompletor
    ///

    int iCompletionType;

    /// completor

    CPFunction *pfCompletor;

#endif

}
QueryHandlerAssociation;


/* static CPFunction QueryMachineSymbolGenerator; */

static char *
QueryMachineSymbolGenerator(char *,int);


/// query association table

static QueryHandlerAssociation pquhasTable[] =
{
    /// algorithmclass

    {
	"algorithmclass",
	QueryHandlerAlgorithmClass,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// algorithminstance

    {
	"algorithminstance",
	QueryHandlerAlgorithmInstance,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// algorithminstantiate

    {
	"algorithminstantiate",
	QueryHandlerAlgorithmInstantiate,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// algorithmset

    {
	"algorithmset",
	QueryHandlerAlgorithmSet,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// allocation statistics

    {
	"allocations",
	QueryHandlerAllocations,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// biogroup2biolevel

    {
	"biogroup2biolevel",
	QueryHandlerBiogroup2Biolevel,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// biolevel2biogroup

    {
	"biolevel2biogroup",
	QueryHandlerBiolevel2Biogroup,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// cell count

    {
	"cellcount",
	QueryHandlerPrintCellCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// children info

    {
	"childreninfo",
	QueryHandlerPrintChildren,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// connection count

    {
	"connectioncount",
	QueryHandlerPrintConnectionCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// find out information about a context

    {
	"context-info",
	QueryHandlerContextInfo,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// subtract two contexts

    {
	"context-subtract",
	QueryHandlerContextSubtract,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// count number of aliases

    {
	"countaliases",
	QueryHandlerCountAliases,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// count number of allocated symbols

    {
	"countallocatedsymbols",
	QueryHandlerCountAllocatedSymbols,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// delete a model component

    {
	"delete",
	QueryHandlerDelete,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// echo something to the terminal

    {
	"echo",
	QueryHandlerEcho,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// expand a wildcard

    {
	"expand",
	QueryHandlerExpand,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// export

    {
	"export",
	QueryHandlerExport,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    {
	"insert",
	QueryHandlerInsert,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// find out information about an input

    {
	"input-info",
	QueryHandlerInputInfo,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// help

    {
	"help",
	QueryHandlerHelpCommands,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// imported files

    {
	"importedfiles",
	QueryHandlerImportedFiles,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// import a file

    {
	"importfile",
	QueryHandlerImportFile,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// list symbols in namespace

    {
	"listsymbols",
	QueryHandlerListSymbols,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// match of pidinstacks

    {
	"match",
	QueryHandlerPidinStackMatch,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// mesh a cell

    {
	"mesh",
	QueryHandlerMesh,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// namespaces

    {
	"namespaces",
	QueryHandlerNameSpaces,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

/*     /// operate on two parameters */

/*     { */
/* 	"parameteroperator", */
/* 	QueryHandlerParameterOperator, */
/* #ifdef USE_READLINE */
/* 	-1, */
/* 	NULL, */
/* #endif */
/*     }, */

    /// partition a model (and cache the result for later use)

    {
	"partition",
	QueryHandlerPartition,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// global projection query : count

    {
	"pqcount",
	QueryHandlerPQCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : count pre-synaptic serials

    {
	"pqcountpre",
	QueryHandlerPQCountPre,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : get

    {
	"pqget",
	QueryHandlerPQGet,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : load from file

    {
	"pqload",
	QueryHandlerPQLoad,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : save to file

    {
	"pqsave",
	QueryHandlerPQSave,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : set

    {
	"pqset",
	QueryHandlerPQSet,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : set for all projections

    {
	"pqsetall",
	QueryHandlerPQSetAll,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// global projection query : traverse

    {
	"pqtraverse",
	QueryHandlerPQTraverse,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get coordinates

    {
	"printcoordinates",
	QueryHandlerPrintCoordinates,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// print info

    {
	"printinfo",
	QueryHandlerPrintInfo,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get parameter

    {
	"printparameter",
	QueryHandlerPrintParameter,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },


    /// get parameter info

    {
	"printparameterinfo",
	QueryHandlerPrintParameterInfo,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },



    /// get function parameter input

    {
	"printparameterinput",
	QueryHandlerPrintParameterInput,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get scaled parameter

    {
	"printparameterscaled",
	QueryHandlerPrintParameterScaled,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get parameter set

    {
	"printparameterset",
	QueryHandlerPrintParameterSet,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// query projections

    {
	"projectionquery",
	QueryHandlerProjectionQuery,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// count connections in projection query

    {
	"projectionquerycount",
	QueryHandlerProjectionQueryCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    {
	"showparameters",
	QueryHandlerShowParameters,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// recalc serials of a component

    {
	"recalculate",
	QueryHandlerRecalculate,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// reduce parameters of a component

    {
	"reduce",
	QueryHandlerReduce,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// print solver for a symbol

    {
	"resolvesolver",
	QueryHandlerResolveSolverID,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// segment count

    {
	"segmentcount",
	QueryHandlerPrintSegmentCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// segmenter linearize

    {
	"segmenterlinearize",
	QueryHandlerSegmenterLinearize,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// segmenter parent count

    {
	"segmenterparentcount",
	QueryHandlerSegmenterParentCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// set segmenter base

    {
	"segmentersetbase",
	QueryHandlerSegmenterSetBase,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// segmenter tips

    {
	"segmentertips",
	QueryHandlerSegmenterTips,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get serial ID

    {
	"serialID",
	QueryHandlerSerialID,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// output forestspace structure to a file

    {
	"serializeforestspace",
	QueryHandlerSerializeForestspace,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get serial mappings

    {
	"serialMapping",
	QueryHandlerSerialMapping,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// convert serial to context

    {
	"serial2context",
	QueryHandlerSerialToContext,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// set the value of a parameter

    {
	"setparameter",
	QueryHandlerSetParameter,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// set the value of a parameter in the conceptual representation

    {
	"setparameterconcept",
	QueryHandlerSetParameterConcept,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get solver registrations

    {
	"solverget",
	QueryHandlerSolverGet,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// print solver registrations

    {
	"solverregistrations",
	QueryHandlerSolverRegistrations,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// set solver registrations

    {
	"solverset",
	QueryHandlerSolverSet,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// spike receiver count

    {
	"spikereceivercount",
	QueryHandlerPrintSpikeReceiverCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// spike receiver serial ID

    {
	"spikereceiverserialID",
	QueryHandlerPrintSpikeReceiverSerialID,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// spike sender count

    {
	"spikesendercount",
	QueryHandlerPrintSpikeSenderCount,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// symbol parameters

    {
	"symbolparameters",
	QueryHandlerPrintSymbolParameters,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// validate a segment group

    {
	"validatesegmentgroup",
	QueryHandlerValidateSegmentGroup,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// get version info

    {
	"version",
	QueryHandlerVersion,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    },

    /// write library

    {
	"writelibrary",
	QueryHandlerWriteLibrary,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// write modular

    {
	"writemodular",
	QueryHandlerWriteModular,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// write symbol

    {
	"writesymbol",
	QueryHandlerWriteSymbol,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// print out all parameters 
    /// associated with  a symbol

    {
	"printparametertraversal",
	QueryHandlerSymbolPrintParameterTraversal,
#ifdef USE_READLINE
	1,
	QueryMachineSymbolGenerator,
#endif
    },

    /// end of table

    {
	NULL,
	NULL,
#ifdef USE_READLINE
	-1,
	NULL,
#endif
    }

};


/// \def size hack

#define SIZE_COMMANDLINE	1000


/// \def some predefined commands

#define QUERY_COMMAND_CORE		"core"

#define QUERY_COMMAND_QUIT		"quit"


/// 
/// \return void
/// 
/// \brief print info on commands
/// 

int QueryHandlerHelpCommands
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    int i;

    //- print help on commands

    fprintf(stdout, "-------------------- \n\n");
    fprintf(stdout, "Available commands : \n\n");

    for (i = 0 ; pquhasTable[i].pcCommand ; i++)
    {
	fprintf(stdout, "%s\n", pquhasTable[i].pcCommand);
    }

    fprintf(stdout, "-------------------- \n\n");
}


/// 
/// \arg pcLine command line.
/// \arg pneuro neurospaces.
/// 
/// \return int : TRUE means user wants to stop
/// 
/// \brief Handle given command line
/// 

int QueryMachineHandle(struct Neurospaces *pneuro, char *pcLine)
{
    //- set default result : continue

    int bResult = FALSE;

    /// loop var

    int i;

    //- set init string (after '{')

    char *pcInit = &pcLine[0];

    /// argument separator

    char pcSeparator[] = " \t,;/\n";

    /// next arg

    char *pcArg = NULL;

    /// length of arg

    int iLength = -1;

    //- skip first white space

    pcArg = strpbrk(pcInit, pcSeparator);
    while (pcArg == pcInit)
    {
	pcInit++;
	pcArg = strpbrk(pcInit, pcSeparator);
    }

    //- get length for command

    pcArg = strpbrk(pcInit, pcSeparator);

    if (pcArg)
    {
	iLength = pcArg - pcInit;
    }
    else
    {
	iLength = strlen(pcInit);
    }

    //- if null length

    if (!iLength)
    {
	//- return

	return(bResult);
    }

    //- if command matches core command

    if (strncmp(QUERY_COMMAND_CORE, pcInit, iLength) == 0)
    {
	//- try to generate core

	((int *)(0))[0] = 0xdead;

	//- return to quit

	/// \note normally not reached

	return(TRUE);
    }

    //- if command matches quit command

    if (strncmp(QUERY_COMMAND_QUIT, pcInit, iLength) == 0)
    {
	//- return to quit

	return(TRUE);
    }

    //- loop over commands

    for (i = 0 ; pquhasTable[i].pcCommand ; i++)
    {
	//- if command matches

	if (strncasecmp(pquhasTable[i].pcCommand, pcInit, iLength) == 0)
	{
	    //- execute command

	    pquhasTable[i].pfQueryHandler(pcLine, iLength, pneuro, NULL);

	    //- return result

	    return(bResult);
	}
    }

    //- unrecognized command

    fprintf(stderr, "unrecognized command '%s'\n", pcInit);

    //- return result

    return(bResult);
}


/// 
/// \return void
/// 
/// \brief Init readline specific things.
/// 

static char *
QueryMachineCommandGenerator(text,state)
    char *text;
    int state;
{
    //- set default result : no match

    char *pcResult = NULL;

    /// current index in command array

    static int iIndex;

    /// current length of command

    static int iLength;

    char *pcCommand;
     
    /* If this is a new word to complete, initialize now.  This includes
       saving the length of TEXT for efficiency, and initializing the index
       variable to 0. */
    if (!state)
    {
	iIndex = 0;
	iLength = strlen(text);
    }
     
    /* Return the next name which partially matches from the command list. */
    while (pcCommand = pquhasTable[iIndex].pcCommand)
    {
	iIndex++;

	if (strncmp(pcCommand,text,iLength) == 0)
	{
	    //- return match

	    pcResult = calloc(2 + strlen(pcCommand), sizeof(char));
	    strcpy(pcResult, pcCommand);
	    return(pcResult);
	}
    }
    
    /* If no names matched, then return NULL. */
    return(NULL);
}

static char *
QueryMachineEmptyGenerator(text,state)
    char *text;
    int state;
{
    //- set default result : no match

    char *pcResult = NULL;

    //- if first match

    if (state == 0)
    {
	//- allocate empty result

	pcResult = calloc(2, sizeof(char));

	pcResult[0] = '\0';
    }

    //- return result

    return(pcResult);
}


/// \struct symbol generator data for readline callback.

struct QM_sg_traversal_data
{
    /// current child index to look for

    int iLookup;

    /// chars to match against

    char *pcSymbol;

    /// current child index

    int iChild;

    /// current child

    struct symtab_HSolveListElement *phsleChild;
};


static int 
QueryMachineSymbolGeneratorChildProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process sibling

    int iResult = TSTR_PROCESSOR_FAILURE;

    char pc[1000];

    //- get traversal data

    struct QM_sg_traversal_data *psgd
	= (struct QM_sg_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if matches with partial text already present

    IdinFullName(SymbolGetPidin(phsle), pc);

    if (strncmp(pc, psgd->pcSymbol, strlen(psgd->pcSymbol)) == 0)
    {
	//- increment matching children index

	psgd->iChild++;

	//- if past number of children to skip

	if (psgd->iChild > psgd->iLookup)
	{
	    //- abort the traversal

	    iResult = TSTR_PROCESSOR_ABORT;

	    //- set result for traversal

	    psgd->phsleChild = phsle;
	}
    }

    //- return result

    return(iResult);
}


/* Generator function for command completion.  STATE lets us know whether
   to start from scratch; without any state (i.e. STATE == 0), then we
   start at the top of the list. */
static char *
QueryMachineSymbolGenerator(text,state)
    char *text;
    int state;
{
    //- set default result : no match

    char *pcResult = NULL;

    /// current index in command array

    static int iIndex;

    /// current length of symbol

    static int iLength;

    /// ambiguation state

    /// \note ambiguation logic :
    /// \note if there is only one possible completion, 
    /// \note we ambiguate that completion by catting a '/'
    /// \note otherwise readline automatically cats a ' ' to the single 
    /// \note completion, which is very annoying.

    static char *pcAmbiguate;

    /// number of completions returned for current context

    static int iCompletions;

    /// start characters of symbol we are looking for

    char *pcSymbol = NULL;

    char *pcText = NULL;
    char *pcEnd = NULL;
    struct PidinStack *ppist = NULL;
    struct symtab_HSolveListElement *phsle = NULL;
    struct symtab_HSolveListElement *phsleChild = NULL;

    //- initialize state for first completion

    if (!state)
    {
	iIndex = 0;
	iLength = strlen(text);
	iCompletions = 0;
    }

    //- parse text to complete

    pcEnd = strrchr(text,IDENTIFIER_CHILD_CHAR);

    //- if nothing to complete

    if (pcEnd == NULL)
    {
	switch(iIndex)
	{
	//- if first completion

	case 0:
	{
	    //- completion from top of symbols :
	    //- namespaces
	    //- default namespace (::)

	    pcResult = calloc(3, sizeof(char));

	    pcResult[0] = '/';
	    pcResult[1] = '\0';

	    iIndex++;

	    break;
	}

	//- if second completion

	case 1:
	{
	    pcResult = calloc(4, sizeof(char));

	    pcResult[0] = ':';
	    pcResult[1] = ':';
	    pcResult[2] = '\0';

	    iIndex++;

	    break;
	}

	default:
	{
	}
	}
    }

    //- else normal completion

    else
    {
	pcSymbol = &pcEnd[1];

	pcText = calloc(2 + pcEnd - text, sizeof(char));

	strncpy(pcText, text, pcEnd - text);

	//- if symbols in context

	if (pcEnd - text != 0)
	{
	    //- end context at slash char

	    /// \note perhaps I need [1 + pcEnd - text]

	    pcText[pcEnd - text] = '\0';
	}

	//- else

	else
	{
	    //- mark presence of root

	    pcText[0] = '/';
	    pcText[1] = '\0';
	}

	ppist = PidinStackParse(pcText);

	//- lookup symbol

	/// \note allows namespacing, yet incompatible with parameter caches.

	phsle = SymbolsLookupHierarchical(/* pneuro->psym */NULL, ppist);

	if (phsle)
	{
	    struct QM_sg_traversal_data sgd =
		{
		    /// current child index to look for

		    iIndex,

		    /// chars to match against

		    pcSymbol,

		    /// current child index

		    0,

		    /// current child

		    NULL,
		};

	    //- init treespace traversal

	    struct TreespaceTraversal *ptstr
		= TstrNew
		  (ppist,
		   NULL,
		   NULL,
		   QueryMachineSymbolGeneratorChildProcessor,
		   (void *)&sgd,
		   NULL,
		   NULL);

	    //- traverse segment symbol

	    int iTraverse = TstrGo(ptstr, phsle);

	    //- delete treespace traversal

	    TstrDelete(ptstr);

	    //- set result from traversal

	    phsleChild = sgd.phsleChild;

	    iIndex++;
	}

	//- if valid symbol

	if (phsleChild && HSolveListValidSucc(&phsleChild->hsleLink))
	{
	    char pc[1000];

	    //- if still valid child

	    if (HSolveListValidSucc(&phsleChild->hsleLink))
	    {
		//- print original context

		PidinStackString(ppist, pc, sizeof(pc));

		if (strcmp(pc,SYMBOL_ROOT) != 0)
		{
		    strcat(pc,IDENTIFIER_CHILD_STRING);
		}

		//- print info about child

		IdinFullName(SymbolGetPidin(phsleChild), &pc[strlen(pc)]);

		//- allocate result

		pcResult = calloc(2 + strlen(pc), sizeof(char));
		strcpy(pcResult, pc);

		//- initialize ambiguation state

		pcAmbiguate
		    = calloc
		      (2
		       + strlen(pcResult)
		       + strlen(IDENTIFIER_CHILD_STRING),
		       sizeof(char));

		strcpy(pcAmbiguate, pcResult);

		strcat(pcAmbiguate, IDENTIFIER_CHILD_STRING);
	    }
	}
    }

    //- else if no completions

    if (iIndex == 0)
    {
	/// \todo add space to previously available items somehow ?
	/// \todo perhaps that's what is in the line buffer ?
    }

    //- if only one completion till now

    if (iCompletions == 1)
    {
	//- if no current completion

	if (!pcResult)
	{
	    //- ambiguate the previous match

	    /// \note readline will do free(pcAmbiguate)

	    pcResult = pcAmbiguate;

	    pcAmbiguate = NULL;
	}

	//- else

	else
	{
	    //- free the ambiguated symbol

	    /// \note we free the first ambiguation

	    if (pcAmbiguate)
	    {
		free(pcAmbiguate);

		pcAmbiguate = NULL;
	    }
	}
    }

    //- else if this is not the first completion

    else if (iCompletions != 0)
    {
	//- free the ambiguated symbol

	/// \note we free all follow-up ambiguations

	if (pcAmbiguate)
	{
	    free(pcAmbiguate);

	    pcAmbiguate = NULL;
	}
    }

    //- free allocated memory

    PidinStackFree(ppist);

    free(pcText);

    //- if we return a result

    if (pcResult)
    {
	//- increment number of generated completions for current context

	iCompletions++;
    }

    //- return result

    return(pcResult);
}



/* Attempt to complete on the contents of TEXT.  START and END bound the
   region of rl_line_buffer that contains the word to complete.  TEXT is
   the word to complete.  We can use the entire contents of rl_line_buffer
   in case we want to do some simple parsing.  Return the array of matches\
   ,
   or NULL if there aren't any. */

#ifdef USE_READLINE

static char **
QueryMachineCompletorSelector(text, start, end)
    char *text;
    int start, end;
{
    char **matches;

    matches = (char **)NULL;

    //- if completing command name

    /* If this word is at the start of the line, then it is a command
       to complete.  Otherwise it is the name of a file in the current
       directory. */

    if (start == 0)
    {
	//- create matches for commands

	matches = rl_completion_matches(text, QueryMachineCommandGenerator);
    }
    else
    {
	//- lookup command name

	int iCommand = -1;

	int iCurrent = 0;

	char *pcCommand = pquhasTable[iCurrent].pcCommand;

	while (pcCommand)
	{
	    if (strncmp(pcCommand, rl_line_buffer, strlen(pcCommand)) == 0)
	    {
		iCommand = iCurrent;

		break;
	    }

	    iCurrent++;

	    pcCommand = pquhasTable[iCurrent].pcCommand;
	}

/* 	fprintf */
/* 	    (stderr, */
/* 	     "Completion for command %i == %s(%s)\n", */
/* 	     iCommand, */
/* 	     pcCommand, */
/* 	     rl_line_buffer); */

	//- if command found and has a specific completor

	if (iCommand != -1
	    && pquhasTable[iCommand].iCompletionType == 1
	    && pquhasTable[iCommand].pfCompletor != NULL)
	{
	    //- count arguments on command line

	    int i = 0;
	    int iArguments = 0;

	    while (i <= start)
	    {
		i += strcspn(&rl_line_buffer[i], " \t") + 1;
		i += strspn(&rl_line_buffer[i], " \t") + 1;

		iArguments++;
	    }

/* 	    fprintf */
/* 		(stderr, */
/* 		 "Completion for argument %i\n", */
/* 		 iArguments); */

	    //- create matches using command specific completor

	    matches
		= rl_completion_matches
		  (text, pquhasTable[iCommand].pfCompletor);
	}

	//- else

	else
	{
	    //- notify readline : no completions available

	    matches
		= rl_completion_matches(text, QueryMachineEmptyGenerator);
	}
    }
     
    return (matches);
}

#endif


int QueryMachineInitialize(struct Neurospaces *pneuro)
{
    int bResult = TRUE;

    return(bResult);
}


static void QueryMachineInitReadLine()
{
#ifdef USE_READLINE

    //- set readline application name

    /// \note to allow conditional parsing of the ~/.inputrc file.

    rl_readline_name = "neurospaces";

    //- set the completor selector

    /// \note we use different completors, so we need to get around the default 
    /// \note readline mechanism
    /// \note (which uses rl_completion_entry_function as documented).

    rl_attempted_completion_function
	= (CPPFunction *)QueryMachineCompletorSelector;

    //- prevent readline from appending anything to completions.

    rl_completion_append_character = '\0';

    // bind tabulator key to nothing

    //rl_bind_key('\t',rl_insert);

#endif
}


/// 
/// \arg pcLine command line
/// \arg iReadline use readline ?
/// 
/// \return void
/// 
/// \brief Print prompt, get input from user
/// 

void QueryMachineInput(char *pcLine, int iReadline)
{
    //- default : nothing done

    int iDone = FALSE;

#ifdef USE_READLINE

    //- if readline

    if (iReadline)
    {
	/* A static variable for holding the line. */
	static char *line_read = (char *)NULL;

	//- readline initialized ?

	static int bReadline = FALSE;

	/* If the buffer has already been allocated, return the memory
	   to the free pool. */

	if (line_read)
	{
	    free(line_read);
	    line_read = (char *)NULL;
	}
     
	//- initialize some readline specific stuff

	if (!bReadline)
	{
	    QueryMachineInitReadLine();
	}

	/* Get a line from the user. */
	line_read = readline (" neurospaces $ ");
     
	/* If the line has any text in it, save it on the history. */
	if (line_read && *line_read)
	{
	    add_history(line_read);
     
	    strcpy(pcLine, line_read);
	}

	//- else if EOF

	else if (!line_read)
	{
	    //- do request to quit

	    strcpy(pcLine, QUERY_COMMAND_QUIT);
	}

	iDone = TRUE;
    }
    else
    {
	fprintf(stdout, "readline disabled\n");
    }

#endif

    //- if not done

    if (!iDone)
    {
	//- give prompt

	QueryMachinePrompt();

	//- get input from user

	fgets(pcLine, SIZE_COMMANDLINE, stdin);

	//- remove pending newline, compatibility with readline

	int iLength = strlen(pcLine);

	if (pcLine[iLength - 1] == '\n')
	{
	    pcLine[iLength - 1] = '\0';
	}
    }
}


/// 
/// \return void
/// 
/// \brief print prompt
/// 

static void QueryMachinePrompt(void)
{
    //- give prompt

    fprintf(stdout, " neurospaces > ");

    //fflush(stdout);
}


/// 
/// \arg pneuro neurospaces.
/// \arg iReadline use readline ?
/// 
/// \return void
/// 
/// \brief Iface to query machine
/// 

void QueryMachineStart(struct Neurospaces *pneuro, int iReadline)
{
    /// user command line

    char pcCommandLine[SIZE_COMMANDLINE];

    /// end of user input

    int bEOF = FALSE;

    //- initialize the query machine

    if (!QueryMachineInitialize(pneuro))
    {
	printf("Error initializing the query machine\n");

	return;
    }

    //- loop while user input

    do
    {
	//- accept input

	QueryMachineInput(pcCommandLine, iReadline);

	//- handle input

	bEOF = QueryMachineHandle(pneuro, pcCommandLine);
    }
    while (!bEOF);
}


