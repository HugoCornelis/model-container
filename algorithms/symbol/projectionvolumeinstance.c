//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionvolumeinstance.c 1.34 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/cacheregistry.h"
#include "neurospaces/coordinatecache.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/population.h"
#include "neurospaces/projection.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/vectorconnection.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "projectionvolume.h"
#include "projectionvolumeinstance.h"


//s projection algorithm private data

/*s */
/*s struct with projection options */
/*S */

struct ProjectionVolumeOptions_type
{
//			{ -name BackwardProjection -randseed 1212 -prob 1.0 -pre spikegen -post pf_AMPA -source box -1e10 -1e10 -1e10 1e10 1e10 1e10 -dest ellipse -0.00015 -0.00015 0 0.00015 0.00015 0}

    /*m name of symbol to attach to */

    char *pcProjection;

    /*m value of random seed */

    double dRandomSeed;

    /*m probability value */

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

    /*m use coordinate caches ? */

    int iCoordinateCache;
};

typedef struct ProjectionVolumeOptions_type ProjectionVolumeOptions;


//s
//s projection variables
//s

struct ProjectionVolumeVariables_type
{
    //m symbol that points to network where algorithm is instantiated

    struct symtab_HSolveListElement *phsleNetwork;

    //m context of network (parser context)

    struct PidinStack *ppistNetwork;

    //m symbol attached to

    struct symtab_HSolveListElement *phsleProjection;
    struct PidinStack *ppistProjection;

    //m reference to projection (not owned by projection)

    struct PidinStack *ppistArgument;

    //m source population / cell

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    //m target population / cell

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;

    //m coordinate cache to speedup coordinate lookups

    struct CoordinateCache *pcc;

    //m number of added connection groups

    int iConnectionGroups;

    //m total number of added connections

    int iConnections;

    //m number of failures when adding connections

    int iConnectionFailures;

    //m number of tries adding connections

    int iConnectionTries;

    //m number of generators processed

    int iGenerators;

    //m number of failures for coordinates of generators

    int iGeneratorFailures;

    //m number of receivers processed

    int iReceivers;

    //m number of failures for coordinates of receivers

    int iReceiverFailures;
};

typedef struct ProjectionVolumeVariables_type ProjectionVolumeVariables;


//s projectionVolume instance, derives from algorithm instance

struct ProjectionVolumeInstance
{
    //m base struct

    struct AlgorithmInstance algi;

    //m options for this instance

    ProjectionVolumeOptions pro;

    //m variables for this instance

    ProjectionVolumeVariables prv;
};


//s number of symbol that have been modified

/* static int iModified = 0; */

/* #define MAX_NUM_MODIFIED	10 */

/* static struct symtab_IOHierarchy *ppiohModified[MAX_NUM_MODIFIED]; */


// local functions

static
int
ProjectionVolumeInstanceAddConnectionGroups
(struct ProjectionVolumeInstance *ppri,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget);

static int ProjectionVolumeInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static 
int
ProjectionVolumeInstanceSymbolHandler
(struct AlgorithmInstance *palgi,
 struct ParserContext *pac);

static int 
ProjectionVolumeSpikeGeneratorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static int 
ProjectionVolumeSpikeReceiverProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);


/// **************************************************************************
///
/// SHORT: ProjectionVolumeInstanceNew()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of projectionVolume algorithm.
///
/// **************************************************************************

struct AlgorithmInstance *
ProjectionVolumeInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal, struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/projectionvolume_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct ProjectionVolumeInstance *ppvi
	= (struct ProjectionVolumeInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct ProjectionVolumeInstance), _vtable_projectionvolume, HIERARCHY_TYPE_algorithm_instances_projectionvolume);

    AlgorithmInstanceSetName(&ppvi->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//t should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProjection
	    = SymbolFindParameter(&palgs->hsle, "PROJECTION_NAME", ppist);

	//- scan projection name

	ppvi->pro.pcProjection = ParameterGetString(pparProjection);

	//- scan random seed

	ppvi->pro.dRandomSeed = SymbolParameterResolveValue(&palgs->hsle, "RANDOMSEED", ppist);

	//- scan probability value

	ppvi->pro.dProbability = SymbolParameterResolveValue(&palgs->hsle, "PROBABILITY", ppist);

	//- scan presynaptic part

	struct symtab_Parameters *pparPre
	    = SymbolFindParameter(&palgs->hsle, "PRE", ppist);

	ppvi->pro.pcPre = ParameterGetString(pparPre);

	//- scan postsynaptic part

	struct symtab_Parameters *pparPost
	    = SymbolFindParameter(&palgs->hsle, "POST", ppist);

	ppvi->pro.pcPost = ParameterGetString(pparPost);

	//- scan source type

	struct symtab_Parameters *pparSourceType
	    = SymbolFindParameter(&palgs->hsle, "SOURCE_TYPE", ppist);

	char *pcSourceType = ParameterGetString(pparSourceType);

	if (strncmp(pcSourceType, "box", strlen("box")) == 0)
	{
	    ppvi->pro.iSourceType = 0;
	}
	else if (strncmp(pcSourceType, "ellipse", strlen("ellipse")) == 0)
	{
	    ppvi->pro.iSourceType = 1;
	}
	else
	{
	    ppvi->pro.iSourceType = -1;
	}

	//- scan source coordinates, go to next arg

	ppvi->pro.D3Source1.dx = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_X1", ppist);
	ppvi->pro.D3Source1.dy = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_Y1", ppist);
	ppvi->pro.D3Source1.dz = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_Z1", ppist);

	ppvi->pro.D3Source2.dx = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_X2", ppist);
	ppvi->pro.D3Source2.dy = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_Y2", ppist);
	ppvi->pro.D3Source2.dz = SymbolParameterResolveValue(&palgs->hsle, "SOURCE_Z2", ppist);

	//- scan destination type

	struct symtab_Parameters *pparDestinationType
	    = SymbolFindParameter(&palgs->hsle, "DESTINATION_TYPE", ppist);

	char *pcDestinationType = ParameterGetString(pparDestinationType);

	if (strncmp(pcDestinationType, "box", strlen("box")) == 0)
	{
	    ppvi->pro.iDestinationType = 0;
	}
	else if (strncmp(pcDestinationType, "ellipse", strlen("ellipse")) == 0)
	{
	    ppvi->pro.iDestinationType = 1;
	}
	else
	{
	    ppvi->pro.iDestinationType = -1;
	}

	//- scan destination coordinates, go to next arg

	ppvi->pro.D3Destination1.dx = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_X1", ppist);
	ppvi->pro.D3Destination1.dy = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_Y1", ppist);
	ppvi->pro.D3Destination1.dz = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_Z1", ppist);

	ppvi->pro.D3Destination2.dx = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_X2", ppist);
	ppvi->pro.D3Destination2.dy = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_Y2", ppist);
	ppvi->pro.D3Destination2.dz = SymbolParameterResolveValue(&palgs->hsle, "DESTINATION_Z2", ppist);

	//- scan weight

	ppvi->pro.dWeight = SymbolParameterResolveValue(&palgs->hsle, "WEIGHT", ppist);

	//- scan delay type

	struct symtab_Parameters *pparDelayType
	    = SymbolFindParameter(&palgs->hsle, "DELAY_TYPE", ppist);

	char *pcDelayType = ParameterGetString(pparDelayType);

	if (strncmp(pcDelayType, "fixed", strlen("fixed")) == 0)
	{
	    ppvi->pro.iDelayType = 1;
	}
	else if (strncmp(pcDelayType, "radial", strlen("radial")) == 0)
	{
	    ppvi->pro.iDelayType = 2;
	}
	else
	{
	    ppvi->pro.iDelayType = -1;
	}

	//- scan delay / conductance velocity

	if (ppvi->pro.iDelayType == 1)
	{
	    ppvi->pro.uDelay.dFixed = SymbolParameterResolveValue(&palgs->hsle, "FIXED_DELAY", ppist);
	}
	else
	{
	    ppvi->pro.uDelay.dVelocity = SymbolParameterResolveValue(&palgs->hsle, "VELOCITY", ppist);
	}
    }

    //- initialize connection counts

    ppvi->prv.iConnectionGroups = 0;
    ppvi->prv.iConnections = 0;
    ppvi->prv.iConnectionFailures = 0;
    ppvi->prv.iConnectionTries = 0.0;
    ppvi->prv.iGeneratorFailures = 0;
    ppvi->prv.iReceiverFailures = 0;

    //- set result

    palgiResult = &ppvi->algi;

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionVolumeInstanceAddConnectionGroups()
///
/// ARGS.:
///
///	ppvi............: projectionVolume instance.
///	pproj...........: projection symbol to add connection groups to.
///	ppistProjection.: 
///	phsleSource.....: source population / cell of projection.
///	ppistSource.....: 
///	phsleTarget.....: target population / cell of projection.
///	ppistTarget.....: 
///
/// RTN..: int : success of operation
///
/// DESCR: Adds connection groups with connections to projection.
///
/// **************************************************************************

struct ProjectionVolumeInstanceAddConnectionGroups_data
{
    //m projection volume algorithm instance

    struct ProjectionVolumeInstance *ppvi;

    //m network we are handling

    struct symtab_HSolveListElement *phsleNetwork;
    struct PidinStack *ppistNetwork;

    //m projection to add to

    struct symtab_Projection *pproj;
    struct PidinStack *ppistProjection;

    //m coordinate cache

    struct CoordinateCache *pcc;

    //m active connection group

    struct symtab_VConnection *pvconn;

    //m current spike generator

    struct symtab_Attachment *pattaGenerator;
    struct PidinStack *ppistGenerator;

    //m spike generator position

    struct D3Position D3Generator;

    //m current spike receiver

    struct symtab_Attachment *pattaReceiver;
    struct PidinStack *ppistReceiver;

    //m spike receiver position

    struct D3Position D3Receiver;

    //m source population

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    //m target population

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;
};


static int 
ProjectionVolumeSpikeGeneratorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_ABORT;

    //- get pointer to current connection group data

    struct ProjectionVolumeInstanceAddConnectionGroups_data *ppiac
	= (struct ProjectionVolumeInstanceAddConnectionGroups_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if name does not match -pre

    if (strcmp(IdinName(SymbolGetPidin(phsle)), ppiac->ppvi->pro.pcPre) != 0)
    {
	//- return result : do not process

	iResult = TSTR_PROCESSOR_FAILURE;

	return(iResult);
    }

    struct D3Position *pD3Generator = NULL;

    if (ppiac->ppvi->pro.iCoordinateCache)
    {
	//- get serial of network

	int iNetwork = PidinStackToSerial(ppiac->ppistNetwork);

	//- set serial of source population

	int iSource = PidinStackToSerial(ppiac->ppistSource);

	//- get serial of current symbol

	int iGenerator = TstrGetPrincipalSerial(ptstr);

	//- lookup coordinate

	struct CachedCoordinate *pccrdGenerator
	    = CoordinateCacheLookup(ppiac->pcc, iSource + iGenerator - iNetwork);

	if (pccrdGenerator)
	{
	    pD3Generator = &pccrdGenerator->D3;

/* 	    SymbolParameterResolveCoordinateValue */
/* 		(ppiac->phsleNetwork, */
/* 		 ppiac->ppistNetwork, */
/* 		 ptstr->ppist, */
/* 		 &ppiac->D3Generator); */

/* 	    if ( */
/* 		pD3Generator->dx != ppiac->D3Generator.dx */
/* 		|| pD3Generator->dy != ppiac->D3Generator.dy */
/* 		|| pD3Generator->dz != ppiac->D3Generator.dz */
/* 		) */
/* 	    { */
/* 		*(int *)0 = 0; */
/* 	    } */
	}
	else
	{
	    ppiac->ppvi->prv.iGeneratorFailures++;
	}
    }

    //- resolve coordinate for spike generator

    if (ppiac->ppvi->pro.iCoordinateCache)
    {
	ppiac->D3Generator = *pD3Generator;
    }
    else
    {
	*(int *)0 = 0;

	SymbolParameterResolveCoordinateValue
	    (ppiac->phsleNetwork,
	     ppiac->ppistNetwork,
	     ptstr->ppist,
	     &ppiac->D3Generator);
    }

    if (1)
    {
	//- if position in boundaries

	//t query speed up using index on generators

	if (ppiac->ppvi->pro.D3Source1.dx < ppiac->D3Generator.dx 
	    && ppiac->D3Generator.dx <= ppiac->ppvi->pro.D3Source2.dx
	    && ppiac->ppvi->pro.D3Source1.dy < ppiac->D3Generator.dy 
	    && ppiac->D3Generator.dy <= ppiac->ppvi->pro.D3Source2.dy
	    && ppiac->ppvi->pro.D3Source1.dz < ppiac->D3Generator.dz 
	    && ppiac->D3Generator.dz <= ppiac->ppvi->pro.D3Source2.dz)
	{
	    //- fill in current spike generator

	    ppiac->pattaGenerator = (struct symtab_Attachment *)phsle;
	    ppiac->ppistGenerator = ptstr->ppist;

	    //- traverse spike receivers for target population

	    //t use the index on the receivers

	    if (SymbolTraverseSpikeReceivers
		(ppiac->phsleTarget,
		 ppiac->ppistTarget,
		 ProjectionVolumeSpikeReceiverProcessor,
		 NULL,
		 (void *)ppiac) == 1)
	    {
		//- set result : ok

		iResult = TSTR_PROCESSOR_SUCCESS;
	    }
	}
    }
    else
    {
	ppiac->ppvi->prv.iGeneratorFailures++;
    }

    ppiac->ppvi->prv.iGenerators++;

    if (!(ppiac->ppvi->prv.iGenerators % 1024))
    {
	fprintf(stderr, "G");
    }

    if (!(ppiac->ppvi->prv.iGenerators % (32 * 1024)))
    {
	fprintf(stderr, "\n");
    }

    //- return result

    return(iResult);
}


static int 
ProjectionVolumeSpikeReceiverProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to current connection group data

    struct ProjectionVolumeInstanceAddConnectionGroups_data *ppiac
	= (struct ProjectionVolumeInstanceAddConnectionGroups_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get name of channel

    //t don't use PidinStackElementPidin() here, or at least the -2
    //t should be an additional parameter.

    struct symtab_IdentifierIndex *pidinChannel
	= PidinStackElementPidin
	  (ptstr->ppist, PidinStackNumberOfEntries(ptstr->ppist) - 2);

    //- if name does not match -post

    if (strcmp(IdinName(pidinChannel), ppiac->ppvi->pro.pcPost) != 0)
    {
	//- return result : do not process

	iResult = TSTR_PROCESSOR_FAILURE;

	return(iResult);
    }

    struct D3Position *pD3Receiver = NULL;

    if (ppiac->ppvi->pro.iCoordinateCache)
    {
	//- get serial of network

	int iNetwork = PidinStackToSerial(ppiac->ppistNetwork);

	//- set serial of target population

	int iTarget = PidinStackToSerial(ppiac->ppistTarget);

	//- get serial of current symbol

	int iReceiver = TstrGetPrincipalSerial(ptstr);

	//- lookup coordinate

	struct CachedCoordinate *pccrdReceiver
	    = CoordinateCacheLookup(ppiac->pcc, iTarget + iReceiver - iNetwork);

	if (pccrdReceiver)
	{
	    pD3Receiver = &pccrdReceiver->D3;
	}
	else
	{
	    ppiac->ppvi->prv.iGeneratorFailures++;
	}
    }

    //- resolve coordinate for spike receiver

    if (ppiac->ppvi->pro.iCoordinateCache)
    {
	ppiac->D3Receiver = *pD3Receiver;
    }
    else
    {
	*(int *)0 = 0;

	SymbolParameterResolveCoordinateValue
	    (ppiac->phsleNetwork,
	     ppiac->ppistNetwork,
	     ptstr->ppist,
	     &ppiac->D3Receiver);
    }

    if (1)
    {
	//- if diff with presynaptic part in receiving volume

	//t query speed up using index on receivers

	struct D3Position D3Diff;

	D3Diff.dx = ppiac->D3Receiver.dx - ppiac->D3Generator.dx;
	D3Diff.dy = ppiac->D3Receiver.dy - ppiac->D3Generator.dy;
	D3Diff.dz = ppiac->D3Receiver.dz - ppiac->D3Generator.dz;

	if (ppiac->ppvi->pro.D3Destination1.dx < D3Diff.dx 
	    && D3Diff.dx <= ppiac->ppvi->pro.D3Destination2.dx
	    && ppiac->ppvi->pro.D3Destination1.dy < D3Diff.dy 
	    && D3Diff.dy <= ppiac->ppvi->pro.D3Destination2.dy
	    && ppiac->ppvi->pro.D3Destination1.dz < D3Diff.dz 
	    && D3Diff.dz <= ppiac->ppvi->pro.D3Destination2.dz)
	{
	    //- fill in current spike receiver

	    ppiac->pattaReceiver = (struct symtab_Attachment *)phsle;
	    ppiac->ppistReceiver = ptstr->ppist;

	    //- if random number smaller than connection probability

	    if (random() < RAND_MAX * ppiac->ppvi->pro.dProbability)
	    {
		double dDelay = 0.0;
		struct symtab_Connection *pconn = NULL;

		//- get source population serial

		int iSource = PidinStackToSerial(ppiac->ppistSource);

		//- get pre-synaptic serial

		int iPre = PidinStackToSerial(ppiac->ppistGenerator);

		//- get target population serial

		int iTarget = PidinStackToSerial(ppiac->ppistTarget);

		//- get post-synaptic serial

		int iPost = PidinStackToSerial(ppiac->ppistReceiver);

		//- recalculate pre-synaptic and post-synaptic serials
		//- to relative to population

		int iPreRelative = iPre - iSource;
		int iPostRelative = iPost - iTarget;

		//t check serial principals from treespace traversals, should match ?

		//- calculate connection delay

		if (ppiac->ppvi->pro.iDelayType == 1)
		{
		    dDelay = ppiac->ppvi->pro.uDelay.dFixed;
		}
		else if (ppiac->ppvi->pro.iDelayType == 2)
		{
		    double dDistance
			= sqrt(D3Diff.dx * D3Diff.dx
			       + D3Diff.dy * D3Diff.dy
			       + D3Diff.dz * D3Diff.dz);

		    dDelay = dDistance / ppiac->ppvi->pro.uDelay.dVelocity;
		}

		//- construct connection between pre- and post-synaptic sites

/* 		pconn */
/* 		    = ConnectionNewForStandardConnection */
/* 		      (iPre - iSource, */
/* 		       iPost - iTarget, */
/* 		       ppiac->ppvi->pro.dWeight, */
/* 		       dDelay); */

		struct symtab_Connection conn =
		{
		    iPre - iSource,
		    iPost - iTarget,
		    ppiac->ppvi->pro.dWeight,
		    dDelay,
		};

		//- add connection component to container

		ppiac->ppvi->prv.iConnectionTries++;
		ppiac->ppvi->prv.iConnections++;

		//t should this be SymbolAddChild() ?

/* 		IOHierarchyAddChild(&ppiac->pvconsy->vect.bio.ioh, &pconn->hsle); */

		VConnectionAddConnection(ppiac->pvconn, &conn);
	    }
	}
    }
    else
    {
	ppiac->ppvi->prv.iReceiverFailures++;
    }

    ppiac->ppvi->prv.iReceivers++;

    if (!(ppiac->ppvi->prv.iReceivers % 1024))
    {
	fprintf(stderr, "R");
    }

    if (!(ppiac->ppvi->prv.iReceivers % (32 * 1024)))
    {
	fprintf(stderr, "\n");
    }

    //- return result

    return(iResult);
}


static
int
ProjectionVolumeInstanceAddConnectionGroups
(struct ProjectionVolumeInstance *ppvi,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget)
{
    //- set default result : failure

    int bResult = FALSE;

    struct ProjectionVolumeInstanceAddConnectionGroups_data piac =
    {
	//m projection volume algorithm instance

	ppvi,

	//m network we are handling

	ppvi->prv.phsleNetwork,
	ppvi->prv.ppistNetwork,

	//m projection to add to

	pproj,
	ppistProjection,

	//m coordinate cache

	ppvi->prv.pcc,

	//m active connection group

	NULL,

	//m current spike generator

	NULL,
	NULL,

	//m spike generator position

	{
	    0.0,
	    0.0,
	    0.0,
	},

	//m current spike receiver

	NULL,
	NULL,

	//m spike receiver position

	{
	    0.0,
	    0.0,
	    0.0,
	},

	//m source population

	phsleSource,
	ppistSource,

	//m target population

	phsleTarget,
	ppistTarget,
    };

/*     //- count spike receivers and generators in source and target */

/*     int iSources */
/* 	= PopulationCountSpikeGenerators */
/* 	  ((struct symtab_HSolveListElement *)ppopuSource,ppistSource); */
/*     int iTargets */
/* 	= PopulationCountSpikeReceivers */
/* 	  (struct symtab_HSolveListElement *)(ppopuTarget,ppistTarget); */

    //- add a connection group to the projection
     0;
    struct symtab_VConnection *pvconn = VConnectionCalloc();

    struct symtab_IdentifierIndex *pidin = IdinCallocUnique();

    SymbolSetName(&pvconn->vect.bio.ioh.iol.hsle,pidin);

    //- process spike mapping elements and add connections

    piac.pvconn = pvconn;

    //t use the index on the generators

    if (SymbolTraverseSpikeGenerators
	(phsleSource,
	 piac.ppistSource,
	 ProjectionVolumeSpikeGeneratorProcessor,
	 NULL,
	 (void *)&piac) == 1)
    {
	//- add connection group to projection

	ppvi->prv.iConnectionGroups++;

	//t should this be SymbolAddChild() ?

	IOHierarchyAddChild(&pproj->bio.ioh, &pvconn->vect.bio.ioh.iol.hsle);

	//- set result : ok

	bResult = TRUE;
    }

    //- else

    else
    {
	//- set result : failure

	bResult = FALSE;
    }

/*     fprintf(stderr, "\n"); */

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionVolumeInstancePrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on projectionVolume instance.
///
/// **************************************************************************

static int ProjectionVolumeInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct ProjectionVolumeInstance *ppvi
	= (struct ProjectionVolumeInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&ppvi->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ProjectionVolumeInstance %s\n"
	 "report:\n"
	 "    number_of_added_connection_groups: %i\n"
	 "    number_of_added_connections: %i\n"
	 "    number_of_tries_adding_connections: %i\n"
	 "    number_of_failures_adding_connections: %i\n"
	 "    number_of_failures_generator_coordinates: %i\n"
	 "    number_of_failures_receiver_coordinates: %i\n",
	 pcInstance,
	 ppvi->prv.iConnectionGroups,
	 ppvi->prv.iConnections,
	 ppvi->prv.iConnectionTries,
	 ppvi->prv.iConnectionFailures,
	 ppvi->prv.iGeneratorFailures,
	 ppvi->prv.iReceiverFailures);

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_network: %s\n",
	 ppvi->prv.phsleNetwork
	 ? IdinName(SymbolGetPidin(ppvi->prv.phsleNetwork))
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_projection: %s\n",
	 ppvi->prv.phsleProjection
	 ? IdinName(SymbolGetPidin(ppvi->prv.phsleProjection))
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_randomseed: %f\n",
	 ppvi->pro.dRandomSeed);

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_probability: %f\n",
	 ppvi->pro.dProbability);

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_pre: %s\n",
	 ppvi->pro.pcPre
	 ? ppvi->pro.pcPre
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_post: %s\n",
	 ppvi->pro.pcPost
	 ? ppvi->pro.pcPost
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionVolumeInstance_weight: %f\n",
	 ppvi->pro.dWeight);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionVolumeInstanceSymbolHandler()
///
/// ARGS.:
///
///	AlgorithmInstanceSymbolHandler args.
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to add projectionVolume on given symbol
///
///	Does it do a clean update of serials ?
///
/// **************************************************************************

static 
int
ProjectionVolumeInstanceSymbolHandler
(struct AlgorithmInstance *palgi,
 struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct ProjectionVolumeInstance *ppvi
	= (struct ProjectionVolumeInstance *)palgi;

    //- if network

    if (instanceof_network(phsle))
    {
	int i = 0;

	//- set network we are handling

	ppvi->prv.phsleNetwork = phsle;
	ppvi->prv.ppistNetwork = ppist;

	//- get context for projection

	ppvi->prv.ppistProjection
	    = PidinStackDuplicate(ppvi->prv.ppistNetwork);

	ppvi->prv.ppistArgument
	    = PidinStackParse(ppvi->pro.pcProjection);

	PidinStackAppendCompact
	    (ppvi->prv.ppistProjection,ppvi->prv.ppistArgument);

	//- lookup projection symbol

	ppvi->prv.phsleProjection
	    = PidinStackLookupTopSymbol(ppvi->prv.ppistProjection);

	if (ppvi->prv.phsleProjection
	    && instanceof_projection(ppvi->prv.phsleProjection))
	{
	    struct symtab_Parameters *pparSource = NULL;
	    struct symtab_Parameters *pparTarget = NULL;

	    //- get source and target population

	    //t need to check performance issues in these routines

	    pparSource
		= SymbolFindParameter
		  (ppvi->prv.phsleProjection,"SOURCE",ppvi->prv.ppistProjection);

	    if (pparSource)
	    {
		ppvi->prv.ppistSource
		    = ParameterResolveToPidinStack
		      (pparSource,ppvi->prv.ppistProjection);

		ppvi->prv.phsleSource
		    = PidinStackLookupTopSymbol(ppvi->prv.ppistSource);
	    }

	    pparTarget
		= SymbolFindParameter
		  (ppvi->prv.phsleProjection,"TARGET",ppvi->prv.ppistProjection);

	    if (pparTarget)
	    {
		ppvi->prv.ppistTarget
		    = ParameterResolveToPidinStack
		      (pparTarget,ppvi->prv.ppistProjection);

		ppvi->prv.phsleTarget
		    = PidinStackLookupTopSymbol(ppvi->prv.ppistTarget);
	    }

	    //- if not populations

	    if (ppvi->prv.phsleSource
		&& ppvi->prv.phsleTarget
		&& (instanceof_population(ppvi->prv.phsleSource)
		    || instanceof_cell(ppvi->prv.phsleSource))
		&& (instanceof_population(ppvi->prv.phsleTarget)
		    || instanceof_cell(ppvi->prv.phsleTarget)))
	    {
		//- lookup global cache

		struct Neurospaces *pneuro = pac->pneuro;

		struct CacheRegistry *pcr = pneuro->pcr;

		//t the cache identifier does not make sense yet

		struct RegisteredCache *prc
		    = CacheRegistryLookup(pcr, (int)pac);

		//- if not set, create one

		if (!prc)
		{
		    //- init traversal for caches

		    struct TreespaceTraversal *ptstr
			= TstrNew
			  (ppvi->prv.ppistNetwork,
			   NULL,
			   NULL,
			   NULL,
			   NULL,
			   NULL,
			   NULL);

		    //- build caches

		    //t it would speed up if the selector would only select generators and receivers ?

		    //t ppiac->ppvi->pro.pcPre
		    //t ppiac->ppvi->pro.pcPost

		    struct CoordinateCache *pcc = CoordinateCacheNewForTraversal(ptstr);

		    //t then from the coordinate cache, build an index

		    if (pcc && CoordinateCacheBuildCaches(pcc))
		    {
			//- set coordinate cache as instance variable

			ppvi->prv.pcc = pcc;

			//- register the coordinate cache as a global cache

			CacheRegistryRegisterCache(pcr, 0, (int)pac, 0, pcc);

			//- this algorithm instance will use the cache from now on

			ppvi->pro.iCoordinateCache = 1;
		    }
		    else
		    {
			iResult = FALSE;

			//- give diag's : non caches

			NeurospacesError
			    (pac,
			     "ProjectionVolumeInstance",
			     "(%s) Error when building coordinate caches,"
			     " %s : %s -> %s",
			     AlgorithmInstanceGetName(&ppvi->algi),
			     SymbolName(ppvi->prv.phsleProjection),
			     SymbolName(ppvi->prv.phsleSource),
			     SymbolName(ppvi->prv.phsleTarget));
		    }
		}
		else
		{
		    //- set coordinate cache as instance variable

		    ppvi->prv.pcc = (struct CoordinateCache *)prc->pvCache;

		    //- this algorithm instance will use the cache from now on

		    ppvi->pro.iCoordinateCache = 1;
		}

		if (iResult)
		{
		    //- set random seed

		    srandom(ppvi->pro.dRandomSeed);

		    //- add connection groups with connections to projection

		    iResult
			= ProjectionVolumeInstanceAddConnectionGroups
			  (ppvi,
			   (struct symtab_Projection *)ppvi->prv.phsleProjection,
			   ppvi->prv.ppistProjection,
			   ppvi->prv.phsleSource,
			   ppvi->prv.ppistSource,
			   ppvi->prv.phsleTarget,
			   ppvi->prv.ppistTarget);

		    if (iResult != TRUE)
		    {
			iResult = FALSE;

			//- give diag's : non populations

			NeurospacesError
			    (pac,
			     "ProjectionVolumeInstance",
			     "(%s) Error during traversal of populations,"
			     " %s : %s -> %s",
			     AlgorithmInstanceGetName(&ppvi->algi),
			     SymbolName(ppvi->prv.phsleProjection),
			     SymbolName(ppvi->prv.phsleSource),
			     SymbolName(ppvi->prv.phsleTarget));
		    }

		    //- recalculate serial ID's for affected symbols

		    SymbolRecalcAllSerials
			(ppvi->prv.phsleNetwork,ppvi->prv.ppistNetwork);
		}
	    }

	    //- else

	    else
	    {
		//- give diag's : non populations

		if (ppvi->prv.phsleSource
		    && ppvi->prv.phsleTarget)
		{
		    NeurospacesError
			(pac,
			 "ProjectionVolumeInstance",
			 "(%s) Projection algorithm handler finds projection %s,"
			 " projects %s -> %s but these are not both populations",
			 AlgorithmInstanceGetName(&ppvi->algi),
			 SymbolName(ppvi->prv.phsleProjection),
			 SymbolName(ppvi->prv.phsleSource),
			 SymbolName(ppvi->prv.phsleTarget));
		}
		else
		{
		    NeurospacesError
			(pac,
			 "ProjectionVolumeInstance",
			 "(%s) Projection algorithm handler finds projection %s,"
			 " but the 'SOURCE' or 'TARGET' parameter symbols are not found",
			 AlgorithmInstanceGetName(&ppvi->algi),
			 SymbolName(ppvi->prv.phsleProjection));
		}
	    }
	}

	//- else

	else
	{
	    //- give diag's : non projection

	    if (ppvi->prv.phsleProjection)
	    {
		NeurospacesError
		    (pac,
		     "ProjectionVolumeInstance",
		     "(%s) Projection algorithm handler adding"
		     " to non projection %s",
		     AlgorithmInstanceGetName(&ppvi->algi),
		     SymbolName(ppvi->prv.phsleProjection));
	    }
	    else
	    {
		NeurospacesError
		    (pac,
		     "ProjectionVolumeInstance",
		     "(%s) Projection algorithm handler"
		     " did not find symbol %s",
		     AlgorithmInstanceGetName(&ppvi->algi),
		     ppvi->pro.pcProjection);
	    }
	}
    }

    //- else

    else
    {
	//- give diag's : prototype not found

	NeurospacesError
	    (pac,
	     "ProjectionVolumeInstance",
	     "(%s) Projection algorithm handler on non network %s\n",
	     AlgorithmInstanceGetName(&ppvi->algi),
	     "(no pidin)");
/* 	     SymbolName(phsle)); */
    }

    //- return result

    return(iResult);
}

