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


#include "neurospaces/gatekinetic.h"

#include "neurospaces/symbolvirtual_protos.h"


//f static functions

static
double
GateKineticGetHHOffset
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist);

static
double
GateKineticGetTabulationFlag
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist);


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
/// SHORT: GateKineticGetParameter()
///
/// ARGS.:
///
///	pgatk...: symbol to get parameter for.
///	ppist...: context of symbol.
///	pcName..: name of parameter.
///
/// RTN..: struct symtab_Parameters *
///
///	Parameter structure, NULL for failure.
///
/// DESCR: Get specific parameter of symbol.
///
/// **************************************************************************

struct symtab_Parameters * 
GateKineticGetParameter
(struct symtab_GateKinetic *pgatk,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&pgatk->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if offset

	if (0 == strcmp(pcName, "HH_AB_Offset"))
	{
	    //- calculate offset

	    double dHHOffset = GateKineticGetHHOffset(pgatk, ppist);

	    //- cache offset

	    pparResult
		= SymbolSetParameterDouble
		  (&pgatk->bio.ioh.iol.hsle, "HH_AB_Offset", dHHOffset);
	}

	//- if tabulation flag

	else if (0 == strcmp(pcName, "HH_Has_Table"))
	{
	    //- check for table

	    int iTable = GateKineticGetTabulationFlag(pgatk, ppist);

	    //- cache result

	    pparResult
		= SymbolSetParameterDouble
		  (&pgatk->bio.ioh.iol.hsle, "HH_Has_Table", iTable);
	}

    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: GateKineticGetHHOffset()
///
/// ARGS.:
///
///	pgatk.: gate kinetic symbol.
///	ppist.: context of gate kinetic symbol.
///
/// RTN..: double : HH_AB_Offset, FLT_MAX for failure.
///
/// DESCR: Get HH_AB_Offset of gate kinetic.
///
///	If the HH_AB_Offset parameter is not present, it is taken to
///	be the same as the HH_AB_Offset_E parameter.  Existence of the
///	HH_AB_Offset is not done in this function, must be done
///	elsewhere.
///
/// **************************************************************************

static
double
GateKineticGetHHOffset
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist)
{
    //- set result: same as offset_e

    double dResult
	= SymbolParameterResolveValue(&pgatk->bio.ioh.iol.hsle, ppist, "HH_AB_Offset_E");

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: GateKineticGetTabulationFlag()
///
/// ARGS.:
///
///	pgatk.: gate kinetic symbol.
///	ppist.: context of gate kinetic symbol.
///
/// RTN..: int : TRUE if this table can be tabulated.
///
/// DESCR: Get tabulation flag of gate kinetic.
///
///	A gate kinetic can be presented as a table if it contains a
///	table, or if there is a tabulation service that understands
///	the parameters defined in the gate kinetic.
///
/// **************************************************************************

static
double
GateKineticGetTabulationFlag
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist)
{
    //- set result: no

    int iResult = 0;

    //- is there a first entry in the table ?

    struct symtab_Parameters *pparEntry0
	= SymbolGetParameter(&pgatk->bio.ioh.iol.hsle, ppist, "table[0]");

    if (pparEntry0)
    {
	//t should do something for range etc.
	//t see also TODO comments below.

	//- set result: yes

	iResult = 1;
    }

    //- else

    else
    {
	//t check for a tabulation service

	//t ask the tabulation service to tabulate the gate kinetic

	//t so here we have to link to the tabulation service of heccer

	//t heccer compilation of a model
	//t should first ask for the tabulation flag
	//t   if not present
	//t     bail out
	//t   else
	//t     ask for tables, take over tables (stdized table representation).
	//t

	//t tabulation config should be mirrored as gate parameters ?
	//t guess not, because is
    }

    //- return result

    return(iResult);
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


