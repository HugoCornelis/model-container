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
    /// base : symbol stack

    struct PSymbolStack symst;

    /// serial index in principal space,
    /// should be summation of serial indexes of symbols pointed to
    /// by ->ppidin[], pointed to by symbol stack (->symst).
    /// 
    /// value of INT_MAX means serial is unknown, but that should in fact
    /// only happen after initialization of the pidin stack.

    int iPrincipalSerial;

    /// 0 means no entries of symbol stack contribute to serial mapping
    /// == PSymbolStackNumberOfEntries() after init
    /// == PSymbolStackNumberOfEntries() is valid test for serial mapping
    ///     in sync with symbol stack

    int iPrincipalEntries;
};



#include "pidinstack.h"
#include "symboltable.h"


struct symtab_HSolveListElement *
PSymbolSerialStackBase(struct PSymbolSerialStack *psymsst);

int PSymbolSerialStackCachedEntries(struct PSymbolSerialStack *psymsst);

int PSymbolSerialStackCachedSerial(struct PSymbolSerialStack *psymsst);

struct PSymbolSerialStack * PSymbolSerialStackCalloc(void);

int PSymbolSerialStackClearRooted(struct PSymbolSerialStack *psymsst);

struct symtab_HSolveListElement *
PSymbolSerialStackElementSymbol(struct PSymbolSerialStack *psymsst,int i);

int PSymbolSerialStackInit(struct PSymbolSerialStack *psymsst);

int 
PSymbolSerialStackNumberOfEntries(struct PSymbolSerialStack *psymsst);

struct symtab_HSolveListElement * 
PSymbolSerialStackPop
(struct PSymbolSerialStack *psymsst);

int PSymbolSerialStackPush
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle);

int PSymbolSerialStackSetRooted(struct PSymbolSerialStack *psymsst);

struct symtab_HSolveListElement *
PSymbolSerialStackTop(struct PSymbolSerialStack *psymsst);


#endif


