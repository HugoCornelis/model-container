//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionquery.h 1.30 Tue, 11 Sep 2007 18:50:57 -0500 hugo $
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



#ifndef PROJECTIONQUERY_H
#define PROJECTIONQUERY_H


//d declarations

struct ProjectionQuery;


//f static inlines

static inline
int ProjectionQueryGetCurrentSourceSerial(struct ProjectionQuery *ppq);

static inline
int ProjectionQueryGetCurrentTargetSerial(struct ProjectionQuery *ppq);

static inline
struct PidinStack *
ProjectionQueryGetSource(struct ProjectionQuery *ppq, int iCursor);

static inline
int ProjectionQueryGetSourceSerial(struct ProjectionQuery *ppq, int iCursor);

static inline
struct PidinStack *
ProjectionQueryGetTarget(struct ProjectionQuery *ppq, int iCursor);

static inline
int ProjectionQueryGetTargetSerial(struct ProjectionQuery *ppq, int iCursor);

static inline
void ProjectionQuerySetCaching(struct ProjectionQuery *ppq, int bCaching);


#include "connectioncache.h"
#include "orderedconnectioncache.h"


struct ProjectionQuery
{
    //m memory used by this projection query, with caches etc.

    int iMemoryUsed;

    //m number of projections involved

    int iProjections;

    //m active entry

    int iCursor;

    //m caching allowed ?

    int bCaching;

    //m how many times has projectionquery been cloned

    int iCloned;

    //m if cloned, original projectionquery.

    struct ProjectionQuery *ppqCloned;

    //m context of projections

    struct PidinStack **pppist;

    //m projection symbols

    struct symtab_Projection **ppproj;

    //m projection sources

    int *piSource;

    struct PidinStack **pppistSource;

    //m projection targets

    int *piTarget;

    struct PidinStack **pppistTarget;

    //m connection cache

    struct ConnectionCache *pcc;

    //m connection cache sorted on pre synaptic principal

    struct OrderedConnectionCache *poccPre;

    //m connection cache sorted on post synaptic principal

    struct OrderedConnectionCache *poccPost;
};



#include "connection.h"
#include "pidinstack.h"
#include "projection.h"
#include "solverinfo.h"


int ProjectionQueryBuildCaches(struct ProjectionQuery *ppq);

int
ProjectionQueryBuildOrderedConnectionCaches(struct ProjectionQuery *ppq);

struct ProjectionQuery *
ProjectionQueryCallocFromProjections
(struct PidinStack **pppistProjections,int iProjections);

struct ProjectionQuery *
ProjectionQueryCallocFromSolverRegistrations
(struct SolverInfo *psiSolvers,int iSolvers);

struct ProjectionQuery *ProjectionQueryClone(struct ProjectionQuery *ppq);

int ProjectionQueryCountConnections(struct ProjectionQuery *ppq);

int
ProjectionQueryCountConnectionsForSpikeGenerator
(struct ProjectionQuery *ppq,struct PidinStack *ppist);

int
ProjectionQueryCountConnectionsForSpikeReceiver
(struct ProjectionQuery *ppq,struct PidinStack *ppist);

void ProjectionQueryFree(struct ProjectionQuery *ppq);

int ProjectionQueryInit
(struct ProjectionQuery *ppq,
 struct PidinStack **pppistProjections,
 int iProjections);

int
ProjectionQueryLookupPostSerialID
(struct ProjectionQuery *ppq,struct symtab_Connection *pconn);

int
ProjectionQueryLookupPostSerialIDForAbsoluteSerials
(struct ProjectionQuery *ppq,int iPre,int iPost);

int
ProjectionQueryTraverseConnections
(struct ProjectionQuery *ppq,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
ProjectionQueryTraverseConnectionsForPostSerial
(struct ProjectionQuery *ppq,
 int iReceiver,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
ProjectionQueryTraverseConnectionsForSpikeGenerator
(struct ProjectionQuery *ppq,
 struct PidinStack *ppist,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
ProjectionQueryTraverseConnectionsForSpikeReceiver
(struct ProjectionQuery *ppq,
 struct PidinStack *ppist,
/*  struct SolverInfo *psi, */
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


/* // get solution engines for sources of projection */

/* int */
/* ProjectionQuery_GetSourceSolvers */
/* (struct ProjectionQuery *ppq,struct ProjectionQueryResult *ppqr); */


/* // get solution engines for targets of projection */

/* int */
/* ProjectionQuery_GetTargetSolvers */
/* (struct ProjectionQuery *ppq,struct ProjectionQueryResult *ppqr); */


/* // return number of spikegens for entire population */

/* int */
/* ProjectionQuery_GetNumberOfSpikeGeneratorsForPopulation */
/* (struct ProjectionQuery *ppq,struct PidinStack *ppistCell); */


/* // return number of spike receivers for entire population */

/* int */
/* ProjectionQuery_GetNumberOfSpikeReceiversForPopulation */
/* (struct ProjectionQuery *ppq,struct PidinStack *ppistCell); */


//f static inlines

///
/// set caching for projection query
///

static inline
void ProjectionQuerySetCaching(struct ProjectionQuery *ppq, int bCaching)
{
    ppq->bCaching = bCaching;
}


///
/// get current source serial for projection query
///

static inline
int ProjectionQueryGetCurrentSourceSerial(struct ProjectionQuery *ppq)
{
    return(ProjectionQueryGetSourceSerial(ppq,ppq->iCursor));
}


///
/// get current target serial for projection query
///

static inline
int ProjectionQueryGetCurrentTargetSerial(struct ProjectionQuery *ppq)
{
    return(ProjectionQueryGetTargetSerial(ppq,ppq->iCursor));
}


///
/// get memory size taken by projection query.
///

static inline 
int ProjectionQueryGetMemorySize(struct ProjectionQuery *ppq)
{
    return(ppq->iMemoryUsed);
}


///
/// Get source for a projection in the query.  NULL means the
/// projection is not being used.
///

static inline
struct PidinStack *
ProjectionQueryGetSource(struct ProjectionQuery *ppq, int iCursor)
{
    struct PidinStack *ppistResult = NULL;

    if (iCursor != 100000)
    {
	ppistResult = ppq->pppistSource[iCursor];
    }

    return(ppistResult);
}


///
/// Get source serial for a projection in the query.  -1 means the
/// projection is not being used.
///

static inline
int ProjectionQueryGetSourceSerial(struct ProjectionQuery *ppq, int iCursor)
{
    if (iCursor != 100000)
    {
	return(ppq->piSource[iCursor]);
    }
    else
    {
	return 0;
    }
}


///
/// Get target for a projection in the query.  NULL means the
/// projection is not being used.
///

static inline
struct PidinStack *
ProjectionQueryGetTarget(struct ProjectionQuery *ppq, int iCursor)
{
    struct PidinStack *ppistResult = NULL;

    if (iCursor != 100000)
    {
	ppistResult = ppq->pppistTarget[iCursor];
    }

    return(ppistResult);
}


///
/// Get target serial for a projection in the query.  -1 means the
/// projection is not being used.
///

static inline
int ProjectionQueryGetTargetSerial(struct ProjectionQuery *ppq, int iCursor)
{
    if (iCursor != 100000)
    {
	return(ppq->piTarget[iCursor]);
    }
    else
    {
	return 0;
    }
}


#endif


