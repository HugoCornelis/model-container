//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pidinstack.h 1.48 Mon, 08 Oct 2007 22:55:25 -0500 hugo $
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


/*
** pidin stack support routines
*/

#ifndef PIDINSTACK_H
#define PIDINSTACK_H


/// \def If following two are combined, the #define PIDINSTACK_SMART_CACHE
/// \def is defined, which gives a good implementation (and is the only one
/// \def available at the time of this writing).

/// \def have serials associated with a pidin stack

#define USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE


/// \def have a cache of symbol references to do fast lookups

#define USE_PIDINSTACK_WITH_SYMBOL_CACHE


#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

/* #pragma nooptimize */

struct PidinStack;


#include "idin.h"
#include "namespace.h"
#include "psymbolstack.h"
#include "psymbolserialstack.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

#ifndef USE_PIDINSTACK_WITH_SYMBOL_CACHE

#warning "You can only use USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE" \
 " in combination with USE_PIDINSTACK_WITH_SYMBOL_CACHE\n" \
 " deactivating USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE\n"

#undef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

#endif

#endif


#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

#ifndef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

#warning "You can only use USE_PIDINSTACK_WITH_SYMBOL_CACHE" \
 " in combination with USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE\n" \
 " deactivating USE_PIDINSTACK_WITH_SYMBOL_CACHE\n"

#undef USE_PIDINSTACK_WITH_SYMBOL_CACHE

#endif

#endif

#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE
#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

#define PIDINSTACK_SMART_CACHE

#endif
#endif


struct PidinStack
{
    /// stack top

    int iTop;

    /// flags

    int iFlags;

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

#ifndef USE_PIDINSTACK_WITH_SYMBOL_CACHE

    /// \note these are the same as for the symbol serial stack
    /// \note use that in place of these hardcoded ones.

    /// serial index in principal space,
    /// should be summation of serial indexes of symbols pointed to
    /// by ->ppidin[], pointed to by symbol stack cache (->symst).
    /// 
    /// value of INT_MAX means serial is unknown, but that should in fact
    /// only happen after initialization of the pidin stack.

    int iPrincipalSerial;

    /// number of entries in ->ppidin[] that contribute to principal serial
    /// same use as ->iTop, -1 means no entries in use.

    int iPrincipalEntries;

#endif

#endif

    /// array of stacked pidins
    ///
    /// silent assumption :
    ///
    /// always pointers to other's data
    /// never privately allocated, should never be freed
    ///

    struct symtab_IdentifierIndex *ppidin[MAX_ELEMENT_DEPTH];

#ifdef USE_PIDINSTACK_WITH_SYMBOL_CACHE

#ifdef USE_PIDINSTACK_WITH_SERIAL_INDEX_CACHE

    /// private symbol cache with serial support if possible

    /// \note prefered to the one below

    struct PSymbolSerialStack symsst;

#else

    /// private symbol cache if possible

    /// \note if change to pointer : modify accordingly
    /// \note     PidinStackDuplicate()
    /// \note     PidinStackAppendCompact()
    /// \note     PidinStackFree()
    /// \note and copy operation in various place,
    /// \note look for them with something like
    /// \note     'grep "=.*\*p\?pist" *.[ch]'

    struct PSymbolStack symst;

#endif

#endif

};


/// \def rooted pidin stack

#define FLAG_PIST_ROOTED		1


/* /// \def pidinstack with valid symbol stack cache */

/* #define FLAG_PIST_SYMBOLSTACK_CACHE	2 */


#include "parameters.h"
//#include "symbols.h"


int PidinStackAppend
(struct PidinStack *ppistTarget, struct PidinStack *ppistSource);

int
PidinStackAppendCompact
(struct PidinStack *ppistTarget, struct PidinStack *ppistSource);

struct PidinStack * PidinStackCalloc(void);

int PidinStackEqual
(struct PidinStack *ppist1, struct PidinStack *ppist2);

void PidinStackInit(struct PidinStack *ppist);

int PidinStackIsWildcard(struct PidinStack *ppist);

struct symtab_HSolveListElement *
PidinStackLookupBaseSymbol(struct PidinStack *ppist);

struct symtab_HSolveListElement *
PidinStackLookupTopSymbol(struct PidinStack *ppist);

int PidinStackMatch(struct PidinStack *ppist1, struct PidinStack *ppist2);

struct PidinStack *
PidinStackNewFromParameterSymbols(struct symtab_Parameters *ppar);

/* struct PidinStack * */
/* PidinStackNewFromPidins(struct symtab_IdentifierIndex *pidin); */

/* struct PidinStack * */
/* PidinStackNewFromPSymbolStack(struct PSymbolStack *psymst); */

struct PidinStack *PidinStackParse(char *pc);

struct symtab_IdentifierIndex * PidinStackPop(struct PidinStack *ppist);

void PidinStackPrint(struct PidinStack *ppist, FILE *pfile);

int PidinStackPush
(struct PidinStack *ppist, struct symtab_IdentifierIndex *pidinName);

int PidinStackPushAll
(struct PidinStack *ppist, struct symtab_IdentifierIndex *pidinName);

int PidinStackPushCompact
(struct PidinStack *ppist, struct symtab_IdentifierIndex *pidin);

int PidinStackPushCompactAll
(struct PidinStack *ppist, struct symtab_IdentifierIndex *pidin);

int PidinStackPushString(struct PidinStack *ppist, char *pc);

struct symtab_HSolveListElement *
PidinStackPushStringAndLookup(struct PidinStack *ppist, char *pc);

int PidinStackPushSymbol
(struct PidinStack *ppist, struct symtab_HSolveListElement *phsle);

int PidinStackString(struct PidinStack *ppist, char *pc, int iSize);

struct PidinStack *
PidinStackSubtract(struct PidinStack *ppist1, struct PidinStack *ppist2);

struct symtab_IdentifierIndex *
PidinStackToPidinQueue(struct PidinStack *ppist);

void PidinStackTo_stdout(struct PidinStack *ppist);



#ifndef SWIG
static inline 
#endif
void PidinStackClearFlag(struct PidinStack *ppist, int iFlags);

#ifndef SWIG
static inline 
#endif
void PidinStackClearRooted(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
void PidinStackCompress(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
struct PidinStack *
PidinStackDuplicate(struct PidinStack *ppist);

#ifndef SWIG
static inline 
#endif
struct symtab_IdentifierIndex *
PidinStackElementPidin(struct PidinStack *ppist, int i);

#ifndef SWIG
static inline
#endif
int
PidinStackFree(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
int
PidinStackGetFlag(struct PidinStack *ppist, int iF);

#ifndef SWIG
static inline 
#endif
int
PidinStackIsNamespaced(struct PidinStack *ppist);

#ifndef SWIG
static inline 
#endif
int
PidinStackIsRooted(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
int PidinStackNumberOfEntries(struct PidinStack *ppist);

#ifndef SWIG
static inline 
#endif
void PidinStackSetFlag(struct PidinStack *ppist, int iFlags);

#ifndef SWIG
static inline
#endif
void PidinStackSetRooted(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
PidinStackTop(struct PidinStack *ppist);


#ifndef SWIG
static inline
#endif
int PidinStackToSerial(struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
int PidinStackUpdateCaches(struct PidinStack *ppist);


#include "symbolvirtual_protos.h"


/// 
/// clear flags
/// 

#ifndef SWIG
static inline
#endif
void PidinStackClearFlag(struct PidinStack *ppist, int iFlags)
{
    //- clear flags

    ppist->iFlags &= ~iFlags;
}


/// 
/// register pidin stack is not rooted
/// 

#ifndef SWIG
static inline
#endif
void PidinStackClearRooted(struct PidinStack *ppist)
{
#ifdef PIDINSTACK_SMART_CACHE

    //- clear rooted for symbol cache

    PSymbolSerialStackClearRooted(&ppist->symsst);

#endif

    //- clear rooted flag

    PidinStackClearFlag(ppist, FLAG_PIST_ROOTED);
}


/// 
/// compress pidin stack
/// 

#ifndef SWIG
static inline
#endif
void PidinStackCompress(struct PidinStack *ppist)
{
    int i;
    int iEntries = PidinStackNumberOfEntries(ppist);

    //- if there is nothing to compress

    if (ppist->iTop < 0)
    {
	//- just return

	return;
    }

    //- reset top to first element

    ppist->iTop = 0;

#ifdef PIDINSTACK_SMART_CACHE

    //- clear symbol cache

    PSymbolSerialStackInit(&ppist->symsst);

#endif

    //- push & compact all but first entry

    for (i = 1 ; i < iEntries ; i++)
    {
	PidinStackPushCompact(ppist, ppist->ppidin[i]);
    }
}


/// 
/// duplicate pidin stack
/// 

#ifndef SWIG
static inline
#endif
struct PidinStack *
PidinStackDuplicate(struct PidinStack *ppist)
{
    struct PidinStack *pidinResult = PidinStackCalloc();

    if (pidinResult)
    {
	*pidinResult = *ppist;
    }

    return(pidinResult);
}


/// 
/// get element at given place
/// 

#ifndef SWIG
static inline 
#endif
struct symtab_IdentifierIndex *
PidinStackElementPidin(struct PidinStack *ppist, int i)
{
    struct symtab_IdentifierIndex *pidinResult = NULL;

    if (ppist->iTop >= i)
    {
	pidinResult = ppist->ppidin[i];
    }

    return(pidinResult);
}


/// 
/// free pidin stack
/// 

#ifndef SWIG
static inline 
#endif
int
PidinStackFree(struct PidinStack *ppist)
{
    free(ppist);

    return(1);
}


/// 
/// get flag
/// 

#ifndef SWIG
static inline
#endif
int
PidinStackGetFlag(struct PidinStack *ppist, int iF)
{
    return(ppist->iFlags & iF);
}


/// 
/// check if a pidin stack is namespaced
/// 

#ifndef SWIG
static inline 
#endif
int
PidinStackIsNamespaced(struct PidinStack *ppist)
{
    struct symtab_IdentifierIndex *pidin = PidinStackElementPidin(ppist, 0);

    return(IdinIsNamespaced(pidin));
}


/// 
/// check if pidin stack is rooted
/// 

#ifndef SWIG
static inline 
#endif
int
PidinStackIsRooted(struct PidinStack *ppist)
{
    return(PidinStackGetFlag(ppist, FLAG_PIST_ROOTED));
}


/// 
/// get number of entries in pidin stack
/// 

#ifndef SWIG
static inline
#endif
int PidinStackNumberOfEntries(struct PidinStack *ppist)
{
    return(ppist->iTop + 1);
}


/// 
/// set flag
/// 

#ifndef SWIG
static inline 
#endif
void PidinStackSetFlag(struct PidinStack *ppist, int iFlags)
{
    //- set flags

    ppist->iFlags |= iFlags;
}


/// 
/// register pidin stack is rooted
/// 

#ifndef SWIG
static inline
#endif
void PidinStackSetRooted(struct PidinStack *ppist)
{
#ifdef PIDINSTACK_SMART_CACHE

    //- set rooted for symbol cache

    PSymbolSerialStackSetRooted(&ppist->symsst);

#endif

    //- set flag

    PidinStackSetFlag((ppist), FLAG_PIST_ROOTED);
}


/// 
/// get topmost element
/// 

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
PidinStackTop(struct PidinStack *ppist)
{
    return(PidinStackElementPidin(ppist, ppist->iTop));
}


/// 
/// convert pidin stack to corresponding serial id
/// 

#ifndef SWIG
static inline
#endif
int PidinStackToSerial(struct PidinStack *ppist)
{
    //- set default result : failure

    int iResult = INT_MAX;

#ifdef PIDINSTACK_SMART_CACHE

    //- initialize principal : zero

    int iPrincipal = 0;

    //- loop over symbols

    int i;

    for (i = 0 ; i < PidinStackNumberOfEntries(ppist) ; i++)
    {
	//- get current symbol

	struct symtab_HSolveListElement *phsle
	    = PSymbolSerialStackElementSymbol(&ppist->symsst, i);

	if (phsle)
	{
	    //- get principal serial

	    int iSymbol = SymbolGetPrincipalSerialToParent(phsle);

	    //- add to result

	    iPrincipal += iSymbol;
	}

	//- else

	else
	{
	    return(INT_MAX);
	}
    }

    //- set result : principal serial

    iResult = iPrincipal;

#endif

    //- return result

    return(iResult);
}


/// 
/// update caches for given context
/// 

#ifndef SWIG
static inline
#endif
int PidinStackUpdateCaches(struct PidinStack *ppist)
{
    //- set default result : failure

    int bResult = FALSE;

#ifdef PIDINSTACK_SMART_CACHE

    int i = 0;

    int iCached;

    int iEntries;

    //- get uppermost cached symbol

    struct symtab_HSolveListElement *phsle
	= PSymbolSerialStackTop(&ppist->symsst);

    //- if no base symbol

    if (!phsle

	//- but the pidinstack is rooted

	&& PidinStackIsRooted(ppist))
    {
	/// \todo this looks like to much overhead

	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	PidinStackFree(ppistRoot);

	//- use root as base symbol

	phsle = phsleRoot;
    }

    //- if no base symbol

    if (!phsle)
    {
	//- return failure

	return(FALSE);
    }

    //- get number of entries in cache

    iCached = PSymbolSerialStackNumberOfEntries(&ppist->symsst);

    //- get number of entries in context

    iEntries = PidinStackNumberOfEntries(ppist);

    //- set result : ok

    bResult = TRUE;

    //- loop over non-cached entries

    for (i = iCached ; phsle && i < iEntries ; i++)
    {
	//- lookup next symbol

	phsle = SymbolLookupHierarchical(phsle, ppist, i, FALSE);

	if (!phsle)
	{
	    //- set result : failure

	    bResult = FALSE;

	    //- break searching loop

	    break;
	}

	//- push next entry onto cache

	PSymbolSerialStackPush(&ppist->symsst, phsle);
    }

#endif

    //- return result

    return(bResult);
}


#undef PIDINSTACK_SMART_CACHE


/* #pragma optimize */


#endif


