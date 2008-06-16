//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: orderedconnectioncache.c 1.14 Fri, 07 Dec 2007 11:59:10 -0600 hugo $
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

#include "neurospaces/orderedconnectioncache.h"


/// **************************************************************************
///
/// SHORT: OrderedConnectionCacheGetFirstIndexForSerial()
///
/// ARGS.:
///
///	pocc....: ordered connection cache.
///	ppq.....: projection query that makes this call.
///	iSerial.: pre- or post-serial to get first entry for.
///
/// RTN..: int : index into ordered connection cache, -1 for failure.
///
/// DESCR: Get index into ordered connection cache.
///
/// **************************************************************************

int
OrderedConnectionCacheGetFirstIndexForSerial
(struct OrderedConnectionCache *pocc, struct ProjectionQuery *ppq, int iSerial)
{
    //- set default result : failure

    int iResult = -1;

    //1 determine any entry that matches

    //! binary search, probably better to use this in combination with
    //! an interpolation search and apply an heuristic based on the 
    //! cumulative distribution of the post- and pre-synaptic targets
    //! to choose between them.

    //- initialize top and bottom counters

    int iLower = 0;

    int iUpper = pocc->iConnections - 1;

    //- search any match untill range to search in becomes invalid

    while (iUpper - iLower >= 0)
    {
	//- determine middle of search range

	int iMiddle = (iLower + iUpper) / 2;

	//- get pointer to cached connection entry

	int iEntry = pocc->piOrdered[iMiddle];

	struct CachedConnection *pcconn
	    = ConnectionCacheGetEntry(pocc->pcc, iEntry);

	//- get appropriate serial for cached connection

	int iSerialConn
	    = pocc->iPost
	      ? CachedConnectionGetCachedPost(pcconn)
	      : CachedConnectionGetCachedPre(pcconn);

	//- if match

	if (iSerialConn == iSerial)
	{
	    //- set result

	    iResult = iMiddle;

	    //- break searching loop

	    break;
	}

	//- set new lower or upper limit

	if (iSerial > iSerialConn)
	{
	    iLower = iMiddle + 1;
	}
	else
	{
	    iUpper = iMiddle - 1;
	}
    }

    //2 determine first entry that matches

    //! iResult matches, possibly somewhere in middle of matching series
    //! iLower could match if still first entry in array
    //! iUpper does not matter

    //- if we found a matching entry

    if (iResult != -1)
    {
	//- set new limits

	iLower = iLower;
	iUpper = iResult;

	//- search any match untill range to search in becomes invalid

	while (iUpper - iLower >= 0)
	{
	    //- determine middle of search range

	    int iMiddle = (iLower + iUpper) / 2;

	    //- get pointer to cached connection entry

	    int iEntry = pocc->piOrdered[iMiddle];

	    struct CachedConnection *pcconn
		= ConnectionCacheGetEntry(pocc->pcc, iEntry);

	    //- get appropriate serial for cached connection

	    int iSerialConn
		= pocc->iPost
		  ? CachedConnectionGetCachedPost(pcconn)
		  : CachedConnectionGetCachedPre(pcconn);

	    //- if match, set result and adjust limits

	    if (iSerialConn == iSerial)
	    {
		iResult = iMiddle;

		iUpper = iMiddle - 1;
	    }

	    //- non match : adjust lower limit

	    else
	    {
		iLower = iMiddle + 1;
	    }
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: OrderedConnectionCacheNew()
///
/// ARGS.:
///
///	pcc...: connection cache to order.
///	ppq...: projection query that makes this call.
///	iPost.: TRUE == post ordering, FALSE == pre ordering.
///
/// RTN..: struct OrderedConnectionCache * 
///
///	New ordered connection cache, NULL for failure.
///
/// DESCR: Initialize new ordered connection cache.
///
///	The connection cache pcc is kept by reference, don't free it 
///	as long as the ordered connection cache is in use.
///
/// **************************************************************************

//t how to get rid of this static variable ?  Don't use qsort() ?

static struct ConnectionCache *pccToOrder = NULL;

static struct ProjectionQuery *ppqToOrder = NULL;

static int PostSynapticOrder(const void *pv1, const void *pv2)
{
    //- get pointers to cached connections

    struct CachedConnection *pcconn1
	= ConnectionCacheGetEntry(pccToOrder,*(int *)pv1);

    struct CachedConnection *pcconn2
	= ConnectionCacheGetEntry(pccToOrder,*(int *)pv2);

    //- get serials for presynaptic part

    int i1 = CachedConnectionGetCachedPost(pcconn1);
    int i2 = CachedConnectionGetCachedPost(pcconn2);

//    fprintf(stdout,"PostOrder : %i,%i\n");

    //- compare, set result

    return(i1 < i2 ? -1 : i1 > i2 ? 1 : 0);
}


static int PreSynapticOrder(const void *pv1, const void *pv2)
{
    //- get pointers to cached connections

    struct CachedConnection *pcconn1
	= ConnectionCacheGetEntry(pccToOrder, *(int *)pv1);

    struct CachedConnection *pcconn2
	= ConnectionCacheGetEntry(pccToOrder, *(int *)pv2);

    //- get serials for presynaptic part

    int i1 = CachedConnectionGetCachedPre(pcconn1);
    int i2 = CachedConnectionGetCachedPre(pcconn2);

//    fprintf(stdout,"PreOrder : %i,%i\n");

    //- compare, set result

    return(i1 < i2 ? -1 : i1 > i2 ? 1 : 0);
}


struct OrderedConnectionCache *
OrderedConnectionCacheNew
(struct ConnectionCache *pcc, struct ProjectionQuery *ppq, int iPost)
{
    //- set default result : failure

    struct OrderedConnectionCache *poccResult = NULL;

    int i;

    int (*comp)(const void *, const void *);

    //- allocate ordered connection cache

    poccResult
	= (struct OrderedConnectionCache *)
	  calloc(1, sizeof(struct OrderedConnectionCache));

    poccResult->iMemoryUsed = sizeof(struct OrderedConnectionCache);

    //- init

    poccResult->pcc = pcc;

    poccResult->iConnections = ConnectionCacheGetNumberOfConnections(pcc);

    poccResult->piOrdered
	= (int *)calloc(poccResult->iConnections, sizeof(int));

    //- increment used memory

    poccResult->iMemoryUsed += poccResult->iConnections * sizeof(int);

    for (i = 0 ; i < poccResult->iConnections ; i++)
    {
	poccResult->piOrdered[i] = i;
    }

    //- select post or pre ordering

    poccResult->iPost = iPost;

    if (iPost)
    {
	comp = PostSynapticOrder;
    }
    else
    {
	comp = PreSynapticOrder;
    }

    //- do ordering

    pccToOrder = pcc;

    ppqToOrder = ppq;

    qsort
	(&poccResult->piOrdered[0],
	 poccResult->iConnections,
	 sizeof(poccResult->piOrdered[0]),
	 comp);

    ppqToOrder = NULL;

    pccToOrder = NULL;

    //- return result

    return(poccResult);
}


