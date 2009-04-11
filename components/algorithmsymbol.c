//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmsymbol.c 1.11 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "neurospaces/components/algorithmsymbol.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \return struct symtab_AlgorithmSymbol * 
/// 
///	Newly allocated algorithm symbol, NULL for failure
/// 
/// \brief Allocate a new algorithm symbol symbol table element
/// 

struct symtab_AlgorithmSymbol *AlgorithmSymbolCalloc(void)
{
    //- set default result : failure

    struct symtab_AlgorithmSymbol *palgsResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/algorithm_symbol_vtable.c"

    //- allocate algorithm symbol

    palgsResult
	= (struct symtab_AlgorithmSymbol *)
	  SymbolCalloc(1, sizeof(struct symtab_AlgorithmSymbol), _vtable_algorithm_symbol, HIERARCHY_TYPE_symbols_algorithm_symbol);

    //- initialize algorithm symbol

    if (!AlgorithmSymbolInit(palgsResult))
    {
	/// \todo memory leak

	return(NULL);
    }

    //- return result

    return(palgsResult);
}


/// 
/// \arg palgs algorithm symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol.
/// 

struct symtab_HSolveListElement *
AlgorithmSymbolCreateAlias
(struct symtab_AlgorithmSymbol *palgs,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_AlgorithmSymbol *palgsResult = AlgorithmSymbolCalloc();

    //- set name and prototype

    SymbolSetName(&palgsResult->hsle, pidin);
    SymbolSetPrototype(&palgsResult->hsle, &palgs->hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_algorithm_symbol);

    //- return result

    return(&palgs->hsle);
}


/// 
/// \arg palgs algorithm symbol to init
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief init algorithm symbol
/// 

int
AlgorithmSymbolInit(struct symtab_AlgorithmSymbol *palgs)
{
    //- allocate parameter container

    palgs->pparc = ParContainerCalloc();

    //- set type

    palgs->hsle.iType = HIERARCHY_TYPE_symbols_algorithm_symbol;

    //- return result

    return(palgs->pparc != NULL);
}


/// 
/// \arg palgs algorithm symbol to init
/// \arg palgi algorithm instance
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief init algorithm symbol
/// 

int
AlgorithmSymbolSetAlgorithmInstance
(struct symtab_AlgorithmSymbol *palgs,
 struct AlgorithmInstance *palgi)
{
    //- allocate a name for use in the symbol table

    /// \todo perhaps should be just a reference to the name of palgi ?
    /// \todo Don't care actually.

    struct symtab_IdentifierIndex *pidin
	= IdinNewFromChars(AlgorithmInstanceGetName(palgi));

    palgs->dealgs.pidin = pidin;

    //- set algorithm instance

    palgs->dealgs.palgi = palgi;

    //- return result

    return(pidin != NULL);
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pconn symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse symbols in tree manner.
/// 
/// \note  See IOHierarchyTraverse()
/// 
///	Note that not all symbols are required to have a pidin.
///	Interfaces with Tstr{Prepare,Traverse,Repair}() :
/// 
///	Loops over children of top symbol
///		1. Calls TstrPrepare()
///		2. Calls TstrTraverse()
///		3. Calls TstrRepair()
/// 
///	Use Tstr.*() to obtain info on serial IDs and contexts
///	during traversals.
/// 

int
AlgorithmSymbolTraverse
(struct TreespaceTraversal *ptstr, struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : ok

    int iResult = 1;

    //- base algorithm symbols never have any children

    //- return result

    return(iResult);
}


