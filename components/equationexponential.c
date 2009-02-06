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


#include "neurospaces/components/equationexponential.h"
#include "neurospaces/idin.h"


/// 
/// \return struct symtab_EquationExponential * 
/// 
///	Newly allocated equation, NULL for failure
/// 
/// \brief Allocate a new equation symbol table element
/// 

struct symtab_EquationExponential * EquationExponentialCalloc(void)
{
    //- set default result : failure

    struct symtab_EquationExponential *peqeResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/equation_exponential_vtable.c"

    //- allocate equation

    peqeResult
	= (struct symtab_EquationExponential *)
	  SymbolCalloc(1, sizeof(struct symtab_EquationExponential), _vtable_equation_exponential, HIERARCHY_TYPE_symbols_equation_exponential);

    //- init equation

    EquationExponentialInit(peqeResult);

    //- set type

    peqeResult->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_equation_exponential;

    //- return result

    return(peqeResult);
}


/// 
/// \arg peqe symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
EquationExponentialCreateAlias
(struct symtab_EquationExponential *peqe,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_EquationExponential *peqeResult = EquationExponentialCalloc();

    //- set name and prototype

    SymbolSetName(&peqeResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&peqeResult->bio.ioh.iol.hsle, &peqe->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_equation_exponential);

    //- return result

    return(&peqeResult->bio.ioh.iol.hsle);
}


/* ///  */
/* /// \arg peqe equation to init */
/* ///  */
/* /// \return int : type of equation (incoming, outgoing). */
/* ///  */
/* /// \brief Get type of equation. */
/* ///  */

/* int EquationExponentialGetType(struct symtab_EquationExponential *peqe) */
/* { */
/*     return(peqe->deeq.iType); */
/* } */


/// 
/// \arg peqe equation to init
/// 
/// \return void
/// 
/// \brief Init equation
/// 

void EquationExponentialInit(struct symtab_EquationExponential * peqe)
{
    //- initialize base symbol

    BioComponentInit(&peqe->bio);

    //- zero out own fields

    memset(&(&peqe->bio)[1],0,sizeof(*peqe) - sizeof(peqe->bio));

/*     //- set type: exponential */

/*     SymbolSetType(&peqe->bio.ioh.iol.hsle, TYPE_EQUATION_EXPONENTIAL); */
}


/* ///  */
/* /// \arg peqe equation to set type for. */
/* /// \arg iType type of equation. */
/* ///  */
/* /// \return int : success of operation. */
/* ///  */
/* /// \brief Set type of equation. */
/* ///  */

/* int EquationExponentialSetType(struct symtab_EquationExponential *peqe, int iType) */
/* { */
/*     //- set type, return success. */

/*     int iResult = TRUE; */

/*     peqe->deeq.iType = iType; */

/*     return(iResult); */
/* } */


