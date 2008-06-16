//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorconnectionsymbol.c 1.25 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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



#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#include "neurospaces/idin.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/vectorconnectionsymbol.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: VConnectionSymbolCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_VConnection * 
///
///	Newly allocated connection vector, NULL for failure
///
/// DESCR: Allocate a new connection vector symbol table element
///
/// **************************************************************************

struct symtab_VConnectionSymbol * VConnectionSymbolCalloc(void)
{
    //- set default result : failure

    struct symtab_VConnectionSymbol *pvconsyResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/v_connection_symbol_vtable.c"

    //- allocate connection vector

    pvconsyResult
	= (struct symtab_VConnectionSymbol *)
	  SymbolCalloc(1, sizeof(struct symtab_VConnectionSymbol), _vtable_v_connection_symbol, HIERARCHY_TYPE_symbols_v_connection_symbol);

    //- initialize connection vector

    VConnectionSymbolInit(pvconsyResult);

    //- return result

    return(pvconsyResult);
}


/// **************************************************************************
///
/// SHORT: VConnectionSymbolCreateAlias()
///
/// ARGS.:
///
///	pvconsy.: symbol vector to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
VConnectionSymbolCreateAlias
(struct symtab_VConnectionSymbol *pvconsy,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_VConnectionSymbol *pvconsyResult = VConnectionSymbolCalloc();

    //- set name and prototype

    SymbolSetName(&pvconsyResult->vect.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pvconsyResult->vect.bio.ioh.iol.hsle, &pvconsy->vect.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_v_connection_symbol);

    //- return result

    return(&pvconsyResult->vect.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: VConnectionSymbolInit()
///
/// ARGS.:
///
///	pvconsy.: connection vector to init
///
/// RTN..: void
///
/// DESCR: init connection vector
///
/// **************************************************************************

void VConnectionSymbolInit(struct symtab_VConnectionSymbol *pvconsy)
{
    //- initialize base symbol

    VectorInit(&pvconsy->vect);

    //- set type

    pvconsy->vect.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_v_connection_symbol;
}


