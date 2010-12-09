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


/// 
/// \return struct symtab_ConcentrationGateKinetic * 
/// 
///	Newly allocated concentration gate kinetic, NULL for failure
/// 
/// \brief Allocate a new concentration gate kinetic symbol table element
/// 

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


/// 
/// \arg pcgatc symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
ConcentrationGateKineticCreateAlias
(struct symtab_ConcentrationGateKinetic *pcgatc,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_ConcentrationGateKinetic *pcgatcResult = ConcentrationGateKineticCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pcgatcResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pcgatcResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pcgatcResult->bio.ioh.iol.hsle, &pcgatc->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_concentration_gate_kinetic);

    //- return result

    return(&pcgatcResult->bio.ioh.iol.hsle);
}


/// 
/// \arg pcgatc concentration gate kinetic to init
/// 
/// \return void
/// 
/// \brief init concentration gate kinetic
/// 

void ConcentrationGateKineticInit(struct symtab_ConcentrationGateKinetic *pcgatc)
{
    //- initialize base symbol

    BioComponentInit(&pcgatc->bio);

    //- set type

    pcgatc->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_concentration_gate_kinetic;
}




/// 
/// \arg pcgatc symbol to get parameter for.
/// \arg ppist context of symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get specific parameter of symbol.
/// 

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

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}
	else if (0 == strcmp(pcName, "HH_NUMBER_OF_TABLE_ENTRIES"))
	{
	    //- get the number of table entries  

	    double dTableEntries = GateKineticGetNumTableEntries(pcgatc,ppist);

	    if (dTableEntries == DBL_MAX)
	    {
		return NULL;
	    }

	    pparResult
		= SymbolSetParameterDouble
		  (&pcgatc->bio.ioh.iol.hsle,
		   "HH_NUMBER_OF_TABLE_ENTRIES", 
		   dTableEntries);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pcgatc gate kinetic to init
/// \arg ppist context of kinetic symbol
/// 
/// \return double
/// 
/// \brief Functions returns the number of table parameters in a
/// 
/// \details 
///        gate kinetic in the format "table["index"]"
/// 

static
double
GateKineticGetNumTableEntries
(struct symtab_ConcentrationGateKinetic *pcgatc, struct PidinStack *ppist)
{
    //- set default result: failure

    double dResult = DBL_MAX;

    //- if no first table entry

    struct symtab_Parameters *pparTable
	= SymbolGetParameter(&pcgatc->bio.ioh.iol.hsle, ppist, "table[0]");

    if (pparTable == NULL)
    {
	//- return no entries

	return DBL_MAX;
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


/// 
/// \arg pcgatc gate kinetic symbol.
/// \arg ppist context of gate kinetic symbol.
/// 
/// \return int : TRUE if this table can be tabulated.
/// 
/// \brief Get tabulation flag of gate kinetic.
///
/// \details 
/// 
///	A gate kinetic can be presented as a table if it contains a
///	table, or if there is a tabulation service that understands
///	the parameters defined in the gate kinetic.
/// 

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
	/// \todo should do something for range etc.
	/// see also TODO comments below.

	//- set result: yes

	iResult = 1;
    }

    //- else

    else
    {
	/// \todo check for a tabulation service

	/// \todo ask the tabulation service to tabulate the gate kinetic

	/// \todo so here we have to link to the tabulation service of heccer

	/// \todo heccer compilation of a model
	/// should first ask for the tabulation flag
	///   if not present
	///     bail out
	///   else
	///     ask for tables, take over tables (stdized table representation).
	///

	/// \todo tabulation config should be mirrored as gate parameters ?
	/// guess not, because is
    }

    //- return result

    return(iResult);
}


