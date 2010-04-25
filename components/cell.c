//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cell.c 1.78 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/components/attachment.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"



/// 
/// \return struct symtab_Cell * 
/// 
///	Newly allocated cell, NULL for failure
/// 
/// \brief Allocate a new cell symbol table element
/// 

struct symtab_Cell * CellCalloc(void)
{
    //- set default result : failure

    struct symtab_Cell *pcellResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/cell_vtable.c"

    //- allocate cell

    pcellResult
	= (struct symtab_Cell *)
	  SymbolCalloc(1, sizeof(struct symtab_Cell), _vtable_cell, HIERARCHY_TYPE_symbols_cell);

    //- initialize cell

    CellInit(pcellResult);

    //- return result

    return(pcellResult);
}


/// 
/// \arg pcell symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
CellCreateAlias
(struct symtab_Cell *pcell,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Cell *pcellResult = CellCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pcellResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pcellResult->segr.bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pcellResult->segr.bio.ioh.iol.hsle, &pcell->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_cell);

    //- return result

    return(&pcellResult->segr.bio.ioh.iol.hsle);
}


/// 
/// \arg pcell cell to init
/// 
/// \return void
/// 
/// \brief init cell
/// 

void CellInit(struct symtab_Cell *pcell)
{
    //- initialize base symbol

    SegmenterInit(&pcell->segr);

    //- set type

    pcell->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_cell;
}


/// 
/// \arg dx X coordinate
/// \arg dy Y coordinate
/// \arg dz Z coordinate
/// 
/// \return struct symtab_Cell * : resulting cell, NULL for failure
/// 
/// \brief Allocate cell, put at specified position.
///
/// \details 
/// 
///	Contains memory leak.
/// 

struct symtab_Cell * CellNewAtXYZ(double dx, double dy, double dz)
{
    //- set result : new cell

    struct symtab_Cell *pcellResult 
	= CellCalloc();

    //- put at position

    if (!BioComponentSetAtXYZ(&pcellResult->segr.bio, dx, dy, dz, 0))
    {
	return(NULL);
    }

    //- return result

    return(pcellResult);
}


