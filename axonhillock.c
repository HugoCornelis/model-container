//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: axonhillock.c 1.17 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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
#include "neurospaces/axonhillock.h"
#include "neurospaces/biocomp.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: AxonHillockCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_AxonHillock * 
///
///	Newly allocated axon hillock, NULL for failure
///
/// DESCR: Allocate a new axon hillock symbol table element
///
/// **************************************************************************

struct symtab_AxonHillock * AxonHillockCalloc(void)
{
    //- set default result : failure

    struct symtab_AxonHillock *paxhiResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/axon_hillock_vtable.c"

    //- allocate axon hillock

    paxhiResult
	= (struct symtab_AxonHillock *)
	  SymbolCalloc(1, sizeof(struct symtab_AxonHillock), _vtable_axon_hillock, HIERARCHY_TYPE_symbols_axon_hillock);

    //- initialize axon hillock

    AxonHillockInit(paxhiResult);

    //- return result

    return(paxhiResult);
}


/// **************************************************************************
///
/// SHORT: AxonHillockCreateAlias()
///
/// ARGS.:
///
///	paxhi.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
AxonHillockCreateAlias
(struct symtab_AxonHillock *paxhi,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_AxonHillock *paxhiResult = AxonHillockCalloc();

    //- set name and prototype

    SymbolSetName(&paxhiResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&paxhiResult->segr.bio.ioh.iol.hsle, &paxhi->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_axon_hillock);

    //- return result

    return(&paxhiResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: AxonHillockInit()
///
/// ARGS.:
///
///	paxhi.: axon hillock to init
///
/// RTN..: void
///
/// DESCR: init axon hillock
///
/// **************************************************************************

void AxonHillockInit(struct symtab_AxonHillock *paxhi)
{
    //- initialize base symbol

    SegmenterInit(&paxhi->segr);

    //- set type

    paxhi->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_axon_hillock;
}


