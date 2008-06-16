//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: treespacetraversal.c 1.43 Fri, 31 Aug 2007 15:24:45 -0500 hugo $
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



#include <stdlib.h>

#include "neurospaces/biocomp.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/symbolvirtual_protos.h"



/// **************************************************************************
///
/// SHORT: SymbolCellCounter()
///
/// ARGS.:
///
///	pvUserdata.: int * : count on cells.
///
/// RTN..: int : SymbolProcessor return value.
///
/// DESCR: Count cells during traversal.
///
/// **************************************************************************

int SymbolCellCounter(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to mechanism counter

    int *piCells = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if cell

    if (instanceof_cell(phsle))
    {
	//- add to counted cells

	(*piCells)++;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolCellSelector()
///
/// ARGS.:
///
///	std. SymbolSelector args.
///
/// RTN..: int : SymbolSelector return value.
///
/// DESCR: Forbid to process anything below the cell level.
///
/// **************************************************************************

int SymbolCellSelector(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if below cell level

    if (instanceof_segment(phsle))
    {
	//- do not process, continue with siblings

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolConnectionCounter()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal.
///	pvUserdata..: int * : connection count.
///
/// RTN..: int : treespace traversal callback return value.
///
/// DESCR: Increments (*(int *)pvUserdata) for traversed connection symbols.
///
///	This function must not be called on vectors of connections.
///
/// **************************************************************************

int SymbolConnectionCounter(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get actual symbol type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- if connection vector

    if (subsetof_v_connection_symbol(iType))
    {
	//- do nothing

	//! in fact we have an internal error here.
    }

    //- if connection

    else if (subsetof_connection_symbol(iType)
	     || subsetof_connection(iType))
    {
	//- set result : ok, but process sibling afterwards

	iResult = TSTR_PROCESSOR_FAILURE;

	//- count as connection

	(*(int *)pvUserdata)++;
    }

    else
    {
	//t give some diag's : must not be part of network
    }

    //- return result : remember won't go any deeper to traverse connections

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolConnectionSelector()
///
/// ARGS.:
///
///	std. SymbolSelector args.
///
/// RTN..: int : SymbolSelector return value.
///
/// DESCR: Select connections in a treespace traversal.
///
/// **************************************************************************

int SymbolConnectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get current type

    int iType = TstrGetActualType(ptstr);

    //- if this is a projection

    if (subsetof_projection(iType))
    {
	//- skip, subprojections must not be processed

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- if non-connection

    else if (!subsetof_connection(iType)
	     && !subsetof_connection_symbol(iType))
    {
	//- do not process but continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolProjectionSelector()
///
/// ARGS.:
///
///	std. SymbolSelector args.
///
/// RTN..: int : SymbolSelector return value.
///
/// DESCR: Forbid to process anything below the projection level.
///
/// **************************************************************************

int SymbolProjectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if non-projection

    if (!instanceof_projection(phsle))
    {
	//- do not process but continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrCalloc()
///
/// ARGS.:
///
/// RTN..: struct TreespaceTraversal * : newly allocated treespace traversal.
///
/// DESCR: Allocate treespace traversal.
///
/// **************************************************************************

struct TreespaceTraversal * TstrCalloc(void)
{
    //- allocate and return

    return((struct TreespaceTraversal *)calloc(1,sizeof(struct TreespaceTraversal)));
}


/// **************************************************************************
///
/// SHORT: TstrDelete()
///
/// ARGS.:
///
///	ptstr..: allocated treespace traversal.
///
/// RTN..: void
///
/// DESCR: Delete & free treespace traversal.
///
/// **************************************************************************

void TstrDelete(struct TreespaceTraversal *ptstr)
{
    //- delete context

    PidinStackFree(ptstr->ppist);

    PSymbolStackFree(ptstr->psymst);

    //- free treespace traversal

    free(ptstr);
}


/// **************************************************************************
///
/// SHORT: TstrGetActual()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///
/// RTN..: struct CoreRoot *
///
///	actual symbol.
///
/// DESCR: Get actual symbol during traversal.
///
/// **************************************************************************

struct CoreRoot * TstrGetActual(struct TreespaceTraversal *ptstr)
{
    //- return cached info

    return(ptstr->pcrActual);
}


/// **************************************************************************
///
/// SHORT: TstrGetActualType()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///
/// RTN..: int
///
///	actual type.
///
/// DESCR: Get actual type during traversal.
///
/// **************************************************************************

int TstrGetActualType(struct TreespaceTraversal *ptstr)
{
    //- return cached info

    return(ptstr->iType);
}


/// **************************************************************************
///
/// SHORT: TstrGetActualParent()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///
/// RTN..: struct symtab_HSolveListElement * : actual parent symbol
///
/// DESCR: Get actual parent symbol, parent of actual.
///
/// **************************************************************************

struct symtab_HSolveListElement * 
TstrGetActualParent(struct TreespaceTraversal *ptstr)
{
    //- return symbol from cache

    //! (#entries - 1) is top, (#entries - 2) is parent

    return(PSymbolStackElementSymbol
	   (ptstr->psymst,PSymbolStackNumberOfEntries(ptstr->psymst) - 2));
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: TstrGetOriginalContext() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	ptstr..: initialized treespace traversal */
/* /// */
/* /// RTN..: struct PidinStack * : original context of treespace traversal */
/* /// */
/* /// DESCR: Get original context of treespace traversal */
/* /// */
/* /// ************************************************************************** */

/* struct PidinStack * TstrGetOriginalContext(struct TreespaceTraversal *ptstr) */
/* { */
/*     //- set default result : from actual result */

/*     struct PidinStack *ppistResult = PidinStackDuplicate(ptstr->ppist); */

/*     //t if this doesn't get optimized in decent way, perhaps it is better */
/*     //t to directly set the stack top. Needs additional PidinStack operation */

/*     //- while number of entries in context different from origin */

/*     while (PidinStackNumberOfEntries(ppistResult) != ptstr->iFirstEntry) */
/*     { */
/* 	//- pop entry */

/* 	PidinStackPop(ppistResult); */
/*     } */

/*     //- return result */

/*     return(ppistResult); */
/* } */


/// **************************************************************************
///
/// SHORT: TstrGo()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///	phsle..: symbol to traverse
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse symbols, process with registered processors
///
/// EXAMPLE:
///
///    //- init treespace traversal
///
///    memset(&tstr,0,sizeof(tstr));
///
///    tstr.pfPreSelector = SegmentMechanismSelector;
///    tstr.pfProcesor = pfProcesor;
///    tstr.pvUserdata = pvUserdata;
///
///    //- allocate symbol stack
///
///    tstr.ppist = PidinStackDuplicate(ppist);
///
///    //- traverse segment symbol
///
///    iResult = TstrGo(&tstr,&psegment->bio.ioh.iol.hsle);
///
///    //- free symbol stack
///
///    PidinStackFree(tstr.ppist);
///
/// **************************************************************************

int
TstrGo
(struct TreespaceTraversal *ptstr,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int iResult = TRUE;

    //- if first call

    if (ptstr->iStatus == TSTR_STATUS_NEW
	|| ptstr->iStatus == TSTR_STATUS_DONE)
    {
	//- prepare symbol for traversal

	TstrPrepare(ptstr,phsle);

	//- register initial status

	ptstr->iStatus = TSTR_STATUS_INITIALIZED;
    }

    //- traverse and visit

    iResult = SymbolTraverse(ptstr, phsle);

    //- if context stack has only root symbol

    if (PidinStackNumberOfEntries(ptstr->ppist)
	== ptstr->iFirstEntry)
    {
	//- register status : done with traverse

	ptstr->iStatus = TSTR_STATUS_DONE;

        //- repaire symbol after traversal

	TstrRepair(ptstr);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrNew()
///
/// ARGS.:
///
///	ppist.........: context to traverse
///	pfPreSelector.: 
///	pvPreSelector.: 
///	pfProcesor....: all the same
///	pvProcessor...: 
///	pfFinalizer...: 
///	pvFinalizer...: 
///
/// RTN..: struct TreespaceTraversal * : new treespace traversal
///
/// DESCR: Allocate treespace traversal
///
/// **************************************************************************

struct TreespaceTraversal *
TstrNew
(struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfPreSelector,
 void *pvPreSelector,
 TreespaceTraversalProcessor *pfProcesor,
 void *pvProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvFinalizer)
{
    //- set default result : new treespace traversal

    struct TreespaceTraversal *ptstrResult = TstrCalloc();

    //- set requested members

    ptstrResult->pfPreSelector = pfPreSelector;
    ptstrResult->pvPreSelector = pvPreSelector;
    ptstrResult->pfProcessor = pfProcesor;
    ptstrResult->pvProcessor = pvProcessor;
    ptstrResult->pfFinalizer = pfFinalizer;
    ptstrResult->pvFinalizer = pvFinalizer;

    //- allocate symbol stack

    ptstrResult->ppist = PidinStackDuplicate(ppist);

    if (!ptstrResult->ppist)
    {
	TstrDelete(ptstrResult);

	return(NULL);
    }

    //- register initial status

    ptstrResult->iStatus = TSTR_STATUS_NEW;

    ptstrResult->iFirstEntry
	= PidinStackNumberOfEntries(ptstrResult->ppist);

    ptstrResult->psymst = PSymbolStackCalloc();

    if (!ptstrResult->psymst)
    {
	TstrDelete(ptstrResult);

	return(NULL);
    }

    //- reset all serial ID's

    ptstrResult->iSerialPrincipal = 0;
    ptstrResult->iSerialSegment = 0;
    ptstrResult->iSerialMechanism = 0;

    //- return result

    return(ptstrResult);
}


/// **************************************************************************
///
/// SHORT: TstrPrepare()
///
/// ARGS.:
///
///	ptstr..: treespace traversal in traverse
///	phsle..: symbol to traverse
///
/// RTN..: int : success of operation
///
/// DESCR: Prepare for traversing the given symbol.
///
/// **************************************************************************

int 
TstrPrepare
(struct TreespaceTraversal *ptstr, struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int iResult = TRUE;

    //- prepare serials

    TstrPrepareForSerial
	(
	    ptstr,
	    SymbolGetPrincipalSerialToParent(phsle)
#ifdef TREESPACES_SUBSET_MECHANISM
	    , SymbolGetSegmentSerialToParent(phsle)
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	    , SymbolGetMechanismSerialToParent(phsle)
#endif
	    );

    //- if in use

    if (ptstr->iStatus == TSTR_STATUS_INITIALIZED)
    {
	//- push symbol pidin on context

	PidinStackPushSymbol(ptstr->ppist,phsle);
    }

    //- push symbol on cache

    PSymbolStackPush(ptstr->psymst,phsle);

    //- set actual

    TstrSetActual(ptstr, (struct CoreRoot *)phsle);

    //- set actual type

    TstrSetActualType(ptstr, phsle->iType);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrPrepareForSerial()
///
/// ARGS.:
///
///	ptstr............: treespace traversal in traverse
///	iSerialPrincipal.: serial of symbol to traverse
///	iSerialMechanism.: serial of symbol to traverse
///	iSerialSegment...: serial of symbol to traverse
///
/// RTN..: int : success of operation
///
/// DESCR: Prepare for traversing the given serial.
///
/// **************************************************************************

int 
TstrPrepareForSerial
(struct TreespaceTraversal *ptstr,
 int iSerialPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSerialMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSerialSegment
#endif
    )
{
    //- set default result : ok

    int iResult = TRUE;

    //- if in use

    if (ptstr->iStatus == TSTR_STATUS_INITIALIZED)
    {
	//- there is currently no actual

	TstrSetActual(ptstr, NULL);

	//- set serial ID's

	ptstr->iSerialPrincipal += iSerialPrincipal;

#ifdef TREESPACES_SUBSET_MECHANISM
	ptstr->iSerialSegment += iSerialMechanism;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
	ptstr->iSerialMechanism += iSerialSegment;
#endif
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrRepair()
///
/// ARGS.:
///
///	ptstr..: treespace traversal in traverse
///
/// RTN..: int : success of operation
///
/// DESCR: Repair a treespace traversal after visiting it with TstrPrepare()
///
/// **************************************************************************

int TstrRepair(struct TreespaceTraversal *ptstr)
{
    //- set default result : ok

    int iResult = TRUE;

    //- undo prepare of treespace traversal : repair

    //- repair serials

    //- pop cached symbol

    struct symtab_HSolveListElement *phsleChild
	= PSymbolStackTop(ptstr->psymst);

    TstrRepairForSerial
	(
	    ptstr,
	    SymbolGetPrincipalSerialToParent(phsleChild)
#ifdef TREESPACES_SUBSET_MECHANISM
	    , SymbolGetSegmentSerialToParent(phsleChild)
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	    , SymbolGetMechanismSerialToParent(phsleChild)
#endif
	    );

    //- pop cached symbol

    /* struct symtab_HSolveListElement * */phsleChild
	= PSymbolStackPop(ptstr->psymst);

    //- if in use

    if (ptstr->iStatus == TSTR_STATUS_INITIALIZED)
    {
	//- pop from context

	PidinStackPop(ptstr->ppist);
    }

    //- set previous actual

    /* struct symtab_HSolveListElement * */phsleChild
	= PSymbolStackTop(ptstr->psymst);

    TstrSetActual(ptstr, (struct CoreRoot *)phsleChild);

    if (phsleChild)
    {
	TstrSetActualType(ptstr, phsleChild->iType);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrRepairForSerial()
///
/// ARGS.:
///
///	ptstr............: treespace traversal in traverse
///	iSerialPrincipal.: serial of symbol to traverse
///	iSerialMechanism.: serial of symbol to traverse
///	iSerialSegment...: serial of symbol to traverse
///
///
/// RTN..: int : success of operation
///
/// DESCR: Repair a treespace traversal after visiting the given serial.
///
/// **************************************************************************

int
TstrRepairForSerial
(struct TreespaceTraversal *ptstr,
 int iSerialPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSerialMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSerialSegment
#endif
    )
{
    //- set default result : ok

    int iResult = TRUE;

    //- if in use

    if (ptstr->iStatus == TSTR_STATUS_INITIALIZED)
    {
	//- there is currently no actual

	TstrSetActual(ptstr, NULL);

	//- reset serial ID's

	ptstr->iSerialPrincipal -= iSerialPrincipal;

#ifdef TREESPACES_SUBSET_MECHANISM
	ptstr->iSerialSegment -= iSerialSegment;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
	ptstr->iSerialMechanism -= iSerialMechanism;
#endif
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TstrSetActual()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///	pcr....: actual symbol.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set actual symbol.
///
///	This function and TstrSetActualType() delegate typing and data
///	visibility to an external party, instead of to the symbol
///	itself.  This separation of concern increases flexibility.
///	Look at the implementation of efficient connections for an
///	example.
///
/// **************************************************************************

int TstrSetActual(struct TreespaceTraversal *ptstr, struct CoreRoot *pcr)
{
    ptstr->pcrActual = pcr;

    //- return success

    return(1);
}


/// **************************************************************************
///
/// SHORT: TstrSetActualType()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///	iType..: actual symbol type.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set actual symbol type.
///
///	This function and TstrSetActualType() delegate typing and data
///	visibility to an external party, instead of to the symbol
///	itself.  This separation of concern increases flexibility.
///	Look at the implementation of efficient connections for an
///	example.
///
/// **************************************************************************

int TstrSetActualType(struct TreespaceTraversal *ptstr, int iType)
{
    ptstr->iType = iType;

    //- return success

    return(1);
}


