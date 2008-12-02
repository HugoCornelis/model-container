//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: equation.c 1.31 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <stdlib.h>
#include <string.h>


#include "neurospaces/components/equation.h"
#include "neurospaces/idin.h"


/// 
/// 
/// \return struct symtab_Equation * 
/// 
///	Newly allocated equation, NULL for failure
/// 
/// \brief Allocate a new equation symbol table element
/// \details 
/// 

struct symtab_Equation * EquationCalloc(void)
{
    //- set default result : failure

    struct symtab_Equation *peqResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/equation_vtable.c"

    //- allocate equation

    peqResult
	= (struct symtab_Equation *)
	  SymbolCalloc(1, sizeof(struct symtab_Equation), _vtable_equation, HIERARCHY_TYPE_symbols_equation);

    //- init equation

    EquationInit(peqResult);

    //- set type

    peqResult->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_equation;

    //- return result

    return(peqResult);
}


/// 
/// 
/// \arg peq symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
EquationCreateAlias
(struct symtab_Equation *peq,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Equation *peqResult = EquationCalloc();

    //- set name and prototype

    SymbolSetName(&peqResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&peqResult->bio.ioh.iol.hsle, &peq->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_equation);

    //- return result

    return(&peqResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg peq equation to init
/// 
/// \return int : type of equation (incoming, outgoing).
/// 
/// \brief Get type of equation.
/// \details 
/// 

int EquationGetType(struct symtab_Equation *peq)
{
    return(peq->deeq.iType);
}


/// 
/// 
/// \arg peq equation to init
/// 
/// \return void
/// 
/// \brief Init equation
/// \details 
/// 

void EquationInit(struct symtab_Equation * peq)
{
    //- initialize base symbol

    BioComponentInit(&peq->bio);

    //- zero out own fields

    memset(&(&peq->bio)[1],0,sizeof(*peq) - sizeof(peq->bio));
}


/// 
/// 
/// \arg peq equation to set type for.
/// \arg iType type of equation.
/// 
/// \return int : success of operation.
/// 
/// \brief Set type of equation.
/// \details 
/// 

int EquationSetType(struct symtab_Equation *peq, int iType)
{
    //- set type, return success.

    int iResult = TRUE;

    peq->deeq.iType = iType;

    return(iResult);
}


