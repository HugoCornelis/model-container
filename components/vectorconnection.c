//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorconnection.c 1.8 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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


#include "neurospaces/components/connection.h"
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/idin.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \arg pvconn connection vector.
/// \arg pconn connection to add.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Add a connection to the connection vector.
/// 

int
VConnectionAddConnection
(struct symtab_VConnection *pvconn, struct symtab_Connection *pconn)
{
    //- set default result : ok

    int iResult = FALSE;

    //- reallocate when necessary

    if (pvconn->devconn.iConnectionsAllocated <= pvconn->devconn.iConnections)
    {
#define ALLOCATION_SIZE 100000

	size_t sSize
	    = ((ALLOCATION_SIZE + pvconn->devconn.iConnectionsAllocated)
	       * sizeof(struct symtab_Connection));

	pvconn->devconn.pconn
	    = (struct symtab_Connection *)realloc(pvconn->devconn.pconn, sSize);

	if (!pvconn->devconn.pconn)
	{
	    /// \todo memory leak, don't care

	    return(FALSE);
	}

	pvconn->devconn.iConnectionsAllocated += 100000;

	pvconn->devconn.iReallocations++;
    }

    //- store the new connection

    pvconn->devconn.pconn[pvconn->devconn.iConnections] = *pconn;

    pvconn->devconn.iConnections++;

    //- return result

    return(iResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: VConnectionCalloc() */
/* /// */
/* /// ARGS.: */
/* /// */
/* /// \return struct symtab_VConnection *  */
/* /// */
/* ///	Newly allocated connection vector, NULL for failure */
/* /// */
/* /// \brief Allocate a new connection vector symbol table element */
/// \details 
/* /// */
/* /// ************************************************************************** */

/* struct symtab_VConnection * VConnectionCalloc(void) */
/* { */
/*     //- set default result : failure */

/*     struct symtab_VConnection *pvconnResult = NULL; */

/*     //- construct function table */

/* #include "hierarchy/output/symbols/v_connection_vtable.c" */

/*     //- allocate connection vector */

/*     pvconnResult */
/* 	= (struct symtab_VConnection *) */
/* 	  SymbolCalloc(1, sizeof(struct symtab_VConnection), _vtable_v_connection, HIERARCHY_TYPE_symbols_v_connection); */

/*     //- initialize connection vector */

/*     VConnectionInit(pvconnResult); */

/*     //- return result */

/*     return(pvconnResult); */
/* } */


/// 
/// \return struct symtab_VConnection * 
/// 
///	Newly allocated connection vector, NULL for failure
/// 
/// \brief Allocate a new connection vector symbol table element
/// 

struct symtab_VConnection * VConnectionCalloc(void)
{
    //- set default result : failure

    struct symtab_VConnection *pvconnResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/v_connection_vtable.c"

    //- allocate connection vector

    pvconnResult
	= (struct symtab_VConnection *)
	  SymbolCalloc(1, sizeof(struct symtab_VConnection), _vtable_v_connection, HIERARCHY_TYPE_symbols_v_connection);

    //- initialize connection vector

    VConnectionInit(pvconnResult);

    //- return result

    return(pvconnResult);
}


/// 
/// \arg pvconn connection vector to init
/// 
/// \return void
/// 
/// \brief init connection vector
/// 

void VConnectionInit(struct symtab_VConnection *pvconn)
{
    //- initialize base symbol

    VectorInit(&pvconn->vect);

    //- set type

    pvconn->vect.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_v_connection;
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pvconn: symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1  immediate abort
/// 
/// \brief Traverse symbols in tree manner.
/// 
/// \note  
/// 
///	Note that not all symbols are required to have a pidin.
///	Interfaces with Tstr{Prepare,Traverse,Repair}() :
/// 
///	Loops over children of top symbol
///		1. Calls TstrPrepare()
///		2. Calls TstrTraverse()
///		3. Calls TstrRepair()
/// 
///	Use Tstr.*() to obtain info on serial IDs and contexts
///	during traversals.
/// 

int
VConnectionTraverse
(struct TreespaceTraversal *ptstr, struct symtab_VConnection *pvconn)
{
    //- set default result : ok

    int iResult = 1;

    //- loop over all connections

    int i;

    for (i = 0 ; i < pvconn->devconn.iConnections ; i++)
    {
	int iSelectorValue;
	int iProcessorValue;
	int iPostSelectorValue;

	//- prepare traversal with serial of connection

	TstrPrepareForSerial(ptstr, i);

	TstrSetActual(ptstr, (struct CoreRoot *)&pvconn->devconn.pconn[i]);

	TstrSetActualType(ptstr, HIERARCHY_TYPE_symbols_connection);

	//- call pre selector

	iSelectorValue
	    = ptstr->pfPreSelector
	      ? ptstr->pfPreSelector(ptstr,ptstr->pvPreSelector)
	      : TSTR_SELECTOR_PROCESS_CHILDREN ;

	//- if selected

	if (iSelectorValue == TSTR_SELECTOR_PROCESS_CHILDREN
	    || iSelectorValue == TSTR_SELECTOR_PROCESS_ONLY_CHILDREN)
	{
	    //- if no process requested, only process children

	    if (iSelectorValue == TSTR_SELECTOR_PROCESS_ONLY_CHILDREN)
	    {
		//- remember to descend into children

		iProcessorValue = TSTR_PROCESSOR_SUCCESS;
	    }

	    //- else

	    else
	    {
		//- call processor

		iProcessorValue
		    = ptstr->pfProcessor
		      ? ptstr->pfProcessor(ptstr,ptstr->pvProcessor)
		      : TSTR_PROCESSOR_SUCCESS ;
	    }

	    //- if request to process children

	    if (iProcessorValue == TSTR_PROCESSOR_SUCCESS
		|| iProcessorValue == TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
	    {
		//- traverse children

/* 		iResult = TstrGo(ptstr,phsleChild); */

		/// \note hardcoded, but cannot be anything else
		/// \note this gets fixed automatically, once the truth table logic is moved to treespacetraversal.c.

		iResult = ConnectionTraverse(ptstr, &pvconn->devconn.pconn[i]);
	    }

	    //- if aborted

	    if (iProcessorValue == TSTR_PROCESSOR_ABORT
		|| iResult == -1)
	    {
		//- set result : aborted

		iResult = -1;
	    }
	}

	//- else

	else
	{
	    //- default : success for processor

	    iProcessorValue = TSTR_PROCESSOR_SUCCESS;
	}

	//- if abort

	if (iResult == -1)
	{
	    //- remember : abort

	    iPostSelectorValue = TSTR_SELECTOR_FAILURE;
	}

	//- if finalize required

	else if (iProcessorValue != TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
	{
	    //- if processor has been called

	    if (iSelectorValue != TSTR_SELECTOR_PROCESS_ONLY_CHILDREN
		&& iSelectorValue != TSTR_SELECTOR_PROCESS_SIBLING
		&& ptstr->pfProcessor)
	    {
		//- call post selector

		iPostSelectorValue
		    = ptstr->pfFinalizer
		      ? ptstr->pfFinalizer(ptstr,ptstr->pvFinalizer)
		      : TSTR_SELECTOR_PROCESS_SIBLING ;

		//- if ok

		if (iPostSelectorValue != TSTR_PROCESSOR_ABORT)
		{
		    //- remember to continue

		    iPostSelectorValue = TSTR_SELECTOR_PROCESS_SIBLING;
		}
	    }

	    //- else

	    else
	    {
		//- remember to continue

		iPostSelectorValue = TSTR_SELECTOR_PROCESS_SIBLING;
	    }
	}

	//- else

	else
	{
	    //- ok : continue

	    iPostSelectorValue = TSTR_SELECTOR_PROCESS_SIBLING;
	}

	//- undo prepare of treespace traversal : repair serial

	TstrRepairForSerial(ptstr, i);

	//- if reasons to stop

	if (iResult != 1
	    || iPostSelectorValue != TSTR_SELECTOR_PROCESS_SIBLING)
	{
	    //- break loop

	    break;
	}
    }

    //- return result

    return(iResult);
}


