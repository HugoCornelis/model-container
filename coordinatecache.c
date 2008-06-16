//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: coordinatecache.c 1.4 Sun, 26 Aug 2007 09:32:05 -0500 hugo $
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
#include <string.h>

#include "neurospaces/cachedcoordinate.h"
#include "neurospaces/coordinatecache.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/treespacetraversal.h"


static int 
CoordinateCacheCoordinateCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static int 
CoordinateCacheCoordinateFiller
(struct TreespaceTraversal *ptstr, void *pvUserdata);


/// **************************************************************************
///
/// SHORT: CoordinateCacheBuildCaches()
///
/// ARGS.:
///
///	pcc..: coordinate cache to build caches for.
///
/// RTN..: int
///
///	Success of operation.
///
/// DESCR: Build caches.
///
/// **************************************************************************

static int 
CoordinateCacheCoordinateCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- count caches

    int *piCoordinates = (int *)pvUserdata;

    (*piCoordinates)++;

    //- return result

    return(iResult);
}


static int 
CoordinateCacheCoordinateFiller
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get coordinate cache

    struct CoordinateCache *pcc = (struct CoordinateCache *)pvUserdata;

    //- get current coordinate

    int iCoordinate = pcc->iCoordinates;

    //- compute coordinate

    //! xref cannot complete the following array, change to pointer
    //! dereference, and it works

    SymbolParameterResolveCoordinateValue
	(pcc->phsle, pcc->ppist, ptstr->ppist, &pcc->pccrd[iCoordinate].D3);

    //- set serial

    int iSerial = TstrGetPrincipalSerial(ptstr);

/*     int iSerial = PidinStackToSerial(ptstr->ppist); */

    pcc->pccrd[iCoordinate].iSerial = iSerial;

    //- next coordinate

    pcc->iCoordinates++;

    //- return result

    return(iResult);
}


int
CoordinateCacheBuildCaches(struct CoordinateCache *pcc)
{
    //- set default result: failure

    int iResult = 0;

    //- number of coordinates to cache

    int iCoordinates = 0;

    //- set processor of traversal: count coordinates

    pcc->ptstr->pfProcessor = CoordinateCacheCoordinateCounter;
    pcc->ptstr->pvProcessor = &iCoordinates;

    //- traverse

    TstrGo(pcc->ptstr, pcc->phsle);

    if (iCoordinates != -1)
    {
	//- allocate caches

	CoordinateCacheInit(pcc, iCoordinates);

	//- set processor of traversal: fill coordinates

	pcc->ptstr->pfProcessor = CoordinateCacheCoordinateFiller;
	pcc->ptstr->pvProcessor = pcc;

	//- traverse

	//! the filler uses ->iCoordinates as the active coordinate

	pcc->iCoordinates = 0;

	TstrGo(pcc->ptstr, pcc->phsle);

	//- set result: ok

	iResult = 1;
    }

    //- sanity check

    if (pcc->iCoordinates != iCoordinates)
    {
	//- set result: failure

	iResult = 0;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: CoordinateCacheInit()
///
/// ARGS.:
///
///	pcc..: coordinate cache to init.
///
/// RTN..: int
///
///	Success of operation.
///
/// DESCR: Initialize new coordinate cache, without building caches.
///
/// **************************************************************************

int
CoordinateCacheInit(struct CoordinateCache *pcc, int iCoordinates)
{
    //- set default result: failure

    int iResult = 0;

    //- init

    pcc->iCoordinates = iCoordinates;

    pcc->pccrd
	= (struct CachedCoordinate *)
	  calloc(iCoordinates,sizeof(struct CachedCoordinate));

    //- set used memory

    pcc->iMemoryUsed
	= (iCoordinates * sizeof(struct CachedCoordinate)
	   + sizeof(struct CoordinateCache));

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: CoordinateCacheLookup()
///
/// ARGS.:
///
///	pcc.....: coordinate cache.
///	iSerial.: serial to search for.
///
/// RTN..: struct CachedCoordinate *
///
///	cached coordinate for this serial, NULL for not found.
///
/// DESCR: Find the cached coordinate for the given serial.
///
/// **************************************************************************

struct CachedCoordinate *
CoordinateCacheLookup(struct CoordinateCache *pcc, int iSerial)
{
    //- set default result: failure

    struct CachedCoordinate *pccrdResult = NULL;

    //- init top and bottom counters

    int iLower = 0;
    int iUpper = pcc->iCoordinates - 1;

    //! binary search

    //- search until the range to search in becomes invalid

    while (iUpper - iLower >= 0)
    {
	//- determine the middle of the search range

	int iMiddle = (iLower + iUpper) / 2;

	//- get pointer to this command info entry

        struct CachedCoordinate *pccrd = &pcc->pccrd[iMiddle];

	//- set result and break out loop if search value is found here

	if (iSerial == pccrd->iSerial)
	{
	    pccrdResult = pccrd;

	    break;
	}

	//- set a new lower or upper limit

	if (iSerial > pccrd->iSerial)
	{
	    iLower = iMiddle + 1;
	}
	else
	{
	    iUpper = iMiddle - 1;
	}
    }

    //- return result

    return(pccrdResult);
}


/// **************************************************************************
///
/// SHORT: CoordinateCacheNewForTraversal()
///
/// ARGS.:
///
///	ptstr..: traversal that visits symbol to cache coordinates for.
///
/// RTN..: struct CoordinateCache * 
///
///	New coordinate cache, NULL for failure.
///
/// DESCR: Create new coordinate cache, without building caches.
///
///	Note that the semantics of the traversal are not defined.  Probably,
///     in the future the client has to set the selector, while this
///     module sets the processor.
///
///	At present, the client is responsible for allocation and
///	destruction of the traversal.
///
/// **************************************************************************

struct CoordinateCache *
CoordinateCacheNewForTraversal(struct TreespaceTraversal *ptstr)
{
    //- set default result : failure

    struct CoordinateCache *pccResult = NULL;

    //- allocate coordinate cache

    pccResult
	= (struct CoordinateCache *)calloc(1,sizeof(struct CoordinateCache));

    //- set traversal

    pccResult->ptstr = ptstr;

    //- set root symbol

    pccResult->phsle = PidinStackLookupTopSymbol(ptstr->ppist);

    pccResult->ppist = PidinStackDuplicate(ptstr->ppist);

    //- return result

    return(pccResult);
}


