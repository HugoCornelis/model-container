//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cacheregistry.c 1.2 Sun, 10 Jun 2007 21:11:20 -0500 hugo $
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

#include "neurospaces/cacheregistry.h"


/// **************************************************************************
///
/// SHORT: CacheRegistryCalloc()
///
/// ARGS.:
///
///	iSize...: Initial size.
///
/// RTN..: struct CacheRegistry *
///
///	Newly allocated cache registry, NULL for failure.
///
/// DESCR: Allocate a cache registry.
///
/// **************************************************************************

struct CacheRegistry *
CacheRegistryCalloc(int iSize)
{
    //- set default result: failure

    struct CacheRegistry *pcrResult = NULL;

    //- allocate registry

    pcrResult = (struct CacheRegistry *)calloc(1, sizeof(*pcrResult));

    if (!pcrResult)
    {
	return(NULL);
    }

    //- allocate entries

    pcrResult->prc
	= (struct RegisteredCache *)calloc(iSize, sizeof(*pcrResult->prc));

    if (!pcrResult->prc)
    {
	free(pcrResult);

	return(NULL);
    }

    //- set size

    pcrResult->iSize = iSize;

    //- return result

    return(pcrResult);
}


/// **************************************************************************
///
/// SHORT: CacheRegistryLookup()
///
/// ARGS.:
///
///	pcr.........: cache registry.
///	iIdentifier.: cache identifier for lookup.
///
/// RTN..: struct RegisteredCache *
///
///	New registered cache entry, NULL for failure.
///
/// DESCR: Register a new cache, duplicate identifiers not allowed.
///
/// **************************************************************************

struct RegisteredCache *
CacheRegistryLookup(struct CacheRegistry *pcr, int iIdentifier)
{
    //- set default result: failure

    struct RegisteredCache *prcResult = NULL;

    //- loop over all entries

    int i;

    for (i = 0 ; i < pcr->iRegistered ; i++)
    {
	//- if found

	if (pcr->prc[i].iIdentifier == iIdentifier)
	{
	    //- set result

	    prcResult = &pcr->prc[i];

	    //- break searching loop

	    break;
	}
    }

    //- return result

    return(prcResult);
}


/// **************************************************************************
///
/// SHORT: CacheRegistryRegisterCache()
///
/// ARGS.:
///
///	pcr.........: cache registry.
///	iType.......: cache type.
///	iIdentifier.: cache identifier for lookup.
///	iSize.......: cache size.
///	pvCache.....: cache data.
///
/// RTN..: struct RegisteredCache *
///
///	New registered cache entry, NULL for failure.
///
/// DESCR: Register a new cache, duplicate identifiers not allowed.
///
/// **************************************************************************

struct RegisteredCache *
CacheRegistryRegisterCache
(struct CacheRegistry *pcr,
 int iType,
 int iIdentifier,
 int iSize,
 void *pvCache)
{
    //- set default result: failure

    struct RegisteredCache *prcResult = NULL;

    //- lookup the identifier in the cache

    struct RegisteredCache *prc
	= CacheRegistryLookup(pcr, iIdentifier);

    if (prc)
    {
	//- return failure

	return(NULL);
    }

    //- look for a new entry in the cache

    prcResult = &pcr->prc[pcr->iRegistered];

    //- fill the new entry

    prcResult->iIdentifier = iIdentifier;
    prcResult->iSize = iSize;
    prcResult->iType = iType;
    prcResult->pvCache = pvCache;

    //- make the new entry available

    pcr->iRegistered++;

    //- return result

    return(prcResult);
}


