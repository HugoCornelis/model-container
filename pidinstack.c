//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pidinstack.c 1.59 Sun, 04 Nov 2007 22:34:52 -0600 hugo $
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
//o pidin stack intro :
//o -------------------
//o
//o pidin stacks are almost exactly what the word says : a stack of 
//o (references to) pidins.  The interface mainly is concerned about
//o stack operations, although sometimes more is needed (like getting 
//o the number of elements in the stack).  It's primarily purpose is
//o context association for symbols / parameters / functions.
//o 
//o If a context is valid (i.e. the symbol it referes to is present in 
//o Neurospaces) a pidinstack will try to associated a serial mapping 
//o with it.  The maintenance of the serial mapping comes mostly from
//o PidinStackLookupTopSymbol() since pidinstacks are assumed to be
//o give meaningfull serial mappings only for symbols present in 
//o Neurospaces.  If you push 'simple pidins' on a pidin stack, you currently 
//o force the cached serial mapping to be (partially) out of sync.  If you ask 
//o for serials afterwards, they first have to be recalculated.  It is 
//o probably good to remind that a principal serial index completely defines
//o the context.
//o
//o It is possible to push 'points to parent' pidin on a pidin stack.
//o If you want to get rid of these, use compacting routines.
//o
//o There is some ambiguity about what to do when multiple rooted pidins
//o are pushed.  At the moment this clears the pidin stack for some 
//o compacting routines only.
//o
//////////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/parameters.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE
#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

#define PIDINSTACK_SMART_CACHE

#endif
#endif


/// **************************************************************************
///
/// SHORT: PidinStackAppend()
///
/// ARGS.:
///
///	ppistTarget..: target & first source context stack
///	ppistSource..: stack to append
///
/// RTN..: int : success of operation
///
/// DESCR: Append two pidin stacks, flags unaffected, no compaction
///
/// **************************************************************************

int PidinStackAppend
(struct PidinStack *ppistTarget, struct PidinStack *ppistSource)
{
    //- set default result : ok

    int iResult = TRUE;

    int i;

    //- loop over source stack

    for (i = 0; i < PidinStackNumberOfEntries(ppistSource) ; i++)
    {
	//- push source pidin onto target

	if (PidinStackPush
	    (ppistTarget,PidinStackElementPidin(ppistSource,i)) == FALSE)
	{
	    return(FALSE);
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackAppendCompact()
///
/// ARGS.:
///
///	ppistTarget..: target & first source context stack
///	ppistSource..: stack to append
///
/// RTN..: int : success of operation
///
/// DESCR: Append two pidin stacks, flags unaffected, with compaction
///
/// **************************************************************************

int
PidinStackAppendCompact
(struct PidinStack *ppistTarget, struct PidinStack *ppistSource)
{
    //- set default result : ok

    int iResult = TRUE;

    int i;

    //- if second source is rooted

    if (PidinStackIsRooted(ppistSource))
    {
	//- simple copy to target

	*ppistTarget = *ppistSource;
    }

    //- else

    else
    {
#ifdef PIDINSTACK_SMART_CACHE

	//! considered a hardcoded solution,
	//!
	//! nice solution : consists of pidinqueues and pidinstacks 
	//! cooperation.
	//! 1. convert ppistSource to ppiqu
	//! 2. some cooperation between ppiqu and SymbolLookupHierarchical()

/* 	//- get main hypothetical root */

/* 	struct ImportedFile *pif = ImportedFileGetRootImport(); */

/* 	struct symtab_HypotheticalRoot *phyroRoot */
/* 	    = ImportedFileGetHypotheticalRoot(pif); */

/* 	//- set start of symbol queue */

/* 	struct symtab_HSolveListElement *phsleLast = &phyroRoot->hsle; */

	//- loop over source's symbols

	for (i = 0 ; i < PidinStackNumberOfEntries(ppistSource) ; i++)
	{
	    //- get current source idin

	    struct symtab_IdentifierIndex *pidin
		= PidinStackElementPidin(ppistSource,i);

	    //- if points to parent

	    if (IdinPointsToParent(pidin))
	    {
		//- pop target

		if (!PidinStackPop(ppistTarget))
		{
		    iResult = 0;
		    break;
		}
	    }

	    //- else

	    else
	    {

		//t we could do something smart here :
		//t maintain symbol cache and serial mapping as follows :
		//t
		//t lookup current symbol from ppistSource
		//t if found
		//t     push symbol with PidinStackPushSymbol()
		//t else
		//t     push current pidin from ppistSource
		//t

		//- get current symbol

		//! the dirty solution, see comments above

		struct symtab_HSolveListElement *phsleSource
		    = PSymbolSerialStackElementSymbol(&ppistSource->symsst,i);

		//- if cached

		if (phsleSource)
		{
		    //- push symbol (and maintain caches)

		    PidinStackPushSymbol(ppistTarget,phsleSource);
		}

		//- else

		else
		{
		    //- push to target

		    if (!PidinStackPush(ppistTarget,pidin))
		    {
			iResult = 0;
			break;
		    }
		}
	    }
	}

#else

	//- loop over second source's symbols

	for (i = 0 ; i < PidinStackNumberOfEntries(ppistSource) ; i++)
	{
	    //- get current source idin

	    struct symtab_IdentifierIndex *pidin
		= PidinStackElementPidin(ppistSource,i);

	    //- if points to parent

	    if (IdinPointsToParent(pidin))
	    {
		//- pop target

		if (!PidinStackPop(ppistTarget))
		{
		    iResult = 0;
		    break;
		}
	    }

	    //- else

	    else
	    {
		//- push to target

		if (!PidinStackPush(ppistTarget,pidin))
		{
		    iResult = 0;
		    break;
		}
	    }
	}
#endif
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackCalloc()
///
/// ARGS.:
///
/// RTN..: struct PidinStack * 
///
///	Newly allocated pidin stack, NULL for failure
///
/// DESCR: Allocate a new pidin stack symbol table element
///
/// **************************************************************************

struct PidinStack * PidinStackCalloc(void)
{
    //- set default result : failure

    struct PidinStack *ppistResult = NULL;

    //- allocate pidin stack

    ppistResult = (struct PidinStack *)
	  calloc(1,sizeof(struct PidinStack));

    //- initialize pidin stack

    PidinStackInit(ppistResult);

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackEqual()
///
/// ARGS.:
///
///	ppist1: pidin stack to test
///	ppist2: pidin stack to test
///
/// RTN..: int : TRUE if equal
///
/// DESCR: check if two pidinstacks equal
///
///	equal defined to be all id's refer to same hierarchical symbols,
///	ie comparisons are done symbollicaly.
///
///	This function will only give valid results for rooted pidinstacks.
///
/// **************************************************************************

int PidinStackEqual
(struct PidinStack *ppist1, struct PidinStack *ppist2)
{
    //- set default result : equal

    int iResult = TRUE;

    //v loop var

    int i;

    //- get number of entries for both stacks

    int i1 = PidinStackNumberOfEntries(ppist1);
    int i2 = PidinStackNumberOfEntries(ppist2);

    //- if pointers equal

    if (ppist1 == ppist2)
    {
	//- return equal

	return(TRUE);
    }

    //- if not same number of entries

    if (i1 != i2)
    {
	//- return not equal

	return(FALSE);
    }

    //- if no entries in stacks

    if (i1 < 0)
    {
	//- return equal

	return(TRUE);
    }

#ifdef PIDINSTACK_SMART_CACHE

    //t do something smart with serial IDs :
    //t
    //t if #(serial ID entries) different
    //t     use serial ID of lowest number available entries
    //t     since serial ID entries is direct consequence from 
    //t         symbol serial cache, lowest number available entries
    //t         can be calculated using symbol serial cache.
    //t
    //t if serial IDs equal
    //t     start at #(serial ID entries)
    //t else
    //t     return unequal
    //t

    //! I should evaluate what speed change this gives
    //! hopefully faster in the most common cases

    //- if both pidinstacks rooted

    if (PidinStackIsRooted(ppist1)
	&& PidinStackIsRooted(ppist2))
    {
	//- if number of cached entries same

	if (PSymbolSerialStackCachedEntries(&ppist1->symsst)
	    == PSymbolSerialStackCachedEntries(&ppist2->symsst))
	{
	    //- if principal serials equal

	    if (PSymbolSerialStackCachedSerial(&ppist1->symsst)
		== PSymbolSerialStackCachedSerial(&ppist2->symsst))
	    {
		//- start at uncached entry

		i = PSymbolSerialStackCachedEntries(&ppist1->symsst) + 1;
	    }

	    //- else

	    else
	    {
		//- set result : unequal

		iResult = FALSE;

		//- skip compare loop

		i = i1 + 1;
	    }
	}

	//- else

	else
	{
	    //- start at first entry

	    i = 0;
	}
    }

    //- else

    else
    {
	//- start at first entry

	i = 0;
    }

    //- loop over entries in stacks, compare

    for (; i < i1 ; i++)
    {
	//- get current entries

	struct symtab_IdentifierIndex *pidin1
	    = PidinStackElementPidin(ppist1,i);

	struct symtab_IdentifierIndex *pidin2
	    = PidinStackElementPidin(ppist2,i);

	//- if current idins not equal

	if (!IdinEqual(pidin1,pidin2))
	{
	    //- set result : not equal

	    iResult = FALSE;

	    //- break compare loop

	    break;
	}
    }

#else

    //- loop over entries in stacks

    for (i = 0 ; i < i1 ; i++)
    {
	//- get current entries

	struct symtab_IdentifierIndex *pidin1
	    = PidinStackElementPidin(ppist1,i);

	struct symtab_IdentifierIndex *pidin2
	    = PidinStackElementPidin(ppist2,i);

	//- if current idins not equal

	if (!IdinEqual(pidin1,pidin2))
	{
	    //- set result : not equal

	    iResult = FALSE;

	    //- break compare loop

	    break;
	}
    }

#endif

    //t if result is TRUE :
    //t update caches of poorest pidinstack
    //t with the one of richest pidinstack

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackInit()
///
/// ARGS.:
///
///	ppist.: pidin stack to clear
///
/// RTN..: void
///
/// DESCR: Initialize a pidin stack
///
/// **************************************************************************

void PidinStackInit(struct PidinStack *ppist)
{
    //- clear stack top

    ppist->iTop = -1;

#ifdef PIDINSTACK_SMART_CACHE

    //- init symbol cache

    PSymbolSerialStackInit(&ppist->symsst);

#else

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

    //- serial : points to this symbol, whatever it may be

    ppist->iPrincipalSerial = 0;

#endif


#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

    //- init symbol cache

    PSymbolStackInit(&ppist->symst);

#endif

#endif
}


/// **************************************************************************
///
/// SHORT: PidinStackIsWildcard()
///
/// ARGS.:
///
///	ppist.: pidin stack
///
/// RTN..: int
///
///	1 if pidinstack contains wildcards.
///
/// DESCR: Check if pidinstack contains wildcards.
///
/// **************************************************************************

int PidinStackIsWildcard(struct PidinStack *ppist)
{
    //- set default result : no

    int iResult = 0;

    //- loop over pidins

    int i;

    for (i = 0 ; i < PidinStackNumberOfEntries(ppist) ; i++)
    {
	//- get current source idin

	struct symtab_IdentifierIndex *pidin
	    = PidinStackElementPidin(ppist,i);

	//- if is wildcard

	if (IdinIsWildCard(pidin, "**"))
	{
	    //- return result : yes

	    return(1);
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackLookupBaseSymbol()
///
/// ARGS.:
///
///	ppist.: pidin stack
///
/// RTN..: struct symtab_HSolveListElement * : base symbol, used by ppist.
///
/// DESCR: Lookup base symbol.
///
/// **************************************************************************

struct symtab_HSolveListElement *
PidinStackLookupBaseSymbol(struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get number of entries in stack

    int iEntries = PidinStackNumberOfEntries(ppist);

    //- if no entries

    if (iEntries == 0)
    {
	//- for a rooted context

	if (PidinStackIsRooted(ppist))
	{
	    //- return root symbol

	    phsleResult = SymbolsLookupHierarchical(NULL,ppist);

	    return(phsleResult);
	}

	//- else

	else
	{
	    //- return failure

	    return(NULL);
	}
    }

    //- if empty cache

    if (PSymbolSerialStackNumberOfEntries(&ppist->symsst) == 0)
    {
	//- do normal lookup

	phsleResult = SymbolsLookupHierarchical(NULL,ppist);

	//- set first entry for cache

	PSymbolSerialStackPush(&ppist->symsst,phsleResult);

	//- return result

	return(phsleResult);
    }

    //- else

    else
    {
	//t we could do a sanity check here on symbol cache :
	//t top symbol pidin == top pidin stack
	//t etc.

	//- set result from cache

	phsleResult = PSymbolSerialStackBase(&ppist->symsst);

	//- return result

	return(phsleResult);
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackLookupTopSymbol()
///
/// ARGS.:
///
///	ppist.: pidin stack
///
/// RTN..: struct symtab_HSolveListElement * : symbol, referenced by ppist
///
/// DESCR: Lookup top symbol
///
/// **************************************************************************

struct symtab_HSolveListElement *
PidinStackLookupTopSymbol(struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //t we should to this with a pidin queue, but that's too much work 
    //t at the moment
    //t
    //t SymbolLookupHierarchical() should do its job on a queue instead
    //t of a pidinstack with an active level
    //t by feeding all the entries of ppist one at a time to 
    //t SymbolLookupHierarchical() and registering the result in the cache
    //t of ppist, all this is nicer and more efficient.

#ifdef PIDINSTACK_SMART_CACHE


    //- get number of entries in cache

    int iCached = PSymbolSerialStackNumberOfEntries(&ppist->symsst);

    //- get number of entries in stack

    int iEntries = PidinStackNumberOfEntries(ppist);

    //- if no entries

    if (iEntries == 0)
    {
	if (PidinStackIsRooted(ppist))
	{
	    //- return root symbol

	    phsleResult = SymbolsLookupHierarchical(NULL,ppist);

	    return(phsleResult);
	}
	else
	{
	    //- return failure

	    return(NULL);
	}
    }

    //- if single entry

    if (iEntries == 1)
    {
	//- if empty cache

	if (PSymbolSerialStackNumberOfEntries(&ppist->symsst) == 0)
	{
	    //- do normal lookup

	    phsleResult = SymbolsLookupHierarchical(NULL,ppist);

	    //- if not found

	    if (!phsleResult)
	    {
		return(NULL);
	    }

	    //- set first entry for cache

	    PSymbolSerialStackPush(&ppist->symsst,phsleResult);

	    //- return result

	    return(phsleResult);
	}

	//- else

	else
	{
	    //t we could do a sanity check here on symbol cache :
	    //t number of entries == 1
	    //t top symbol pidin == top pidin stack
	    //t etc.

	    //- set result from cache

	    phsleResult = PSymbolSerialStackTop(&ppist->symsst);

	    //- return result

	    return(phsleResult);
	}
    }

    //- if #cached different from #stack

    if (iCached != iEntries)
    {
	struct symtab_HSolveListElement *phsleMinor = NULL;
	struct symtab_HSolveListElement *phsle = NULL;

	int i;

	//- construct a minor context with one less entry

	struct PidinStack *ppistMinor
	    = PidinStackDuplicate(ppist);

	PidinStackPop(ppistMinor);

	//- lookup top for the minor

	//t connections pidin are not found, so interferes with 
	//t serial index maintenance (via PSymbolSerialStackPush() )
	//t means connection lookup will not benefit from 
	//t speed cache used by PidinStackLookupTopSymbol().

	if (PidinStackLookupTopSymbol(ppistMinor))
	{
	    //- copy resolved cache from minor to target

	    for ( i = iCached ; i < iEntries - 1 ; i++ )
	    {
		PSymbolSerialStackPush
		    (&ppist->symsst,
		     PSymbolSerialStackElementSymbol(&ppistMinor->symsst,i));
	    }
	}

	//- get top of minor, comes from cache

	phsleMinor = PidinStackLookupTopSymbol(ppistMinor);

	if (phsleMinor)
	{
	    //- push current entry back to minor

	    PidinStackPush(ppistMinor,PidinStackTop(ppist));

	    //- do lookup on (non-)minor, in last symbol from minor

	    //t connections pidin are not found, so interferes with 
	    //t serial index maintenance (via PSymbolSerialStackPush() )
	    //t means connection lookup will not benefit from 
	    //t speed cache used by PidinStackLookupTopSymbol().

	    phsle
		= SymbolLookupHierarchical
		  (phsleMinor,ppistMinor,iEntries - 1,TRUE);

	    //- if found

	    if (phsle)
	    {
		//- set new entry for cache

		PSymbolSerialStackPush(&ppist->symsst,phsle);
	    }
	}

	//- free minor context

	PidinStackFree(ppistMinor);

	//- set result

	phsleResult = phsle;
    }

    //- else (cache is up to date)

    else
    {
	//- set result from cache

	phsleResult = PSymbolSerialStackTop(&ppist->symsst);
    }

#else

#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

    //- get number of entries in cache

    int iCached = PSymbolStackNumberOfEntries(&ppist->symst);

    //- get number of entries in stack

    int iEntries = PidinStackNumberOfEntries(ppist);

    //- if no entries

    if (iEntries == 0)
    {
	//- return failure

	return(NULL);
    }

    //- if single entry

    if (iEntries == 1)
    {
	//- if empty cache

	if (PSymbolStackNumberOfEntries(&ppist->symst) == 0)
	{
	    //- do normal lookup

	    phsleResult = SymbolsLookupHierarchical(NULL,ppist);

	    //- set first entry for cache

	    PSymbolStackPush(&ppist->symst,phsleResult);

	    //- return result

	    return(phsleResult);
	}

	//- else

	else
	{
	    //t we could do a sanity check here on symbol cache :
	    //t number of entries == 1
	    //t top symbol pidin == top pidin stack
	    //t etc.

	    //- set result from cache

	    phsleResult = PSymbolStackTop(&ppist->symst);

	    //- return result

	    return(phsleResult);
	}
    }

    //- if #cached different from #stack

    if (iCached != iEntries)
    {
	struct symtab_HSolveListElement *phsleMinor = NULL;
	struct symtab_HSolveListElement *phsle = NULL;

	int i;

	//- construct a minor context with one less entry

	struct PidinStack *ppistMinor
	    = PidinStackDuplicate(ppist);

	PidinStackPop(ppistMinor);

	//- lookup top for the minor

	PidinStackLookupTopSymbol(ppistMinor);

	//- copy resolved cache from minor to target

	for ( i = iCached ; i < iEntries - 1 ; i++ )
	{
	    PSymbolStackPush
		(&ppist->symst,
		 PSymbolStackElementSymbol(&ppistMinor->symst,i));
	}

	//- get top of minor, comes from cache

	phsleMinor = PidinStackLookupTopSymbol(ppistMinor);

	//- push current entry back to minor

	PidinStackPush(ppistMinor,PidinStackTop(ppist));

	//- do lookup on (non-)minor, in last symbol from minor

	phsle
	    = SymbolLookupHierarchical
	      (phsleMinor,ppistMinor,iEntries - 1,TRUE);

	//- free minor context

	PidinStackFree(ppistMinor);

	//- set new entry for cache

	PSymbolStackPush(&ppist->symst,phsle);

	//- set result

	phsleResult = phsle;
    }

    //- else (cache is up to date)

    else
    {
	//- set result from cache

	phsleResult = PSymbolStackTop(&ppist->symst);
    }

#else

    //- set result : normal lookup

    phsleResult = SymbolsLookupHierarchical(NULL,ppist);

#endif

#endif

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackMatch()
///
/// ARGS.:
///
///	ppist1: pidin stack to test
///	ppist2: pidin stack to test, wildcards recognized
///
/// RTN..: int : TRUE if match
///
/// DESCR: check if two pidinstacks match, wildcards allowed
///
/// **************************************************************************

int PidinStackMatch(struct PidinStack *ppist1,struct PidinStack *ppist2)
{
    //- set default result : match

    int iResult = TRUE;

    //v loop vars

    int i1,i2;

    //- get number of entries for both stacks

    int iTop1 = PidinStackNumberOfEntries(ppist1);
    int iTop2 = PidinStackNumberOfEntries(ppist2);

    //- loop

    i1 = 0;
    i2 = 0;

    for (;;)
    {
	//- if all entries matched

	if (i1 == iTop1 && i2 == iTop2)
	{
	    //- break matching loop

	    break;
	}

	//- if no more entries in wildcard stack

	if (i2 >= iTop2)
	{
	    //- set result : no match

	    iResult = FALSE;

	    //- break matching loop

	    break;
	}

	//- if no more entries in symbol stack

	else if (i1 >= iTop1)
	{
	    //- if one of the next entries of wildcard stack is not a wildcard

	    //! this says that /Purkinje matches with /Purkinje/**

	    while (i2 < iTop2
		   && IdinIsWildCard(PidinStackElementPidin(ppist2,i2), "**"))
	    {
		i2++;
	    }

	    if (i2 < iTop2)
	    {
		//- set result : no match

		iResult = FALSE;
	    }

	    //- break matching loop

	    break;
	}

	//- if current idins equal

	else if (IdinEqual
		 (PidinStackElementPidin(ppist1,i1),
		  PidinStackElementPidin(ppist2,i2)))
	{
	    //- increment idin counts

	    i1++;
	    i2++;
	}

	//- else if wildcard match

	else if (IdinMatch
		 (PidinStackElementPidin(ppist1,i1),
		  PidinStackElementPidin(ppist2,i2)))
	{
/* 	    //- if first not at end of stack, but second is at end of stack */

/* 	    if (PidinStackElementPidin(ppist1,i1) */
/* 		&& !PidinStackElementPidin(ppist2,i2 + 1)) */
/* 	    { */
/* 		//- set result : wildcard match */

/* 		iResult = TRUE; */

/* 		//- break matching loop */

/* 		break; */
/* 	    } */

	    //- if wildcard idin is recursive

	    if (IdinIsRecursive(PidinStackElementPidin(ppist2,i2)))
	    {
		//- increment idin count for first stack

		i1++;

		//- if first at end of stack, but second not at end of stack

		if (!PidinStackElementPidin(ppist1,i1)
		    && PidinStackElementPidin(ppist2,i2 + 1))
		{
		    //- set result : no match

		    iResult = FALSE;

		    //- break matching loop

		    break;
		}

		//- if second at end of stack

		if (!PidinStackElementPidin(ppist2,i2 + 1))
		{
		    //- set result : wildcard match

		    iResult = TRUE;

		    //- break matching loop

		    break;
		}

		//- if next second context matches new entry in first

		if (IdinMatch
		    (PidinStackElementPidin(ppist1,i1),
		     PidinStackElementPidin(ppist2,i2 + 1)))
		{
		    //- increment idin count for second stack

		    i2++;
		}
	    }

	    //- else not recursive wildcard

	    else
	    {
		//- increment idin counts

		i1++;
		i2++;
	    }
	}

	//- else : no match

	else
	{
	    //- set result : no match

	    iResult = FALSE;

	    //- break matching loop

	    break;
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackNewFromParameterSymbols()
///
/// ARGS.:
///
///	ppar..: parameter referencing a field
///
/// RTN..: struct PidinStack * : resulting pidin stack
///
/// DESCR: Create pidin stack from pidins in parameter
///
///	The resulting pidin stack will not contain any referenced fields or
///	I/O relations.
///
/// **************************************************************************

struct PidinStack *
PidinStackNewFromParameterSymbols(struct symtab_Parameters *ppar)
{
    //- set default result : failure

    struct PidinStack *ppistResult = NULL;

    //- if allocate a pidin stack

    ppistResult = PidinStackCalloc();

    if (ppistResult)
    {
	//- get first pidin

	struct symtab_IdentifierIndex *pidin 
	    = ParameterFirstIdin(ppar);

	//- check for rooted flags

	if (IdinIsRooted(pidin))
	{
	    PidinStackSetRooted(ppistResult);
	}

	//- loop over pidins from parameter

	while (pidin)
	{
	    if (!IdinIsField(pidin))
	    {
		//- push pidin on pidinstack

		PidinStackPush(ppistResult,pidin);
	    }

	    //- go to next pidin

	    pidin = pidin->pidinNext;
	}
    }

    //- return result

    return(ppistResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: PidinStackNewFromPidins() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pidin..: pidin list */
/* /// */
/* /// RTN..: struct PidinStack * : resulting pidin stack */
/* /// */
/* /// DESCR: Create pidin stack from pidins */
/* /// */
/* /// ************************************************************************** */

/* struct PidinStack * */
/* PidinStackNewFromPidins(struct symtab_IdentifierIndex *pidin) */
/* { */
/*     //- set default result : failure */

/*     struct PidinStack *ppistResult = NULL; */

/*     //- if allocate a pidin stack */

/*     ppistResult = PidinStackCalloc(); */

/*     if (ppistResult) */
/*     { */
/* 	//- loop over pidins */

/* 	while (pidin) */
/* 	{ */
/* 	    //- push pidin on pidinstack */

/* 	    PidinStackPushCompact(ppistResult,pidin); */

/* 	    //- go to next pidin */

/* 	    pidin = pidin->pidinNext; */
/* 	} */
/*     } */

/*     //- return result */

/*     return(ppistResult); */
/* } */


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: PidinStackNewFromPSymbolStack() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	psymst..: symbol stack */
/* /// */
/* /// RTN..: struct PidinStack * : resulting pidin stack */
/* /// */
/* /// DESCR: Create pidin stack from pidins in symbols in symbol stack */
/* /// */
/* /// NOTE.: should be optimized with respect to symbol cache. */
/* /// */
/* /// ************************************************************************** */

/* struct PidinStack * */
/* PidinStackNewFromPSymbolStack(struct PSymbolStack *psymst) */
/* { */
/*     //- set default result : failure */

/*     struct PidinStack *ppistResult = NULL; */

/*     //- if allocate a pidin stack */

/*     ppistResult = PidinStackCalloc(); */

/*     if (ppistResult) */
/*     { */
/* 	//v loop var */

/* 	int i; */

/* 	//v number of entries */

/* 	int iEntries = 0; */

/* 	//- if symbol stack is rooted */

/* 	if (PSymbolStackIsRooted(psymst)) */
/* 	{ */
/* 	    //- set rooted pidinstack */

/* 	    PidinStackSetRooted(ppistResult); */
/* 	} */

/* 	//- get number of entries in symbol stack */

/* 	iEntries = PSymbolStackNumberOfEntries(psymst); */

/* 	//- loop over entries in symbol stack */

/* 	for (i = 0 ; i < iEntries ; i++) */
/* 	{ */
/* 	    //- get symbol from symbol stack */

/* 	    struct symtab_HSolveListElement *phsle */
/* 		= PSymbolStackElementSymbol(psymst,i); */

/* 	    //- get symbol pidin */

/* 	    struct symtab_IdentifierIndex *pidin */
/* 		= SymbolGetPidin(phsle); */

/* 	    //- push pidin */

/* 	    PidinStackPush(ppistResult,pidin); */
/* 	} */
/*     } */

/*     //- return result */

/*     return(ppistResult); */
/* } */


/// **************************************************************************
///
/// SHORT: PidinStackParse()
///
/// ARGS.:
///
///	pc....: string to parse
///
/// RTN..: struct PidinStack * : resulting pidin stack
///
/// DESCR: Parse string and fill in pidin
///
///	Idins are calloc()'ed, identifiers are calloc()'ed.
///
/// **************************************************************************

struct PidinStack *PidinStackParse(char *pc)
{
    //- set default result : failure

    struct PidinStack *ppistResult = NULL;

    int iPos = 0;

    char *pcSeperators = "  \t\n";

    char *pcSymbolSeperator = IDENTIFIER_CHILD_STRING;

    char *pcArg = NULL;

    //v root marker

    int bRoot = FALSE;

    //- allocate pidin stack

    ppistResult = PidinStackCalloc();

    if (!ppistResult)
    {
	return(NULL);
    }

    //- skip first white space

    pcArg = strpbrk(pc, pcSeperators);

    while (pcArg == pc)
    {
	pc++;

	pcArg = strpbrk(pc, pcSeperators);
    }

    //- skip first namespace operator

    if (pc[iPos] && NameSpaceIsNameSpaceOperator(&pc[iPos]))
    {
	//t note : only checks the first char, yet skips for the
	//t length of the string

	iPos += strlen(IDENTIFIER_NAMESPACE_STRING);
    }

    //- loop over all namespace operators

    while (pc[iPos] && NameSpaceIsNameSpaceToken(&pc[iPos]))
    {
	struct symtab_IdentifierIndex *pidin = NULL;

	char *pcName = NULL;

	int iSize = -1;

	//- allocate idin

	pidin = IdinCalloc();

	//- get size of token + 0 terminator

	iSize = NameSpaceEndThisToken(&pc[iPos]);

	//- fill in name

	pcName = (char *)calloc(1 + iSize,sizeof(char));

	strncpy(pcName, &pc[iPos], iSize);

	pcName[iSize] = '\0';

	//- if reference to parent

	if (strcmp(pcName, IDENTIFIER_SYMBOL_PARENT_STRING) == 0)
	{
	    IdinSetFlags(pidin, FLAG_IDENTINDEX_PARENT);
	}

	IdinSetName(pidin, pcName);

	IdinSetNamespaced(pidin);

	//- push name on stack

	PidinStackPush(ppistResult, pidin);

	//- remember new positions

	iPos += iSize + strlen(IDENTIFIER_NAMESPACE_STRING);
    }

    //- if first char is symbol seperator

    if (strncmp(&pc[iPos], SYMBOL_ROOT, strlen(SYMBOL_ROOT)) == 0)
    {
	//- flag as rooted

	PidinStackSetRooted(ppistResult);
    }

    //- loop over string

    while (pc[iPos]/*  && NameSpaceIsChildToken(&pc[iPos]) */)
    {
	struct symtab_IdentifierIndex *pidin = NULL;

	char *pcName = NULL;

	int iSize = -1;

	int iTokenSize = -1;

	//- if first char is symbol seperator

	if (strncmp
	    (&pc[iPos],
	     IDENTIFIER_CHILD_STRING,
	     strlen(IDENTIFIER_CHILD_STRING))
	    == 0)
	{
	    //- go to next char

	    iPos += strlen(IDENTIFIER_CHILD_STRING);
	}

	//- else

	else
	{
	    //- if first id already parsed

	    if (bRoot)
	    {
		//- break loop

		break;
	    }
	}

	//- get size of token + 0 terminator

	iTokenSize = NameSpaceEndThisToken(&pc[iPos]);

	//- if till end of string

	if (iTokenSize == -1)
	{
	    //- get size from string

	    iSize = strlen(&pc[iPos]);
	}

	//- else

	else
	{
	    //- get size from token

	    iSize = iTokenSize;
	}

	//- if no token

	if (!iSize)
	{
	    //- nothing to do, next loop iteration

	    continue;
	}

	//- set : first id is being parsed

	bRoot = TRUE;

	//- allocate idin

	pidin = IdinCalloc();

	//- fill in name

	pcName = (char *)calloc(1 + iSize,sizeof(char));

	strncpy(pcName, &pc[iPos], iSize);

	pcName[iSize] = '\0';

	//- if reference to parent

	if (strcmp(pcName, IDENTIFIER_SYMBOL_PARENT_STRING) == 0)
	{
	    IdinSetFlags(pidin, FLAG_IDENTINDEX_PARENT);
	}

	IdinSetName(pidin, pcName);

	//- push name on stack

	PidinStackPush(ppistResult, pidin);

	//- remember new position

	if (iTokenSize != -1)
	{
	    iPos += iTokenSize;
	}
	else
	{
	    iPos += iSize;
	}
    }

    //- compress stack

    PidinStackCompress(ppistResult);

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPop()
///
/// ARGS.:
///
///	ppist.: pidin stack to pop
///
/// RTN..: struct symtab_IdentifierIndex * : popped idin, NULL for failure
///
/// DESCR: Pop pidin from stack
///
/// **************************************************************************

struct symtab_IdentifierIndex * PidinStackPop(struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_IdentifierIndex * pidinResult = NULL;

    //- if underflow

    if (PidinStackNumberOfEntries(ppist) == 0)
    {
	//- return failure

	return(NULL);
    }

    //- set result : current element name

    pidinResult = PidinStackElementPidin(ppist,ppist->iTop);

    //- decrement top

    ppist->iTop--;

#ifdef PIDINSTACK_SMART_CACHE

    if (PSymbolSerialStackNumberOfEntries(&ppist->symsst)
	> PidinStackNumberOfEntries(ppist) + 1)
    {
	fprintf
	    (stderr,"Warning : symbol cache for pidinstack corrupt\n\t");

	PidinStackPrint(ppist,stderr);

	fprintf(stderr,"\n");
    }

    //- if cache has more entries than stack

    while (PSymbolSerialStackNumberOfEntries(&ppist->symsst)
	   > PidinStackNumberOfEntries(ppist))
    {
	//- pop symbol stack

	struct symtab_HSolveListElement *phsle
	    = PSymbolSerialStackPop(&ppist->symsst);
    }

#else

#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

    if (PSymbolStackNumberOfEntries(&ppist->symst)
	> PidinStackNumberOfEntries(ppist) + 1)
    {
	fprintf
	    (stderr,"Warning : symbol cache for pidinstack corrupt\n\t");

	PidinStackPrint(ppist,stderr);

	fprintf(stderr,"\n");
    }

    //- if cache has more entries than stack

    while (PSymbolStackNumberOfEntries(&ppist->symst)
	   > PidinStackNumberOfEntries(ppist))
    {
	//- pop symbol stack

	struct symtab_HSolveListElement *phsle
	    = PSymbolStackPop(&ppist->symst);
    }

#else

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

    ppist->iPrincipalSerial = -1;

#endif

#endif

#endif

    //- return result

    return(pidinResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPrint()
///
/// ARGS.:
///
///	ppist.: pidin stack to print
///	pfile.: file to print pidin stack to, NULL means stdout
///
/// RTN..: void
///
/// DESCR: Print pidinstack
///
/// **************************************************************************

void PidinStackPrint(struct PidinStack *ppist, FILE *pfile)
{
    char pc[1000];

    PidinStackString(ppist, pc, sizeof(pc));

    //- no file means stdout

    if (!pfile)
    {
	pfile = stdout;
    }

    fprintf(pfile, "%s", pc);
}


/// **************************************************************************
///
/// SHORT: PidinStackPush()
///
/// ARGS.:
///
///	ppist.: pidin stack to push onto
///	pidin.: pidin to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push pidin onto stack
///
/// **************************************************************************

int PidinStackPush
(struct PidinStack *ppist,struct symtab_IdentifierIndex *pidin)
{
    //- set default result : ok

    int bResult = TRUE;

    //- increment stack top

    ppist->iTop++;

    //- if overflow

    if (ppist->iTop >= MAX_ELEMENT_DEPTH)
    {
	//- decrement top

	ppist->iTop--;

	//- return failure

	return(FALSE);
    }

    //- register current element

    ppist->ppidin[ppist->iTop] = pidin;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushAll()
///
/// ARGS.:
///
///	ppist.: pidin stack to push onto
///	pidin.: list of pidin to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push list of pidin onto stack
///
/// **************************************************************************

int PidinStackPushAll
(struct PidinStack *ppist,struct symtab_IdentifierIndex *pidin)
{
    //- set default result : ok

    int bResult = TRUE;

    //- loop over pidin list

    do
    {
	//- push pidin

	if (!PidinStackPush(ppist,pidin))
	{
	    bResult = FALSE;

	    break;
	}

	//- go to next pidin

	pidin = pidin->pidinNext;
    }
    while (pidin);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushCompact()
///
/// ARGS.:
///
///	ppist.: pidin stack to push onto
///	pidin.: list of pidin to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push onto pidin stack, flags unaffected, with compaction
///
/// **************************************************************************

int PidinStackPushCompact
(struct PidinStack *ppist,struct symtab_IdentifierIndex *pidin)
{
    //- set default result : ok

    int iResult = TRUE;

    //- if pidin points to parent

    if (IdinPointsToParent(pidin))
    {
	//- pop stack if possible

	if (PidinStackNumberOfEntries(ppist) > 0)
	{
	    iResult = PidinStackPop(ppist) != NULL;
	}
	else
	{
	    iResult = PidinStackPush(ppist,pidin);
	}
    }

    //- else

    else
    {
	//- push pidin

	iResult = PidinStackPush(ppist,pidin);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushCompactAll()
///
/// ARGS.:
///
///	ppist.: pidin stack to push onto
///	pidin.: list of pidin to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push list of pidin onto stack, compact
///
/// **************************************************************************

int PidinStackPushCompactAll
(struct PidinStack *ppist,struct symtab_IdentifierIndex *pidin)
{
    //- set default result : ok

    int bResult = TRUE;

    //- if given pidin is rooted

    if (IdinIsRooted(pidin))
    {
	//- empty pidinstack

	PidinStackInit(ppist);
    }

    //- loop over pidin list

    do
    {
	//- push pidin

	if (!PidinStackPushCompact(ppist,pidin))
	{
	    bResult = FALSE;

	    break;
	}

	//- go to next pidin

	pidin = pidin->pidinNext;
    }
    while (pidin);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushString()
///
/// ARGS.:
///
///	ppist.: context.
///	pc....: name of symbol to push.
///
/// RTN..: int
///
///	Success of operation.
///
/// DESCR: Push the name of a symbol.
///
/// **************************************************************************

int PidinStackPushString(struct PidinStack *ppist, char *pc)
{
    //- allocate pidin

    struct symtab_IdentifierIndex *pidin = IdinNewFromChars(pc);

    if (!pidin)
    {
	return(0);
    }

    //- push pidin

    PidinStackPush(ppist, pidin);

    return(1);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushStringAndLookup()
///
/// ARGS.:
///
///	ppist.: context.
///	pc....: name of symbol to push and lookup.
///
/// RTN..: struct symtab_HSolveListElement *
///
///	Symbol found, NULL for failure.
///
/// DESCR: Push the name of a symbol on the stack, lookup top symbol.
///
/// **************************************************************************

struct symtab_HSolveListElement *
PidinStackPushStringAndLookup(struct PidinStack *ppist, char *pc)
{
    //- push string

    int iCheck = PidinStackPushString(ppist, pc);

    if (!iCheck)
    {
	return(NULL);
    }

    //- lookup top, return result

    struct symtab_HSolveListElement *phsleResult
	= PidinStackLookupTopSymbol(ppist);

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackPushSymbol()
///
/// ARGS.:
///
///	ppist.: pidin stack to push onto
///	phsle.: symbol pidin to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push symbol's pidin onto stack
///
/// **************************************************************************

int PidinStackPushSymbol
(struct PidinStack *ppist,struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get symbol's pidin

    struct symtab_IdentifierIndex *pidin
	= SymbolGetPidin(phsle);

#ifdef PIDINSTACK_SMART_CACHE

    //- if cache is in sync with context

    if (PidinStackNumberOfEntries(ppist)
	== PSymbolSerialStackNumberOfEntries(&ppist->symsst))
    {
	//- push on symbol stack

	bResult = PSymbolSerialStackPush(&ppist->symsst,phsle);
    }

#else

#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

    //- if cache is in sync with context

    if (PidinStackNumberOfEntries(ppist)
	== PSymbolStackNumberOfEntries(&ppist->symst))
    {
	//- push on symbol stack

	bResult = PSymbolStackPush(&ppist->symst,phsle);
    }

#else

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

    //t this is really implementation dependent (currently it's wrong, so
    //t commented out).
    //t add to principal-to-parents

/*     ppist->iPrincipalSerial += SymbolGetPrincipalSerialToParent(phsle); */

#endif

#endif

#endif

    //- push pidin

    if (bResult)
    {
	bResult = PidinStackPush(ppist,pidin);
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackString()
///
/// ARGS.:
///
///	ppist.: pidin stack to print
///	pc....: string to print pidin stack to.
///	iSize.: size of available space in pc (ignored).
///
/// RTN..: int : success of operation.
///
///	pc....: string to print pidin stack to.
///
/// DESCR: Convert pidinstack to a string.
///
/// **************************************************************************

int PidinStackString(struct PidinStack *ppist,char *pc,int iSize)
{
    //- set default result : ok

    int bResult = TRUE;

    //- current index : zero

    int iIndex = 0;

    int iCount = 0;

    int i;

    //- remember : printing first idin.

    int bFirst = TRUE;

    //- do some sanity

    if (iSize <= 0)
    {
	return(FALSE);
    }

    pc[0] = '\0';

    //- if rooted pidinstack and not namespaced idin

    if (PidinStackIsRooted(ppist))
    {
	//- print root symbol

	iCount = snprintf(&pc[iIndex],iSize,"%s",SYMBOL_ROOT);
	iIndex += iCount;
	iSize -= iCount;
    }

    for (i = 1 ; i < PidinStackNumberOfEntries(ppist) ; i++)
    {
	//- get current entry

	struct symtab_IdentifierIndex *pidin
	    = PidinStackElementPidin(ppist,i - 1);

	//- print seperator if necessary

	if (!bFirst)
	{
	    if (IdinIsField(pidin))
	    {
		iCount
		    = snprintf
			(&pc[iIndex],iSize,"%s",IDENTIFIER_DEREFERENCE_STRING);
		iIndex += iCount;
		iSize -= iCount;
	    }
	    else
	    {
		iCount
		    = snprintf
			(&pc[iIndex],iSize,"%s",IDENTIFIER_CHILD_STRING);
		iIndex += iCount;
		iSize -= iCount;
	    }
	}

	//- print current entry

	iCount = snprintf(&pc[iIndex],iSize,"%s",IdinName(pidin));
	iIndex += iCount;
	iSize -= iCount;

	//- if namespaced

	if (IdinIsNamespaced(pidin))
	{
	    //- print namespace operator

	    iCount
		= snprintf
		    (&pc[iIndex],iSize,"%s",IDENTIFIER_NAMESPACE_STRING);
	    iIndex += iCount;
	    iSize -= iCount;
	}

	bFirst = FALSE;
    }

    //- if remaining entries

    if (i - 1 < PidinStackNumberOfEntries(ppist))
    {
	//- get current entry

	struct symtab_IdentifierIndex *pidin
	    = PidinStackElementPidin(ppist,i - 1);

	//- print seperator if necessary

	if (!bFirst)
	{
	    if (IdinIsField(pidin))
	    {
		iCount
		    = snprintf
			(&pc[iIndex],iSize,"%s",IDENTIFIER_DEREFERENCE_STRING);
		iIndex += iCount;
		iSize -= iCount;
	    }
	    else
	    {
		iCount
		    = snprintf
			(&pc[iIndex],iSize,"%s",IDENTIFIER_CHILD_STRING);
		iIndex += iCount;
		iSize -= iCount;
	    }
	}

	//- print current entry

	iCount = snprintf(&pc[iIndex],iSize,"%s",IdinName(pidin));
	iIndex += iCount;
	iSize -= iCount;

	//- if namespaced

	if (IdinIsNamespaced(pidin))
	{
	    //- print namespace operator

	    iCount
		= snprintf
		    (&pc[iIndex],iSize,"%s",IDENTIFIER_NAMESPACE_STRING);
	    iIndex += iCount;
	    iSize -= iCount;
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackToPidinQueue()
///
/// ARGS.:
///
///	ppist.: pidin stack to convert.
///
/// RTN..: struct symtab_IdentifierIndex *
///
///	NULL terminated pidin queue, NULL for failure.
///
/// DESCR: Convert a context to a pidin queue.
///
/// NOTE.:
///
///	A pidinQueue is allocated as one block, and must be freed as
///	one block.
///
/// TODO.:
///
///	No difference is made between an rooted empty context and a
///	conversion failure (should return a pidin with the root flag set).
///
/// **************************************************************************

struct symtab_IdentifierIndex *
PidinStackToPidinQueue(struct PidinStack *ppist)
{
    //- set default result: failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- allocate entries

    //! note that a pidinQueue is allocated as one block

    pidinResult
	= (
	    (struct symtab_IdentifierIndex *)
	    calloc(PidinStackNumberOfEntries(ppist),
		   sizeof(struct symtab_IdentifierIndex))
	    );

    if (!pidinResult)
    {
	return(NULL);
    }

    //- loop over all pidins

    int i;

    for (i = 0 ; i < PidinStackNumberOfEntries(ppist) ; i++)
    {
	//- duplicate current entry

	struct symtab_IdentifierIndex *pidin
	    = PidinStackElementPidin(ppist, i);

	pidinResult[ i ] = *pidin;

	//- correct links

	pidinResult[ i ].pidinRoot = pidinResult;

	if (i + 1 < PidinStackNumberOfEntries(ppist))
	{
	    pidinResult[ i ].pidinNext = &pidinResult[ i + 1 ];
	}
    }

    //- correct last link: is NULL

    pidinResult[ i - 1 ].pidinNext = NULL;

    //- correct for rooted stacks

    if (PidinStackIsRooted(ppist))
    {
	IdinSetRooted(&pidinResult[0]);
    }

    //- return result

    return(pidinResult);
}


/// **************************************************************************
///
/// SHORT: PidinStackTo_stdout()
///
/// ARGS.:
///
///	ppist.: pidin stack to print.
///
/// RTN..: void
///
/// DESCR: Print pidin stack to stdout.
///
/// **************************************************************************

void PidinStackTo_stdout(struct PidinStack *ppist)
{
    PidinStackPrint(ppist, stdout);

    fprintf(stdout, "\n");
}


