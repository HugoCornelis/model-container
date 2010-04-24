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


#include "neurospaces/components/gatekinetic.h"

#include "neurospaces/symbolvirtual_protos.h"



static
double
GateKineticGetHHOffset
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist);

static 
double 
GateKineticGetNumTableEntries
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist);

static
double
GateKineticGetTabulationFlag
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist);


/// 
/// 
/// \return struct symtab_GateKinetic * 
/// 
///	Newly allocated gate kinetic, NULL for failure
/// 
/// \brief Allocate a new gate kinetic symbol table element
/// \details 
/// 

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


/// 
/// 
/// \arg pgatk symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
GateKineticCreateAlias
(struct symtab_GateKinetic *pgatk,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_GateKinetic *pgatkResult = GateKineticCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pgatkResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pgatkResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pgatkResult->bio.ioh.iol.hsle, &pgatk->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_gate_kinetic);

    //- return result

    return(&pgatkResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pgatk symbol to get parameter for.
/// \arg ppist context of symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get specific parameter of symbol.
/// \details 
/// 

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

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
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

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if number of table entries

	else if (0 == strcmp(pcName, "HH_NUMBER_OF_TABLE_ENTRIES"))
	{
	    //- get the number of table entries  

	    double dEntries = GateKineticGetNumTableEntries(pgatk, ppist);

	    if (dEntries == DBL_MAX)
	    {
		return NULL;
	    }

	    pparResult
		= SymbolSetParameterDouble
		  (&pgatk->bio.ioh.iol.hsle, "HH_NUMBER_OF_TABLE_ENTRIES", dEntries);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if table start

	else if (0 == strcmp(pcName, "HH_TABLE_START_Y"))
	{
	    //- get first table entry

	    pparResult
		= SymbolGetParameter(&pgatk->bio.ioh.iol.hsle, ppist, "table[0]");
	}

	//- if table end

	else if (0 == strcmp(pcName, "HH_TABLE_END_Y"))
	{
	    //- get number of entries in the table

	    double dEntries = SymbolParameterResolveValue(&pgatk->bio.ioh.iol.hsle, ppist, "HH_NUMBER_OF_TABLE_ENTRIES");

	    if (dEntries != DBL_MAX)
	    {
		//- get last table entry

		char pc[50];

		int iEntries = dEntries - 1;

		sprintf(pc, "table[%i]", iEntries);

		//- set result

		double dResult = SymbolParameterResolveValue(&pgatk->bio.ioh.iol.hsle, ppist, pc);

		pparResult
		    = SymbolSetParameterDouble
		      (&pgatk->bio.ioh.iol.hsle, "HH_TABLE_END_Y", dResult);

		pparResult->iFlags |= FLAG_PARA_DERIVED;
	    }
	}

	//- if table step

	else if (0 == strcmp(pcName, "HH_TABLE_STEP_Y"))
	{
	    //- get first table entry

	    double d0 = SymbolParameterResolveValue(&pgatk->bio.ioh.iol.hsle, ppist, "table[0]");

	    //- get second table entry

	    double d1 = SymbolParameterResolveValue(&pgatk->bio.ioh.iol.hsle, ppist, "table[1]");

	    //- if both are defined

	    if (d0 != DBL_MAX
		&& d1 != DBL_MAX)
	    {
		//- subtract

		double dResult = d1 - d0;

		//- set result

		pparResult
		    = SymbolSetParameterDouble(&pgatk->bio.ioh.iol.hsle, "HH_TABLE_STEP_Y", dResult);

		pparResult->iFlags |= FLAG_PARA_DERIVED;
	    }
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// 
/// \arg pgatk gate kinetic symbol.
/// \arg ppist context of gate kinetic symbol.
/// 
/// \return double : HH_AB_Offset, DBL_MAX for failure.
/// 
/// \brief Get HH_AB_Offset of gate kinetic.
/// \details 
/// 
///	If the HH_AB_Offset parameter is not present, it is taken to
///	be the same as the HH_AB_Offset_E parameter.  Existence of the
///	HH_AB_Offset is not done in this function, must be done
///	elsewhere.
/// 

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


/// 
/// 
/// \arg pgatk gate kinetic to init
/// \arg ppist context of kinetic symbol
/// 
/// \return double
/// 
///	Number of entries in the table, DBL_MAX for no table.
/// 
/// \brief Calculate the number of entries in the gate kinetic table.
/// \details 
/// 

static
double
GateKineticGetNumTableEntries
(struct symtab_GateKinetic *pgatk, struct PidinStack *ppist)
{
    //- set default result: failure

    double dResult = DBL_MAX;

    //- if no first table entry

    struct symtab_Parameters *pparTable
	= SymbolGetParameter(&pgatk->bio.ioh.iol.hsle, ppist, "table[0]");

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
	    = SymbolGetParameter(&pgatk->bio.ioh.iol.hsle, ppist, pcTable);
    }

    //- set result

    dResult = i - 1;

    //- return index of last found

    return(dResult);
}


/// 
/// 
/// \arg pgatk gate kinetic symbol.
/// \arg ppist context of gate kinetic symbol.
/// 
/// \return int : TRUE if this table can be tabulated.
/// 
/// \brief Get tabulation flag of gate kinetic.
/// \details 
/// 
///	A gate kinetic can be presented as a table if it contains a
///	table, or if there is a tabulation service that understands
///	the parameters defined in the gate kinetic.
/// 

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
	/// \todo should do something for range etc.
	/// \todo see also TODO comments below.

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
	/// \todo should first ask for the tabulation flag
	/// \todo   if not present
	/// \todo     bail out
	/// \todo   else
	/// \todo     ask for tables, take over tables (stdized table representation).
	///

	/// \todo tabulation config should be mirrored as gate parameters ?
	/// \todo guess not, because is
    }

    //- return result

    return(iResult);
}


/// 
/// 
/// \arg pgatk gate kinetic to init
/// 
/// \return void
/// 
/// \brief init gate kinetic
/// \details 
/// 

void GateKineticInit(struct symtab_GateKinetic *pgatk)
{
    //- initialize base symbol

    BioComponentInit(&pgatk->bio);

    //- set type

    pgatk->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_gate_kinetic;
}


