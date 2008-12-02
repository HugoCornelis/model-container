//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionrandomizedinstance.c 1.25 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "projectionrandomized.h"
#include "projectionrandomizedinstance.h"


/// \struct projection algorithm private data

/*s */
/*s struct with projection options */
/*S */

struct ProjectionRandomizedOptions_type
{
//			{ -name BackwardProjection -randseed 1212 -prob 1.0 -pre spikegen -post pf_AMPA}

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
};

typedef struct ProjectionRandomizedOptions_type ProjectionRandomizedOptions;


/// \struct
/// \struct projection variables
/// \struct

struct ProjectionRandomizedVariables_type
{
    /// symbol that points to network where algorithm is instantiated

    struct symtab_HSolveListElement *phsleNetwork;

    /// context of network (parser context)

    struct PidinStack *ppistNetwork;

    /// symbol attached to

    struct symtab_HSolveListElement *phsleProjection;
    struct PidinStack *ppistProjection;

    /// reference to projection (not owned by projection)

    struct PidinStack *ppistArgument;

    /// source population / cell

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    /// target population / cell

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;

    /// number of added connection groups

    int iConnectionGroups;

    /// total number of added connections

    int iConnections;

    /// number of failures when adding connections

    int iConnectionFailures;

    /// number of tries adding connections

    int iConnectionTries;
};

typedef struct ProjectionRandomizedVariables_type ProjectionRandomizedVariables;


/// \struct projectionRandomized instance, derives from algorithm instance

struct ProjectionRandomizedInstance
{
    /// base struct

    struct AlgorithmInstance algi;

    /// options for this instance

    ProjectionRandomizedOptions pro;

    /// variables for this instance

    ProjectionRandomizedVariables prv;
};


/// \struct number of symbol that have been modified

/* static int iModified = 0; */

/* #define MAX_NUM_MODIFIED	10 */

/* static struct symtab_IOHierarchy *ppiohModified[MAX_NUM_MODIFIED]; */


// local functions

static
int
ProjectionRandomizedInstanceAddConnectionGroups
(struct ProjectionRandomizedInstance *ppri,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget);

static int ProjectionRandomizedInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static 
int
ProjectionRandomizedInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);

static int 
ProjectionRandomizedSpikeGeneratorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static int 
ProjectionRandomizedSpikeReceiverProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of projectionRandomized algorithm.
/// \details 
/// 

struct AlgorithmInstance *
ProjectionRandomizedInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/projectionrandomized_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct ProjectionRandomizedInstance *ppri
	= (struct ProjectionRandomizedInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct ProjectionRandomizedInstance), _vtable_projectionrandomized, HIERARCHY_TYPE_algorithm_instances_projectionrandomized);

    AlgorithmInstanceSetName(&ppri->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProjection
	    = SymbolFindParameter(&palgs->hsle, ppist, "PROJECTION_NAME");

	//- scan projection name

	ppri->pro.pcProjection = ParameterGetString(pparProjection);

	//- scan random seed

	ppri->pro.dRandomSeed = SymbolParameterResolveValue(&palgs->hsle, ppist, "RANDOMSEED");

	//- scan probability value

	ppri->pro.dProbability = SymbolParameterResolveValue(&palgs->hsle, ppist, "PROBABILITY");

	//- scan presynaptic part

	struct symtab_Parameters *pparPre
	    = SymbolFindParameter(&palgs->hsle, ppist, "PRE");

	ppri->pro.pcPre = ParameterGetString(pparPre);

	//- scan postsynaptic part

	struct symtab_Parameters *pparPost
	    = SymbolFindParameter(&palgs->hsle, ppist, "POST");

	ppri->pro.pcPost = ParameterGetString(pparPost);
    }

    //- initialize connection counts

    ppri->prv.iConnectionGroups = 0;
    ppri->prv.iConnections = 0;
    ppri->prv.iConnectionFailures = 0;
    ppri->prv.iConnectionTries = 0.0;

    //- set result

    palgiResult = &ppri->algi;

    //- return result

    return(palgiResult);
}


/// 
/// 
/// \arg ppri projectionRandomized instance.
/// \arg pproj projection symbol to add connection groups to.
/// \arg ppistProjection 
///	phsleSource.....: source population / cell of projection.
/// \arg ppistSource 
///	phsleTarget.....: target population / cell of projection.
///	ppistTarget.....: 
/// 
/// \return int : success of operation
/// 
/// \brief Adds connection groups with connections to projection.
/// \details 
/// 

struct ProjectionRandomizedInstanceAddConnectionGroups_data
{
    /// projection randomized algorithm instance

    struct ProjectionRandomizedInstance *ppri;

    /// network we are handling

    struct symtab_HSolveListElement *phsleNetwork;
    struct PidinStack *ppistNetwork;

    /// projection to add to

    struct symtab_Projection *pproj;
    struct PidinStack *ppistProjection;

    /// active connection group

    struct symtab_VConnection *pvconn;

    /// current spike generator

    struct symtab_Attachment *pattaGenerator;
    struct PidinStack *ppistGenerator;

    /// current spike receiver

    struct symtab_Attachment *pattaReceiver;
    struct PidinStack *ppistReceiver;

    /// source population

    struct symtab_HSolveListElement *phsleSource;
    struct PidinStack *ppistSource;

    /// target population

    struct symtab_HSolveListElement *phsleTarget;
    struct PidinStack *ppistTarget;
};


static int 
ProjectionRandomizedSpikeGeneratorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_ABORT;

    //- get pointer to current connection group data

    struct ProjectionRandomizedInstanceAddConnectionGroups_data *ppiac
	= (struct ProjectionRandomizedInstanceAddConnectionGroups_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if name does not match -pre

    if (strcmp(IdinName(SymbolGetPidin(phsle)),ppiac->ppri->pro.pcPre) != 0)
    {
	//- return result : do not process

	iResult = TSTR_PROCESSOR_FAILURE;

	return(iResult);
    }

    //- fill in current spike generator

    ppiac->pattaGenerator = (struct symtab_Attachment *)phsle;
    ppiac->ppistGenerator = ptstr->ppist;

    //- traverse spike receivers for target population

    if (SymbolTraverseSpikeReceivers
	(ppiac->phsleTarget,
	 ppiac->ppistTarget,
	 ProjectionRandomizedSpikeReceiverProcessor,
	 NULL,
	 (void *)ppiac) == 1)
    {
	//- set result : ok

	iResult = TSTR_PROCESSOR_SUCCESS;
    }

    //- return result

    return(iResult);
}


static int 
ProjectionRandomizedSpikeReceiverProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to current connection group data

    struct ProjectionRandomizedInstanceAddConnectionGroups_data *ppiac
	= (struct ProjectionRandomizedInstanceAddConnectionGroups_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get name of channel

    struct symtab_IdentifierIndex *pidinChannel
	= PidinStackElementPidin
	  (ptstr->ppist,PidinStackNumberOfEntries(ptstr->ppist) - 2);

    //- if name does not match -post

    if (strcmp(IdinName(pidinChannel),ppiac->ppri->pro.pcPost) != 0)
    {
	//- return result : do not process

	iResult = TSTR_PROCESSOR_FAILURE;

	return(iResult);
    }

    //- fill in current spike receiver

    ppiac->pattaReceiver = (struct symtab_Attachment *)phsle;
    ppiac->ppistReceiver = ptstr->ppist;

    //- if random number smaller than connection probability

    if (random() < RAND_MAX * ppiac->ppri->pro.dProbability)
    {
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

	/// \note check serial principals from treespace traversals, should match.

	//- construct connection between pre- and post-synaptic sites

/* 	struct symtab_Connection *pconn */
/* 	    = ConnectionNewForStandardConnection */
/* 	      (iPre - iSource, iPost - iTarget, 1.0, 1.0); */

	struct symtab_Connection conn =
	    {
		iPre - iSource, iPost - iTarget, 1.0, 1.0,
	    };

	//- add connection component to container

	ppiac->ppri->prv.iConnectionTries++;
	ppiac->ppri->prv.iConnections++;

	/// \todo should this be SymbolAddChild() ?

/* 	IOHierarchyAddChild(&ppiac->pvconsy->vect.bio.ioh, &pconn->hsle); */

	VConnectionAddConnection(ppiac->pvconn, &conn);
    }

    //- return result

    return(iResult);
}


static
int
ProjectionRandomizedInstanceAddConnectionGroups
(struct ProjectionRandomizedInstance *ppri,
 struct symtab_Projection *pproj,
 struct PidinStack *ppistProjection,
 struct symtab_HSolveListElement *phsleSource,
 struct PidinStack *ppistSource,
 struct symtab_HSolveListElement *phsleTarget,
 struct PidinStack *ppistTarget)
{
    //- set default result : failure

    int bResult = FALSE;

    struct ProjectionRandomizedInstanceAddConnectionGroups_data piac =
    {
	/// projection randomized algorithm instance

	ppri,

	/// network we are handling

	ppri->prv.phsleNetwork,
	ppri->prv.ppistNetwork,

	/// projection to add to

	pproj,
	ppistProjection,

	/// active connection group

	NULL,

	/// current spike generator

	NULL,
	NULL,

	/// current spike receiver

	NULL,
	NULL,

	/// source population

	phsleSource,
	ppistSource,

	/// target population

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

/*     VConnectionAddConnection(NULL, NULL); */

    struct symtab_IdentifierIndex *pidin = IdinCallocUnique("v_group_");

    SymbolSetName(&pvconn->vect.bio.ioh.iol.hsle, pidin);

/*     //- get zero context for source and target populations */

/*     /// \note this enables the symbol cache on the context which */
/*     /// \note can then be used to calculate pre- and post-synaptic */
/*     /// \note serials. */

/*     piac.ppistSource = PidinStackCalloc(); */
/*     piac.ppistTarget = PidinStackCalloc(); */

    //- process spike mapping elements and add connections

    piac.pvconn = pvconn;

    if (SymbolTraverseSpikeGenerators
	(phsleSource,
	 piac.ppistSource,
	 ProjectionRandomizedSpikeGeneratorProcessor,
	 NULL,
	 (void *)&piac) == 1)
    {
	//- add connection group to projection

	ppri->prv.iConnectionGroups++;

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

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on projectionRandomized instance.
/// \details 
/// 

static int ProjectionRandomizedInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct ProjectionRandomizedInstance *ppri
	= (struct ProjectionRandomizedInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&ppri->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ProjectionRandomizedInstance %s\n"
	 "report:\n"
	 "    number_of_added_connection_groups: %i\n"
	 "    number_of_added_connections: %i\n"
	 "    number_of_tries_adding_connections: %i\n"
	 "    number_of_failures_adding_connections: %i\n",
	 pcInstance,
	 ppri->prv.iConnectionGroups,
	 ppri->prv.iConnections,
	 ppri->prv.iConnectionTries,
	 ppri->prv.iConnectionFailures);

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_network: %s\n",
	 ppri->prv.phsleNetwork
	 ? IdinName(SymbolGetPidin(ppri->prv.phsleNetwork))
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_projection: %s\n",
	 ppri->prv.phsleProjection
	 ? IdinName(SymbolGetPidin(ppri->prv.phsleProjection))
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_randomseed: %f\n",
	 ppri->pro.dRandomSeed);

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_probability: %f\n",
	 ppri->pro.dProbability);

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_pre: %s\n",
	 ppri->pro.pcPre
	 ? ppri->pro.pcPre
	 : "(none)");

    fprintf
	(pfile,
	 "    ProjectionRandomizedInstance_post: %s\n",
	 ppri->pro.pcPost
	 ? ppri->pro.pcPost
	 : "(none)");

    //- return result

    return(bResult);
}


/// 
/// 
///	AlgorithmInstanceSymbolHandler args.
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to add projectionRandomized on given symbol
/// \details 
/// 
///	Does it do a clean update of serials ?
/// 

static 
int
ProjectionRandomizedInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct ProjectionRandomizedInstance *ppri
	= (struct ProjectionRandomizedInstance *)palgi;

    //- if network

    if (instanceof_network(phsle))
    {
	int i = 0;

	//- set network we are handling

	ppri->prv.phsleNetwork = phsle;
	ppri->prv.ppistNetwork = ppist;

	//- get context for projection

	ppri->prv.ppistProjection
	    = PidinStackDuplicate(ppri->prv.ppistNetwork);

	ppri->prv.ppistArgument
	    = PidinStackParse(ppri->pro.pcProjection);

	PidinStackAppendCompact
	    (ppri->prv.ppistProjection,ppri->prv.ppistArgument);

	//- lookup projection symbol

	ppri->prv.phsleProjection
	    = PidinStackLookupTopSymbol(ppri->prv.ppistProjection);

	if (instanceof_projection(ppri->prv.phsleProjection))
	{
	    struct symtab_Parameters *pparSource = NULL;
	    struct symtab_Parameters *pparTarget = NULL;

	    //- get source and target population

	    /// \todo need to check performance issues in these routines

	    pparSource
		= SymbolFindParameter
		  (ppri->prv.phsleProjection, ppri->prv.ppistProjection, "SOURCE");
	    ppri->prv.ppistSource
		= ParameterResolveToPidinStack
		  (pparSource,ppri->prv.ppistProjection);

	    pparTarget
		= SymbolFindParameter
		  (ppri->prv.phsleProjection, ppri->prv.ppistProjection, "TARGET");
	    ppri->prv.ppistTarget
		= ParameterResolveToPidinStack
		  (pparTarget,ppri->prv.ppistProjection);

	    ppri->prv.phsleSource
		= PidinStackLookupTopSymbol(ppri->prv.ppistSource);

	    ppri->prv.phsleTarget
		= PidinStackLookupTopSymbol(ppri->prv.ppistTarget);

	    //- if not populations

	    if ((instanceof_population(ppri->prv.phsleSource)
		 || instanceof_cell(ppri->prv.phsleSource))
		&& (instanceof_population(ppri->prv.phsleTarget)
		    || instanceof_cell(ppri->prv.phsleTarget)))
	    {
		//- set random seed

		srandom(ppri->pro.dRandomSeed);

		//- add connection groups with connections to projection

		iResult
		    = ProjectionRandomizedInstanceAddConnectionGroups
		      (ppri,
		       (struct symtab_Projection *)ppri->prv.phsleProjection,
		       ppri->prv.ppistProjection,
		       ppri->prv.phsleSource,
		       ppri->prv.ppistSource,
		       ppri->prv.phsleTarget,
		       ppri->prv.ppistTarget);

		if (iResult != TRUE)
		{
		    iResult = FALSE;

		    //- give diag's : non populations

		    NeurospacesError
			(pac,
			 "ProjectionRandomizedInstance",
			 "(%s) Error during traversal of populations,"
			 " %s : %s -> %s",
			 AlgorithmInstanceGetName(&ppri->algi),
			 SymbolName(ppri->prv.phsleProjection),
			 SymbolName(ppri->prv.phsleSource),
			 SymbolName(ppri->prv.phsleTarget));
		}

		//- recalculate serial ID's for affected symbols

		SymbolRecalcAllSerials
		    (ppri->prv.phsleNetwork,ppri->prv.ppistNetwork);
	    }

	    //- else

	    else
	    {
		//- give diag's : non populations

		NeurospacesError
		    (pac,
		     "ProjectionRandomizedInstance",
		     "(%s) Projection algorithm handler finds projection %s,"
		     " projects %s -> %s but these are not both populations\n",
		     AlgorithmInstanceGetName(&ppri->algi),
		     SymbolName(ppri->prv.phsleProjection),
		     SymbolName(ppri->prv.phsleSource),
		     SymbolName(ppri->prv.phsleTarget));
	    }
	}

	//- else

	else
	{
	    //- give diag's : non projection

	    NeurospacesError
		(pac,
		 "ProjectionRandomizedInstance",
		 "(%s) Projection algorithm handler adding"
		 " to non projection %s\n",
		 AlgorithmInstanceGetName(&ppri->algi),
		 SymbolName(ppri->prv.phsleProjection));
	}
    }

    //- else

    else
    {
	//- give diag's : prototype not found

	NeurospacesError
	    (pac,
	     "ProjectionRandomizedInstance",
	     "(%s) Projection algorithm handler on non network %s\n",
	     AlgorithmInstanceGetName(&ppri->algi),
	     "(no pidin)");
/* 	     SymbolName(phsle)); */
    }

    //- return result

    return(iResult);
}


