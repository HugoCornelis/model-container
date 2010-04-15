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


#include "neurospaces/components/hhgate.h"

#include "neurospaces/symbolvirtual_protos.h"


static
double
HHGateGetTableValue
(struct symtab_HHGate *pgathh, struct PidinStack *ppist, char *pc);

static
double
HHGateGetStateInit
(struct symtab_HHGate *pgathh, struct PidinStack *ppist);


/// 
/// \return struct symtab_HHGate * 
/// 
///	Newly allocated conceptual gate, NULL for failure
/// 
/// \brief Allocate a new conceptual gate symbol table element
/// 

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


/// 
/// \arg pgathh symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
HHGateCreateAlias
(struct symtab_HHGate *pgathh,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_HHGate *pgathhResult = HHGateCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pgathhResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pgathhResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pgathhResult->bio.ioh.iol.hsle, &pgathh->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_h_h_gate);

    //- return result

    return(&pgathhResult->bio.ioh.iol.hsle);
}


/// 
/// \arg pgathh symbol to get parameter for.
/// \arg ppist context of symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get parameter of symbol.
/// 

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

	    double dState = HHGateGetTableValue(pgathh, ppist, "HH_NUMBER_OF_TABLE_ENTRIES");

	    //- set number of table entries

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "HH_NUMBER_OF_TABLE_ENTRIES", dState);
	}

	//- if start of table

	else if (0 == strcmp(pcName,"HH_TABLE_START_Y"))
	{
	    //- get start of table

	    double dState = HHGateGetTableValue(pgathh, ppist, "HH_TABLE_START_Y");

	    //- set start of table

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "HH_TABLE_START_Y", dState);
	}

	//- if end of table

	else if (0 == strcmp(pcName,"HH_TABLE_END_Y"))
	{
	    //- get end of table

	    double dState = HHGateGetTableValue(pgathh, ppist, "HH_TABLE_END_Y");

	    //- set end of table

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "HH_TABLE_END_Y", dState);
	}

	//- if table step

	else if (0 == strcmp(pcName,"HH_TABLE_STEP_Y"))
	{
	    //- get table step

	    double dState = HHGateGetTableValue(pgathh, ppist, "HH_TABLE_STEP_Y");

	    //- set table step

	    pparResult
		= SymbolSetParameterDouble
		  (&pgathh->bio.ioh.iol.hsle, "HH_TABLE_STEP_Y", dState);
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pgathh conceptual gate.
/// \arg ppist context of conceptual gate.
/// \arg pc name of parameter.
/// 
/// \return double
/// 
///	Number of table entries of precalculated tables for all of the
///	kinetics inside the gate, DBL_MAX for inconsistent tables, 0
///	for no tables.
/// 
/// \brief Get number of table entries, or a similar parameter.
/// 
/// \details 
/// 
///	Similar parameters are currently HH_TABLE_START_Y,
///	HH_TABLE_END_Y, and HH_TABLE_STEP_Y.
/// 

static
double
HHGateGetTableValue
(struct symtab_HHGate *pgathh, struct PidinStack *ppist, char *pc)
{
    //- set default result: failure.

    double dResult = DBL_MAX;

    struct table_parameter_collector_data tpcd =
	{
	    /// parameter under investigation

	    pc,

	    /// current value

	    /// \note must be initialized to zero for correct error processing

	    0,
	};

    //- traverse gate symbol, collect number of entries for each gate
    //- kinetic

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolGateKineticSelector,
	   NULL,
	   SymbolTableValueCollector,
	   (void *)&tpcd,
	   NULL,
	   NULL);

    int i = TstrGo(ptstr, &pgathh->bio.ioh.iol.hsle);

    if (i == 1)
    {
	//- if no errors

	if (tpcd.iValue >= 0)
	{
	    //- set result

	    dResult = tpcd.iValue;
	}
    }

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(dResult);
}


/// 
/// \arg pgathh conceptual gate.
/// \arg ppist context of conceptual gate.
/// 
/// \return double
/// 
///	Initial state, DBL_MAX for unknown.  By default the initial
///	state is the steady state for the initial membrane potential
///	found in the parent compartment.
/// 
/// \brief Get initial state of this gate.
/// 

static
double
HHGateGetStateInit
(struct symtab_HHGate *pgathh, struct PidinStack *ppist)
{
    //- set default result: failure.

    double dResult = DBL_MAX;

    //- determine the initial membrane potential of the parent segment

    struct PidinStack *ppistSegment = PidinStackDuplicate(ppist);

    PidinStackPop(ppistSegment);

    struct symtab_HSolveListElement *phsleSegment
	= PidinStackLookupTopSymbol(ppistSegment);

    if (phsleSegment)
    {
	double dVm = SymbolParameterResolveValue(phsleSegment, ppistSegment, "Vm_init");

	if (dVm != DBL_MAX)
	{
	    /// \todo need access to a gate kinetic calculator

/* 	    A = TabInterp(channel->X_A,v); */
/* 	    B = TabInterp(channel->X_B,v); */
/* 	    channel->X = A / B; */
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg pgathh conceptual gate to init
/// 
/// \return void
/// 
/// \brief init conceptual gate
/// 

void HHGateInit(struct symtab_HHGate *pgathh)
{
    //- initialize base symbol

    BioComponentInit(&pgathh->bio);

    //- set type

    pgathh->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_h_h_gate;
}


