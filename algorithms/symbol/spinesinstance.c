//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: spinesinstance.c 1.44 Wed, 14 Nov 2007 16:12:38 -0600 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "spines.h"
#include "spinesinstance.h"


/// \struct spine algorithm private data

/*s */
/*s struct with spine options */
/*S */

struct SpinesOptions_type
{
    /*m name of prototype for random spines */

    char *pcRandomSpineProto;

    /*m spine surface option */

    double fSpineSurface;

    /*m random spines maximal dendritic diameter for segment */

    double fDendrDiaMax;

    /*m random spines minimal dendritic diameter for segment */

    double fDendrDiaMin;

    /*m spine density */

    double fSpineDensity;

    /*m spine frequency */

    double fSpineFrequency;

    /*m name selector */

    char *pcSelector;
};

typedef struct SpinesOptions_type SpinesOptions;


/// \struct
/// \struct spine variables
/// \struct

struct SpinesVariables_type
{
    /// current cell to add spines to

    struct symtab_Cell *pcell;

    /// symbol of prototype for random spines

    struct symtab_HSolveListElement *phsleSpineProto;

    /// segments to add spines to

    struct symtab_HSolveListElement **pphsleSegms;

    /// allocated segments

    int iAllocatedSegments;

    /// used segments

    int iSpinySegments;

    /*m spine surface */

    double dSpineSurface;

    /// number of added spines for this cell

    int iPhysicalSpines;

    /// number of failures when adding spines for this cell

    int iPhysicalSpinesFailures;

    /// number of tries adding spines for this cell

    int iPhysicalSpinesTries;

    /// number of (physical + virtual) spines for this cell

    double dAllSpines;
};

typedef struct SpinesVariables_type SpinesVariables;


/// \struct spines instance, derives from algorithm instance

struct SpinesInstance
{
    /// base struct

    struct AlgorithmInstance algi;

    /// options for this instance

    SpinesOptions so;

    /// variables for this instance

    SpinesVariables sv;
};


// local functions

static int SpinesInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static 
int
SpinesInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);

static int SpinesSegmentProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static int SpinesSegmentRecorder
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
SpinesSurfaceCalculator
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
SpinesDoPhysicalAdjustments
(struct SpinesInstance *psi,
 struct TreespaceTraversal *ptstr,
 struct symtab_Segmenter *psegr);

static
double
SpinesDoVirtualAdjustments
(struct SpinesInstance *psi,
 struct PidinStack *ppist,
 struct symtab_Segmenter *psegr,
 int iSpines);


static
int
SpinesSurfaceCalculator
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to algorithm instance

    struct SpinesInstance *psi = (struct SpinesInstance *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- add surface of this segment to the total surface of the spine

    psi->sv.dSpineSurface += SymbolParameterResolveValue(phsle, NULL, "SURFACE");

    //- return result

    return(iResult);
}


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of spines algorithm.
/// 

struct AlgorithmInstance *
SpinesInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/spines_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct SpinesInstance *psi
	= (struct SpinesInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct SpinesInstance), _vtable_spines, HIERARCHY_TYPE_algorithm_instances_spines);

    AlgorithmInstanceSetName(&psi->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//- scan prototype name

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProto
	    = SymbolFindParameter(&palgs->hsle, ppist, "PROTOTYPE");

	psi->so.pcRandomSpineProto = pparProto ? ParameterGetString(pparProto) : NULL ;

	//- scan surface of spine

	psi->so.fSpineSurface = SymbolParameterResolveValue(&palgs->hsle, ppist, "SPINE_SURFACE");

	if (psi->so.fSpineSurface != DBL_MAX)
	{
	    psi->so.fSpineSurface *= 1e-12;
	}

	//- scan min dia

	psi->so.fDendrDiaMin = SymbolParameterResolveValue(&palgs->hsle, ppist, "DIA_MIN");

	if (psi->so.fDendrDiaMin == DBL_MAX)
	{
	    psi->so.fDendrDiaMin = 0;
	}
	else
	{
	    psi->so.fDendrDiaMin *=  1e-6;
	}

	//- scan max dia

	psi->so.fDendrDiaMax = 1e-6 * SymbolParameterResolveValue(&palgs->hsle, ppist, "DIA_MAX");

	//- scan density

	psi->so.fSpineDensity = SymbolParameterResolveValue(&palgs->hsle, ppist, "SPINE_DENSITY");

	//- scan frequency

	psi->so.fSpineFrequency = SymbolParameterResolveValue(&palgs->hsle, ppist, "SPINE_FREQUENCY");

	//- scan name selector

	struct symtab_Parameters *pparSelector
	    = SymbolFindParameter(&palgs->hsle, ppist, "NAME_SELECTOR");

	psi->so.pcSelector = pparSelector ? ParameterGetString(pparSelector) : NULL ;
    }

    //- do error checking for frequency

    if (psi->so.fSpineFrequency < 0)
    {
	//- give diag's : prototype not found

	NeurospacesError
	    (pacContext,
	     "Spines algorithm instance",
	     "fSpineFrequency should be greater than 0, but now it is %g\n",
	     psi->so.fSpineFrequency);
    }

    //- initialize spine count

    psi->sv.iPhysicalSpines = 0;
    psi->sv.iPhysicalSpinesFailures = 0;
    psi->sv.iPhysicalSpinesTries = 0;
    psi->sv.dAllSpines = 0.0;

    //- if lookup prototype in symbol table

    if (psi->so.pcRandomSpineProto)
    {
	psi->sv.phsleSpineProto
	    = ParserLookupPrivateModel(psi->so.pcRandomSpineProto);
    }

    if (psi->sv.phsleSpineProto)
    {
	//- calculate spines surface

	psi->sv.dSpineSurface = 0.0;

	/// \todo this context does not make any sense for a private model,
	/// \todo but need something to work with.

	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	if (SymbolTraverseSegments
	    (psi->sv.phsleSpineProto,
	     ppist,
	     SpinesSurfaceCalculator,
	     NULL,
	     (void *)psi)
	    == FALSE)
	{
	    NeurospacesError
		(pacContext,
		 "Spines algorithm instance",
		 "Spine surface calculation of %s failed\n",
		 psi->so.pcRandomSpineProto);

	    psi->sv.dSpineSurface = DBL_MAX;

	    /// \todo memory leak

	    psi = NULL;
	}
    }

    //- else

    else
    {
	if (psi->so.pcRandomSpineProto)
	{
	    //- give diag's : prototype not found

	    NeurospacesError
		(pacContext,
		 "Spines algorithm instance",
		 "Private model %s not found\n",
		 psi->so.pcRandomSpineProto);
	}
    }

    //- if there was an option setting the spine surface

    if (psi->so.fSpineSurface != DBL_MAX)
    {
	//- set spine surface, possibly overwrites calculated surface

	psi->sv.dSpineSurface = psi->so.fSpineSurface;
    }

    //- if spine surface not set

    if (psi->sv.dSpineSurface == DBL_MAX)
    {
	//- give diag's

	NeurospacesError
	    (pacContext,
	     "Spines algorithm instance",
	     "Is not able to determine the spine surface\n");
    }

    //- set result

    palgiResult = &psi->algi;

    //- return result

    return(palgiResult);
}


/// 
/// \arg SymbolProcessor args
/// 
/// \return int : 
/// 
///	SymbolProcessor return value, always SYMBOL_PROCESSOR_SUCCESS
/// 
/// \brief Dummy processor which always succeeds
/// 

static
int
SpinesSegmentProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to algorithm instance

    struct SpinesInstance *psi = (struct SpinesInstance *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get pointer to segment

    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

    //- get algorithm instance info on symbol

    struct AlgorithmInstance *palgi
	= SymbolGetAlgorithmInstanceInfo(&psegr->bio.ioh.iol.hsle);

    //- if already attached by some algorithm

    if (palgi)
    {
	//- register failure in algorithm instance

	psi->sv.iPhysicalSpinesFailures++;

	//- set result : ok, but process siblings

	iResult = TSTR_PROCESSOR_FAILURE;
    }

    //- return result

    return (iResult);
}


/// 
/// \arg SymbolProcessor args
/// 
/// \return int : SymbolProcessor return value
/// 
/// \brief Record if segment needs spines
///

static
int
SpinesSegmentRecorder
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : abort

    int iResult = TSTR_PROCESSOR_ABORT;

    /// segment parameters

    double dDia;
    double dLength;

    //- get pointer to algorithm instance

    struct SpinesInstance *psi = (struct SpinesInstance *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get pointer to segment

    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

    //- if segment spherical

    if (SegmenterIsSpherical(psegr, ptstr->ppist))
    {
	//- return success

	return(TSTR_PROCESSOR_SUCCESS);
    }

    //- if the symbol is not selected

    char *pcSymbol = SymbolGetName(phsle);

    if (psi->so.pcSelector
	&& strncmp(pcSymbol, psi->so.pcSelector, strlen(psi->so.pcSelector)) != 0)
    {
	//- return success

	return(TSTR_PROCESSOR_SUCCESS);
    }

    //- get segment diameter

    dDia
	= SymbolParameterResolveValue
	  (&psegr->bio.ioh.iol.hsle, NULL, "DIA");

    //- if not found

    if (dDia == DBL_MAX)
    {
	fprintf
	    (stderr,
	     "Purkinje spines : %s doesn't have a diameter\n",
	     IdinName(SymbolGetPidin(phsle)));

	//- return result

	return(iResult);
    }

    //- if diameter small enough

    if (dDia <= psi->so.fDendrDiaMax)
    {
	//- if diameter appropriate for physical spines

	if (dDia > psi->so.fDendrDiaMin

	    //- and physical spines requested

	    && psi->so.fSpineDensity != 0.0)
	{
	    /// number of physical spines added

	    int iSpines = 0;

	    //- if add physical spines

	    iSpines
		= SpinesDoPhysicalAdjustments(psi, ptstr, psegr);

	    if (iSpines != -1)
	    {
		//- if do virtual spine adjustments

		if (SpinesDoVirtualAdjustments
		    (psi, ptstr->ppist, psegr, iSpines) != -1)
		{
		    //- set result : ok

		    iResult = TSTR_PROCESSOR_SUCCESS;
		}
	    }
	}
    }

    //- else

    else
    {
	//- set result : success

	iResult = TSTR_PROCESSOR_SUCCESS;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg ppist context of segment
/// \arg psegr segmenter candidate for spines
/// 
/// \return int : number of added physical spines, -1 for failure
/// 
/// \brief Do physical spine adjustment on segment
/// 

static
int
SpinesDoPhysicalAdjustments
(struct SpinesInstance *psi,
 struct TreespaceTraversal *ptstr,
 struct symtab_Segmenter *psegr)
{
    //- set default result : none added

    int iResult = 0;

    //- default we do not add spines

    int iAdd = 0;

    //- if frequency is set to one

    if (psi->so.fSpineFrequency == 1)
    {
	//- remember to add spines

	iAdd = 1;
    }

    //- if frequency is set to zero

    else if (psi->so.fSpineFrequency == 0)
    {
	//- we do nothing
    }

    //- if frequency is a probability

    else if (psi->so.fSpineFrequency > 0)
    {
	/// \note this algorithm tries to spread as uniformly as possible,
	/// \note by giving a guarantee that every dendrite receives at least
	/// \note one spine if the frequency is greater than or equal to 1.

	double dFrequency = psi->so.fSpineFrequency;

	//- set base number of spines: the integer part of the frequency

	iAdd = floor(dFrequency);

	//- determine fractional frequency

	dFrequency -= iAdd;

	//- generate a random number

	long int iRandom = random();

	//- compute the probability for this random number

	double dProbability = (double) iRandom / RAND_MAX;

	//- if probability lower than frequency

	if (dProbability < dFrequency)
	{
	    //- remember to add a spine

	    iAdd++;
	}
    }

    //- else

    else
    {
	//- increment failure count

	psi->sv.iPhysicalSpinesFailures++;
    }

    //- if we need to add a spine

    int iMax = iAdd;

    int iInfo = 0;

    while (iAdd > 0)
    {
	//- get pointer to spine prototype

	struct symtab_HSolveListElement *phsleSpine
	    = psi->sv.phsleSpineProto;

	//- determine a name for the new spine

	struct symtab_IdentifierIndex *pidinAlias
	    = IdinCreateAlias(SymbolGetPidin(phsleSpine), iMax - iAdd);

	//- create an alias to spine

	struct symtab_HSolveListElement *phsleNew = SymbolCreateAlias(phsleSpine, NULL, pidinAlias);

	//- add algorithm info

	if (!iInfo)
	{
/* 	    if (SymbolSetAlgorithmInstanceInfo(&psegr->bio.ioh.iol.hsle, &psi->algi)) */
	    {
		iInfo = 1;
	    }
/* 	    else */
/* 	    { */
/* 		psi->sv.iPhysicalSpinesFailures++; */
/* 	    } */
	}

	if (iInfo
	    && SymbolSetAlgorithmInstanceInfo(phsleNew, &psi->algi))
	{
	    //- link symbol to segment

	    SymbolAddChild(&psegr->bio.ioh.iol.hsle, phsleNew);
    
	    //- increment spine count

	    psi->sv.iPhysicalSpines++;

	    //- increment result

	    iResult++;
	}

	//- else

	else
	{
	    //- increment failure count

	    psi->sv.iPhysicalSpinesFailures++;
	}

	//- decrement number of spines to add

	iAdd--;
    }

    //- increment tries count

    psi->sv.iPhysicalSpinesTries++;

    //- return result

    return(iResult);
}


/// 
/// \arg psi spines algorithm instance.
/// \arg ppist context of segment
/// \arg psegr segment candidate for spines
/// \arg iSpines: number of physical spines added to this segment
/// 
/// \return double  number of added virtual spines, -1 for failure
/// 
/// \brief Do virtual spine adjustment on segment
/// 

static
double
SpinesDoVirtualAdjustments
(struct SpinesInstance *psi,
 struct PidinStack *ppist,
 struct symtab_Segmenter *psegr,
 int iSpines)
{
    //- set default result : none added

    double dResult = 0.0;

    double dLength;
    double dSpines;

    //- get segment length

    dLength
	= SymbolParameterResolveValue
	  (&psegr->bio.ioh.iol.hsle, ppist, "LENGTH");

    //- calculate total number of spines for this segment

    /// \note here we assume fSpineDensity has units spines/m
    /// \note probably better to get this into spines/m^2
    ///
    /// \note for now this is a compatibility issue with the old reader

    dSpines = dLength * psi->so.fSpineDensity * 1e6;

    //- if there were any spines

    if (dSpines > 0)
    {
	/// segment surface

	double dSegment;

	//- calculate number of spines to add

	/// \note can get negative ...

	dSpines -= iSpines;

	//- set result : number of spines to add

	dResult = dSpines;

	//- get surface of segment

	dSegment
	    = SymbolParameterResolveValue
	      (&psegr->bio.ioh.iol.hsle, ppist, "SURFACE");

	if (dSegment == DBL_MAX)
	{
	    fprintf
		(stderr,
		 "Spines : %s doesn't have a surface\n",
		 IdinName(SymbolGetPidin(&psegr->bio.ioh.iol.hsle)));

	    dResult = -1.0;
	}

	//- recalculate segment surface

	/// \note can be a subtraction ...

	dSegment += dSpines * psi->sv.dSpineSurface;

	//- set new surface

	SymbolSetParameterDouble
	    (&psegr->bio.ioh.iol.hsle, "SURFACE", dSegment);
    }

    //- increment spine count

    psi->sv.dAllSpines += dSpines;

    //- return result

    return(dResult);
}


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on spines instance.
/// 

static int SpinesInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct SpinesInstance *psi = (struct SpinesInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&psi->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: SpinesInstance %s\n"
	 "report:\n"
	 "    number_of_added_spines: %i\n"
	 "    number_of_virtual_spines: %f\n"
	 "    number_of_spiny_segments: %i\n"
	 "    number_of_failures_adding_spines: %i\n",
	 pcInstance,
	 psi->sv.iPhysicalSpines,
	 psi->sv.dAllSpines,
	 psi->sv.iPhysicalSpinesTries,
	 psi->sv.iPhysicalSpinesFailures);

    fprintf
	(pfile,
	 "    SpinesInstance_prototype: %s\n",
	 psi->sv.phsleSpineProto
	 ? IdinName(SymbolGetPidin(psi->sv.phsleSpineProto))
	 : "(none)");

    fprintf
	(pfile,
	 "    SpinesInstance_surface: %g\n",
	 psi->sv.dSpineSurface);

    //- return result

    return(bResult);
}


/// 
/// \arg AlgorithmInstanceSymbolHandler args.
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to add spines on given symbol
///
/// \todo 
/// 
///	Does it do a clean update of serials ?
/// 

static 
int
SpinesInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- if cell

    if (instanceof_cell(phsle))
    {
	int i = 0;

	//- traverse segments and add spines

	iResult
	    = SymbolTraverseSegments
	      (phsle,
	       ppist,
	       SpinesSegmentProcessor,
	       SpinesSegmentRecorder,
	       (void *)(struct SpinesInstance *)palgi);

	if (iResult != 1)
	{
	    iResult = FALSE;
	}

	SymbolRecalcAllSerials(phsle, ppist);
    }

    //- if an em section

    else if (instanceof_v_contour(phsle))
    {
	//- give feedback: not yet implemented

	char pc[1000];

	PidinStackString(&pac->pist, pc, 1000);

	NeurospacesError
	    (pac,
	     "SpinesInstance",
	     "Spine algorithm handler on a contour group %s (not yet implemented)\n",
	     pc);
    }

    //- else

    else
    {
	//- give diag's: not a cell or section

	char pc[1000];

	PidinStackString(&pac->pist, pc, 1000);

	NeurospacesError
	    (pac,
	     "SpinesInstance",
	     "Spine algorithm handler on non cell and non section %s\n",
	     pc);
    }

    //- return result

    return(iResult);
}


