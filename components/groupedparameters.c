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


/// 
/// 
/// \return struct symtab_GroupedParameters * 
/// 
///	Newly allocated parameter group, NULL for failure
/// 
/// \brief Allocate a new parameter group symbol table element.
/// \details 
/// 

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


/// 
/// 
/// \arg pgrpp parameter group to init.
/// 
/// \return void
/// 
/// \brief init parameter group.
/// \details 
/// 

void GroupedParametersInit(struct symtab_GroupedParameters *pgrpp)
{
    //- initialize base symbol

    BioComponentInit(&pgrpp->bio);

    //- set type

    pgrpp->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_grouped_parameters;
}


