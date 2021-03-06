//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: segment.c 1.137 Wed, 10 Oct 2007 12:05:16 -0500 hugo $
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

#include "neurospaces/components/segment.h"
#include "neurospaces/function.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"



static
double
SegmentGetBranchpointFlag
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetLength
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetSomatopetalBranchpoints
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetSomatopetalDistance
(struct symtab_Segment *psegment, struct PidinStack *ppist);

/* static */
double
SegmentGetSurface
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetTau
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetVmInit
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetVolume
(struct symtab_Segment *psegment, struct PidinStack *ppist);


/// 
/// \return struct symtab_Segment * 
/// 
///	Newly allocated segment, NULL for failure
/// 
/// \brief Allocate a new segment symbol table element
/// 

struct symtab_Segment * SegmentCalloc(void)
{
    //- set default result : failure

    struct symtab_Segment *psegmentResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/segment_vtable.c"

    //- allocate segment

    psegmentResult
	= (struct symtab_Segment *)
	  SymbolCalloc(1, sizeof(struct symtab_Segment), _vtable_segment, HIERARCHY_TYPE_symbols_segment);

    //- initialize segment

    SegmentInit(psegmentResult);

    //- return result

    return(psegmentResult);
}


/// 
/// \arg psegment symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
SegmentCreateAlias
(struct symtab_Segment *psegment,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Segment *psegmentResult = SegmentCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&psegmentResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&psegmentResult->segr.bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&psegmentResult->segr.bio.ioh.iol.hsle, &psegment->segr.bio.ioh.iol.hsle);

    //- set options

    int iOptions = SymbolGetOptions(&psegment->segr.bio.ioh.iol.hsle);

    iOptions &= ~(BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL);

    SymbolSetOptions(&psegmentResult->segr.bio.ioh.iol.hsle, iOptions);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_segment);

    //- return result

    return(&psegmentResult->segr.bio.ioh.iol.hsle);
}


/// 
/// \arg psegment segment to get length for.
/// \arg ppist context of segment.
/// 
/// \return double
/// 
///	1, 2, 3 ... if this is a branch point, 0 if not, DBL_MAX if unknown.
/// 
/// \brief Get branch point flag of this segment.
/// 

static
double
SegmentGetBranchpointFlag
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result: failure

    double dResult = DBL_MAX;

    //- get segmenter base symbol

    struct symtab_Parameters *pparBase
	= SymbolFindParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "SEGMENTER_BASE");

    if (pparBase)
    {
	struct PidinStack *ppistBase
	    = ParameterResolveToPidinStack(pparBase, ppist);

	if (ppistBase)
	{
	    struct symtab_HSolveListElement *phsleBase
		= PidinStackLookupTopSymbol(ppistBase);

	    //- build linearized caches

	    struct symtab_Segmenter *psegrBase
		= (struct symtab_Segmenter *)phsleBase;

	    if (SegmenterLinearize(psegrBase, ppistBase))
	    {
		//- get serial of ppist

		int iSerial = PidinStackToSerial(ppist);

		//- loop over all segments contained in the base

		int i;

		for (i = 0 ; i < psegrBase->desegmenter.iSegments ; i++)
		{
		    //- get current segment

		    struct cable_structure *pcs = &psegrBase->desegmenter.pcs[i];

		    //- if it is the one of the branchpoint flag request

		    if (pcs->iSerial == iSerial)
		    {
			//- ok, stop searching loop

			break;
		    }
		}

		//- set current segment parent index

		if (i < psegrBase->desegmenter.iSegments)
		{
		    //- branchpoint flag is number of children minus 1 (1 means linear cable extension)

		    dResult = psegrBase->desegmenter.piChildren[i] - 1;
		}
		else
		{
		    /// \note not found, this is an internal error

		    fprintf
			(stderr,
			 "internal error: SegmenterLinearize() was used to obtain the branchpoint flag on a segment that does not belong to its own container\n");

		    dResult = DBL_MAX;
		}
	    }

	    //- free allocated memory

	    PidinStackFree(ppistBase);
	}
	else
	{
	    fprintf
		(stderr,
		 "*** Error: SegmentGetBranchpointFlag(): segmenter base cannot be found\n");

	    ParameterPrintInfoRecursive(pparBase, ppist, 0, stderr);

	    dResult = DBL_MAX;
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get length for.
/// \arg ppist context of segment.
/// 
/// \return double : segment length, DBL_MAX for failure.
/// 
/// \brief Get length of segment.
/// 
/// \note 
/// 
///	This function assumes relative to the somatopetal neighbour
///	coordinates for all segments.  See also notes on that in
///	parser.rules.
/// 
/// \todo  
/// 
///	To change the note mentioned above : use ppist and ->pidinSomatopetal
///	to go to somatopetal neighbour and get its coordinates, subtract to get relative
///	coordinates.  Since ->pidinSomatopetal is relative to the
///	parent symbol, ppist must first be popped.  This should be
///	changed, with changes in the description files too.  See also
///	relevant note in the genesis implementation,
///	cellsolver_getsegments().
/// 

static
double
SegmentGetLength
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- get coordinates

    double dX
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_X");
    double dY
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_Y");
    double dZ
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_Z");

    if (dX != DBL_MAX
	&& dY != DBL_MAX
	&& dZ != DBL_MAX)
    {
	//- calculate distance between two segments

	dResult = sqrt(dX * dX + dY * dY + dZ * dZ);
    }
    else
    {
/* 	fprintf */
/* 	    (stderr, */
/* 	     "SegmentGetLength() : %s doesn't have relative coordinates\n", */
/* 	     IdinName(SymbolGetPidin(&psegment->segr.bio.ioh.iol.hsle))); */
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment symbol to get parameter for
/// \arg ppist context of symbol.
/// \arg pcName name of parameter
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get specific parameter of symbol.
/// 

struct symtab_Parameters * 
SegmentGetParameter
(struct symtab_Segment *psegment,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&psegment->segr.bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if somatopetal distance

	if (0 == strcmp(pcName, "SOMATOPETAL_DISTANCE"))
	{
	    //- get distance

	    double dDistance = SegmentGetSomatopetalDistance(psegment, ppist);

	    //- set distance of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegment->segr.bio.ioh.iol.hsle, "SOMATOPETAL_DISTANCE", dDistance);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if somatopetal branchpoints

	else if (0 == strcmp(pcName, "SOMATOPETAL_BRANCHPOINTS"))
	{
	    //- get branchpoints

	    double dBranchpoints = SegmentGetSomatopetalBranchpoints(psegment, ppist);

	    //- set branchpoints of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegment->segr.bio.ioh.iol.hsle, "SOMATOPETAL_BRANCHPOINTS", dBranchpoints);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if branchpoint flag

	else if (0 == strcmp(pcName, "BRANCHPOINT"))
	{
	    //- get branchpoint flag

	    double dBranchpoint = SegmentGetBranchpointFlag(psegment, ppist);

	    //- set branchpoint flag of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegment->segr.bio.ioh.iol.hsle, "BRANCHPOINT", dBranchpoint);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if surface

	else if (0 == strcmp(pcName, "SURFACE"))
	{
	    //- get surface

	    double dSurface = SegmentGetSurface(psegment, ppist);

	    //- set surface of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegment->segr.bio.ioh.iol.hsle, "SURFACE", dSurface);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if volume

	else if (0 == strcmp(pcName, "VOLUME"))
	{
	    //- get volume

	    double dVolume = SegmentGetVolume(psegment, ppist);

	    //- set volume of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegment->segr.bio.ioh.iol.hsle, "VOLUME", dVolume);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if length

	else if (0 == strcmp(pcName, "LENGTH"))
	{
	    //- calculate length

	    double dLength = SegmentGetLength(psegment, ppist);

	    if (dLength != DBL_MAX)
	    {
		//- set length of segment

		pparResult
		    = SymbolSetParameterDouble
		      (&psegment->segr.bio.ioh.iol.hsle, "LENGTH", dLength);

		pparResult->iFlags |= FLAG_PARA_DERIVED;
	    }
	}

	//- if time constant

	else if (0 == strcmp(pcName, "TAU"))
	{
	    //- calculate time constant

	    double dTau = SegmentGetTau(psegment, ppist);

	    if (dTau != DBL_MAX)
	    {
		//- set time constant

		pparResult
		    = SymbolSetParameterDouble
		      (&psegment->segr.bio.ioh.iol.hsle, "TAU", dTau);

		pparResult->iFlags |= FLAG_PARA_DERIVED;
	    }
	}

	//- if initial membrane potential

	else if (0 == strcmp(pcName, "Vm_init"))
	{
	    //- calculate initial membrane potential

	    double dVmInit = SegmentGetVmInit(psegment, ppist);

	    if (dVmInit != DBL_MAX)
	    {
		//- set initial membrane potential

		pparResult
		    = SymbolSetParameterDouble
		      (&psegment->segr.bio.ioh.iol.hsle, "Vm_init", dVmInit);

		pparResult->iFlags |= FLAG_PARA_DERIVED;
	    }
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg psegment segment to get somatopetal branchpoints for.
/// \arg ppist context of segment.
/// 
/// \return double : segment somatopetal branchpoints, DBL_MAX for failure.
/// 
/// \brief get somatopetal branchpoints of segment.
/// 

static
double
SegmentGetSomatopetalBranchpoints
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : no branchpoints

    double dResult = 0.0;

    //- create a working context

    struct PidinStack *ppistWorking = PidinStackDuplicate(ppist);

    //- loop over parents

    struct symtab_HSolveListElement *phsle = &psegment->segr.bio.ioh.iol.hsle;

    while (phsle)
    {
	//- if this is the soma

	if (strncmp(SymbolGetName(phsle), "soma", strlen("soma")) == 0)
	{
	    /// \note should we add the soma branch point flag to ?

	    //- done, break loop

	    break;
	}

	//- add branch point flag of this symbol

	double dBranchpoint = SymbolParameterResolveValue(phsle, ppistWorking, "BRANCHPOINT");

	if (dBranchpoint == DBL_MAX)
	{
	    dResult = DBL_MAX;

	    break;
	}

	dResult += dBranchpoint ? 1 : 0;

	//- go to parent symbol

	struct symtab_Parameters *pparParent
	    = SymbolFindParameter(phsle, ppistWorking, "PARENT");

	if (pparParent)
	{
	    struct PidinStack *ppistParent
		= ParameterResolveToPidinStack(pparParent, ppistWorking);

	    //- lookup parent

	    phsle = PidinStackLookupTopSymbol(ppistParent);

	    //- if not found

	    if (!phsle)
	    {
		//- we just let this go
	    }

	    PidinStackFree(ppistWorking);

	    ppistWorking = ppistParent;

	    //- add number of branch points of the parent

	    double dParentBranchPoints = SymbolParameterResolveValue(phsle, ppistWorking, "SOMATOPETAL_BRANCHPOINTS");

	    if (dParentBranchPoints != DBL_MAX)
	    {
		dResult += dParentBranchPoints;
	    }
	    else
	    {
		dResult = DBL_MAX;
	    }

	    phsle = NULL;

	}

	//- if no parent

	else
	{
	    //- break loop

	    phsle = NULL;
	}
    }

    //- free allocated memory

    if (ppistWorking)
    {
	PidinStackFree(ppistWorking);
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get somatopetal distance for.
/// \arg ppist context of segment.
/// 
/// \return double : segment somatopetal distance, DBL_MAX for failure.
/// 
/// \brief get somatopetal distance of segment.
/// 

static
double
SegmentGetSomatopetalDistance
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : zero

    double dResult = 0.0;

    //- create a working context

    struct PidinStack *ppistWorking = PidinStackDuplicate(ppist);

    //- loop over parents

    struct symtab_HSolveListElement *phsle = &psegment->segr.bio.ioh.iol.hsle;

    while (phsle)
    {
	//- if this is the soma

	if (strncmp(SymbolGetName(phsle), "soma", strlen("soma")) == 0)
	{
	    //- done, break loop

	    break;
	}

	//- add length of this symbol

	double dLength = SymbolParameterResolveValue(phsle, ppistWorking, "LENGTH");

	if (dLength == DBL_MAX)
	{
	    dResult = DBL_MAX;

	    break;
	}

	dResult += dLength;

	//- go to parent symbol

	struct symtab_Parameters *pparParent
	    = SymbolFindParameter(phsle, ppistWorking, "PARENT");

	if (pparParent)
	{
	    struct PidinStack *ppistParent
		= ParameterResolveToPidinStack(pparParent, ppistWorking);

	    //- lookup parent

	    phsle = PidinStackLookupTopSymbol(ppistParent);

	    //- if not found

	    if (!phsle)
	    {
		//- return failure

		PidinStackFree(ppistParent);

		dResult = DBL_MAX;

		break;
	    }

	    PidinStackFree(ppistWorking);

	    ppistWorking = ppistParent;

	    //- add somatopetal distance of the parent

	    double dParentDistance = SymbolParameterResolveValue(phsle, ppistWorking, "SOMATOPETAL_DISTANCE");

	    if (dParentDistance != DBL_MAX)
	    {
		dResult += dParentDistance;
	    }
	    else
	    {
		dResult = DBL_MAX;
	    }

	    phsle = NULL;

	}

	//- if no parent

	else
	{
	    //- break loop

	    phsle = NULL;
	}
    }

    //- free allocated memory

    if (ppistWorking)
    {
	PidinStackFree(ppistWorking);
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get surface for.
/// \arg ppist context of segment.
/// 
/// \return double : segment surface, DBL_MAX for failure.
/// 
/// \brief get surface of segment.
/// 

/* static */
double
SegmentGetSurface
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- if spherical segment

    /// \note this must be a single segment, not a segmenter

    /// \todo but the cast should not be here, there is a mismatch in the
    /// \todo derivation hierarchy here.

    if (SegmenterIsSpherical((struct symtab_Segmenter *)psegment, ppist))
    {
	//- calculate surface

	dResult
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	if (dResult != DBL_MAX)
	{
	    dResult = dResult * dResult * M_PI;
	}
    }

    //- else (cylindrical)

    else
    {
	//- if dia and length found

	double dDia
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	double dLength
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "LENGTH");

	if (dDia != DBL_MAX && dLength != FLT_MAX)
	{
	    //- calculate surface

	    dResult =  M_PI * dDia * dLength;
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get time constant for.
/// \arg ppist context of segment.
/// 
/// \return double : segment time constant, DBL_MAX for failure.
/// 
/// \brief Get time constant of segment.
/// 

static
double
SegmentGetTau
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- get capacitance and resistance

    /// \note note that it does not matter if we use specific or actual values

    double dCm
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "CM");
    double dRm
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "RM");

    if (dCm != DBL_MAX
	&& dRm != DBL_MAX)
    {
	//- calculate time constant

	dResult = dCm * dRm;
    }
    else
    {
/* 	fprintf */
/* 	    (stderr, */
/* 	     "SegmentGetTau() : %s doesn't have a capacitance or resistance\n", */
/* 	     IdinName(SymbolGetPidin(&psegment->segr.bio.ioh.iol.hsle))); */
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get initial membrane potential for.
/// \arg ppist context of segment.
/// 
/// \return double : segment initial membrane potential, DBL_MAX for
/// failure.
/// 
/// \brief Get initial membrane potential of segment.
/// 

static
double
SegmentGetVmInit
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- get leak conductance potential

    /// \note note that it does not matter if we use specific or actual values

    double dEm
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "ELEAK");

    //- set result

    dResult = dEm;

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to get volume for.
/// \arg ppist context of segment.
/// 
/// \return double : segment volume, DBL_MAX for failure.
/// 
/// \brief get volume of segment.
/// 

static
double
SegmentGetVolume
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- if spherical segment

    /// \note this must be a single segment, not a segmenter

    /// \todo but the cast should not be here, there is a mismatch in the
    /// \todo derivation hierarchy here.

    if (SegmenterIsSpherical((struct symtab_Segmenter *)psegment, ppist))
    {
	//- calculate volume

	dResult
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	dResult = dResult * dResult * dResult * M_PI / 6;
    }

    //- else (cylindrical)

    else
    {
	//- if dia and length found

	double dDia
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	double dLength
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "LENGTH");

	if (dDia != DBL_MAX && dLength != FLT_MAX)
	{
	    //- calculate volume

	    dResult =  M_PI * dDia * dDia * dLength / 4;
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegment segment to init
/// 
/// \return void
/// 
/// \brief init segment
/// 

void SegmentInit(struct symtab_Segment *psegment)
{
    //- initialize base symbol

    SegmenterInit(&psegment->segr);

    //- set type

    psegment->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_segment;
}


/// 
/// \arg psegment segment to reduce.
/// \arg ppist context of segment.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a segment.
///
/// \details Reduces:
///
///	LENGTH		0.0 sets spherical option.
///	CM		check for GENESIS2 (unscaling).
///	RM		check for GENESIS2 (unscaling).
///	RA		check for GENESIS2 (unscaling).
///	SURFACE		compare with surface calculated from length and dia.
/// 

int
SegmentReduce
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    {
	//- get LENGTH parameter

	struct symtab_Parameters *pparLength
	    = SymbolGetParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "LENGTH");

	//- if has GENESIS2 function

	if (pparLength
	    && ParameterIsNumber(pparLength)
	    && ParameterValue(pparLength) == 0)
	{
	    //- remove length parameter

	    ParContainerDelete(psegment->segr.bio.pparc, pparLength);

/* 	    //- mark segment as spherical */

/* 	    SymbolSetOptions(&psegment->segr.bio.ioh.iol.hsle, FLAG_SEGMENTER_SPHERICAL); */
	}
    }

    {
	//- get CM parameter

	struct symtab_Parameters *pparCM
	    = SymbolGetParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "CM");

	//- if has GENESIS2 function

	if (pparCM
	    && ParameterIsFunction(pparCM)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparCM)), "GENESIS2") == 0)
	{
	    //- remove CM parameter

	    ParContainerDelete(psegment->segr.bio.pparc, pparCM);

	    //- get scaled capacitance

	    double dCMScaled = ParameterResolveScaledValue(pparCM, ppist);

	    //- get surface

	    double dSurface = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "SURFACE");

	    //- unscale capacitance to surface of segment

	    double dCMUnscaled = dCMScaled / dSurface;

	    //- set this as CM

	    SymbolSetParameterDouble(&psegment->segr.bio.ioh.iol.hsle, "CM", dCMUnscaled);
	    
	}
    }

    {
	//- get RM parameter

	struct symtab_Parameters *pparRM
	    = SymbolGetParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "RM");

	//- if has GENESIS2 function

	if (pparRM
	    && ParameterIsFunction(pparRM)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparRM)), "GENESIS2") == 0)
	{
	    //- remove RM parameter

	    ParContainerDelete(psegment->segr.bio.pparc, pparRM);

	    //- get scaled resistance

	    double dRMScaled = ParameterResolveScaledValue(pparRM, ppist);

	    //- get surface

	    double dSurface = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "SURFACE");

	    //- unscale resistance to surface of segment

	    double dRMUnscaled = dRMScaled * dSurface;

	    //- set this as RM

	    SymbolSetParameterDouble(&psegment->segr.bio.ioh.iol.hsle, "RM", dRMUnscaled);

	}
    }

    {
	//- get RA parameter

	struct symtab_Parameters *pparRA
	    = SymbolGetParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "RA");

	//- if has GENESIS2 function

	if (pparRA
	    && ParameterIsFunction(pparRA)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparRA)), "GENESIS2") == 0)
	{
	    //- remove RA parameter

	    ParContainerDelete(psegment->segr.bio.pparc, pparRA);

	    //- get scaled resistance

	    double dRAScaled = ParameterResolveScaledValue(pparRA, ppist);

	    //- get length and dia

	    double dLength = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "LENGTH");

	    double dDia = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	    //- unscale resistance to length and dia of segment

	    double dRAUnscaled = DBL_MAX;

	    if (SegmenterIsSpherical(&psegment->segr, ppist))
	    {
		/* Thinking of the 'one-dimensional' cable resistance of a 
		** sphere is a bit of a challenge...  As an approximation we
		** choose here the Ra of an equivalent cylinder C with the same
		** surface and volume as the sphere S: 
		**  lenC = 3/2 diaS  and  diaC = 2/3 diaS
		*/

		dRAUnscaled = dRAScaled / 13.50 * (dDia * M_PI);
	    }
	    else
	    {
		dRAUnscaled = dRAScaled / 4.0 / dLength * (dDia * dDia * M_PI);
	    }

	    //- set this as RA

	    SymbolSetParameterDouble(&psegment->segr.bio.ioh.iol.hsle, "RA", dRAUnscaled);

	}
    }

    {
	/// accuracy constant

	static double dGeoRoundOff = 0.00001;

/* #define MMGParmEQzero(d)				(int)( fabs(d) <= (dGeoRoundOff) ) */
#define MMGParmEQ(d1, d2)				(int)( /* (MMGParmEQzero((d1))  && MMGParmEQzero((d2))) || */ fabs((d1) - (d2)) <= ((dGeoRoundOff) * fabs((d2))) )

	//- get SURFACE parameter

	struct symtab_Parameters *pparSurface
	    = SymbolGetParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "SURFACE");

	double dSurface = ParameterResolveValue(pparSurface, ppist);

	//- if present

	if (dSurface != DBL_MAX)
	{
	    //- if spherical

	    if (SegmenterIsSpherical(&psegment->segr, ppist))
	    {
		//- get length and dia

		double dDia = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

		if (dDia != DBL_MAX)
		{
		    //- if surface matches with spherical surface

		    double d = dDia * dDia * M_PI;

		    if (MMGParmEQ(dSurface, d))
		    {
			//- remove SURFACE parameter

			ParContainerDelete(psegment->segr.bio.pparc, pparSurface);
		    }
		}
	    }

	    //- if cylindrical

	    else
	    {
		//- get length and dia

		double dLength = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "LENGTH");

		double dDia = SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

		if (dLength != DBL_MAX
		    && dDia != DBL_MAX)
		{
		    //- if surface matches with cylindrical surface

		    double d = M_PI * dDia * dLength;

		    if (MMGParmEQ(dSurface, d))
		    {
			//- remove SURFACE parameter

			ParContainerDelete(psegment->segr.bio.pparc, pparSurface);
		    }
		}
	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&psegment->segr.bio, ppist);

    //- return result

    return(iResult);
}


