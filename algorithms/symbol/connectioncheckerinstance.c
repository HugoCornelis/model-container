//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectioncheckerinstance.c 1.24 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "connectionchecker.h"
#include "connectioncheckerinstance.h"
#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"

#include "neurospaces/idin.h"
#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/population.h"
#include "neurospaces/projection.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/vectorconnection.h"


//s connection checker algorithm private data

/*s */
/*s struct with connection checker options */
/*S */

struct ConnectionCheckerOptions_type
{
//			{ -name BackwardProjection }

    /*m name of symbol to check */

    char *pcProjection;

    /*m below is not used, left in place if needed e.g. for options
     *m concerning average values. */

    /*m value of random seed */

    double dRandomSeed;

    /* probability value */

    double dProbability;

    /*m pre synaptic part */

    char *pcPre;

    /*m post synaptic part */

    char *pcPost;

    /*m source type : box or ellipse */

    int iSourceType;

    /*m source coordinates */

    struct D3Position D3Source1;
    struct D3Position D3Source2;

    /*m destination type : box or ellipse */

    int iDestinationType;

    /*m destination coordinates */

    struct D3Position D3Destination1;
    struct D3Position D3Destination2;

    /*m weight */

    double dWeight;

    /*m delay type */

    int iDelayType;

    /*m delay / velocity value */

    union {
	double dFixed;
	double dVelocity;
    } uDelay;
};

typedef struct ConnectionCheckerOptions_type ConnectionCheckerOptions;


//s
//s connection checker variables
//s

struct ConnectionCheckerVariables_type
{
    //m symbol that points to network where algorithm is instantiated

    struct symtab_HSolveListElement *phsleNetwork;

    //m context of network (parser context)

    struct PidinStack *ppistNetwork;

    //m symbol attached to

    struct symtab_HSolveListElement *phsleProjection;
    struct PidinStack *ppistProjection;

    //m pidin pointing to projection (not owned by projection)

    struct PidinStack *ppistArgument;

    //m source population / cell

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    //m target population / cell

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;

    //m number of sources

    int iSources;

    //m number of destinations

    int iDestinations;

    //m average delay

    double dAverageDelay;

    //m average weight

    double dAverageWeight;

    //m number of added connection groups

    int iConnectionGroups;

    //m total number of added connections

    int iConnections;

    /*m below is not used, left in place if needed e.g. to store
     *m average values. */

    //m number of failures when adding connections

    int iConnectionFailures;

    //m number of tries adding connections

    int iConnectionTries;

    //m number of failures for coordinates of generators

    int iGeneratorFailures;

    //m number of failures for coordinates of receivers

    int iReceiverFailures;
};

typedef struct ConnectionCheckerVariables_type ConnectionCheckerVariables;


//s ConnectionChecker instance, derives from algorithm instance

struct ConnectionCheckerInstance
{
    //m base struct

    struct AlgorithmInstance algi;

    //m options for this instance

    ConnectionCheckerOptions cco;

    //m variables for this instance

    ConnectionCheckerVariables ccv;
};


//s number of symbol that have been modified

/* static int iModified = 0; */

/* #define MAX_NUM_MODIFIED	10 */

/* static struct symtab_IOHierarchy *ppiohModified[MAX_NUM_MODIFIED]; */


// local functions

static
int
ConnectionCheckerInstanceCheckConnectionGroups
(struct ConnectionCheckerInstance *ppri,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget);

static int ConnectionCheckerInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static 
int
ConnectionCheckerInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);

/* static int  */
/* ConnectionCheckerSpikeGeneratorProcessor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata); */

/* static int  */
/* ConnectionCheckerSpikeReceiverProcessor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata); */


/// **************************************************************************
///
/// SHORT: ConnectionCheckerInstanceNew()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of connection checker algorithm.
///
/// **************************************************************************

struct AlgorithmInstance *
ConnectionCheckerInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/connectionchecker_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct ConnectionCheckerInstance *pcci
	= (struct ConnectionCheckerInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct ConnectionCheckerInstance), _vtable_connectionchecker, HIERARCHY_TYPE_algorithm_instances_connectionchecker);

    AlgorithmInstanceSetName(&pcci->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//t should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProjection
	    = SymbolFindParameter(&palgs->hsle, "PROJECTION_NAME", ppist);

	//- scan projection name

	pcci->cco.pcProjection = ParameterGetString(pparProjection);
    }

    //- set result

    palgiResult = &pcci->algi;

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionCheckerInstanceCheckConnectionGroups()
///
/// ARGS.:
///
///	pcci............: connection checker instance.
///	pproj...........: projection symbol to check connections for.
///	ppistProjection.: 
///	phsleSource.....: source population / cell of projection.
///	ppistSource.....: 
///	phsleTarget.....: target population / cell of projection.
///	ppistTarget.....: 
///
/// RTN..: int : success of operation
///
/// DESCR: Checks connection groups with connections in projection.
///
/// **************************************************************************

struct ConnectionCheckerInstanceCheckConnectionGroups_data
{
    //m connection checker algorithm instance

    struct ConnectionCheckerInstance *pcci;

    //m network we are handling

    struct symtab_HSolveListElement *phsleNetwork;
    struct PidinStack *ppistNetwork;

    //m projection to check

    struct symtab_Projection *pproj;
    struct PidinStack *ppistProjection;

    //m active connection group

    struct symtab_VConnectionSymbol *pvconsy;

/*     //m current spike generator */

/*     struct symtab_Attachment *pattaGenerator; */
/*     struct PidinStack *ppistGenerator; */

/*     //m spike generator position */

/*     struct D3Position D3Generator; */

/*     //m current spike receiver */

/*     struct symtab_Attachment *pattaReceiver; */
/*     struct PidinStack *ppistReceiver; */

/*     //m spike receiver position */

/*     struct D3Position D3Receiver; */

    //m source population

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    //m target population

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;
};


/* static int  */
/* ConnectionCheckerSpikeGeneratorProcessor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : ok */

/*     int iResult = SYMBOL_PROCESSOR_ABORT; */

/*     //- get pointer to current connection group data */

/*     struct ConnectionCheckerInstanceCheckConnectionGroups_data *ppiac */
/* 	= (struct ConnectionCheckerInstanceCheckConnectionGroups_data *) */
/* 	  pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- if name does not match -pre */

/*     if (strcmp(IdinName(SymbolGetPidin(phsle)),ppiac->pcci->cco.pcPre) != 0) */
/*     { */
/* 	//- return result : do not process */

/* 	iResult = SYMBOL_PROCESSOR_FAILURE; */

/* 	return(iResult); */
/*     } */

/*     //- resolve coordinate for spike generator */

/*     if (SymbolParameterResolveCoordinateValue */
/* 	(ppiac->phsleNetwork, */
/* 	 ppiac->ppistNetwork, */
/* 	 ptstr->ppist, */
/* 	 &ppiac->D3Generator) == TRUE) */
/*     { */
/* 	//- if position in boundaries */

/* 	if (ppiac->pcci->cco.D3Source1.dx < ppiac->D3Generator.dx  */
/* 	    && ppiac->D3Generator.dx <= ppiac->pcci->cco.D3Source2.dx */
/* 	    && ppiac->pcci->cco.D3Source1.dy < ppiac->D3Generator.dy  */
/* 	    && ppiac->D3Generator.dy <= ppiac->pcci->cco.D3Source2.dy */
/* 	    && ppiac->pcci->cco.D3Source1.dz < ppiac->D3Generator.dz  */
/* 	    && ppiac->D3Generator.dz <= ppiac->pcci->cco.D3Source2.dz) */
/* 	{ */
/* 	    //- fill in current spike generator */

/* 	    ppiac->pattaGenerator = (struct symtab_Attachment *)phsle; */
/* 	    ppiac->ppistGenerator = ptstr->ppist; */

/* 	    //- traverse spike receivers for target population */

/* 	    if (SymbolTraverseSpikeReceivers */
/* 		(ppiac->phsleTarget, */
/* 		 ppiac->ppistTarget, */
/* 		 ConnectionCheckerSpikeReceiverProcessor, */
/* 		 NULL, */
/* 		 (void *)ppiac) == 1) */
/* 	    { */
/* 		//- set result : ok */

/* 		iResult = SYMBOL_PROCESSOR_SUCCESS; */
/* 	    } */
/* 	} */
/*     } */
/*     else */
/*     { */
/* 	ppiac->pcci->ccv.iGeneratorFailures++; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* static int  */
/* ConnectionCheckerSpikeReceiverProcessor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : ok */

/*     int iResult = SYMBOL_PROCESSOR_SUCCESS; */

/*     //- get pointer to current connection group data */

/*     struct ConnectionCheckerInstanceCheckConnectionGroups_data *ppiac */
/* 	= (struct ConnectionCheckerInstanceCheckConnectionGroups_data *) */
/* 	  pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- get name of channel */

/*     struct symtab_IdentifierIndex *pidinChannel */
/* 	= PidinStackElementPidin */
/* 	  (ptstr->ppist,PidinStackNumberOfEntries(ptstr->ppist) - 2); */

/*     //- if name does not match -post */

/*     if (strcmp(IdinName(pidinChannel),ppiac->pcci->cco.pcPost) != 0) */
/*     { */
/* 	//- return result : do not process */

/* 	iResult = SYMBOL_PROCESSOR_FAILURE; */

/* 	return(iResult); */
/*     } */

/*     //- resolve coordinate for spike receiver */

/*     if (SymbolParameterResolveCoordinateValue */
/* 	(ppiac->phsleNetwork, */
/* 	 ppiac->ppistNetwork, */
/* 	 ptstr->ppist, */
/* 	 &ppiac->D3Receiver) == TRUE) */
/*     { */
/* 	//- if diff with presynaptic part in receiving volume */

/* 	struct D3Position D3Diff; */

/* 	D3Diff.dx = ppiac->D3Receiver.dx - ppiac->D3Generator.dx; */
/* 	D3Diff.dy = ppiac->D3Receiver.dy - ppiac->D3Generator.dy; */
/* 	D3Diff.dz = ppiac->D3Receiver.dz - ppiac->D3Generator.dz; */

/* 	if (ppiac->pcci->cco.D3Destination1.dx < D3Diff.dx  */
/* 	    && D3Diff.dx <= ppiac->pcci->cco.D3Destination2.dx */
/* 	    && ppiac->pcci->cco.D3Destination1.dy < D3Diff.dy  */
/* 	    && D3Diff.dy <= ppiac->pcci->cco.D3Destination2.dy */
/* 	    && ppiac->pcci->cco.D3Destination1.dz < D3Diff.dz  */
/* 	    && D3Diff.dz <= ppiac->pcci->cco.D3Destination2.dz) */
/* 	{ */
/* 	    //- fill in current spike receiver */

/* 	    ppiac->pattaReceiver = (struct symtab_Attachment *)phsle; */
/* 	    ppiac->ppistReceiver = ptstr->ppist; */

/* 	    //- if random number smaller than connection probability */

/* 	    if (random() < RAND_MAX * ppiac->pcci->cco.dProbability) */
/* 	    { */
/* 		double dDelay = 0.0; */
/* 		struct symtab_Connection *pconn = NULL; */

/* 		//- get source population serial */

/* 		int iSource = PidinStackToSerial(ppiac->ppistSource); */

/* 		//- get pre-synaptic serial */

/* 		int iPre = PidinStackToSerial(ppiac->ppistGenerator); */

/* 		//- get target population serial */

/* 		int iTarget = PidinStackToSerial(ppiac->ppistTarget); */

/* 		//- get post-synaptic serial */

/* 		int iPost = PidinStackToSerial(ppiac->ppistReceiver); */

/* 		//- recalculate pre-synaptic and post-synaptic serials */
/* 		//- to relative to population */

/* 		int iPreRelative = iPre - iSource; */
/* 		int iPostRelative = iPost - iTarget; */

/* 		//t check serial principals from treespace traversals, should match ? */

/* 		//- calculate connection delay */

/* 		if (ppiac->pcci->cco.iDelayType == 1) */
/* 		{ */
/* 		    dDelay = ppiac->pcci->cco.uDelay.dFixed; */
/* 		} */
/* 		else if (ppiac->pcci->cco.iDelayType == 2) */
/* 		{ */
/* 		    double dDistance */
/* 			= sqrt(D3Diff.dx * D3Diff.dx */
/* 			       + D3Diff.dy * D3Diff.dy */
/* 			       + D3Diff.dz * D3Diff.dz); */

/* 		    dDelay = dDistance / ppiac->pcci->cco.uDelay.dVelocity; */
/* 		} */

/* 		//- construct connection between pre- and post-synaptic sites */

/* 		pconn */
/* 		    = ConnectionNewForStandardConnection */
/* 		      (iPre - iSource, */
/* 		       iPost - iTarget, */
/* 		       ppiac->pcci->cco.dWeight, */
/* 		       dDelay); */

/* 		//- add connection component to container */

/* 		//t wrong cast here : pconn does not derive from iohier. */
/* 		//t see related comments of SymbolEntailChild(). */

/* 		ppiac->pcci->ccv.iConnectionTries++; */
/* 		ppiac->pcci->ccv.iConnections++; */

/* 		SymbolEntailChild */
/* 		    (&ppiac->pvconn->vect.bio.ioh, */
/* 		     (struct symtab_IOHierarchy *)pconn); */
/* 	    } */
/* 	} */
/*     } */
/*     else */
/*     { */
/* 	ppiac->pcci->ccv.iReceiverFailures++; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


static int 
ConnectionCheckerConnectionProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    struct symtab_Parameters *pparWeight = NULL;
    struct symtab_Parameters *pparDelay = NULL;

    //- get pointer to current connection group data

    struct ConnectionCheckerInstanceCheckConnectionGroups_data *ppiac
	= (struct ConnectionCheckerInstanceCheckConnectionGroups_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- increment number of connections

    ppiac->pcci->ccv.iConnections++;

    //- count average weight

    pparWeight
	= ConnectionGetParameter
	  ((struct symtab_Connection *)phsle,"WEIGHT",NULL);

    ppiac->pcci->ccv.dAverageWeight
	+= (ParameterResolveValue(pparWeight,NULL)
	    - ppiac->pcci->ccv.dAverageWeight)
	   / ppiac->pcci->ccv.iConnections;

    //- count average delay

    pparDelay
	= ConnectionGetParameter
	  ((struct symtab_Connection *)phsle,"DELAY",NULL);

    ppiac->pcci->ccv.dAverageDelay
	+= (ParameterResolveValue(pparDelay,NULL)
	    - ppiac->pcci->ccv.dAverageDelay)
	   / ppiac->pcci->ccv.iConnections;

    //- return result

    return(iResult);
}


static
int
ConnectionCheckerInstanceCheckConnectionGroups
(struct ConnectionCheckerInstance *pcci,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget)
{
    //- set default result : success

    int bResult = FALSE;

    struct ConnectionCheckerInstanceCheckConnectionGroups_data piac =
    {
	//m connection checker algorithm instance

	pcci,

	//m network we are handling

	pcci->ccv.phsleNetwork,
	pcci->ccv.ppistNetwork,

	//m projection to check

	pproj,
	ppistProjection,

	//m active connection group

	NULL,

/* 	//m current spike generator */

/* 	NULL, */
/* 	NULL, */

/* 	//m spike generator position */

/* 	{ */
/* 	    0.0, */
/* 	    0.0, */
/* 	    0.0, */
/* 	}, */

/* 	//m current spike receiver */

/* 	NULL, */
/* 	NULL, */

/* 	//m spike receiver position */

/* 	{ */
/* 	    0.0, */
/* 	    0.0, */
/* 	    0.0, */
/* 	}, */

	//m source population

	phsleSource,
	ppistSource,

	//m target population

	phsleTarget,
	ppistTarget,
    };


    //- count spike receivers and generators in source and target

    pcci->ccv.iSources
	= SymbolCountSpikeGenerators(phsleSource,ppistSource);
    pcci->ccv.iDestinations
	= SymbolCountSpikeReceivers(phsleTarget,ppistTarget);

    //- loop over connections to make statistics

    if (ProjectionTraverseConnections
	(pproj,
	 ppistProjection,
	 ConnectionCheckerConnectionProcessor,
	 NULL,
	 &piac) == 1)
    {
	//- set result : ok

	bResult = TRUE;
    }

/*     //- get zero context for source and target populations */

/*     //! this enables the symbol cache on the context which */
/*     //! can then be used to calculate pre- and post-synaptic */
/*     //! serials. */

/*     piac.ppistSource = PidinStackCalloc(); */
/*     piac.ppistTarget = PidinStackCalloc(); */

    //- process spike mapping elements and check connections

/*     piac.pvconn = pvconn; */

/*     if (SymbolTraverseSpikeGenerators */
/* 	(phsleSource, */
/* 	 piac.ppistSource, */
/* 	 ConnectionCheckerSpikeGeneratorProcessor, */
/* 	 NULL, */
/* 	 (void *)&piac) == 1) */
/*     { */
/* 	//- add connection group to projection */

/* 	pcci->ccv.iConnectionGroups++; */

/* 	SymbolEntailChild(&pproj->bio.ioh,&pvconn->vect.bio.ioh); */

/* 	//- set result : ok */

/* 	bResult = TRUE; */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- set result : failure */

/* 	bResult = FALSE; */
/*     } */

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionCheckerInstancePrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on connection checker instance.
///
/// **************************************************************************

static int ConnectionCheckerInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct ConnectionCheckerInstance *pcci
	= (struct ConnectionCheckerInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pcci->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ConnectionCheckerInstance %s\n"
	 "report:\n"
	 "    number_of_checked_connection_groups: %i\n"
	 "    number_of_checked_connections: %i\n"
	 "    average_weight: %f\n"
	 "    average_delay: %f\n",
	 pcInstance,
	 pcci->ccv.iConnectionGroups,
	 pcci->ccv.iConnections,
	 pcci->ccv.dAverageWeight,
	 pcci->ccv.dAverageDelay);

    fprintf
	(pfile,
	 "    ConnectionCheckerInstance_network: %s\n",
	 pcci->ccv.phsleNetwork
	 ? IdinName(SymbolGetPidin(pcci->ccv.phsleNetwork))
	 : "(none)");

    fprintf
	(pfile,
	 "    ConnectionCheckerInstance_projection: %s\n",
	 pcci->ccv.phsleProjection
	 ? IdinName(SymbolGetPidin(pcci->ccv.phsleProjection))
	 : "(none)");

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionCheckerInstanceSymbolHandler()
///
/// ARGS.:
///
///	AlgorithmInstanceSymbolHandler args.
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to check connections of given symbol
///
/// **************************************************************************

static 
int
ConnectionCheckerInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct ConnectionCheckerInstance *pcci
	= (struct ConnectionCheckerInstance *)palgi;

    //- if network

    if (instanceof_network(phsle))
    {
	int i = 0;

	//- set network we are handling

	pcci->ccv.phsleNetwork = phsle;
	pcci->ccv.ppistNetwork = ppist;

	//- get context for projection

	pcci->ccv.ppistProjection
	    = PidinStackDuplicate(pcci->ccv.ppistNetwork);

	pcci->ccv.ppistArgument
	    = PidinStackParse(pcci->cco.pcProjection);

	PidinStackAppendCompact
	    (pcci->ccv.ppistProjection,pcci->ccv.ppistArgument);

	//- lookup projection symbol

	pcci->ccv.phsleProjection
	    = PidinStackLookupTopSymbol(pcci->ccv.ppistProjection);

	if (instanceof_projection(pcci->ccv.phsleProjection))
	{
	    struct symtab_Parameters *pparSource = NULL;
	    struct symtab_Parameters *pparTarget = NULL;

	    //- get source and target population

	    //t need to check performance issues in these routines

	    pparSource
		= SymbolFindParameter
		  (pcci->ccv.phsleProjection,"SOURCE",pcci->ccv.ppistProjection);
	    pcci->ccv.ppistSource
		= ParameterResolveToPidinStack
		  (pparSource,pcci->ccv.ppistProjection);

	    pparTarget
		= SymbolFindParameter
		  (pcci->ccv.phsleProjection,"TARGET",pcci->ccv.ppistProjection);
	    pcci->ccv.ppistTarget
		= ParameterResolveToPidinStack
		  (pparTarget,pcci->ccv.ppistProjection);

	    pcci->ccv.phsleSource
		= PidinStackLookupTopSymbol(pcci->ccv.ppistSource);

	    pcci->ccv.phsleTarget
		= PidinStackLookupTopSymbol(pcci->ccv.ppistTarget);

	    //- if not populations

	    if ((instanceof_population(pcci->ccv.phsleSource)
		 || instanceof_cell(pcci->ccv.phsleSource))
		&& (instanceof_population(pcci->ccv.phsleTarget)
		    || instanceof_cell(pcci->ccv.phsleTarget)))
	    {
/* 		//- set random seed */

/* 		srandom(pcci->cco.dRandomSeed); */

		//- check connections

		iResult
		    = ConnectionCheckerInstanceCheckConnectionGroups
		      (pcci,
		       (struct symtab_Projection *)pcci->ccv.phsleProjection,
		       pcci->ccv.ppistProjection,
		       pcci->ccv.phsleSource,
		       pcci->ccv.ppistSource,
		       pcci->ccv.phsleTarget,
		       pcci->ccv.ppistTarget);

		if (iResult != TRUE)
		{
		    iResult = FALSE;

		    //- give diag's : non populations

		    NeurospacesError
			(pac,
			 "ConnectionCheckerInstance",
			 "(%s) Error during traversal of populations,"
			 " %s : %s -> %s",
			 AlgorithmInstanceGetName(&pcci->algi),
			 SymbolName(pcci->ccv.phsleProjection),
			 SymbolName(pcci->ccv.phsleSource),
			 SymbolName(pcci->ccv.phsleTarget));
		}

		//- recalculate serial ID's for affected symbols

		SymbolRecalcAllSerials
		    (pcci->ccv.phsleNetwork,pcci->ccv.ppistNetwork);
	    }

	    //- else

	    else
	    {
		//- give diag's : non populations

		NeurospacesError
		    (pac,
		     "ConnectionCheckerInstance",
		     "(%s) Projection algorithm handler finds projection %s,"
		     " projects %s -> %s but these are not both populations\n",
		     AlgorithmInstanceGetName(&pcci->algi),
		     SymbolName(pcci->ccv.phsleProjection),
		     SymbolName(pcci->ccv.phsleSource),
		     SymbolName(pcci->ccv.phsleTarget));
	    }
	}

	//- else

	else
	{
	    //- give diag's : non projection

	    NeurospacesError
		(pac,
		 "ConnectionCheckerInstance",
		 "(%s) Projection algorithm handler adding"
		 " to non projection %s\n",
		 AlgorithmInstanceGetName(&pcci->algi),
		 SymbolName(pcci->ccv.phsleProjection));
	}
    }

    //- else

    else
    {
	//- give diag's : prototype not found

	NeurospacesError
	    (pac,
	     "ConnectionCheckerInstance",
	     "(%s) Projection algorithm handler on non network %s\n",
	     AlgorithmInstanceGetName(&pcci->algi),
	     "(no pidin)");
/* 	     SymbolName(phsle)); */
    }

    //- return result

    return(iResult);
}


