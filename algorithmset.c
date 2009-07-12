//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmset.c 1.22 Tue, 19 Jun 2007 17:47:36 -0500 hugo $
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

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithmset.h"

#include "algorithms/symbol/connectionchecker.h"
#include "algorithms/symbol/dendrogram.h"
#include "algorithms/symbol/grid3d.h"
#include "algorithms/symbol/inserter.h"
#include "algorithms/symbol/projectionvolume.h"
#include "algorithms/symbol/projectionrandomized.h"
#include "algorithms/symbol/randomize.h"
#include "algorithms/symbol/spines.h"


/// 
/// \return AlgorithmSet * : Set of algorithms.
/// 
/// \brief Allocate algorithm set, init with default algorithm classes.
/// 

AlgorithmSet * AlgorithmSetCalloc(void)
{
    //- set default result : failure

    AlgorithmSet * pasResult = NULL;

    //- allocate memory

    pasResult = (AlgorithmSet *)calloc(1,sizeof(*pasResult));

    //- init algorithm list

    if (!AlgorithmSetInit(pasResult))
    {
	AlgorithmSetFree(pasResult);

	pasResult = NULL;
    }

    //- return result

    return(pasResult);
}


/// 
/// \arg pas set of algorithms
/// 
/// \return void
/// 
/// \brief Free algorithms list.
/// 

void AlgorithmSetFree(AlgorithmSet *pas)
{
    /// \todo remove all algorithm instances
    /// \todo remove all algorithm classes
    /// \todo free algorithm set

    // free set

//    free(pas);
}


/// 
/// \arg pas set of algorithms
/// \arg pcName name of algorithm class to import
/// \arg pcInstance name of algorithm instance to create
/// \arg pcInit init string for algorithm
/// \arg ppar algorithm instantiation parameters.
/// \arg palgs algorithm symbol.
/// 
/// \return struct AlgorithmInstance * 
/// 
///	Instantiated algorithm, NULL for failure.
/// 
/// \brief Instantiat an algorithm from given algorithm class.
/// 

struct AlgorithmInstance *
AlgorithmSetInstantiateAlgorithm
(AlgorithmSet *pas,
 PARSERCONTEXT *pacContext,
 char *pcName,
 char *pcInstance,
 char *pcInit,
 struct symtab_Parameters *ppar,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- lookup algorithm class in imported list

    struct AlgorithmClass *palgc = AlgorithmSetLookupAlgorithmClass(pas,pcName);

    //- if not found

    if (!palgc)
    {
	//- try to load algorithm

	palgc = AlgorithmSetLoadAlgorithmClass(pas,pcName);
    }

    //- if algorithm class found or loaded

    if (palgc)
    {
	//- construct instance from class

	palgiResult
	    = palgc->ppfHandlers->pfCreateInstance
	      (palgc, pcInstance, pacContext, palgs);

	if (palgiResult)
	{
/* 	    //- set flag : algorithm active */

/* 	    palgiResult->iFlags |= ALGORITHM_FLAG_MODELACTIVE; */

	    /// \todo check event types, register event listeners

	    //- link algorithm instance into instance list

	    HSolveListEnqueue(&pas->hslInstances, &palgiResult->hsleLink);

	    pas->iInstances++;
	}

	//- else

	else
	{
	    //- remember failure

	    palgiResult = NULL;
	}
    }

    //- return result

    return(palgiResult);
}


/// 
/// \arg pas set of algorithms
/// 
/// \return int
/// 
///	success of operation
/// 
/// \brief init algorithms
/// 

int AlgorithmSetInit(AlgorithmSet *pas)
{
    //- set default result : ok

    int bResult = TRUE;

    //- initialize algorithm class list

    HSolveListInit(&pas->hslClasses);

    pas->iClasses = 0;

    //- initialize algorithm instances list

    HSolveListInit(&pas->hslInstances);

    pas->iInstances = 0;

/*     //- add serial segment algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialSegment->hsleLink); */

/*     //- add serial cell algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialCell->hsleLink); */

/*     //- add serial population algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialPopulation->hsleLink); */

/*     //- add serial connection algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialConnection->hsleLink); */

/*     //- add serial projection algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialProjection->hsleLink); */

/*     //- add serial network algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSerialNetwork->hsleLink); */

/*     //- add cerebellum algorithm */

/*     HSolveListEnqueue(&pas->hslClasses,&palgCerebellum->hsleLink); */

    //- add regular dendrogram algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcDendrogram->hsleLink);

    pas->iClasses++;

    //- add regular grid 3D algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcGrid3D->hsleLink);

    pas->iClasses++;

    //- add regular inserter algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcInserter->hsleLink);

    pas->iClasses++;

    //- add regular projection volume algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcProjectionVolume->hsleLink);

    pas->iClasses++;

    //- add regular projection randomized algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcProjectionRandomized->hsleLink);

    pas->iClasses++;

    //- add regular spines algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcSpines->hsleLink);

    pas->iClasses++;

    //- add regular randomize algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcRandomize->hsleLink);

    pas->iClasses++;

    //- add regular connection checker algorithm

    HSolveListEnqueue(&pas->hslClasses,&palgcConnectionChecker->hsleLink);

    pas->iClasses++;

/*     //- add spines_with_events algorithm */

/*     /// \note spines algorithm at front of list, gives fast lookup */

/*     HSolveListEnqueue(&pas->hslClasses,&palgSpinesEvents->hsleLink); */

/*     //- initialize serial population algorithm */

/*     bResult = palgSerialPopulation->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialPopulation,"SerialPopulation",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialPopulation->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

/*     //- initialize serial connection algorithm */

/*     bResult = palgSerialConnection->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialConnection,"SerialConnection",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialConnection->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

/*     //- initialize serial projection algorithm */

/*     bResult = palgSerialProjection->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialProjection,"SerialProjection",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialProjection->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

/*     //- initialize serial network algorithm */

/*     bResult = palgSerialNetwork->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialNetwork,"SerialNetwork",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialNetwork->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

/*     //- initialize serial cell algorithm */

/*     bResult = palgSerialCell->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialCell,"SerialCell",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialCell->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

/*     //- initialize serial segment algorithm */

/*     bResult = palgSerialSegment->ppfAlgorithmHandlers->pfInit */
/* 	(palgSerialSegment,"SerialSegment",NULL,pisSymbols); */

/*     if (bResult) */
/*     { */
/* 	palgSerialSegment->iFlags |= ALGORITHM_FLAG_ACTIVE; */
/*     } */

    //- return result

    return(bResult);
}


/// 
/// \arg pas algorithm set
/// \arg pcName name of algorithm class to load
/// 
/// \return struct AlgorithmClass * 
/// 
///	Newly loaded algorithm class, NULL for failure
/// 
/// \brief Load algorithm class with given name
/// 

struct AlgorithmClass * AlgorithmSetLoadAlgorithmClass(AlgorithmSet *pas,char *pcName)
{
    //- set default result : failure

    struct AlgorithmClass *palgcResult = NULL;

    //- lookup algorithm somewhere

    int bFound = FALSE;

    //- if found

    if (bFound)
    {
	//- allocate algorithm instance

	palgcResult = AlgorithmClassCalloc();

	/// \todo load algorithm
	/// \todo link into algorithm list
    }

    //- return result

    return(palgcResult);
}


/// 
/// \arg pas algorithm set
/// \arg pcName name of algorithm to search for
/// 
/// \return struct AlgorithmClass * 
/// 
///	algorithm class with given name, NULL for not found
/// 
/// \brief search for a algorithm class in the class list
/// 

struct AlgorithmClass * AlgorithmSetLookupAlgorithmClass(AlgorithmSet *pas,char *pcName)
{
    //- set default result : failure

    struct AlgorithmClass *palgcResult = NULL;

    //- loop through the class list

    struct AlgorithmClass *palgc
	= (struct AlgorithmClass *)HSolveListHead(&pas->hslClasses);

    while (HSolveListValidSucc(&palgc->hsleLink))
    {
	//- if class name matches

	if (strcmp(palgc->pcIdentifier,pcName) == 0)
	{
	    //- set result

	    palgcResult = palgc;

	    //- break loop

	    break;
	}

	//- go to next element

	palgc = (struct AlgorithmClass *)HSolveListNext(&palgc->hsleLink);
    }

    //- return result

    return(palgcResult);
}


/// 
/// \arg pas set of algorithms
/// \arg pfile file to print algorithm info to
/// \arg pc name of classes to print
/// 
/// \return int
/// 
///	success of operation
/// 
/// \brief print algorithm class info.
/// 

int AlgorithmSetClassPrint(AlgorithmSet *pas, char *pc, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    struct AlgorithmClass *palgc = NULL;

    if (!pfile)
    {
	pfile = stdout;
    }

    //- loop through the class list

    palgc
	= (struct AlgorithmClass *)HSolveListHead(&pas->hslClasses);

    while (HSolveListValidSucc(&palgc->hsleLink))
    {
	//- if name matches

	if (strncmp(palgc->pcIdentifier, pc, strlen(pc)) == 0)
	{
	    //- if info handler available

	    if (palgc->ppfHandlers->pfPrintInfo)
	    {
		//- print algorithm info, remember result

		bResult
		    = bResult
		      && palgc->ppfHandlers->pfPrintInfo
		         (palgc,palgc->pcIdentifier,NULL,pfile);
	    }
	}

	//- go to next element

	palgc = (struct AlgorithmClass *)HSolveListNext(&palgc->hsleLink);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pas set of algorithms
/// \arg pfile file to print algorithm info to
/// \arg pc name of instances to print
/// 
/// \return int
/// 
///	success of operation
/// 
/// \brief print algorithm info for algorithm classes and instances.
/// 

int AlgorithmSetInstancePrint(AlgorithmSet *pas, char *pc, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    struct AlgorithmInstance *palgi = NULL;

    if (!pfile)
    {
	pfile = stdout;
    }

    //- loop through the instance list

    palgi
	= (struct AlgorithmInstance *)HSolveListHead(&pas->hslInstances);

    while (HSolveListValidSucc(&palgi->hsleLink))
    {
	//- if name matches

	if (strncmp(palgi->pcIdentifier, pc, strlen(pc)) == 0)
	{
	    //- print algorithm instance info

	    bResult = bResult && AlgorithmInstancePrintInfo(palgi, pfile);
	}

	//- go to next element

	palgi = (struct AlgorithmInstance *)HSolveListNext(&palgi->hsleLink);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pas set of algorithms
/// \arg pfile file to print algorithm info to
/// 
/// \return int
/// 
///	success of operation
/// 
/// \brief print algorithm info for algorithm classes and instances.
/// 

int AlgorithmSetPrint(AlgorithmSet *pas,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    struct AlgorithmClass *palgc = NULL;
    struct AlgorithmInstance *palgi = NULL;

    //- print info : algorithm classes

    fprintf(pfile, "---\n");
    fprintf(pfile, "number_of_algorithm_classes: %i\n",pas->iClasses);

    //- loop through the class list

    palgc
	= (struct AlgorithmClass *)HSolveListHead(&pas->hslClasses);

    while (HSolveListValidSucc(&palgc->hsleLink))
    {
	//- if info handler available

	if (palgc->ppfHandlers->pfPrintInfo)
	{
	    //- print algorithm info, remember result

	    bResult
		= bResult
		  && palgc->ppfHandlers->pfPrintInfo
		     (palgc,palgc->pcIdentifier,NULL,pfile);
	}

	//- go to next element

	palgc = (struct AlgorithmClass *)HSolveListNext(&palgc->hsleLink);
    }

    //- print info : algorithm instances

    fprintf(pfile, "---\n");
    fprintf(pfile, "number_of_algorithm_instances: %i\n", pas->iInstances);

    //- loop through the instance list

    palgi
	= (struct AlgorithmInstance *)HSolveListHead(&pas->hslInstances);

    while (HSolveListValidSucc(&palgi->hsleLink))
    {
	//- print algorithm instance info

	bResult = bResult && AlgorithmInstancePrintInfo(palgi, pfile);

	//- go to next element

	palgi = (struct AlgorithmInstance *)HSolveListNext(&palgi->hsleLink);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pas algorithm set
/// \arg pev event to propagate
/// 
/// \return int
/// 
///	success of operation
/// 
/// \brief propagate event through algorithms registered for this event type
/// 

/* int AlgorithmSetPropagateParserEvent(AlgorithmSet *pas,ParserEvent *pev) */
/* { */
/*     //- set default result : failure */

/*     int bResult = FALSE; */

/*     //- look at type of event */

/*     switch (pev->iType & EVENT_MASK_TYPES) */

/*     //- hardcoded : non event */

/*     switch ((44 << EVENT_OFFSET_TYPES)) */
/*     { */

/*     //- if pure event */

/*     case 0: */
/*     { */
/* 	//- look at action of event */

/* 	switch (pev->iType & EVENT_MASK_ACTIONS) */
/* 	{ */
/* 	//- for EVENT_ACTION_START */

/* 	case EVENT_ACTION_START: */
/* 	{ */
/* 	    break; */
/* 	} */

/* 	//- for EVENT_ACTION_FINISH */

/* 	case EVENT_ACTION_FINISH: */
/* 	{ */
/* 	    //- call connection array organizer */

/* 	    /// \note hard coded */

/* 	    bResult */
/* 		= palgSerialConnection */
/* 		  ->pevatListeners->pevas[0].pfParserEventListener */
/* 		  (pev,palgSerialConnection); */

/* 	    break; */
/* 	} */

/* 	} */

/* 	break; */
/*     } */

/*     //- for segment */

/*     case EVENT_TYPE_SEGMENT: */
/*     { */
/* 	//- get pointer to spine algorithm */

/* 	struct symtab_Algorithm * palgSpinesEvents = AlgorithmLookup(phslAlgorithmsList,"Spines_with_events"); */

/* 	//- call segmental array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialSegment->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialSegment); */

/* 	//- if spine algorithm active */

/* 	if (palgSpinesEvents->iFlags & ALGORITHM_FLAG_ACTIVE */
/* 	    || palgSpinesEvents->iFlags & ALGORITHM_FLAG_MODELACTIVE) */
/* 	{ */
/* 	    //- call spine segment listener */

/* 	    /// \note a bit less hardcoded */

/* 	    bResult */
/* 		= palgSpinesEvents->pevatListeners->pevas[0].pfParserEventListener */
/* 		  (pev,palgSpinesEvents); */
/* 	} */

/* 	break; */
/*     } */

/*     //- for cell */

/*     case EVENT_TYPE_CELL: */
/*     { */
/* 	//- call cell array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialCell->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialCell); */

/* /* 	//- if spine algorithm active * */

/* /* 	if (palgSpinesEvents->iFlags & ALGORITHM_FLAG_ACTIVE * */
/* /* 	    || palgSpinesEvents->iFlags & ALGORITHM_FLAG_MODELACTIVE) * */
/* /* 	{ * */
/* /* 	    //- call spine cell listener * */

/* /* 	    /// \note a bit less hardcoded * */

/* /* 	    bResult * */
/* /* 		= palgSpinesEvents->pevatListeners->pevas[1].pfParserEventListener * */
/* /* 		  (pev,palgSpinesEvents); * */
/* /* 	} * */

/* 	break; */
/*     } */

/*     //- for population */

/*     case EVENT_TYPE_POPULATION: */
/*     { */
/* 	//- call population array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialPopulation->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialPopulation); */

/* 	break; */
/*     } */

/*     //- for connection */

/*     case EVENT_TYPE_CONNECTION: */
/*     { */
/* 	//- call connection array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialConnection->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialConnection); */

/* 	break; */
/*     } */

/*     //- for projection */

/*     case EVENT_TYPE_PROJECTION: */
/*     { */
/* 	//- call projection array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialProjection->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialProjection); */

/* 	break; */
/*     } */

/*     //- for network */

/*     case EVENT_TYPE_NETWORK: */
/*     { */
/* 	//- get pointer to cerebellum algorithm */

/* 	struct symtab_Algorithm * palgCerebellumConnections */
/* 	    = AlgorithmLookup(phslAlgorithmsList,"CerebellumConnections"); */

/* 	//- call network array organizer */

/* 	/// \note hard coded */

/* 	bResult */
/* 	    = palgSerialNetwork->pevatListeners->pevas[0].pfParserEventListener */
/* 	      (pev,palgSerialNetwork); */

/* 	//- if cerebellum algorithm active */

/* 	if (palgCerebellumConnections->iFlags & ALGORITHM_FLAG_ACTIVE */
/* 	    || palgCerebellumConnections->iFlags & ALGORITHM_FLAG_MODELACTIVE) */
/* 	{ */
/* 	    //- call cerebellar connection listener */

/* 	    /// \note a bit less hardcoded */

/* 	    bResult */
/* 		= palgCerebellumConnections */
/* 		  ->pevatListeners->pevas[0].pfParserEventListener */
/* 		  (pev,palgCerebellumConnections); */
/* 	} */

/* 	break; */
/*     } */

/*     //- else */

/*     default: */
/*     { */
/* 	//- give diagnostics : not implemented */

/* 	fprintf */
/* 	    (stderr, */
/* 	     "Propagation of event type %i not implemented\n", */
/* 	     pev->iType); */

/* 	break; */
/*     } */
/*     } */

/*     //- return result */

/*     return(bResult); */
/* } */


