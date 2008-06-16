//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: traversablealgorithm.c 1.2 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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


#include "neurospaces/traversablealgorithm.h"


/// **************************************************************************
///
/// SHORT: TraversableAlgorithmCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_TraversableAlgorithm * 
///
///	Newly allocated traversable algorithm, NULL for failure
///
/// DESCR: Allocate a new cell symbol table element
///
/// **************************************************************************

struct symtab_TraversableAlgorithm * TraversableAlgorithmCalloc(void)
{
    //- set default result : failure

    struct symtab_TraversableAlgorithm *ptalgResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/traversable_algorithm_vtable.c"

    //- allocate traversable algorithm

    ptalgResult
	= (struct symtab_TraversableAlgorithm *)
	  SymbolCalloc(1, sizeof(struct symtab_TraversableAlgorithm), _vtable_traversable_algorithm, HIERARCHY_TYPE_symbols_traversable_algorithm);

    //- initialize traversable algorithm

    TraversableAlgorithmInit(ptalgResult);

    //- return result

    return(ptalgResult);
}


/// **************************************************************************
///
/// SHORT: TraversableAlgorithmInit()
///
/// ARGS.:
///
///	ptalg.: traversable algorithm to init
///
/// RTN..: void
///
/// DESCR: init traversable algorithm.
///
/// **************************************************************************

void TraversableAlgorithmInit(struct symtab_TraversableAlgorithm *ptalg)
{
    //- initialize base symbol

    AlgorithmSymbolInit(&ptalg->algs);

    //- set type

    ptalg->algs.hsle.iType = HIERARCHY_TYPE_symbols_traversable_algorithm;
}


/// **************************************************************************
///
/// SHORT: TraversableAlgorithmTraverse()
///
/// ARGS.:
///
///	ptalg.: traversable algorithm to init
///
/// RTN..: int
///
///	regular treespace traversal return value.
///
/// DESCR: init traversable algorithm.
///
/// **************************************************************************

int
TraversableAlgorithmTraverse
(struct TreespaceTraversal *ptstr, struct symtab_TraversableAlgorithm *ptalg)
{
    //- set default result: abort

    int iResult = TSTR_PROCESSOR_ABORT;

    //- return result

    return(iResult);
}


