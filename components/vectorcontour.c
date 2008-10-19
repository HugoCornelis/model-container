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


/// **************************************************************************
///
/// SHORT: VContourCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_VContour * 
///
///	Newly allocated contour vector, NULL for failure
///
/// DESCR: Allocate a new contour vector symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: VContourCreateAlias()
///
/// ARGS.:
///
///	pvcont.: symbol vector to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
VContourCreateAlias
(struct symtab_VContour *pvcont,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_VContour *pvcontResult = VContourCalloc();

    //- set name and prototype

    SymbolSetName(&pvcontResult->vect.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pvcontResult->vect.bio.ioh.iol.hsle, &pvcont->vect.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_v_contour);

    //- return result

    return(&pvcontResult->vect.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: VContourInit()
///
/// ARGS.:
///
///	pvcont.: contour vector to init
///
/// RTN..: void
///
/// DESCR: init contour vector
///
/// **************************************************************************

void VContourInit(struct symtab_VContour *pvcont)
{
    //- initialize base symbol

    VectorInit(&pvcont->vect);

    //- set type

    pvcont->vect.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_v_contour;
}


