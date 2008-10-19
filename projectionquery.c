//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionquery.c 1.61 Fri, 07 Dec 2007 11:59:10 -0600 hugo $
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

#include "neurospaces/cachedconnection.h"
#include "neurospaces/components/connection.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/parameters.h"
#include "neurospaces/projectionquery.h"
#include "neurospaces/treespacetraversal.h"

#include "neurospaces/symbolvirtual_protos.h"


//f local functions

static int
ProjectionQueryTraverseProjectionConnections
(struct ProjectionQuery *ppq,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

static int
ProjectionQueryBuildConnectionCache(struct ProjectionQuery *ppq);


/// **************************************************************************
///
/// SHORT: ProjectionQueryBuildCaches()
///
/// ARGS.:
///
///	ppq..: projection query
///
/// RTN..: int : success of operation.
///
/// DESCR: Build caches for projection query.
///
/// **************************************************************************

int ProjectionQueryBuildCaches(struct ProjectionQuery *ppq)
{
    //- set default result : failure

    int bResult = FALSE;

    //- build unordered connection cache

    if (ProjectionQueryBuildConnectionCache(ppq))
    {
	//- build ordered connection caches

	if (ProjectionQueryBuildOrderedConnectionCaches(ppq))
	{
	    //- set result : ok

	    bResult = TRUE;
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryBuildConnectionCache()
///
/// ARGS.:
///
///	ppq..: projection query
///
/// RTN..: int : success of operation.
///
/// DESCR: Build the unordered connection cache for initialized query.
///
/// **************************************************************************

struct UnorderedCaching_data
{
    //m original projection query

    struct ProjectionQuery *ppq;

    //m connection cache associated with projection query

    struct ConnectionCache *pcc;

    //m current entry in connection cache

    int iCurrent;
};

static int
ProjectionQueryConnectionCacher
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to cache build data

    struct UnorderedCaching_data *pucd
	= (struct UnorderedCaching_data *)pvUserdata;

    //- get actual entry

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- sanity check

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	//- compute absolute pre serial

	struct PidinStack *ppistSource
	    = ProjectionQueryGetSource(pucd->ppq, pucd->ppq->iCursor);

	if (!ppistSource)
	{
	    //- return failure

	    return(TSTR_PROCESSOR_ABORT);
	}

	int iSource = PidinStackToSerial(ppistSource);

#include "hierarchy/output/symbols/all_vtables.c"

	int iPre = SymbolGetPre_alien(phsle, iSource, _vtable_all[iType - 1]);

	//- compute absolute post serial

	struct PidinStack *ppistTarget
	    = ProjectionQueryGetTarget(pucd->ppq, pucd->ppq->iCursor);

	if (!ppistTarget)
	{
	    //- return failure

	    return(TSTR_PROCESSOR_ABORT);
	}

	int iTarget = PidinStackToSerial(ppistTarget);

	int iPost = SymbolGetPost_alien(phsle, iTarget, _vtable_all[iType - 1]);

	struct PidinStack *ppistConnection = ptstr->ppist;

	double dDelay = SymbolGetDelay_alien(phsle, ppistConnection, _vtable_all[iType - 1]);

	double dWeight = SymbolGetWeight_alien(phsle, ppistConnection, _vtable_all[iType - 1]);

	//- register connection in cache

	ConnectionCacheSetEntry
	    (pucd->pcc,
	     pucd->iCurrent,
	     iPre,
	     iPost,
	     dDelay,
	     dWeight);

/* 	     pucd->ppq->iCursor, */
/* 	     iType, */
/* 	     phsle); */

	//- add to counted connections

	pucd->iCurrent++;
    }

    //- return result

    return(iResult);
}


static int
ProjectionQueryBuildConnectionCache(struct ProjectionQuery *ppq)
{
    //- set default result : failure

    int bResult = FALSE;

    //v cache build data

    struct UnorderedCaching_data ucd = 
    {
	//m original projection query

	ppq,

	//m connection cache associated with projection query

	NULL,

	//m current entry in connection cache

	0,
    };

    //- count all connections

    int iConnections = ProjectionQueryCountConnections(ppq);

    //- allocate connection caches

    ppq->pcc = ConnectionCacheNew(iConnections);

    //- keep track of used memory

    ppq->iMemoryUsed += ConnectionCacheGetMemorySize(ppq->pcc);

    //- traverse connections and register them in the cache.

    ucd.pcc = ppq->pcc;
    ucd.iCurrent = 0;

    if (ProjectionQueryTraverseProjectionConnections
	(ppq, ProjectionQueryConnectionCacher, NULL, (void *)&ucd) == 1)
    {
	//- sanity check

	if (ucd.iCurrent != iConnections)
	{
	    fprintf
		(stdout,
		 "ProjectionQueryBuildConnectionCache() :"
		 " ucd.iCurrent(%i) != iConnections(%i)\n",
		 ucd.iCurrent,
		 iConnections);
	}

	//- set result : ok

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryBuildOrderedConnectionCaches()
///
/// ARGS.:
///
///	ppq..: projection query
///
/// RTN..: int : success of operation.
///
/// DESCR: Build the ordered connection caches for an initialized query.
///
/// **************************************************************************

int
ProjectionQueryBuildOrderedConnectionCaches(struct ProjectionQuery *ppq)
{
    //- set default result : failure

    int bResult = FALSE;

    //- allocate connection caches

    ppq->poccPre = OrderedConnectionCacheNew(ppq->pcc,ppq,FALSE);

    ppq->poccPost = OrderedConnectionCacheNew(ppq->pcc,ppq,TRUE);

    //- keep track of used memory

    ppq->iMemoryUsed += OrderedConnectionCacheGetMemorySize(ppq->poccPre);

    ppq->iMemoryUsed += OrderedConnectionCacheGetMemorySize(ppq->poccPost);

    //- set result : ok

    bResult = TRUE;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryCallocFromProjections()
///
/// ARGS.:
///
///	ppistProjections.: array of projections to query
///	iProjections.....: number of projections in array
///
/// RTN..: struct ProjectionQuery *
///
/// DESCR: Construct a projection query for given projections
///
/// SEE..: ProjectionQueryInit()
///
/// **************************************************************************

struct ProjectionQuery *
ProjectionQueryCallocFromProjections
(struct PidinStack **pppistProjections,int iProjections)
{
    //- set default result : failure

    struct ProjectionQuery *ppqResult = NULL;

    //- allocate projection query

    ppqResult 
	= (struct ProjectionQuery *)
	  calloc(1,sizeof(struct ProjectionQuery));

    //- init projection query

    if (!ProjectionQueryInit(ppqResult,pppistProjections,iProjections))
    {
	ProjectionQueryFree(ppqResult);

	return(NULL);
    }

    //- return result

    return(ppqResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryCallocFromSolverRegistrations()
///
/// ARGS.:
///
///	psiSolvers..: array of solver registrations
///	iSolvers....: number of entries in array
///
/// RTN..: struct ProjectionQuery *
///
/// DESCR: Construct a projection query for projections onto solvers.
///
///	Constructs an array of projections on the solvers and calls
///	ProjectionQueryCallocFromProjections().
///
/// **************************************************************************

/* struct ProjectionQuery * */
/* ProjectionQueryCallocFromSolverRegistration */
/* (struct SolverInfo *psiSolvers,int iSolvers) */
/* { */
/*     //- set default result : failure */

/*     struct ProjectionQuery *ppqResult = NULL; */

/*     //- return result */

/*     return(ppqResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ProjectionQueryClone()
///
/// ARGS.:
///
///	ppq...........: projection query to clone
///
/// RTN..: struct ProjectionQuery *
///
///	cloned projection query, NULL for failure
///
/// DESCR: Clone a projection query for new queries on same projections.
///
///	Result is completely seperate from original projection query.
///	Query cursor is reset to zero.
///
/// **************************************************************************

struct ProjectionQuery *ProjectionQueryClone(struct ProjectionQuery *ppq)
{
    //- set default result : failure

    struct ProjectionQuery *ppqResult = NULL;

    //- allocate new projection query

    //! this will check if all symbols involved are indeed projections,
    //! this is a small overhead which could be eliminated.

    ppqResult
	= ProjectionQueryCallocFromProjections
	  (ppq->pppist,ppq->iProjections);

    //- register cloning flags

    ppq->iCloned++;

    ppqResult->ppqCloned = ppq;

    //- share caches

    ppqResult->bCaching = ppq->bCaching;

    ppqResult->pcc = ppq->pcc;
    ppqResult->poccPre = ppq->poccPre;
    ppqResult->poccPost = ppq->poccPost;

    //- if the projection query is from a file cache

    if (ppq->iCursor == 100000)
    {
	//- set flag

	ppqResult->iCursor = ppq->iCursor;
    }

    //! we do not share memory use for the moment.

    //- return result

    return(ppqResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryCountConnections()
///
/// ARGS.:
///
///	ppq...........: projection query
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Count connections for all projections in query.
///
/// **************************************************************************

int ProjectionQueryCountConnections(struct ProjectionQuery *ppq)
{
    //- set default result : failure

    int iResult = -1;

    //- default with no connections

    int iConnections = 0;

    int i;

    //- if cursor already in use

    if (ppq->iCursor != -1)
    {
	//- return failure

	return(-1);
    }

    //- if no projections

    if (ppq->iProjections == 0)
    {
	//- then no connections either

	return(0);
    }

    //- loop over projections

    for (i = 0 ; i < ppq->iProjections ; i++)
    {
	//- set cursor

	ppq->iCursor = i;

	//- count connections for current projection

	iResult = ProjectionCountConnections(ppq->ppproj[i],ppq->pppist[i]);

	if (iResult == -1)
	{
	    break;
	}

	//- add connections

	iConnections += iResult;
    }

    //- if no failure

    if (iResult != -1)
    {
	//- set result : number of connections

	iResult = iConnections;
    }

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- reset cursor

	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryCountConnectionsForSpikeGenerator()
///
/// ARGS.:
///
///	ppq...........: projection query
///	ppist.........: spike generator
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Count connections attached to spikegen.
///
/// **************************************************************************

static int ProjectionQueryConnectionForSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- add to counted connections

    int *piConnections = (int *)pvUserdata;

    (*piConnections)++;

    //- return result

    return(iResult);
}


int
ProjectionQueryCountConnectionsForSpikeGenerator
(struct ProjectionQuery *ppq,struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    int iTraverse
	= ProjectionQueryTraverseConnectionsForSpikeGenerator
	  (ppq,
	   ppist,
/*	   psi, */
	   ProjectionQueryConnectionForSpikeGeneratorCounter,
	   NULL,
	   (void *)&iResult);

    //- count connections

    if (iTraverse == -1 || iTraverse == 0)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryCountConnectionsForSpikeReceiver()
///
/// ARGS.:
///
///	ppq...........: projection query
///	ppist.........: spike receiver
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Count connections attached to spikerec.
///
/// **************************************************************************

static int ProjectionQueryConnectionForSpikeReceiverCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- add to counted connections

    int *piConnections = (int *)pvUserdata;

    (*piConnections)++;

    //- return result

    return(iResult);
}


int
ProjectionQueryCountConnectionsForSpikeReceiver
(struct ProjectionQuery *ppq,struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    int iTraverse
	= ProjectionQueryTraverseConnectionsForSpikeReceiver
	  (ppq,
	   ppist,
/*	   psi, */
	   ProjectionQueryConnectionForSpikeReceiverCounter,
	   NULL,
	   (void *)&iResult);

    //- count connections

    if (iTraverse == -1 || iTraverse == 0)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryFree()
///
/// ARGS.:
///
///	ppist.: projection to query
///
/// RTN..: void
///
/// DESCR: Free a projection query.
///
///	It is illegal to free projection queries that have pending clones.
///	First free the clones afterwards the cloned one.
///
/// **************************************************************************

void ProjectionQueryFree(struct ProjectionQuery *ppq)
{
    //- if not cloned

    if (ppq->iCloned == 0)
    {
	//- loop over projections

	int i;

	for (i = 0 ; i < ppq->iProjections ; i++)
	{
	    //- free current projection context

	    if (ppq->pppist[i])
	    {
		PidinStackFree(ppq->pppist[i]);
	    }

	    if (ppq->pppistSource[i])
	    {
		PidinStackFree(ppq->pppistSource[i]);
	    }

	    if (ppq->pppistTarget[i])
	    {
		PidinStackFree(ppq->pppistTarget[i]);
	    }
	}

	//- free projection info

	free(ppq->ppproj);
	free(ppq->pppist);

	free(ppq->pppistSource);
	free(ppq->pppistTarget);

	//t free ->piSource and ->piTarget ?

	//- if non-cloned projectionquery

	if (!ppq->ppqCloned)
	{
	    //- free caches

	    //! first free ordered caches : they use the unordered cache.

	    if (ppq->poccPre)
	    {
		OrderedConnectionCacheFree(ppq->poccPre);
	    }

	    if (ppq->poccPost)
	    {
		OrderedConnectionCacheFree(ppq->poccPost);
	    }

	    if (ppq->pcc)
	    {
		ConnectionCacheFree(ppq->pcc);
	    }
	}
	else
	{
	    //! force that these are not used anymore

	    ppq->poccPre = NULL;
	    ppq->poccPost = NULL;
	    ppq->pcc = NULL;

	    //- decrement clone count in original projection query

	    ppq->ppqCloned->iCloned--;
	}

	//- free projection query

	free(ppq);
    }
    else
    {
	fprintf
	    (stdout,
	     "ProjectionQueryFree() : Cannot free cloned projectionquery\n");
    }
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryInit()
///
/// ARGS.:
///
///	ppq..............: projection query to init
///	ppistProjections.: array of projections to query
///	iProjections.....: number of projections in array
///
/// RTN..: int : success of operation
///
/// DESCR: Init a projection query from an enumeration of projections.
///
///	ppistProjections may be discarded afterwards.
///
/// **************************************************************************

int ProjectionQueryInit
(struct ProjectionQuery *ppq,
 struct PidinStack **pppistProjections,
 int iProjections)
{
    //- set default result : failure

    int iResult = TRUE;

    int i;

    //- zero out memory

    memset((void *)ppq,0,sizeof(struct ProjectionQuery));

    //- set allocated memory counter

    ppq->iMemoryUsed = sizeof(struct ProjectionQuery);

    //- set caching status : no caching

    ppq->bCaching = FALSE;

    //- register number of projections

    ppq->iProjections = iProjections;

    //- allocate for projection info

    ppq->ppproj
	= (struct symtab_Projection **)
	  calloc(ppq->iProjections, sizeof(struct symtab_Projection *));

    ppq->pppist
	= (struct PidinStack **)
	  calloc(ppq->iProjections, sizeof(struct PidinStack *));

    ppq->piSource
	= (int *)calloc(ppq->iProjections, sizeof(int));

    ppq->pppistSource
	= (struct PidinStack **)
	  calloc(ppq->iProjections, sizeof(struct PidinStack *));

    ppq->piTarget
	= (int *)calloc(ppq->iProjections, sizeof(int));

    ppq->pppistTarget
	= (struct PidinStack **)
	  calloc(ppq->iProjections, sizeof(struct PidinStack *));

    if (!ppq->ppproj
	|| !ppq->pppist
	|| !ppq->piSource
	|| !ppq->pppistSource
	|| !ppq->piTarget
	|| !ppq->pppistTarget)
    {
	return(FALSE);
    }

    //- increment allocated memory counter

    ppq->iMemoryUsed
	+= (
	    ppq->iProjections * sizeof(struct symtab_Projection *)
	    + ppq->iProjections * sizeof(struct PidinStack *)
	    + ppq->iProjections * sizeof(int)
	    + ppq->iProjections * sizeof(struct PidinStack *)
	    + ppq->iProjections * sizeof(int)
	    + ppq->iProjections * sizeof(struct PidinStack *)
	    );

    //- loop over projections

    for (i = 0 ; i < iProjections ; i++)
    {
	//- find projection symbol

	struct symtab_HSolveListElement *phsle
	    = PidinStackLookupTopSymbol(pppistProjections[i]);

	if (PidinStackIsRooted(pppistProjections[i]) && phsle)
	{
	    //- if projection

	    if (instanceof_projection(phsle))
	    {
		//- if source and target defined

		struct symtab_Parameters *pparSource
		    = SymbolFindParameter(phsle, pppistProjections[i], "SOURCE");
		struct symtab_Parameters *pparTarget
		    = SymbolFindParameter(phsle, pppistProjections[i], "TARGET");

		if (pparSource && pparTarget)
		{
		    struct PidinStack *ppistSource
			= ParameterResolveToPidinStack
			  (pparSource, pppistProjections[i]);
		    struct PidinStack *ppistTarget
			= ParameterResolveToPidinStack
			  (pparTarget, pppistProjections[i]);

		    //- update caches 

		    PidinStackLookupTopSymbol(ppistSource);
		    PidinStackLookupTopSymbol(ppistTarget);

		    //- get serials

		    ppq->piSource[i] = PidinStackToSerial(ppistSource);

		    ppq->piTarget[i] = PidinStackToSerial(ppistTarget);

		    //- set contexts

		    ppq->pppistSource[i] = ppistSource;

		    ppq->pppistTarget[i] = ppistTarget;
		}

		//- else

		else
		{
		    //- remember that these entries exists, but not used

		    ppq->piSource[i] = -1;
		    ppq->piTarget[i] = -1;

		    ppq->pppistSource[i] = NULL;
		    ppq->pppistTarget[i] = NULL;
		}

		//- copy projection info

		ppq->ppproj[i] = (struct symtab_Projection *)phsle;

		ppq->pppist[i] = PidinStackDuplicate(pppistProjections[i]);
	    }

	    //- else

	    else
	    {
		//- set result : failure

		iResult = FALSE;
	    }
	}

	//- else

	else
	{
	    //- set result : failure

	    iResult = FALSE;
	}
    }

    //- set cursor : none

    if (iResult)
    {
	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryLookupPostSerialID()
///
/// ARGS.:
///
///	ppq....: projection query
///	pconn..: connection symbol
///
/// RTN..: int : Serial ID for connection, -1 for failure
///
/// DESCR: Get synapse number on synaptic target.
///
///	Get serial ID of specified connection, relative to the spike 
///	receiver for the connection symbol.  This is the same as the
///	synapse number for that spike receiver.  The given connection
///	is assumed to be part of the current active projection in the
///	given projection query, meaning the post serial id of the 
///	connection is assumed to be relative to the TARGET of that 
///	projection.
///
/// **************************************************************************

struct ProjectionQuerySpikeReceiverCounterData
{
    //m serial id of connection on spike receiver

    int iSerialID;

    //m connection symbol

    struct symtab_Connection *pconn;
};


static int 
ProjectionQuerySpikeReceiverCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //! we get here for connections with a specified spike receiver

    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to init struct

    struct ProjectionQuerySpikeReceiverCounterData *ppqpid
	= (struct ProjectionQuerySpikeReceiverCounterData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    //! sanity check

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- if connection matches

	if (pconn == ppqpid->pconn)
	{
	    //- set result : abort

	    iResult = TSTR_PROCESSOR_ABORT;
	}

	//- else

	else
	{
	    //- update to next serial ID

	    ppqpid->iSerialID++;
	}
    }

    //- return result : remember will go any deeper if possible

    return(iResult);
}


int
ProjectionQueryLookupPostSerialID
(struct ProjectionQuery *ppq,struct symtab_Connection *pconn)
{
    //- set default result

    int iResult = -1;

    int iTraverse = 0;

    //v target of projection

    struct PidinStack *ppistTarget = NULL;

    struct symtab_HSolveListElement *phsleTarget = NULL;

    //v post-synaptic target

    struct PidinStack *ppistPost = NULL;

    //v user data for traversal

    struct ProjectionQuerySpikeReceiverCounterData pqpid =
    {
	//m serial id

	0,

	//m connection symbol

	pconn,
    };

    //- cloned projection query to do new lookups / traversals

    struct ProjectionQuery *ppqCloned = ProjectionQueryClone(ppq);

    //- get active projection from projection query

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)ppq->ppproj[ppq->iCursor];

    struct PidinStack *ppist = ppq->pppist[ppq->iCursor];

    //- get target from projection

    struct symtab_Parameters *pparTarget
	= SymbolFindParameter(phsle, ppist, "TARGET");

    ppistTarget = ParameterResolveToPidinStack(pparTarget, ppist);

    phsleTarget = PidinStackLookupTopSymbol(ppistTarget);

    //- get spike receiver context

    ppistPost = ConnectionGetSpikeReceiver(pconn, phsleTarget ,ppistTarget);

    //- traverse connections for spike receiver

    iTraverse
	= ProjectionQueryTraverseConnectionsForSpikeReceiver
	  (ppqCloned,
	   ppistPost,
	   ProjectionQuerySpikeReceiverCounter,
	   NULL,
	   (void *)&pqpid);

    //- if traversal not aborted

    if (iTraverse != -1)
    {
	//- we did not find connection

	iResult = -1;
    }

    //- else

    else
    {
	//- set result

	iResult = pqpid.iSerialID;
    }

    //- free spike receiver contexts

    PidinStackFree(ppistTarget);
    PidinStackFree(ppistPost);

    //- free cloned projection query

    ProjectionQueryFree(ppqCloned);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryLookupPostSerialIDForAbsoluteSerials()
///
/// ARGS.:
///
///	ppq....: projection query
///	iPre...: rooted pre-synaptic serial
///	iPost..: rooted post-synaptic serial
///
/// RTN..: int : Serial ID for connection, -1 for failure
///
/// DESCR: Get synapse number on synaptic target.
///
///	Get serial ID of specified connection, relative to the spike 
///	receiver for the connection symbol.  This is the same as the
///	synapse number for that spike receiver.  The connection, 
///	given as a pre-,post-synaptic pair,
///	is assumed to be part of the current active projection in the
///	given projection query, meaning the post serial id of the 
///	connection is assumed to be relative to the TARGET of that 
///	projection.
///
/// **************************************************************************

struct ProjectionQueryPostSerialIDCounterData
{
    //m serial id of connection on spike receiver

    int iSerialID;

    //m connection {pre,post}synaptic pair

    int iPre;

    int iPost;

    //m traversal projection query

    struct ProjectionQuery *ppq;
};


static int 
ProjectionQueryPostSerialIDCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //! we get here for connections with a specified spike receiver

    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to init struct

    struct ProjectionQueryPostSerialIDCounterData *ppqpsid
	= (struct ProjectionQueryPostSerialIDCounterData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    //! sanity check

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- if connection matches

	//! post always matches, if not means bug in traversal interface.

	int iPre
	    = (ConnectionGetPre
	       (pconn,
		ProjectionQueryGetCurrentSourceSerial(ppqpsid->ppq)));

	if (iPre == ppqpsid->iPre)
	{
	    //- set result : abort

	    iResult = TSTR_PROCESSOR_ABORT;
	}

	//- else

	else
	{
	    //- update to next serial ID

	    ppqpsid->iSerialID++;
	}
    }

    //- return result : remember will go any deeper if possible

    return(iResult);
}


int
ProjectionQueryLookupPostSerialIDForAbsoluteSerials
(struct ProjectionQuery *ppq,int iPre,int iPost)
{
    //- set default result : failure

    int iResult = -1;

    int iTraverse = 0;

    //v user data for traversal

    struct ProjectionQueryPostSerialIDCounterData pqpsid =
    {
	//m serial id of connection on spike receiver

	0,

	//m connection {pre,post}synaptic pair

	iPre,
	iPost,

	//m traversal projection query

	NULL,
    };

    //- cloned projection query to do new lookups / traversals

    struct ProjectionQuery *ppqCloned = ProjectionQueryClone(ppq);

    pqpsid.ppq = ppqCloned;

    //- traverse connections for spike receiver

    iTraverse
	= ProjectionQueryTraverseConnectionsForPostSerial
	  (ppqCloned,
	   iPost,
	   ProjectionQueryPostSerialIDCounter,
	   NULL,
	   (void *)&pqpsid);

    //- if traversal not aborted

    if (iTraverse != -1)
    {
	//- we did not find connection

	iResult = -1;
    }

    //- else

    else
    {
	//- set result

	iResult = pqpsid.iSerialID;
    }

    //- free cloned projection query

    ProjectionQueryFree(ppqCloned);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryTraverseConnections()
///
/// ARGS.:
///
///	ppq...........: projection query
///	psi...........: solver registration
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections.
///
///	Call processor on connections.  If no connections, always 
///	successfull.
///
/// **************************************************************************

int
ProjectionQueryTraverseConnections
(struct ProjectionQuery *ppq,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- if cursor already in use

	if (ppq->iCursor != -1)
	{
	    //- return failure

	    return(0);
	}

	//- if no projections

	if (ppq->iProjections == 0)
	{
	    //- return ok.

	    return(1);
	}
    }

    //- if no caches for projection query

    if ((!ppq->pcc
	 || !ppq->poccPre
	 || !ppq->poccPost)
	&& ppq->bCaching)
    {
	//- build caches first

	if (!ProjectionQueryBuildCaches(ppq))
	{
	    return(0);
	}
    }

    //- if caches

    if (ppq->bCaching)
    {
	int i = 0;
	struct CachedConnection *pcconn = NULL;
	struct PidinStack *ppistTraversal = NULL;
	struct TreespaceTraversal *ptstr = NULL;

	//- get a treespace traversal context

	//! if this is solved, enabled the associated code in br2p and
	//! test with the connection matrix explorer.

	//! what I could do here :
	//!
	//! attach to each cached connection
	//!     1. projection cursor of projection query
	//!     2. serial to projection of connection
	//! use context of projection the connection belongs to do traversal
	//! inform struct TreespaceTraversal about serial of connection
	//!     before pre- or post-processing

	ppistTraversal = PidinStackCalloc();

	//- get a treespace traversal

	ptstr
	    = TstrNew
	      (ppistTraversal,
	       NULL,
	       NULL,
	       pfProcessor,
	       pvUserdata,
	       pfFinalizer,
	       pvUserdata);

	//- traverse cached connection entries

	for (i = 0 ;
	     i < ConnectionCacheGetNumberOfConnections(ppq->pcc) ;
	     i++)
	{
	    int iPreProcessor = -1;
	    int iPostProcessor = -1;
	    struct symtab_HSolveListElement *phsle = NULL;

	    pcconn = ConnectionCacheGetEntry(ppq->pcc, i);

	    //- set cursor

	    if (ppq->iCursor != 100000)
	    {
		ppq->iCursor = -1; // CachedConnectionGetCursor(pcconn);
	    }

	    //t calculate serial of connection:
	    //t the serial of the connection is defined during the 
	    //t traversal of the projection, to build the cache.
	    //t So it has to go in the cache, and then set in the traversal
	    //t overhere.  This means that the stream served by a projectionquery
	    //t can be out of order.

	    //- call processor and finalizer on connection

	    //! if this is solved, enabled the associated code in br2p and
	    //! test with the connection matrix explorer.

	    //! this prepare is real dirty : officially the treespace traversal 
	    //! has been not initialized yet, a call to
	    //! TstrTraverse() is necessary to do this.
	    //! I only need to set ->phsleActual, so this should do it for
	    //! the moment.

/* 	    phsle */
/* 		= (struct symtab_HSolveListElement *) */
/* 		  CachedConnectionGetConnection(pcconn); */

	    TstrPrepareForSerial(ptstr, -1);

	    TstrSetActual(ptstr, (struct CoreRoot *)pcconn);

	    TstrSetActualType(ptstr, HIERARCHY_TYPE_symbols_cached_connection);

	    if (pfProcessor)
	    {
		iPreProcessor = pfProcessor(ptstr, pvUserdata);
	    }
	    else
	    {
		iPreProcessor = TSTR_PROCESSOR_SUCCESS;
	    }

	    if (!pfFinalizer)
	    {
		if (iPreProcessor == TSTR_PROCESSOR_ABORT)
		{
		    iResult = -1;
		}
		else
		{
		    iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
		}
	    }
	    else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS)
	    {
		iPostProcessor = pfFinalizer(ptstr, pvUserdata);
	    }
	    else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
	    {
		iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
	    }
	    else
	    {
		iPostProcessor = TSTR_SELECTOR_FAILURE;
	    }

	    TstrRepairForSerial(ptstr, -1);

	    //- if some failure

	    if (iResult != 1
		|| iPostProcessor == TSTR_SELECTOR_FAILURE)
	    {
		//- break traversal

		break;
	    }
	}

	//- delete traversal

	TstrDelete(ptstr);
    }

    //- else (without caches)

    else
    {
	int i;

	//- loop over projections

	for (i = 0 ; i < ppq->iProjections ; i++)
	{
	    //- set cursor

	    ppq->iCursor = i;

	    //- traverse connections

	    iResult
		= ProjectionTraverseConnections
		  (ppq->ppproj[i],
		   ppq->pppist[i],
/* 		   psi, */
		   pfProcessor,
		   pfFinalizer,
		   pvUserdata);

	    if (iResult != 1)
	    {
		break;
	    }
	}
    }

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- reset cursor

	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryTraverseProjectionConnections()
///
/// ARGS.:
///
///	ppq...........: projection query
///	psi...........: solver registration
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections, do not use any caches.
///
///	Call processor on connections.  If no connections, always 
///	successfull.
///
///	This function never uses caches, so it can be used for cache
///	maintenance.
///
/// **************************************************************************

static int
ProjectionQueryTraverseProjectionConnections
(struct ProjectionQuery *ppq,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    int i;

    //- if cursor already in use

    if (ppq->iCursor != -1)
    {
	//- return failure

	return(0);
    }

    //- if no projections

    if (ppq->iProjections == 0)
    {
	//- return ok.

	return(1);
    }

    //- loop over projections

    for (i = 0 ; i < ppq->iProjections ; i++)
    {
	//- set cursor

	ppq->iCursor = i;

	//- traverse connections

	iResult
	    = ProjectionTraverseConnections
	      (ppq->ppproj[i],
	       ppq->pppist[i],
/* 	       psi, */
	       pfProcessor,
	       pfFinalizer,
	       pvUserdata);

	if (iResult != 1)
	{
	    break;
	}
    }

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- reset cursor

	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryTraverseConnectionsForPostSerial()
///
/// ARGS.:
///
///	ppq...........: projection query
///	iReceiver.....: spike receiver
///	psi...........: solver registration
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections attached to spikerec and solver.
///
///	Call processor on connections attached to spikerec, but only if 
///	the spikegens of the connections are solved by the solver given
///	by psi.
///
///	If no connections, always successfull.
///
/// **************************************************************************

int
ProjectionQueryTraverseConnectionsForPostSerial
(struct ProjectionQuery *ppq,
 int iReceiver,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- if cursor already in use

	if (ppq->iCursor != -1)
	{
	    //- return failure

	    return(0);
	}

	//- if no projections

	if (ppq->iProjections == 0)
	{
	    //- return ok

	    return(1);
	}
    }

    //- if no caches for projection query

    if ((!ppq->pcc
	 || !ppq->poccPre
	 || !ppq->poccPost)
	&& ppq->bCaching)
    {
	//- build caches first

	if (!ProjectionQueryBuildCaches(ppq))
	{
	    return(0);
	}
    }

    //- if caches

    if (ppq->bCaching)
    {
	int i = -1;
	int iFirst = -1;
	struct CachedConnection *pcconn = NULL;
	struct PidinStack *ppistTraversal = NULL;

	//- get a treespace traversal context

	//! what I could do here :
	//!
	//! attach to each cached connection
	//!     1. projection cursor of projection query
	//!     2. serial to projection of connection
	//! use context of projection the connection belongs to do traversal
	//! inform struct TreespaceTraversal about serial of connection
	//!     before pre- or post-processing

	ppistTraversal = PidinStackCalloc();

	//- get first entry from cache

	iFirst
	    = OrderedConnectionCacheGetFirstIndexForSerial
	      (ppq->poccPost, ppq, iReceiver);

	i = iFirst;

	//- if found

	if (iFirst != -1)
	{
	    struct TreespaceTraversal *ptstr = NULL;

	    //- get a treespace traversal

	    ptstr
		= TstrNew
		  (ppistTraversal,
		   NULL,
		   NULL,
		   pfProcessor,
		   pvUserdata,
		   pfFinalizer,
		   pvUserdata);

	    //- traverse entries for spike receiver

	    pcconn = OrderedConnectionCacheGetEntry(ppq->poccPost, i);

	    while (CachedConnectionGetCachedPost(pcconn) == iReceiver)
	    {
		int iPreProcessor = -1;
		int iPostProcessor = -1;
		struct symtab_HSolveListElement *phsle = NULL;

		//- set cursor

		if (ppq->iCursor != 100000)
		{
		    ppq->iCursor = -1; // CachedConnectionGetCachedCursor(pcconn);
		}

		//t calculate serial of connection:
		//t the serial of the connection is defined during the 
		//t traversal of the projection, to build the cache.
		//t So it has to go in the cache, and then set in the traversal
		//t overhere.  This means that the stream served by a projectionquery
		//t can be out of order.

		//- call processor and finalizer on connection

		//! if this is solved, enabled the associated code in br2p and
		//! test with the connection matrix explorer.

		//! this prepare is real dirty : officially the treespace traversal 
		//! has not been initialized yet, a call to 
		//! TstrTraverse() is necessary to do this.
		//! I only need to set ->phsleActual, so this should do it for
		//! the moment.

/* 		phsle */
/* 		    = (struct symtab_HSolveListElement *) */
/* 		      CachedConnectionGetCachedConnection(pcconn); */

		TstrPrepareForSerial(ptstr, -1);

		TstrSetActual(ptstr, (struct CoreRoot *)pcconn);

		TstrSetActualType(ptstr, HIERARCHY_TYPE_symbols_cached_connection);

		if (pfProcessor)
		{
		    iPreProcessor = pfProcessor(ptstr,pvUserdata);
		}
		else
		{
		    iPreProcessor = TSTR_PROCESSOR_SUCCESS;
		}

		if (!pfFinalizer)
		{
		    if (iPreProcessor == TSTR_PROCESSOR_ABORT)
		    {
			iResult = -1;
		    }
		    else
		    {
			iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
		    }
		}
		else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS)
		{
		    iPostProcessor = pfFinalizer(ptstr,pvUserdata);
		}
		else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
		{
		    iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
		}
		else
		{
		    iPostProcessor = TSTR_SELECTOR_FAILURE;
		}

		TstrRepairForSerial(ptstr, -1);

		//- if some failure

		if (iResult != 1
		    || iPostProcessor == TSTR_SELECTOR_FAILURE)
		{
		    //- break traversal

		    break;
		}

		//- get next ordered connection

		i++;

		pcconn = OrderedConnectionCacheGetEntry(ppq->poccPost, i);
	    }

	    //- delete traversal

	    TstrDelete(ptstr);
	}
    }

    //- else without caches

    else
    {
	int i;

	//- loop over projections

	for (i = 0 ; i < ppq->iProjections ; i++)
	{
	    //- set cursor

	    ppq->iCursor = i;

	    //- traverse connections

	    iResult
		= ProjectionTraverseConnectionsForPostSerial
		  (ppq->ppproj[i],
		   ppq->pppist[i],
		   iReceiver,
/* 		   psi, */
		   pfProcessor,
		   pfFinalizer,
		   pvUserdata);

	    if (iResult != 1)
	    {
		break;
	    }
	}
    }

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- reset cursor

	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryTraverseConnectionsForSpikeGenerator()
///
/// ARGS.:
///
///	ppq...........: projection query
///	ppist.........: spike generator
///	psi...........: solver registration
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections attached to spikegen and solver.
///
///	Call processor on connections attached to spikegen, but only if 
///	the spikerecs of the connections are solved by the solver given
///	by psi.
///
///	If no connections, always successfull.
///
/// **************************************************************************

int
ProjectionQueryTraverseConnectionsForSpikeGenerator
(struct ProjectionQuery *ppq,
 struct PidinStack *ppist,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- if cursor already in use

	if (ppq->iCursor != -1)
	{
	    //- return failure

	    return(0);
	}

	//- if no projections

	if (ppq->iProjections == 0)
	{
	    //- return ok

	    return(1);
	}
    }

    //- if no caches for projection query

    if ((!ppq->pcc
	 || !ppq->poccPre
	 || !ppq->poccPost)
	&& ppq->bCaching)
    {
	//- build caches first

	if (!ProjectionQueryBuildCaches(ppq))
	{
	    return(0);
	}
    }

    //- if caches

    if (ppq->bCaching)
    {
	int i = -1;
	int iFirst = -1;
	int iSpikeGenerator = -1;
	struct CachedConnection *pcconn = NULL;
	struct PidinStack *ppistTraversal = NULL;

	//- get a treespace traversal context

	//! if this is solved, enabled the associated code in br2p and
	//! test with the connection matrix explorer.

	//! what I could do here :
	//!
	//! attach to each cached connection
	//!     1. projection cursor of projection query
	//!     2. serial to projection of connection
	//! use context of projection the connection belongs to do traversal
	//! inform struct TreespaceTraversal about serial of connection
	//!     before pre- or post-processing

	ppistTraversal = PidinStackCalloc();

	//- get serial for spike generator

	//! update cache

	PidinStackLookupTopSymbol(ppist);

	iSpikeGenerator = PidinStackToSerial(ppist);

	//- get first entry from cache

	iFirst
	    = OrderedConnectionCacheGetFirstIndexForSerial
	      (ppq->poccPre, ppq, iSpikeGenerator);

	i = iFirst;

	//- if found

	if (iFirst != -1)
	{
	    struct TreespaceTraversal *ptstr = NULL;

	    //- get a treespace traversal

	    ptstr
		= TstrNew
		  (ppistTraversal,
		   NULL,
		   NULL,
		   pfProcessor,
		   pvUserdata,
		   pfFinalizer,
		   pvUserdata);

	    //- traverse entries for spike generator

	    pcconn = OrderedConnectionCacheGetEntry(ppq->poccPre,i);

	    while (CachedConnectionGetCachedPre(pcconn) == iSpikeGenerator)
	    {
		int iPreProcessor = -1;
		int iPostProcessor = -1;
		struct symtab_HSolveListElement *phsle = NULL;

		//- set cursor

		if (ppq->iCursor != 100000)
		{
		    ppq->iCursor = -1; // CachedConnectionGetCachedCursor(pcconn);
		}

		//t calculate serial of connection:
		//t the serial of the connection is defined during the 
		//t traversal of the projection, to build the cache.
		//t So it has to go in the cache, and then set in the traversal
		//t overhere.  This means that the stream served by a projectionquery
		//t can be out of order.

		//- call processor and finalizer on connection

		//! if this is solved, enabled the associated code in br2p and
		//! test with the connection matrix explorer.

		//! this prepare is real dirty : officially the treespace traversal 
		//! has been not initialized yet, a call to
		//! TstrTraverse() is necessary to do this.
		//! I only need to set ->phsleActual, so this should do it for
		//! the moment.

/* 		phsle */
/* 		    = (struct symtab_HSolveListElement *) */
/* 		      CachedConnectionGetCachedConnection(pcconn); */

		TstrPrepareForSerial(ptstr, -1);

		TstrSetActual(ptstr, (struct CoreRoot *)pcconn);

		TstrSetActualType(ptstr, HIERARCHY_TYPE_symbols_cached_connection);

		if (pfProcessor)
		{
		    iPreProcessor = pfProcessor(ptstr,pvUserdata);
		}
		else
		{
		    iPreProcessor = TSTR_PROCESSOR_SUCCESS;
		}

		if (!pfFinalizer)
		{
		    if (iPreProcessor == TSTR_PROCESSOR_ABORT)
		    {
			iResult = -1;
		    }
		    else
		    {
			iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
		    }
		}
		else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS)
		{
		    iPostProcessor = pfFinalizer(ptstr,pvUserdata);
		}
		else if (iPreProcessor == TSTR_PROCESSOR_SUCCESS_NO_FINALIZE)
		{
		    iPostProcessor = TSTR_SELECTOR_PROCESS_SIBLING;
		}
		else
		{
		    iPostProcessor = TSTR_SELECTOR_FAILURE;
		}

		TstrRepairForSerial(ptstr, -1);

		//- if some failure

		if (iResult != 1
		    || iPostProcessor == TSTR_SELECTOR_FAILURE)
		{
		    //- break traversal

		    break;
		}

		//- get next ordered connection

		i++;

		pcconn = OrderedConnectionCacheGetEntry(ppq->poccPre,i);
	    }

	    //- delete traversal

	    TstrDelete(ptstr);
	}
    }

    //- else without caches

    else
    {
	int i;

	//- loop over projections

	for (i = 0 ; i < ppq->iProjections ; i++)
	{
	    //- set cursor

	    ppq->iCursor = i;

	    //- traverse connections

	    iResult
		= ProjectionTraverseConnectionsForSpikeGenerator
		  (ppq->ppproj[i],
		   ppq->pppist[i],
		   ppist,
/* 		   psi, */
		   pfProcessor,
		   pfFinalizer,
		   pvUserdata);

	    if (iResult != 1)
	    {
		break;
	    }
	}
    }

    //- if the projection query is not from a file cache

    if (ppq->iCursor != 100000)
    {
	//- reset cursor

	ppq->iCursor = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionQueryTraverseConnectionsForSpikeReceiver()
///
/// ARGS.:
///
///	ppq...........: projection query
///	ppist.........: spike receiver
///	psi...........: solver registration
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections attached to spikerec and solver.
///
///	Call processor on connections attached to spikerec, but only if 
///	the spikegens of the connections are solved by the solver given
///	by psi.
///
///	If no connections, always successfull.
///
/// **************************************************************************

int
ProjectionQueryTraverseConnectionsForSpikeReceiver
(struct ProjectionQuery *ppq,
 struct PidinStack *ppist,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    int iSpikeReceiver = -1;

    //- get serial for spike receiver

    //! update cache

    PidinStackLookupTopSymbol(ppist);

    iSpikeReceiver = PidinStackToSerial(ppist);

    //- traverse connections for spike receiver serial

    iResult
	= ProjectionQueryTraverseConnectionsForPostSerial
	  (ppq,
	   iSpikeReceiver,
/* 	   psi, */
	   pfProcessor,
	   pfFinalizer,
	   pvUserdata);

    //- return result

    return(iResult);
}


