//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iohier.c 1.63 Fri, 16 Nov 2007 18:22:20 -0600 hugo $
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

#include "neurospaces/components/iohier.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \arg pioh symbol container
/// \arg phsleChild child to enqueue
/// 
/// \return int : success of operation
/// 
/// \brief Add a child to the children of given symbol container.
///
/// \details 
/// 
///	Updates (sub)?space indices if symbol type has mappings.
/// 

int
IOHierarchyAddChild
(struct symtab_IOHierarchy *pioh,
 struct symtab_HSolveListElement *phsleChild)
{
    //- set default result : failure

    int iResult = FALSE;

    //- add to end of list

    HSolveListEntail(&pioh->iohc, &phsleChild->hsleLink);

    //- set serials of child

    SymbolAllSerialsEntailChild(&pioh->iol.hsle, phsleChild);

    //- set result: ok

    iResult = TRUE;

    //- return result

    return(iResult);
}


/// 
/// \arg pioh symbol container
/// \arg phsleChild child to delete
/// 
/// \return int : success of operation
/// 
/// \brief Delete a child from the children of given symbol container.
///
/// \details 
/// 
///	Does not update (sub)?space indices.
/// 

int
IOHierarchyDeleteChild
(struct symtab_IOHierarchy *pioh,
 struct symtab_HSolveListElement *phsleChild)
{
    //- set default result: ok

    int iResult = TRUE;

    //- delete child

    HSolveListRemove(&phsleChild->hsleLink);

/*     //- set serials of child */

/*     SymbolAllSerialsEntailChild(&pioh->iol.hsle, phsleChild); */

    //- return result

    return(iResult);
}


/// 
/// \arg pioh symbol to get children from.
/// 
/// \return IOHContainer * : symbol container.
/// 
/// \brief Get children from given symbol.
/// 

IOHContainer *
IOHierarchyGetChildren
(struct symtab_IOHierarchy *pioh)
{
    //- set default result : not found

    IOHContainer *piohcResult = NULL;

    //- set result from element

    piohcResult = &pioh->iohc;

    //- return result

    return(piohcResult);
}


/// 
///	pioh.: hierarchical I/O element to init
/// 
/// \return void
/// 
/// \brief Init hierarchical I/O element
/// 

void IOHierarchyInit(struct symtab_IOHierarchy * pioh)
{
    //- init bio sub symbol

    IOListInit(&pioh->iol);

    //- init own fields

    HSolveListInit(&pioh->iohc);
}


/// 
/// \arg pioh container
/// \arg ppist name(s) to search
/// \arg iLevel: active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in subsymbols
///
/// \details 
/// 
///	First tries to match with container itself, if fails, returns failure
///	If match and subsymbols requested (bAll), tries to match next names
///	with subsymbols of container.
/// 

struct symtab_HSolveListElement *
IOHierarchyLookupHierarchical
(struct symtab_IOHierarchy * pioh,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    struct symtab_IOHierarchy * piohSub = NULL;

    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get active pidin

    struct symtab_IdentifierIndex *pidin
	= PidinStackElementPidin(ppist, iLevel);

    //- if points to current

    if (IdinPointsToCurrent(pidin))
    {
	//- return current

	phsleResult = (struct symtab_HSolveListElement *)pioh;

	//- if stop at current symbol

	if (!bAll)
	{
	    return(phsleResult);
	}
	else
	{
	  phsleResult
	      = SymbolLookupHierarchical
	        (&pioh->iol.hsle, ppist, iLevel + 1, TRUE);
	  
	}
    }

    //- loop over sub symbols

    piohSub = (struct symtab_IOHierarchy *)HSolveListHead(&pioh->iohc);

    while (HSolveListValidSucc(&piohSub->iol.hsle.hsleLink))
    {
	//- if name matches

	if (strcmp
	    (SymbolName(&piohSub->iol.hsle),
	     IdinName(PidinStackElementPidin(ppist, iLevel))) == 0)
	{
	    //- if stop at current symbol

	    if (!bAll)
	    {
		//- set result and break searching loop

		phsleResult = &piohSub->iol.hsle;

		return(phsleResult);
	    }

	    //- lookup next symbol in queue

	    phsleResult
		= SymbolLookupHierarchical
		  (&piohSub->iol.hsle, ppist, iLevel + 1, TRUE);

	    //- if found

	    if (phsleResult)
	    {
		/// \todo we could register phsleResult in cache of ppist.
		/// \todo probably means we need something like
		/// \todo PidinStackLookupHierarchical
		/// \todo     (ppist,iLevel + 1,&piohSub->iol.hsle,TRUE);
		///
		/// \todo this makes pidin stack behave more like pidin queues
		/// \todo look for interference with java interfaces.

		//- return result

		return(phsleResult);
	    }
	}

	//- go to next section

	piohSub
	    = (struct symtab_IOHierarchy *)
	      HSolveListNext(&piohSub->iol.hsle.hsleLink);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pioh symbol to print symbols for
/// \arg bAll TRUE == full list of symbols, FALSE == only given one.
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info.
/// 

int IOHierarchyPrint
(struct symtab_IOHierarchy *pioh, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    /// section element

    struct symtab_HSolveListElement *phsle = NULL;

    //- do indent

    PrintSymbolIndent(&pioh->iol.hsle, iIndent, pfile);

    //- name

    fprintf
	(pfile,
	 "Name, index (%s,%i)\n",
	 SymbolName(&pioh->iol.hsle)
	 ? SymbolName(&pioh->iol.hsle)
	 : "Undefined",
	 -1);

    //- do indent

    PrintSymbolIndent(&pioh->iol.hsle, iIndent, pfile);

    //- begin section header

    fprintf(pfile, "{-- begin HIER sections ---\n");

    //- loop over sections

    phsle
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&pioh->iohc);

    while (HSolveListValidSucc(&phsle->hsleLink))
    {
	//- print symbol

	if (!SymbolPrint(phsle, iIndent + 4, pfile))
	{
	    bResult = FALSE;
	    break;
	}

	//- go to next section

	phsle
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsle->hsleLink);
    }

    //- do indent

    PrintSymbolIndent(&pioh->iol.hsle, iIndent, pfile);

    //- begin section header

    fprintf(pfile, "}--  end  HIER sections ---\n");

    //- return result

    return(bResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: IOHierarchyRecalcChildrenSerialToParent() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pioh.: symbol to recalculate serials for */
/* /// */
/* /// \return int : success of operation */
/* /// */
/* /// \brief Recalculate children serials relative to symbol (== parent). */
/* /// */
/* ///	Uses #SU in children to set serial to parent, #SU must be correct */
/* ///	for this function to work. */
/* /// */
/* /// ************************************************************************** */

/* int IOHierarchyRecalcChildrenSerialToParent(struct symtab_IOHierarchy *pioh) */
/* { */
/*     //- set default result : ok */

/*     int bResult = TRUE; */

/*     //- start with no cumulative successors for previous children */

/*     int iSuccessorsPrincipal = 0; */
/*     int iSuccessorsMechanism = 0; */
/*     int iSuccessorsSegment = 0; */

/*     //- loop over children */

/*     struct symtab_IOHierarchy * piohChild */
/* 	= (struct symtab_IOHierarchy *) */
/* 	  HSolveListHead(&pioh->iohc); */

/*     while (HSolveListValidSucc(&piohChild->iol.hsle.hsleLink)) */
/*     { */
/* 	//- recalculate serials */

/* 	SymbolAllSerialsRecalculate */
/* 	    (&piohChild->iol.hsle, */
/* 	     &iSuccessorsPrincipal, */
/* 	     &iSuccessorsMechanism, */
/* 	     &iSuccessorsSegment); */

/* 	//- go to next child */

/* 	piohChild */
/* 	    = (struct symtab_IOHierarchy *) */
/* 	      HSolveListNext(&piohChild->iol.hsle.hsleLink); */
/*     } */

/*     //- set number of successors for parent symbol */

/*     SymbolAllSuccessorsSet */
/* 	(&pioh->iol.hsle, */
/* 	 iSuccessorsPrincipal, */
/* 	 iSuccessorsMechanism, */
/* 	 iSuccessorsSegment); */

/*     //- return result */

/*     return(bResult); */
/* } */


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pioh symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse IO symbols in tree manner.
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

int IOHierarchyTraverse
(struct TreespaceTraversal *ptstr, struct symtab_IOHierarchy *pioh)
{
    //- set default result : ok

    int iResult = 1;

    //- loop over children

    struct symtab_HSolveListElement * phsleChild
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&pioh->iohc);

    while (HSolveListValidSucc(&phsleChild->hsleLink))
    {
	int iSelectorValue;
	int iProcessorValue;
	int iPostSelectorValue;

	//- prepare traversal with child

	TstrPrepare(ptstr, phsleChild);

	//- call pre selector

	iSelectorValue
	    = ptstr->pfPreSelector
	      ? ptstr->pfPreSelector(ptstr, ptstr->pvPreSelector)
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
		      ? ptstr->pfProcessor(ptstr, ptstr->pvProcessor)
		      : TSTR_PROCESSOR_SUCCESS ;
	    }

	    //- if request to process children

	    if (iProcessorValue == TSTR_PROCESSOR_SUCCESS
		|| iProcessorValue == TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
	    {
		//- traverse children

		iResult = TstrGo(ptstr, phsleChild);
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

	/// \todo register next child, such that the current one can be removed
	/// \todo continue operating on the current child, the finalizer is allowed to remove it.
	/// \todo call the finalizer as usual
	/// \todo copy registered child to current child, continue loop

	//- register next child

	struct symtab_HSolveListElement *phsleNextChild
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsleChild->hsleLink);

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
		&& (ptstr->pfProcessor
		    || iProcessorValue == TSTR_PROCESSOR_SUCCESS))
	    {
		//- call post processor

		iPostSelectorValue
		    = ptstr->pfFinalizer
		      ? ptstr->pfFinalizer(ptstr, ptstr->pvFinalizer)
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

	//- undo prepare of treespace traversal : repair

	TstrRepair(ptstr);

	//- if reasons to stop

	if (iResult != 1
	    || iPostSelectorValue != TSTR_SELECTOR_PROCESS_SIBLING)
	{
	    //- break loop

	    break;
	}

	//- go to next child

	phsleChild = phsleNextChild;
    }

    //- return result

    return(iResult);
}


