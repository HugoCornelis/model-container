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

#include "neurospaces/segment.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


//f static functions

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

static
double
SegmentGetSurface
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetTau
(struct symtab_Segment *psegment, struct PidinStack *ppist);

static
double
SegmentGetVolume
(struct symtab_Segment *psegment, struct PidinStack *ppist);


/// **************************************************************************
///
/// SHORT: SegmentCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Segment * 
///
///	Newly allocated segment, NULL for failure
///
/// DESCR: Allocate a new segment symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: SegmentCreateAlias()
///
/// ARGS.:
///
///	psegment.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
SegmentCreateAlias
(struct symtab_Segment *psegment,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Segment *psegmentResult = SegmentCalloc();

    //- set name and prototype

    SymbolSetName(&psegmentResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&psegmentResult->segr.bio.ioh.iol.hsle, &psegment->segr.bio.ioh.iol.hsle);

    //- set options

    SymbolSetOptions(&psegmentResult->segr.bio.ioh.iol.hsle, SymbolGetOptions(&psegment->segr.bio.ioh.iol.hsle));

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_segment);

    //- return result

    return(&psegmentResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: SegmentGetBranchpointFlag()
///
/// ARGS.:
///
///	psegment.: segment to get length for.
///	ppist....: context of segment.
///
/// RTN..: double
///
///	1, 2, 3 ... if this is a branch point, 0 if not, FLT_MAX if unknown.
///
/// DESCR: Get branch point flag of this segment.
///
/// **************************************************************************

static
double
SegmentGetBranchpointFlag
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result: failure

    double dResult = FLT_MAX;

    //- get segmenter base symbol

    struct symtab_Parameters *pparBase
	= SymbolFindParameter(&psegment->segr.bio.ioh.iol.hsle, ppist, "SEGMENTER_BASE");

    if (pparBase)
    {
	struct PidinStack *ppistBase
	    = ParameterResolveToPidinStack(pparBase, ppist);

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
		//! not found, this is an internal error

		fprintf
		    (stderr,
		     "internal error: SegmenterLinearize() was used to obtain the branchpoint flag on a segment that does not belong to its own container\n");

		dResult = FLT_MAX;
	    }
	}

	//- free allocated memory

	PidinStackFree(ppistBase);

    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: SegmentGetLength()
///
/// ARGS.:
///
///	psegment.: segment to get length for.
///	ppist....: context of segment.
///
/// RTN..: double : segment length, FLT_MAX for failure.
///
/// DESCR: Get length of segment.
///
/// NOTE.:
///
///	This function assumes relative to the somatopetal neighbour
///	coordinates for all segments.  See also notes on that in
///	parser.rules.
///
/// TODO.: 
///
///	To change the note mentioned above : use ppist and ->pidinSomatopetal
///	to go to somatopetal neighbour and get its coordinates, subtract to get relative
///	coordinates.  Since ->pidinSomatopetal is relative to the
///	parent symbol, ppist must first be popped.  This should be
///	changed, with changes in the description files too.  See also
///	relevant note in the genesis implementation,
///	cellsolver_getsegments().
///
/// **************************************************************************

static
double
SegmentGetLength
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- get coordinates

    double dX
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_X");
    double dY
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_Y");
    double dZ
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "rel_Z");

    if (dX != FLT_MAX
	&& dY != FLT_MAX
	&& dZ != FLT_MAX)
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


/// **************************************************************************
///
/// SHORT: SegmentGetParameter()
///
/// ARGS.:
///
///	psegment..: symbol to get parameter for
///	ppist.....: context of symbol.
///	pcName....: name of parameter
///
/// RTN..: struct symtab_Parameters *
///
///	Parameter structure, NULL for failure.
///
/// DESCR: Get specific parameter of symbol.
///
/// **************************************************************************

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
	}

	//- if length

	else if (0 == strcmp(pcName, "LENGTH"))
	{
	    //- calculate length

	    double dLength = SegmentGetLength(psegment, ppist);

	    if (dLength != FLT_MAX)
	    {
		//- set length of segment

		pparResult
		    = SymbolSetParameterDouble
		      (&psegment->segr.bio.ioh.iol.hsle, "LENGTH", dLength);
	    }
	}

	//- if time constant

	else if (0 == strcmp(pcName, "TAU"))
	{
	    //- calculate time constant

	    double dTau = SegmentGetTau(psegment, ppist);

/* 	    //- allocate new parameter for give name,value */

/* 	    pparResult = ParameterNewFromNumber(pcName, dTau); */

	    if (dTau != FLT_MAX)
	    {
		//- set length of segment

		pparResult
		    = SymbolSetParameterDouble
		      (&psegment->segr.bio.ioh.iol.hsle, "TAU", dTau);
	    }
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: SegmentGetSomatopetalBranchpoints()
///
/// ARGS.:
///
///	psegment.: segment to get somatopetal branchpoints for.
///	ppist....: context of segment.
///
/// RTN..: double : segment somatopetal branchpoints, FLT_MAX for failure.
///
/// DESCR: get somatopetal branchpoints of segment.
///
/// **************************************************************************

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
	    //! should we add the soma branch point flag to ?

	    //- done, break loop

	    break;
	}

	//- add branch point flag of this symbol

	double dBranchpoint = SymbolParameterResolveValue(phsle, ppistWorking, "BRANCHPOINT");

	if (dBranchpoint == FLT_MAX)
	{
	    dResult = FLT_MAX;

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

	    if (dParentBranchPoints != FLT_MAX)
	    {
		dResult += dParentBranchPoints;
	    }
	    else
	    {
		dResult = FLT_MAX;
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


/// **************************************************************************
///
/// SHORT: SegmentGetSomatopetalDistance()
///
/// ARGS.:
///
///	psegment.: segment to get somatopetal distance for.
///	ppist....: context of segment.
///
/// RTN..: double : segment somatopetal distance, FLT_MAX for failure.
///
/// DESCR: get somatopetal distance of segment.
///
/// **************************************************************************

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

	if (dLength == FLT_MAX)
	{
	    dResult = FLT_MAX;

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

		dResult = FLT_MAX;

		break;
	    }

	    PidinStackFree(ppistWorking);

	    ppistWorking = ppistParent;

	    //- add somatopetal distance of the parent

	    double dParentDistance = SymbolParameterResolveValue(phsle, ppistWorking, "SOMATOPETAL_DISTANCE");

	    if (dParentDistance != FLT_MAX)
	    {
		dResult += dParentDistance;
	    }
	    else
	    {
		dResult = FLT_MAX;
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


/// **************************************************************************
///
/// SHORT: SegmentGetSurface()
///
/// ARGS.:
///
///	psegment.: segment to get surface for.
///	ppist....: context of segment.
///
/// RTN..: double : segment surface, FLT_MAX for failure.
///
/// DESCR: get surface of segment.
///
/// **************************************************************************

static
double
SegmentGetSurface
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- if spherical segment

    //! this must be a single segment, not a segmenter

    //t but the cast should not be here, there is a mismatch in the
    //t derivation hierarchy here.

    if (SegmenterIsSpherical((struct symtab_Segmenter *)psegment))
    {
	//- calculate surface

	dResult
	    = SymbolParameterResolveValue
	      (&psegment->segr.bio.ioh.iol.hsle, ppist, "DIA");

	if (dResult != FLT_MAX)
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

	if (dDia != FLT_MAX && dLength != FLT_MAX)
	{
	    //- calculate surface

	    dResult =  M_PI * dDia * dLength;
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: SegmentGetTau()
///
/// ARGS.:
///
///	psegment.: segment to get time constant for.
///	ppist....: context of segment.
///
/// RTN..: double : segment time constant, FLT_MAX for failure.
///
/// DESCR: Get time constant of segment.
///
/// **************************************************************************

static
double
SegmentGetTau
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- get capacitance and resistance

    //! note that it does not matter if we use specific or actual values

    double dCm
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "CM");
    double dRm
	= SymbolParameterResolveValue(&psegment->segr.bio.ioh.iol.hsle, ppist, "RM");

    if (dCm != FLT_MAX
	&& dRm != FLT_MAX)
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


/// **************************************************************************
///
/// SHORT: SegmentGetVolume()
///
/// ARGS.:
///
///	psegment.: segment to get volume for.
///	ppist....: context of segment.
///
/// RTN..: double : segment volume, FLT_MAX for failure.
///
/// DESCR: get volume of segment.
///
/// **************************************************************************

static
double
SegmentGetVolume
(struct symtab_Segment *psegment, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- if spherical segment

    //! this must be a single segment, not a segmenter

    //t but the cast should not be here, there is a mismatch in the
    //t derivation hierarchy here.

    if (SegmenterIsSpherical((struct symtab_Segmenter *)psegment))
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

	if (dDia != FLT_MAX && dLength != FLT_MAX)
	{
	    //- calculate volume

	    dResult =  M_PI * dDia * dDia * dLength / 4;
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: SegmentInit()
///
/// ARGS.:
///
///	psegment.: segment to init
///
/// RTN..: void
///
/// DESCR: init segment
///
/// **************************************************************************

void SegmentInit(struct symtab_Segment *psegment)
{
    //- initialize base symbol

    SegmenterInit(&psegment->segr);

    //- set type

    psegment->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_segment;
}


