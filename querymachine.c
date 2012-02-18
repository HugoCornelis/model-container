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


typedef
int QueryHandler
    (char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData);


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


static QueryHandler QueryHandlerAlgorithmClass;
static QueryHandler QueryHandlerAlgorithmInstance;
static QueryHandler QueryHandlerAlgorithmInstantiate;
static QueryHandler QueryHandlerAlgorithmSet;
static QueryHandler QueryHandlerAllocations;
static QueryHandler QueryHandlerBiogroup2Biolevel;
static QueryHandler QueryHandlerBiolevel2Biogroup;
static QueryHandler QueryHandlerContextInfo;
static QueryHandler QueryHandlerContextSubtract;
static QueryHandler QueryHandlerCountAliases;
static QueryHandler QueryHandlerCountAllocatedSymbols;
static QueryHandler QueryHandlerDelete;
static QueryHandler QueryHandlerEcho;
static QueryHandler QueryHandlerExpand;
static QueryHandler QueryHandlerExport;
static QueryHandler QueryHandlerInsert;
static QueryHandler QueryHandlerInputInfo;
static QueryHandler QueryHandlerHelpCommands;
static QueryHandler QueryHandlerImportFile;
static QueryHandler QueryHandlerImportedFiles;
static QueryHandler QueryHandlerListSymbols;
static QueryHandler QueryHandlerMesh;
static QueryHandler QueryHandlerNameSpaces;
static QueryHandler QueryHandlerPQCount;
static QueryHandler QueryHandlerPQCountPre;
static QueryHandler QueryHandlerPQGet;
static QueryHandler QueryHandlerPQLoad;
static QueryHandler QueryHandlerPQSave;
static QueryHandler QueryHandlerPQSet;
static QueryHandler QueryHandlerPQSetAll;
static QueryHandler QueryHandlerPQTraverse;
/* static QueryHandler QueryHandlerParameterOperator; */
static QueryHandler QueryHandlerPartition;
static QueryHandler QueryHandlerPidinStackMatch;
static QueryHandler QueryHandlerPrintCellCount;
static QueryHandler QueryHandlerPrintChildren;
static QueryHandler QueryHandlerPrintConnectionCount;
static QueryHandler QueryHandlerPrintCoordinates;
static QueryHandler QueryHandlerPrintInfo;
static QueryHandler QueryHandlerPrintParameter;
static QueryHandler QueryHandlerPrintParameterInfo;
static QueryHandler QueryHandlerPrintParameterInput;
static QueryHandler QueryHandlerPrintParameterScaled;
static QueryHandler QueryHandlerPrintParameterSet;
static QueryHandler QueryHandlerPrintSegmentCount;
static QueryHandler QueryHandlerPrintSpikeReceiverCount;
static QueryHandler QueryHandlerPrintSpikeReceiverSerialID;
static QueryHandler QueryHandlerPrintSpikeSenderCount;
static QueryHandler QueryHandlerPrintSymbolParameters;
static QueryHandler QueryHandlerProjectionQuery;
static QueryHandler QueryHandlerProjectionQueryCount;
static QueryHandler QueryHandlerRecalculate;
static QueryHandler QueryHandlerReduce;
static QueryHandler QueryHandlerResolveSolverID;
static QueryHandler QueryHandlerSegmenterLinearize;
static QueryHandler QueryHandlerSegmenterParentCount;
static QueryHandler QueryHandlerSegmenterSetBase;
static QueryHandler QueryHandlerSegmenterTips;
static QueryHandler QueryHandlerSerialID;
static QueryHandler QueryHandlerSerialMapping;
static QueryHandler QueryHandlerSerialToContext;
static QueryHandler QueryHandlerSerializeForestspace;
static QueryHandler QueryHandlerSetParameter;
static QueryHandler QueryHandlerSetParameterConcept;
static QueryHandler QueryHandlerSolverGet;
static QueryHandler QueryHandlerSolverRegistrations;
static QueryHandler QueryHandlerSolverSet;
static QueryHandler QueryHandlerSymbolPrintParameterTraversal;
static QueryHandler QueryHandlerValidateSegmentGroup;
static QueryHandler QueryHandlerVersion;
static QueryHandler QueryHandlerWriteLibrary;
static QueryHandler QueryHandlerWriteModular;
static QueryHandler QueryHandlerWriteSymbol;


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


// copied from GNU libc.
// modified : 
//	- const *x, *y
//	- changed to ANSI/ISO arg passing.

/* Subtract the `struct timeval' values X and Y,
**   storing the result in RESULT.
**   Return 1 if the difference is negative, otherwise 0.  */
     
static int
timeval_subtract
(struct timeval *result, struct timeval *x, struct timeval *y)
{
    // copy y before modifications

    struct timeval tv = *y;

    /* Perform the carry for the later subtraction by updating Y. */
    if (x->tv_usec < tv.tv_usec) {
	int nsec = (tv.tv_usec - x->tv_usec) / 1000000 + 1;
	tv.tv_usec -= 1000000 * nsec;
	tv.tv_sec += nsec;
    }
    if (x->tv_usec - tv.tv_usec > 1000000) {
	int nsec = (x->tv_usec - tv.tv_usec) / 1000000;
	tv.tv_usec += 1000000 * nsec;
	tv.tv_sec -= nsec;
    }
     
    /* Compute the time remaining to wait.
       `tv_usec' is certainly positive. */
    result->tv_sec = x->tv_sec - tv.tv_sec;
    result->tv_usec = x->tv_usec - tv.tv_usec;
     
    /* Return 1 if result is negative. */
    return x->tv_sec < tv.tv_sec;
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle allocation info query
/// 



static int QueryHandlerAllocations
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

#if !defined(__APPLE__)

    //- get memory statistics

    struct mallinfo mi;

    mi = mallinfo();

    //- diag's

    fprintf(stdout, "This is the total size of memory allocated with `sbrk' by\n");
    fprintf(stdout, "`malloc', in bytes.\n");
    fprintf(stdout, "\t\t`int arena' = %i\n",mi.arena);

    fprintf(stdout, "This is the number of chunks not in use.  (The storage\n");
    fprintf(stdout, "allocator internally gets chunks of memory from the operating\n");
    fprintf(stdout, "system, and then carves them up to satisfy individual\n");
    fprintf(stdout, "`malloc' requests; see *Note Efficiency and Malloc::.)\n");
    fprintf(stdout, "\t\t`int ordblks' = %i\n",mi.ordblks);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int smblks' = %i\n",mi.smblks);

    fprintf(stdout, "This is the total number of chunks allocated with `mmap'.\n");
    fprintf(stdout, "\t\t`int hblks' = %i\n",mi.hblks);

    fprintf(stdout, "This is the total size of memory allocated with `mmap', in\n");
    fprintf(stdout, "bytes.\n");
    fprintf(stdout, "\t\t`int hblkhd' = %i\n",mi.hblkhd);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int usmblks' = %i\n",mi.usmblks);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int fsmblks' = %i\n",mi.fsmblks);

    fprintf(stdout, "This is the total size of memory occupied by chunks handed\n");
    fprintf(stdout, "out by `malloc'.\n");
    fprintf(stdout, "\t\t`int uordblks' = %i\n",mi.uordblks);

    fprintf(stdout, "This is the total size of memory occupied by free (not in\n");
    fprintf(stdout, "use) chunks.\n");
    fprintf(stdout, "\t\t`int fordblks' = %i\n",mi.fordblks);

    fprintf(stdout, "This is the size of the top-most, releaseable chunk that\n");
    fprintf(stdout, "normally borders the end of the heap (i.e. the \"brk\" of the\n");
    fprintf(stdout, "process).\n");
    fprintf(stdout, "\t\t`int keepcost' = %i\n",mi.keepcost);

    fprintf(stdout, "\n");

#else

    fprintf(stdout,"Memory reporting not available in MAC OSX.\n");

#endif

    //- return result

    return(bResult);
}




/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Bio group 2 bio level conversion.
/// 

static int QueryHandlerBiogroup2Biolevel
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- default no group

    int iGroup = -1;

    //- check command line for extra argument

    if (pcLine[iLength] == '\0'
	|| pcLine[iLength + 1] == '\0')
    {
	return(FALSE);
    }

    //- attempt to parse integer

    if (pcLine[iLength + 1] >= '0'
	&& pcLine[iLength + 1] <= '9')
    {
	iGroup = atoi(&pcLine[iLength + 1]);
    }

    //- attempt to parse element context

    else if (pcLine[iLength + 1] == '/')
    {
	//- find symbol

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength + 1]);

	struct symtab_HSolveListElement *phsle
	    = PidinStackLookupTopSymbol(ppist);

	PidinStackFree(ppist);

	if (!phsle)
	{
	    fprintf(stdout, "symbol not found\n");

	    return(FALSE);
	}

	//- get group of symbol

	iGroup = piBiolevel2Biolevelgroup[SymbolType2Biolevel(phsle->iType) / DIVIDER_BIOLEVEL];
    }

    //- or attempt to parse a literal biogroup string

    else
    {
	iGroup = Biolevelgroup(&pcLine[iLength + 1]);
    }

    //- if group was found

    if (iGroup > 0)
    {
	int iLevel = piBiolevelgroup2Biolevel[iGroup / DIVIDER_BIOLEVELGROUP];

	//- report group and matching level

	fprintf(stdout, "biogroup %s has %s as lowest component\n",ppcBiolevelgroup[iGroup / DIVIDER_BIOLEVELGROUP], ppcBiolevel[iLevel / DIVIDER_BIOLEVEL]);
    }
    else
    {
	//- diag's

	fprintf(stdout, "Unable to resolve biogroup %i\n",iGroup);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Bio level 2 bio group conversion.
/// 

static int QueryHandlerBiolevel2Biogroup
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- default no level

    int iLevel = -1;

    //- check command line for extra argument

    if (pcLine[iLength] == '\0'
	|| pcLine[iLength + 1] == '\0')
    {
	return(FALSE);
    }

    //- attempt to parse integer

    if (pcLine[iLength + 1] >= '0'
	&& pcLine[iLength + 1] <= '9')
    {
	iLevel = atoi(&pcLine[iLength + 1]);
    }

    //- attempt to parse element context

    else if (pcLine[iLength + 1] == '/')
    {
	//- find symbol

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength + 1]);

	struct symtab_HSolveListElement *phsle
	    = PidinStackLookupTopSymbol(ppist);

	PidinStackFree(ppist);

	if (!phsle)
	{
	    fprintf(stdout, "symbol not found\n");

	    return(FALSE);
	}

	//- get level of symbol

	iLevel = SymbolType2Biolevel(phsle->iType);
    }

    //- or attempt to parse a literal biolevel string

    else
    {
	iLevel = Biolevel(&pcLine[iLength + 1]);
    }

    //- if level was found

    if (iLevel > 0)
    {
	int iGroup = piBiolevel2Biolevelgroup[iLevel / DIVIDER_BIOLEVEL];

	//- report group and matching level

	fprintf(stdout, "biolevel %s has %s as biogroup\n",ppcBiolevel[iLevel / DIVIDER_BIOLEVEL], ppcBiolevelgroup[iGroup / DIVIDER_BIOLEVELGROUP]);
    }
    else
    {
	//- diag's

	fprintf(stdout, "Unable to resolve biolevel %i\n",iLevel);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle context info query.
/// 

static int QueryHandlerContextInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup child symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle1
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    struct symtab_HSolveListElement *phsle2
	= PidinStackLookupTopSymbol(ppist);

    fprintf(stdout, "---\n- parsed context: ");

    PidinStackPrint(ppist, stdout);

    fprintf(stdout, "\n");

    if (phsle1)
    {
	fprintf(stdout, "- found using SymbolsLookupHierarchical()\n");
    }
    else
    {
	fprintf(stdout, "- not found using SymbolsLookupHierarchical()\n");
    }

    if (phsle2)
    {
	fprintf(stdout, "- found using PidinStackLookupTopSymbol()\n");
    }
    else
    {
	fprintf(stdout, "- not found using PidinStackLookupTopSymbol()\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle context subtraction query.
/// 

static int QueryHandlerContextSubtract
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppist3 = NULL;

    char pc3[1000];

    //- get first pidinstack

    struct PidinStack *ppist1 = PidinStackParse(&pcLine[iLength]);

    //- get second pidinstack

    /// \note will core for invalid command lines

    struct PidinStack *ppist2
	= PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));

    //- subtract two contexts

    ppist3 = PidinStackSubtract(ppist1, ppist2);

    PidinStackString(ppist3, pc3, 1000);

    fprintf(stdout, "---\n");

    fprintf(stdout, "first-second: %s\n", pc3);

    PidinStackFree(ppist3);

    //- subtract two contexts, reverse order

    ppist3 = PidinStackSubtract(ppist2, ppist1);

    PidinStackString(ppist3, pc3, 1000);

    fprintf(stdout, "second-first: %s\n", pc3);

    PidinStackFree(ppist3);

    //- free memory

    PidinStackFree(ppist2);
    PidinStackFree(ppist1);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle aliases query
/// 

static int QueryHandlerCountAliases
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get total number of created aliases

    int iCreatedAliases = SymbolGetNumberOfAliases();

    //- get number of created aliases by type

    int * piCreatedAliases = SymbolGetArrayOfNumberOfAliases();

    //- give results

    int i;

    fprintf(stdout, "  0\tcreated aliases of type\tthe empty type(0)\n");

    for (i = 1 ; i < piCreatedAliases[0] ; i++)
    {
	fprintf
	    (stdout,
	     "  %i\tcreated aliases of type\t%s(%i)\n",
	     piCreatedAliases[i],
	     SymbolHSLETypeDescribe(i),
	     i);
    }

    fprintf(stdout, "  %i created aliases\n", iCreatedAliases);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle allocated symbols query
/// 

static int QueryHandlerCountAllocatedSymbols
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print total number of allocated symbols

    fprintf(stdout, "  %i total allocated symbols\n", iTotalAllocatedSymbols);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Delete a component
///
/// \details 
/// 
///	delete <symbol>
/// 

static
int
QueryHandlerDelete
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup child symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleChild
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- lookup parent symbol

    PidinStackPop(ppist);

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleParent
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if both found

    if (phsleParent && phsleChild)
    {
	//- delete child

	if (SymbolDeleteChild(phsleParent, phsleChild))
	{
	    //- recalc serials

	    SymbolRecalcAllSerials(NULL, NULL);
	}
	else
	{
	    fprintf(stdout, "error during deletion\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Echo args to the terminal.
///
/// \details 
/// 
///	echo <something>
/// 

static
int
QueryHandlerEcho
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print to terminal

    puts(&pcLine[iLength]);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Expand a wildcard.
///
/// \details 
/// 
///	expand <wildcard>
/// 

static
int 
QueryMachineWildcardTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct PidinStack *ppistWildcard
	= (struct PidinStack *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- give diag's

    char pc[1000];

    PidinStackString(ptstr->ppist, pc, 1000);

    fprintf(stdout, "- %s\n", pc);

    //- return result

    return(iResult);
}


static
int
QueryHandlerExpand
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = 1;

    struct symtab_HSolveListElement *phsle = NULL;

    struct symtab_HSolveListElement *phsleTraversal = NULL;

    struct PidinStack *ppistTraversal = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- check if we can find a selector

    struct symtab_IdentifierIndex *pidin = PidinStackElementPidin(ppist, 0);

    if (!pidin)
    {
	fprintf(stdout, "no symbols selector found\n");

	return(FALSE);
    }
 
    //- if the wildcard is namespaced

    if (PidinStackIsNamespaced(ppist))
    {
	//- find namespace

	struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

	if (!pif)
	{
	    fprintf(stdout, "cannot find namespace\n");

	    return(0);
	}

	struct symtab_RootSymbol *prootNamespace = ImportedFileGetRootSymbol(pif);

	//- set variables for traversal

	phsleTraversal = &prootNamespace->hsle;
	ppistTraversal = PidinStackDuplicate(ppist);

	//- convert full context to one with only namespaces

	if (PidinStackNumberOfEntries(ppistTraversal))
	{
	    struct symtab_IdentifierIndex *pidinTraversal
		= PidinStackTop(ppistTraversal);

	    //- pop all elements that are part of the wildcard

	    while (pidinTraversal && !IdinIsNamespaced(pidinTraversal))
	    {
		PidinStackPop(ppistTraversal);

		pidinTraversal
		    = PidinStackTop(ppistTraversal);
	    }
	}
    }

    //- without namespace

    else
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    fprintf(stdout, "cannot allocate a context\n");

	    return(0);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	//- set variables for traversal

	phsleTraversal = phsleRoot;
	ppistTraversal = ppistRoot;
    }

    //- if there is a symbol candidate for traversal

    /// \note so phsleRoot can be NULL if the model description file was not found

    if (phsleTraversal)
    {
	//- start yaml output

	fprintf(stdout, "---\n");

	//- traverse symbols that match with wildcard

	int iResult
	    = SymbolTraverseWildcard
	      (phsleTraversal,
	       ppistTraversal,
	       ppist,
	       QueryMachineWildcardTraverser,
	       NULL,
	       NULL);

	if (iResult != 1)
	{
	    fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");
	}
    }
    else
    {
	//- diag's

	fprintf(stdout, "no model loaded\n");
    }

    //- free allocated memory

    PidinStackFree(ppistTraversal);
    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Export a model in one of the available formats.
///
/// \details 
/// 
///	export <flags> <info|ndf|xml> <filename> <wildcard> <symbol>
/// 

static
int
QueryHandlerExport
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result: ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get flags

    int iFlags = -1;

    char pcSeparator[] = " \t,;\n";

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "export flags not specified on command line\n");

	return(FALSE);
    }

    char *pcFlags = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    if (strcmp(pcFlags, "all") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL;
    }
    else if (strcmp(pcFlags, "all_library") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_LIBRARY;
    }
    else if (strcmp(pcFlags, "all_library_names") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_LIBRARY | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "all_names") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "library") == 0)
    {
	iFlags = EXPORTER_FLAG_LIBRARY;
    }
    else if (strcmp(pcFlags, "library_names") == 0)
    {
	iFlags = EXPORTER_FLAG_LIBRARY | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "names") == 0)
    {
	iFlags = EXPORTER_FLAG_NAMESPACES;
    }
    else
    {
	iFlags = 0;
    }

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "export type not specified on command line\n");

	return(FALSE);
    }

    //- get type

    int iType = -1;

    char *pcType = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    iLength++;

    if (strcmp(pcType, "info") == 0)
    {
	iType = EXPORTER_TYPE_INFO;
    }
    else if (strcmp(pcType, "ndf") == 0)
    {
	iType = EXPORTER_TYPE_NDF;
    }
    else if (strcmp(pcType, "xml") == 0)
    {
	iType = EXPORTER_TYPE_XML;
    }
    else
    {
	iType = -1;
    }

    if (iType == -1)
    {
	fprintf(stdout, "export of type %s not supported\n", pcType);

	return(FALSE);
    }

    //- parse filename

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "filename not found on command line\n");

	return(FALSE);
    }

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "wildcard not found on command line\n");

	return(FALSE);
    }

    char *pcFilename = &pcLine[iLength];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "wildcard not found on command line\n");

	return(FALSE);
    }

    pcLine[iLength] = '\0';

    iLength++;

/*     char *pcNamespace = &pcLine[iLength + 1]; */

/*     if (strpbrk(&pcLine[iLength + 1], pcSeparator)) */
/*     { */
/* 	strpbrk(&pcLine[iLength + 1], pcSeparator)[0] = '\0'; */
/*     } */

    //- parse command line element

    struct PidinStack *ppistWildcard = PidinStackParse(&pcLine[iLength]);

    //- if the wildcard is namespaced

    struct symtab_IdentifierIndex *pidinWildcard = PidinStackElementPidin(ppistWildcard, 0);

    if (!pidinWildcard)
    {
	fprintf(stdout, "no symbols selector found\n");

	return(FALSE);
    }

    if (IdinIsNamespaced(pidinWildcard))
    {
	fprintf(stdout, "wildcard expansion cannot be combined with namespaces.\n");

	return(FALSE);
    }

    int iSuccess = SymbolRecalcAllSerials(NULL, NULL);

    if (!iSuccess)
    {
	fprintf(stdout, "SymbolRecalcAllSerials() failed, output in %s may be incorrect.", pcFilename);

	return(FALSE);
    }

    //- export model

    int iExported = ExporterModel(ppistWildcard, iType, iFlags, pcFilename);

    if (!iExported)
    {
	return(FALSE);
    }

    //- free allocated memory

    PidinStackFree(ppistWildcard);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Insert a new component.
///
/// \details 
/// 
///	insert <source> <target>
/// 

static
int
QueryHandlerInsert
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppistSource = PidinStackParse(&pcLine[iLength]);

    //- get target context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a target\n");

	return(FALSE);
    }

    struct PidinStack *ppistTarget = PidinStackParse(pcBreak);

    //- lookup source symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleSource
	= SymbolsLookupHierarchical(pneuro->psym, ppistSource);

    if (!phsleSource)
    {
	fprintf(stdout, "source symbol not found\n");

	return(FALSE);
    }

    //- register the name of the target

    struct symtab_IdentifierIndex *pidinTarget
	= PidinStackPop(ppistTarget);

    //- lookup target symbol

    struct symtab_HSolveListElement *phsleTarget
	= SymbolsLookupHierarchical(pneuro->psym, ppistTarget);

    if (!phsleTarget)
    {
	fprintf(stdout, "target symbol not found\n");

	return(FALSE);
    }

    //- create an alias of the source

    struct symtab_IdentifierIndex *pidinNew
	= IdinCallocUnique(IdinName(pidinTarget));

    //t have to fill in namespace

    struct symtab_HSolveListElement *phsleAlias
	= SymbolCreateAlias(phsleSource, NULL, pidinNew);

    //- disable traversals of the alias

    SymbolSetOptions
	(phsleAlias, (SymbolGetOptions(phsleAlias) | BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL));

    //- link the alias into the symbol table

    int iSuccess1 = SymbolAddChild(phsleTarget, phsleAlias);

    if (!iSuccess1)
    {
	fprintf(stdout, "SymbolAddChild() failed\n");

	return(FALSE);
    }

    int iSuccess2 = SymbolRecalcAllSerials(NULL, NULL);

    if (!iSuccess2)
    {
	fprintf(stdout, "SymbolRecalcAllSerials() failed");

	return(FALSE);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print information about an input.
///
/// \details 
/// 
///	input-info <wildcard>
/// 

static
int
QueryHandlerInputInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(ppist);

    if (phsle)
    {
	if (instanceof_bio_comp(phsle))
	{
	    int i = 0;

	    struct symtab_BioComponent *pbio
		= (struct symtab_BioComponent *)phsle;

	    //- construct all input types

	    fprintf(stdout, "inputs:\n");

	    while (pbio)
	    {
		//- if input info

		struct symtab_IOContainer *pioc = SymbolGetInputs(phsle);

		if (pioc)
		{
		    //- loop over inputs

		    struct symtab_InputOutput *pio = IOContainerIterateRelations(pioc);

		    for ( ; pio ; i++)
		    {
			char pc[100];

			//- get info about input

			struct symtab_HSolveListElement *phsleInput = SymbolGetChildFromInput(phsle, pio);

			//- print info about input

			IdinFullName(pio->pidinField, pc);

			fprintf
			    (stdout,
			     "%s input %i: %s, %s\n",
			     SymbolName(&pbio->ioh.iol.hsle),
			     i,
			     pc,
			     phsleInput
			     ? SymbolHSLETypeDescribe(phsleInput->iType)
			     : "child not defined in this context");

			//- go to next input

			pio = IOContainerNextRelation(pio);
		    }
		}

		//- next prototype

		pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol is not a biocomponent\n");
	}
    }
    else
    {
	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle print query
/// 

static int QueryHandlerImportedFiles
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    /// \note remember if ppist is zero length, root namespace ('::') is default.
    /// \note this lookup is neglected in the rest of this function.

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- print imported table to stdout

    SymbolsPrintImportedFiles(pneuro->psym,stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args.
/// 
/// \return int : QueryHandler return value.
/// 
/// \brief Import a file.
/// 

static
int
QueryHandlerImportFile
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse filename

    char pcSeparator[] = " \t,;\n";

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "filename not found on command line\n");

	return(FALSE);
    }

    char *pcFilename = &pcLine[iLength + 1];

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "namespace not found on command line\n");

	return(FALSE);
    }

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "namespace not found on command line\n");

	return(FALSE);
    }

    pcLine[iLength] = '\0';

    char *pcNamespace = &pcLine[iLength + 1];

    if (strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	strpbrk(&pcLine[iLength + 1], pcSeparator)[0] = '\0';
    }

    //- allocate memory for permanent storage

    pcFilename = strdup(pcFilename);

    pcNamespace = strdup(pcNamespace);

    //- qualify the filename

    char *pcQualified = ParserContextQualifyFilename(NULL, pcFilename);

    fprintf(stdout, "importing file %s as %s\n", pcFilename, pcQualified);

    //- import the file

    if (!ParserImport(pneuro->pacRootContext, pcQualified, pcFilename, pcNamespace))
    {
	fprintf(stdout, "importing file %s failed\n", pcFilename);
    }
    else
    {
	fprintf(stdout, "importing file %s ok\n", pcFilename);
    }

    //- return result

    return(bResult);
}


/// 
/// \return void
/// 
/// \brief print info on commands
/// 

static int QueryHandlerHelpCommands
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    int i;

    //- print help on commands

    fprintf(stdout, "-------------------- \n\n");
    fprintf(stdout, "Available commands : \n\n");

    for (i = 0 ; pquhasTable[i].pcCommand ; i++)
    {
	fprintf(stdout, "%s\n",pquhasTable[i].pcCommand);
    }

    fprintf(stdout, "-------------------- \n\n");
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle print query
/// 

static int QueryHandlerListSymbols
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- if found

    if (pif)
    {
	//- print namespaces to stdout

	ImportedFilePrint(pif, 0, EXPORTER_TYPE_INFO, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "no imported file with given namespace found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Mesh a cell or group of segments.
/// 

static int QueryHandlerMesh
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse maximum length

    char pcSeparator[] = " \t,;\n";

    char *pcLength = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcLength)
    {
	fprintf(stdout, "maximum length not found on command line\n");

	return(FALSE);
    }

    pcLength++;

    double dLength = strtod(pcLength, NULL);

    if (dLength == 0.0)
    {
	fprintf(stdout, "length of 0.0 not allowed\n");

	return(FALSE);
    }

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    if (!phsle)
    {
	fprintf(stdout, "symbol not found\n");

	PidinStackFree(ppist);

	return(FALSE);
    }

    //- if this is a segmenter

    if (instanceof_segmenter(phsle))
    {
	//- call the segmentation routine

	struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	SymbolMesherOnLength(&psegr->bio.ioh.iol.hsle, ppist, dLength);
    }
    else
    {
	fprintf(stdout, "symbol is not a segmenter\n");

	PidinStackFree(ppist);

	return(FALSE);
    }

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle namespaces query.
/// 

static int QueryHandlerNameSpaces
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- if found

    if (pif)
    {
	//- print namespaces to stdout

	ImportedFilePrintNameSpaces(pif, 0, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "no imported file with given namespace found\n");
    }

    //- free allocated memory

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

static int QueryHandlerAlgorithmClass
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

    char *pcName = &pcLine[iLength];

    if (pcName[0] != '\0')
    {
	pcName++;
    }

    bResult = AlgorithmSetClassPrint(pneuro->psym->pas, pcName, stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

static int QueryHandlerAlgorithmInstance
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

    char *pcName = &pcLine[iLength];

    if (pcName[0] != '\0')
    {
	pcName++;
    }

    bResult = AlgorithmSetInstancePrint(pneuro->psym->pas, pcName, stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Instantiate an algorithm interactively.
/// 

static int QueryHandlerAlgorithmInstantiate
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

/*     GENESIS3::Commands::querymachine("algorithminstantiate Grid3D createmap_$target $prototype $positionX $positionY 0 $deltaX $deltaY 0"); */

    //- get algorithm name

    char pcSeparator[] = " \t,;\n";

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "prototype symbol not specified on the commandl line\n");

	return(FALSE);
    }

    char *pcName = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "instance name not specified on command line\n");

	return(FALSE);
    }

    //- get instance name

    char *pcInstance = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    struct symtab_Parameters *ppar = NULL;

    struct symtab_AlgorithmSymbol *palgs = NULL;

    if (0 == strcmp(pcName, "Grid3D"))
    {
	//- get target name

	char *pcTarget = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	//- get prototype name

	char *pcPrototype = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	//- get x count

	char *pcXCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dXCount = strtod(pcXCount, NULL);

	//- get y count

	char *pcYCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dYCount = strtod(pcYCount, NULL);

	//- get z count

	char *pcZCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dZCount = strtod(pcZCount, NULL);

	//- get x distance

	char *pcXDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dXDistance = strtod(pcXDistance, NULL);

	//- get y distance

	char *pcYDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dYDistance = strtod(pcYDistance, NULL);

	//- get z distance

	char *pcZDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	if (iLength >= 0)
	{
	    pcLine[iLength] = '\0';
	}

	double dZDistance = strtod(pcZDistance, NULL);

	//! see also the ns-sli for other examples of the usage of this function

	struct symtab_ParContainer *pparcAlgorithm
	    = ParContainerNewFromList
	      (/* ParameterNewFromString("INSTANCE_NAME", pcInstanceTemplate), */
		ParameterNewFromString("PROTOTYPE", pcPrototype),
		ParameterNewFromNumber("X_DISTANCE", dXDistance),
		ParameterNewFromNumber("Y_DISTANCE", dYDistance),
		ParameterNewFromNumber("Z_DISTANCE", dZDistance),
		ParameterNewFromNumber("X_COUNT", dXCount),
		ParameterNewFromNumber("Y_COUNT", dYCount),
		ParameterNewFromNumber("Z_COUNT", dZCount),
		NULL);

	ppar = pparcAlgorithm->ppars;
    }

    //- preparation, in the parser this happens with a push

    struct AlgorithmInstance *palgi = NULL;

    if (1)
    {
	//- import & init algorithm

	//t error checking

	struct symtab_AlgorithmSymbol *palgs
	    = AlgorithmSymbolCalloc();

	AlgorithmSymbolAssignParameters(palgs, ppar);

	palgi
	    = ParserAlgorithmImport
	      (pneuro->pacRootContext,
	       pcName,
	       pcInstance,
	       ppar,
	       palgs);

	if (palgi)
	{
	    AlgorithmSymbolSetAlgorithmInstance(palgs, palgi);

/* 	ParserContextPushAlgorithmState(palgs); */
/* 	ParserContextPushAlgorithmState(palgi); */
/* 	ParserContextPushAlgorithmState($3); */
/* 	ParserContextPushAlgorithmState($4); */

/* 	ParserContextPushAlgorithmState(PARSERSTATE_ALGORITHM); */

	    //- insert algorithm instance in the symbol table

	    //t I prefer to move this code to the
	    //t AlgorithmListPush non-terminal, but that
	    //t does not work because
	    //t ParserContextGetActual() sometimes returns
	    //t NULL overthere, don't know why.

	    struct symtab_HSolveListElement *phsleActual
		= ParserContextGetActual(pneuro->pacRootContext);

	    SymbolAddChild(phsleActual, &palgs->hsle);
	}
	else
	{
	    NeurospacesError
		(pneuro->pacRootContext,
		 "AlgorithmListPush",
		 " Failed to import algorithm (%s)",
		 pcName);
	}
    }

    //- handling, in the parser this happens with a pop

    if (1)
    {
	//- while algorithms on context stack

/* 	while ((pvState = ParserContextPopAlgorithmState()) */
/* 	       != PARSERSTATE_START_ALGORITHMS) */
	{
	    //- pop algorithm info

/* 	    char *pcInstance = (char *)ParserContextPopAlgorithmState(); */
/* 	    char *pcName = (char *)ParserContextPopAlgorithmState(); */
/* 	    struct AlgorithmInstance *palgi */
/* 		= (struct AlgorithmInstance *) */
/* 		  ParserContextPopAlgorithmState(); */

/* 	    struct symtab_AlgorithmSymbol *palgs */
/* 		= (struct symtab_AlgorithmSymbol *) */
/* 		  ParserContextPopAlgorithmState(); */

	    //- if algorithm handlers are not disabled by the options

	    if (!(pneuro->pacRootContext->pneuro->pnsc->nso.iFlags & NSOFLAG_DISABLE_ALGORITHM_HANDLING))
	    {
		//- call algorithm on current symbol

		ParserAlgorithmHandle
		    (pneuro->pacRootContext,
		     ParserContextGetActual(pneuro->pacRootContext),
		     palgi,
		     pcName,
		     pcInstance);
	    }

	    //t I could free pcName, pcInstance here ?

/* 			//- insert algorithm instance in the symbol table */

/* 			//t I prefer to move this code to the */
/* 			//t AlgorithmListPush non-terminal, but that */
/* 			//t does not work because */
/* 			//t ParserContextGetActual() sometimes returns */
/* 			//t NULL overthere, don't know why. */

/* 			//t it looks like that the symbol that should */
/* 			//t go into phsleActual is allocated to late, ie */
/* 			//t in .*Description, and AlgorithmListPush is */
/* 			//t called for in .*Front.  But, in .*Front the */
/* 			//t type of the symbol to be allocated is */
/* 			//t already known, so it is possible to allocate */
/* 			//t the correct symbol type, and put it in */
/* 			//t phsleActual. */

/* 			struct symtab_HSolveListElement *phsleActual */
/* 			    = ParserContextGetActual((PARSERCONTEXT *)pacParserContext); */

/* 			SymbolAddChild(phsleActual, &palgs->hsle); */

/* 			int iResult = ParserAddModel((PARSERCONTEXT *)pacParserContext, &palgs->hsle); */

/* 			if (!iResult) */
/* 			{ */
/* 			    NeurospacesError */
/* 				((PARSERCONTEXT *)pacParserContext, */
/* 				 "AlgorithmListPush", */
/* 				 "Error inserting algorithm instance (%s) in symbol table (class %s).", */
/* 				 $3, */
/* 				 $5); */
/* 			} */

	    //- disable the algorithm

	    ParserAlgorithmDisable
		(pneuro->pacRootContext,
		 palgi,
		 pcName,
		 pcInstance);
	}

/* 	//- sanity check :  */
/* 	//- pvState should be PARSERSTATE_START_ALGORITHMS here */

/* 	if (pvState != PARSERSTATE_START_ALGORITHMS) */
/* 	{ */
/* 	    NeurospacesError */
/* 		((PARSERCONTEXT *)pacParserContext, */
/* 		 "AlgorithmListPop", */
/* 		 " Internal error :" */
/* 		 " non-terminal AlgorithmListPop encounters" */
/* 		 " messed up algorithm stack\n" */
/* 		 " Internal error : Expecting" */
/* 		 " PARSERSTATE_START_ALGORITHMS (== %i)," */
/* 		 " encountered %i\n\n", */
/* 		 PARSERSTATE_START_ALGORITHMS, */

/* 		 //t gives a warning on 64bit machines. */

/* 		 (int)pvState); */

/* 	    //- dump core  */
/* 	    //- (should contain interesting info to be examined) */

/* 	    *(int *)NULL = 0xdeadbeaf; */
/* 	} */
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

static int QueryHandlerAlgorithmSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = AlgorithmSetPrint(pneuro->psym->pas,stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Partition a model (and cache the result for later use).
///
/// \details 
/// 
///	partition <context> <partitions> <this-node>
/// 

static int QueryHandlerPartition
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse number of partitions needed

    char pcSeparator[] = " \t,;\n";

    char *pcPartitions = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPartitions)
    {
	fprintf(stdout, "number of partition nodes not found on command line\n");

	return(FALSE);
    }

    pcPartitions++;

    int iPartitions = strtol(pcPartitions, (char **)NULL, 0);

    //- parse number of this node

    char *pcThisNode = strpbrk(pcPartitions, pcSeparator);

    if (!pcThisNode)
    {
	fprintf(stdout, "number for this node not found on command line\n");

	return(FALSE);
    }

    pcThisNode++;

    int iThisNode = strtol(pcThisNode, (char **)NULL, 0);

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- get cumulative workload

	struct workload_info *pwi
	    = WorkloadNew(phsle, ppist, BIOLEVEL_ATOMIC, 0);

	//- if workload_cumulative ok

	if (pwi)
	{
	    WorkloadPartition(pwi, iPartitions);

	    WorkloadPrint(pwi, stdout);

/* 	    NeurospacesRegisterWorkload(pneuro, ptiWorkload, iThisNode); */

	    WorkloadFree(pwi);

	    fprintf(stdout, "workload ok\n");
	}
	else
	{
	    fprintf(stdout, "traversal failure (no children ?)\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free context info

    if (ppist)
    {
	PidinStackFree(ppist);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Match of two contexts ?
/// 

static int QueryHandlerPidinStackMatch
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get first pidinstack

    struct PidinStack *ppist1 = PidinStackParse(&pcLine[iLength]);

    //- get second pidinstack

    /// \note will core for invalid command lines

    struct PidinStack *ppist2
	= PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));

    //- diag's on matching

    if (PidinStackMatch(ppist1, ppist2))
    {
	fprintf(stdout, "Match\n");
    }
    else
    {
	fprintf(stdout, "No match\n");
    }

    //- free pidinstacks

    PidinStackFree(ppist2);
    PidinStackFree(ppist1);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Count connections in projection query.
/// 

struct QM_neuro_pq_traversal_data
{
    /// set first serial ID : 0

    int iSerial;

    /// projection query

    struct ProjectionQuery *ppq;

    /// file to write to

    FILE *pfile;
};


static int 
QueryMachineNeuroConnectionCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n", pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


static int QueryHandlerPQCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    if (strpbrk(&pcLine[iLength + 1], " \t"))
    {
	//- go to next arg

	iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

	//- parse command line element, get spike(gen|rec)

	ppistAttachment = PidinStackParse(&pcLine[iLength]);

	//- lookup attachment symbol

	/// \note allows namespacing, yet incompatible with parameter caches.

	phsleAttachment
	    = SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

	if (!phsleAttachment)
	{
	    fprintf(stdout, "attachment symbol not found\n");

	    PidinStackFree(ppistAttachment);

	    return(FALSE);
	}
    }

    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    struct QM_neuro_pq_traversal_data qtd =
	    {
		/// set count : 0

		0,

		/// projection query

		ppq2,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq2, bCaching);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	    {
		//return(FALSE);
	    }

	    //- if selective count

	    if (ppistAttachment)
	    {
		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

	    }

	    //- else

	    else
	    {
		//- traverse all connections

		ProjectionQueryTraverseConnections
		    (ppq2,
		     QueryMachineNeuroConnectionCounter,
		     NULL,
		     (void *)&qtd);
	    }

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    //- diag's

	    fprintf(stdout, "#connections = %i\n",qtd.iSerial);

	    fprintf
		(stdout,
		 "#memory used by projection query = %i\n",
		 ProjectionQueryGetMemorySize(ppq));

	    fprintf
		(stdout,
		 "#memory used by connection cache = %i\n",
		 ppq->pcc
		 ? ConnectionCacheGetMemorySize(ppq->pcc)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 1  = %i\n",
		 ppq->poccPre
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPre)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 2  = %i\n",
		 ppq->poccPost
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPost)
		 : 0 );

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	    //- free cloned projection query

	    ProjectionQueryFree(ppq2);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "No projection query defined yet.\n");
	}
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Count pre-synaptic serials in projection query.
/// 

static int QueryHandlerPQCountPre
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    fprintf(stdout, "number of pre-synaptic serials: %i\n", ProjectionQueryCountPreSerials(ppq));
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "No projection query defined yet.\n");
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print some info on registered projection query.
/// 

static int QueryHandlerPQGet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print all projections in query

    if (pneuro->ppq)
    {
	int i;

	fprintf
	    (stdout, "bCaching(%s)\n", pneuro->ppq->bCaching ? "TRUE" : "FALSE");

	fprintf
	    (stdout,
	     "pcc(%s)\n",
	     pneuro->ppq->pcc ? "available" : "not available");

	fprintf
	    (stdout,
	     "pcc->iConnections(%i)\n",
	     pneuro->ppq->pcc ? pneuro->ppq->pcc->iConnections : -1);

	fprintf
	    (stdout,
	     "poccPre(%s)\n",
	     pneuro->ppq->poccPre ? "available" : "not available");

	fprintf
	    (stdout,
	     "poccPost(%s)\n",
	     pneuro->ppq->poccPost ? "available" : "not available");

	fprintf(stdout, "iCloned(%i)\n", pneuro->ppq->iCloned);

	fprintf(stdout, "iCursor(%i)\n", pneuro->ppq->iCursor);

	for (i = 0 ; i < pneuro->ppq->iProjections ; i++)
	{
	    fprintf
		(stdout,
		 "%i -> %i : ",
		 pneuro->ppq->piSource[i],
		 pneuro->ppq->piTarget[i]);

	    PidinStackPrint(pneuro->ppq->pppist[i], stdout);

	    fprintf(stdout, "\n");
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Load a projection query from a file.
/// 

static int QueryHandlerPQLoad
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    char pcFilename[1000];

    int iSize = -1;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- get filename

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }

    //pcFilename = malloc((1 + iSize) * sizeof(char));

    strncpy(pcFilename, &pcLine[iLength + 1], iSize);

    pcFilename[iSize] = '\0';

    char *pcQualified = pcFilename;

    if (pcQualified[0] != '/')
    {
	pcQualified = ParserContextQualifyToEnvironment(pcFilename);
    }

    if (!pcQualified)
    {
	fprintf(stdout, "Could not qualify %s\n", pcFilename);

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- open file

    FILE *pfile = fopen(pcQualified, "r");;

    if (!pfile)
    {
	fprintf(stdout, "Could not open file %s\n", pcQualified);

	return(FALSE);
    }

    //- read number of connections

    int iConnections;

    int iAssigned = fscanf(pfile, "Number of connections : %i\n", &iConnections);

    if (iAssigned != 1)
    {
	fclose(pfile);

	return(FALSE);
    }

/*     //- allocate connections */

/*     struct symtab_Connection **ppconn = calloc(iConnections, sizeof(struct symtab_Connection *)); */

/*     int iCount = 0; */

/*     while (iCount < iConnections) */
/*     { */
/* 	ppconn[iCount] = ConnectionCalloc(); */

/* 	iCount++; */
/*     } */

    //- allocate connection cache

    struct ConnectionCache *pcc = ConnectionCacheNew(iConnections);

    struct CachedConnection *pcconn = pcc->pcconn;

    //- loop

    int iCount = 0;

    while (iCount < iConnections)
    {
	//- read next connection from file

	int iPre;
	int iPost;
	double dDelay;
	double dWeight;

	fscanf(pfile, "%i,%i(%lf,%lf)\n", &iPre, &iPost, &dDelay, &dWeight);

/* 	//- store connection data */

/* 	ConnectionInit(ppconn[iCount]); */

/* 	ppconn[iCount]->deconn.iPreSynaptic = iPre; */
/* 	ppconn[iCount]->deconn.iPostSynaptic = iPost; */

/* 	ppconn[iCount]->deconn.dDelay = dDelay; */
/* 	ppconn[iCount]->deconn.dWeight = dWeight; */

	//- store connection cache data

/* 	pcconn[iCount].iProjection = -1; */
/* 	pcconn[iCount].phsle = (struct symtab_HSolveListElement*)ppconn[iCount]; */

     0;
	pcconn[iCount].iPre = iPre;
	pcconn[iCount].iPost = iPost;
	pcconn[iCount].dDelay = dDelay;
	pcconn[iCount].dWeight = dWeight;

	//- increment count

	iCount++;
    }

    //- done reading from file

    fclose(pfile);

    /// \note following code nicely copied from projectionquery.c

    //- allocate projection query

    struct ProjectionQuery *ppq
	= (struct ProjectionQuery *)
	  calloc(1, sizeof(struct ProjectionQuery));

    //- set allocated memory counter

    ppq->iMemoryUsed = sizeof(struct ProjectionQuery);

    //- set caching status : must be caching

    ppq->bCaching = TRUE;

    //- block the cursor from being used

    ppq->iCursor = 100000;

    //- link the connections and the cache into the projection query

    ppq->pcc = pcc;

    //- keep track of used memory

    ppq->iMemoryUsed += ConnectionCacheGetMemorySize(ppq->pcc);

    //- initialize ordered connection caches

    if (!ProjectionQueryBuildOrderedConnectionCaches(ppq))
    {
	bResult = FALSE;
    }

    //- register projection query in neurospaces

    if (pneuro->ppq)
    {
	NeurospacesRemoveProjectionQuery(pneuro);
    }

    NeurospacesSetProjectionQuery(pneuro, ppq);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Store connections in projection query in a file.
///
/// \details 
/// 
///	pqsave <caching = c|n> <filename>
/// 

static int 
QueryMachineNeuroConnectionStore
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- get source and target for current projection

	int iSource = ProjectionQueryGetCurrentSourceSerial(pqtd->ppq);

	int iTarget = ProjectionQueryGetCurrentTargetSerial(pqtd->ppq);

	//- get pre and post for connection

	int iPre = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "PRE");

	int iPost = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "POST");

	//- get weight and delay

	double dDelay
	    = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "DELAY");

	double dWeight
	    = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "WEIGHT");

	fprintf
	    (pqtd->pfile,
	     "%i,%i(%f,%f)\n",
	     iSource + iPre,
	     iTarget + iPost,
	     dDelay,
	     dWeight);

	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n", pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


static int QueryHandlerPQSave
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    char pcFilename[1000];

    int iSize = -1;

    //- get projection query

    struct ProjectionQuery *ppq = pneuro->ppq;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- get filename

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }

    //pcFilename = malloc((1 + iSize) * sizeof(char));

    strncpy(pcFilename,&pcLine[iLength + 1],iSize);

    pcFilename[iSize] = '\0';

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- if clone projection query

    if (ppq)
    {
	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	struct QM_neuro_pq_traversal_data qtd =
	{
	    /// set first serial ID : 0

	    0,

	    /// projection query

	    ppq2,

	    /// file to write to

	    NULL,
	};

	//- give some diag's

	fprintf(stdout, "Storing connection matrix in file %s\n", pcFilename);

	//- set if projectionquery should use caches

	ProjectionQuerySetCaching(ppq2,bCaching);

	//- open output file

	qtd.pfile = fopen(pcFilename, "w");

	//- write number of connections

	int iConnections = ProjectionQueryCountConnections(ppq2);

	fprintf(qtd.pfile, "Number of connections : %i\n", iConnections);

	//- traverse connections in query

	ProjectionQueryTraverseConnections
	    (ppq2,
	     QueryMachineNeuroConnectionStore,
	     NULL,
	     (void *)&qtd);

	//- close file

	fclose(qtd.pfile);

	//- free cloned projection query

	ProjectionQueryFree(ppq2);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "No projection query defined yet.\n");
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Define a projection query.
/// 

static int QueryHandlerPQSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *pppistProjections[1000];
    int iProjections = 0;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");

	return(FALSE);
    }

    //- get projections

    for (iProjections = 0 
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	pppistProjections[iProjections]
	    = PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));
    }

    pppistProjections[iProjections] = NULL;

    {
	//- if can create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections,iProjections);

	//- failed to allocate a projection query

	if (ppq)
	{
	    //- if projection query ok

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    ProjectionQueryFree(ppq2);

	    if (ppq)
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

/* 		struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq); */

		//- set if projectionquery should use caches

		ProjectionQuerySetCaching(ppq,bCaching);

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
		{
		    //return(FALSE);
		}

		//- if should use caches

		if (bCaching)
		{
		    //- build caches

		    ProjectionQueryBuildCaches(ppq);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

		//- register projection query in neurospaces

		if (pneuro->ppq)
		{
		    NeurospacesRemoveProjectionQuery(pneuro);
		}

		NeurospacesSetProjectionQuery(pneuro, ppq);

		//- diag's

		fprintf
		    (stdout,
		     "# connections = %i\n",
		     ProjectionQueryCountConnections(ppq));
		fprintf
		    (stdout,
		     "caching = %s\n",
		     bCaching ? "yes" : "no");

		fprintf
		    (stdout,
		     "user time = %lis, %lius\n",
		     tvUser.tv_sec,
		     (long int)tvUser.tv_usec);
		fprintf
		    (stdout,
		     "system time = %lis, %lius\n",
		     tvSystem.tv_sec,
		     (long int)tvSystem.tv_usec);

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbols must be projection\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "cannot allocate projection query (no projections ?)\n");
	}
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	PidinStackFree(pppistProjections[iProjections]);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Select all projections in the model for the projection query.
/// 

struct QM_projection_collector_traversal_data
{
    /// start of traversal

    struct PidinStack *ppistStart;

    /// number of projections found

    int iProjections;

    /// contexts of projections

    struct PidinStack *pppistProjections[1000];
};


static int 
QueryMachineProjectionContextCollector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_projection_collector_traversal_data *ppcd
	= (struct QM_projection_collector_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if a projection

    if (instanceof_projection(phsle))
    {
	//- allocate a context for this projection

	int iSerial = TstrGetPrincipalSerial(ptstr);

	struct symtab_HSolveListElement *phsleStart
	    = PidinStackLookupTopSymbol(ppcd->ppistStart);

	struct PidinStack *ppistProjection
	    = SymbolPrincipalSerial2Context(phsleStart, ppcd->ppistStart, iSerial);

	//- fill in context

	ppcd->pppistProjections[ppcd->iProjections] = ppistProjection;

	//- increment the number of projections found

	ppcd->iProjections++;
    }

    //- else

    else
    {
	//- signal internal error

	fprintf
	    (stdout,
	     "Internal error : asking for only projections, also encountering %i (%s)\n",
	     phsle->iType,
	     ppc_symbols_long_descriptions[phsle->iType]);
    }

    //- return result

    return(iResult);
}


static int QueryHandlerPQSetAll
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");

	return(FALSE);
    }

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct QM_projection_collector_traversal_data pcd =
	{
	    /// start of traversal

	    ppistRoot,

	    /// number of projections found

	    0,

	    /// contexts of projections

	    { NULL, },
	};

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppistRoot,
	   SymbolProjectionSelector,
	   NULL,
	   QueryMachineProjectionContextCollector,
	   (void *)&pcd,
	   NULL,
	   NULL);

    //- traverse symbol : get projections

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    int iTraverse = TstrGo(ptstr, phsleRoot);

    //- delete treespace traversal

    TstrDelete(ptstr);

    pcd.pppistProjections[pcd.iProjections] = NULL;

    {
	//- if can create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pcd.pppistProjections, pcd.iProjections);

	//- failed to allocate a projection query

	if (ppq)
	{
	    //- if projection query ok

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    ProjectionQueryFree(ppq2);

	    if (ppq)
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

/* 		struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq); */

		//- set if projectionquery should use caches

		ProjectionQuerySetCaching(ppq,bCaching);

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
		{
		    //return(FALSE);
		}

		//- if should use caches

		if (bCaching)
		{
		    //- build caches

		    ProjectionQueryBuildCaches(ppq);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser,&ruAfter.ru_utime,&ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem,&ruAfter.ru_stime,&ruBefore.ru_stime);

		//- register projection query in neurospaces

		if (pneuro->ppq)
		{
		    NeurospacesRemoveProjectionQuery(pneuro);
		}

		NeurospacesSetProjectionQuery(pneuro, ppq);

		//- diag's

		fprintf
		    (stdout,
		     "# connections = %i\n",
		     ProjectionQueryCountConnections(ppq));
		fprintf
		    (stdout,
		     "caching = %s\n",
		     bCaching ? "yes" : "no");

		fprintf
		    (stdout,
		     "user time = %lis, %lius\n",
		     tvUser.tv_sec,
		     (long int)tvUser.tv_usec);
		fprintf
		    (stdout,
		     "system time = %lis, %lius\n",
		     tvSystem.tv_sec,
		     (long int)tvSystem.tv_usec);

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbols must be projection\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "cannot allocate projection query (no projections ?)\n");
	}
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    for (pcd.iProjections = 0 ; pcd.pppistProjections[pcd.iProjections] ; pcd.iProjections++)
    {
	PidinStackFree(pcd.pppistProjections[pcd.iProjections]);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print info on connections in global projection query.
/// 

static int 
QueryMachineNeuroConnectionTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- give diag's

	fprintf
	    (stdout,
	     "Connection (%5.5i)\n",
	     pqtd->iSerial);

/* 	fprintf */
/* 	    (stdout, */
/* 	     "----------------------------------------------------\n"); */

/* 	fprintf */
/* 	    (stdout, */
/* 	     "Projection source (%i), Projection target (%i)\n", */
/* 	     ProjectionQueryGetCurrentSourceSerial(pqtd->ppq), */
/* 	     ProjectionQueryGetCurrentTargetSerial(pqtd->ppq)); */

	if (subsetof_cached_connection(iType))
	{
	  CachedConnectionPrint(pconn, TRUE, 8, stdout);
	}
	else if (subsetof_connection(iType))
	{
	  ConnectionPrint(pconn, TRUE, 8, stdout);
	}

	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n", pqtd->iSerial);
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(iResult);
}


static int QueryHandlerPQTraverse
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iLength += strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }


    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    //- if spike(gen|rec) found

    if (phsleAttachment)
    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    struct QM_neuro_pq_traversal_data qtd =
	    {
		/// set first serial ID : 0

		0,

		/// projection query

		ppq2,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq2, bCaching);

	    //- if attachment

	    if (instanceof_attachment(phsleAttachment))
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
		{
		    //return(FALSE);
		}

		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbol must be attachment\n");
	    }

	    //- free cloned projection query

	    ProjectionQueryFree(ppq2);

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "No projection query defined yet.\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle print query
/// 

static int QueryHandlerPrintCellCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- obtain cell count

	int iCells = SymbolCountCells(phsle, ppist);

	//- print cell count

	fprintf(stdout, "Number of cells : %i\n", iCells);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle print query
/// 

static int QueryHandlerPrintChildren
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	struct symtab_IOContainer *pioc = NULL;
	struct symtab_InputOutput *pio = NULL;
	IOHContainer *piohcChildren = NULL;
	struct symtab_HSolveListElement *phsleChild = NULL;
	int i = 0;

	//- if children info

	///
	/// \note never use this to do a traversal, use std traversals instead.
	///

	piohcChildren = SymbolGetChildren((struct symtab_IOHierarchy *)phsle);

	if (piohcChildren)
	{
	    fprintf(stdout, "children (if any) :\n");

	    phsleChild = IOHContainerIterate(piohcChildren);

	    //- loop over children

	    for (i = 0 ;
		 SymbolIterateValid(phsleChild) ;
		 i++)
	    {
		char pc[100];

		//- print info about child

		IdinFullName(SymbolGetPidin(phsleChild), pc);

		fprintf
		    (stdout,
		     "Child %i : %s,%s\n",
		     i,
		     pc,
		     SymbolHSLETypeDescribe(phsleChild->iType));

		//- go to next child

		phsleChild = SymbolContainerNext(phsleChild);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol has no children\n");
	}

	//- if input info

	pioc = SymbolGetInputs(phsle);

	if (pioc)
	{
	    fprintf(stdout, "inputs (if any) :\n");

	    //- loop over inputs

	    pio = IOContainerIterateRelations(pioc);

	    for (i = 0 ; pio ; i++)
	    {
		char pc[100];

		//- get info about input

		phsleChild = SymbolGetChildFromInput(phsle, pio);

		//- print info about input

		IdinFullName(pio->pidinField, pc);

		fprintf
		    (stdout,
		     "Input %i : %s,%s\n",
		     i,
		     pc,
		     phsleChild
		     ? SymbolHSLETypeDescribe(phsleChild->iType)
		     : "Child given as input, but not defined");

		//- go to next input

		pio = IOContainerNextRelation(pio);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol has no inputs\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections in given projection.
///
/// \details 
/// 
///	connectioncount <projection symbol>
/// 

static int QueryHandlerPrintConnectionCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	int iConnections = -1;

	/// resources used before and after command executed

	struct rusage ruBefore, ruAfter;

	//- get resource usage

	if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	{
	    //return(FALSE);
	}

	//- obtain connection count

	iConnections = SymbolCountConnections(phsle, ppist);

	//- get resource usage

	if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	{
	    //return(FALSE);
	}

	//- compute time to execute query

	timeval_subtract
	    (&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	timeval_subtract
	    (&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	//- print connection count

	fprintf(stdout, "Number of connections : %i\n", iConnections);

	//- diag's

	fprintf
	    (stdout,
	     "user time = %lis, %lius\n",
	     tvUser.tv_sec,
	     (long int)tvUser.tv_usec);
	fprintf
	    (stdout,
	     "system time = %lis, %lius\n",
	     tvSystem.tv_sec,
	     (long int)tvSystem.tv_usec);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle coordinate query
///
/// \details 
/// 
///	printcoordinates <caching = c|n> <ancestor> <descendant>
/// 

static int QueryHandlerPrintCoordinates
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    struct symtab_HSolveListElement *phsle = NULL;
    struct symtab_HSolveListElement *phsleCoord = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get symbol to print coordinates for

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify two ancestor and descendant symbols\n");

	return(FALSE);
    }

    struct PidinStack *ppistCoord = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note need serial here

    phsle = PidinStackLookupTopSymbol(ppist);

    //- lookup coordinate symbol

    /// \note loads cache, ie cache is passed with parameter.

    phsleCoord = PidinStackLookupTopSymbol(ppistCoord);

    //- if both found

    if (phsle && phsleCoord)
    {
	//- if caching

	if (bCaching)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
	    {
		//return(FALSE);
	    }

	    //- init traversal for caches

	    struct TreespaceTraversal *ptstr
		= TstrNew
		  (ppist,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL);

	    //- build caches

	    struct CoordinateCache *pcc = CoordinateCacheNewForTraversal(ptstr);

	    if (CoordinateCacheBuildCaches(pcc))
	    {
		//- lookup symbol in cache

		int iAncestor = PidinStackToSerial(ppist);

		int iDescendant = PidinStackToSerial(ppistCoord);

		int iCoord = iDescendant - iAncestor;

		struct CachedCoordinate *pccrd
		    = CoordinateCacheLookup(pcc, iCoord);

		//- print results

		fprintf(stdout, "cached coordinate x = %g\n", pccrd->D3.dx);
		fprintf(stdout, "cached coordinate y = %g\n", pccrd->D3.dy);
		fprintf(stdout, "cached coordinate z = %g\n", pccrd->D3.dz);

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser,&ruAfter.ru_utime,&ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem,&ruAfter.ru_stime,&ruBefore.ru_stime);

		//- print coordinate count

		fprintf(stdout, "#coordinates : %i\n", pcc->iCoordinates);
		fprintf
		    (stdout,
		     "#memory used by coordinate cache = %i\n",
		     pcc->iMemoryUsed);

		//- diag's

		fprintf
		    (stdout,
		     "user time = %lis, %lius\n",
		     tvUser.tv_sec,
		     (long int)tvUser.tv_usec);
		fprintf
		    (stdout,
		     "system time = %lis, %lius\n",
		     tvSystem.tv_sec,
		     (long int)tvSystem.tv_usec);
	    }
	    else
	    {
		fprintf(stdout, "cannot build coordinate caches\n");
	    }

	    //- free cache

	    CoordinateCacheFree(pcc);

	    //- delete treespace traversal

	    TstrDelete(ptstr);

	}

	//- else non caching

	else
	{
	    struct D3Position D3Coord;

	    //- resolve coordinate values with default transformations

	    double x
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "X");

	    double y
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "Y");

	    double z
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "Z");

	    //- print results

	    fprintf(stdout, "transformed x = %g\n", x);
	    fprintf(stdout, "transformed y = %g\n", y);
	    fprintf(stdout, "transformed z = %g\n", z);

	    //- resolve coordinate

	    SymbolParameterResolveCoordinateValue
		(phsle, ppist, ppistCoord, &D3Coord);

	    //- print results

	    fprintf(stdout, "coordinate x = %g\n", D3Coord.dx);
	    fprintf(stdout, "coordinate y = %g\n", D3Coord.dy);
	    fprintf(stdout, "coordinate z = %g\n", D3Coord.dz);
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle print query
///
/// \details 
///
///	printinfo <type> <context>
/// 

static
int
QueryHandlerPrintInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

/*     //- get type */

/*     int iType = -1; */

/*     char pcSeparator[] = " \t,;\n"; */

/*     if (!strpbrk(&pcLine[iLength + 1], pcSeparator)) */
/*     { */
/* 	fprintf(stdout, "export type not specified on command line\n"); */

/* 	return(FALSE); */
/*     } */

/*     char *pcType = &pcLine[iLength + 1]; */

/*     iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength]; */

/*     pcLine[iLength] = '\0'; */

/*     iLength++; */

/*     if (strcmp(pcType, "info") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_INFO; */
/*     } */
/*     else if (strcmp(pcType, "ndf") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_NDF; */
/*     } */
/*     else if (strcmp(pcType, "xml") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_XML; */
/*     } */
/*     else */
/*     { */
/* 	iType = -1; */
/*     } */

/*     if (iType == -1) */
/*     { */
/* 	fprintf(stdout, "export of type %s not supported\n", pcType); */

/* 	return(FALSE); */
/*     } */

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- print info

	SymbolPrint(phsle, 4, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter-name>
/// 

static int
QueryMachineWildcardParameterTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    char *pcPar = (char *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- lookup parameter

    struct symtab_Parameters *ppar
	= SymbolFindParameter(phsle, ptstr->ppist, pcPar);

    //- if parameter found

    if (ppar)
    {
	//- give diag's

	char pc[1000];

	PidinStackString(ptstr->ppist, pc, 1000);

	fprintf(stdout, "%s->%s", pc, pcPar);

	//- for numeric indirect parameter values

	if (ParameterIsNumber(ppar)
	    || ParameterIsFunction(ppar)
	    || ParameterIsField(ppar))
	{
	    //- resolve parameter value

	    double d = ParameterResolveValue(ppar, ptstr->ppist);

	    //- print result

	    fprintf(stdout, " = %g\n", d);
	}

	//- for string parameter values

	else if (ParameterIsString(ppar))
	{
	    //- print string parameter values

	    char *pc = ParameterGetString(ppar);

	    fprintf(stdout, " = \"%s\"\n", pc);
	}
/* 	else if (ParameterIsFunction(ppar)) */
/* 	{ */
/* 	    //- give diagnostics: not implemented yet */

/* 	    fprintf(stdout, "\nreporting of function parameters is not implemented yet\n"); */
/* 	} */
/* 	else if (ParameterIsField(ppar)) */
/* 	{ */
/* 	    //- give diagnostics: not implemented yet */

/* 	    fprintf(stdout, "\nreporting of field parameters is not implemented yet\n"); */
/* 	} */

	//- otherwise

	else if (ParameterIsSymbolic(ppar))
	{
	    //- give diagnostics: not implemented yet

	    fprintf(stdout, "\nreporting of symbolic parameters is not implemented yet\n");
	}
	else if (ParameterIsAttribute(ppar))
	{
	    //- give diagnostics: not implemented yet

	    fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter1-name> <parameter2-name>
/// 

static int QueryHandlerPrintParameter
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
	    //- traverse symbols that match with wildcard

	    int iResult
		= SymbolTraverseWildcard
		  (phsleRoot,
		   ppistRoot,
		   ppist,
		   QueryMachineWildcardParameterTraverser,
		   NULL,
		   (void *)pcPar);

	    if (iResult != 1)
	    {
		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- lookup parameter

	    struct symtab_Parameters *ppar
		= SymbolFindParameter(phsle, ppist, pcPar);

	    //- if parameter found

	    if (ppar)
	    {
		//- for numeric indirect parameter values

		if (ParameterIsNumber(ppar)
		    || ParameterIsFunction(ppar)
		    || ParameterIsField(ppar))
		{
		    //- resolve parameter value

		    double d = ParameterResolveValue(ppar, ppist);

		    //- print result

		    fprintf(stdout, "value = %g\n", d);
		}

		//- for string parameter values

		else if (ParameterIsString(ppar))
		{
		    //- print string result

		    char *pc = ParameterGetString(ppar);

		    fprintf(stdout, "value = \"%s\"\n", pc);
		}
/* 		else if (ParameterIsFunction(ppar)) */
/* 		{ */
/* 		    //- give diagnostics: not implemented yet */

/* 		    fprintf(stdout, "\nreporting of function parameters is not implemented yet\n"); */
/* 		} */
/* 		else if (ParameterIsField(ppar)) */
/* 		{ */
/* 		    //- give diagnostics: not implemented yet */

/* 		    fprintf(stdout, "\nreporting of field parameters is not implemented yet\n"); */
/* 		} */

		//- otherwise

		else if (ParameterIsSymbolic(ppar))
		{
		    //- give diagnostics: not implemented yet

		    fprintf(stdout, "\nreporting of symbolic parameters is not implemented yet\n");
		}
		else if (ParameterIsAttribute(ppar))
		{
		    //- give diagnostics: not implemented yet

		    fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");
		}
	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "parameter not found in symbol\n");
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter1-name> <parameter2-name>
/// 

static int QueryHandlerPrintParameterInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
	    //- traverse symbols that match with wildcard

	    int iResult
		= SymbolTraverseWildcard
		  (phsleRoot,
		   ppistRoot,
		   ppist,
		   QueryMachineWildcardParameterTraverser,
		   NULL,
		   (void *)pcPar);

	    if (iResult != 1)
	    {
		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- lookup parameter

	    struct symtab_Parameters *ppar
		= SymbolFindParameter(phsle, ppist, pcPar);

	    //- if parameter found

	    if (ppar)
	    {
		fprintf(stdout, "%s", "---\n");

		int iResult = ParameterPrintInfoRecursive(ppar, ppist, 0, stdout);

		if (!iResult)
		{
		    bResult = 0;
		}
	    }
	    else
	    {
		fprintf(stdout, "parameter not found\n");
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameterinput <context> <parameter1-name> <parameter2-name>
/// 

static int
QueryHandlerPrintParameterInput
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    int iSize = -1;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    if (!ppist)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    //- parse parameter

    char pcPar1[100];
    char pcPar2[100];

    char pcSeparator[] = " \t,;\n";

    //- get parameter 1

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    iSize = strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    strncpy(pcPar1, &pcLine[iLength + 1], iSize);

    pcPar1[iSize - 1] = '\0';

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    //- get parameter 2

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];
    }

    strncpy(pcPar2, &pcLine[iLength + 1], iSize);

    pcPar2[iSize] = '\0';

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    /// \note does not allow namespacing

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- lookup parameter

	struct symtab_HSolveListElement *phsleInput
	    = SymbolResolveParameterFunctionalInput(phsle, ppist, pcPar1, pcPar2, 0);

	//- if parameter found

	if (phsleInput)
	{
	    //- print result

	    fprintf(stdout, "value = %s\n", SymbolGetName(phsleInput));
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "input not found\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle scaled parameter query
///

static int QueryHandlerPrintParameterScaled
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    /// \note does not allow namespacing

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- lookup parameter

	struct symtab_Parameters *ppar
	    = SymbolFindParameter(phsle, ppist, pcPar);

	//- if parameter found

	if (ppar || 1)
	{
	    //- resolve value

	    double d = SymbolParameterResolveScaledValue(phsle, ppist, pcPar);

	    //- print result

	    fprintf(stdout, "scaled value = %g\n",d);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "parameter not found in symbol\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter set query
///
/// \details 
/// 
///	printparameterset <context>
/// 
/// \todo 
/// 
///	This function should also be able to get the parameters from
///	functions.  First functions must be included in the principal
///	set before that can happen.
/// 

struct VectorParameters
{
    /// number of parameters

    int iParameters;

    /// parameters

    struct symtab_Parameters *ppparameters[100];
};

static int
ParameterNameComparator
(const void * pvParameter1, const void * pvParameter2)
{
    /// \note never saw this construct, but I got it right from the first
    /// \note time, I 'understand' this code, and it _does_ makes sense

    struct symtab_Parameters * const * pppar1 = pvParameter1;
    struct symtab_Parameters * const * pppar2 = pvParameter2;

    char *pc1 = ParameterGetName(*pppar1);
    char *pc2 = ParameterGetName(*pppar2);

    return strcmp(pc1, pc2);
}

static int
QueryMachineWildcardParameterSetTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct VectorParameters *pvpars = (struct VectorParameters *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if this is a biological component

    int iType = TstrGetActualType(ptstr);

    if (subsetof_bio_comp(iType))
    {
	/// \todo this code is one more reason to implement traversals that are
	/// \todo orthogonal to the model's axis.

	//- loop over all prototypes including self

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	while (pbio)
	{
	    //- loop over parameters of this prototype

	    struct symtab_Parameters *ppar
		= ParContainerIterateParameters(pbio->pparc);

	    while (ppar)
	    {
		//- lookup the parameter in the stored ones

		char *pcNew = ParameterGetName(ppar);

		int i;

		for (i = 0 ; i < pvpars->iParameters ; i++)
		{
		    //- if found

		    char *pcStored = ParameterGetName(pvpars->ppparameters[i]);

		    if (strcmp(pcStored, pcNew) == 0)
		    {
			//- loop index signals were found

			//- break loop

			break;
		    }
		}

		//- if not found

		if (i == pvpars->iParameters)
		{
		    //- store this parameter

		    pvpars->ppparameters[pvpars->iParameters] = ppar;

		    pvpars->iParameters++;
		}

		//- go to next parameter

		ppar = ParContainerNextParameter(ppar);
	    }

	    //- go to next prototype

	    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	}
    }
    else if (subsetof_algorithm_symbol(iType)
	     || subsetof_connection(iType)
	     || subsetof_connection_symbol(iType))
    {
    }
    else
    {
	//- give diagnostics : not supported

	fprintf
	    (stdout,
	     "printparameterset: only biocomponents are supported (%s is not a biocomponent)\n",
	     SymbolGetName(phsle));

	//- abort traversal

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}

static int QueryHandlerPrintParameterSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    /// \note so phsleRoot can be NULL if the model description file was not found

    if (phsleRoot)
    {
	//- get parameters

	struct VectorParameters vpars =
	    {
		/// number of parameters

		0,

		/// parameters

		{
		    NULL,
		},
	    };

	//- traverse symbols that match with wildcard

	int iResult
	    = SymbolTraverseWildcard
	      (phsleRoot,
	       ppistRoot,
	       ppist,
	       QueryMachineWildcardParameterSetTraverser,
	       NULL,
	       (void *)&vpars);

	if (iResult == 1)
	{
	    //- sort things

	    qsort
		(&vpars.ppparameters[0],
		 vpars.iParameters,
		 sizeof(vpars.ppparameters[0]),
		 ParameterNameComparator);

	    //- loop over all parameters found

	    int i;

	    for (i = 0 ; i < vpars.iParameters ; i++)
	    {
		//- diags: parameter name

		char *pcStored = ParameterGetName(vpars.ppparameters[i]);

		fprintf(stdout, "Parameter (%s)\n", pcStored);
	    }

	}
	else
	{
	    fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	}
    }
    else
    {
	//- diag's

	fprintf(stdout, "no model loaded\n");
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of segments.
/// 

static int QueryHandlerPrintSegmentCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- obtain segment count

	int iChildren = SymbolCountSegments(phsle, ppist);

	//- print segment count

	fprintf(stdout, "Number of segments : %i\n", iChildren);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections for a spikereceiver in a projection.
///
/// \details 
/// 
///	spikereceivercount <projection> <spike-receiver>
/// 

static int QueryHandlerPrintSpikeReceiverCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get projection context

    struct PidinStack *ppistProjection = PidinStackParse(&pcLine[iLength]);

    //- get spike receiver context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike receiver\n");

	return(FALSE);
    }

    struct PidinStack *ppistReceiver = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppistProjection);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    struct symtab_Projection *pproj = NULL;
	    int iConnections = -1;

	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	    {
		//return(FALSE);
	    }

	    //- print connection count

	    pproj = (struct symtab_Projection *)phsle;

	    iConnections
		= ProjectionGetNumberOfConnectionsForSpikeReceiver
		  (pproj, ppistProjection, ppistReceiver);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    //- print connection count

	    fprintf(stdout, "Number of connections : %i\n", iConnections);

	    //i
	    //i Bug: These print statements can lead to a stall when stdout is blocking I/O on the 
	    //i      fprintf statement. 
	    //i      Bug only seems to be present in Mac OSX Leopard when the machine has other 
	    //i      programs loaded and is running the nesting.t test in neurospaces_harness. 
	    //i      Could be a sign of another subprocess putting an I/O lock on stdout.

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- print : not a projection

	    fprintf(stdout, "%s is not a projection\n",SymbolName(phsle));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistReceiver);
    PidinStackFree(ppistProjection);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print unique ID for symbol with respect to container.
///
/// \details 
/// 
///	spikereceiverserialID <population> <spike-receiver>
/// 

static int QueryHandlerPrintSpikeReceiverSerialID
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phslePopulation = NULL;
    struct symtab_HSolveListElement *phsleReceiver = NULL;

    //- get population context

    struct PidinStack *ppistPopulation = PidinStackParse(&pcLine[iLength]);

    //- get spike receiver context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike receiver\n");

	return(FALSE);
    }

    struct PidinStack *ppistReceiver = PidinStackParse(pcBreak);

    //- lookup symbols

    /// \note allows namespacing, yet incompatible with parameter caches.

    phslePopulation = SymbolsLookupHierarchical(pneuro->psym, ppistPopulation);

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleReceiver = SymbolsLookupHierarchical(pneuro->psym, ppistReceiver);

    //- if found

    if (phslePopulation)
    {
	//- if population

	if (instanceof_population(phslePopulation))
	{
	    //- set serial ID

	    int iID
		= PopulationLookupSpikeReceiverSerialID
		  (phslePopulation,
		   ppistPopulation,
		   phsleReceiver,
		   ppistReceiver);

	    //- print serial ID

	    fprintf(stdout, "Serial ID : %i\n",iID);
	}

	//- else

	else
	{
	    //- print : not a population

	    fprintf(stdout, "%s is not a population\n",SymbolName(phslePopulation));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistReceiver);
    PidinStackFree(ppistPopulation);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections for a spikesender in a projection.
///
/// \details 
/// 
///	spikesendercount <projection> <spike-sender>
/// 

static int QueryHandlerPrintSpikeSenderCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get projection context

    struct PidinStack *ppistProjection = PidinStackParse(&pcLine[iLength]);

    //- get spike sender context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike sender\n");

	return(FALSE);
    }

    struct PidinStack *ppistSender = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppistProjection);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    struct symtab_Projection *pproj = NULL;
	    int iConnections = -1;

	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
	    {
		//return(FALSE);
	    }

	    //- print connection count

	    pproj = (struct symtab_Projection *)phsle;

	    iConnections
		= ProjectionGetNumberOfConnectionsForSpikeGenerator
		  (pproj, ppistProjection, ppistSender);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    fprintf(stdout, "Number of connections : %i\n", iConnections);

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- print : not a projection

	    fprintf(stdout, "%s is not a projection\n",SymbolName(phsle));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistSender);
    PidinStackFree(ppistProjection);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printsymbolparameters <context>
/// 

static int QueryHandlerPrintSymbolParameters
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

/*     //- parse parameter */

/*     char pcSeparator[] = " \t,;\n"; */

/*     char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator); */

/*     if (!pcPar) */
/*     { */
/* 	fprintf(stdout, "parameter not found on command line\n"); */

/* 	return(FALSE); */
/*     } */

/*     pcPar++; */

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
/* 	    //- traverse symbols that match with wildcard */

/* 	    int iResult */
/* 		= SymbolTraverseWildcard */
/* 		  (phsleRoot, */
/* 		   ppistRoot, */
/* 		   ppist, */
/* 		   QueryMachineWildcardParameterTraverser, */
/* 		   NULL, */
/* 		   (void *)pcPar); */

/* 	    if (iResult != 1) */
/* 	    { */
/* 		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n"); */
/* 	    } */
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- if biocomponent

	    if (instanceof_bio_comp(phsle))
	    {
		struct symtab_BioComponent *pbio
		    = (struct symtab_BioComponent *)phsle;

		if (!BioComponentExportParametersYAML(pbio, ppist, 0, NULL))
		{
		    bResult = 0;
		}
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print info on spikesender or receiver for a given set of
/// projections.
///
/// \details 
/// 
///	projectionquery <caching = c|n> <attachment-path> <projection-path> ...
/// 

struct QM_pq_traversal_data
{
    /// set first serial ID : 0

    int iSerial;

    /// projection query

    struct ProjectionQuery *ppq;
};


static int 
QueryMachineConnectionTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_pq_traversal_data *pqtd
	= (struct QM_pq_traversal_data *)pvUserdata;

    //- get actual symbol type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- if connection

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- give diag's

	fprintf
	    (stdout,
	     "Connection (%5.5i)\n",
	     pqtd->iSerial);

/* 	fprintf */
/* 	    (stdout, */
/* 	     "----------------------------------------------------\n"); */

/* 	fprintf */
/* 	    (stdout, */
/* 	     "Projection source (%i), Projection target (%i)\n", */
/* 	     ProjectionQueryGetCurrentSourceSerial(pqtd->ppq), */
/* 	     ProjectionQueryGetCurrentTargetSerial(pqtd->ppq)); */

	if (subsetof_cached_connection(iType))
	{
	    CachedConnectionPrint(pconn, TRUE, 8, stdout);
	}
	else if (subsetof_connection(iType))
	{
	    ConnectionPrint(pconn, TRUE, 8, stdout);
	}

	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
/* 	fprintf(stdout, "--------------------------------\n", pqtd->iSerial); */
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(iResult);
}


static int QueryHandlerProjectionQuery
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    struct PidinStack *pppistProjections[10];
    int iProjections = 0;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    //- get projections

    for (iProjections = 0 
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

	if (pcBreak)
	{
	    pppistProjections[iProjections] = PidinStackParse(pcBreak);
	}
    }

    pppistProjections[iProjections] = NULL;

    //- if spike(gen|rec) found

    if (phsleAttachment)
    {
	//- create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections, iProjections);

	//- if projection query ok

	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	ProjectionQueryFree(ppq2);

	if (ppq)
	{
	    struct QM_pq_traversal_data qtd =
	    {
		/// set first serial ID : 0

		0,

		/// projection query

		ppq,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq, bCaching);

	    //- if attachment

	    if (instanceof_attachment(phsleAttachment))
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
		{
		    //return(FALSE);
		}

		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbol must be attachment\n");
	    }

	    //- free projection query

	    ProjectionQueryFree(ppq);

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbols must be projection\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	PidinStackFree(pppistProjections[iProjections]);
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections optionally on spikesender or
/// receiver for a given set of projections.
///
/// \details 
/// 
///	projectionquerycount \
///		<caching = c|n> \
///		<attachment-path>? \
///		<projection-path> ...
/// 

static int 
QueryMachineConnectionCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_pq_traversal_data *pqtd
	= (struct QM_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n", pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


static int QueryHandlerProjectionQueryCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    struct PidinStack *pppistProjections[10];
    int iProjections = 0;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    if (!phsleAttachment)
    {
	fprintf(stdout, "symbol not found\n");

	PidinStackFree(ppistAttachment);

	return(FALSE);
    }

    if (phsleAttachment && !instanceof_attachment(phsleAttachment))
    {
	fprintf
	    (stdout,
	     "first symbol is not attachment,"
	     " will be used as part of projectionquery\n");
    }

    //- if is projection

    if (instanceof_projection(phsleAttachment))
    {
	//- fill in projection array

	pppistProjections[iProjections] = ppistAttachment;

	iProjections++;

	ppistAttachment = NULL;
	phsleAttachment = NULL;
    }

    //- get projections

    for (/* iProjections = 0  */
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

	if (pcBreak)
	{
	    pppistProjections[iProjections] = PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));
	}
    }

    pppistProjections[iProjections] = NULL;

    {
	//- create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections, iProjections);

	if (!ppq)
	{
	    fprintf(stdout, "Could not allocate projection query\n");

	    return(FALSE);
	}

	//- if projection query ok

	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	ProjectionQueryFree(ppq2);

	if (ppq)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    struct QM_pq_traversal_data qtd =
	    {
		/// set count : 0

		0,

		/// projection query

		ppq,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq, bCaching);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	    {
		//return(FALSE);
	    }

	    //- if selective count

	    if (ppistAttachment)
	    {
		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

	    }

	    //- else

	    else
	    {
		//- traverse connections arriving on spike receiver

		ProjectionQueryTraverseConnections
		    (ppq,
		     QueryMachineConnectionCounter,
		     NULL,
		     (void *)&qtd);
	    }

/* 	    { */
/* 		int i; */

/* 		for (i = 10000000 ; i > 0 ; i --); */
/* 	    } */

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    //- diag's

	    fprintf(stdout, "#connections = %i\n", qtd.iSerial);

	    fprintf
		(stdout,
		 "#memory used by projection query = %i\n",
		 ProjectionQueryGetMemorySize(ppq));

	    fprintf
		(stdout,
		 "#memory used by connection cache = %i\n",
		 ppq->pcc
		 ? ConnectionCacheGetMemorySize(ppq->pcc)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 1  = %i\n",
		 ppq->poccPre
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPre)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 2  = %i\n",
		 ppq->poccPost
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPost)
		 : 0 );

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	    //- free projection query

	    ProjectionQueryFree(ppq);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbols must be projection\n");
	}
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	free(pppistProjections[iProjections]);
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Recalculate serial mappings for a symbol relative.
///
/// \details 
/// 
///	recalculate <context>
/// 

static
int
QueryHandlerRecalculate
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- if there is a context argument

    if (pcLine[iLength])
    {
	//- parse command line element

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

	//- lookup symbol

	/// \note allows namespacing, yet incompatible with parameter caches.
	/// \note note : can be lookup for root, so PidinStackLookupTopSymbol()
	/// \note does not work, should be fixed ?

	struct symtab_HSolveListElement *phsle
	    = SymbolsLookupHierarchical(pneuro->psym, ppist);

	//- if found

	if (phsle)
	{
	    char pc[1000];

	    PidinStackString(ppist, pc, 1000);

	    fprintf(stdout, "recalc serials for %s\n", pc);

	    //- recalc serials

	    SymbolRecalcAllSerials(phsle, ppist);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}

	//- free allocated memory

	PidinStackFree(ppist);
    }
    else
    {
	fprintf(stdout, "recalc all serials\n");

	//- recalc all serials

	SymbolRecalcAllSerials(NULL, NULL);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Reduce parameters of a component, all if no component
/// given.
///
/// \details 
/// 
///	reduce <component>
/// 

static
int
QueryHandlerReduce
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int iResult = 1;

    struct PidinStack *ppist = NULL;
    struct symtab_HSolveListElement *phsle = NULL;

    if (pcLine[iLength])
    {
	//- parse command line element

	ppist = PidinStackParse(&pcLine[iLength]);

	//- lookup symbol

	/// \note allows namespacing, yet incompatible with parameter caches.

	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

	if (!phsle)
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");

	    //- return failure

	    return(0);
	}

    }

    //- if symbol found

    if (phsle)
    {
	//- reduce parameters of only this symbol

	iResult = SymbolReduce(phsle, ppist);
    }

    //- else

    else
    {
	//- reduce everything

	iResult = NeurospacesReduce(pneuro);
    }

    if (ppist)
    {
	//- free context

	PidinStackFree(ppist);
    }

    //- return result

    return(iResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Get solver info for symbol.
///
/// \details 
/// 
///	resolvesolver <solved-context>
/// 

static int QueryHandlerResolveSolverID
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    //- diag's

	    fprintf(stdout, "not implemented for projections\n");
	}

	//- if instance of biocomponent

	else if (instanceof_bio_comp(phsle))
	{
	    int iSerialID = -1;
	    struct SolverInfo *psi = NULL;
	    struct PidinStack *ppistSerial = NULL;

	    //- get solver info for symbol

	    psi = SolverRegistryGet(pneuro->psr, ppist);

	    if (!psi)
	    {
		fprintf(stdout, "Could not find solver info\n", iSerialID);
		return(FALSE);
	    }

	    //- lookup serial ID

	    iSerialID = SolverInfoLookupPrincipalSerial(psi, ppist);

	    //- diag's

	    fprintf
		(stdout,
		 "Solver = %s, solver serial ID = %i\n",
		 SolverInfoGetSolverString(psi),
		 iSerialID);

	    //- convert serial back to context

	    ppistSerial
		= SolverInfoLookupContextFromPrincipalSerial(psi, iSerialID);

	    if (ppistSerial)
	    {
		//- diag's

		fprintf
		    (stdout,
		     "Solver serial context for %i = \n\t",
		     iSerialID);

		PidinStackPrint(ppistSerial, stdout);

		fprintf(stdout, "\n");

		//- free context

		PidinStackFree(ppistSerial);
	    }
	    else
	    {
		fprintf
		    (stdout,
		     "Solver serial context for %i = \n\t(NULL)\n",
		     iSerialID);
	    }
	}
	else
	{
	    fprintf(stdout, "not a biocomponent\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free context

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Linearize the segments in a segmenter in an internal cache.
/// 

static
int
QueryHandlerSegmenterLinearize
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    int iSuccess = SymbolLinearize(phsle, ppist);

	    //- print segment count

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    fprintf(stdout, "---\n", psegr->desegmenter.iSegments);
	    fprintf(stdout, "Number of segments: %i\n", psegr->desegmenter.iSegments);
	    fprintf(stdout, "Number of segments without parents: %i\n", psegr->desegmenter.iNoParents);
	    fprintf(stdout, "Number of segment tips: %i\n", psegr->desegmenter.iTips);

	    if (!iSuccess)
	    {
		fprintf(stdout, "linearization failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Report the parent count in a segmenter.
/// 

static
int
QueryHandlerSegmenterParentCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterParentCount(psegr, ppist);

	    if (!iSuccess)
	    {
		fprintf(stdout, "parent count report failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Set the segmenter base for a group of segments.
///
/// \details 
/// 
///	segmentersetbase <segmenter-base-context>
/// 

static
int
QueryHandlerSegmenterSetBase
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterSetBase(psegr, ppist);

	    if (!iSuccess)
	    {
		fprintf(stdout, "setting segmentation base component failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Report the segment tips in a segmenter.
/// 

static
int
QueryHandlerSegmenterTips
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- report tips

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterTips(psegr, ppist, 0);

	    if (!iSuccess)
	    {
		fprintf(stdout, "tip report failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Report biocomp serial ID.
///
/// \details 
/// 
///	serialID <context> <child-context>
/// 

static int QueryHandlerSerialID
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get child context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify two symbols\n");

	return(FALSE);
    }

    struct PidinStack *ppistSearched = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    //- diag's

	    fprintf
		(stdout,
		 "Get neurospaces C implementation prior to -r 405 to see"
		 " what happens here.\n");
	    fprintf
		(stdout,
		 "\tThat version has connections with hardcoded serial IDs"
		 " per connection.\n");
	}

	//- if instance of biocomponent

	else if (instanceof_bio_comp(phsle))
	{
	    int i;

	    //- lookup serial ID

	    int iSerialID 
		= BioComponentLookupSerialID
		  ((struct symtab_BioComponent *)phsle,
		   ppist,
		   NULL,
		   ppistSearched);

	    //- diag's

	    fprintf(stdout, "serial ID = %i\n",iSerialID);
	}
	else
	{
	    fprintf(stdout, "not a biocomponent\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Output forestspace structure to a file.
///
/// \details 
/// 
///	serializeforestspace <type=a|x> <context> <filename>
/// 

struct QM_fs_traversal_data
{
    /// file to write to

    FILE *pfile;

    /// type of output

    char *pcType;

    /// symbol last visited

    char *pcLast;
};


static int 
QueryMachineForestspaceSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

/*     //- if tagged */

/*     if (SymbolGetFlags(phsle) & FLAGS_HSLE_TRAVERSAL != 0) */
/*     { */
/* 	//- do not process, continue with siblings */

/* //	iResult = SYMBOL_SELECTOR_PROCESS_SIBLING; */
/*     } */

    //- return result

    return(iResult);
}


static void
QueryMachineForestspaceEdgeSerializer
(struct symtab_HSolveListElement *phsleParent,
 struct symtab_HSolveListElement *phsle,
 struct QM_fs_traversal_data *pfsd)
{
    //- write info on symbol

    switch (pfsd->pcType[0])
    {
    case 'x':
    {
	fprintf(pfsd->pfile, "  edge:  {");
	fprintf(pfsd->pfile, "    sourcename: \"%p\"", phsleParent);
	fprintf(pfsd->pfile, "    targetname: \"%p\"", phsle);
	fprintf(pfsd->pfile, "    color: black }\n");
	break;
    }
    case 'a':
    {
	fprintf(pfsd->pfile, "  edge:  {");
	fprintf(pfsd->pfile, "    sourcename: \"%p\"", phsleParent);
	fprintf(pfsd->pfile, "    targetname: \"%p\"", phsle);
	fprintf(pfsd->pfile, "    color: black }\n");
	break;
    }
    }
}


static void
QueryMachineForestspaceNodeSerializer
(struct symtab_HSolveListElement *phsle,
 struct QM_fs_traversal_data *pfsd)
{
    //- write info on symbol

    switch (pfsd->pcType[0])
    {
    case 'x':
    {
	fprintf(pfsd->pfile, "  node:\n  {\n");
	fprintf(pfsd->pfile, "    title: \"%p\"\n", phsle);
	fprintf
	    (pfsd->pfile,
	     "    label: \"%s\"\n",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );
	fprintf
	    (pfsd->pfile,
	     "    info1: \"%s\"\n",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );

	fprintf(pfsd->pfile, "  }\n");
	break;
    }
    case 'a':
    {
	fprintf(pfsd->pfile, "  node:  {");
	fprintf(pfsd->pfile, "    title: \"%p\"", phsle);
	fprintf
	    (pfsd->pfile,
	     "    label: \"%s\"",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );
	fprintf
	    (pfsd->pfile,
	     "    info1: \"%s\"",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );

	fprintf(pfsd->pfile, "  }\n");
	break;
    }
    }
}


static int 
QueryMachineForestspaceSerializer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_fs_traversal_data *pfsd
	= (struct QM_fs_traversal_data *)pvUserdata;

    //- get actual symbol type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- if not a connection

    if (!subsetof_connection_symbol(iType)
	&& !subsetof_connection(iType)
	&& !subsetof_v_connection_symbol(iType)
	&& !subsetof_projection(iType))
    {
	//- get parent symbol

	struct symtab_HSolveListElement *phsleParent
	    = TstrGetActualParent(ptstr);

	//- write info on symbol

	QueryMachineForestspaceNodeSerializer(phsle, pfsd);

	//- write info on to parent edge

	QueryMachineForestspaceEdgeSerializer(phsleParent, phsle, pfsd);
    }

    //- return result

    return(iResult);
}


static int QueryHandlerSerializeForestspace
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    char * pcArg = NULL;
    char * pcType = NULL;
    char * pcFilename = NULL;

    //- get type of output

    /// \note will core for invalid command lines

    pcArg = strpbrk(&pcLine[iLength + 1], " \t");

    pcType = &pcArg[1];

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- get filename

    pcArg = strpbrk(&pcLine[iLength + 1], " \t");

    pcFilename = &pcArg[1];

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
/* 	//- if instance of biocomponent */

/* 	if (InstanceOfBioComponent(phsle)) */
	{
	    struct QM_fs_traversal_data fsd =
		{
		    /// file to write to

		    NULL,

		    /// type of output

		    NULL,

		    /// symbol last visited

		    NULL,

		};

	    struct TreespaceTraversal *ptstr = NULL;
	    int iTraverse = -1;

	    //- open output file

	    fsd.pfile = fopen(pcFilename, "w");
	    fsd.pcType = pcType;

	    //- output header

	    switch (fsd.pcType[0])
	    {
	    case 'a':
	    {
		break;
	    }
	    case 'x':
	    {
		fprintf(fsd.pfile, "graph:\n{\n");
		fprintf(fsd.pfile, "  title: \"forestspace\"\n");
		fprintf(fsd.pfile, "  port_sharing: no\n");
		fprintf(fsd.pfile, "  layoutalgorithm: minbackward\n");
		fprintf(fsd.pfile, "  layout_downfactor: 39\n");
		fprintf(fsd.pfile, "  layout_upfactor: 0\n");
		fprintf(fsd.pfile, "  layout_nearfactor: 0\n");
		fprintf(fsd.pfile, "  nearedges: no\n");
		fprintf(fsd.pfile, "  splines: yes\n");
		fprintf(fsd.pfile, "  straight_phase: yes\n");
		fprintf(fsd.pfile, "  priority_phase: yes\n");
		fprintf(fsd.pfile, "  cmin: 10\n");
		break;
	    }
	    default:
		fprintf(stdout, "serializeforestspace:\n");
		fprintf
		    (stdout, " unrecognized output type (%c)\n",fsd.pcType[0]);
		break;
	    }

	    //- write info on first symbol

	    QueryMachineForestspaceNodeSerializer(phsle,&fsd);

	    //- init treespace traversal

	    ptstr
		= TstrNew
		  (ppist,
		   NULL,
		   NULL,
		   QueryMachineForestspaceSerializer,
		   (void *)&fsd,
		   NULL,
		   NULL);

	    //- traverse segment symbol

	    iTraverse = TstrGo(ptstr, phsle);

	    //- delete treespace traversal

	    TstrDelete(ptstr);

	    //- write tail of file

	    switch (fsd.pcType[0])
	    {
	    case 'x':
	    {
		fprintf(fsd.pfile, "\n}\n");
		break;
	    }
	    }

	    //- close output file

	    fclose(fsd.pfile);
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Get serial mappings for a symbol relative to another symbol.
///
/// \details 
/// 
///	serialMapping <context> <child-context>
/// 

static int QueryHandlerSerialMapping
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get child context

    /// \note will core for invalid command lines

    char * pcSearched = strpbrk(&pcLine[iLength + 1], " \t");

    struct PidinStack *ppistSearched = NULL;

    if (pcSearched)
    {
	ppistSearched = PidinStackParse(pcSearched);
    }
    else
    {
	ppistSearched = ppist;
	ppist = PidinStackCalloc();
    }

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    /// \note note : can be lookup for root, so PidinStackLookupTopSymbol()
    /// \note does not work, should be fixed ?

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
/* 	//- if instance of biocomponent */

/* 	if (InstanceOfBioComponent(phsle)) */
	{
	    struct PidinStack pistDuplicate
		= *ppistSearched;

	    struct symtab_HSolveListElement *phsleDuplicate = phsle;

	    int i;

	    int iPrincipalSerial = -1;
	    int iPrincipalSuccessors = -1;
	    int iMechanismSerial = -1;
	    int iMechanismSuccessors = -1;
	    int iSegmentSerial = -1;
	    int iSegmentSuccessors = -1;

	    //- lookup serial ID

	    int iSerialID 
		= BioComponentLookupSerialID
		  ((struct symtab_BioComponent *)phsle,
		   ppist,
		   NULL,
		   ppistSearched);

	    //- look up all intermediate symbols

	    *ppistSearched = pistDuplicate;

	    phsle = PidinStackLookupTopSymbol(ppistSearched);

	    if (phsle)
	    {
		//- go through all found symbols

		iPrincipalSerial = 0;

		/// \note note additional protection on NULL phsle necessary
		/// \note for case that namespace operators are being used.

		while (phsle && phsle != phsleDuplicate)
		{
		    //- get principal serial from intermediate symbol

		    iPrincipalSerial += SymbolGetPrincipalSerialToParent(phsle);

		    //- get next symbol

		    if (PidinStackPop(ppistSearched) == NULL)
		    {
			//- if none, set error condition

			phsle = NULL;

			phsleDuplicate = NULL;

			break;
		    }

		    phsle = PidinStackLookupTopSymbol(ppistSearched);
		}

		if (phsleDuplicate)
		{
		    //- get principal successors

		    iPrincipalSuccessors
			= SymbolGetPrincipalNumOfSuccessors(phsleDuplicate);

#ifdef TREESPACES_SUBSET_MECHANISM
		    //- look up all intermediate symbols

		    *ppistSearched = pistDuplicate;

		    phsle = PidinStackLookupTopSymbol(ppistSearched);

		    //- go through all found symbols

		    iMechanismSerial = 0;

		    /// \note note additional protection on NULL phsle necessary
		    /// \note for case that namespace operators are being used.

		    while (phsle && phsle != phsleDuplicate)
		    {
			//- get mechanism serial from intermediate symbol

			iMechanismSerial += SymbolGetMechanismSerialToParent(phsle);

			//- get next symbol

			(void)PidinStackPop(ppistSearched);

			phsle = PidinStackLookupTopSymbol(ppistSearched);
		    }

		    //- get mechanism successors

		    iMechanismSuccessors
			= SymbolGetMechanismNumOfSuccessors(phsleDuplicate);
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
		    //- look up all intermediate symbols

		    *ppistSearched = pistDuplicate;

		    phsle = PidinStackLookupTopSymbol(ppistSearched);

		    //- go through all found symbols

		    iSegmentSerial = 0;

		    /// \note note additional protection on NULL phsle necessary
		    /// \note for case that namespace operators are being used.

		    while (phsle && phsle != phsleDuplicate)
		    {
			//- get segment serial from intermediate symbol

			iSegmentSerial += SymbolGetSegmentSerialToParent(phsle);

			//- get next symbol

			(void)PidinStackPop(ppistSearched);

			phsle = PidinStackLookupTopSymbol(ppistSearched);
		    }

		    //- get segment successors

		    iSegmentSuccessors
			= SymbolGetSegmentNumOfSuccessors(phsleDuplicate);
#endif
		}

		if (phsleDuplicate)
		{
		    //- diag's

		    fprintf(stdout, "Traversal serial ID = %i\n",iSerialID);
		    fprintf(stdout, "Principal serial ID = %i",iPrincipalSerial);
		    fprintf(stdout, " of %i Principal successors\n",iPrincipalSuccessors);
#ifdef TREESPACES_SUBSET_MECHANISM
		    fprintf(stdout, "Mechanism serial ID = %i",iMechanismSerial);
		    fprintf(stdout, " of %i Mechanism successors\n",iMechanismSuccessors);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		    fprintf(stdout, "Segment  serial  ID = %i",iSegmentSerial);
		    fprintf(stdout, " of %i  Segment  successors\n",iSegmentSuccessors);
#endif
		}
		else
		{
		    fprintf(stdout, "symbol is not an ancestor\n");
		}
	    }
	    else
	    {
		fprintf(stdout, "symbol not found\n");
	    }
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print context of serial relative to another context.
///
/// \details 
/// 
///	serial2context <path> <serial>
/// 

static int QueryHandlerSerialToContext
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get serial ID to lookup

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a serial\n");

	return(FALSE);
    }

    int iSerial = strtol(pcBreak,&pcLine, 0);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(NULL, ppist);

    //- if found

    if (phsle)
    {
	//- get context

	struct PidinStack *ppistSerial
	    = SymbolPrincipalSerial2Context(phsle, ppist, iSerial);

	//- if found

	if (ppistSerial)
	{
	    //- diag's

	    fprintf(stdout, "serial id ");

	    PidinStackPrint(ppist, stdout);

	    fprintf(stdout, ",%i -> ", iSerial);

	    PidinStackPrint(ppistSerial, stdout);

	    fprintf(stdout, "\n");

	    PidinStackFree(ppistSerial);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "serial not found\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Set the value of a parameter.
///
/// \details 
/// 
///	setparameter <parameter-base> <parameter-context> <parameter-name> <parameter-type> <parameter-value>
/// 

static int QueryHandlerSetParameter
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppistBase = PidinStackParse(pcArg);

    //- get parameter context

    /// \note will core for invalid command lines

    pcArg = strpbrk(pcArg, pcSeparator);

    struct PidinStack *ppistParameter = PidinStackParse(pcArg);

    //- lookup base symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     struct symtab_HSolveListElement *phsleBase */
/* 	= SymbolsLookupHierarchical(pneuro->psym, ppistBase); */

    struct symtab_HSolveListElement *phsleBase
	= PidinStackLookupTopSymbol(ppistBase);

    if (!phsleBase)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    int iBase = PidinStackToSerial(ppistBase);

    //- lookup parameter context symbol

    struct symtab_HSolveListElement *phsleParameter
	= SymbolLookupHierarchical(phsleBase, ppistParameter, 0, 1);

    if (phsleBase && phsleParameter)
    {
	struct symtab_Parameters *ppar = NULL;

	//- get serial of parameter symbol

	int iSerialBase = PidinStackToSerial(ppistBase);

	struct PidinStack *ppistAbsoluteParameter
	    = PidinStackDuplicate(ppistBase);

	PidinStackAppendCompact(ppistAbsoluteParameter, ppistParameter);

	if (phsleParameter != PidinStackLookupTopSymbol(ppistAbsoluteParameter))
	{
	    fprintf(stdout, "internal error: parameter symbol changed location\n");
	}

	int iSerialAbsolutParameter
	    = PidinStackToSerial(ppistAbsoluteParameter);

	int iParameterSymbol = iSerialAbsolutParameter - iSerialBase;

	if (iParameterSymbol == INT_MAX
	    || iSerialAbsolutParameter == INT_MAX
	    || iSerialBase == INT_MAX)
	{
	    fprintf(stdout, "internal error: cannot compute index of parameter symbol\n");

	    iParameterSymbol = INT_MAX;
	}

	//- get parameter name

	pcArg = &pcArg[1];

	pcArg = strpbrk(pcArg, pcSeparator);

	char *pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	char pcName[1000];

	strncpy(pcName, pcInit, pcArg - pcInit);

	pcName[pcArg - pcInit] = '\0';

	//- get parameter type

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    PidinStackFree(ppistAbsoluteParameter);
	    PidinStackFree(ppistBase);
	    PidinStackFree(ppistParameter);

	    fprintf(stdout, "error in command line processing, cannot determine parameeter type\n");

	    return(FALSE);
	}

	char pcType[1000];

	strncpy(pcType, pcInit, pcArg - pcInit);

	pcType[pcArg - pcInit] = '\0';

	//- get parameter value

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	char pcValue[1000];

	if (pcArg)
	{
	    strncpy(pcValue, pcInit, MIN(pcArg - pcInit, 999));

	    pcValue[MIN(pcArg - pcInit, 999)] = '\0';
	}
	else
	{
	    strncpy(pcValue, pcInit, 999);
	}

	if (iParameterSymbol == INT_MAX)
	{
	}

	//- for a number

	else if (strcmp("number", pcType) == 0)
	{
	    //- convert value to double

	    double dValue = atof(pcValue);

	    //- set parameter value

	    // if the base symbol is at the root of the hierarchy, we
	    // set the parameter relative to the root so that it
	    // becomes absolute, otherwise we set it as a relative
	    // parameter.

/* 	    printf("iBase = %i\n", iBase); */

/* 	    printf("iParameterSymbol = %i\n", iParameterSymbol); */

	    if (iBase == 1)
	    {
		ppar = SymbolSetParameterFixedDouble(phsleParameter, ppistAbsoluteParameter, pcName, dValue);
	    }
	    else
	    {
		ppar = SymbolCacheParameterDouble(phsleBase, iParameterSymbol, pcName, dValue);
	    }
	}

	//- for a string

	else if (strcmp("string", pcType) == 0)
	{
	    //- copy string

	    char *pc = strdup(pcValue);

	    //- set parameter value

	    if (iBase == 1)
	    {
		ppar = SymbolSetParameterFixedString(phsleParameter, ppistAbsoluteParameter, pcName, pc);
	    }
	    else
	    {
		ppar = SymbolCacheParameterString(phsleBase, iParameterSymbol, pcName, pc);
	    }
	}

	//- else for a symbolic reference

	else if (strcmp("symbolic", pcType) == 0)
	{
	    /// \todo convert to list of pidins

	    /// \todo use list of pidins to store the parameter

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	//- else for a function

	else if (strcmp("function", pcType) == 0)
	{
	    /// \todo do some additional parsing

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	else
	{
	    fprintf(stdout, "unsupported parameter type %s\n", pcType);
	}

	if (!ppar)
	{
	    fprintf
		(stdout,
		 "could not set parameter %s with type %s to %s\n",
		 pcName,
		 pcType,
		 pcValue);
	}

	//- free stacks

	PidinStackFree(ppistAbsoluteParameter);
    }
    else
    {
	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistBase);
    PidinStackFree(ppistParameter);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Set the value of a parameter.
///
/// \details 
/// 
///	setparameterconcept <namespaced-symbol> <parameter-name> <parameter-type> <parameter-value>
/// 

static int QueryHandlerSetParameterConcept
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppistBase = PidinStackParse(pcArg);

    //- lookup base symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleBase
	= SymbolsLookupHierarchical(pneuro->psym, ppistBase);

    if (!phsleBase)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    if (phsleBase)
    {
	struct symtab_Parameters *ppar = NULL;

	//- get parameter name

	pcArg = &pcArg[1];

	pcArg = strpbrk(pcArg, pcSeparator);

	char *pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    fprintf(stdout, "parameter-type not found (must be 'number')\n");

	    return(FALSE);
	}

	char pcName[1000];

	strncpy(pcName, pcInit, pcArg - pcInit);

	pcName[pcArg - pcInit] = '\0';

	//- get parameter type

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    fprintf(stdout, "value not found (must be a number)\n");

	    return(FALSE);
	}

	char pcType[1000];

	strncpy(pcType, pcInit, pcArg - pcInit);

	pcType[pcArg - pcInit] = '\0';

	//- get parameter value

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	/// \note pcArg can be NULL

	char pcValue[1000];

	if (pcArg)
	{
	    strncpy(pcValue, pcInit, MIN(pcArg - pcInit, 999));

	    pcValue[MIN(pcArg - pcInit, 999)] = '\0';
	}
	else
	{
	    strncpy(pcValue, pcInit, strlen(pcInit));

	    pcValue[strlen(pcInit)] = '\0';
	}

	//- for a number

	if (strcmp("number", pcType) == 0)
	{
	    //- convert value to double

	    double dValue = atof(pcValue);

	    //- set parameter value

	    ppar = SymbolSetParameterDouble(phsleBase, pcName, dValue);
	}

	//- else for a symbolic reference

	else if (strcmp("symbolic", pcType) == 0)
	{
	    /// \todo convert to list of pidins

	    /// \todo use list of pidins to store the parameter

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	//- else for a function

	else if (strcmp("function", pcType) == 0)
	{
	    /// \todo do some additional parsing

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	else
	{
	    fprintf(stdout, "unsupported parameter type %s\n", pcType);
	}

	if (!ppar)
	{
	    fprintf
		(stdout,
		 "could not set parameter %s with type %s to %s\n",
		 pcName,
		 pcType,
		 pcValue);
	}
    }
    else
    {
	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistBase);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print solver registration for a context.
///
/// \details 
/// 
///	solverget <solved-context>
/// 

static int QueryHandlerShowParameters
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppist = PidinStackParse(pcArg);

    char pcContext[1000];

    PidinStackString(ppist, pcContext, 1000);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    if (!phsle)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    if (phsle)
    {
	fprintf(stdout, "---\nshow_parameters:\n");

	/// \todo this code is one more reason to implement traversals that are
	/// \todo orthogonal to the model's axis.

	//- loop over all prototypes including self

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	while (pbio)
	{
	    //- loop over parameters of this prototype

	    struct symtab_Parameters *ppar
		= ParContainerIterateParameters(pbio->pparc);

	    while (ppar)
	    {
		//- get parameter name

		char *pc = ParameterGetName(ppar);

		//- print parameter info

		fprintf(stdout, "  - component_name: %s\n", pcContext);
		fprintf(stdout, "    field: %s\n", ParameterGetName(ppar));
		fprintf(stdout, "    value: %s\n", ParameterGetString(ppar));

		//- go to next parameter

		ppar = ParContainerNextParameter(ppar);
	    }

	    //- go to next prototype

	    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	}
    }
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print solver registration for a context.
///
/// \details 
/// 
///	solverget <solved-context>
/// 

static int QueryHandlerSolverGet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get symbol context

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get solver registration

    struct SolverInfo *psi = SolverRegistryGet(pneuro->psr, ppist);

    //- if found

    if (psi)
    {
	//- get solver

	char *pcSolver = SolverInfoGetSolverString(psi);

	if (pcSolver)
	{
	    //- diag's

	    fprintf(stdout, "%s\n", pcSolver);
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "No solver\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "solver info not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value.
/// 
/// \brief Print all solver registrations.
/// 

static int QueryHandlerSolverRegistrations
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- give some info about all solver info registrations

    bResult = SolverRegistryEnumerate(pneuro->psr);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Add solver registration
///
/// \details 
/// 
///	solverset <symbol-path> <solver-path>
/// 

static int QueryHandlerSolverSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get symbol context

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- if not projection

	if (!instanceof_projection(phsle))
	{
	    //- get solver name

	    char *pcSolver = strpbrk(&pcLine[iLength + 1], " \t");

	    //- remove blank

	    pcSolver = &pcSolver[1];

	    //- set solver

	    SolverRegistryAddFromContext(pneuro->psr, NULL, ppist, pcSolver);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol must not be projection\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/*
 * \fun static int QueryHandlerSymbolPrintParameterTraversal
 *          (char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
 * 
 *  Prints out all parameters associated with a given symbol.
 */
static int QueryHandlerSymbolPrintParameterTraversal
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int iResult = 1;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);
 
    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	iResult = SymbolPrintParameterTraversal(phsle,ppist);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(iResult);
}


struct QM_SegmentValidator_data
{
    /// base symbol.

    struct symtab_HSolveListElement *phsleBase;

    /// number of entries in context ?

    int iEntries;
};

static
int
SegmentValidator
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
SegmentValidator
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : success

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment vector

    struct QM_SegmentValidator_data *pd
	= (struct QM_SegmentValidator_data *)pvUserdata;

    struct symtab_HSolveListElement *phsleBase = pd->phsleBase;

    int iEntries = pd->iEntries;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    struct PidinStack *ppist = ptstr->ppist;

    //- if this segment has a named parent segment

    struct symtab_Parameters *pparParent
	= SymbolGetParameter(phsle, ppist, "PARENT");

    if (pparParent)
    {
/* 	//- if parent symbol exists */

/* 	struct symtab_HSolveListElement *phsleParent */
/* 	    = ParameterResolveSymbol(pparParent, ppist); */

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar
	    = ParameterResolveToPidinStack(pparParent, ppist);

	if (ppistPar)
	{
	    {
		//- if parent symbol exists

		struct symtab_HSolveListElement *phsleParent = NULL;

		if (iEntries < PidinStackNumberOfEntries(ppistPar))
		{
		    phsleParent
			= SymbolLookupHierarchical
			  (phsleBase, ppistPar, iEntries, 1);
		}

		if (!phsleParent)
		{
		    char pc1[1000];
		    char pc2[1000];

		    PidinStackString(ppistPar, pc1, 1000);

		    PidinStackString(ppist, pc2, 1000);

		    fprintf(stdout, "not found using SymbolLookupHierarchical() for %s: %s\n", pc2, pc1);
		}
	    }

	    {
		//- if parent symbol exists

		struct symtab_HSolveListElement *phsleParent
		    = PidinStackLookupTopSymbol(ppistPar);

		if (!phsleParent)
		{
		    char pc1[1000];
		    char pc2[1000];

		    PidinStackString(ppistPar, pc1, 1000);

		    PidinStackString(ppist, pc2, 1000);

		    fprintf(stdout, "not found using PidinStackLookupTopSymbol() for %s: %s\n", pc2, pc1);
		}
	    }

	    //- free allocated memory

	    PidinStackFree(ppistPar);
	}
	else
	{
	    /// \note not sure if this is ok.

	    fprintf(stderr, "Warning: cannot find parent symbols in SegmentValidator()\n");
	}
    }

    //- return result

    return(iResult);
}

/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Give version information.
/// 

static
int
QueryHandlerValidateSegmentGroup
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get symbol context

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	struct QM_SegmentValidator_data d =
	{
	    phsle,

	    PidinStackNumberOfEntries(ppist),
	};

	//- if a cell

	if (instanceof_cell(phsle))
	{
	    //- traverse segments

	    int iTraverse
		= SymbolTraverseSegments(phsle, ppist, SegmentValidator, NULL, &d);
	}

	//- if a segment group

	else if (instanceof_v_segment(phsle))
	{
	    //- traverse segments

	    int iTraverse
		= SymbolTraverseSegments(phsle, ppist, SegmentValidator, NULL, &d);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol must be a cell or segment group\n");

	    bResult = FALSE;
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Give version information.
/// 

static int QueryHandlerVersion
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- diag's

    char *pcVersion = NeurospacesGetVersion();

    fprintf(stdout, "Version info : %s\n", pcVersion);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write library of symbols.
///
/// \details 
/// 
///	writelibrary <nesting-depth> <file.nld> symbol symbol
/// 
///	For every given symbol on command line
///		Traverse in-symbol until nesting-depth reached,
///			tag used symbols at nesting-depth,
///			lookup tagged symbols, 
///				get info about imported files, 
///				build table on imported files,
///		write info on imported files in table,
///		write info on private models from tagged symbols,
///		Writes in-symbol until nesting-depth reached,
///			afterwards makes references to used symbols.
///	Write library file of given symbols.
/// 

static int QueryHandlerWriteLibrary
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write modular description of symbol.
///
/// \details 
/// 
///	writemodular \
///		<public-nesting-depth> \
///		<private-nesting-depth> \
///		<file-prefix> \
///		<symbols>
/// 
///	writes <file-prefix>_<symbol-label>.nsd file for each symbol.
/// 

static int QueryHandlerWriteModular
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write selfcontained symbol description.
///
/// \details 
/// 
///	writesymbol \
///		<public-nesting-depth> \
///		<private-nesting-depth> \
///		<file-name.nsd> \
///		<symbols>
/// 
///	Nesting depths are used as maximum nesting depths in the
///	respective section of the description file before references are 
///	used, '-1' means infinite.
///	Writes file without any external dependencies on model description
///	files for a nesting depth of '-1'.  
/// 

static int QueryHandlerWriteSymbol
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
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


