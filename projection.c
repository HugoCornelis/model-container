//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projection.c 1.67 Fri, 07 Dec 2007 11:59:10 -0600 hugo $
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



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/pidinstack.h"
#include "neurospaces/projection.h"
#include "neurospaces/treespacetraversal.h"

#include "neurospaces/symbolvirtual_protos.h"


// local function prototypes

static int 
ProjectionConnectionCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionConnectionSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionConnectionSourceProcessor
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionConnectionTargetProcessor
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionConnectionTargetCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionConnectionTargetCounterGroupProcessor
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionSpikeGenConnectionCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionSpikeGenSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionSpikeRecConnectionCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

static int 
ProjectionSpikeRecSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata);

/* static int  */
/* ProjectionConnectionSpikeGeneratorOfSolverProcessor */
/* (struct TreespaceTraversal *ptstr, */
/*  void *pvUserdata); */

/* static int  */
/* ProjectionConnectionSpikeReceiverOfSolverProcessor */
/* (struct TreespaceTraversal *ptstr, */
/*  void *pvUserdata); */



/// **************************************************************************
///
/// SHORT: ProjectionCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Projection * 
///
///	Newly allocated projection, NULL for failure
///
/// DESCR: Allocate a new projection symbol table element
///
/// **************************************************************************

struct symtab_Projection * ProjectionCalloc(void)
{
    //- set default result : failure

    struct symtab_Projection *pprojResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/projection_vtable.c"

    //- allocate projection

    pprojResult
	= (struct symtab_Projection *)
	  SymbolCalloc(1, sizeof(struct symtab_Projection), _vtable_projection, HIERARCHY_TYPE_symbols_projection);

    //- initialize projection

    ProjectionInit(pprojResult);

    //- return result

    return(pprojResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionConnectionForPostSerialSelector()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Selects connections if they come from a registered spikerec.
///
/// **************************************************************************

static int 
ProjectionConnectionForPostSerialSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : process only children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- get pointer to query result struct

    struct PQ_ConnsForPostSerial_Result *ppqr
	= (struct PQ_ConnsForPostSerial_Result *)pvUserdata;

    //- if connection symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct symtab_Connection *pconn
	    = (struct symtab_Connection *)phsle;

	//- get post serial

	int iTarget = ProjectionGetTargetSerial(ppqr->pproj, ppqr->ppistProjection);

	int iPost = ConnectionGetPost(pconn, iTarget);

	//- if match

	//! iPost is absolute, ppqr->iPost is relative, cannot match

	if (iPost == ppqr->iPost)
	{
	    //- ok, select connection

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionConnectionForPreSerialSelector()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Selects connections if they come from a registered spikegen.
///
/// **************************************************************************

static int 
ProjectionConnectionForPreSerialSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : process only children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- get pointer to query result struct

    struct PQ_ConnsForPreSerial_Result *ppqr
	= (struct PQ_ConnsForPreSerial_Result *)pvUserdata;

    //- if connection symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct symtab_Connection *pconn
	    = (struct symtab_Connection *)phsle;

	//- get pre serial

	//t needs target population, available from projection
	//t ProjectionGetSourceSerial()

	int iSource = ProjectionGetSourceSerial(ppqr->pproj, ppqr->ppistProjection);

	int iPre = ConnectionGetPre(pconn, iSource);

	//- if match

	if (iPre == ppqr->iPre)
	{
	    //- ok, select connection

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionConnectionSourceProcessor()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Translate vector traversal to traversal over connection sources.
///
///	The user data is supposed to have registered preprocesor and 
///	postprocessor. For vectors encountered in this traversal (which are
///	supposed to be connection vectors), a new traversal is created and
///	used to do traversal with the registered preprocessor and 
///	postprocessor.
///	Only spikegens are traversed (due to hardcoded selector).
///
/// **************************************************************************

static int 
ProjectionConnectionSourceProcessor
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get pointer to query result struct

    struct PQ_ConnsForSpikegen_Result *ppqr
	= (struct PQ_ConnsForSpikegen_Result *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection vector

    int iType = TstrGetActualType(ptstr);

    if (subsetof_v_connection_symbol(iType))
    {
	//- init treespace traversal to go over individual connections

	struct TreespaceTraversal *ptstrConns
	    = TstrNew
	      (ptstr->ppist,
	       ProjectionSpikeGenSelector,
	       (void *)ppqr,
	       ppqr->pfProcessor,
	       ppqr->pvUserdata,
	       ppqr->pfFinalizer,
	       ppqr->pvUserdata);

	//- traverse connections for spikegen

	int iResult2 = TstrGo(ptstrConns,phsle);

	//- delete treespace traversal

	TstrDelete(ptstrConns);

	//- if failure/abort traversing connections

	if (iResult2 == -1 || iResult2 == 0)
	{
	    //- stop parent traverse

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }

    //- else if connection

    else if (subsetof_connection(iType))
    {
	//- call processor and finalizer in order

	ppqr->pfProcessor(ptstr,ppqr->pvUserdata);

	ppqr->pfFinalizer(ptstr,ppqr->pvUserdata);
    }

    //- return result : remember won't go any deeper to traverse connections

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionConnectionTargetProcessor()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Translate vector traversal to traversal over connection targets.
///
///	The user data is supposed to have registered procesor and 
///	finalizer. For vectors encountered in this traversal (which are
///	supposed to be connection vectors), a new traversal is created and
///	used to do traversal with the registered processor and finalizer.
///	Only spikerecs are traversed (due to hardcoded selector).
///
/// **************************************************************************

static int 
ProjectionConnectionTargetProcessor
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get pointer to query result struct

    struct PQ_ConnsForSpikerec_Result *ppqr
	= (struct PQ_ConnsForSpikerec_Result *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection vector

    int iType = TstrGetActualType(ptstr);

    if (subsetof_v_connection_symbol(iType))
    {
	//- init treespace traversal to go over individual connections

	struct TreespaceTraversal *ptstrConns
	    = TstrNew
	      (ptstr->ppist,
	       ProjectionSpikeRecSelector,
	       (void *)ppqr,
	       ppqr->pfProcessor,
	       ppqr->pvUserdata,
	       ppqr->pfFinalizer,
	       ppqr->pvUserdata);

	//- traverse connections for spikerec

	int iResult2 = TstrGo(ptstrConns,phsle);

	//- delete treespace traversal

	TstrDelete(ptstrConns);

	//- if failure/abort traversing connections

	if (iResult2 == -1 || iResult2 == 0)
	{
	    //- stop parent traverse

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }

    //- else if connection

    else if (subsetof_connection(iType))
    {
	//- call processor and finalizer in order

	ppqr->pfProcessor(ptstr,ppqr->pvUserdata);

	ppqr->pfFinalizer(ptstr,ppqr->pvUserdata);
    }

    //- return result : remember won't go any deeper to traverse connections

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionCountConnections()
///
/// ARGS.:
///
///	pproj...: projection
///	ppist...: context of projection
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Get number of connections in projection
///
///	connections == synapses
///
/// **************************************************************************

int ProjectionCountConnections
(struct symtab_Projection *pproj,struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse connection symbols and count them

    if (ProjectionTraverseConnections
	(pproj,
	 ppist,
	 SymbolConnectionCounter,
	 NULL,
	 (void *)&iResult) != 1)
    {
	//- set result : failure

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionCreateAlias()
///
/// ARGS.:
///
///	pproj.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
ProjectionCreateAlias
(struct symtab_Projection *pproj,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Projection *pprojResult = ProjectionCalloc();

    //- set name and prototype

    SymbolSetName(&pprojResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pprojResult->bio.ioh.iol.hsle, &pproj->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_projection);

    //- return result

    return(&pprojResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: ProjectionGetNumberOfConnectionsForSpikeGenerator()
///
/// ARGS.:
///
///	pproj.........: projection
///	ppist.........: context of projection
///	ppistSpikeGen.: spike generator
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Get number of connections for a single spikegen
///
///	connections == affected synapses attached to a spikegen
///
/// **************************************************************************

int
ProjectionGetNumberOfConnectionsForSpikeGenerator
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeGen)
{
    //- set default result : none

    int iResult = 0;

    //- traverse connection symbols, counting them, if failure

    if (ProjectionTraverseConnectionsForSpikeGenerator
	(pproj,
	 ppist,
	 ppistSpikeGen,
	 ProjectionSpikeGenConnectionCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	//- set result : failure

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionGetNumberOfConnectionsForSpikeReceiver()
///
/// ARGS.:
///
///	pproj.........: projection
///	ppist.........: context of projection
///	ppistSpikeRec.: spike receiver (attachment point)
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Get number of connections for a single spike receiver
///
///	connections == affected synapses attached to a spike receiver
///
/// **************************************************************************

int
ProjectionGetNumberOfConnectionsForSpikeReceiver
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeRec)
{
    //- set default result : none

    int iResult = 0;

    //- traverse connection symbols, counting them, if failure

    if (ProjectionTraverseConnectionsForSpikeReceiver
	(pproj,
	 ppist,
	 ppistSpikeRec,
	 ProjectionSpikeRecConnectionCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	//- set result : failure

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ProjectionGetNumberOfConnectionsOnThisTarget() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pproj.......: projection query */
/* ///	ppist.......: context of projection */
/* ///	ppistTarget.: population target */
/* /// */
/* /// RTN..: int : number of connections, -1 for failure */
/* /// */
/* /// DESCR: Get number of connections for given target population */
/* /// */
/* ///	#connections == #affected synapses in the target population */
/* /// */
/* /// NOTE.: DO NOT USE, will be removed */
/* /// */
/* /// ************************************************************************** */

/* static int  */
/* ProjectionConnectionTargetCounter */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : ok, but process sibling afterwards */

/*     int iResult = SYMBOL_PROCESSOR_FAILURE; */

/*     //- get pointer to query result struct */

/*     struct PQ_ConnsForTarget_Result *ppqr */
/* 	= (struct PQ_ConnsForTarget_Result *)pvUserdata; */

/*     //- if connection symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     if (InstanceOfConnection(phsle)) */
/*     { */
/* 	//- increment connection count */

/* 	ppqr->iConnections++; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */

/* static int  */
/* ProjectionConnectionTargetCounterGroupProcessor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : ok, but process sibling afterwards */

/*     int iResult = SYMBOL_PROCESSOR_FAILURE; */

/*     //- get pointer to query result struct */

/*     struct PQ_ConnsForTarget_Result *ppqr */
/* 	= (struct PQ_ConnsForTarget_Result *)pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- if connection vector */

/*     if (InstanceOfVConnection(phsle)) */
/*     { */
/* 	struct TreespaceTraversal tstr; */

/* 	int iResult2; */

/* 	//- init treespace traversal */

/* 	memset(&tstr,0,sizeof(tstr)); */

/* 	tstr.pfPreSelector = NULL; */
/* 	tstr.pfProcesor = ProjectionConnectionTargetCounter; */
/* 	tstr.pfFinalizer = NULL; //ptstr->pfFinalizer; */
/* 	tstr.pvProcessor = pvUserdata; */

/* 	//- allocate symbol stack */

/* 	tstr.ppist = PidinStackDuplicate(ptstr->ppist); */

/* 	//- count connections for spikegen */

/* 	iResult2 = TstrTraverse(&tstr,phsle); */

/* 	//- delete treespace traversal */

/* 	TstrDelete(ptstr); */

/* 	//- if failure/abort counting connections */

/* 	if (iResult2 == -1 || iResult == 0) */
/* 	{ */
/* 	    //- stop parent traverse */

/* 	    iResult = SYMBOL_PROCESSOR_ABORT; */
/* 	} */
/*     } */

/*     //- return result : remember will go any deeper to individual connections */

/*     return(iResult); */
/* } */

/* int */
/* ProjectionGetNumberOfConnectionsOnThisTarget */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistTarget) */
/* { */
/*     //- set default result : failure */

/*     int iResult = -1; */

/*     struct PQ_ConnsForTarget_Result pqr = */
/*     { */
/* 	0, */
/* 	pproj, */
/* 	ppist, */
/* 	ppistTarget, */
/*     }; */

/*     //- traverse connection symbols */

/*     iResult */
/* 	= ProjectionTraverseConnections */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ProjectionConnectionTargetCounterGroupProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

/*     //- if success */

/*     if (iResult == TRUE) */
/*     { */
/* 	//- set result : number of connections */

/* 	iResult = pqr.iConnections; */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- return failure */

/* 	iResult = -1; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ProjectionGetSourceSerial()
///
/// ARGS.:
///
///	pproj.: projection.
///	ppist.: context of projection.
///
/// RTN..: int : Serial for source population, -1 for failure.
///
/// DESCR: Calculate serial for source population.
///
/// **************************************************************************

int
ProjectionGetSourceSerial
(struct symtab_Projection *pproj,struct PidinStack *ppist)
{
    //- set default result : failure

    int iResult = -1;

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)pproj;

    //- get source population context

    struct symtab_Parameters *pparSource
	= SymbolFindParameter(phsle,"SOURCE",ppist);

    struct PidinStack *ppistSource
	= ParameterResolveToPidinStack(pparSource,ppist);

    //- try to update cache

    PidinStackLookupTopSymbol(ppistSource);

    //- get serial

    iResult = PidinStackToSerial(ppistSource);

    if (iResult == INT_MAX)
    {
	iResult = -1;
    }

    //- free memory

    PidinStackFree(ppistSource);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionGetTargetSerial()
///
/// ARGS.:
///
///	pproj.: projection.
///	ppist.: context of projection.
///
/// RTN..: int : Serial for target population, -1 for failure.
///
/// DESCR: Calculate serial for target population.
///
/// **************************************************************************

int
ProjectionGetTargetSerial
(struct symtab_Projection *pproj,struct PidinStack *ppist)
{
    //- set default result : failure

    int iResult = -1;

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)pproj;

    //- get target population context

    struct symtab_Parameters *pparTarget
	= SymbolFindParameter(phsle,"TARGET",ppist);

    struct PidinStack *ppistTarget
	= ParameterResolveToPidinStack(pparTarget,ppist);

    //- try to update cache

    PidinStackLookupTopSymbol(ppistTarget);

    //- get serial

    iResult = PidinStackToSerial(ppistTarget);

    if (iResult == INT_MAX)
    {
	iResult = -1;
    }

    //- free memory

    PidinStackFree(ppistTarget);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionInit()
///
/// ARGS.:
///
///	pproj.: projection to init
///
/// RTN..: void
///
/// DESCR: init projection
///
/// **************************************************************************

void ProjectionInit(struct symtab_Projection *pproj)
{
    //- initialize base symbol

    BioComponentInit(&pproj->bio);

    //- set type

    pproj->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_projection;
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ProjectionLookupSerialID() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pproj..: projection query */
/* ///	ppist..: context of projection */
/* ///	pconn..: connection to lookup serial ID for */
/* /// */
/* /// RTN..: int : serial ID, -1 for failure */
/* /// */
/* /// DESCR: Lookup serial ID for a connection */
/* /// */
/* /// ************************************************************************** */

/* int ProjectionLookupSerialID */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct symtab_Connection *pconn) */
/* { */
/*     //- set result : cached from connection */

/*     int iResult = ConnectionGetSerialID(pconn); */

/*     //- if not set yet */

/*     if (iResult == -1) */
/*     { */
/* 	//- construct pidinstack for target */

/* 	struct PidinStack *ppistTarget = PidinStackCalloc(); */

/* 	PidinStackPushCompactAll(ppistTarget,ConnectionTargetPidin(pconn)); */

/* 	//- count connections for target of this connection */

/* 	//! this caches the serial ID for this target in the connections */

/* 	ProjectionGetNumberOfConnectionsForSpikeReceiver */
/* 	    (pproj,ppist,ppistTarget); */

/* 	//- free pidinstack */

/* 	PidinStackFree(ppistTarget); */
/*     } */

/*     //- set result : cached from connection */

/*     iResult = ConnectionGetSerialID(pconn); */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ProjectionSpikeGenConnectionCounter()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Increments (int *)ppqr->pvUserdata.
///
/// **************************************************************************

static int 
ProjectionSpikeGenConnectionCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

/*     //- get pointer to query result struct */

/*     struct PQ_ConnsForSpikegen_Result *ppqr */
/* 	= (struct PQ_ConnsForSpikegen_Result *)pvUserdata; */

/*     //- get pointer to connection counter */

/*     int *piConnections = (int *)ppqr->pvUserdata; */

    int *piConnections = (int *)pvUserdata;

    //- increment connection count

    (*piConnections)++;

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionSpikeGenSelector()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Selects connections if they come from a registered spikegen.
///
/// **************************************************************************

static int 
ProjectionSpikeGenSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get pointer to query result struct

    struct PQ_ConnsForSpikegen_Result *ppqr
	= (struct PQ_ConnsForSpikegen_Result *)pvUserdata;

    //- if connection symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct PidinStack *ppistConnection = NULL;

	//- get projection context

	struct PidinStack *ppistProjection = ppqr->ppistProjection;

	//- get projection symbol

	struct symtab_HSolveListElement *phsleProjection
/* 	    = SymbolsLookupHierarchical(NULL,ppistProjection); */
	    = PidinStackLookupTopSymbol(ppistProjection);

	//- get source population context

	struct symtab_Parameters *pparSource
	    = SymbolFindParameter(phsleProjection,"SOURCE",ppistProjection);

	struct PidinStack *ppistSource
	    = ParameterResolveToPidinStack(pparSource,ppistProjection);

/* 	ppistConnection = PidinStackDuplicate(ppistSource); */

	//- get spike generator context

	struct symtab_HSolveListElement *phsleSource
	    = PidinStackLookupTopSymbol(ppistSource);

	ppistConnection
	    = ConnectionGetSpikeGenerator
	      ((struct symtab_Connection *)phsle,phsleSource,ppistSource);

	//- cat spikegen context

	PidinStackAppendCompact(ppistSource,ppqr->ppistSpikegen);

/* 	//- get context for source of connection */

/* 	PidinStackPushCompactAll */
/* 	    (ppistConnection, */
/* 	     ConnectionSourcePidin((struct symtab_Connection *)phsle)); */

	//- if connection source is spikegen

	if (PidinStackEqual(ppistSource,ppistConnection))
	{
	    //- set result : selected

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}

	//- free pidinstacks

	PidinStackFree(ppistConnection);
	PidinStackFree(ppistSource);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionSpikeRecConnectionCounter()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Increments (int *)ppqr->pvUserdata.
///
/// **************************************************************************

static int 
ProjectionSpikeRecConnectionCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get pointer to query result struct

    int *piConnections = (int *)pvUserdata;

    //- set serial ID of connection

    struct symtab_Connection *pconn
	= (struct symtab_Connection *)TstrGetActual(ptstr);

    //- increment connection count

    (*piConnections)++;

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionSpikeRecSelector()
///
/// ARGS.:
///
///	ptstr.......: treespace traversal
///	pvUserdata..: any user data
///
/// RTN..: int : treespace traversal callback return value
///
/// DESCR: Selects connections if they come from a given spikerec.
///
/// **************************************************************************

static int 
ProjectionSpikeRecSelector
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get pointer to query result struct

    struct PQ_ConnsForSpikerec_Result *ppqr
	= (struct PQ_ConnsForSpikerec_Result *)pvUserdata;

    //- if connection symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct PidinStack *ppistConnection = NULL;

	//- get projection context

	struct PidinStack *ppistProjection = ppqr->ppistProjection;

	//- get projection symbol

	struct symtab_HSolveListElement *phsleProjection
/* 	    = SymbolsLookupHierarchical(NULL,ppistProjection); */
	    = PidinStackLookupTopSymbol(ppistProjection);

	//- get target population context

	struct symtab_Parameters *pparTarget
	    = SymbolFindParameter(phsleProjection,"TARGET",ppistProjection);

	struct PidinStack *ppistTarget
	    = ParameterResolveToPidinStack(pparTarget,ppistProjection);

/* 	ppistConnection = PidinStackDuplicate(ppistTarget); */

	//- get spike receiver context

	struct symtab_HSolveListElement *phsleTarget
	    = PidinStackLookupTopSymbol(ppistTarget);

	ppistConnection
	    = ConnectionGetSpikeReceiver
	      ((struct symtab_Connection *)phsle,phsleTarget,ppistTarget);

	//- cat spikerec context

	PidinStackAppendCompact(ppistTarget,ppqr->ppistSpikerec);

/* 	//- get context for target of connection */

/* 	PidinStackPushCompactAll */
/* 	    (ppistConnection, */
/* 	     ConnectionTargetPidin((struct symtab_Connection *)phsle)); */

	//- if connection target is spikerec

	if (PidinStackEqual(ppistTarget,ppistConnection))
	{
	    //- set result : selected

	    iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
	}

	//- free pidinstacks

	PidinStackFree(ppistConnection);
	PidinStackFree(ppistTarget);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionTraverseConnections()
///
/// ARGS.:
///
///	pproj.......: projection to traverse connections for
///	ppist.......: context of projection, projection assumed to be on top
///	pfProcessor.: mechanism processor
///	pfFinalizer.: finalizer
///	pvUserdata..: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections, call pfProcesor on each of them
///
///	Does not use a selector to select connections yet, so calls 
///	pfProcesor on connection vectors also. Test with 
///	InstanceOfVConnection() and InstanceOfConnection() to make 
///	distinction between the two.
///
/// **************************************************************************

int
ProjectionTraverseConnections
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TRUE;

    //- init projection treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolConnectionSelector,
	   NULL,
	   pfProcessor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse projection symbol

    iResult = TstrGo(ptstr,&pproj->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionTraverseConnectionsForPostSerial()
///
/// ARGS.:
///
///	pproj.........: projection
///	ppist.........: context of projection
///	iReceiver.....: rooted serial of spike receiver
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Call processor on connections attached to spikerec.
///
///	If ppistSpikerec is rooted, ppist must be rooted to.
///
/// **************************************************************************

int
ProjectionTraverseConnectionsForPostSerial
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 int iReceiver,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : none

    int iResult = 0;

    struct TreespaceTraversal *ptstr = NULL;

    struct PQ_ConnsForPostSerial_Result pqr =
    {
	pproj,
	ppist,
	NULL,
	0,
	pfProcessor,
	pfFinalizer,
	pvUserdata,
    };

    //- update caches on contexts

    PidinStackLookupTopSymbol(ppist);

    //- set relative postsynaptic serial

    pqr.iPost = iReceiver;

/*     if (TRUE /* && PidinStackIsRooted(ppistSpikerec) *) */
/*     { */
/* 	pqr.iPost -= ProjectionGetTargetSerial(pproj,ppist); */
/*     } */

    //- init projection treespace traversal

    ptstr
	= TstrNew
	  (ppist,
	   ProjectionConnectionForPostSerialSelector,
	   (void *)&pqr,
	   pfProcessor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse projection symbol

    iResult = TstrGo(ptstr,&pproj->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //! obsolete : ProjectionTraverseConnections() now has its own
    //! connection selector.

/*     struct PQ_ConnsForSpikerec_Result pqr = */
/*     { */
/* 	pproj, */
/* 	ppist, */
/* 	ppistSpikerec, */
/* 	pfProcessor, */
/* 	pfFinalizer, */
/* 	pvUserdata, */
/*     }; */

/*     //- traverse connection symbols and process them */

/*     iResult */
/* 	= ProjectionTraverseConnections */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ProjectionConnectionTargetProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionTraverseConnectionsForSpikeGenerator()
///
/// ARGS.:
///
///	ppq...........: projection query
///	ppistSpikeGen.: spike generator
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Call processor on connections attached to spikegen.
///
///	If ppistSpikeGen is rooted, ppist must be rooted to.
///
/// **************************************************************************

int
ProjectionTraverseConnectionsForSpikeGenerator
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeGen,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : none

    int iResult = 0;

    struct TreespaceTraversal *ptstr = NULL;

    struct PQ_ConnsForPreSerial_Result pqr =
    {
	pproj,
	ppist,
	ppistSpikeGen,
	0,
	pfProcessor,
	pfFinalizer,
	pvUserdata,
    };

    //- update caches on contexts

    PidinStackLookupTopSymbol(ppistSpikeGen);
    PidinStackLookupTopSymbol(ppist);

    //- get relative presynaptic serial

    pqr.iPre = PidinStackToSerial(ppistSpikeGen);

/*     if (PidinStackIsRooted(ppistSpikeGen)) */
/*     { */
/* 	pqr.iPre -= ProjectionGetSourceSerial(pproj,ppist); */
/*     } */

    //- init projection treespace traversal

    ptstr
	= TstrNew
	  (ppist,
	   ProjectionConnectionForPreSerialSelector,
	   (void *)&pqr,
	   pfProcessor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse projection symbol

    iResult = TstrGo(ptstr,&pproj->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //! obsolete : ProjectionTraverseConnections() now has its own
    //! connection selector.

/*     struct PQ_ConnsForSpikegen_Result pqr = */
/*     { */
/* 	pproj, */
/* 	ppist, */
/* 	ppistSpikeGen, */
/* 	pfProcessor, */
/* 	pfFinalizer, */
/* 	pvUserdata, */
/*     }; */

/*     //- traverse connection symbols and process them */

/*     iResult */
/* 	= ProjectionTraverseConnections */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ProjectionConnectionSourceProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

    //- return result

    return(iResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ProjectionTraverseConnectionsForSpikeGeneratorOfSolver() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pproj.........: projection */
/* ///	ppist.........: context of projection */
/* ///	ppistSpikeGen.: spike generator */
/* ///	psi...........: solver registration */
/* ///	pfProcessor...: processor to be called on matching connections */
/* ///	pfFinalizer...: finalizer */
/* ///	pvUserdata....: any user data */
/* /// */
/* /// RTN..: int : success of operation */
/* /// */
/* /// DESCR: Traverse connections attached to spikegen and solver. */
/* /// */
/* ///	Call processor on connections attached to spikegen, but only if  */
/* ///	the spikerecs of the connections are solved by the solver given */
/* ///	by psi. */
/* /// */
/* /// ************************************************************************** */

/* static int  */
/* ProjectionConnectionSpikeGeneratorOfSolverProcessor */
/* (struct TreespaceTraversal *ptstr, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : ok, but process sibling afterwards */

/*     int iResult = SYMBOL_PROCESSOR_FAILURE; */

/*     //- get pointer to query result struct */

/*     struct PQ_ConnsForSpikegen_Result *ppqrAbused */
/* 	= (struct PQ_ConnsForSpikegen_Result *)pvUserdata; */

/*     struct PQ_ConnsForSpikegenOfSolver_Result *ppqr */
/* 	= (struct PQ_ConnsForSpikegenOfSolver_Result *)ppqrAbused->pvUserdata; */

/*     //- get solved symbols from solver info */

/*     struct PidinStack *ppistSolver */
/* 	= SolverInfoPidinStack(ppqr->psi); */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- get projection context */

/*     struct PidinStack *ppistProjection = ppqr->ppistProjection; */

/*     //- get projection symbol */

/*     struct symtab_HSolveListElement *phsleProjection */
/* /* 	= SymbolsLookupHierarchical(NULL,ppistProjection); * */
/* 	= PidinStackLookupTopSymbol(ppistProjection); */

/*     //- get source population context */

/*     struct symtab_Parameters *pparSource */
/* 	= SymbolFindParameter(phsleProjection,"SOURCE",ppistProjection); */

/*     struct PidinStack *ppistSource */
/* 	= ParameterResolveToPidinStack(pparSource,ppistProjection); */

/*     //- cat spikegen context */

/*     PidinStackAppendCompact(ppistSource,ppqr->ppistSpikegen); */

/*     //- if solved by registered solver */

/*     if (PidinStackMatch(ppistSource,ppistSolver)) */
/*     { */
/* /* 	struct TreespaceTraversal tstr; * */

/* /* 	int iResult2; * */

/* /* 	//- init treespace traversal to traverse spikegen * */

/* /* 	memset(&tstr,0,sizeof(tstr)); * */

/* /* 	tstr.pfPreSelector = NULL; * */
/* /* 	tstr.pfProcesor = ppqr->pfProcessor; * */
/* /* 	tstr.pfPostSelector = ppqr->pfFinalizer; * */
/* /* 	tstr.pvUserdata = ppqr; * */

/* /* 	//- allocate symbol stack * */

/* /* 	tstr.ppist = PidinStackDuplicate(ptstr->ppist); * */

/* /* 	//- traverse spikerec (calls processor and finalizer) * */

/* /* 	iResult2 = TstrTraverse(&tstr,phsle); * */

/* /* 	//- free symbol stack * */

/* /* 	PidinStackFree(tstr.ppist); * */

/* /* 	//- if failure/abort traversing * */

/* /* 	if (iResult2 == -1 || iResult == 0) * */
/* /* 	{ * */
/* /* 	    //- stop parent traverse * */

/* /* 	    iResult = SYMBOL_PROCESSOR_ABORT; * */
/* /* 	} * */

/* 	//- call processor */

/* 	int iResult2 = ppqr->pfProcessor(ptstr,ppqr->pvUserdata); */
/*     } */

/*     //- free pidinstacks */

/*     PidinStackFree(ppistSource); */

/*     //- return result : remember won't go any deeper to traverse connections */

/*     return(iResult); */
/* } */

/* int */
/* ProjectionTraverseConnectionsForSpikeGeneratorOfSolver */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistSpikegen, */
/*  struct SolverInfo *psi, */
/*  SymbolProcessor *pfProcessor, */
/*  SymbolProcessor *pfFinalizer, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : none */

/*     int iResult = 0; */

/*     struct PQ_ConnsForSpikegenOfSolver_Result pqr = */
/*     { */
/* 	pproj, */
/* 	ppist, */
/* 	ppistSpikegen, */
/* 	psi, */
/* 	pfProcessor, */
/* 	pfFinalizer, */
/* 	pvUserdata, */
/*     }; */

/*     //- traverse connections for spike generator */

/*     iResult */
/* 	= ProjectionTraverseConnectionsForSpikeGenerator */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ppistSpikegen, */
/* 	   ProjectionConnectionSpikeGeneratorOfSolverProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ProjectionTraverseConnectionsForSpikeReceiver()
///
/// ARGS.:
///
///	pproj.........: projection
///	ppist.........: context of projection
///	ppistSpikerec.: spike receiver
///	pfProcessor...: processor to be called on matching connections
///	pfFinalizer...: finalizer
///	pvUserdata....: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Call processor on connections attached to spikerec.
///
///	If ppistSpikerec is rooted, ppist must be rooted to.
///
/// **************************************************************************

int
ProjectionTraverseConnectionsForSpikeReceiver
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikerec,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : none

    int iResult = 0;

    struct TreespaceTraversal *ptstr = NULL;

    struct PQ_ConnsForPostSerial_Result pqr =
    {
	pproj,
	ppist,
	ppistSpikerec,
	0,
	pfProcessor,
	pfFinalizer,
	pvUserdata,
    };

    //- update caches on contexts

    PidinStackLookupTopSymbol(ppistSpikerec);
    PidinStackLookupTopSymbol(ppist);

    //- get relative postsynaptic serial

    pqr.iPost = PidinStackToSerial(ppistSpikerec);

/*     if (PidinStackIsRooted(ppistSpikerec)) */
/*     { */
/* 	pqr.iPost -= ProjectionGetTargetSerial(pproj,ppist); */
/*     } */

    //- init projection treespace traversal

    ptstr
	= TstrNew
	  (ppist,
	   ProjectionConnectionForPostSerialSelector,
	   (void *)&pqr,
	   pfProcessor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse projection symbol

    iResult = TstrGo(ptstr,&pproj->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //! obsolete : ProjectionTraverseConnections() now has its own
    //! connection selector.

/*     struct PQ_ConnsForSpikerec_Result pqr = */
/*     { */
/* 	pproj, */
/* 	ppist, */
/* 	ppistSpikerec, */
/* 	pfProcessor, */
/* 	pfFinalizer, */
/* 	pvUserdata, */
/*     }; */

/*     //- traverse connection symbols and process them */

/*     iResult */
/* 	= ProjectionTraverseConnections */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ProjectionConnectionTargetProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

    //- return result

    return(iResult);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ProjectionTraverseConnectionsForSpikeReceiverOfSolver() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pproj.........: projection */
/* ///	ppist.........: context of projection */
/* ///	ppistSpikerec.: spike receiver */
/* ///	psi...........: solver registration */
/* ///	pfProcessor...: processor to be called on matching connections */
/* ///	pfFinalizer...: finalizer */
/* ///	pvUserdata....: any user data */
/* /// */
/* /// RTN..: int : success of operation */
/* /// */
/* /// DESCR: Traverse connections attached to spikerec and solver. */
/* /// */
/* ///	Call processor on connections attached to spikerec, but only if  */
/* ///	the spikegens of the connections are solved by the solver given */
/* ///	by psi. */
/* /// */
/* /// ************************************************************************** */

/* static int  */
/* ProjectionConnectionSpikeReceiverOfSolverProcessor */
/* (struct TreespaceTraversal *ptstr, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : ok, but process sibling afterwards */

/*     int iResult = SYMBOL_PROCESSOR_FAILURE; */

/*     //- get pointer to query result struct */

/*     struct PQ_ConnsForSpikerec_Result *ppqrAbused */
/* 	= (struct PQ_ConnsForSpikerec_Result *)pvUserdata; */

/*     struct PQ_ConnsForSpikerecOfSolver_Result *ppqr */
/* 	= (struct PQ_ConnsForSpikerecOfSolver_Result *)ppqrAbused->pvUserdata; */

/*     //- get solved symbols from solver info */

/*     struct PidinStack *ppistSolver */
/* 	= SolverInfoPidinStack(ppqr->psi); */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- get projection context */

/*     struct PidinStack *ppistProjection = ppqr->ppistProjection; */

/*     //- get projection symbol */

/*     struct symtab_HSolveListElement *phsleProjection */
/* /* 	= SymbolsLookupHierarchical(NULL,ppistProjection); * */
/* 	= PidinStackLookupTopSymbol(ppistProjection); */

/*     //- get target population context */

/*     struct symtab_Parameters *pparTarget */
/* 	= SymbolFindParameter(phsleProjection,"TARGET",ppistProjection); */

/*     struct PidinStack *ppistTarget */
/* 	= ParameterResolveToPidinStack(pparTarget,ppistProjection); */

/*     //- cat spikerec context */

/*     PidinStackAppendCompact(ppistTarget,ppqr->ppistSpikerec); */

/*     //- if solved by registered solver */

/*     if (PidinStackMatch(ppistTarget,ppistSolver)) */
/*     { */
/* /* 	struct TreespaceTraversal tstr; * */

/* /* 	int iResult2; * */

/* /* 	//- init treespace traversal to traverse spikerec * */

/* /* 	memset(&tstr,0,sizeof(tstr)); * */

/* /* 	tstr.pfPreSelector = NULL; * */
/* /* 	tstr.pfProcesor = ppqr->pfProcessor; * */
/* /* 	tstr.pfPostSelector = ppqr->pfFinalizer; * */
/* /* 	tstr.pvUserdata = ppqr; * */

/* /* 	//- allocate symbol stack * */

/* /* 	tstr.ppist = PidinStackDuplicate(ptstr->ppist); * */

/* /* 	//- traverse spikerec (calls processor and finalizer) * */

/* /* 	iResult2 = TstrTraverse(&tstr,phsle); * */

/* /* 	//- free symbol stack * */

/* /* 	PidinStackFree(tstr.ppist); * */

/* /* 	//- if failure/abort traversing * */

/* /* 	if (iResult2 == -1 || iResult == 0) * */
/* /* 	{ * */
/* /* 	    //- stop parent traverse * */

/* /* 	    iResult = SYMBOL_PROCESSOR_ABORT; * */
/* /* 	} * */

/* 	//- call processor */

/* 	int iResult2 = ppqr->pfProcessor(ptstr,ppqr->pvUserdata); */
/*     } */

/*     //- free pidinstacks */

/*     PidinStackFree(ppistTarget); */

/*     //- return result : remember won't go any deeper to traverse connections */

/*     return(iResult); */
/* } */

/* int */
/* ProjectionTraverseConnectionsForSpikeReceiverOfSolver */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistSpikerec, */
/*  struct SolverInfo *psi, */
/*  SymbolProcessor *pfProcessor, */
/*  SymbolProcessor *pfFinalizer, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : none */

/*     int iResult = 0; */

/*     struct PQ_ConnsForSpikerecOfSolver_Result pqr = */
/*     { */
/* 	pproj, */
/* 	ppist, */
/* 	ppistSpikerec, */
/* 	psi, */
/* 	pfProcessor, */
/* 	pfFinalizer, */
/* 	pvUserdata, */
/*     }; */

/*     //- traverse connections for spike receiver */

/*     iResult */
/* 	= ProjectionTraverseConnectionsForSpikeReceiver */
/* 	  (pproj, */
/* 	   ppist, */
/* 	   ppistSpikerec, */
/* 	   ProjectionConnectionSpikeReceiverOfSolverProcessor, */
/* 	   NULL, */
/* 	   (void *)&pqr); */

/*     //- return result */

/*     return(iResult); */
/* } */


