//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorcontour.c 1.5 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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
#include "neurospaces/components/vectorcontour.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// 
/// \return struct symtab_VContour * 
/// 
///	Newly allocated contour vector, NULL for failure
/// 
/// \brief Allocate a new contour vector symbol table element
/// \details 
/// 

struct symtab_VContour * VContourCalloc(void)
{
    //- set default result : failure

    struct symtab_VContour *pvcontResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/v_contour_vtable.c"

    //- allocate contour vector

    pvcontResult
	= (struct symtab_VContour *)
	  SymbolCalloc(1, sizeof(struct symtab_VContour), _vtable_v_contour, HIERARCHY_TYPE_symbols_v_contour);

    //- initialize contour vector

    VContourInit(pvcontResult);

    //- return result

    return(pvcontResult);
}


/// 
/// 
/// \arg pvcont symbol vector to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
VContourCreateAlias
(struct symtab_VContour *pvcont,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_VContour *pvcontResult = VContourCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pvcontResult->vect.bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pvcontResult->vect.bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pvcontResult->vect.bio.ioh.iol.hsle, &pvcont->vect.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_v_contour);

    //- return result

    return(&pvcontResult->vect.bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pvcont contour vector to init
/// 
/// \return void
/// 
/// \brief init contour vector
/// \details 
/// 

void VContourInit(struct symtab_VContour *pvcont)
{
    //- initialize base symbol

    VectorInit(&pvcont->vect);

    //- set type

    pvcont->vect.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_v_contour;
}


