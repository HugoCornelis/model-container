//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: modelevent.c 1.46 Thu, 27 Sep 2007 18:36:41 -0500 hugo $
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
#include <string.h>

#include "neurospaces/algorithm.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: ParserEventCellGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	pcell....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for cell symbol
///
/// **************************************************************************

int ParserEventCellGenerate
(int iParserEvent,
 struct symtab_Cell *pcell,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //v sections of cell

    struct symtab_HSolveListElement * phsleSection = NULL;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    // push cell name on context element stack

    //PidinStackPushAll(&ev.pist,CellGetPidin(pcell));

    //- loop over sections in the cell

    phsleSection
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&pcell->segr.bio.ioh.iohc);

    while (HSolveListValidSucc(&phsleSection->hsleLink))
    {
	//- look at type of section

	switch (phsleSection->iType)
	{
	//- for single segment

	case HIERARCHY_TYPE_symbols_segment:
	{
	    //- generate segment event

	    ParserEventSegmentGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Segment *)phsleSection,
		 &ev.pist);

	    break;
	}

/* 	//- for multiple segments */

/* 	case TYPE_HSLE_VECTOR_BASE: */
/* 	{ */
/* 	    //- generate segment enumeration event */

/* 	    ParserEventGenerate */
/* 		(EVENT_MULTIPLECOMPD3 | (iParserEvent & EVENT_MASK_ACTIONS), */
/* 		 phsleSection, */
/* 		 &ev.pist); */

/* 	    break; */
/* 	} */

	//- else

	default:
	{
	    //- illegal section in cell, give diagnostics

	    //! need parser context here

	    NeurospacesError
		(NULL,
		 "Cell event generation",
		 "Illegal sections in cell\n");

	    break;
	}
	}

	//- get next section

	phsleSection
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsleSection->hsleLink);
    }

    //- construct event

    ev.iType = iParserEvent | EVENT_TYPE_CELL;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)pcell;

    //- write context element as context of event

    ev.pist = *ppist;

    //- if failure propagating event through algorithms

    if (!AlgorithmsPropagateParserEvent(&ev))
    {
	//- return failure

	return(FALSE);
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventSegmentGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	psegment....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for single segment symbol
///
/// **************************************************************************

int ParserEventSegmentGenerate
(int iParserEvent,
 struct symtab_Segment *psegment,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    //- construct segment event

    ev.iType = iParserEvent | EVENT_TYPE_SEGMENT;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)psegment;

    //- write context element as context of event

    ev.pist = *ppist;

    //- propagate event through algorithms

    bResult = AlgorithmsPropagateParserEvent(&ev);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventConnectionGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	pconn....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for connection symbol
///
/// **************************************************************************

int ParserEventConnectionGenerate
(int iParserEvent,
 struct symtab_Connection *pconn,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    //- construct connection event

    ev.iType = iParserEvent | EVENT_TYPE_CONNECTION;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)pconn;

    //- write context element as context of event

    ev.pist = *ppist;

    //- propagate event through algorithms

    bResult = AlgorithmsPropagateParserEvent(&ev);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventNetworkGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	pnetw....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for network symbol
///
/// **************************************************************************

int ParserEventNetworkGenerate
(int iParserEvent,
 struct symtab_Network *pnetw,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //v sections of network

    struct symtab_HSolveListElement * phsleSection = NULL;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    // push network name on context element stack

    //PidinStackPushAll(&ev.pist,NetworkGetPidin(pnetw));

    //- loop over sections in the network

    phsleSection
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&pnetw->segr.bio.ioh.iohc);

    while (HSolveListValidSucc(&phsleSection->hsleLink))
    {
	//- look at type of section

	switch (phsleSection->iType)
	{
	//- for network

	case HIERARCHY_TYPE_symbols_network:
	{
	    //- generate network event

	    ParserEventNetworkGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Network *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- for population

	case HIERARCHY_TYPE_symbols_population:
	{
	    //- generate population event

	    ParserEventPopulationGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Population *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- for cell

	case HIERARCHY_TYPE_symbols_cell:
	{
	    //- generate cell event

	    ParserEventCellGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Cell *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- for connection

	case HIERARCHY_TYPE_symbols_connection:
	{
	    //- generate connection event

	    ParserEventConnectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Connection *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- for projection

	case HIERARCHY_TYPE_symbols_projection:
	{
	    //- generate projection event

	    ParserEventProjectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Projection *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- else

	default:
	{
	    //- illegal section in network, give diagnostics

	    //! need parser context here

	    NeurospacesError
		(NULL,
		 "Network event generation",
		 "Illegal sections in network\n");

	    break;
	}
	}

	//- get next section

	phsleSection
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsleSection->hsleLink);
    }

    //- construct network event

    ev.iType = iParserEvent | EVENT_TYPE_NETWORK;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)pnetw;

    //- write context element as context of event

    ev.pist = *ppist;

    //- propagate event through algorithms

    bResult = AlgorithmsPropagateParserEvent(&ev);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventPopulationGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	ppopu....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for population symbol
///
/// **************************************************************************

int ParserEventPopulationGenerate
(int iParserEvent,
 struct symtab_Population *ppopu,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    //- construct population event

    ev.iType = iParserEvent | EVENT_TYPE_POPULATION;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)ppopu;

    //- write context element as context of event

    ev.pist = *ppist;

    //- propagate event through algorithms

    bResult = AlgorithmsPropagateParserEvent(&ev);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventProjectionGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event actions to generate
///	pproj....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for projection symbol
///
/// **************************************************************************

int ParserEventProjectionGenerate
(int iParserEvent,
 struct symtab_Projection *pproj,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //v event to fire

    ParserEvent ev;

    //v sections of network

    struct symtab_HSolveListElement * phsleSection = NULL;

    //- init event

    ParserEventInit(&ev);

    //- write context element as context of event

    ev.pist = *ppist;

    // push network name on context element stack

    //PidinStackPushAll(&ev.pist,SymbolGetPidin(&pproj->bio.ioh.iol.hsle));

    //- loop over sections in the projection

    phsleSection
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&pproj->bio.ioh.iohc);

    while (HSolveListValidSucc(&phsleSection->hsleLink))
    {
	//- look at type of section

	switch (phsleSection->iType)
	{
	//- for connection

	case HIERARCHY_TYPE_symbols_connection:
	{
	    //- generate connection event

	    ParserEventConnectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Connection *)phsleSection,
		 &ev.pist);

	    break;
	}

	//- for projection

	case HIERARCHY_TYPE_symbols_projection:
	{
	    //- generate projection event

	    ParserEventProjectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Projection *)phsleSection,
		 &ev.pist);

	    break;
	}

/* 	//- for vector */

/* 	case TYPE_HSLE_VECTOR_BASE: */
/* 	{ */
/* 	    //- generate new event */

/* 	    //! enumeration logic in ParserEventGenerate() */

/* 	    ParserEventGenerate */
/* 		((iParserEvent & EVENT_MASK_ACTIONS) */
/* 		 | EVENT_FLAG_ENUMERATION */
/* 		 | EVENT_TYPE_CONNECTION, */
/* 		 phsleSection, */
/* 		 &ev.pist); */

/* 	    break; */
/* 	} */

	//- else

	default:
	{
	    //- illegal section in projection, give diagnostics

	    //! need parser context here

	    NeurospacesError
		(NULL,
		 "Projection event generation",
		 "Illegal sections in projection\n");

	    break;
	}
	}

	//- get next section

	phsleSection
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsleSection->hsleLink);
    }

    //- construct projection event

    ev.iType = iParserEvent | EVENT_TYPE_PROJECTION;

    ev.uInfo.phsle = (struct symtab_HSolveListElement *)pproj;

    //- write context element as context of event

    ev.pist = *ppist;

    //- propagate event through algorithms

    bResult = AlgorithmsPropagateParserEvent(&ev);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventGenerate()
///
/// ARGS.:
///
///	iParserEvent...: event to generate
///	phsle....: symbol that generates this event
///	ppist....: context element
///
/// RTN..: int : success of operation
///
/// DESCR: Generates event for given symbol
///
/// **************************************************************************

int ParserEventGenerate
(int iParserEvent,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    //t could do a sanity check here on phsle, iParserEvent, type check

    //- if no enumeration event

    //t should be a bit more generic (C++ or Java ?)

    if ((iParserEvent & EVENT_FLAG_ENUMERATION) == 0)
    {
	//- look at event type

	switch (iParserEvent & EVENT_MASK_TYPES)
	{

	//- if pure event

	case 0:
	{
	    //v event to fire

	    ParserEvent ev;

	    //- construct pure event

	    ev.iType = iParserEvent;

	    //! phsle should be NULL here

	    ev.uInfo.phsle = phsle;

	    //- write context element as context of event

	    ev.pist = *ppist;

	    //- propagate event through algorithms

	    bResult = AlgorithmsPropagateParserEvent(&ev);

	    break;
	}

	//- segment segment event

	case EVENT_TYPE_SEGMENT:
	{
	    //fprintf
	    //(stdout,
	    //"segment %s,%i\n",
	    //uSymbol.psegment->pidinName->pcIdentifier,
	    //uSymbol.psegment->pidinName->iIndex);

	    //- generate single segment event

	    ParserEventSegmentGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Segment *)phsle,
		 ppist);

	    break;
	}

	//- for cell event

	case EVENT_TYPE_CELL:
	{	
	    //- generate cell event

	    ParserEventCellGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Cell *)phsle,
		 ppist);

	    break;
	}

	//- for population event

	case EVENT_TYPE_POPULATION:
	{
	    //- generate population event

	    ParserEventPopulationGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Population *)phsle,
		 ppist);

	    break;
	}

	//- for connection event

	case EVENT_TYPE_CONNECTION:
	{
	    //- generate connection event

	    ParserEventConnectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Connection *)phsle,
		 ppist);

	    break;
	}

	//- for projection event

	case EVENT_TYPE_PROJECTION:
	{
	    //- generate projection event

	    ParserEventProjectionGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Projection *)phsle,
		 ppist);

	    break;
	}

	//- for network event

	case EVENT_TYPE_NETWORK:
	{
	    //- generate network event

	    ParserEventNetworkGenerate
		(iParserEvent & EVENT_MASK_ACTIONS,
		 (struct symtab_Network *)phsle,
		 ppist);

	    break;
	}

	//- else

	default:
	{
	    fprintf
		(stderr,
		 "Generation of event type not implemented\n");

	    bResult = FALSE;
	}
	}
    }

    //- if event is of enumeration type

    if ((iParserEvent & EVENT_MASK_FLAGS) & EVENT_FLAG_ENUMERATION)
    {
	//- get type of event

	int iParserEventToGenerate = (iParserEvent & EVENT_MASK_TYPES);

	//- get pointer to container element

	struct symtab_Vector * pvect = (struct symtab_Vector *)phsle;

	//- construct context with container element

	struct PidinStack pist = *ppist;

	//- if container has group name

	if (SymbolGetPidin(&pvect->bio.ioh.iol.hsle))
	{
	    //- push groupname in context

	    //! still need private data here

	    PidinStackPushAll(&pist,SymbolGetPidin(&pvect->bio.ioh.iol.hsle));
	}

	//! enumerate all subsymbols in the main symbol
	//!
	//! should be done with an iterator template

	{
	    //- loop over sections in container element

	    struct symtab_HSolveListElement * phsleSection
		= (struct symtab_HSolveListElement *)
		  HSolveListHead(&pvect->bio.ioh.iohc);
	    
	    while (HSolveListValidSucc(&phsleSection->hsleLink))
	    {
		//- generate event for current subsymbol

		ParserEventGenerate
		    (iParserEventToGenerate | (iParserEvent & EVENT_MASK_ACTIONS),
		     phsleSection,
		     &pist);

		//- go to next section

		phsleSection
		    = (struct symtab_HSolveListElement *)
		      HSolveListNext(&phsleSection->hsleLink);
	    }
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParserEventInit()
///
/// ARGS.:
///
///	pev..: event to init
///
/// RTN..: int : success of operation
///
/// DESCR: Init event
///
/// **************************************************************************

int ParserEventInit(ParserEvent *pev)
{
    //- set default result : ok

    int bResult = TRUE;

    //- zero out mem

    memset(pev,0,sizeof(*pev));

    //- initialize context stack

    PidinStackInit(&pev->pist);

    //- return result

    return(bResult);
}


