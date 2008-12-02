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


/// 
/// 
/// \return struct PSymbolSerialStack * 
/// 
///	Newly allocated symbol serial stack, NULL for failure
/// 
/// \brief Allocate a new symbol serial stack symbol table element
/// \details 
/// 

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


/// 
/// 
/// \arg psymsst symbol serial stack to clear
/// 
/// \return void
/// 
/// \brief Initialize a symbol serial stack
/// \details 
/// 

void PSymbolSerialStackInit(struct PSymbolSerialStack *psymsst)
{
    //- init base struct

    PSymbolStackInit(&psymsst->symst);

    //- reset serial addenda : points to this whatever that may be

    psymsst->iPrincipalSerial = 0;

    psymsst->iPrincipalEntries = PSymbolStackNumberOfEntries(&psymsst->symst);
}


/// 
/// 
/// \arg psymsst symbol serial stack to pop
/// 
/// \return struct symtab_HSolveListElement * 
/// 
///	popped symbol, NULL for failure
/// 
/// \brief Pop symbol from stack
/// \details 
/// 

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


/// 
/// 
/// \arg psymsst popped symbol serial stack
/// \arg phsle symbol that has been popped
/// 
/// \return void
/// 
/// \brief Repair a symbol serial stack that has been popped
/// \details 
/// 
///	Updates serial after popping phsle from psymsst.
///	Serial must be in sync with base struct (symbol stack).
/// 

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


/// 
/// 
/// \arg psymsst symbol serial stack to push onto
/// \arg phsle phsle to push
/// 
/// \return int : success of operation
/// 
/// \brief Push phsle onto stack
/// \details 
/// 

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


/// 
/// 
/// \arg psymsst symbol serial stack after push
/// \arg phsle symbol that has been pushed
/// 
/// \return void
/// 
/// \brief Repair a symbol serial stack that has been pushed on
/// \details 
/// 
///	Updates serial after pushing phsle onto psymsst.
///	Serial must be in sync with base struct (symbol stack).
/// 

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


