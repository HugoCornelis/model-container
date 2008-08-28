//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: hhgate.c 1.14 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/hhgate.h"

#include "neurospaces/symbolvirtual_protos.h"


static
double
HHGateGetNumTableEntries
(struct symtab_HHGate *pgathh, struct PidinStack *ppist);

static
double
HHGateGetStateInit
(struct symtab_HHGate *pgathh, struct PidinStack *ppist);


/// **************************************************************************
///
/// SHORT: HHGateCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_HHGate * 
///
///	Newly allocated conceptual gate, NULL for failure
///
/// DESCR: Allocate a new conceptual gate symbol table element
///
/// **************************************************************************

struct symtab_HHGate * HHGateCalloc(void)
{
    //- set default result : failure

    struct symtab_HHGate *pgathhResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/h_h_gate_vtable.c"

    //- allocate conceptual gate

    pgathhResult
	= (struct symtab_HHGate *)
	  SymbolCalloc(1, sizeof(struct symtab_HHGate), _vtable_h_h_gate, HIERARCHY_TYPE_symbols_h_h_gate);

    //- initialize conceptual gate

    HHGateInit(pgathhResult);

    //- return result

    return(pgathhResult);
}


/// **************************************************************************
///
/// SHORT: HHGateCreateAlias()
///
/// ARGS.:
///
///	pgathh.: symbol to alias
///	pidin..: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
HHGateCreateAlias
(struct symtab_HHGate *pgathh,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_HHGate *pgathhResult = HHGateCalloc();

    //- set name and prototype

    SymbolSetName(&pgathhResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pgathhResult->bio.ioh.iol.hsle, &pgathh->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_h_h_gate);

    //- return result

    return(&pgathhResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: HHGateGetParameter()
///
/// ARGS.:
///
///	pgathh..: symbol to get parameter for.
///	ppist...: context of symbol.
///	pcName..: name of parameter.
///
/// RTN..: struct symtab_Parameters *
///
///	Parameter structure, NULL for failure.
///
/// DESCR: Get parameter of symbol.
///
/// **************************************************************************

struct symtab_Parameters * 
HHGateGetParameter
(struct symtab_HHGate *pgathh,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&pgathh->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if initial gate state

	if (0 == strcmp(pcName,"state_init"))
	{
	    //- get initial state

	    double dState = HHGateGetStateInit(pgathh, ppist);

	    //- set initial state of gate

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "state_init", dState);
	}

	//- if number of table entries

	else if (0 == strcmp(pcName,"HH_NUMBER_OF_TABLE_ENTRIES"))
	{
	    //- get number of table entries

	    double dState = HHGateGetNumTableEntries(pgathh, ppist);

	    //- set number of table entries

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "HH_NUMBER_OF_TABLE_ENTRIES", dState);
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: HHGateGetNumTableEntries()
///
/// ARGS.:
///
///	pgathh.: conceptual gate.
///	ppist..: context of conceptual gate.
///
/// RTN..: double
///
///	Number of table entries of precalculated tables for all of the
///	kinetics inside the gate, FLT_MAX for inconsistent tables, 0
///	for no tables.
///
/// DESCR: Get number of table entries.
///
/// **************************************************************************

static
double
HHGateGetNumTableEntries
(struct symtab_HHGate *pgathh, struct PidinStack *ppist)
{
    //- set default result: failure.

    double dResult = FLT_MAX;

    //- set default number of entries: no tables

    int iEntries = 0;

    //- traverse gate symbol, collect number of entries for each gate
    //- kinetic

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolGateKineticSelector,
	   NULL,
	   SymbolTableEntriesCollector,
	   (void *)&iEntries,
	   NULL,
	   NULL);

    int i = TstrGo(ptstr, &pgathh->bio.ioh.iol.hsle);

    if (i == 1)
    {
	//- if no errors

	if (iEntries >= 0)
	{
	    //- set result

	    dResult = iEntries;
	}
    }

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: HHGateGetStateInit()
///
/// ARGS.:
///
///	pgathh.: conceptual gate.
///	ppist..: context of conceptual gate.
///
/// RTN..: double
///
///	Initial state, FLT_MAX for unknown.  By default the initial
///	state is the steady state for the initial membrane potential
///	found in the parent compartment.
///
/// DESCR: Get initial state of this gate.
///
/// **************************************************************************

static
double
HHGateGetStateInit
(struct symtab_HHGate *pgathh, struct PidinStack *ppist)
{
    //- set default result: failure.

    double dResult = FLT_MAX;

    //- determine the initial membrane potential of the parent segment

    struct PidinStack *ppistSegment = PidinStackDuplicate(ppist);

    PidinStackPop(ppistSegment);

    struct symtab_HSolveListElement *phsleSegment
	= PidinStackLookupTopSymbol(ppistSegment);

    if (phsleSegment)
    {
	double dVm = SymbolParameterResolveValue(phsleSegment, ppistSegment, "Vm_init");

	if (dVm != FLT_MAX)
	{
	    //t need access to a gate kinetic calculator

/* 	    A = TabInterp(channel->X_A,v); */
/* 	    B = TabInterp(channel->X_B,v); */
/* 	    channel->X = A / B; */
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: HHGateInit()
///
/// ARGS.:
///
///	pgathh.: conceptual gate to init
///
/// RTN..: void
///
/// DESCR: init conceptual gate
///
/// **************************************************************************

void HHGateInit(struct symtab_HHGate *pgathh)
{
    //- initialize base symbol

    BioComponentInit(&pgathh->bio);

    //- set type

    pgathh->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_h_h_gate;
}


