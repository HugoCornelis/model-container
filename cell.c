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
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "neurospaces/attachment.h"
#include "neurospaces/biocomp.h"
#include "neurospaces/cell.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"



/// **************************************************************************
///
/// SHORT: CellCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Cell * 
///
///	Newly allocated cell, NULL for failure
///
/// DESCR: Allocate a new cell symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: CellCreateAlias()
///
/// ARGS.:
///
///	pcell.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
CellCreateAlias
(struct symtab_Cell *pcell,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Cell *pcellResult = CellCalloc();

    //- set name and prototype

    SymbolSetName(&pcellResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pcellResult->segr.bio.ioh.iol.hsle, &pcell->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_cell);

    //- return result

    return(&pcellResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: CellInit()
///
/// ARGS.:
///
///	pcell.: cell to init
///
/// RTN..: void
///
/// DESCR: init cell
///
/// **************************************************************************

void CellInit(struct symtab_Cell *pcell)
{
    //- initialize base symbol

    SegmenterInit(&pcell->segr);

    //- set type

    pcell->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_cell;
}


/// **************************************************************************
///
/// SHORT: CellNewAtXYZ()
///
/// ARGS.:
///
///	dx..: X coordinate
///	dy..: Y coordinate
///	dz..: Z coordinate
///
/// RTN..: struct symtab_Cell * : resulting cell, NULL for failure
///
/// DESCR: Allocate cell, put at specified position.
///
///	Contains memory leak.
///
/// **************************************************************************

struct symtab_Cell * CellNewAtXYZ(double dx, double dy, double dz)
{
    //- set result : new cell

    struct symtab_Cell *pcellResult 
	= CellCalloc();

    //- allocate & insert parameters

    if (SymbolSetParameterDouble(&pcellResult->segr.bio.ioh.iol.hsle, "X", dx))
    {
	if (SymbolSetParameterDouble(&pcellResult->segr.bio.ioh.iol.hsle, "Y", dy))
	{
	    if (SymbolSetParameterDouble(&pcellResult->segr.bio.ioh.iol.hsle, "Z", dz))
	    {
	    }
	    else
	    {
		pcellResult = NULL;
	    }
	}
	else
	{
	    pcellResult = NULL;
	}
    }
    else
    {
	pcellResult = NULL;
    }

    //- return result

    return(pcellResult);
}


