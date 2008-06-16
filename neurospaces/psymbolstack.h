//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: psymbolstack.h 1.19 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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
** symbol stack support routines
*/

#ifndef PSYMBOLSTACK_H
#define PSYMBOLSTACK_H


#include "idin.h"
#include "namespace.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


struct PSymbolStack
{
    //m stack top

    int iTop;

    //m flags

    int iFlags;

    //m array of stacked symbols

    struct symtab_HSolveListElement *pphsle[MAX_ELEMENT_DEPTH];
};


//d rooted symbol stack

#define FLAG_SYMST_ROOTED		1


//f static inline prototypes

static inline
struct symtab_HSolveListElement *
PSymbolStackBase(struct PSymbolStack *psymst);

static inline 
void PSymbolStackClearFlags(struct PSymbolStack *psymst,int iFlags);

static inline 
void PSymbolStackClearRooted(struct PSymbolStack *psymst);

static inline
struct symtab_HSolveListElement *
PSymbolStackElementSymbol(struct PSymbolStack *psymst, int i);


///
/// get base element
///

static inline
struct symtab_HSolveListElement *
PSymbolStackBase(struct PSymbolStack *psymst)
{
    return PSymbolStackElementSymbol(psymst, 0);
}


///
/// register symbol stack is not rooted
///

static inline 
void PSymbolStackClearFlags(struct PSymbolStack *psymst,int iFlags)
{
    //- clear flags

    psymst->iFlags &= ~iFlags;
}


///
/// register symbol stack is not rooted
///

static inline 
void PSymbolStackClearRooted(struct PSymbolStack *psymst)
{
    //- clear rooted flag

    PSymbolStackClearFlags(psymst,FLAG_SYMST_ROOTED);
}


///
/// get element at given place
///

static inline
struct symtab_HSolveListElement *
PSymbolStackElementSymbol(struct PSymbolStack *psymst, int i)
{
    struct symtab_HSolveListElement *phsleResult = NULL;

    if (psymst->iTop != -1
	&& psymst->iTop >= i)
    {
	phsleResult = psymst->pphsle[i];
    }
    else
    {
	phsleResult = NULL;
    }

    return(phsleResult);
}


//d
//d test type(psymst) == struct PSymbolStack * at compile time
//d

#define CompileTimeTestPSymbolStack(psymst)				\
do {									\
    struct PSymbolStack symst;						\
    (psymst) == &symst;							\
} while (0)


//d
//d append two symbol stacks, flags unaffected, no compaction
//d

#define PSymbolStackAppend(psymstTarget,psymstSource)			\
({									\
    int i;								\
    CompileTimeTestPSymbolStack(psymstTarget);				\
    CompileTimeTestPSymbolStack(psymstSource);				\
    for (i = 0; i <= (psymstSource)->iTop; i++)				\
    {									\
	PSymbolStackPush						\
	    ((psymstTarget),						\
	     (psymstSource)->pphsle[i]);				\
    }									\
    1;									\
})


//d
//d free given symbol stack
//d

#define PSymbolStackFree(psymst)					\
do {									\
    free(psymst);							\
    psymst = NULL;							\
} while (0)


//d
//d duplicate symbol stack
//d

#define PSymbolStackDuplicate(psymst)					\
({									\
    struct PSymbolStack *psymstResult = NULL;				\
    CompileTimeTestPSymbolStack(psymst);				\
    psymstResult = PSymbolStackCalloc();				\
    if (psymstResult)							\
    {									\
	*psymstResult = *(psymst);					\
    }									\
    psymstResult;							\
})


//d
//d get number of entries in symbol stack
//d

#define PSymbolStackNumberOfEntries(psymst)				\
({									\
    CompileTimeTestPSymbolStack(psymst);				\
    (psymst)->iTop + 1;							\
})


//d
//d register symbol stack is rooted
//d

#define PSymbolStackSetRooted(psymst)					\
do {									\
    CompileTimeTestPSymbolStack(psymst);				\
    (psymst)->iFlags |= FLAG_SYMST_ROOTED;				\
} while (0)


//d
//d check if symbol stack is rooted
//d

#define PSymbolStackIsRooted(psymst)					\
({									\
    CompileTimeTestPSymbolStack(psymst);				\
    (psymst)->iFlags & FLAG_SYMST_ROOTED != 0;				\
})


//d
//d get topmost element
//d

#define PSymbolStackTop(psymst)						\
({									\
    CompileTimeTestPSymbolStack(psymst);				\
    PSymbolStackElementSymbol((psymst),(psymst)->iTop);			\
})


#include "pidinstack.h"
#include "symboltable.h"


struct PSymbolStack * PSymbolStackCalloc(void);

void PSymbolStackInit(struct PSymbolStack *psymst);

struct PSymbolStack * 
PSymbolStackNewFromPidinStack(struct PidinStack *ppist);

struct symtab_HSolveListElement * PSymbolStackPop(struct PSymbolStack *psymst);

int PSymbolStackPush
(struct PSymbolStack *psymst,struct symtab_HSolveListElement *phsle);


#endif


