//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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


#include "neurospaces/components/groupedparameters.h"
#include "neurospaces/idin.h"


/// **************************************************************************
///
/// SHORT: GroupedParametersCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_GroupedParameters * 
///
///	Newly allocated parameter group, NULL for failure
///
/// DESCR: Allocate a new parameter group symbol table element.
///
/// **************************************************************************

struct symtab_GroupedParameters * GroupedParametersCalloc(void)
{
    //- set default result : failure

    struct symtab_GroupedParameters *pgrppResult = NULL;

#include "hierarchy/output/symbols/grouped_parameters_vtable.c"

    //- allocate parameter group

    pgrppResult
	= (struct symtab_GroupedParameters *)
	  SymbolCalloc(1, sizeof(struct symtab_GroupedParameters), _vtable_grouped_parameters, HIERARCHY_TYPE_symbols_grouped_parameters);

    //- initialize group

    GroupedParametersInit(pgrppResult);

    //- return result

    return(pgrppResult);
}


/// **************************************************************************
///
/// SHORT: GroupedParametersInit()
///
/// ARGS.:
///
///	pgrpp.: parameter group to init.
///
/// RTN..: void
///
/// DESCR: init parameter group.
///
/// **************************************************************************

void GroupedParametersInit(struct symtab_GroupedParameters *pgrpp)
{
    //- set type

    pgrpp->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_grouped_parameters;
}


