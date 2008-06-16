//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: fiber.c 1.17 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <stdlib.h>


#include "neurospaces/attachment.h"
#include "neurospaces/fiber.h"
#include "neurospaces/idin.h"


/// **************************************************************************
///
/// SHORT: FiberCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Fiber * 
///
///	Newly allocated fiber, NULL for failure
///
/// DESCR: Allocate a new fiber symbol table element
///
/// **************************************************************************

struct symtab_Fiber * FiberCalloc(void)
{
    //- set default result : failure

    struct symtab_Fiber *pfibrResult = NULL;

#include "hierarchy/output/symbols/fiber_vtable.c"

    //- allocate fiber

    pfibrResult
	= (struct symtab_Fiber *)
	  SymbolCalloc(1, sizeof(struct symtab_Fiber), _vtable_fiber, HIERARCHY_TYPE_symbols_fiber);

    //- initialize fiber

    FiberInit(pfibrResult);

    //- return result

    return(pfibrResult);
}


/// **************************************************************************
///
/// SHORT: FiberCountSpikeGenerators()
///
/// ARGS.:
///
///	pfibr.: fiber to count spike generators for
///	ppist.: context, fiber on top
///
/// RTN..: int : number of spike generators in fiber, -1 for failure
///
/// DESCR: count all spike generators in fiber
///
/// **************************************************************************

static int 
FiberSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    int *piSpikeGens = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike generator

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted spike generators

	(*piSpikeGens)++;
    }

    //- return result

    return(iResult);
}

int FiberCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse fiber spike generators and count them

    if (SymbolTraverseSpikeGenerators
	(phsle,ppist,FiberSpikeGeneratorCounter,NULL,(void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: FiberCreateAlias()
///
/// ARGS.:
///
///	pfibr.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
FiberCreateAlias
(struct symtab_Fiber *pfibr,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Fiber *pfibrResult = FiberCalloc();

    //- set name and prototype

    SymbolSetName(&pfibrResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pfibrResult->segr.bio.ioh.iol.hsle, &pfibr->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_fiber);

    //- return result

    return(&pfibrResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: FiberInit()
///
/// ARGS.:
///
///	pfibr.: fiber to init
///
/// RTN..: void
///
/// DESCR: init fiber
///
/// **************************************************************************

void FiberInit(struct symtab_Fiber *pfibr)
{
    //- initialize base symbol

    SegmenterInit(&pfibr->segr);

    //- set type

    pfibr->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_fiber;
}


/// **************************************************************************
///
/// SHORT: FiberNewAtXYZ()
///
/// ARGS.:
///
///	dx..: X coordinate
///	dy..: Y coordinate
///	dz..: Z coordinate
///
/// RTN..: struct symtab_Fiber * : resulting cell, NULL for failure
///
/// DESCR: Allocate cell, put at specified position.
///
///	Contains memory leak.
///
/// **************************************************************************

struct symtab_Fiber * FiberNewAtXYZ(double dx,double dy,double dz)
{
    //- set result : new cell

    struct symtab_Fiber *pfibrResult 
	= FiberCalloc();

    //- allocate & insert parameters

    if (SymbolSetParameterDouble(&pfibrResult->segr.bio.ioh.iol.hsle, "X", dx))
    {
	if (SymbolSetParameterDouble(&pfibrResult->segr.bio.ioh.iol.hsle, "Y", dy))
	{
	    if (SymbolSetParameterDouble(&pfibrResult->segr.bio.ioh.iol.hsle, "Z", dz))
	    {
	    }
	    else
	    {
		pfibrResult = NULL;
	    }
	}
	else
	{
	    pfibrResult = NULL;
	}
    }
    else
    {
	pfibrResult = NULL;
    }

    //- return result

    return(pfibrResult);
}


