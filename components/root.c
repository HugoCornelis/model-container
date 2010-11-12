//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: root.c 1.36 Sat, 15 Sep 2007 10:50:45 -0500 hugo $
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

#include "neurospaces/components/attachment.h"
#include "neurospaces/components/root.h"
#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \arg proot root symbol
/// \arg phsle child to add
/// 
/// \return int : success of operation
/// 
/// \brief Add child to root symbol.
///
/// \details 
/// 
///	Updates serial indices, see also SymbolInit(), SymbolEntailChild().
/// 

int
RootSymbolAddChild
(struct symtab_RootSymbol *proot, struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- link symbol into child list

    HSolveListEntail(&proot->hslSubs, &phsle->hsleLink);

    //- set serials of child

    SymbolAllSerialsEntailChild(&proot->hsle, phsle);

    //- return result

    return(bResult);
}


/// 
/// \return struct symtab_RootSymbol * 
/// 
///	Newly allocated root symbol, NULL for failure
/// 
/// \brief Allocate a new root symbol table element
/// 

struct symtab_RootSymbol * RootSymbolCalloc(void)
{
    //- set default result : failure

    struct symtab_RootSymbol *prootResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/root_symbol_vtable.c"

    //- allocate root

    prootResult
	= (struct symtab_RootSymbol *)
	  SymbolCalloc(1, sizeof(struct symtab_RootSymbol), _vtable_root_symbol, HIERARCHY_TYPE_symbols_root_symbol);

    //- initialize root

    RootSymbolInit(prootResult);

    //- return result

    return(prootResult);
}


#ifdef DELETE_OPERATION

/// 
/// \arg proot root symbol container.
/// \arg phsleChild child to delete.
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
RootSymbolDeleteChild
(struct symtab_RootSymbol *proot,
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

#endif


/// 
/// \arg proot root to free
/// 
/// \return void
/// 
/// \brief Free a root symbol.
/// 

void RootSymbolFree(struct symtab_RootSymbol *proot)
{
    //- free root symbol

    SymbolFree(&proot->hsle);
}


/// 
/// \arg proot root to init
/// 
/// \return struct symtab_IdentifierIndex *
/// 
///	Pidin of root, shared over all roots.
/// 
/// \brief Get pidin of root.
/// 

char *
RootSymbolGetName(struct symtab_RootSymbol *proot)
{
    //- return name

    return(IdinName(SymbolGetPidin(proot)));
}


/// 
/// \arg proot root to init
/// 
/// \return struct symtab_IdentifierIndex *
/// 
///	Pidin of root, shared over all roots.
/// 
/// \brief Get pidin of root.
/// 

struct symtab_IdentifierIndex *
RootSymbolGetPidin(struct symtab_RootSymbol *proot)
{
    //- allocate a rooted pidin

    static struct symtab_IdentifierIndex idinResult =
    {
	/// link structures in list

	NULL,

	/// give each idin pointer to root for hierarchical idins

	&idinResult,

	/// flags, see FLAG_IDENTINDEX_*

	FLAG_IDENTINDEX_ROOTED,

	/// name of identifier

	"/",
    };

    //- return rooted pidin

    return(&idinResult);
}


/// 
/// \arg proot root to init
/// 
/// \return void
/// 
/// \brief init root
/// 

void RootSymbolInit(struct symtab_RootSymbol *proot)
{
    //- initialize base symbol

    SymbolInit(&proot->hsle);

    //- initialize list of subsymbols

    HSolveListInit(&proot->hslSubs);

    //- clear serial mapping info

    SymbolAllSerialsClear(&proot->hsle);

    //- set type

    proot->hsle.iType = HIERARCHY_TYPE_symbols_root_symbol;
}


/// 
/// \arg proot root to search in
/// \arg pcName name of symbol to lookup
/// 
/// \return 
/// 
///	struct symtab_HSolveListElement * : found symbol, NULL for not found
/// 
/// \brief Look for child symbol
/// 

struct symtab_HSolveListElement *
RootSymbolLookup(struct symtab_RootSymbol *proot, char *pcName)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- loop over children

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&proot->hslSubs);

    while (HSolveListValidSucc(&phsle->hsleLink))
    {
	//- if symbol names match

	if (strcmp(pcName, SymbolName(phsle)) == 0)
	{
	    //- set result

	    phsleResult = phsle;

	    //- return result

	    return(phsleResult);
	}

	//- goto next element

	phsle
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsle->hsleLink);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg proot root to search in
/// \arg ppist element to search
/// 
/// \return struct symtab_HSolveListElement * : matching symbol
/// 
/// \brief lookup a hierarchical symbol name in given root.
/// 
/// \note  does not support lookup of current (this should never be needed).
/// 

struct symtab_HSolveListElement *
RootSymbolLookupHierarchical
(struct symtab_RootSymbol *proot,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- lookup first entry

    char *pcName = IdinName(PidinStackElementPidin(ppist, iLevel));

    phsleResult = RootSymbolLookup(proot, pcName);

    //- if found

    if (phsleResult

	//- and need to lookup other entries

	&& bAll)
    {
	//- lookup other entries

	phsleResult
	    = SymbolLookupHierarchical(phsleResult, ppist, iLevel + 1, bAll);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg proot root to search in
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print children of a root
/// 

int
RootSymbolPrint
(struct symtab_RootSymbol *proot, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- loop over children

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&proot->hslSubs);

    while (HSolveListValidSucc(&phsle->hsleLink))
    {
	//- print symbol

	bResult = SymbolsPrintModel(phsle, iIndent, pfile);

	//- goto next element

	phsle
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsle->hsleLink);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg proot symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse symbols in tree manner.
/// 
/// \note  See IOHierarchyTraverse()
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
RootSymbolTraverse
(struct TreespaceTraversal *ptstr, struct symtab_RootSymbol *proot)
{
    //- set default result : ok

    int iResult = 1;

    //- loop over children

    struct symtab_HSolveListElement * phsleChild
	= (struct symtab_HSolveListElement *)
	  HSolveListHead(&proot->hslSubs);

    while (HSolveListValidSucc(&phsleChild->hsleLink))
    {
	int iSelectorValue;
	int iProcessorValue;
	int iPostSelectorValue;

	//- prepare treespace traversal with child

	TstrPrepare(ptstr,phsleChild);

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
		//- call post selector

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

	phsleChild
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsleChild->hsleLink);
    }

    //- return result

    return(iResult);
}


int
RootSymbolTraverseSpikeGenerators
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolSpikeGeneratorSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbol

    iResult = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


int
RootSymbolTraverseSpikeReceivers
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolSpikeReceiverSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbol

    iResult = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


