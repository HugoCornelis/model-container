//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: population.c 1.75 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/cell.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/population.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/attachment.h"

#include "neurospaces/symbolvirtual_protos.h"


struct PopulationSerialSpikeReceiver
{
    //m original population

    struct symtab_HSolveListElement *phslePopulation;
    struct PidinStack *ppistPopulation;

    //m spike receiver to lookup

    struct symtab_HSolveListElement *phsleReceiver;
    struct PidinStack *ppistReceiver;

    //m number of spike receivers encountered so far

    int iReceivers;

    //m flag : found or not found

    int bFound;
};


/// **************************************************************************
///
/// SHORT: PopulationCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Population * 
///
///	Newly allocated population, NULL for failure
///
/// DESCR: Allocate a new population symbol table element
///
/// **************************************************************************

struct symtab_Population * PopulationCalloc(void)
{
    //- set default result : failure

    struct symtab_Population *ppopuResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/population_vtable.c"

    //- allocate population

    ppopuResult
	= (struct symtab_Population *)
	  SymbolCalloc(1, sizeof(struct symtab_Population), _vtable_population, HIERARCHY_TYPE_symbols_population);

    //- initialize population

    PopulationInit(ppopuResult);

    //- return result

    return(ppopuResult);
}


/// **************************************************************************
///
/// SHORT: PopulationCountCells()
///
/// ARGS.:
///
///	ppopu.: population to count cells for
///
/// RTN..: int : number of cells in population, -1 for failure
///
/// DESCR: count cells in population
///
/// **************************************************************************

int PopulationCountCells
(struct symtab_Population *ppopu, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse population cells and count them

    if (PopulationTraverseCells
	(&ppopu->segr.bio.ioh.iol.hsle,
	 ppist,
	 SymbolCellCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	iResult = FALSE;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PopulationCreateAlias()
///
/// ARGS.:
///
///	ppopu.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
PopulationCreateAlias
(struct symtab_Population *ppopu,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Population *ppopuResult = PopulationCalloc();

    //- set name and prototype

    SymbolSetName(&ppopuResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&ppopuResult->segr.bio.ioh.iol.hsle, &ppopu->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_population);

    //- return result

    return(&ppopuResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: PopulationGetParameter()
///
/// ARGS.:
///
///	ppopu..: symbol to get parameter for.
///	ppist..: context of population.
///	pcName.: name of parameter.
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR: Get parameter of symbol
///
/// **************************************************************************

struct symtab_Parameters * 
PopulationGetParameter
(struct symtab_Population *ppopu,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&ppopu->segr.bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if extent x

	if (0 == strcmp(pcName, "EXTENT_X"))
	{
	    struct symtab_IdentifierIndex *pidinFirst;
	    struct symtab_IdentifierIndex *pidinLast;
	    struct D3Position D3CoordFirst;
	    struct D3Position D3CoordLast;
	    int iLast;
	    char pcLast[10];
	    double dExtentX;

	    //- get pidin stack with first cell in populatin

	    struct PidinStack *ppistCoord = PidinStackDuplicate(ppist);
	    pidinFirst = IdinNewFromChars("0");
	    PidinStackPush(ppistCoord, pidinFirst);

	    //- resolve coordinate if first cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordFirst)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- get last cell index in population

	    iLast = PopulationCountCells(ppopu,ppist);

	    sprintf(pcLast,"%i",iLast - 1);

	    //- get pidin stack with last cell in populatin

	    PidinStackFree(ppistCoord);
	    ppistCoord = PidinStackDuplicate(ppist);
	    pidinLast = IdinNewFromChars(pcLast);
	    PidinStackPush(ppistCoord, pidinLast);

	    //- resolve coordinate if last cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordLast)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- free pidinstack

	    PidinStackFree(ppistCoord);

	    //- calculate extent x of population

	    dExtentX = D3CoordLast.dx - D3CoordFirst.dx;

	    //- set extent x parameter

	    pparResult
		= SymbolSetParameterDouble
		  (&ppopu->segr.bio.ioh.iol.hsle, "EXTENT_X", dExtentX);
	}

	//- if extent y

	else if (0 == strcmp(pcName, "EXTENT_Y"))
	{
	    struct symtab_IdentifierIndex *pidinFirst;
	    struct symtab_IdentifierIndex *pidinLast;
	    struct D3Position D3CoordFirst;
	    struct D3Position D3CoordLast;
	    int iLast;
	    char pcLast[10];
	    double dExtentY;

	    //- get pidin stack with first cell in populatin

	    struct PidinStack *ppistCoord = PidinStackDuplicate(ppist);
	    pidinFirst = IdinNewFromChars("0");
	    PidinStackPush(ppistCoord, pidinFirst);

	    //- resolve coordinate if first cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordFirst)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- get last cell index in population

	    iLast = PopulationCountCells(ppopu, ppist);

	    sprintf(pcLast, "%i", iLast - 1);

	    //- get pidin stack with last cell in populatin

	    PidinStackFree(ppistCoord);
	    ppistCoord = PidinStackDuplicate(ppist);
	    pidinLast = IdinNewFromChars(pcLast);
	    PidinStackPush(ppistCoord, pidinLast);

	    //- resolve coordinate if last cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordLast)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- free pidinstack

	    PidinStackFree(ppistCoord);

	    //- calculate extent y of population

	    dExtentY = D3CoordLast.dy - D3CoordFirst.dy;

	    //- set extent y parameter

	    pparResult
		= SymbolSetParameterDouble
		  (&ppopu->segr.bio.ioh.iol.hsle, "EXTENT_Y", dExtentY);
	}

	//- if extent z

	else if (0 == strcmp(pcName, "EXTENT_Z"))
	{
	    struct symtab_IdentifierIndex *pidinFirst;
	    struct symtab_IdentifierIndex *pidinLast;
	    struct D3Position D3CoordFirst;
	    struct D3Position D3CoordLast;
	    int iLast;
	    char pcLast[10];
	    double dExtentZ;

	    //- get pidin stack with first cell in populatin

	    struct PidinStack *ppistCoord = PidinStackDuplicate(ppist);
	    pidinFirst = IdinNewFromChars("0");
	    PidinStackPush(ppistCoord, pidinFirst);

	    //- resolve coordinate if first cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordFirst)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- get last cell index in population

	    iLast = PopulationCountCells(ppopu, ppist);

	    sprintf(pcLast, "%i", iLast - 1);

	    //- get pidin stack with last cell in populatin

	    PidinStackFree(ppistCoord);
	    ppistCoord = PidinStackDuplicate(ppist);
	    pidinLast = IdinNewFromChars(pcLast);
	    PidinStackPush(ppistCoord, pidinLast);

	    //- resolve coordinate if last cell in population

	    if (SymbolParameterResolveCoordinateValue
		((struct symtab_HSolveListElement *)ppopu,
		 ppist,
		 ppistCoord,
		 &D3CoordLast)
		== FALSE)
	    {
		return(NULL);
	    }

	    //- free pidinstack

	    PidinStackFree(ppistCoord);

	    //- calculate extent z of population

	    dExtentZ = D3CoordLast.dz - D3CoordFirst.dz;

	    //- set extent z parameter

	    pparResult
		= SymbolSetParameterDouble
		  (&ppopu->segr.bio.ioh.iol.hsle, "EXTENT_Z", dExtentZ);
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: PopulationInit()
///
/// ARGS.:
///
///	ppopu.: population to init
///
/// RTN..: void
///
/// DESCR: init population
///
/// **************************************************************************

void PopulationInit(struct symtab_Population *ppopu)
{
    //- initialize base symbol

    SegmenterInit(&ppopu->segr);

    //- set type

    ppopu->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_population;
}


/// **************************************************************************
///
/// SHORT: PopulationLookupSpikeReceiverSerialID()
///
/// ARGS.:
///
///	ppopu......: symbol container
///	ppist......: context of container
///	phsleSerial: element to search
///	ppistSerial: context of element to search
///
/// RTN..: int : serial ID of symbol with respect to container, -1 for failure
///
/// DESCR: Get a serial unique ID for symbol with respect to container
///
/// **************************************************************************

static int 
PopulationSpikeReceiverCompare
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    struct PopulationSerialSpikeReceiver *ppsersr
	= (struct PopulationSerialSpikeReceiver *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike receiver

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
    {
	//- if is searched spike receiver

	if (PidinStackEqual(ppsersr->ppistReceiver,ptstr->ppist))
	{
	    //- remember : found

	    ppsersr->bFound = TRUE;

	    //- abort treespace traversal

	    iResult = TSTR_PROCESSOR_ABORT;
	}

	//- else

	else
	{
	    //- add to counted spike receivers

	    ppsersr->iReceivers++;
	}
    }

    //- return result

    return(iResult);
}

int PopulationLookupSpikeReceiverSerialID
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsleSerial,
 struct PidinStack *ppistSerial)
{
    //- set default result : failure

    int iResult = -1;

    struct PopulationSerialSpikeReceiver psersr =
    {
	phsle,
	ppist,

	phsleSerial,
	ppistSerial,

	0,

	FALSE,
    };

    //- if traverse population spike receivers and compare

    if (SymbolTraverseSpikeReceivers
	(phsle,
	 ppist,
	 PopulationSpikeReceiverCompare,
	 NULL,
	 (void *)&psersr))
    {
	//- if found

	if (psersr.bFound)
	{
	    //- set result

	    iResult = psersr.iReceivers;
	}
    }

    //- else

    else
    {
	//- return failure

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: PopulationTraverseCells()
///
/// ARGS.:
///
///	phsle.......: population to traverse cells for
///	ppist.......: context of population, population assumed to be on top
///	pfProcesor..: cell processor
///	pfFinalizer.: cell finalizer
///	pvUserdata..: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse cells, call pfProcessor on each of them
///
/// **************************************************************************

int PopulationTraverseCells
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init population treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolCellSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse population symbol

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


