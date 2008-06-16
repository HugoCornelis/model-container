//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectioncache.h 1.8 Fri, 07 Sep 2007 22:01:15 -0500 hugo $
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



#ifndef CONNECTIONCACHE_H
#define CONNECTIONCACHE_H


//d declarations

struct CachedConnection;
struct ConnectionCache;
struct symtab_Connection;
struct symtab_HSolveListElement;


//f exported functions

struct ConnectionCache * ConnectionCacheNew(int iConnections);


//f exported inlines

static inline 
void ConnectionCacheFree(struct ConnectionCache *pcc);

static inline
struct CachedConnection *
ConnectionCacheGetEntry(struct ConnectionCache *pcc, int iEntry);

static inline 
int ConnectionCacheGetNumberOfConnections(struct ConnectionCache *pcc);

static inline
int
ConnectionCacheSetEntry
(struct ConnectionCache *pcc,
 int iEntry,
/*  int iCursor, */
/*  int iType, */
/*  struct symtab_HSolveListElement *phsle); */
 int iPre,
 int iPost,
 double dDelay,
 double dWeight);


#include "cachedconnection.h"


struct ConnectionCache
{
    //m memory used by this connection cache.

    int iMemoryUsed;

    //m number of connections involved

    int iConnections;

    //m array of referred connections

    struct CachedConnection *pcconn;
};



//f exported inlines

///
/// free connection cache.
///

static inline 
void ConnectionCacheFree(struct ConnectionCache *pcc)
{
    pcc->iConnections = 0;
    free(pcc->pcconn);
    free(pcc);
}


///
/// get an entry in the cache.
///

static inline
struct CachedConnection *
ConnectionCacheGetEntry(struct ConnectionCache *pcc, int iEntry)
{
    return(&pcc->pcconn[iEntry]);
}


///
/// get memory size taken by cache.
///

static inline 
int ConnectionCacheGetMemorySize(struct ConnectionCache *pcc)
{
    return(pcc->iMemoryUsed);
}


///
/// get number of connections in cache.
///

static inline 
int ConnectionCacheGetNumberOfConnections(struct ConnectionCache *pcc)
{
    return(pcc->iConnections);
}


///
/// set an entry in the cache.
///

static inline
int
ConnectionCacheSetEntry
(struct ConnectionCache *pcc,
 int iEntry,
/*  int iCursor, */
/*  int iType, */
/*  struct symtab_HSolveListElement *phsle) */
 int iPre,
 int iPost,
 double dDelay,
 double dWeight)
{
    CachedConnectionInit(&pcc->pcconn[iEntry],/*  iCursor, iType, phsle, */ iPre, iPost, dDelay, dWeight);
}


#endif


