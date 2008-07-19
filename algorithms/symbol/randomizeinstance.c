//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: randomizeinstance.c 1.25 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/cell.h"
#include "neurospaces/group.h"
#include "neurospaces/idin.h"
#include "neurospaces/iohier.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "randomize.h"
#include "randomizeinstance.h"


//s Randomize algorithm private data

/*s */
/*s struct with Randomize options */
/*S */

struct RandomizeOptions_type
{
    /*m name of symbol to randomize */

    char *pcSymbol;

    /*m name of parameter to randomize */

    char *pcParameter;

    /*m name of prototype target to randomize */

    char *pcTarget;

    /*m random seed */

    double dRandomSeed;

    /*m lower bound */

    double dLower;

    /*m upper bound */

    double dUpper;
};

typedef struct RandomizeOptions_type RandomizeOptions;


//s
//s Randomize variables
//s

struct RandomizeVariables_type
{
    //m current symbol to randomize

    struct symtab_BioComponent *pbio;

    //m target for symbolic parameter to add

    struct PidinStack *ppistTarget;

    /*m count on number of randomized symbols */

    int iRandomized;

    //m count on number of non-randomized symbols, expected */

    int iNonRandomizedExpected;

    //m count on number of non-randomized symbols, unexpected */

    int iNonRandomizedUnexpected;
};

typedef struct RandomizeVariables_type RandomizeVariables;


//s Randomize instance, derives from algorithm instance

struct RandomizeInstance
{
    //m base struct

    struct AlgorithmInstance algi;

    //m options for this instance

    RandomizeOptions rio;

    //m variables for this instance

    RandomizeVariables riv;
};


// local functions

static
int
RandomizeComponentSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static
int
RandomizeComponentProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static int 
RandomizeComponents
(struct RandomizeInstance *pri,
 struct ParserContext *pac,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

static int RandomizeInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static
int
RandomizeInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);



/// **************************************************************************
///
/// SHORT: RandomizeInstanceNew()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of Randomize algorithm.
///
/// **************************************************************************

struct AlgorithmInstance *
RandomizeInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/randomize_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct RandomizeInstance *pri
	= (struct RandomizeInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct RandomizeInstance), _vtable_randomize, HIERARCHY_TYPE_algorithm_instances_randomize);

    AlgorithmInstanceSetName(&pri->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//t should use ParameterResolveSymbol()

	struct symtab_Parameters *pparSymbol
	    = SymbolFindParameter(&palgs->hsle, "SYMBOL_NAME", ppist);

	//- scan addto symbol

	pri->rio.pcSymbol = ParameterGetString(pparSymbol);

	//- scan parameter name

	struct symtab_Parameters *pparParameter
	    = SymbolFindParameter(&palgs->hsle, "PARAMETER_NAME", ppist);

	pri->rio.pcParameter = ParameterGetString(pparParameter);

	//- scan target name

	struct symtab_Parameters *pparTarget
	    = SymbolFindParameter(&palgs->hsle, "TARGET_NAME", ppist);

	pri->rio.pcTarget = ParameterGetString(pparTarget);

	//- scan random seed

	pri->rio.dRandomSeed = SymbolParameterResolveValue(&palgs->hsle, ppist, "RANDOMSEED");

	//- scan lower bound

	pri->rio.dLower = SymbolParameterResolveValue(&palgs->hsle, ppist, "LOWER_BOUND");

	//- scan upper bound

	pri->rio.dUpper = SymbolParameterResolveValue(&palgs->hsle, ppist, "UPPER_BOUND");
    }

    //- initialize randomize count

    pri->riv.iRandomized = 0;
    pri->riv.iNonRandomizedExpected = 0;
    pri->riv.iNonRandomizedUnexpected = 0;

    //- set result

    palgiResult = &pri->algi;

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: RandomizeComponents()
///
/// ARGS.:
///
///	palg..: randomize algorithm.
///	phsle.: symbol with components to randomize.
///	ppist.: current parser context.
///
/// RTN..: int : success of operation.
///
/// DESCR: Randomizecomponents as specified by options and variables.
///
/// **************************************************************************

static
int
RandomizeComponentSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : selected

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

/*     //- get pointer to randomize instance */

/*     struct RandomizeInstance *pri = (struct RandomizeInstance *)pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- if not same type as prototype */

/*     if (phsle->iType != pri->riv.pbio->ioh.iol.hsle.iType) */
/*     { */
/* 	iResult = SYMBOL_SELECTOR_PROCESS_SIBLING; */
/*     } */

/*     //- if name does not match */

/*     if (strcmp(IdinName(SymbolGetPidin(phsle)),pri->rio.pcSymbol) != 0) */
/*     { */
/* 	//- return result : do not process */

/* 	iResult = SYMBOL_PROCESSOR_FAILURE; */

/* 	return(iResult); */
/*     } */

    //- return result

    return(iResult);
}


static
int
RandomizeComponentProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process siblings afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    struct symtab_Parameters *ppar = NULL;

    //- get pointer to randomize instance

    struct RandomizeInstance *pri = (struct RandomizeInstance *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- generate random value

    double dUpper = pri->rio.dUpper;
    double dLower = pri->rio.dLower;

    double dValue
	= ((double) random() / RAND_MAX) * (dUpper - dLower) + dLower;

    //- add parameter to symbol

    ppar = ParameterNewFromNumber(pri->rio.pcParameter,dValue);

    if (instanceof_bio_comp(phsle))
    {
	SymbolParameterLinkAtEnd(phsle, ppar);

	pri->riv.iRandomized++;
    }
    else if (instanceof_algorithm_symbol(phsle))
    {
	pri->riv.iNonRandomizedExpected++;
    }
    else
    {
	pri->riv.iNonRandomizedUnexpected++;
    }

    //- return result

    return(iResult);
}


static
int 
RandomizeComponents
(struct RandomizeInstance *pri,
 struct ParserContext *pac,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    int i;

    struct symtab_Parameters *ppar = NULL;
    struct symtab_IdentifierIndex *ppidin[10];
    struct symtab_IdentifierIndex *pidinField = NULL;
    char *pcField = NULL;

    struct TreespaceTraversal *ptstr = NULL;

    struct PidinStack *ppistTraversal = PidinStackDuplicate(ppist);

    //- add parameter to prototype : inherits from some ancestor

    for (i = 0 ; i < PidinStackNumberOfEntries(pri->riv.ppistTarget) ; i++)
    {
	ppidin[i] = IdinCalloc();

	IdinSetFlags(ppidin[i],FLAG_IDENTINDEX_PARENT);

	ppidin[i]->pidinRoot = ppidin[0];

	if (i > 0)
	{
	    ppidin[i - 1]->pidinNext = ppidin[i];
	}
    }

    pcField = calloc(1 + strlen(pri->rio.pcParameter),sizeof(pcField[0]));

    strcpy(pcField,pri->rio.pcParameter);

    pidinField = IdinNewFromChars(pcField);
    ppidin[i - 1]->pidinNext = pidinField;
    pidinField->pidinRoot = ppidin[0];
    IdinSetFlags(pidinField,FLAG_IDENTINDEX_FIELD);

    ppar = ParameterNewFromPidinQueue(pcField, ppidin[0], TYPE_PARA_FIELD);

    //- register this parameter in the biocomponent

    BioComponentChangeParameter(pri->riv.pbio,ppar);

    //- traverse symbol
    //-     selector : symbols for name
    //-     pre-processor : add parameter to symbol : randomize

    ptstr
	= TstrNew
	  (ppistTraversal,
	   RandomizeComponentSelector,
	   (void *)pri,
	   RandomizeComponentProcessor,
	   (void *)pri,
	   NULL,
	   NULL);

    TstrGo(ptstr,phsle);

    //- delete traversal

    TstrDelete(ptstr);

    //- free allocated memory

    PidinStackFree(ppistTraversal);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: RandomizeInstancePrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on randomization algorithm
///
/// **************************************************************************

static int RandomizeInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //v loop var

    int i;

    //- get pointer to randomize instance

    struct RandomizeInstance *pri = (struct RandomizeInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pri->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: RandomizeInstance %s\n"
	 "report:\n"
	 "    number_of_randomized_components: %i\n"
	 "    number_of_non-randomized_components_algorithm_symbols: %i\n"
	 "    number_of_non-randomized_components_unexpected: %i\n",
	 pcInstance,
	 pri->riv.iRandomized,
	 pri->riv.iNonRandomizedExpected,
	 pri->riv.iNonRandomizedUnexpected);

    fprintf
	(pfile,
	 "    RandomizeInstance_prototype: %s\n",
	 pri->riv.pbio
	 ? IdinName(SymbolGetPidin(&pri->riv.pbio->ioh.iol.hsle))
	 : "(none)");

    fprintf
	(pfile,
	 "    RandomizeInstance_options: %s->%s %f %f %f\n",
	 pri->rio.pcSymbol,
	 pri->rio.pcParameter,
	 pri->rio.dRandomSeed,
	 pri->rio.dLower,
	 pri->rio.dUpper);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: RandomizeInstanceSymbolHandler()
///
/// ARGS.:
///
///	AlgorithmSymbolHandler args.
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to randomize children of given symbol.
///
/// **************************************************************************

static
int
RandomizeInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to randomize instance

    struct RandomizeInstance *pri = (struct RandomizeInstance *)palgi;

    //- lookup target for change of parameters

    struct PidinStack *ppistPrivate = PidinStackParse(pri->rio.pcSymbol);

    struct symtab_HSolveListElement *phslePrivate = NULL;

    if (PidinStackIsNamespaced(ppistPrivate))
    {
	phslePrivate = SymbolsLookupHierarchical(NULL, ppistPrivate);
    }
    else
    {
	phslePrivate = ParserLookupPrivateModel(pri->rio.pcSymbol);
    }

    if (!phslePrivate)
    {
	NeurospacesError
	    (pac,
	     "Randomize algorithm instance",
	     "%s: private model %s not found\n",
	     pri->algi.pcIdentifier,
	     pri->rio.pcSymbol);

	return(FALSE);
    }

    pri->riv.ppistTarget = PidinStackParse(pri->rio.pcTarget);

    //- lookup symbol to which the target belongs

    phslePrivate
	= SymbolLookupHierarchical(phslePrivate,pri->riv.ppistTarget,0,TRUE);

    if (!phslePrivate)
    {
	NeurospacesError
	    (pac,
	     "Randomize algorithm instance",
	     "%s: target %s not found.\n",
	     pri->algi.pcIdentifier,
	     pri->rio.pcTarget);

	return(FALSE);
    }

    //- make sure we are dealing with biological components

    if (!instanceof_bio_comp(phslePrivate))
    {
	NeurospacesError
	    (pac,
	     "Randomize algorithm instance",
	     "%s: target %s must be instance of biological component.\n",
	     pri->algi.pcIdentifier,
	     pri->rio.pcTarget);

	return(FALSE);
    }

    //- register biocomponent in variables

    pri->riv.pbio = (struct symtab_BioComponent *)phslePrivate;

    //- set random seed

    srandom(pri->rio.dRandomSeed);

    //- add cells to population

    iResult = RandomizeComponents(pri, pac, phsle, ppist);

    //- return result

    return(iResult);
}


