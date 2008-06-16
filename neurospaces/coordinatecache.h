//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: coordinatecache.h 1.1 Wed, 06 Jun 2007 23:12:27 -0500 hugo $
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



#ifndef COORDINATECACHE_H
#define COORDINATECACHE_H


//d declarations

struct CachedCoordinate;
struct CoordinateCache;
struct D3Position;
struct TreespaceTraversal;


//f exported functions

int
CoordinateCacheBuildCaches(struct CoordinateCache *pcc);

int
CoordinateCacheInit(struct CoordinateCache *pcc, int iCoordinates);

struct CoordinateCache *
CoordinateCacheNewForTraversal(struct TreespaceTraversal *ptstr);

struct CachedCoordinate *
CoordinateCacheLookup(struct CoordinateCache *pcc, int iSerial);


//f exported inlines

static inline 
void CoordinateCacheFree(struct CoordinateCache *pcc);

static inline
struct CachedCoordinate *
CoordinateCacheGetEntry(struct CoordinateCache *pcc, int iEntry);

static inline 
int CoordinateCacheGetNumberOfCoordinates(struct CoordinateCache *pcc);

static inline
int
CoordinateCacheSetEntry
(struct CoordinateCache *pcc,
 int iEntry,
 int iSerial,
 struct D3Position *pD3);


#include "cachedcoordinate.h"


struct CoordinateCache
{
    //m traversal used to build the cache

    //! see notes of CoordinateCacheNew() for more information.

    struct TreespaceTraversal *ptstr;

    //m root symbol of cache

    struct symtab_HSolveListElement *phsle;

    struct PidinStack *ppist;

    //m memory used by this coordinate cache.

    int iMemoryUsed;

    //m number of coordinates involved

    int iCoordinates;

    //m array of referred coordinates

    struct CachedCoordinate *pccrd;
};



//f exported inlines

///
/// free coordinate cache.
///

static inline 
void CoordinateCacheFree(struct CoordinateCache *pcc)
{
    pcc->iCoordinates = 0;
    free(pcc->pccrd);
    free(pcc);
}


///
/// get an entry in the cache.
///

static inline
struct CachedCoordinate *
CoordinateCacheGetEntry(struct CoordinateCache *pcc, int iEntry)
{
    return(&pcc->pccrd[iEntry]);
}


///
/// get memory size taken by cache.
///

static inline 
int CoordinateCacheGetMemorySize(struct CoordinateCache *pcc)
{
    return(pcc->iMemoryUsed);
}


///
/// get number of coordinates in cache.
///

static inline 
int CoordinateCacheGetNumberOfCoordinates(struct CoordinateCache *pcc)
{
    return(pcc->iCoordinates);
}


///
/// set an entry in the cache.
///

static inline
int
CoordinateCacheSetEntry
(struct CoordinateCache *pcc,
 int iEntry,
 int iSerial,
 struct D3Position *pD3)
{
    CachedCoordinateInit(&pcc->pccrd[iEntry], iSerial, pD3);
}


#endif


