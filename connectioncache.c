//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectioncache.c 1.7 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#include <stdlib.h>
#include <string.h>

#include "neurospaces/connectioncache.h"


/// **************************************************************************
///
/// SHORT: ConnectionCacheNew()
///
/// ARGS.:
///
///	iConnections..: number of connections to go into cache.
///
/// RTN..: struct ConnectionCache * 
///
///	New connection cache, NULL for failure.
///
/// DESCR: Initialize new connection cache.
///
/// **************************************************************************

struct ConnectionCache * ConnectionCacheNew(int iConnections)
{
    //- set default result : failure

    struct ConnectionCache *pccResult = NULL;

    //- allocate connection cache

    pccResult
	= (struct ConnectionCache *)calloc(1,sizeof(struct ConnectionCache));

    //- init

    pccResult->iConnections = iConnections;

    pccResult->pcconn
	= (struct CachedConnection *)
	  calloc(iConnections,sizeof(struct CachedConnection));

    //- set used memory

    pccResult->iMemoryUsed
	= iConnections * sizeof(struct CachedConnection)
	  + sizeof(struct ConnectionCache);

    //- return result

    return(pccResult);
}


