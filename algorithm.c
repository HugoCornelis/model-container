//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithm.c 1.45 Sun, 11 Mar 2007 21:42:11 -0500 hugo $
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



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/cell.h"
#include "neurospaces/segment.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/algorithm.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/vector.h"

#include "algorithms/event/cerebellum.h"
#include "algorithms/event/serialcell.h"
#include "algorithms/event/serialsegment.h"
#include "algorithms/event/serialconnection.h"
#include "algorithms/event/serialnetwork.h"
#include "algorithms/event/serialpopulation.h"
#include "algorithms/event/serialprojection.h"
#include "algorithms/symbol/grid3d.h"
#include "algorithms/symbol/spines.h"


//v list of algorithms

static HSolveList * phslAlgorithmsList = NULL;


//d algorithm is active

#define ALGORITHM_FLAG_ACTIVE		1

//d algorithm is active in current model section

#define ALGORITHM_FLAG_MODELACTIVE		2


/// **************************************************************************
///
/// SHORT: AlgorithmCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Algorithm * 
///
///	Newly allocated algorithm, NULL for failure
///
/// DESCR: Allocate a new algorithm symbol table element
///
/// **************************************************************************

struct symtab_Algorithm * AlgorithmCalloc(void)
{
    //- set default result : failure

    struct symtab_Algorithm *palgResult = NULL;

    //- allocate algorithm

    palgResult
	= (struct symtab_Algorithm *)
	  calloc(1,sizeof(struct symtab_Algorithm));

    //- initialize algorithm

    AlgorithmInit(palgResult);

    //- return result

    return(palgResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmDisable()
///
/// ARGS.:
///
///	pcName.: name of algorithm to import
///	pcInit.: init string for algorithm
///
/// RTN..: int : success of operation
///
/// DESCR: disable algorithm with given name
///
/// **************************************************************************

int
AlgorithmDisable
(HSolveList *phsl,char *pcName,PARSERCONTEXT *pacContext)
{
    //- set default result : failure

    int bResult = FALSE;

    //- lookup algorithm in imported list

    struct symtab_Algorithm *palg = AlgorithmLookup(phsl,pcName);

    //- if found

    if (palg)
    {
	//- set flag : algorithm inactive

	palg->iFlags &= ~ALGORITHM_FLAG_MODELACTIVE;

	//- set result : ok

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: AlgorithmHandleSymbol() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	palg..: algorithm to handle symbol */
/* ///	phsle.: symbol to handle */
/* ///	pv....: user data */
/* /// */
/* /// RTN..: int : success of operation */
/* /// */
/* /// DESCR: Ask algorithm to handle a symbol. */
/* /// */
/* /// ************************************************************************** */

/* int AlgorithmHandleSymbol */
/* (struct symtab_Algorithm *palg,struct symtab_HSolveListElement *phsle,void *pv) */
/* { */
/*     //- set default result : ok */

/*     int iResult = TRUE; */

/*     //- call algorithm's symbol handler */

/*     iResult = palg->ppfAlgorithmHandlers->pfSymbolHandler(palg,phsle,pv); */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: AlgorithmImport()
///
/// ARGS.:
///
///	pcName.: name of algorithm to import
///	pcInit.: init string for algorithm
///
/// RTN..: struct symtab_Algorithm * 
///
///	Imported & inited algorithm, NULL for failure
///
/// DESCR: import algorithm with given name
///
///	Look for algorithm in imported algorithm list, if not already loaded,
///	load algorithm
///	Algorithm is linked into algorithm list and initialized with given init
///	string.
///
/// **************************************************************************

struct symtab_Algorithm *
AlgorithmImport
(HSolveList *phsl,char *pcName,PARSERCONTEXT *pacContext,char *pcInit)
{
    //- set default result : failure

    struct symtab_Algorithm *palgResult = NULL;

    //- lookup algorithm in imported list

    palgResult = AlgorithmLookup(phsl,pcName);

    //- if not found

    if (!palgResult)
    {
	//- try to load algorithm

	palgResult = AlgorithmLoad(phsl,pcName);
    }

    //- if algorithm found or loaded

    if (palgResult)
    {
	//- if initialize algorithm with init string

	if (palgResult->ppfAlgorithmHandlers->pfInit
	    (palgResult,pcName,pacContext,pcInit))
	{
	    //- set flag : algorithm active

	    palgResult->iFlags |= ALGORITHM_FLAG_MODELACTIVE;

	    //t check event types, register event listeners
	}

	//- else

	else
	{
	    //- remember failure

	    palgResult = NULL;
	}
    }

    //- return result

    return(palgResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmInit()
///
/// ARGS.:
///
///	palg.: algorithm to init
///
/// RTN..: void
///
/// DESCR: init algorithm
///
/// **************************************************************************

void AlgorithmInit(struct symtab_Algorithm *palg)
{
    //- initialize algorithm

    memset(palg,0,sizeof(*palg));
}


/// **************************************************************************
///
/// SHORT: AlgorithmLoad()
///
/// ARGS.:
///
/// RTN..: struct symtab_Algorithm * 
///
///	Newly loaded algorithm, NULL for failure
///
/// DESCR: Load algorithm with given name
///
/// **************************************************************************

struct symtab_Algorithm * AlgorithmLoad(HSolveList *phsl,char *pcName)
{
    //- set default result : failure

    struct symtab_Algorithm *palgResult = NULL;

    //- lookup algorithm somewhere

    int bFound = FALSE;

    //- if found

    if (bFound)
    {
	//- allocate algorithm

	palgResult = AlgorithmCalloc();

	//t load algorithm
	//t link into algorithm list
    }

    //- return result

    return(palgResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmLookup()
///
/// ARGS.:
///
///	phsl...: list of algorithms
///	pcName.: name of algorithm to search for
///
/// RTN..: struct symtab_Algorithm * 
///
///	algorithm with given name, NULL for not found
///
/// DESCR: search for a algorithm in the algorithm list
///
/// **************************************************************************

struct symtab_Algorithm * AlgorithmLookup(HSolveList *phsl,char *pcName)
{
    //- set default result : failure

    struct symtab_Algorithm *palgResult = NULL;

    //- loop through the algorithm list

    struct symtab_Algorithm *palg
	= (struct symtab_Algorithm *)HSolveListHead(phsl);

    while (HSolveListValidSucc(&palg->hsleLink))
    {
	//- if algorithm name matches

	if (strcmp(palg->pcIdentifier,pcName) == 0)
	{
	    //- set result

	    palgResult = palg;

	    //- break loop

	    break;
	}

	//- go to next element

	palg = (struct symtab_Algorithm *)HSolveListNext(&palg->hsleLink);
    }

    //- return result

    return(palgResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmName()
///
/// ARGS.:
///
///	palg.: algorithm to get name for
///
/// RTN..: char * : name of algorithm, NULL for failure
///
/// DESCR: get name of algorithm
///
///	Return value is pointer to symbol table read only data
///
/// **************************************************************************

char * AlgorithmName(struct symtab_Algorithm *palg)
{
    //- set default result : no name

    char *pcResult = NULL;

    //- set result from name

    pcResult = palg->pcIdentifier;

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmsInit()
///
/// ARGS.:
///
///	phslAlgorithms.: algorithm list to initialize
///
/// RTN..: int
///
///	success of operation
///
/// DESCR: init algorithms
///
/// **************************************************************************

int AlgorithmsInit(HSolveList *phslAlgorithms,struct Symbols *pisSymbols)
{
    //- set default result : ok

    int bResult = TRUE;

    //- initialize algorithm list

    HSolveListInit(phslAlgorithms);

    //- add serial segment algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialSegment->hsleLink);

    //- add serial cell algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialCell->hsleLink);

    //- add serial population algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialPopulation->hsleLink);

    //- add serial connection algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialConnection->hsleLink);

    //- add serial projection algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialProjection->hsleLink);

    //- add serial network algorithm

    HSolveListEnqueue(phslAlgorithms,&palgSerialNetwork->hsleLink);

    //- add cerebellum algorithm

    HSolveListEnqueue(phslAlgorithms,&palgCerebellum->hsleLink);

    //- add regular grid 3D algorithm

    //! grid 3D algorithm at front of list, gives fast lookup

/*     HSolveListEnqueue(phslAlgorithms,&palgGrid3D->hsleLink); */

    //- add regular spines algorithm

    //! spines algorithm at front of list, gives fast lookup

/*     HSolveListEnqueue(phslAlgorithms,&palgSpines->hsleLink); */

/*     //- add spines_with_events algorithm */

/*     //! spines algorithm at front of list, gives fast lookup */

/*     HSolveListEnqueue(phslAlgorithms,&palgSpinesEvents->hsleLink); */

    //- initialize local algorithm list

    phslAlgorithmsList = phslAlgorithms;

    //- initialize serial population algorithm

    bResult = palgSerialPopulation->ppfAlgorithmHandlers->pfInit
	(palgSerialPopulation,"SerialPopulation",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialPopulation->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- initialize serial connection algorithm

    bResult = palgSerialConnection->ppfAlgorithmHandlers->pfInit
	(palgSerialConnection,"SerialConnection",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialConnection->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- initialize serial projection algorithm

    bResult = palgSerialProjection->ppfAlgorithmHandlers->pfInit
	(palgSerialProjection,"SerialProjection",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialProjection->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- initialize serial network algorithm

    bResult = palgSerialNetwork->ppfAlgorithmHandlers->pfInit
	(palgSerialNetwork,"SerialNetwork",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialNetwork->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- initialize serial cell algorithm

    bResult = palgSerialCell->ppfAlgorithmHandlers->pfInit
	(palgSerialCell,"SerialCell",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialCell->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- initialize serial segment algorithm

    bResult = palgSerialSegment->ppfAlgorithmHandlers->pfInit
	(palgSerialSegment,"SerialSegment",NULL,pisSymbols);

    if (bResult)
    {
	palgSerialSegment->iFlags |= ALGORITHM_FLAG_ACTIVE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmsPrint()
///
/// ARGS.:
///
///	phsl..: list of algorithms
///	pfile.: file to print algorithm info to
///
/// RTN..: int
///
///	success of operation
///
/// DESCR: print algorithm info for registered algorithms
///
/// **************************************************************************

int AlgorithmsPrint(HSolveList *phsl,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- loop through the algorithm list

    struct symtab_Algorithm *palg
	= (struct symtab_Algorithm *)HSolveListHead(phsl);

    while (HSolveListValidSucc(&palg->hsleLink))
    {
	//- if info handler available

	if (palg->ppfAlgorithmHandlers->pfPrintInfo)
	{
	    //- print algorithm info, remember result

	    bResult
		= bResult
		  && palg->ppfAlgorithmHandlers->pfPrintInfo
		     (palg,palg->pcIdentifier,NULL,pfile);
	}

	//- go to next element

	palg = (struct symtab_Algorithm *)HSolveListNext(&palg->hsleLink);
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmsPropagateParserEvent()
///
/// ARGS.:
///
///	pev...: event to propagate
///
/// RTN..: int
///
///	success of operation
///
/// DESCR: propagate event through registered algorithms for this event type
///
/// **************************************************************************

int AlgorithmsPropagateParserEvent(ParserEvent *pev)
{
    //- set default result : ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- if pure event

    case 0:
    {
	//- look at action of event

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- for EVENT_ACTION_START

	case EVENT_ACTION_START:
	{
	    break;
	}

	//- for EVENT_ACTION_FINISH

	case EVENT_ACTION_FINISH:
	{
	    //- call connection array organizer

	    //! hard coded

	    bResult
		= palgSerialConnection
		  ->pevatListeners->pevas[0].pfParserEventListener
		  (pev,palgSerialConnection);

	    break;
	}

	}

	break;
    }

    //- for segment

    case EVENT_TYPE_SEGMENT:
    {
	//- get pointer to spine algorithm

	struct symtab_Algorithm * palgSpinesEvents = AlgorithmLookup(phslAlgorithmsList,"Spines_with_events");

	//- call segmental array organizer

	//! hard coded

	bResult
	    = palgSerialSegment->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialSegment);

	//- if spine algorithm active

	if (palgSpinesEvents->iFlags & ALGORITHM_FLAG_ACTIVE
	    || palgSpinesEvents->iFlags & ALGORITHM_FLAG_MODELACTIVE)
	{
	    //- call spine segment listener

	    //! a bit less hardcoded

	    bResult
		= palgSpinesEvents->pevatListeners->pevas[0].pfParserEventListener
		  (pev,palgSpinesEvents);
	}

	break;
    }

    //- for cell

    case EVENT_TYPE_CELL:
    {
	//- call cell array organizer

	//! hard coded

	bResult
	    = palgSerialCell->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialCell);

/* 	//- if spine algorithm active */

/* 	if (palgSpinesEvents->iFlags & ALGORITHM_FLAG_ACTIVE */
/* 	    || palgSpinesEvents->iFlags & ALGORITHM_FLAG_MODELACTIVE) */
/* 	{ */
/* 	    //- call spine cell listener */

/* 	    //! a bit less hardcoded */

/* 	    bResult */
/* 		= palgSpinesEvents->pevatListeners->pevas[1].pfParserEventListener */
/* 		  (pev,palgSpinesEvents); */
/* 	} */

	break;
    }

    //- for population

    case EVENT_TYPE_POPULATION:
    {
	//- call population array organizer

	//! hard coded

	bResult
	    = palgSerialPopulation->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialPopulation);

	break;
    }

    //- for connection

    case EVENT_TYPE_CONNECTION:
    {
	//- call connection array organizer

	//! hard coded

	bResult
	    = palgSerialConnection->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialConnection);

	break;
    }

    //- for projection

    case EVENT_TYPE_PROJECTION:
    {
	//- call projection array organizer

	//! hard coded

	bResult
	    = palgSerialProjection->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialProjection);

	break;
    }

    //- for network

    case EVENT_TYPE_NETWORK:
    {
	//- get pointer to cerebellum algorithm

	struct symtab_Algorithm * palgCerebellumConnections
	    = AlgorithmLookup(phslAlgorithmsList,"CerebellumConnections");

	//- call network array organizer

	//! hard coded

	bResult
	    = palgSerialNetwork->pevatListeners->pevas[0].pfParserEventListener
	      (pev,palgSerialNetwork);

	//- if cerebellum algorithm active

	if (palgCerebellumConnections->iFlags & ALGORITHM_FLAG_ACTIVE
	    || palgCerebellumConnections->iFlags & ALGORITHM_FLAG_MODELACTIVE)
	{
	    //- call cerebellar connection listener

	    //! a bit less hardcoded

	    bResult
		= palgCerebellumConnections
		  ->pevatListeners->pevas[0].pfParserEventListener
		  (pev,palgCerebellumConnections);
	}

	break;
    }

    //- else

    default:
    {
	//- give diagnostics : not implemented

	fprintf
	    (stderr,
	     "Propagation of event type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


