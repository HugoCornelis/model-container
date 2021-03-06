//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: orderedconnectioncache.h 1.6 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#ifndef ORDEREDCONNECTIONCACHE_H
#define ORDEREDCONNECTIONCACHE_H



#include "connectioncache.h"


struct OrderedConnectionCache
{
    /// memory used by this connection cache.

    int iMemoryUsed;

    /// number of connections involved

    int iConnections;

    /// flag indicating pre or post ordering

    int iPost;

    /// array of ordered connections

    int *piOrdered;

    /// array of referred connections

    /// \note this one is given to the constructor,
    /// \note it is never part of the allocated memory.

    struct ConnectionCache *pcc;
};



struct OrderedConnectionCache * 
OrderedConnectionCacheNew
(struct ConnectionCache *pcc,struct ProjectionQuery *ppq,int iPost);

int
OrderedConnectionCacheGetFirstIndexForSerial
(struct OrderedConnectionCache *pocc,struct ProjectionQuery *ppq,int iSerial);



static inline 
void OrderedConnectionCacheFree(struct OrderedConnectionCache *pocc);

static inline
struct CachedConnection *
OrderedConnectionCacheGetEntry
(struct OrderedConnectionCache *pocc,int iEntry);



/// 
/// free ordered connection cache.
/// 

static inline 
void OrderedConnectionCacheFree(struct OrderedConnectionCache *pocc)
{
    pocc->iConnections = 0;
    free(pocc->piOrdered);
    free(pocc);
}


/// 
/// get entry from connection cache.
/// 

static inline
struct CachedConnection *
OrderedConnectionCacheGetEntry
(struct OrderedConnectionCache *pocc,int iEntry)
{
    return(ConnectionCacheGetEntry(pocc->pcc,pocc->piOrdered[iEntry]));
}


/// 
/// get memory size taken by cache.
/// 

static inline 
int OrderedConnectionCacheGetMemorySize(struct OrderedConnectionCache *pocc)
{
    return(pocc->iMemoryUsed);
}


#endif


