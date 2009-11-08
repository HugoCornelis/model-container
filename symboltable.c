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
//' Copyright (C) 1999-2008 Hugo Cornelis
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

#include "neurospaces/biolevel.h"
#include "neurospaces/cachedparameter.h"
#include "neurospaces/components/algorithmsymbol.h"
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/axonhillock.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/connection.h"
#include "neurospaces/components/equationexponential.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/iohier.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/pool.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/pulsegen.h"
#include "neurospaces/components/randomvalue.h"
#include "neurospaces/components/root.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/components/vectorsegment.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/parametercache.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/workload.h"


#include "hierarchy/output/symbols/long_descriptions.c"

#include "hierarchy/output/symbols/short_descriptions.c"

#include "hierarchy/output/symbols/textual_descriptions.c"


/// global number of allocated symbols

int iTotalAllocatedSymbols = 0;


/// number of created aliases for biocomponents

int iCreatedAliases = 0;

/// number of created aliases for biocomponents by type, 
/// first entry (the null type that cannot be aliased) 
/// contains number of valid entries (inclusive).

int piCreatedAliases[COUNT_HIERARCHY_TYPE_symbols + 1] =
{
    COUNT_HIERARCHY_TYPE_symbols + 1,
};


// local functions


TreespaceTraversalProcessor SymbolDeleter;


/// \todo would be great to put all the selectors and processors in a
/// \todo library

/// \note note that deletions are only possible during finalization.

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


/// 
/// \arg phsle symbol to get ID for.
/// 
/// \return char *
/// 
///	Unique string representation identifying this symbol content.
/// 
/// \brief Get ID identifying this symbol content.
/// 
/// \note 
/// 
/// 	The result is a pointer to static memory that gets overwitten
/// 	on each call to this function.
/// 

char *
BaseSymbolGetID(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result: none

    char *pcResult = NULL;

    //- define result

    static char pc[100];

    if (sprintf(pc, "%p", phsle) >= 0)
    {
	pcResult = pc;
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg phsle symbol to use for caching.
/// \arg iSerial serial to use for caching, context of parameter.
/// \arg pcName name of parameter.
/// \arg dNumber value of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Newly allocated parameters, NULL for failure.
/// 
/// \details 
/// 
///	Allocate a parameter for the given value and insert it in the
///	parameter cache of the given symbol.
/// 

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


/// 
/// \arg phsle symbol to use for caching.
/// \arg iSerial serial to use for caching, context of parameter.
/// \arg pcName name of parameter.
/// \arg pcValue value of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Newly allocated parameters, NULL for failure.
/// 
/// \details 
/// 
///	Allocate a parameter for the given value and insert it in the
///	parameter cache of the given symbol.
/// 

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


/// 
/// \arg std ANSI calloc() parameters.
/// \arg _vtable function table.
/// \arg iType type of element.
/// 
/// \return struct symtab_HSolveListElement * 
/// 
///	Newly allocated symbol, NULL for failure.
/// 
/// \brief Allocate a new symbol table element.
/// 

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

    //- increment number of allocated symbols

    iTotalAllocatedSymbols++;

    //- register allocation identifier

    phsleResult->iAllocationIdentifier = iTotalAllocatedSymbols;

    //- return result

    return(phsleResult);
}


/// 
/// \arg phsle symbol to find parameter of.
/// \arg pcName name of parameter.
/// \arg ppist context of symbol.
/// 
/// \return struct symtab_Parameters * : parameter structure.
/// 
/// \details 
/// 
///	Consulte caches as appropriate for the given context, and try
///	to find the parameter with given name.
/// 

struct symtab_Parameters *
SymbolFindCachedParameter
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- update context caches

    /// \todo how can I get around this hack in a clean way ?

    /// \todo I force to have at least one symbol in the context cache, such
    /// \todo that caches can be updated.

/*     if (ppist->symsst.symst.iTop == -1) */
/*     { */
/* 	/// \todo how can we possibly find out the root here ? */

/* 	/// \todo actually this should not happen, so we make the caller */
/* 	/// \todo responsible for giving an appropriate ppist, this will */
/* 	/// \todo generate a SEGV to force this behaviour. */

/* 	struct symtab_HSolveListElement *phsleRoot = NULL; */

/* 	int bResult = PSymbolSerialStackPush(&ppist->symsst, phsleRoot); */
/*     } */

    if (!PidinStackUpdateCaches(ppist))
    {
	fprintf(stderr, "Cannot update context caches in SymbolFindCachedParameter()\n");

	return(NULL);
    }

    //- set serial

    int iSerial = PidinStackToSerial(ppist);

/*     if (PidinStackIsRooted(ppist)) */
/*     { */
/* 	/// \note skip root, cannot cache parameters */

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

	/// \todo more hacking to be removed

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


/// 
/// \arg phsle symbol to find parameter of.
/// \arg pcName name of parameter.
/// \arg ppist context of symbol.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \details 
/// 
///	Find parameter of symbol, consulting caches as appropriate for
///	the given context.
/// 

struct symtab_Parameters *
SymbolFindParameter
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- if the parameter is in the caches

    pparResult = SymbolFindCachedParameter(phsle, ppist, pcName);

    if (pparResult)
    {
	//- return this parameter

	return(pparResult);
    }

    //- regular lookup of the parameter

    pparResult = SymbolGetParameter(phsle, ppist, pcName);

    //- return result

    return(pparResult);
}


/// 
/// \arg phsle symbol.
/// \arg ppist symbol context.
/// 
/// \return struct PidinStack *
/// 
///	Context of parent segment, NULL for failure.
/// 
/// \brief Find the parent segment that contains the given symbol.
/// 

struct PidinStack *
SymbolFindParentSegment
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result: failure

    struct PidinStack *ppistResult = NULL;

    struct PidinStack *ppistComp
	= PidinStackDuplicate(ppist);

    //- get top symbol

    struct symtab_HSolveListElement *phsleComp
	= PidinStackLookupTopSymbol(ppistComp);

    struct symtab_IdentifierIndex *pidinComp
	= PidinStackTop(ppistComp);

    //- while not segment

    while (pidinComp && phsleComp && !instanceof_segment(phsleComp))
    {
	//- pop element

	// \note that pidinComp can be NULL while phsleComp is a root
	// symbol, that is a perfectly legal situation.

	pidinComp = PidinStackPop(ppistComp);

	phsleComp = PidinStackLookupTopSymbol(ppistComp);
    }

    //- set result

    if (phsleComp && instanceof_segment(phsleComp))
    {
	ppistResult = ppistComp;
    }
    else
    {
	PidinStackFree(ppistComp);
    }

    //- return result

    return(ppistResult);
}


/// 
/// \arg phsle symbol to free.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Free memory of a symbol table element
/// 

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


/// 
/// \arg phsle symbol to get algorithm info for
/// 
/// \return struct AlgorithmInstance * : algorithm instance
/// 
/// \brief Get algorithm info for symbol
/// 

struct AlgorithmInstance *
SymbolGetAlgorithmInstanceInfo(struct symtab_HSolveListElement *phsle)
{
    //- return result : from symbol

    return(phsle->palgi);
}


/// 
/// \arg phsle symbol to get individual workload for.
/// \arg ppist context of symbol
/// 
/// \return int
/// 
///	Workload for this symbol (not including descendants) expressed
///	in workload units, -1 for failure.
/// 
/// \brief Get workload for this symbol.
/// 

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

    //t some weird testing going on here: why not just using instanceof ?

    else if (in_dimension_mechanism(phsle))
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


/// 
/// \arg phsle symbol to init.
/// 
/// \return void
/// 
/// \brief Init a new symbol table element
/// 

void SymbolInit(struct symtab_HSolveListElement * phsle)
{
/*     //- zero out struct */

/*     memset(phsle, 0, sizeof(*phsle)); */

    //- clear serial mapping info

    SymbolAllSerialsClear(phsle);
}


/// 
/// \arg phsle symbol container
/// \arg ppist context of symbol
/// \arg ppistCoord context to get coordinate for
/// \arg pD3Coord coordinate receiving result (may be uninitialized)
/// 
/// \return int : success of operation
///
/// \return pD3Coord coordinate receiving result
/// 
/// \brief Resolve coordinates for symbol.
///
/// \details 
/// 
///	Coordinate values are by default relative to parent.  
///	This functions (and related) recalculates the coordinate values
///	to make them relative to the given context.  ppistCoord must
///	be part of ppist, otherwise this function will give faulty 
///	results without errors.  Coordinates are 'X', 'Y', 'Z' symbol
///	parameters.
/// 

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

    /// \todo I'm also not sure if I should check here the parameter type,
    /// \todo it's also done by SymbolParameterTransformValue().  
    /// \todo I think the default parameter handler (where this function is
    /// \todo is supposed to be part of that default handler), should not
    /// \todo test, so commented out for the moment.

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
		= SymbolFindParameter(phsleWorking, ppistWorking, "X");

	    struct symtab_Parameters *pparY
		= SymbolFindParameter(phsleWorking, ppistWorking, "Y");

	    struct symtab_Parameters *pparZ
		= SymbolFindParameter(phsleWorking, ppistWorking, "Z");

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

	    dResolvedX = ParameterResolveValue(pparX, ppistWorking);
	    dResolvedY = ParameterResolveValue(pparY, ppistWorking);
	    dResolvedZ = ParameterResolveValue(pparZ, ppistWorking);

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
		      (phsleWorking, ppistWorking, pparX, pD3Coord);
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


/// 
/// \arg phsle symbol container
/// \arg ppist context of symbol
/// \arg ppistCoord context to get coordinate for
/// \arg pcName name of parameter ("X", "Y", "Z")
/// 
/// \return double : coordinate parameter value, FLT_MAX if some error occured
/// 
/// \brief Resolve coordinate value of parameter
///
/// \details 
/// 
///	Coordinate values are by default relative to parent.  
///	This functions (and related) recalculates the coordinate values
///	to make them relative to the given context.  ppistCoord must
///	be part of ppist, otherwise this function will give faulty 
///	results without errors.
/// 

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

    /// \todo I'm also not sure if I should check here the parameter type,
    /// \todo it's also done by SymbolParameterTransformValue().  
    /// \todo I think the default parameter handler (where this function is
    /// \todo is supposed to be part of that default handler), should not
    /// \todo test, so commented out for the moment.

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
		= SymbolFindParameter(phsleWorking, ppistWorking, "X");

	    struct symtab_Parameters *pparY
		= SymbolFindParameter(phsleWorking, ppistWorking, "Y");

	    struct symtab_Parameters *pparZ
		= SymbolFindParameter(phsleWorking, ppistWorking, "Z");

	    if (!pparX || !pparY || !pparZ)
	    {
		D3Value.dx = FLT_MAX;
		D3Value.dy = FLT_MAX;
		D3Value.dz = FLT_MAX;

		break;
	    }

	    //- resolve values

	    dResolvedX = ParameterResolveValue(pparX, ppistWorking);
	    dResolvedY = ParameterResolveValue(pparY, ppistWorking);
	    dResolvedZ = ParameterResolveValue(pparZ, ppistWorking);

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
		  (phsleWorking, ppistWorking, pparX, &D3Value);

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


/// 
/// \arg phsle symbol to get parameter for
/// \arg ppist context of symbol
/// \arg pcName name of parameter
/// 
/// \return double : scaled parameter value, FLT_MAX if some error occured
/// 
/// \brief Resolve scaled value of parameter
/// 

double
SymbolParameterResolveScaledValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- lookup parameter

    struct symtab_Parameters *ppar = SymbolFindParameter(phsle, ppist, pcName);

    //- if found

    if (ppar)
    {
	//- resolve value

	dResult = ParameterResolveScaledValue(ppar, ppist);
    }

    //- return result

    return(dResult);
}


/// 
/// \arg phsle symbol to calculate absolute value
/// \arg ppist context of given element
/// \arg ppar parameter that specifies type of transformation
/// \arg pD3 coordinate to make transform
/// 
/// \return int success of operation
/// 
/// \return pD3 transformed coordinate
/// 
/// \brief Calculate transformation on value for given parameter.
/// 

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

    //t movable_parameter_name()

    if ((pcName[0] == 'X' || pcName[0] == 'Y' || pcName[0] == 'Z')
	&& pcName[1] == '\0')

    {
	//- if this is a movable symbol

	if (in_dimension_movable(phsle))
	{
	    ///
	    /// \todo what is really needed :
	    ///
	    /// \todo 3 angles : theta, phi ,rho
	    /// \todo 2 offsets : {x,y,z}1, {x,y,z}2
	    /// \todo     one applied before rotation, one after rotation
	    /// \todo     both default to origin
	    /// \todo     this allows to do fancy things like 
	    /// \todo         x1 = soma->X, x2 = - soma->X
	    ///
	    /// \todo can be done with one matrix multiplication ?
	    /// \todo 

	    //- get position parameters

	    double x = pD3->dx;
	    double y = pD3->dy;
	    double z = pD3->dz;

	    //- get rotation parameters

	    struct symtab_Parameters *pparAngle
		= SymbolFindParameter(phsle, ppist,"ROTATE_ANGLE");

	    struct symtab_Parameters *pparCenterX
		= SymbolFindParameter(phsle, ppist,"ROTATE_CENTER_X");

	    struct symtab_Parameters *pparCenterY
		= SymbolFindParameter(phsle, ppist,"ROTATE_CENTER_Y");

	    struct symtab_Parameters *pparCenterZ
		= SymbolFindParameter(phsle, ppist,"ROTATE_CENTER_Z");

	    struct symtab_Parameters *pparAxisX
		= SymbolFindParameter(phsle, ppist,"ROTATE_AXIS_X");

	    struct symtab_Parameters *pparAxisY
		= SymbolFindParameter(phsle, ppist,"ROTATE_AXIS_Y");

	    struct symtab_Parameters *pparAxisZ
		= SymbolFindParameter(phsle, ppist,"ROTATE_AXIS_Z");

	    //- resolve values for rotation parameters

	    double dAngle
		= pparAngle
		  ? ParameterResolveValue(pparAngle, ppist)
		  : 0.0 ;

	    double dCenterX
		= pparCenterX
		  ? ParameterResolveValue(pparCenterX, ppist)
		  : 0.0 ;

	    double dCenterY
		= pparCenterY
		  ? ParameterResolveValue(pparCenterY, ppist)
		  : 0.0 ;

	    double dCenterZ
		= pparCenterZ
		  ? ParameterResolveValue(pparCenterZ, ppist)
		  : 0.0 ;

	    double dAxisX
		= pparAxisX
		  ? ParameterResolveValue(pparAxisX, ppist)
		  : 0.0 ;

	    double dAxisY
		= pparAxisY
		  ? ParameterResolveValue(pparAxisY, ppist)
		  : 0.0 ;

	    double dAxisZ
		= pparAxisZ
		  ? ParameterResolveValue(pparAxisZ, ppist)
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


/// 
/// \arg phsle symbol container.
/// \arg ppist context of given element
/// \arg iPrincipal principal serial ID for sub-symbol.
/// 
/// \return struct PidinStack *
/// 
///	symbol corresponding to iPrincipal, NULL for failure
/// 
/// \brief Convert principal serial ID to symbol info.
/// 

struct SymbolPrincipal2ContextData
{
    /// result of operation: uninitialized means result context
    /// will be based on the given context

    struct PidinStack *ppistResult;

    /// number of skipped successors

    int iSkippedSuccessors;

    /// relative principal ID

    int iPrincipal;
};


static
int 
SymbolPrincipal2SymbolSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
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
	fprintf
	    (stderr,
	     "SymbolPrincipalSerial2Context() :"
	     " internal error: zero serial\n");

	//- remove result

	if (psip2c->ppistResult)
	{
	    PidinStackFree(psip2c->ppistResult);

	    psip2c->ppistResult = NULL;
	}

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

	//- if there is a result

	if (psip2c->ppistResult)
	{
	    //- push current symbol to the result

	    PidinStackPushSymbol(psip2c->ppistResult, phsle);
	}

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


static
int 
SymbolPrincipal2SymbolConvertor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
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
	//- if there is a result

	if (psip2c->ppistResult)
	{
/* 	    //- push current symbol to the result */

/* 	    PidinStackPushSymbol(psip2c->ppistResult, phsle); */
	}

	//- no result yet

	else
	{
	    //- initialize result: context of current symbol

	    psip2c->ppistResult = PidinStackDuplicate(ptstr->ppist);
	}

	//- we are done, abort traversal

	return(TSTR_PROCESSOR_ABORT);
    }

    //- if #SU < relative principal ID

    if (iSuccessors < psip2c->iPrincipal)
    {
	fprintf
	    (stderr,
	     "SymbolPrincipalSerial2Context() :"
	     " internal error: #SU < serial\n");

	//- remove result

	if (psip2c->ppistResult)
	{
	    PidinStackFree(psip2c->ppistResult);

	    psip2c->ppistResult = NULL;
	}

	//- we have an internal error : abort

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- if negative serial

    if (psip2c->iPrincipal < 0)
    {
	fprintf
	    (stderr,
	     "SymbolPrincipalSerial2Context() :"
	     " internal error: negative serial\n");

	//- remove result

	if (psip2c->ppistResult)
	{
	    PidinStackFree(psip2c->ppistResult);

	    psip2c->ppistResult = NULL;
	}

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

    /// treespace traversal to go over successors

    struct TreespaceTraversal *ptstr = NULL;

    int iTraversal = 0;

    /// number of successors for top of solved symbol tree

    int iSuccessors = 0;

    /// traversal user data

    struct SymbolPrincipal2ContextData sip2c =
    {
	/// result of operation: uninitialized means result context
	/// will be based on the given context

	NULL,

	/// number of skipped successors

	0,

	/// relative principal ID

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

    //- duplicate given context

    sip2c.ppistResult = PidinStackDuplicate(ppist);

    //- if this symbol requested

    if (iPrincipal == 0)
    {
	//- set result

	ppistResult = sip2c.ppistResult;

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

    iTraversal = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- set result from traversal data

    ppistResult = sip2c.ppistResult;

    //- return result

    return(ppistResult);
}


struct PidinStack *
SymbolPrincipalSerial2RelativeContext
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 int iPrincipal)
{
    //- set default result : not found

    struct PidinStack *ppistResult = NULL;

    /// treespace traversal to go over successors

    struct TreespaceTraversal *ptstr = NULL;

    int iTraversal = 0;

    /// number of successors for top of solved symbol tree

    int iSuccessors = 0;

    /// traversal user data

    struct SymbolPrincipal2ContextData sip2c =
    {
	/// result of operation: uninitialized means result context
	/// will be based on the given context

	NULL,

	/// number of skipped successors

	0,

	/// relative principal ID

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

    sip2c.ppistResult = PidinStackParse(".");

    //- if this symbol requested

    if (iPrincipal == 0)
    {
	//- current result

	ppistResult = sip2c.ppistResult;

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

    iTraversal = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- set result from traversal data

    ppistResult = sip2c.ppistResult;

    //- return result

    return(ppistResult);
}


/// 
/// \arg phsle symbol to resolve input for
/// \arg ppist context of given element, may be NULL
/// 
/// \return int : success of operation
/// 
/// \brief Recalculate all serial mappings of given symbol
///
/// \details 
/// 
///	For the given symbol only \#SU is updated, the serial to
///	parent is not touched (it's not known here).
/// 

struct SerialRecalculationData
{
    /// next invisible ID

    int iInvisible;

    /// next principal ID

    int iPrincipal;

#ifdef TREESPACES_SUBSET_MECHANISM
    /// next mechanism ID

    int iMechanism;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    /// next segment ID

    int iSegment;
#endif

/*     /// successors for each depth */

/*     int iSuccessors[20]; */

/*     /// serial to parent for each depth */

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

    /// \todo must choose exactly one of those two, not sure which one, but
    /// \todo is harmless to use both of them (I think).

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

    /// \todo if left child
    /// \todo     serial for left child is known
    /// \todo     number of successors for left child
    /// \todo     set serial for current child
    ///
    /// \todo else
    /// \todo     set serial for current child to one/instanceof(mapping)
    ///
    /// \todo set #SU to zero

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

    /// \note #SU of child have been set during pre order (first visit).
    /// \note psrd->.* has been further updated for each SU(child) during pre order.
    /// \note difference (now during post order) is #SU contributed by this child.

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

    /// \note the absolute serials have been set correctly during pre order.
    /// \note subtract to get serials relative to parent.

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
	/// next invisible ID

	0,

	/// next principal ID

	0,

#ifdef TREESPACES_SUBSET_MECHANISM
	/// next mechanism ID

	0,
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
	/// next segment ID

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

    /// \note initializes successors for all spaces with -1 as a way of 
    /// \note tagging the symbols.

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

	   /// \todo the SymbolSerialRecalcSelector()
	   /// \todo recalculates the number of successors in an illegal way,
	   /// \todo I can't figure it out at the moment.
	   /// \todo It seems to be fast enough without this boost,
	   /// \todo so let as is for the moment,
	   /// \todo worth an extra check.

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


/// 
/// \arg phsle symbol to add algorithm info to
/// \arg palgi algorithm instance
/// 
/// \return int : success of operation
/// 
/// \brief Add algorithm info to symbol
/// 

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


/// 
/// \arg phsle symbol to get parameter for
/// \arg ppist context of symbol.
/// \arg pcName name of parameter
/// \arg dValue: parameter value
/// 
/// \return struct symtab_Parameters *  parameter structure
/// 
/// \details 
/// 
///	High-level set / update parameter of symbol.
/// 
///	This function operates at treespace level, i.e. if you change
///	a parameter with this function, only this symbol
///	will have the given parameter value.  Note that references to
///	the root of the given context will still share the parameter
///	value.
/// 

struct symtab_Parameters *
SymbolSetParameterFixedDouble
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName,
 double dValue)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- lookup base symbol

    struct symtab_HSolveListElement *phsleBase
	= PidinStackLookupBaseSymbol(ppist);

    //- set parameter value in base symbol

    int iSerial = PidinStackToSerial(ppist) - SymbolGetPrincipalSerialToParent(phsleBase);;

/*     printf("iSerial = %i\n", iSerial); */

    pparResult
	= SymbolCacheParameterDouble(phsleBase, iSerial, pcName, dValue);

    //- if the target symbol is a biocomp

    if (instanceof_bio_comp(phsle))
    {
	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	//- assign a unique prototype identifier

	BioComponentAssignUniquePrototypeID(pbio);
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg phsle symbol to get parameter for
/// \arg ppist context of symbol.
/// \arg pcName name of parameter
/// \arg pcValue parameter value
/// 
/// \return struct symtab_Parameters *  parameter structure
/// 
/// \details 
/// 
///	High-level set / update parameter of symbol.
/// 
///	This function operates at treespace level, i.e. if you change
///	a parameter with this function, only this symbol
///	will have the given parameter value.  Note that references to
///	the root of the given context will still share the parameter
///	value.
/// 

struct symtab_Parameters *
SymbolSetParameterFixedString
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName,
 char *pcValue)
{
    //- set default result : failure

    struct symtab_Parameters * pparResult = NULL;

    //- lookup base symbol

    struct symtab_HSolveListElement *phsleBase
	= PidinStackLookupBaseSymbol(ppist);

    //- set parameter value in base symbol

    int iSerial = PidinStackToSerial(ppist) - SymbolGetPrincipalSerialToParent(phsleBase);;

    pparResult
	= SymbolCacheParameterString(phsleBase, iSerial, pcName, pcValue);

    //- if the target symbol is a biocomp

    if (instanceof_bio_comp(phsle))
    {
	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	//- assign a unique prototype identifier

	BioComponentAssignUniquePrototypeID(pbio);
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg phsle symbol to traverse spike generators for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pbls level specification of levels to traverse
/// \arg pfProcesor processor
/// \arg pfFinalizer finalizer
/// \arg pvUserdata any user data
/// 
/// \return int : see TstrGo().
/// 
/// \details 
/// 
///	Traverse all symbols above or within the indicated biolevel,
///	call pfProcessor and pfFinalizer on each of them.
/// 

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

    /// \note four way fork, depending on selection mode and relation
    /// \note between current and selected level.

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
	    /// \todo should optimize somewhat : e.g. depending on the
	    /// \todo selected levels, we could return
	    /// \todo SYMBOL_SELECTOR_PROCESS_SIBLING,
	    /// \todo skipping entire subtrees.

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


/// 
/// \arg phsle symbol to traverse wildcard for.
/// \arg ppist context of symbol, symbol assumed to be on top.
/// \arg pfProcesor processor.
/// \arg pfFinalizer finalizer.
/// \arg pvUserdata any user data.
/// 
/// \return int : see TstrGo().
/// 
/// \details 
/// 
///	Traverse all symbols using the default selector.
/// 

int
SymbolTraverseDescendants
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
	   NULL,
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


/* ///  */
/* /// \arg phsle symbol to traverse spike generators for. */
/* /// \arg ppist context of symbol, symbol assumed to be on top. */
/* /// \arg pfProcesor processor. */
/* /// \arg pfFinalizer finalizer. */
/* /// \arg pvUserdata any user data. */
/* ///  */
/* /// \return int : see TstrGo(). */
/* ///  */
/* /// \details  */
/* ///  */
/* ///	Traverse all tagged symbols, call pfProcessor and pfFinalizer */
/* ///	on each of them. */
/* ///  */

/* static int  */
/* TaggedSelector */
/* (struct TreespaceTraversal *ptstr, void *pvUserdata) */
/* { */
/*     //- set default result : process children of this symbol */

/*     int iResult = TSTR_SELECTOR_PROCESS_CHILDREN; */

/*     //- get actual symbol type */

/*     int iType = TstrGetActualType(ptstr); */

/*     //- if symbol is tagged */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

/*     int iFlags = SymbolGetFlags(phsle); */

/*     if (iFlags & FLAGS_HSLE_TRAVERSAL) */
/*     { */
/* 	//- select, process children too */

/* 	iResult = TSTR_SELECTOR_PROCESS_CHILDREN; */
/*     } */

/*     //- else this level is higher than the selected one */

/*     else */
/*     { */
/* 	//- do not process, continue with children */

/* 	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* int */
/* SymbolTraverseTagged */
/* (struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist, */
/*  TreespaceTraversalProcessor *pfProcesor, */
/*  TreespaceTraversalProcessor *pfFinalizer, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : ok */

/*     int iResult = 1; */

/*     //- allocate treespace traversal */

/*     struct TreespaceTraversal *ptstr */
/* 	= TstrNew */
/* 	  (ppist, */
/* 	   TaggedSelector, */
/* 	   NULL, */
/* 	   pfProcesor, */
/* 	   pvUserdata, */
/* 	   pfFinalizer, */
/* 	   pvUserdata); */

/*     //- traverse symbols, looking for serial */

/*     iResult = TstrGo(ptstr,phsle); */

/*     //- delete treespace traversal */

/*     TstrDelete(ptstr); */

/*     //- return result */

/*     return(iResult); */
/* } */


/// 
/// \arg phsle symbol to traverse wildcard for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg ppistWildcard: wildcard selector
/// \arg pfProcesor processor
/// \arg pfFinalizer finalizer
/// \arg pvUserdata any user data
/// 
/// \return int : see TstrGo().
/// 
/// \details 
/// 
///	Traverse all symbols that match the given wildcard.
/// 

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

    /// \todo process siblings, or process only children, or process with
    /// \todo children, or process and skip children

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


/// 
/// \arg phsle symbol container.
/// \arg phsleChild child to add.
/// 
/// \return int : success of operation
/// 
/// \brief Add a child to the children of given symbol container.
///
/// \details 
/// 
///	Updates (sub)?space indices if symbol type has mappings.
/// 


/// 
/// \arg phsle symbol.
/// \arg pioc IO relations.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign bindable relations to symbol.
/// 


/// 
/// \arg phsle symbol.
/// \arg pio inputs.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign inputs to symbol.
/// 


/// 
/// \arg phsle symbol.
/// \arg ppar parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign bindable relations to symbol.
/// 


/// 
/// \arg phsle symbol to count cells for.
/// \arg ppist context of symbol
/// 
/// \return int : number of cells in symbol, -1 for failure.
/// 
/// \brief Count cells of symbol.
/// 


/// 
/// \arg phsle symbol to count connections for.
/// \arg ppist context of symbol
/// 
/// \return int : number of connections in symbol, -1 for failure.
/// 
/// \brief Count connections of symbol.
/// 


/// 
/// \arg phsle symbol to count segments for
/// \arg ppist context of symbol, symbol assumed to be on top
/// 
/// \return int
/// 
///	Number of segments, -1 for failure.
/// 
/// \brief Count segments.
/// 


/// 
/// \arg phsle symbol to count spike generators for
/// \arg ppist context of symbol, symbol assumed to be on top
/// 
/// \return int
/// 
///	Number of spike generators, -1 for failure.
/// 
/// \brief Count spike generators.
/// 


/// 
/// \arg phsle symbol to count spike receivers for
/// \arg ppist context of symbol, symbol assumed to be on top
/// 
/// \return int : success of operation
/// 
///	Number of spike receivers, -1 for failure.
/// 
/// \brief Count spike receivers.
/// 


/// 
/// \arg pbio symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_BioComponent * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 


/// 
/// \arg phsle symbol that receives given input
/// \arg pio input to search
/// 
/// \return struct symtab_HSolveListElement * : symbol generating given input
/// 
/// \brief Look for symbol that generates given input
/// 


/// 
/// \arg phsle symbol to get children from.
/// 
/// \return IOHContainer * : symbol container.
/// 
/// \brief Get children from given symbol.
/// 


/// 
/// \arg piol symbol to get inputs from.
/// 
/// \return struct symtab_IOContainer * 
/// 
///	input container of symbol.
/// 
/// \brief Find inputs of symbol.
/// 


/// 
/// \arg phsle symbol to get parameter for
/// \arg pcName name of parameter
/// \arg ppist context of symbol
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol
/// 


/// 
/// \arg phsle symbol to get name for.
/// 
/// \return char * : name of symbol.
/// 
/// \brief Get name of symbol.
/// 


/// 
/// \arg phsle symbol to get options for.
/// 
/// \return int : options.
/// 
/// \brief Get options of symbol.
/// 


/// 
/// \arg phsle symbol to get parameter for.
/// \arg ppist context of symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol
/// 


/// 
/// \arg phsle symbol to get pidin for
/// 
/// \return struct symtab_IdentifierIndex * : pidin of symbol
/// 
/// \brief Get pidin for symbol
/// 


/// 
/// \arg phsle symbol to get prototype for.
/// 
/// \return struct symtab_HSolveListElement *
/// 
///	Prototype, NULL if none.
/// 
/// \details 
/// 
///	Get prototype of symbol.
/// 


/// 
/// \arg phsle symbol to get type for.
/// 
/// \return int : type of symbol.
/// 
/// \details 
/// 
///	Get type of symbol.  See also SymbolSetType().
/// 
/// \note 
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


/// 
/// \arg phsle symbol to check.
/// \arg pc name of input.
/// \arg i location of input.
/// 
/// \return int : TRUE if symbol has bindable IO relations.
/// 
/// \brief Check if symbol has bindable IO relations.
/// 


/// 
/// \arg phsle symbol to check
/// \arg ppist context of channel
/// 
/// \return int : TRUE if symbol contains an equation.
/// 
/// \brief Check if symbol contains an equation.
/// 


/// 
/// \arg phsle channel to check
/// 
/// \return int : TRUE if symbol has MG blocking
/// 
/// \brief Check if symbol G is MG blocked.
/// 


/// 
/// \arg phsle channel to check
/// 
/// \return int : TRUE if symbol has nernst
/// 
/// \brief Check if symbol Erev nernst-equation controlled
/// 


/// 
/// \arg phsle symbol to get parameter for.
/// \arg ppars new list of parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Add new paramaters, not overriding existing ones.
/// 


/// 
/// \arg phsle symbol container.
/// \arg ppist element to search.
/// \arg iLevel active level of ppist,
///		0 <= iLevel < PidinStackNumberOfEntries().
/// \arg bAll set TRUE if all names in ppist should be searched.
/// 
/// \return struct symtab_HSolveListElement * : searched symbol.
/// 
/// \brief lookup a hierarchical symbol name in another symbol.
/// 


/// 
/// \arg phsleCont symbol container
/// \arg ppistCont context of container
/// \arg phsleSerial: element to search
/// \arg ppistSerial: context of element to search
/// 
/// \return int : serial ID of symbol with respect to container, -1 for failure
/// 
/// \brief Get a serial unique ID for symbol with respect to container
/// 


/// 
/// \arg phsle symbol to get parameter for
/// \arg pcName name of parameter
/// \arg ppist context of symbol
/// 
/// \return double : parameter value, FLT_MAX if some error occured
/// 
/// \brief Resolve value of parameter
/// 


/// 
/// \arg phsle symbol to do scaling
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specifies type of scaling
/// 
/// \return double : scaled value, FLT_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 


/// 
/// \arg phsle symbol to print
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Pretty print symbol
/// 


/// 
/// \arg phsle symbol to resolve input for
/// \arg ppist context of given element
/// \arg pcName name of input to resolve
/// \arg iPosition: number of inputs with given name to skip
/// 
/// \return struct symtab_HSolveListElement *
/// 
///	symbol table element generating input, NULL for non-existent
/// 
/// \brief Find input with given name
/// 


/// 
/// \arg phsle symbol to resolve input for
/// \arg ppist context of given element
/// \arg pcParameter: name of parameter with function
/// \arg pcInput name of input on function of parameter
/// \arg iPosition input identifier in instantiation
/// 
/// \return struct symtab_HSolveListElement * : symbol that gives input
/// 
/// \brief Find input to functional parameter
/// 


/// 
/// \arg phsle symbol to set coordinates for.
/// \arg x coordinate x
/// \arg y coordinate y
/// \arg z coordinate z
/// 
/// \return int : success of operation
/// 
/// \brief Set coordinates for symbol.
/// 


/// 
/// \arg phsle symbol to set name of
/// \arg pidin name.
/// 
/// \return int : success of operation
/// 
/// \brief Set name of symbol.
/// 


/// 
/// \arg phsle symbol to set parameter for.
/// \arg iOptions options for symbol.
/// 
/// \return int : success of operation.
/// 
/// \brief Set options of symbol.
/// 


/// 
/// \arg phsle symbol to get parameter for
/// \arg pcName name of parameter
/// \arg dNumber: parameter value
/// \arg ppist context of symbol (not used at the moment, can be changed)
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \details 
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


/// 
/// \arg phsle symbol to get parameter for
/// \arg pcName name of parameter
/// \arg pcValue: parameter value
/// \arg ppist context of symbol (not used at the moment, can be changed)
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \details 
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


/// 
/// \arg phsle symbol to set prototype for.
/// \arg phsleProto prototype symbol.
/// 
/// \return int : success of operation.
/// 
/// \details 
/// 
///	Set prototype of symbol.
/// 
///	The symbol uses the prototype symbol for inferences when needed.
/// 


/// 
/// \arg phsle symbol to get type for.
/// \arg iType type of symbol.
/// 
/// \return int : success of operation.
/// 
/// \details 
/// 
///	Set type of symbol.  See also SymbolGetType().
/// 
/// \note 
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


/// 
/// \arg ptstr initialized treespace traversal
/// \arg phsle symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse symbols in tree manner.
/// 
/// \note  See IOHierarchyTraverse()
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


/// 
/// \arg phsle symbol to traverse segments for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pfProcesor segment processor
/// \arg pfFinalizer segment finalizer
/// \arg pvUserdata any user data
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse segments, call pfProcessor on each of them
/// 


/// 
/// \arg phsle symbol to traverse spike generators for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pfProcesor spike generator processor
/// \arg pfFinalizer spike generator finalizer
/// \arg pvUserdata any user data
/// 
/// \return int : success of operation
/// 
/// \brief Traverse spike generators, call pfProcessor on each of them
/// 


/// 
/// \arg phsle symbol to traverse spike receivers for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pfProcesor spike receiver processor
/// \arg pfFinalizer spike receiver finalizer
/// \arg pvUserdata any user data
/// 
/// \return int : see TstrGo()
/// 
/// \brief Traverse spike receivers, call pfProcessor on each of them
/// 


