//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: psymbolstack.c 1.14 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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


//////////////////////////////////////////////////////////////////////////////
//o
//o Symbol stack intro :
//o --------------------
//o
//o Symbol stacks are almost exactly what the word says : a stack of 
//o (references to) symbols.  The interface mainly is concerned about
//o stack operations, although sometimes more is needed (like getting 
//o the number of elements in the stack).  It's primarily purpose is
//o caching for other routines (e.g. pidin stacks and symbol 
//o traversals).
//o 
//o The consequence if this narrow approach is that it is not meaningfull
//o to associate a serial index with the symbol at the top (as is the
//o case with pidinstacks) : there is no guarantee that the stack gives
//o the context of an occurence of a symbol.  It is of course legal to
//o use the stack in that way (it is designed to be used that way), but
//o association of serial mappings with symbols is not the purpose of
//o this structure.
//o
//////////////////////////////////////////////////////////////////////////////


#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/psymbolstack.h"
#include "neurospaces/symbols.h"


/// **************************************************************************
///
/// SHORT: PSymbolStackCalloc()
///
/// ARGS.:
///
/// RTN..: struct PSymbolStack * 
///
///	Newly allocated symbol stack, NULL for failure
///
/// DESCR: Allocate a new symbol stack symbol table element
///
/// **************************************************************************

struct PSymbolStack * PSymbolStackCalloc(void)
{
    //- set default result : failure

    struct PSymbolStack *psymstResult = NULL;

    //- allocate symbol stack

    psymstResult
	= (struct PSymbolStack *)
	  calloc(1,sizeof(struct PSymbolStack));

    //- initialize symbol stack

    PSymbolStackInit(psymstResult);

    //- return result

    return(psymstResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolStackInit()
///
/// ARGS.:
///
///	psymst.: symbol stack to clear
///
/// RTN..: void
///
/// DESCR: Initialize a symbol stack
///
/// **************************************************************************

void PSymbolStackInit(struct PSymbolStack *psymst)
{
    //- clear stack top

    psymst->iTop = -1;
}


/// **************************************************************************
///
/// SHORT: PSymbolStackNewFromPidinStack()
///
/// ARGS.:
///
///	ppist.: pidin stack to convert
///
/// RTN..: struct PSymbolStack * : new symbol stack
///
/// DESCR: Create symbol stack correspoonding to ppist
///
/// TODO.: Optimize, function to get #pidins on stack
///
/// **************************************************************************

struct PSymbolStack * 
PSymbolStackNewFromPidinStack(struct PidinStack *ppist)
{
    //- allocate result

    struct PSymbolStack * psymstResult = PSymbolStackCalloc();

    //- if allocated

    if (psymstResult)
    {
	//v symbol to lookup

	struct symtab_HSolveListElement *phsle;

	//v loop var

	int i;
	int j;

	//v number of entries in compressed pidin stack

	int iEntries;

	//- duplicate pidin stack

	struct PidinStack *ppistComp = PidinStackDuplicate(ppist);

	//- compact duplicate

	PidinStackCompress(ppistComp);

	//- keep flags

	if (PidinStackIsRooted(ppistComp))
	{
	    PSymbolStackSetRooted(psymstResult);
	}

	//- get number of pidins

	iEntries = PidinStackNumberOfEntries(ppistComp);

	//- loop over duplicate pidinstack

	for (i = 0 ; i < iEntries ; i++)
	{
	    //- duplicate compressed pidin stack

	    struct PidinStack *ppistDupl = PidinStackDuplicate(ppistComp);

	    //- pop unresolvable elements

	    for (j = i + 1 ; j < iEntries ; j++)
	    {
		PidinStackPop(ppistDupl);
	    }

	    //- resolve symbol

	    phsle = SymbolsLookupHierarchical(NULL,ppistDupl);

	    //- free duplicate pidin stack

	    PidinStackFree(ppistDupl);

	    //- if symbol not found

	    if (!phsle)
	    {
		//- free symbol stack

		PSymbolStackFree(psymstResult);

		//- unset result

		psymstResult = NULL;

		//- break loop

		break;
	    }

	    //- push symbol

	    PSymbolStackPush(psymstResult,phsle);
	}

	//- free compressed pidin stack

	PidinStackFree(ppistComp);
    }

    //- return result

    return(psymstResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolStackPop()
///
/// ARGS.:
///
///	psymst.: symbol stack to pop
///
/// RTN..: struct symtab_IdentifierIndex * : popped idin, NULL for failure
///
/// DESCR: Pop symbol from stack
///
/// **************************************************************************

struct symtab_HSolveListElement * PSymbolStackPop(struct PSymbolStack *psymst)
{
    //- set default result : failure

    struct symtab_HSolveListElement * phsleResult = NULL;

    //- if underflow

    if (psymst->iTop == -1)
    {
	//- return failure

	return(NULL);
    }

    //- set result : current element name

    phsleResult = psymst->pphsle[psymst->iTop];

    //- decrement top

    psymst->iTop--;

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolStackPush()
///
/// ARGS.:
///
///	psymst.: symbol stack to push onto
///	phsle..: phsle to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push phsle onto stack
///
/// **************************************************************************

int PSymbolStackPush
(struct PSymbolStack *psymst,struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- increment stack top

    psymst->iTop++;

    //- if overflow

    if (psymst->iTop >= MAX_ELEMENT_DEPTH)
    {
	//- decrement top

	psymst->iTop--;

	//- return failure

	return(FALSE);
    }

    //- register current element

    psymst->pphsle[psymst->iTop] = phsle;

    //- return result

    return(bResult);
}


