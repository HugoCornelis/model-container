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

#include "neurospaces/attachment.h"
#include "neurospaces/root.h"
#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: RootSymbolAddChild()
///
/// ARGS.:
///
///	proot.: root symbol
///	phsle.: child to add
///
/// RTN..: int : success of operation
///
/// DESCR: Add child to root symbol.
///
///	Updates serial indices, see also SymbolInit(), SymbolEntailChild().
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_RootSymbol * 
///
///	Newly allocated root symbol, NULL for failure
///
/// DESCR: Allocate a new root symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolFree()
///
/// ARGS.:
///
///	proot.: root to free
///
/// RTN..: void
///
/// DESCR: Free a root symbol.
///
/// **************************************************************************

void RootSymbolFree(struct symtab_RootSymbol *proot)
{
    //- free root symbol

    SymbolFree(&proot->hsle);
}


/// **************************************************************************
///
/// SHORT: RootSymbolGetPidin()
///
/// ARGS.:
///
///	proot.: root to init
///
/// RTN..: struct symtab_IdentifierIndex *
///
///	Pidin of root, shared over all roots.
///
/// DESCR: Get pidin of root.
///
/// **************************************************************************

struct symtab_IdentifierIndex *
RootSymbolGetPidin(struct symtab_RootSymbol *proot)
{
    //- allocate a rooted pidin

    static struct symtab_IdentifierIndex idinResult =
    {
	//m link structures in list

	NULL,

	//m give each idin pointer to root for hierarchical idins

	&idinResult,

	//m flags, see FLAG_IDENTINDEX_*

	FLAG_IDENTINDEX_ROOTED,

	//m name of identifier

	NULL,

	//m index value

	-1,

	//m value of e.g. parameter

	FLT_MAX,
    };

    //- return rooted pidin

    return(&idinResult);
}


/// **************************************************************************
///
/// SHORT: RootSymbolInit()
///
/// ARGS.:
///
///	proot.: root to init
///
/// RTN..: void
///
/// DESCR: init root
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolLookup()
///
/// ARGS.:
///
///	proot..: root to search in
///	pcName.: name of symbol to lookup
///
/// RTN..: 
///
///	struct symtab_HSolveListElement * : found symbol, NULL for not found
///
/// DESCR: Look for child symbol
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolLookupHierarchical()
///
/// ARGS.:
///
///	proot....: root to search in
///	ppist....: element to search
///
/// RTN..: struct symtab_HSolveListElement * : matching symbol
///
/// DESCR: lookup a hierarchical symbol name in given root.
///
/// NOTE.: does not support lookup of current (this should never be needed).
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolPrint()
///
/// ARGS.:
///
///	proot....: root to search in
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Print children of a root
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RootSymbolTraverse()
///
/// ARGS.:
///
///	ptstr.: initialized treespace traversal
///	proot.: symbol to traverse
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse symbols in tree manner.
///
/// NOTE.: See IOHierarchyTraverse()
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
/// **************************************************************************

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
		&& ptstr->pfProcessor)
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


/// **************************************************************************
///
/// SHORT: RootSymbolTraverseSpikeGenerators()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike generators for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: spike generator processor
///	pfFinalizer.: spike receiver finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : see TstrGo()
///
/// DESCR: Traverse spike generators, call pfProcessor on each of them
///
/// **************************************************************************

static int 
SymbolSpikeGeneratorSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if an attachment point

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- select this one to process

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
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


/// **************************************************************************
///
/// SHORT: RootSymbolTraverseSpikeReceivers()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike receivers for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: spike receiver processor
///	pfFinalizer.: spike receiver finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : see TstrGo()
///
/// DESCR: Traverse spike receivers, call pfProcessor on each of them
///
/// **************************************************************************

static int 
SymbolSpikeReceiverSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if an attachment point

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
    {
	//- select this one to process

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

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


