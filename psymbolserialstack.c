//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: psymbolserialstack.c 1.8 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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
//o Symbol serial stack intro :
//o ---------------------------
//o
//o See first symbol stacks intro.
//o 
//o Additional : some support for calculating serial indices.
//o
//////////////////////////////////////////////////////////////////////////////



#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/psymbolstack.h"
#include "neurospaces/symbols.h"


static inline void
PSymbolSerialStackPopped
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle);

static inline void
PSymbolSerialStackPushed
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle);


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackCalloc()
///
/// ARGS.:
///
/// RTN..: struct PSymbolSerialStack * 
///
///	Newly allocated symbol serial stack, NULL for failure
///
/// DESCR: Allocate a new symbol serial stack symbol table element
///
/// **************************************************************************

struct PSymbolSerialStack * PSymbolSerialStackCalloc(void)
{
    //- set default result : failure

    struct PSymbolSerialStack *psymsstResult = NULL;

    //- allocate symbol serial stack

    psymsstResult
	= (struct PSymbolSerialStack *)
	  calloc(1,sizeof(struct PSymbolSerialStack));

    //- initialize symbol serial stack

    PSymbolSerialStackInit(psymsstResult);

    //- return result

    return(psymsstResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackInit()
///
/// ARGS.:
///
///	psymsst.: symbol serial stack to clear
///
/// RTN..: void
///
/// DESCR: Initialize a symbol serial stack
///
/// **************************************************************************

void PSymbolSerialStackInit(struct PSymbolSerialStack *psymsst)
{
    //- init base struct

    PSymbolStackInit(&psymsst->symst);

    //- reset serial addenda : points to this whatever that may be

    psymsst->iPrincipalSerial = 0;

    psymsst->iPrincipalEntries = PSymbolStackNumberOfEntries(&psymsst->symst);
}


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackPop()
///
/// ARGS.:
///
///	psymsst.: symbol serial stack to pop
///
/// RTN..: struct symtab_HSolveListElement * 
///
///	popped symbol, NULL for failure
///
/// DESCR: Pop symbol from stack
///
/// **************************************************************************

struct symtab_HSolveListElement * 
PSymbolSerialStackPop(struct PSymbolSerialStack *psymsst)
{
    //- set default result : failure

    struct symtab_HSolveListElement * phsleResult = NULL;

    //- set result : from base struct

    phsleResult = PSymbolStackPop(&psymsst->symst);

    //- if success

    if (phsleResult)
    {
	//- if serial is in sync

	if (psymsst->iPrincipalEntries - 1
	    == PSymbolStackNumberOfEntries(&psymsst->symst))
	{
	    //- register popped symbol (adjust serials)

	    PSymbolSerialStackPopped(psymsst,phsleResult);
	}
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackPopped()
///
/// ARGS.:
///
///	psymsst.: popped symbol serial stack
///	phsle...: symbol that has been popped
///
/// RTN..: void
///
/// DESCR: Repair a symbol serial stack that has been popped
///
///	Updates serial after popping phsle from psymsst.
///	Serial must be in sync with base struct (symbol stack).
///
/// **************************************************************************

static inline void
PSymbolSerialStackPopped
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle)
{
    //- get principal-to-parent from symbol

    int iPrincipalSerial = SymbolGetPrincipalSerialToParent(phsle);

    //- subtract serials

    psymsst->iPrincipalSerial -= iPrincipalSerial;

    psymsst->iPrincipalEntries--;
}


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackPush()
///
/// ARGS.:
///
///	psymsst.: symbol serial stack to push onto
///	phsle...: phsle to push
///
/// RTN..: int : success of operation
///
/// DESCR: Push phsle onto stack
///
/// **************************************************************************

int
PSymbolSerialStackPush
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- set result : from base struct

    bResult = PSymbolStackPush(&psymsst->symst,phsle);

    //- if success

    if (bResult)
    {
	//- if serial is in sync

	if (psymsst->iPrincipalEntries + 1
	    == PSymbolStackNumberOfEntries(&psymsst->symst))
	{
	    //- register pushed symbol (adjust serials)

	    PSymbolSerialStackPushed(psymsst,phsle);
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: PSymbolSerialStackPushed()
///
/// ARGS.:
///
///	psymsst.: symbol serial stack after push
///	phsle...: symbol that has been pushed
///
/// RTN..: void
///
/// DESCR: Repair a symbol serial stack that has been pushed on
///
///	Updates serial after pushing phsle onto psymsst.
///	Serial must be in sync with base struct (symbol stack).
///
/// **************************************************************************

static inline void
PSymbolSerialStackPushed
(struct PSymbolSerialStack *psymsst,struct symtab_HSolveListElement *phsle)
{
    //- get principal-to-parent from symbol

    int iPrincipalSerial = SymbolGetPrincipalSerialToParent(phsle);

    //- add serials

    psymsst->iPrincipalSerial += iPrincipalSerial;

    psymsst->iPrincipalEntries++;
}


