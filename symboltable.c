//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: symboltable.c 1.41.1.176 Thu, 15 Nov 2007 18:32:41 -0600 hugo $
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



#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmsymbol.h"
#include "neurospaces/attachment.h"
#include "neurospaces/axonhillock.h"
#include "neurospaces/biocomp.h"
#include "neurospaces/biolevel.h"
#include "neurospaces/cell.h"
#include "neurospaces/cachedparameter.h"
#include "neurospaces/connection.h"
#include "neurospaces/channel.h"
#include "neurospaces/equation.h"
#include "neurospaces/group.h"
#include "neurospaces/idin.h"
#include "neurospaces/iohier.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/network.h"
#include "neurospaces/parametercache.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/pool.h"
#include "neurospaces/population.h"
#include "neurospaces/projection.h"
#include "neurospaces/randomvalue.h"
#include "neurospaces/root.h"
#include "neurospaces/segment.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/vector.h"
#include "neurospaces/vectorconnection.h"
#include "neurospaces/vectorsegment.h"
#include "neurospaces/workload.h"


#include "hierarchy/output/symbols/long_descriptions.c"

#include "hierarchy/output/symbols/short_descriptions.c"


//v global number of allocated symbols

int iTotalAllocatedSymbols = 1;


//v number of created aliases for biocomponents

int iCreatedAliases = 0;

//v number of created aliases for biocomponents by type, 
//v first entry (the null type that cannot be aliased) 
//v contains number of valid entries (inclusive).

int piCreatedAliases[COUNT_HIERARCHY_TYPE_symbols + 1] =
{
    COUNT_HIERARCHY_TYPE_symbols + 1,
};


// local functions


TreespaceTraversalProcessor SymbolDeleter;


//t would be great to put all the selectors and processors in a
//t library

//! note that deletions are only possible during finalization.

int SymbolDeleter(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result: success

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- remove the original from the original forestspace

    struct symtab_HSolveListElement *phsleParent
	= TstrGetActualParent(ptstr);

    SymbolDeleteChild(phsleParent, phsle);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolCacheParameterDouble()
///
/// ARGS.:
///
///	phsle..: symbol to use for caching.
///	iSerial: serial to use for caching, context of parameter.
///	pcName.: name of parameter.
///	dNumber: value of parameter.
///
/// RTN..: struct symtab_Parameters *
///
///	Newly allocated parameters, NULL for failure.
///
/// DESCR:
///
///	Allocate a parameter for the given value and insert it in the
///	parameter cache of the given symbol.
///
/// **************************************************************************

struct symtab_Parameters *
SymbolCacheParameterDouble
(struct symtab_HSolveListElement *phsle, int iSerial, char *pcName, double dNumber)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    struct ImportedFile *pifRootImport = ImportedFileGetRootImport();

/*     fprintf(stdout, "importedfile.c: root import %p\n", pifRootImport); */

    struct symtab_RootSymbol *proot
	= ImportedFileGetRootSymbol(pifRootImport);

/*     fprintf(stdout, "importedfile.c: root symbol %p\n", proot); */

/*     fprintf(stdout, "importedfile.c: symbol %p\n", phsle); */

    //- allocate parameter cache if needed

    if (!phsle->pparcac)
    {
	phsle->pparcac = ParameterCacheNew();

	if (!phsle->pparcac)
	{
	    return(NULL);
	}
    }

    //- get reference to parameter cache

    struct ParameterCache *pparcac = phsle->pparcac;

    //- add the parameter to the cache

    struct CachedParameter *pcacpar
	= ParameterCacheAddDouble(pparcac, iSerial, pcName, dNumber);

    pparResult = CachedParameterGetParameter(pcacpar);

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SymbolCacheParameterString()
///
/// ARGS.:
///
///	phsle..: symbol to use for caching.
///	iSerial: serial to use for caching, context of parameter.
///	pcName.: name of parameter.
///	pcValue: value of parameter.
///
/// RTN..: struct symtab_Parameters *
///
///	Newly allocated parameters, NULL for failure.
///
/// DESCR:
///
///	Allocate a parameter for the given value and insert it in the
///	parameter cache of the given symbol.
///
/// **************************************************************************

struct symtab_Parameters *
SymbolCacheParameterString
(struct symtab_HSolveListElement *phsle, int iSerial, char *pcName, char *pcValue)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    struct ImportedFile *pifRootImport = ImportedFileGetRootImport();

/*     fprintf(stdout, "importedfile.c: root import %p\n", pifRootImport); */

    struct symtab_RootSymbol *proot
	= ImportedFileGetRootSymbol(pifRootImport);

/*     fprintf(stdout, "importedfile.c: root symbol %p\n", proot); */

/*     fprintf(stdout, "importedfile.c: symbol %p\n", phsle); */

    //- allocate parameter cache if needed

    if (!phsle->pparcac)
    {
	phsle->pparcac = ParameterCacheNew();

	if (!phsle->pparcac)
	{
	    return(NULL);
	}
    }

    //- get reference to parameter cache

    struct ParameterCache *pparcac = phsle->pparcac;

    //- add the parameter to the cache

    struct CachedParameter *pcacpar
	= ParameterCacheAddString(pparcac, iSerial, pcName, pcValue);

    pparResult = CachedParameterGetParameter(pcacpar);

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SymbolCalloc()
///
/// ARGS.:
///
///	std ANSI calloc() parameters.
///	_vtable..: function table.
///	iType....: type of element.
///
/// RTN..: struct symtab_HSolveListElement * 
///
///	Newly allocated symbol, NULL for failure
///
/// DESCR: Allocate a new symbol table element
///
/// **************************************************************************

struct symtab_HSolveListElement *
SymbolCalloc(size_t nmemb, size_t size, VTable_symbols * _vtable, int iType)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- calculate size of symbol

    size_t vpsize = sizeof(struct _typeinfo_symbols);

    //- allocate symbol

    phsleResult
	= (struct symtab_HSolveListElement *)
	  &((struct _typeinfo_symbols *)calloc(nmemb,size + vpsize))[1];

    //- initialize element

    SymbolInit(phsleResult);

    //- initialize virtual table, type of symbol.

    attach_typeinfo_symbols(phsleResult, _vtable, iType);

    //- register allocation identifier

    phsleResult->iAllocationIdentifier = iTotalAllocatedSymbols;

    //- increment number of allocated symbols

    iTotalAllocatedSymbols++;

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: SymbolFindCachedParameter()
///
/// ARGS.:
///
///	phsle..: symbol to find parameter of.
///	pcName.: name of parameter.
///	ppist..: context of symbol.
///
/// RTN..: struct symtab_Parameters * : parameter structure.
///
/// DESCR:
///
///	Consulte caches as appropriate for the given context, and try
///	to find the parameter with given name.
///
/// **************************************************************************

struct symtab_Parameters *
SymbolFindCachedParameter
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- update context caches

    //t how can I get around this hack in a clean way ?

    //t I force to have at least one symbol in the context cache, such
    //t that caches can be updated.

/*     if (ppist->symsst.symst.iTop == -1) */
/*     { */
/* 	//t how can we possibly find out the root here ? */

/* 	//t actually this should not happen, so we make the caller */
/* 	//t responsible for giving an appropriate ppist, this will */
/* 	//t generate a SEGV to force this behaviour. */

/* 	struct symtab_HSolveListElement *phsleRoot = NULL; */

/* 	int bResult = PSymbolSerialStackPush(&ppist->symsst, phsleRoot); */
/*     } */

    if (!PidinStackUpdateCaches(ppist))
    {
	fprintf(stderr, "Cannot update context caches in SymbolFindCachedParameter()\n");

/* 	return(NULL); */
    }

    //- set serial

    int iSerial = PidinStackToSerial(ppist);

/*     if (PidinStackIsRooted(ppist)) */
/*     { */
/* 	//! skip root, cannot cache parameters */

/* 	struct symtab_HSolveListElement *phsleRootChild */
/* 	    = PSymbolSerialStackElementSymbol(&ppist->symsst, 0); */

/* 	int iRootChild = SymbolGetPrincipalSerialToParent(phsleRootChild); */

/* 	iSerial -= iRootChild; */
/*     } */

    //- loop through all caches

    int iEntries = PidinStackNumberOfEntries(ppist);

    int i;

    for (i = 0 ; i < iEntries ; i++)
    {
	//- get caching symbol

	//t more hacking to be removed

	struct symtab_HSolveListElement *phsleCache
	    = PSymbolSerialStackElementSymbol(&ppist->symsst, i);

	//- correct serial to be relative to next symbol

	iSerial -= SymbolGetPrincipalSerialToParent(phsleCache);

	//- if there is a parameter cache for the current symbol

	struct ParameterCache *pparcac = phsleCache->pparcac;

	if (pparcac)
	{
	    //- find parameter in the cache

	    pparResult = ParameterCacheLookup(pparcac, iSerial, pcName);

	    //- if found

	    if (pparResult)
	    {
		//- break searching loop

		break;
	    }
	}
    }

    //- consistency check : if we did not find the parameter

    if (!pparResult)
    {
	//- we must have followed the right path

	if (iSerial != 0)
	{
	    fprintf
		(stderr,
		 "SymbolFindCachedParameter(): did not find a parameter,\n"
		 "yet context and index do not correspond.\n");
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SymbolFindParameter()
///
/// ARGS.:
///
///	phsle..: symbol to find parameter of.
///	pcName.: name of parameter.
///	ppist..: context of symbol.
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR:
///
///	Find parameter of symbol, consulting caches as appropriate for
///	the given context.
///
/// **************************************************************************

struct symtab_Parameters *
SymbolFindParameter
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- if the parameter is in the caches

    pparResult = SymbolFindCachedParameter(phsle, pcName, ppist);

    if (pparResult)
    {
	//- return this parameter

	return(pparResult);
    }

    //- regular lookup of the parameter

    pparResult = SymbolGetParameter(phsle, pcName, ppist);

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SymbolFree()
///
/// ARGS.:
///
///	phsle..: symbol to free.
///
/// RTN..: int
///
///	Success of operation.
///
/// DESCR: Free memory of a symbol table element
///
/// **************************************************************************

int SymbolFree(struct symtab_HSolveListElement *phsle)
{
    //- set default result: ok

    int iResult = 1;

    //- get access to base of allocated memory

    //- calculate size of symbol

    size_t vpsize = sizeof(struct _typeinfo_symbols);

    //- allocate symbol

    void *pv
	= (struct symtab_HSolveListElement *)
	  &((struct _typeinfo_symbols *)(phsle))[-1];

    //- free allocated memory

    free(pv);

    //- decrement number of allocated symbols

    iTotalAllocatedSymbols--;

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolGetAlgorithmInstanceInfo()
///
/// ARGS.:
///
///	phsle.: symbol to get algorithm info for
///
/// RTN..: struct AlgorithmInstance * : algorithm instance
///
/// DESCR: Get algorithm info for symbol
///
/// **************************************************************************

struct AlgorithmInstance *
SymbolGetAlgorithmInstanceInfo(struct symtab_HSolveListElement *phsle)
{
    //- return result : from symbol

    return(phsle->palgi);
}


/// **************************************************************************
///
/// SHORT: SymbolGetWorkloadIndividual()
///
/// ARGS.:
///
///	phsle.: symbol to get individual workload for.
///	ppist.: context of symbol
///
/// RTN..: int
///
///	Workload for this symbol (not including descendants) expressed
///	in workload units, -1 for failure.
///
/// DESCR: Get workload for this symbol.
///
/// **************************************************************************

int
SymbolGetWorkloadIndividual
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : unknown.

    int iResult = -1;

    //- set result from table with known symbols

    if (instanceof_attachment(phsle))
    {
	iResult = wsc.iAttachment;
    }
    else if (instanceof_axon_hillock(phsle))
    {
	iResult = wsc.iAxonHillock;
    }
    else if (instanceof_cell(phsle))
    {
	iResult = wsc.iCell;
    }
    else if (instanceof_connection(phsle))
    {
	iResult = wsc.iConnection;
    }
    else if (InstanceOfMechanism(phsle))
    {
	if (phsle->iType == HIERARCHY_TYPE_symbols_channel)
	{
	    iResult = wsc.mechanisms.iChannel;
	}
	else if (phsle->iType == HIERARCHY_TYPE_symbols_pool)
	{
	    iResult = wsc.mechanisms.iPool;
	}
    }
    else if (instanceof_network(phsle))
    {
	iResult = wsc.iNetwork;
    }
    else if (instanceof_population(phsle))
    {
	iResult = wsc.iPopulation;
    }
    else if (instanceof_projection(phsle))
    {
	iResult = wsc.iProjection;
    }
    else if (instanceof_randomvalue(phsle))
    {
	iResult = wsc.iRandomvalue;
    }
    else if (instanceof_segment(phsle))
    {
	iResult = wsc.iSegment;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolInit()
///
/// ARGS.:
///
///	phsle.: symbol to init.
///
/// RTN..: void
///
/// DESCR: Init a new symbol table element
///
/// **************************************************************************

void SymbolInit(struct symtab_HSolveListElement * phsle)
{
    //- zero out struct

    memset(phsle, 0, sizeof(*phsle));

    //- clear serial mapping info

    SymbolAllSerialsClear(phsle);
}


/// **************************************************************************
///
/// SHORT: SymbolParameterResolveCoordinateValue()
///
/// ARGS.:
///
///	phsle......: symbol container
///	ppist......: context of symbol
///	ppistCoord.: context to get coordinate for
///	pD3Coord...: coordinate receiving result (may be uninitialized)
///
/// RTN..: int : success of operation
///
///	pD3Coord...: coordinate receiving result
///
/// DESCR: Resolve coordinates for symbol.
///
///	Coordinate values are by default relative to parent.  
///	This functions (and related) recalculates the coordinate values
///	to make them relative to the given context.  ppistCoord must
///	be part of ppist, otherwise this function will give faulty 
///	results without errors.  Coordinates are 'X', 'Y', 'Z' symbol
///	parameters.
///
/// **************************************************************************

int
SymbolParameterResolveCoordinateValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistCoord,
 struct D3Position *pD3Coord)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get a working context

    struct PidinStack *ppistWorking = PidinStackDuplicate(ppistCoord);

    //- init transformed value : zero

    pD3Coord->dx = 0.0;
    pD3Coord->dy = 0.0;
    pD3Coord->dz = 0.0;

    //t I'm also not sure if I should check here the parameter type,
    //t it's also done by SymbolParameterTransformValue().  
    //t I think the default parameter handler (where this function is
    //t is supposed to be part of that default handler), should not
    //t test, so commented out for the moment.

/*     //- if non coordinate parameter */

/*     if ((pcName[0] != 'X' && pcName[0] != 'Y' && pcName[0] != 'Z') */
/* 	|| pcName[1] != '\0') */
/*     { */
/* 	//- return default failure */

/* 	return(FLT_MAX); */
/*     } */

    //- loop over context to base symbol

    while (PidinStackNumberOfEntries(ppist)
	   < PidinStackNumberOfEntries(ppistWorking))
    {
	double dResolvedX;
	double dResolvedY;
	double dResolvedZ;

	//- default : remember coordinates not transformed

	int bTransformed = FALSE;

	//- lookup coordinate symbol

	struct symtab_HSolveListElement *phsleWorking
	    = PidinStackLookupTopSymbol(ppistWorking);

	if (phsleWorking)
	{
	    //- lookup parameters

	    struct symtab_Parameters *pparX
		= SymbolFindParameter(phsleWorking,"X",ppistWorking);

	    struct symtab_Parameters *pparY
		= SymbolFindParameter(phsleWorking,"Y",ppistWorking);

	    struct symtab_Parameters *pparZ
		= SymbolFindParameter(phsleWorking,"Z",ppistWorking);

	    if (!pparX
		|| !pparY
		|| !pparZ)
	    {
		pD3Coord->dx = FLT_MAX;
		pD3Coord->dy = FLT_MAX;
		pD3Coord->dz = FLT_MAX;

		bResult = FALSE;

		break;
	    }

	    //- resolve values

	    dResolvedX = ParameterResolveValue(pparX,ppistWorking);
	    dResolvedY = ParameterResolveValue(pparY,ppistWorking);
	    dResolvedZ = ParameterResolveValue(pparZ,ppistWorking);

	    if (dResolvedX == FLT_MAX
		|| dResolvedY == FLT_MAX
		|| dResolvedZ == FLT_MAX)
	    {
		pD3Coord->dx = FLT_MAX;
		pD3Coord->dy = FLT_MAX;
		pD3Coord->dz = FLT_MAX;

		bResult = FALSE;

		break;
	    }

	    //- add resolved value to resulting value

	    pD3Coord->dx += dResolvedX;
	    pD3Coord->dy += dResolvedY;
	    pD3Coord->dz += dResolvedZ;

	    //- transform value to current symbol

	    if (PidinStackNumberOfEntries(ppist)
		- PidinStackNumberOfEntries(ppistWorking) < 0)
	    {
		bTransformed
		    = SymbolParameterTransformValue
		      (phsleWorking,ppistWorking,pparX,pD3Coord);
	    }
	    else
	    {
		bTransformed = TRUE;
	    }
	}

	//- if dealing with root element

	else if (PidinStackNumberOfEntries(ppistWorking) == 0)
	{
	    //- no transformations is ok for root element

	    bTransformed = TRUE;

	    //- and break transformation loop

	    break;
	}

	//- if not transformed

	if (!bTransformed)
	{
	    //- signal error

	    pD3Coord->dx = FLT_MAX;
	    pD3Coord->dy = FLT_MAX;
	    pD3Coord->dz = FLT_MAX;

	    bResult = FALSE;

	    break;
	}

	//- pop coordinate pidinstack

	PidinStackPop(ppistWorking);
    }

    //- free working context

    PidinStackFree(ppistWorking);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolParameterResolveTransformedValue()
///
/// ARGS.:
///
///	phsle......: symbol container
///	ppist......: context of symbol
///	ppistCoord.: context to get coordinate for
///	pcName.....: name of parameter ("X", "Y", "Z")
///
/// RTN..: double : coordinate parameter value, FLT_MAX if some error occured
///
/// DESCR: Resolve coordinate value of parameter
///
///	Coordinate values are by default relative to parent.  
///	This functions (and related) recalculates the coordinate values
///	to make them relative to the given context.  ppistCoord must
///	be part of ppist, otherwise this function will give faulty 
///	results without errors.
///
/// **************************************************************************

double
SymbolParameterResolveTransformedValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistCoord,
 char *pcName)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- init transformed value : zero

    struct D3Position D3Value = 
    {
	0.0,
	0.0,
	0.0,
    };

    //- get a working context

    struct PidinStack *ppistWorking = PidinStackDuplicate(ppistCoord);

    //t I'm also not sure if I should check here the parameter type,
    //t it's also done by SymbolParameterTransformValue().  
    //t I think the default parameter handler (where this function is
    //t is supposed to be part of that default handler), should not
    //t test, so commented out for the moment.

/*     //- if non coordinate parameter */

/*     if ((pcName[0] != 'X' && pcName[0] != 'Y' && pcName[0] != 'Z') */
/* 	|| pcName[1] != '\0') */
/*     { */
/* 	//- return default failure */

/* 	return(FLT_MAX); */
/*     } */

    //- loop over context to base symbol

    while (PidinStackNumberOfEntries(ppist)
	   < PidinStackNumberOfEntries(ppistWorking))
    {
	double dResolvedX;
	double dResolvedY;
	double dResolvedZ;

	//- default : remember coordinates not transformed

	int bTransformed = FALSE;

	//- lookup coordinate symbol

	struct symtab_HSolveListElement *phsleWorking
	    = PidinStackLookupTopSymbol(ppistWorking);

	if (phsleWorking)
	{
	    //- lookup parameters

	    struct symtab_Parameters *pparX
		= SymbolFindParameter(phsleWorking,"X",ppistWorking);

	    struct symtab_Parameters *pparY
		= SymbolFindParameter(phsleWorking,"Y",ppistWorking);

	    struct symtab_Parameters *pparZ
		= SymbolFindParameter(phsleWorking,"Z",ppistWorking);

	    if (!pparX || !pparY || !pparZ)
	    {
		D3Value.dx = FLT_MAX;
		D3Value.dy = FLT_MAX;
		D3Value.dz = FLT_MAX;

		break;
	    }

	    //- resolve values

	    dResolvedX = ParameterResolveValue(pparX,ppistWorking);
	    dResolvedY = ParameterResolveValue(pparY,ppistWorking);
	    dResolvedZ = ParameterResolveValue(pparZ,ppistWorking);

	    if (dResolvedX == FLT_MAX
		|| dResolvedY == FLT_MAX
		|| dResolvedZ == FLT_MAX)
	    {
		D3Value.dx = FLT_MAX;
		D3Value.dy = FLT_MAX;
		D3Value.dz = FLT_MAX;

		break;
	    }

	    //- add resolved value to resulting value

	    D3Value.dx += dResolvedX;
	    D3Value.dy += dResolvedY;
	    D3Value.dz += dResolvedZ;

	    //- transform value to current symbol

	    bTransformed
		= SymbolParameterTransformValue
		  (phsleWorking,ppistWorking,pparX,&D3Value);

	}

	//- if not transformed

	if (!bTransformed)
	{
	    D3Value.dx = FLT_MAX;
	    D3Value.dy = FLT_MAX;
	    D3Value.dz = FLT_MAX;

	    break;
	}

	//- pop coordinate pidinstack

	PidinStackPop(ppistWorking);
    }

    //- free working context

    PidinStackFree(ppistWorking);

    //- set result

    if (D3Value.dx != FLT_MAX && D3Value.dy != FLT_MAX && D3Value.dz != FLT_MAX)
    {
	switch (pcName[0])
	{
	case 'X': dResult = D3Value.dx; break;
	case 'Y': dResult = D3Value.dy; break;
	case 'Z': dResult = D3Value.dz; break;
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: SymbolParameterResolveScaledValue()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	ppist..: context of symbol
///
/// RTN..: double : scaled parameter value, FLT_MAX if some error occured
///
/// DESCR: Resolve scaled value of parameter
///
/// **************************************************************************

double
SymbolParameterResolveScaledValue
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- lookup parameter

    struct symtab_Parameters *ppar = SymbolFindParameter(phsle,pcName,ppist);

    //- if found

    if (ppar)
    {
	//- resolve value

	dResult = ParameterResolveScaledValue(ppar,ppist);
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: SymbolParameterTransformValue()
///
/// ARGS.:
///
///	phsle.....: symbol to calculate absolute value
///	ppist.....: context of given element
///	ppar......: parameter that specifies type of transformation
///	pD3.......: coordinate to make transform
///
/// RTN..: int : success of operation
///
///	pD3.......: transformed coordinate
///
/// DESCR: Calculate transformation on value for given parameter.
///
/// **************************************************************************

static 
void cross_prd
(double *x1,
 double *y1,
 double *z1,
 double x2,
 double y2,
 double z2,
 double x3,
 double y3,
 double z3);

static 
void cross_prd
(double *x1,
 double *y1,
 double *z1,
 double x2,
 double y2,
 double z2,
 double x3,
 double y3,
 double z3)
{
    *x1 = y2 * z3 - y3 * z2;
    *y1 = z2 * x3 - z3 * x2;
    *z1 = x2 * y3 - x3 * y2;
}

#define dot_prd(x1,y1,z1,x2,y2,z2) (x1 * x2 + y1 * y2 + z1 * z2)

int
SymbolParameterTransformValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct symtab_Parameters *ppar,
 struct D3Position *pD3)
{
    //- set default result : none

    int bResult = FALSE;

    //- get parameter name

    char *pcName = ParameterGetName(ppar);

    //- and if coordinate parameter

    if ((pcName[0] == 'X' || pcName[0] == 'Y' || pcName[0] == 'Z')
	&& pcName[1] == '\0')

    {
	//- if this is a movable symbol

	if (InstanceOfMovable(phsle))
	{
	    //t
	    //t what is really needed :
	    //t
	    //t 3 angles : theta, phi ,rho
	    //t 2 offsets : {x,y,z}1, {x,y,z}2
	    //t     one applied before rotation, one after rotation
	    //t     both default to origin
	    //t     this allows to do fancy things like 
	    //t         x1 = soma->X, x2 = - soma->X
	    //t
	    //t can be done with one matrix multiplication ?
	    //t 

	    //- get position parameters

	    double x = pD3->dx;
	    double y = pD3->dy;
	    double z = pD3->dz;

	    //- get rotation parameters

	    struct symtab_Parameters *pparAngle
		= SymbolFindParameter(phsle,"ROTATE_ANGLE",ppist);

	    struct symtab_Parameters *pparCenterX
		= SymbolFindParameter(phsle,"ROTATE_CENTER_X",ppist);

	    struct symtab_Parameters *pparCenterY
		= SymbolFindParameter(phsle,"ROTATE_CENTER_Y",ppist);

	    struct symtab_Parameters *pparCenterZ
		= SymbolFindParameter(phsle,"ROTATE_CENTER_Z",ppist);

	    struct symtab_Parameters *pparAxisX
		= SymbolFindParameter(phsle,"ROTATE_AXIS_X",ppist);

	    struct symtab_Parameters *pparAxisY
		= SymbolFindParameter(phsle,"ROTATE_AXIS_Y",ppist);

	    struct symtab_Parameters *pparAxisZ
		= SymbolFindParameter(phsle,"ROTATE_AXIS_Z",ppist);

	    //- resolve values for rotation parameters

	    double dAngle
		= pparAngle
		  ? ParameterResolveValue(pparAngle,ppist)
		  : 0.0 ;

	    double dCenterX
		= pparCenterX
		  ? ParameterResolveValue(pparCenterX,ppist)
		  : 0.0 ;

	    double dCenterY
		= pparCenterY
		  ? ParameterResolveValue(pparCenterY,ppist)
		  : 0.0 ;

	    double dCenterZ
		= pparCenterZ
		  ? ParameterResolveValue(pparCenterZ,ppist)
		  : 0.0 ;

	    double dAxisX
		= pparAxisX
		  ? ParameterResolveValue(pparAxisX,ppist)
		  : 0.0 ;

	    double dAxisY
		= pparAxisY
		  ? ParameterResolveValue(pparAxisY,ppist)
		  : 0.0 ;

	    double dAxisZ
		= pparAxisZ
		  ? ParameterResolveValue(pparAxisZ,ppist)
		  : 0.0 ;

	    /* Normalising the axis vector */
	    double dLength
		= sqrt(dAxisX * dAxisX + dAxisY * dAxisY + dAxisZ * dAxisZ);
	    dAxisX = dAxisX / dLength;
	    dAxisY = dAxisY / dLength;
	    dAxisZ = dAxisZ / dLength;

	    //- if rotation (parameters set)

	    if (dAngle != 0.0)
	    {
		double kx = dAxisX;
		double ky = dAxisY;
		double kz = dAxisZ;

		double theta = dAngle;

		/* Vectors for the axes of the new frame of reference */
		double	ix,iy,iz;
		double	jx,jy,jz;

		/* matrix for intermediate transform */
		double m11,m12,m13;
		double m21,m22,m23;
		double m31,m32,m33;

		/* matrix for final transform */
		double t11,t12,t13;
		double t21,t22,t23;
		double t31,t32,t33;

		/* sin and cos variables */
		double s,c;

		/* finding vectors for the other axes.
		** Trick : to get a vector nonparallel to k, we just rotate 
		** its components. No particular directions are needed.
		*/
		cross_prd(&jx,&jy,&jz,kx,ky,kz,ky,kz,kx);
		cross_prd(&ix,&iy,&iz,jx,jy,jz,kx,ky,kz);

		/* Doing rotation about z axis in new frame */
		/* First, finding sin and cos : */
		c = cos(theta);
		s = sin(theta);

		/* then, pre-multiplying the axes transform by the rot transf */
		m11=c * ix - s * jx; m12=c * iy - s * jy; m13=c * iz - s * jz;
		m21=s * ix + c * jx; m22=s * iy + c * jy; m23=s * iz + c * jz;
		m31=kx; m32 = ky; m33 = kz;

		/* Finally, pre-multiplying by the inverse transform to the
		** original frame. This is just the transpose of the first
		** transform matrix, since the columns were orthogonal */
		t11 = dot_prd(ix,jx,kx,m11,m21,m31);
		t12 = dot_prd(ix,jx,kx,m12,m22,m32);
		t13 = dot_prd(ix,jx,kx,m13,m23,m33);
		t21 = dot_prd(iy,jy,ky,m11,m21,m31);
		t22 = dot_prd(iy,jy,ky,m12,m22,m32);
		t23 = dot_prd(iy,jy,ky,m13,m23,m33);
		t31 = dot_prd(iz,jz,kz,m11,m21,m31);
		t32 = dot_prd(iz,jz,kz,m12,m22,m32);
		t33 = dot_prd(iz,jz,kz,m13,m23,m33);

		{
		    double dTmpX = x - dCenterX;
		    double dTmpY = y - dCenterY;
		    double dTmpZ = z - dCenterZ;

		    x = dot_prd(t11,t12,t13,dTmpX,dTmpY,dTmpZ) + dCenterX;
		    y = dot_prd(t21,t22,t23,dTmpX,dTmpY,dTmpZ) + dCenterY;
		    z = dot_prd(t31,t32,t33,dTmpX,dTmpY,dTmpZ) + dCenterZ;

		    pD3->dx = x;
		    pD3->dy = y;
		    pD3->dz = z;

		    //- flag legal result 

		    bResult = TRUE;
		}
	    }

	    //- else

	    else
	    {
		//- no rotation, but flag legal result 
		//- (unchanged position in pD3)

		bResult = TRUE;
	    }
	}

	//- else

	else
	{
	    //- no transformation, but flag legal result 
	    //- (unchanged position in pD3)

	    bResult = TRUE;
	}
    }

    //- else

    else
    {
	//- error : give diagnostics

	fprintf
	    (stderr,
	     "SymbolParameterTransformValue() : "
	     "Don't know how to transform parameter %s for ",
	     pcName);

	PidinStackPrint(ppist,stderr);

	fprintf(stderr,"\n");

	bResult = FALSE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolPrincipalSerial2Context()
///
/// ARGS.:
///
///	phsle......: symbol container.
///	ppist......: context of given element
///	iPrincipal.: principal serial ID for sub-symbol.
///
/// RTN..: struct PidinStack *
///
///	symbol corresponding to iPrincipal, NULL for failure
///
/// DESCR: Convert principal serial ID to symbol info.
///
/// **************************************************************************

struct SymbolPrincipal2ContextData
{
    //m result of operation

    struct PidinStack *ppistResult;

    //m number of skipped successors

    int iSkippedSuccessors;

    //m relative principal ID

    int iPrincipal;
};


static int 
SymbolPrincipal2SymbolSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : siblings

    int iResult = TSTR_SELECTOR_PROCESS_SIBLING;

    //- get pointer to conversion data

    struct SymbolPrincipal2ContextData *psip2c
	= (struct SymbolPrincipal2ContextData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get number of successors

    int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle);

    //- get principal serial relative to parent

    int iSerial = SymbolGetPrincipalSerialToParent(phsle);

    //- if serial is zero

    if (iSerial <= 0)
    {
	printf
	    ("SymbolPrincipalSerial2Context() :"
	     " internal error: zero serial\n");

	//- we have an internal error : abort

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- if #SU + this symbol >= relative principal ID, 
    //- or this is the symbol we are looking for

    if (psip2c->iSkippedSuccessors + iSuccessors + 1 >= psip2c->iPrincipal
	|| iSerial == psip2c->iPrincipal)
    {
	//- subtract principal serials

	psip2c->iPrincipal -= iSerial;

	//- register number of skipped successors : zero

	psip2c->iSkippedSuccessors = 0;

	//- set result : process children

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

    //- else

    else
    {
	//- register that all successors and current symbol are skipped

	psip2c->iSkippedSuccessors += iSuccessors + 1;

	//- set result : process siblings

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- return result

    return(iResult);
}


static int 
SymbolPrincipal2SymbolConvertor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : siblings

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to conversion data

    struct SymbolPrincipal2ContextData *psip2c
	= (struct SymbolPrincipal2ContextData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get number of successors

    int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle);

    //- if match

    if (0 == psip2c->iPrincipal)
    {
	//- set result : current symbol

	psip2c->ppistResult = PidinStackDuplicate(ptstr->ppist);

	//- abort traversal

	return(TSTR_PROCESSOR_ABORT);
    }

    //- if #SU < relative principal ID

    if (iSuccessors < psip2c->iPrincipal)
    {
	printf
	    ("SymbolPrincipalSerial2Context() :"
	     " internal error: #SU < serial\n");

	//- we have an internal error : abort

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- if negative serial

    if (psip2c->iPrincipal < 0)
    {
	printf
	    ("SymbolPrincipalSerial2Context() :"
	     " internal error: negative serial\n");

	//- we have an internal error : abort

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}


struct PidinStack *
SymbolPrincipalSerial2Context
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 int iPrincipal)
{
    //- set default result : not found

    struct PidinStack *ppistResult = NULL;

    //v treespace traversal to go over successors

    struct TreespaceTraversal *ptstr = NULL;

    int iTraversal = 0;

    //v number of successors for top of solved symbol tree

    int iSuccessors = 0;

    //v traversal user data

    struct SymbolPrincipal2ContextData sip2c =
    {
	//m result of operation

	NULL,

	//m number of skipped successors

	0,

	//m relative principal ID

	iPrincipal,
    };

    //- get #SU for symbol

    iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle);

    //- if serial out of range for this symbol

    if (iPrincipal > iSuccessors
	|| iPrincipal < 0)
    {
	//- serial ID unknown, return failure

	return(NULL);
    }

    //- if this symbol requested

    if (iPrincipal == 0)
    {
	//- duplicate given context

	ppistResult = PidinStackDuplicate(ppist);

/* 	//- push this symbol */

/* 	PidinStackPushSymbol(ppistResult,phsle); */

	//- return result

	return(ppistResult);
    }

    //- allocate treespace traversal

    ptstr
	= TstrNew
	  (ppist,
	   SymbolPrincipal2SymbolSelector,
	   (void *)&sip2c,
	   SymbolPrincipal2SymbolConvertor,
	   (void *)&sip2c,
	   NULL,
	   NULL);

    //- traverse symbols, looking for serial

    iTraversal = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- set result from traversal data

    ppistResult = sip2c.ppistResult;

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: SymbolRecalcAllSerials()
///
/// ARGS.:
///
///	phsle....: symbol to resolve input for
///	ppist....: context of given element, may be NULL
///
/// RTN..: int : success of operation
///
/// DESCR: Recalculate all serial mappings of given symbol
///
///	For the given symbol only #SU is updated, the serial to parent is
///	not touched (it's not known here).
///
/// **************************************************************************

struct SerialRecalculationData
{
    //m next invisible ID

    int iInvisible;

    //m next principal ID

    int iPrincipal;

#ifdef TREESPACES_SUBSET_MECHANISM
    //m next mechanism ID

    int iMechanism;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    //m next segment ID

    int iSegment;
#endif

/*     //m successors for each depth */

/*     int iSuccessors[20]; */

/*     //m serial to parent for each depth */

/*     int iSerial[20]; */
};

static int 
SymbolSerialInitializerSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- get #SU for symbol

    int iInvisible;
    int iPrincipal;
    int iMechanism;
    int iSegment;

    if (!subsetof_symbol(iType))
    {
	if (subsetof_connection(iType))
	{
#include "hierarchy/output/symbols/connection_vtable.c"

	    SymbolAllSuccessorsGet_alien
		(phsle
		 , &iInvisible
		 , &iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
		 , &iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , &iSegment
#endif
		 , _vtable_connection
		    );

	    return(iResult);
	}
	else
	{
	    fprintf
		(stderr,
		 "*** Warning: SymbolSerialInitializerSelector() encounters unknown symbol types (iType %i)\n",
		 iType);

	    return(iResult);
	}
    }

    SymbolAllSuccessorsGet
	(phsle
	 , &iInvisible
	 , &iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , &iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , &iSegment
#endif
	    );

    //- if -1

    //t must choose exactly one of those two, not sure which one, but
    //t is harmless to use both of them (I think).

    if (iInvisible == -1 || iPrincipal == -1)
    {
	//- already initalized

	//- don't process symbol, assuming everything below is already done

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- return result

    return(iResult);
}


static int 
SymbolSerialInitializerPreProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle */
/* 	= TstrGetActual(ptstr); */

/*     if (!instanceof_symbol(phsle)) */
/*     { */
/* 	return(iResult); */
/*     } */

    //- return result

    return(iResult);
}


static int 
SymbolSerialInitializerPostProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    if (!subsetof_symbol(iType))
    {
	if (subsetof_connection(iType))
	{
#include "hierarchy/output/symbols/connection_vtable.c"

	    SymbolAllSuccessorsSet_alien
		(phsle
		 , -1
		 , -1
#ifdef TREESPACES_SUBSET_MECHANISM
		 , -1
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , -1
#endif
		 , _vtable_connection
		    );

	    return(iResult);
	}
	else
	{
	    fprintf
		(stderr,
		 "*** Warning: SymbolSerialInitializerPostProcessor() encounters unknown symbol types (iType %i)\n",
		 iType);

	    return(iResult);
	}
    }

    //- set number of successors for current symbol to -1

    SymbolAllSuccessorsSet
	(phsle
	 , -1
	 , -1
#ifdef TREESPACES_SUBSET_MECHANISM
	 , -1
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 -1
#endif
	    );

    //- return result

    return(iResult);
}


static int 
SymbolSerialRecalcSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    if (!instanceof_symbol(phsle))
    {
	return(iResult);
    }

    //- get serial recalculation data

    struct SerialRecalculationData *psrd =
	(struct SerialRecalculationData *)pvUserdata;

    int iInvisibleSuccessors;
    int iPrincipalSuccessors;
#ifdef TREESPACES_SUBSET_MECHANISM
    int iMechanismSuccessors;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    int iSegmentSuccessors;
#endif

    //- get cached successors

    SymbolAllSuccessorsGet
	(phsle
	 , &iInvisibleSuccessors
	 , &iPrincipalSuccessors
#ifdef TREESPACES_SUBSET_MECHANISM
	 , &iMechanismSuccessors
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , &iSegmentSuccessors
#endif
	    );

    //- if already set

    if (iPrincipalSuccessors != -1)
    {
	//- already initalized

	//- register number of skipped symbols for all spaces

	psrd->iInvisible += iInvisibleSuccessors;
	psrd->iPrincipal += iPrincipalSuccessors;
#ifdef TREESPACES_SUBSET_MECHANISM
	psrd->iMechanism += iMechanismSuccessors;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	psrd->iSegment += iSegmentSuccessors;
#endif
	//- don't process symbol, assuming everything below is already done

	return(TSTR_SELECTOR_PROCESS_SIBLING);
    }

    //- return result

    return(iResult);
}


static int 
SymbolSerialRecalcPreProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //t if left child
    //t     serial for left child is known
    //t     number of successors for left child
    //t     set serial for current child
    //t
    //t else
    //t     set serial for current child to one/instanceof(mapping)
    //t
    //t set #SU to zero

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- get serial recalculation data

    struct SerialRecalculationData *psrd =
	(struct SerialRecalculationData *)pvUserdata;

    //- register to which subspaces the symbol belongs

    psrd->iInvisible += 1;

    psrd->iPrincipal += 1;

#ifdef TREESPACES_SUBSET_MECHANISM
    psrd->iMechanism += ( subsetof_pool(iType) || subsetof_channel(iType) ) ? 1 : 0 ;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    psrd->iSegment += subsetof_segment(iType) ? 1 : 0 ;
#endif

    if (!subsetof_symbol(iType))
    {
	if (subsetof_connection(iType))
	{
#include "hierarchy/output/symbols/connection_vtable.c"

	    SymbolAllSuccessorsSet_alien
		(phsle
		 , psrd->iInvisible
		 , psrd->iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
		 , psrd->iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , psrd->iSegment
#endif
		 , _vtable_connection
		    );

	    SymbolAllSerialsToParentSet_alien
		(phsle
		 , psrd->iInvisible
		 , psrd->iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
		 , psrd->iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , psrd->iSegment
#endif
		 , _vtable_connection
		    );

	    return(iResult);
	}
	else
	{
	    fprintf
		(stderr,
		 "*** Warning: SymbolSerialRecalcPreProcessor() encounters unknown symbol types (iType %i)\n",
		 iType);

	    return(iResult);
	}
    }

    //- set successors as absolute serials for this traversal,
    //- will be overwritten by post processor

    SymbolAllSuccessorsSet
	(phsle
	 , psrd->iInvisible
	 , psrd->iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , psrd->iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , psrd->iSegment
#endif
	    );

    //- set absolute serials for this traversal,
    //- will be overwritten by post processor

    SymbolAllSerialsToParentSet
	(phsle
	 , psrd->iInvisible
	 , psrd->iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , psrd->iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , psrd->iSegment
#endif
	    );

    //- return result

    return(iResult);
}


static int 
SymbolSerialRecalcPostProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol (child)

    struct symtab_HSolveListElement *phsleChild = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- get serial recalculation data

    struct SerialRecalculationData *psrd =
	(struct SerialRecalculationData *)pvUserdata;

    //- get actual parent

    struct symtab_HSolveListElement *phsleParent
	= TstrGetActualParent(ptstr);

    int iInvisibleSuccessorsChild;
    int iPrincipalSuccessorsChild;
#ifdef TREESPACES_SUBSET_MECHANISM
    int iMechanismSuccessorsChild;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    int iSegmentSuccessorsChild;
#endif

    int iInvisibleChild;
    int iPrincipalChild;
#ifdef TREESPACES_SUBSET_MECHANISM
    int iMechanismChild;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    int iSegmentChild;
#endif

    int iInvisibleParent;
    int iPrincipalParent;
#ifdef TREESPACES_SUBSET_MECHANISM
    int iMechanismParent;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    int iSegmentParent;
#endif

    if (!subsetof_symbol(iType))
    {
	if (subsetof_connection(iType))
	{
#include "hierarchy/output/symbols/connection_vtable.c"

	    SymbolAllSuccessorsGet_alien
		(phsleChild
		 , &iInvisibleSuccessorsChild
		 , &iPrincipalSuccessorsChild
#ifdef TREESPACES_SUBSET_MECHANISM
		 , &iMechanismSuccessorsChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , &iSegmentSuccessorsChild
#endif
		 , _vtable_connection
		    );

	    SymbolAllSerialsToParentGet_alien
		(phsleChild
		 , &iInvisibleChild
		 , &iPrincipalChild
#ifdef TREESPACES_SUBSET_MECHANISM
		 , &iMechanismChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , &iSegmentChild
#endif
		 , _vtable_connection
		    );

	    SymbolAllSerialsToParentGet_alien
		(phsleParent
		 , &iInvisibleParent
		 , &iPrincipalParent
#ifdef TREESPACES_SUBSET_MECHANISM
		 , &iMechanismParent
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , &iSegmentParent
#endif
		 , _vtable_connection
		    );

	    SymbolAllSuccessorsSet_alien
		(phsleChild
		 , psrd->iInvisible - iInvisibleSuccessorsChild
		 , psrd->iPrincipal - iPrincipalSuccessorsChild
#ifdef TREESPACES_SUBSET_MECHANISM
		 , psrd->iMechanism - iMechanismSuccessorsChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , psrd->iSegment - iSegmentSuccessorsChild
#endif
		 , _vtable_connection
		    );

	    SymbolAllSerialsToParentSet_alien
		(phsleChild
		 , iInvisibleChild - iInvisibleParent
		 , iPrincipalChild - iPrincipalParent
#ifdef TREESPACES_SUBSET_MECHANISM
		 , iMechanismChild - iMechanismParent
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		 , iSegmentChild - iSegmentParent
#endif
		 , _vtable_connection
		    );

	    return(iResult);
	}
	else
	{
	    fprintf
		(stderr,
		 "*** Warning: SymbolSerialRecalcPostProcessor() encounters unknown symbol types (iType %i)\n",
		 iType);

	    return(iResult);
	}
    }

    //- get cached successors

    SymbolAllSuccessorsGet
	(phsleChild
	 , &iInvisibleSuccessorsChild
	 , &iPrincipalSuccessorsChild
#ifdef TREESPACES_SUBSET_MECHANISM
	 , &iMechanismSuccessorsChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , &iSegmentSuccessorsChild
#endif
	    );

    //- get (absolute) serials for child and parent

    SymbolAllSerialsToParentGet
	(phsleChild
	 , &iInvisibleChild
	 , &iPrincipalChild
#ifdef TREESPACES_SUBSET_MECHANISM
	 , &iMechanismChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , &iSegmentChild
#endif
	    );

    SymbolAllSerialsToParentGet
	(phsleParent
	 , &iInvisibleParent
	 , &iPrincipalParent
#ifdef TREESPACES_SUBSET_MECHANISM
	 , &iMechanismParent
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , &iSegmentParent
#endif
	    );

    //- set successors : 
    //- subtract absolute id with what is already cached

    //! #SU of child have been set during pre order (first visit).
    //! psrd->.* has been further updated for each SU(child) during pre order.
    //! difference (now during post order) is #SU contributed by this child.

    SymbolAllSuccessorsSet
	(phsleChild
	 , psrd->iInvisible - iInvisibleSuccessorsChild
	 , psrd->iPrincipal - iPrincipalSuccessorsChild
#ifdef TREESPACES_SUBSET_MECHANISM
	 , psrd->iMechanism - iMechanismSuccessorsChild
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , psrd->iSegment - iSegmentSuccessorsChild
#endif
	    );

    //- set (relative) serial for child

    //! the absolute serials have been set correctly during pre order.
    //! subtract to get serials relative to parent.

    SymbolAllSerialsToParentSet
	(phsleChild
	 , iInvisibleChild - iInvisibleParent
	 , iPrincipalChild - iPrincipalParent
#ifdef TREESPACES_SUBSET_MECHANISM
	 , iMechanismChild - iMechanismParent
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , iSegmentChild - iSegmentParent
#endif
	    );

    //- return result

    return(iResult);
}


int SymbolRecalcAllSerials
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    struct TreespaceTraversal *ptstr = NULL;

    struct PidinStack *ppistSerials;

    struct SerialRecalculationData srd =
    {
	//m next invisible ID

	0,

	//m next principal ID

	0,

#ifdef TREESPACES_SUBSET_MECHANISM
	//m next mechanism ID

	0,
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
	//m next segment ID

	0,
#endif
    };

    //- create context stack

    if (ppist && phsle)
    {
	ppistSerials = PidinStackDuplicate(ppist);
    }
    else
    {
	ppistSerials = PidinStackCalloc();

	PidinStackSetRooted(ppistSerials);

	phsle = PidinStackLookupTopSymbol(ppistSerials);
    }

    //- create treespace traversal to initialize

    //! initializes successors for all spaces with -1 as a way of 
    //! tagging the symbols.

    ptstr
	= TstrNew
	  (ppistSerials,
	   SymbolSerialInitializerSelector,
	   NULL,
	   SymbolSerialInitializerPreProcessor,
	   NULL,
	   SymbolSerialInitializerPostProcessor,
	   NULL);

    //- do traverse

    TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- create treespace traversal to recalculate serials

    ptstr
	= TstrNew
	  (ppistSerials,

	   //t the SymbolSerialRecalcSelector()
	   //t recalculates the number of successors in an illegal way,
	   //t I can't figure it out at the moment.
	   //t It seems to be fast enough without this boost,
	   //t so let as is for the moment,
	   //t worth an extra check.

/* 	   SymbolSerialRecalcSelector, */
/* 	   (void *)&srd, */
	   NULL,
	   NULL,
	   SymbolSerialRecalcPreProcessor,
	   (void *)&srd,
	   SymbolSerialRecalcPostProcessor,
	   (void *)&srd);

    //- do traverse

    TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- free allocated memory

    PidinStackFree(ppistSerials);

    //- set successors for given symbol

    SymbolAllSuccessorsSet
	(phsle
	 , srd.iInvisible
	 , srd.iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , srd.iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , srd.iSegment
#endif
	    );

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolSetAlgorithmInstanceInfo()
///
/// ARGS.:
///
///	phsle.: symbol to add algorithm info to
///	palgi.: algorithm instance
///
/// RTN..: int : success of operation
///
/// DESCR: Add algorithm info to symbol
///
/// **************************************************************************

int
SymbolSetAlgorithmInstanceInfo
(struct symtab_HSolveListElement *phsle,struct AlgorithmInstance *palgi)
{
    //- set default result : failure

    int bResult = FALSE;

    if (!phsle->palgi)
    {
	//- add algorithm info

	phsle->palgi = palgi;

/* 	//- set flag for algorithm info */

/* 	SymbolSetFlags(phsle,FLAGS_HSLE_ALGORITHM); */

	//- set result : success

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolSetParameterFixedDouble()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	dNumber: parameter value
///	ppist..: context of symbol.
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR:
///
///	High-level set / update parameter of symbol.
///
///	This function operates at treespace level, i.e. if you change
///	a parameter with this function, only this symbol
///	will have the given parameter value.  Note that references to
///	to the root of the given context will still share the
///	parameter value.
///
/// **************************************************************************

struct symtab_Parameters *
SymbolSetParameterFixedDouble
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 double dNumber,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- lookup base symbol

    struct symtab_HSolveListElement *phsleBase
	= PidinStackLookupBaseSymbol(ppist);

    //- set parameter value in base symbol

    int iSerial = PidinStackToSerial(ppist);

    pparResult
	= SymbolCacheParameterDouble(phsleBase, iSerial, pcName, dNumber);

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SymbolTraverseBioLevels()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike generators for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pbls........: level specification of levels to traverse
///	pfProcesor..: processor
///	pfFinalizer.: finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : see TstrGo().
///
/// DESCR:
///
///	Traverse all symbols above or within the indicated biolevel,
///	call pfProcessor and pfFinalizer on each of them.
///
/// **************************************************************************

static int 
BiolevelSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- get actual symbol type

    int iType = TstrGetActualType(ptstr);

    //- get pointer to selector data

    struct BiolevelSelection *pbls
	= (struct BiolevelSelection *)pvUserdata;

    //- if running in inclusive mode

    //! four way fork, depending on selection mode and relation
    //! between current and selected level.

    if (pbls->iMode == SELECTOR_BIOLEVEL_INCLUSIVE)
    {
	//- get level of actual symbol

	int iCurrentLevel = SymbolType2Biolevel(iType);

	//- if this level is lower than the selected one

	if (iCurrentLevel <= pbls->iLevel)
	{
	    //- select, process children too

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}

	//- else this level is higher than the selected one

	else
	{
	    //- do not process, continue with siblings

	    iResult = TSTR_SELECTOR_PROCESS_SIBLING;
	}
    }

    //- else running in exclusive mode

    else
    {
	//- get level of actual symbol

	int iCurrentLevel = SymbolType2Biolevel(iType);

	//- if this level is the selected one

	if (iCurrentLevel == pbls->iLevel)
	{
	    //- select, process children too

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}

	//- else

	else
	{
	    //t should optimize somewhat : e.g. depending on the
	    //t selected levels, we could return
	    //t SYMBOL_SELECTOR_PROCESS_SIBLING,
	    //t skipping entire subtrees.

	    //- do not process, continue with selection of children

	    iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
	}
    }

    //- return result

    return(iResult);
}


int SymbolTraverseBioLevels
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct BiolevelSelection *pbls,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- set user data

    pbls->pvUserdata = pvUserdata;

    //- allocate treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   BiolevelSelector,
	   (void *)pbls,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbols, looking for serial

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolTraverseTagged()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike generators for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: processor
///	pfFinalizer.: finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : see TstrGo().
///
/// DESCR:
///
///	Traverse all tagged symbols, call pfProcessor and pfFinalizer
///	on each of them.
///
/// **************************************************************************

static int 
TaggedSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- get actual symbol type

    int iType = TstrGetActualType(ptstr);

    //- if symbol is tagged

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iFlags = SymbolGetFlags(phsle);

    if (iFlags & FLAGS_HSLE_TRAVERSAL)
    {
	//- select, process children too

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

    //- else this level is higher than the selected one

    else
    {
	//- do not process, continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


int
SymbolTraverseTagged
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- allocate treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   TaggedSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbols, looking for serial

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SymbolTraverseWildcard()
///
/// ARGS.:
///
///	phsle........: symbol to traverse wildcard for
///	ppist........: context of symbol, symbol assumed to be on top
///	ppistWildcard: wildcard selector
///	pfProcesor...: processor
///	pfFinalizer..: finalizer
///	pvUserdata...: any user data
///
/// RTN..: int : see TstrGo().
///
/// DESCR:
///
///	Traverse all symbols that match the given wildcard.
///
/// **************************************************************************

static int 
WildcardSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get pointer to selector data

    struct PidinStack *ppistWildcard
	= (struct PidinStack *)pvUserdata;

    //t process siblings, or process only children, or process with
    //t children, or process and skip children

    //- if pidinstacks match

    if (PidinStackMatch(ptstr->ppist, ppistWildcard))
    {
	//- process with children

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }
    else
    {
	//- process only children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


int
SymbolTraverseWildcard
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- allocate treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   WildcardSelector,
	   (void *)ppistWildcard,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbols, looking for serial

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/////////// include automatically generated functions


#include "hierarchy/output/symbols/all_callees_implementations.c"


/// **************************************************************************
///
/// SHORT: SymbolAddChild()
///
/// ARGS.:
///
///	phsle......: symbol container.
///	phsleChild.: child to add.
///
/// RTN..: int : success of operation
///
/// DESCR: Add a child to the children of given symbol container.
///
///	Updates (sub)?space indices if symbol type has mappings.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolAssignBindableIO()
///
/// ARGS.:
///
///	phsle.: symbol.
///	pioc..: IO relations.
///
/// RTN..: int : success of operation.
///
/// DESCR: Assign bindable relations to symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolAssignInputs()
///
/// ARGS.:
///
///	phsle.: symbol.
///	pio...: inputs.
///
/// RTN..: int : success of operation.
///
/// DESCR: Assign inputs to symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolAssignParameters()
///
/// ARGS.:
///
///	phsle.: symbol.
///	ppar..: parameters.
///
/// RTN..: int : success of operation.
///
/// DESCR: Assign bindable relations to symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCountCells()
///
/// ARGS.:
///
///	phsle.: symbol to count cells for.
///	ppist.: context of symbol
///
/// RTN..: int : number of cells in symbol, -1 for failure.
///
/// DESCR: Count cells of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCountConnections()
///
/// ARGS.:
///
///	phsle.: symbol to count connections for.
///	ppist.: context of symbol
///
/// RTN..: int : number of connections in symbol, -1 for failure.
///
/// DESCR: Count connections of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCountSegments()
///
/// ARGS.:
///
///	phsle.......: symbol to count segments for
///	ppist.......: context of symbol, symbol assumed to be on top
///
/// RTN..: int
///
///	Number of segments, -1 for failure.
///
/// DESCR: Count segments.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCountSpikeGenerators()
///
/// ARGS.:
///
///	phsle.......: symbol to count spike generators for
///	ppist.......: context of symbol, symbol assumed to be on top
///
/// RTN..: int
///
///	Number of spike generators, -1 for failure.
///
/// DESCR: Count spike generators.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCountSpikeReceivers()
///
/// ARGS.:
///
///	phsle.......: symbol to count spike receivers for
///	ppist.......: context of symbol, symbol assumed to be on top
///
/// RTN..: int : success of operation
///
///	Number of spike receivers, -1 for failure.
///
/// DESCR: Count spike receivers.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolCreateAlias()
///
/// ARGS.:
///
///	pbio..: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_BioComponent * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetChildFromInput()
///
/// ARGS.:
///
///	phsle.: symbol that receives given input
///	pio...: input to search
///
/// RTN..: struct symtab_HSolveListElement * : symbol generating given input
///
/// DESCR: Look for symbol that generates given input
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetChildren()
///
/// ARGS.:
///
///	phsle....: symbol to get children from.
///
/// RTN..: IOHContainer * : symbol container.
///
/// DESCR: Get children from given symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetInputs()
///
/// ARGS.:
///
///	piol....: symbol to get inputs from.
///
/// RTN..: struct symtab_IOContainer * 
///
///	input container of symbol.
///
/// DESCR: Find inputs of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetModifiableParameter()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	ppist..: context of symbol
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR: Get parameter of symbol
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetName()
///
/// ARGS.:
///
///	phsle....: symbol to get name for.
///
/// RTN..: char * : name of symbol.
///
/// DESCR: Get name of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetOptions()
///
/// ARGS.:
///
///	phsle....: symbol to get options for.
///
/// RTN..: int : options.
///
/// DESCR: Get options of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetParameter()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	ppist..: context of symbol
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR: Get parameter of symbol
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetPidin()
///
/// ARGS.:
///
///	phsle....: symbol to get pidin for
///
/// RTN..: struct symtab_IdentifierIndex * : pidin of symbol
///
/// DESCR: Get pidin for symbol
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetPrototype()
///
/// ARGS.:
///
///	phsle......: symbol to get prototype for.
///
/// RTN..: struct symtab_HSolveListElement *
///
///	Prototype, NULL if none.
///
/// DESCR:
///
///	Get prototype of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolGetType()
///
/// ARGS.:
///
///	phsle......: symbol to get type for.
///
/// RTN..: int : type of symbol.
///
/// DESCR:
///
///	Get type of symbol.  See also SymbolSetType().
///
/// NOTE:
///
///	1. The exact semantics of this function is dependent on the
///	location of the type of the symbol in the symbol derivation
///	hierarchy.  Use or specific implementation of this function in
///	the symbol derivation hierarchy is strongly discouraged.  If
///	you think you need to use this function, try to use regular
///	derivation at first.  If that is not enough for you, contact
///	the author of Neurospaces (you probably need role based
///	derivation or meta object protocols.
///
///	2. This function is used at a very restricted set of places in
///	the code.  But that is not an encouragement to use this
///	function even more, read above, point (1).
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolHasBindableIO()
///
/// ARGS.:
///
///	phsle.: symbol to check.
///	pc....: name of input.
///	i.....: location of input.
///
/// RTN..: int : TRUE if symbol has bindable IO relations.
///
/// DESCR: Check if symbol has bindable IO relations.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolHasEquation()
///
/// ARGS.:
///
///	phsle.: symbol to check
///	ppist.: context of channel
///
/// RTN..: int : TRUE if symbol contains an equation.
///
/// DESCR: Check if symbol contains an equation.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolHasMGBlockGk()
///
/// ARGS.:
///
///	phsle.: channel to check
///
/// RTN..: int : TRUE if symbol has MG blocking
///
/// DESCR: Check if symbol Gk MG blocking dependent
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolHasNernstEk()
///
/// ARGS.:
///
///	phsle.: channel to check
///
/// RTN..: int : TRUE if symbol has nernst
///
/// DESCR: Check if symbol Ek nernst-equation controlled
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolParameterLinkAtEnd()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for.
///	ppars..: new list of parameters.
///
/// RTN..: int : success of operation.
///
/// DESCR: Add new paramaters, not overriding existing ones.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolLookupHierarchical()
///
/// ARGS.:
///
///	phsle..: symbol container.
///	ppist..: element to search.
///	iLevel.: active level of ppist,
///		0 <= iLevel < PidinStackNumberOfEntries().
///	bAll...: set TRUE if all names in ppist should be searched.
///
/// RTN..: struct symtab_HSolveListElement * : searched symbol.
///
/// DESCR: lookup a hierarchical symbol name in another symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolLookupSerialID()
///
/// ARGS.:
///
///	phsleCont..: symbol container
///	ppistCont..: context of container
///	phsleSerial: element to search
///	ppistSerial: context of element to search
///
/// RTN..: int : serial ID of symbol with respect to container, -1 for failure
///
/// DESCR: Get a serial unique ID for symbol with respect to container
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolParameterResolveValue()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	ppist..: context of symbol
///
/// RTN..: double : parameter value, FLT_MAX if some error occured
///
/// DESCR: Resolve value of parameter
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolParameterScaleValue()
///
/// ARGS.:
///
///	phsle...: symbol to do scaling
///	ppist...: context of given element
///	dValue..: value to scale
///	ppar....: parameter that specifies type of scaling
///
/// RTN..: double : scaled value, FLT_MAX for failure
///
/// DESCR: Scale value according to parameter type and symbol type
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolPrint()
///
/// ARGS.:
///
///	phsle....: symbol to print
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print symbol
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolResolveInput()
///
/// ARGS.:
///
///	phsle....: symbol to resolve input for
///	ppist....: context of given element
///	pcName...: name of input to resolve
///	iPosition: number of inputs with given name to skip
///
/// RTN..: struct symtab_HSolveListElement *
///
///	symbol table element generating input, NULL for non-existent
///
/// DESCR: Find input with given name
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolResolveParameterFunctionalInput()
///
/// ARGS.:
///
///	phsle......: symbol to resolve input for
///	ppist......: context of given element
///	pcParameter: name of parameter with function
///	pcInput....: name of input on function of parameter
///	iPosition..: input identifier in instantiation
///
/// RTN..: struct symtab_HSolveListElement * : symbol that gives input
///
/// DESCR: Find input to functional parameter
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetAtXYZ()
///
/// ARGS.:
///
///	phsle.: symbol to set coordinates for.
///	x.....:
///	y.....:
///	z.....:
///
/// RTN..: int : success of operation
///
/// DESCR: Set coordinates for symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetName()
///
/// ARGS.:
///
///	phsle.: symbol to set name of
///	pidin.: name.
///
/// RTN..: int : success of operation
///
/// DESCR: Set name of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetOptions()
///
/// ARGS.:
///
///	phsle....: symbol to set parameter for.
///	iOptions.: options for symbol.
///
/// RTN..: int : success of operation.
///
/// DESCR: Set options of symbol.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetParameterDouble()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	dNumber: parameter value
///	ppist..: context of symbol (not used at the moment, can be changed)
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR:
///
///	Low-level set / update parameter of symbol.
///
///	This function operates at forestspace level, i.e. if you
///	change a parameter with this function, all references to this
///	symbol will share that value, unless they have a value that
///	overwrites the one given to this function.  To set a parameter
///	at treespace level, use one of the SymbolSetParameterFixed.*()
///	functions.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetParameterString()
///
/// ARGS.:
///
///	phsle..: symbol to get parameter for
///	pcName.: name of parameter
///	pcValue: parameter value
///	ppist..: context of symbol (not used at the moment, can be changed)
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR:
///
///	Low-level set / update parameter of symbol.
///
///	This function operates at forestspace level, i.e. if you
///	change a parameter with this function, all references to this
///	symbol will share that value, unless they have a value that
///	overwrites the one given to this function.  To set a parameter
///	at treespace level, use one of the SymbolSetParameterFixed.*()
///	functions.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetPrototype()
///
/// ARGS.:
///
///	phsle......: symbol to set prototype for.
///	phsleProto.: prototype symbol.
///
/// RTN..: int : success of operation.
///
/// DESCR:
///
///	Set prototype of symbol.
///
///	The symbol uses the prototype symbol for inferences when needed.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolSetType()
///
/// ARGS.:
///
///	phsle......: symbol to get type for.
///	iType......: type of symbol.
///
/// RTN..: int : success of operation.
///
/// DESCR:
///
///	Set type of symbol.  See also SymbolGetType().
///
/// NOTE:
///
///	1. The exact semantics of this function is dependent on the
///	location of the type of the symbol in the symbol derivation
///	hierarchy.  Use or specific implementation of this function in
///	the symbol derivation hierarchy is strongly discouraged.  If
///	you think you need to use this function, try to use regular
///	derivation at first.  If that is not enough for you, contact
///	the author of Neurospaces (you probably need role based
///	derivation or meta object protocols.
///
///	2. This function is used at a very restricted set of places in
///	the code.  But that is not an encouragement to use this
///	function even more, read above, point (1).
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolTraverse()
///
/// ARGS.:
///
///	ptstr.: initialized treespace traversal
///	phsle.: symbol to traverse
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse symbols in tree manner.
///
/// NOTE.: See IOHierarchyTraverse()
///
///	Note that not all symbols are required to have a pidin.
///	Interfaces with Tstr{Prepare,Traverse,Repair}() :
///
///	Loops over children of top symbol
///		1. Calls TstrPrepare()
///		2. Calls TstrTraverse()
///		3. Calls TstrRepair()
///
///	Use Tstr.*() to obtain info on serial IDs and contexts
///	during traversals.
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolTraverseSegments()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse segments for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: segment processor
///	pfFinalizer.: segment finalizer
///	pvUserdata..: any user data
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse segments, call pfProcessor on each of them
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolTraverseSpikeGenerators()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike generators for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: spike generator processor
///	pfFinalizer.: spike generator finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : success of operation
///
/// DESCR: Traverse spike generators, call pfProcessor on each of them
///
/// **************************************************************************


/// **************************************************************************
///
/// SHORT: SymbolTraverseSpikeReceivers()
///
/// ARGS.:
///
///	phsle.......: symbol to traverse spike receivers for
///	ppist.......: context of symbol, symbol assumed to be on top
///	pfProcesor..: spike receiver processor
///	pfFinalizer.: spike receiver finalizer
///	pvUserdata..: any user data
///
/// RTN..: int : see TstrGo()
///
/// DESCR: Traverse spike receivers, call pfProcessor on each of them
///
/// **************************************************************************


