//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: concentrationgatekinetic.c 1.5 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/concentrationgatekinetic.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: ConcentrationGateKineticCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_ConcentrationGateKinetic * 
///
///	Newly allocated concentration gate kinetic, NULL for failure
///
/// DESCR: Allocate a new concentration gate kinetic symbol table element
///
/// **************************************************************************

struct symtab_ConcentrationGateKinetic * ConcentrationGateKineticCalloc(void)
{
    //- set default result : failure

    struct symtab_ConcentrationGateKinetic *pcgatcResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/concentration_gate_kinetic_vtable.c"

    //- allocate concentration gate kinetic

    pcgatcResult
	= (struct symtab_ConcentrationGateKinetic *)
	  SymbolCalloc(1, sizeof(struct symtab_ConcentrationGateKinetic), _vtable_concentration_gate_kinetic, HIERARCHY_TYPE_symbols_concentration_gate_kinetic);

    //- initialize concentration gate kinetic

    ConcentrationGateKineticInit(pcgatcResult);

    //- return result

    return(pcgatcResult);
}


/// **************************************************************************
///
/// SHORT: ConcentrationGateKineticCreateAlias()
///
/// ARGS.:
///
///	pcgatc.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
ConcentrationGateKineticCreateAlias
(struct symtab_ConcentrationGateKinetic *pcgatc,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_ConcentrationGateKinetic *pcgatcResult = ConcentrationGateKineticCalloc();

    //- set name and prototype

    SymbolSetName(&pcgatcResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pcgatcResult->bio.ioh.iol.hsle, &pcgatc->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_concentration_gate_kinetic);

    //- return result

    return(&pcgatcResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: ConcentrationGateKineticInit()
///
/// ARGS.:
///
///	pcgatc.: concentration gate kinetic to init
///
/// RTN..: void
///
/// DESCR: init concentration gate kinetic
///
/// **************************************************************************

void ConcentrationGateKineticInit(struct symtab_ConcentrationGateKinetic *pcgatc)
{
    //- initialize base symbol

    BioComponentInit(&pcgatc->bio);

    //- set type

    pcgatc->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_concentration_gate_kinetic;
}


