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


#include "neurospaces/components/concentrationgatekinetic.h"

#include "neurospaces/symbolvirtual_protos.h"


//f static functions

static
double
GateKineticGetHHOffset
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist);

static 
double
GateKineticGetNumTableEntries
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist);

static
double
GateKineticGetTabulationFlag
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist);


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
///	pidin..: name of new symbol
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




/// **************************************************************************
///
/// SHORT: ConcentrationGateKineticGetParameter()
///
/// ARGS.:
///
///	pcgatc...: symbol to get parameter for.
///	ppist....: context of symbol.
///	pcName...: name of parameter.
///
/// RTN..: struct symtab_Parameters *
///
///	Parameter structure, NULL for failure.
///
/// DESCR: Get specific parameter of symbol.
///
/// **************************************************************************

struct symtab_Parameters * 
ConcentrationGateKineticGetParameter
(struct symtab_ConcentrationGateKinetic *pcgatc,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&pcgatc->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if tabulation flag

	if (0 == strcmp(pcName, "HH_Has_Table"))
	{
	    //- check for table

	    int iTable = GateKineticGetTabulationFlag(pcgatc, ppist);

	    //- cache result

	    pparResult
		= SymbolSetParameterDouble
		  (&pcgatc->bio.ioh.iol.hsle, "HH_Has_Table", iTable);
	}
	else if (0 == strcmp(pcName, "HH_NUMBER_OF_TABLE_ENTRIES"))
	{
	    //- get the number of table entries  

	    double dTableEntries = GateKineticGetNumTableEntries(pcgatc,ppist);

	    if (dTableEntries == FLT_MAX)
	    {
		return NULL;
	    }

	    pparResult
		= SymbolSetParameterDouble
		  (&pcgatc->bio.ioh.iol.hsle,
		   "HH_NUMBER_OF_TABLE_ENTRIES", 
		   dTableEntries);
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: GateKineticGetNumTableEntries()
///
/// ARGS.:
///
///	pcgatc.: gate kinetic to init
///     ppist..: context of kinetic symbol
///
/// RTN..: double
///
/// DESCR: Functions returns the number of table parameters in a
///        gate kinetic in the format "table["index"]"
///
/// **************************************************************************

static
double
GateKineticGetNumTableEntries
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist)
{
    //- set default result: failure

    double dResult = FLT_MAX;

    //- if no first table entry

    struct symtab_Parameters *pparTable
	= SymbolGetParameter(&pcgatc->bio.ioh.iol.hsle, ppist, "table[0]");

    if (pparTable == NULL)
    {
	//- return no entries

	return FLT_MAX;
    }

    //- loop over all table entries by index

    int i;

    for (i = 0 ; pparTable ; i++)
    {
	char pcTable[50];

	sprintf(&pcTable[0], "table[%i]", i);

	pparTable
	    = SymbolGetParameter(&pcgatc->bio.ioh.iol.hsle, ppist, pcTable);
    }

    //- set result

    dResult = i - 1;

    //- return index of last found

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: GateKineticGetTabulationFlag()
///
/// ARGS.:
///
///	pcgatc.: gate kinetic symbol.
///	ppist..: context of gate kinetic symbol.
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
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist)
{
    //- set result: no

    int iResult = 0;

    //- is there a first entry in the table ?

    struct symtab_Parameters *pparEntry0
	= SymbolGetParameter(&pcgatc->bio.ioh.iol.hsle, ppist, "table[0]");

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
