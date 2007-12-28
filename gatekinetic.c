//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: gatekinetic.c 1.13 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/gatekinetic.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: GateKineticCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_GateKinetic * 
///
///	Newly allocated gate kinetic, NULL for failure
///
/// DESCR: Allocate a new gate kinetic symbol table element
///
/// **************************************************************************

struct symtab_GateKinetic * GateKineticCalloc(void)
{
    //- set default result : failure

    struct symtab_GateKinetic *pgatkResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/gate_kinetic_vtable.c"

    //- allocate gate kinetic

    pgatkResult
	= (struct symtab_GateKinetic *)
	  SymbolCalloc(1, sizeof(struct symtab_GateKinetic), _vtable_gate_kinetic, HIERARCHY_TYPE_symbols_gate_kinetic);

    //- initialize gate kinetic

    GateKineticInit(pgatkResult);

    //- return result

    return(pgatkResult);
}


/// **************************************************************************
///
/// SHORT: GateKineticCreateAlias()
///
/// ARGS.:
///
///	pgatk.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
GateKineticCreateAlias
(struct symtab_GateKinetic *pgatk,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_GateKinetic *pgatkResult = GateKineticCalloc();

    //- set name and prototype

    SymbolSetName(&pgatkResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pgatkResult->bio.ioh.iol.hsle, &pgatk->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_gate_kinetic);

    //- return result

    return(&pgatkResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: GateKineticInit()
///
/// ARGS.:
///
///	pgatk.: gate kinetic to init
///
/// RTN..: void
///
/// DESCR: init gate kinetic
///
/// **************************************************************************

void GateKineticInit(struct symtab_GateKinetic *pgatk)
{
    //- initialize base symbol

    BioComponentInit(&pgatk->bio);

    //- set type

    pgatk->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_gate_kinetic;
}


