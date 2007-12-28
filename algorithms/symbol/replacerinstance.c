//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: replacerinstance.c 1.8 Wed, 14 Nov 2007 16:12:38 -0600 hugo $
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

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/segment.h"
#include "neurospaces/segmenter.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/vector.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "replacer.h"
#include "replacerinstance.h"


//s replacer algorithm private data

/*s */
/*s struct with replacer options */
/*S */

struct ReplacerOptions_type
{
    /*m prototype to use */

    char *pcPrototype;

    /*m name matcher, selects segment candidates by name */

    char *pcSelector;
};

typedef struct ReplacerOptions_type ReplacerOptions;


//s
//s replacer variables
//s

struct ReplacerVariables_type
{
    //m base symbol, start of traversal

    struct symtab_HSolveListElement *phsleBase;

    struct PidinStack *ppistBase;

    //m number of replaced symbols

    int iReplacedSymbols;

    //m number of tries

    int iReplacerTries;

    //m number of failures

    int iReplacerFailures;

    //m current parser context

    struct ParserContext *pacContext;

    //m prototype to work with

    struct symtab_HSolveListElement *phslePrototype;
};

typedef struct ReplacerVariables_type ReplacerVariables;


//s replacer instance, derives from algorithm instance

struct ReplacerInstance
{
    //m base struct

    struct AlgorithmInstance algi;

    //m options for this instance

    ReplacerOptions ro;

    //m variables for this instance

    ReplacerVariables rv;
};


// local functions

static
int
ReplacerInstanceInsert
(struct ReplacerInstance *pri,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsle);

static
int
ReplacerInstanceProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static int ReplacerInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static 
int
ReplacerInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);


/// **************************************************************************
///
/// SHORT: ReplacerInstanceInsert()
///
/// ARGS.:
///
///	pri...: replacer algorithm instance.
///	ptstr.: active traversal.
///	phsle.: top symbol to consider.
///
/// RTN..: int : number of added symbols, -1 for failure.
///
/// DESCR: Insert symbols.
///
/// **************************************************************************

static
int
ReplacerInstanceInsert
(struct ReplacerInstance *pri,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : none added

    int iResult = 0;

    fprintf(stdout, "Replacer instance %s\n", pri->algi.pcIdentifier);

    //- lookup the prototype

    struct symtab_HSolveListElement *phslePrototype = pri->rv.phslePrototype;

    if (!phslePrototype)
    {
	//- lookup the prototype

	phslePrototype = ParserLookupPrivateModel(pri->ro.pcPrototype);
    }

    if (phslePrototype)
    {
	//- fill in the prototype

	pri->rv.phslePrototype = phslePrototype;

	//- determine a name for the new symbol

	struct symtab_IdentifierIndex *pidinAlias
	    = IdinCreateAlias(SymbolGetPidin(phslePrototype), 0);

	//- create an alias (symbol must be biocomp)

	struct symtab_HSolveListElement *phsleNew
	    = SymbolCreateAlias(phslePrototype, pidinAlias);

	//- add algorithm info

	int iInfo = 0;

	if (0
	    && !iInfo
	    && 0)
	{
	    if (SymbolSetAlgorithmInstanceInfo(phsle, &pri->algi))
	    {
		iInfo = 1;
	    }
	    else
	    {
		pri->rv.iReplacerFailures++;
	    }
	}

	if ((1
	     || iInfo
	     || 1)
	    && (1
		|| SymbolSetAlgorithmInstanceInfo(phsleNew, &pri->algi)
		|| 1))
	{
	    //- link symbol to segment

	    //t a todo

	    SymbolReplaceChild(phsle, phsleNew);
    
	    //- increment added symbol count

	    pri->rv.iReplacedSymbols++;

	    //- increment result

	    iResult++;
	}

	//- else

	else
	{
	    //- increment failure count

	    pri->rv.iReplacerFailures++;
	}
    }
    else
    {
	NeurospacesError
	    (pri->rv.pacContext,
	     "ReplacerInstance",
	     "Replacer instance %s cannot find symbol %s\n",
	     pri->algi.pcIdentifier,
	     pri->ro.pcPrototype);
    }

    if (pri->rv.iReplacerFailures)
    {
	NeurospacesError
	    (pri->rv.pacContext,
	     "ReplacerInstance",
	     "Replacer instance %s encountered %i failures\n",
	     pri->algi.pcIdentifier,
	     pri->rv.iReplacerFailures);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ReplacerInstanceNew()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of replacer algorithm.
///
/// **************************************************************************

struct AlgorithmInstance *
ReplacerInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/replacer_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct ReplacerInstance *pri
	= (struct ReplacerInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct ReplacerInstance), _vtable_replacer, HIERARCHY_TYPE_algorithm_instances_replacer);

    AlgorithmInstanceSetName(&pri->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//- get prototype

	struct symtab_Parameters *pparPrototype
	    = SymbolFindParameter(&palgs->hsle, "PROTOTYPE", ppist);

	if (pparPrototype)
	{
	    pri->ro.pcPrototype = ParameterGetString(pparPrototype);
	}
	else
	{
	    NeurospacesError
		(pacContext,
		 "ReplacerInstance",
		 "Replacer instance %s cannot resolve PROTOTYPE parameter\n",
		 pcInstance);
	}

	//- get symbol name selector

	struct symtab_Parameters *pparSelector
	    = SymbolFindParameter(&palgs->hsle, "NAME_SELECTOR", ppist);

	if (pparSelector)
	{
	    pri->ro.pcSelector = ParameterGetString(pparSelector);
	}
	else
	{
	    NeurospacesError
		(pacContext,
		 "ReplacerInstance",
		 "Replacer instance %s cannot resolve NAME_SELECTOR parameter\n",
		 pcInstance);
	}
    }

    //- initialize counts

    pri->rv.iReplacedSymbols = 0;
    pri->rv.iReplacerFailures = 0;
    pri->rv.iReplacerTries = 0;

    //- register parser context

    pri->rv.pacContext = pacContext;

    //- set result

    palgiResult = &pri->algi;

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ReplacerInstancePrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on replacer instance.
///
/// **************************************************************************

static int ReplacerInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct ReplacerInstance *pri = (struct ReplacerInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pri->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ReplacerInstance %s\n"
	 "report:\n"
	 "    number_of_tries: %i\n"
	 "    number_of_failures_adding: %i\n",
	 pcInstance,
	 pri->rv.iReplacerTries,
	 pri->rv.iReplacerFailures);

    fprintf
	(pfile,
	 "    ReplacerInstance prototype: %s\n"
	 "    ReplacerInstance name selector: %s\n",
	 pri->ro.pcPrototype,
	 pri->ro.pcSelector);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ReplacerInstanceProcessor()
///
/// ARGS.:
///
///	SymbolProcessor args
///
/// RTN..: int : 
///
///	SymbolProcessor return value, always SYMBOL_PROCESSOR_SUCCESS
///
/// DESCR: Obtain coordinates from encountered symbols.
///
/// **************************************************************************

static
int
ReplacerInstanceProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to algorithm instance

    struct ReplacerInstance *pri = (struct ReplacerInstance *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get algorithm instance info on symbol

    struct AlgorithmInstance *palgi
	= SymbolGetAlgorithmInstanceInfo(phsle);

    //- if already attached by some algorithm

    if (0
	&& palgi
	&& 0)
    {
	//- register failure in algorithm instance

	pri->rv.iReplacerFailures++;

	//- set result : ok, but process siblings

	iResult = TSTR_PROCESSOR_FAILURE;
    }

    //- if name matches

    char *pcSymbol = SymbolGetName(phsle);

    if (pri->ro.pcSelector
	&& strncmp(pcSymbol, pri->ro.pcSelector, strlen(pri->ro.pcSelector)) == 0)
    {
	//- replace components

	int iReplaced = ReplacerInstanceInsert(pri, ptstr->ppist, phsle);

	if (iReplaced == -1)
	{
	    iResult = TSTR_PROCESSOR_ABORT;
	}

    }

    //- return result

    return (iResult);
}


/// **************************************************************************
///
/// SHORT: ReplacerInstanceSymbolHandler()
///
/// ARGS.:
///
///	AlgorithmInstanceSymbolHandler args.
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to add replacer on given symbol
///
///	Does it do a clean update of serials ?
///
/// **************************************************************************

static 
int
ReplacerInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result: ok

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct ReplacerInstance *pri = (struct ReplacerInstance *)palgi;

    //- register current symbol as a variable

    pri->rv.phsleBase = phsle;

    pri->rv.ppistBase = ppist;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   NULL,
	   NULL,
	   ReplacerInstanceProcessor,
	   (void *)pri,
	   NULL,
	   NULL);

    //- traverse

    int iTraverse = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    if (iTraverse != 1)
    {
	iResult = FALSE;
    }

    SymbolRecalcAllSerials(phsle,ppist);

    //- return result

    return(iResult);
}


