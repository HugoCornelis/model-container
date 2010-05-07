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

#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/hhgate.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/treespacetraversal.h"



/// 
/// \arg pvUserdata is int * : count on cells.
/// 
/// \return int : SymbolProcessor return value.
/// 
/// \brief Count cells during traversal.
/// 

int SymbolCellCounter(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to mechanism counter

    int *piCells = (int *)pvUserdata;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

    //- if cell

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cell(iType))
    {
	//- add to counted cells

	(*piCells)++;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg std. SymbolSelector args.
/// 
/// \return int : SymbolSelector return value.
/// 
/// \brief Forbid to process anything below the cell level.
/// 

int SymbolCellSelector(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

    //- if below cell level

    int iType = TstrGetActualType(ptstr);

    if (subsetof_segment(iType))
    {
	//- do not process, continue with siblings

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg ptstr treespace traversal.
/// \arg pvUserdata is int * : connection count.
/// 
/// \return int : treespace traversal callback return value.
/// 
/// \brief Increments (*(int *)pvUserdata) for traversed connection symbols.
/// 
/// \details 
/// 
///	This function must not be called on vectors of connections.
/// 

int SymbolConnectionCounter(struct TreespaceTraversal *ptstr, void *pvUserdata)
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

	/// \note in fact we have an internal error here.
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
	/// \todo give some diag's : must not be part of network
    }

    //- return result : remember won't go any deeper to traverse connections

    return(iResult);
}


/// 
/// \arg std. SymbolSelector args.
/// 
/// \return int : SymbolSelector return value.
/// 
/// \brief Select connections in a treespace traversal.
/// 

int SymbolConnectionSelector(struct TreespaceTraversal *ptstr, void *pvUserdata)
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


/// 
/// \arg std. SymbolSelector args.
/// 
/// \return int : SymbolSelector return value.
/// 
/// \brief Select only gate kinetics (includes concentration gate kinetics).
/// 

int SymbolGateKineticSelector(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

    //- if a gate kinetic

    int iType = TstrGetActualType(ptstr);

    if (subsetof_gate_kinetic(iType)
	|| subsetof_concentration_gate_kinetic(iType))
      {
	//- process including children

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
      }

    //- return result

    return(iResult);
}


/// 
/// \arg std. SymbolSelector args.
/// 
/// \return int : SymbolSelector return value.
/// 
/// \brief Forbid to process anything below the projection level.
/// 

int SymbolProjectionSelector(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if non-projection

    int iType = TstrGetActualType(ptstr);

    if (!subsetof_projection(iType))
    {
	//- do not process but continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pvUserdata is int * : number of table entries for each gate kinetic.
/// 
/// \return int : SymbolProcessor return value.
/// 
/// \details 
/// 
///	Determine the unique number of table entries for all gate
///	kinetics.
/// 

int
SymbolTableValueCollector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to collector data

    struct table_parameter_collector_data *ptpcd
	= (struct table_parameter_collector_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if this gate kinetic has a hardcoded table

    double dValue = SymbolParameterResolveValue(phsle, ptstr->ppist, ptpcd->pcParameter);

    if (dValue != DBL_MAX)
    {
	//- if value not initialized

	if (ptpcd->iValue == 0)
	{
	    //- initialize value

	    ptpcd->iValue = (int)dValue;
	}

	//- if value found different from previous gate

	else if (ptpcd->iValue != (int)dValue)
	{
	    //- flag as error

	    ptpcd->iValue = -1;

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }

    //- else this gate kinetic has no table, so the gate has none either

    else
    {
	//- flag as error

	ptpcd->iValue = -1;

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}


/// 
/// \return struct TreespaceTraversal * : newly allocated treespace traversal.
/// 
/// \brief Allocate treespace traversal.
/// 

struct TreespaceTraversal * TstrCalloc(void)
{
    //- allocate and return

    return((struct TreespaceTraversal *)calloc(1,sizeof(struct TreespaceTraversal)));
}


/// 
/// \arg ptstr allocated treespace traversal.
/// 
/// \return void
/// 
/// \brief Delete & free treespace traversal.
/// 

void TstrDelete(struct TreespaceTraversal *ptstr)
{
    //- delete context

    PidinStackFree(ptstr->ppist);

    PSymbolStackFree(ptstr->psymst);

    //- free treespace traversal

    free(ptstr);
}


/// 
/// \arg ptstr initialized treespace traversal
/// 
/// \return struct CoreRoot *
/// 
///	actual symbol.
/// 
/// \brief Get actual symbol during traversal.
/// 

struct CoreRoot * TstrGetActual(struct TreespaceTraversal *ptstr)
{
    //- return cached info

    return(ptstr->pcrActual);
}


/// 
/// \arg ptstr initialized treespace traversal
/// 
/// \return int
/// 
///	actual type.
/// 
/// \brief Get actual type during traversal.
/// 

int TstrGetActualType(struct TreespaceTraversal *ptstr)
{
    //- return cached info

    return(ptstr->iType);
}


/// 
/// \arg ptstr initialized treespace traversal
/// 
/// \return struct symtab_HSolveListElement * : actual parent symbol
/// 
/// \brief Get actual parent symbol, parent of actual.
/// 

struct symtab_HSolveListElement * 
TstrGetActualParent(struct TreespaceTraversal *ptstr)
{
    //- return symbol from cache

    /// \note (#entries - 1) is top, (#entries - 2) is parent

    return(PSymbolStackElementSymbol
	   (ptstr->psymst, PSymbolStackNumberOfEntries(ptstr->psymst) - 2));
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: TstrGetOriginalContext() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	ptstr..: initialized treespace traversal */
/* /// */
/* /// \return struct PidinStack * : original context of treespace traversal */
/* /// */
/* /// \brief Get original context of treespace traversal */
/* /// */
/* /// ************************************************************************** */

/* struct PidinStack * TstrGetOriginalContext(struct TreespaceTraversal *ptstr) */
/* { */
/*     //- set default result : from actual result */

/*     struct PidinStack *ppistResult = PidinStackDuplicate(ptstr->ppist); */

/*     /// \todo if this doesn't get optimized in decent way, perhaps it is better */
/*     /// \todo to directly set the stack top. Needs additional PidinStack operation */

/*     //- while number of entries in context different from origin */

/*     while (PidinStackNumberOfEntries(ppistResult) != ptstr->iFirstEntry) */
/*     { */
/* 	//- pop entry */

/* 	PidinStackPop(ppistResult); */
/*     } */

/*     //- return result */

/*     return(ppistResult); */
/* } */


/// 
/// \arg ptstr initialized treespace traversal
/// \arg phsle symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse symbols, process with registered processors
/// 
/// \details 
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


/// 
/// \arg ppist context to traverse
/// \arg pfPreSelector 
/// \arg pvPreSelector 
/// \arg pfProcesor all the same
/// \arg pvProcessor 
/// \arg pfFinalizer 
/// \arg pvFinalizer
/// 
/// \return struct TreespaceTraversal * : new treespace traversal
/// 
/// \brief Allocate treespace traversal
/// 

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


/// 
/// \arg ptstr treespace traversal in traverse
/// \arg phsle symbol to traverse
/// 
/// \return int : success of operation
/// 
/// \brief Prepare for traversing the given symbol.
/// 

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


/// 
/// \arg ptstr treespace traversal in traverse
/// \arg iSerialPrincipal serial of symbol to traverse
/// \arg iSerialMechanism serial of symbol to traverse
/// \arg iSerialSegment serial of symbol to traverse
/// 
/// \return int : success of operation
/// 
/// \brief Prepare for traversing the given serial.
/// 

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


/// 
/// \arg ptstr treespace traversal in traverse
/// 
/// \return int : success of operation
/// 
/// \brief Repair a treespace traversal after visiting it with TstrPrepare()
/// 

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


/// 
/// \arg ptstr treespace traversal in traverse
/// \arg iSerialPrincipal serial of symbol to traverse
/// \arg iSerialMechanism serial of symbol to traverse
/// \arg iSerialSegment serial of symbol to traverse
/// 
/// \return int : success of operation
/// 
/// \brief Repair a treespace traversal after visiting the given serial.
/// 

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


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pcr actual symbol.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Set actual symbol.
/// 
/// \details 
/// 
///	This function and TstrSetActualType() delegate typing and data
///	visibility to an external party, instead of to the symbol
///	itself.  This separation of concern increases flexibility.
///	Look at the implementation of efficient connections for an
///	example.
/// 

int TstrSetActual(struct TreespaceTraversal *ptstr, struct CoreRoot *pcr)
{
    ptstr->pcrActual = pcr;

    //- return success

    return(1);
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg iType actual symbol type.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Set actual symbol type.
/// 
/// \details 
/// 
///	This function and TstrSetActualType() delegate typing and data
///	visibility to an external party, instead of to the symbol
///	itself.  This separation of concern increases flexibility.
///	Look at the implementation of efficient connections for an
///	example.
/// 

int TstrSetActualType(struct TreespaceTraversal *ptstr, int iType)
{
    ptstr->iType = iType;

    //- return success

    return(1);
}


