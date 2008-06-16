//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: psymbolserialstack.h 1.8 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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
** symbol stack with serial support
*/

#ifndef PSYMBOLSERIALSTACK_H
#define PSYMBOLSERIALSTACK_H


#include "psymbolstack.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


struct PSymbolSerialStack
{
    //m base : symbol stack

    struct PSymbolStack symst;

    //m serial index in principal space,
    //m should be summation of serial indexes of symbols pointed to
    //m by ->ppidin[], pointed to by symbol stack (->symst).
    //m 
    //m value of INT_MAX means serial is unknown, but that should in fact
    //m only happen after initialization of the pidin stack.

    int iPrincipalSerial;

    //m 0 means no entries of symbol stack contribute to serial mapping
    //m == PSymbolStackNumberOfEntries() after init
    //m == PSymbolStackNumberOfEntries() is valid test for serial mapping
    //m     in sync with symbol stack

    int iPrincipalEntries;
};


//f static inline prototypes

static inline 
struct symtab_HSolveListElement *
PSymbolSerialStackBase(struct PSymbolSerialStack *psymsst);

static inline
int PSymbolSerialStackCachedEntries(struct PSymbolSerialStack *psymsst);

static inline
int PSymbolSerialStackCachedSerial(struct PSymbolSerialStack *psymsst);

static inline
void PSymbolSerialStackClearRooted(struct PSymbolSerialStack *psymsst);

static inline
struct symtab_HSolveListElement *
PSymbolSerialStackElementSymbol(struct PSymbolSerialStack *psymsst,int i);

static inline int 
PSymbolSerialStackNumberOfEntries(struct PSymbolSerialStack *psymsst);

static inline 
void PSymbolSerialStackSetRooted(struct PSymbolSerialStack *psymsst);

static inline 
struct symtab_HSolveListElement *
PSymbolSerialStackTop(struct PSymbolSerialStack *psymsst);


///
/// get base element
///

static inline 
struct symtab_HSolveListElement *
PSymbolSerialStackBase(struct PSymbolSerialStack *psymsst)
{
    //- return active symbol from base struct

    return(PSymbolStackBase(&psymsst->symst));
}


///
/// get cached number of entries
///

static inline
int PSymbolSerialStackCachedEntries(struct PSymbolSerialStack *psymsst)
{
    //- set result : cached principal serial

    return(psymsst->iPrincipalSerial);
}


///
/// get cached principal serial
///

static inline
int PSymbolSerialStackCachedSerial(struct PSymbolSerialStack *psymsst)
{
    //- set result : cached principal serial

    return(psymsst->iPrincipalSerial);
}


///
/// register symbol serial stack is not rooted
///

static inline
void PSymbolSerialStackClearRooted(struct PSymbolSerialStack *psymsst)
{
    //- set result : from base struct

    PSymbolStackClearRooted(&psymsst->symst);
}


///
/// get element at given place
///

static inline
struct symtab_HSolveListElement *
PSymbolSerialStackElementSymbol(struct PSymbolSerialStack *psymsst,int i)
{
    //- set default result : from base struct

    struct symtab_HSolveListElement *phsleResult
	= PSymbolStackElementSymbol(&psymsst->symst,i);

    //- return result

    return(phsleResult);
}


///
/// get number of entries in symbol serial stack
///

static inline
int PSymbolSerialStackNumberOfEntries(struct PSymbolSerialStack *psymsst)
{
    //- return : from base struct

    return(PSymbolStackNumberOfEntries(&psymsst->symst));
}


///
/// register symbol serial stack is rooted
///

static inline 
void PSymbolSerialStackSetRooted(struct PSymbolSerialStack *psymsst)
{
    //- set rooted for base struct

    PSymbolStackSetRooted(&psymsst->symst);
}


///
/// get topmost element
///

static inline 
struct symtab_HSolveListElement *
PSymbolSerialStackTop(struct PSymbolSerialStack *psymsst)
{
    //- return active symbol from base struct

    return(PSymbolStackTop(&psymsst->symst));
}


//d
//d free given symbol serial stack
//d

#define PSymbolSerialStackFree(psymsst)					\
do {									\
    free(psymsst);							\
    psymsst = NULL;							\
} while (0)


#include "pidinstack.h"
#include "symboltable.h"


struct PSymbolSerialStack * PSymbolSerialStackCalloc(void);

void PSymbolSerialStackInit(struct PSymbolSerialStack *psymsst);

struct symtab_HSolveListElement * 
PSymbolSerialStackPop
(struct PSymbolSerialStack *psymsst);

int PSymbolSerialStackPush
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle);


#endif


