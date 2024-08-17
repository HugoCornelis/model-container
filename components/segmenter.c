//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: segmenter.c 1.49 Sat, 17 Nov 2007 22:17:06 -0600 hugo $
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


#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "neurospaces/components/attachment.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/root.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"

#include "neurospaces/symbolvirtual_protos.h"


static
double
SegmenterGetTotalLength
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

static
double
SegmenterGetTotalSurface
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

static
double
SegmenterGetTotalVolume
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);


/// 
/// \return struct symtab_Segmenter * 
/// 
///	Newly allocated segmenter, NULL for failure
/// 
/// \brief Allocate a new segmenter symbol table element
/// 

struct symtab_Segmenter * SegmenterCalloc(void)
{
    //- set default result : failure

    struct symtab_Segmenter *psegrResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/segmenter_vtable.c"

    //- allocate segmenter

    psegrResult
	= (struct symtab_Segmenter *)
	  SymbolCalloc(1, sizeof(struct symtab_Segmenter), _vtable_segmenter, HIERARCHY_TYPE_symbols_segmenter);

    //- initialize segmenter

    SegmenterInit(psegrResult);

    //- return result

    return(psegrResult);
}


/// 
/// \arg psegr segmenter to count segments for
/// 
/// \return int : number of segments in segmenter, -1 for failure
/// 
/// \brief count segments in segmenter
/// 

static
int 
SegmenterSegmentCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment counter

    int *piSegments = (int *)pvUserdata;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

    //- if segment

    int iType = TstrGetActualType(ptstr);

    if (subsetof_segment(iType))
    {
	//- add to counted segments

	(*piSegments)++;
    }

    //- return result

    return(iResult);
}

int
SegmenterCountSegments
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse segmenter symbol, counting segments

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterSegmentCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segmenter to count spike generators for
/// \arg ppist context, segmenter on top
/// 
/// \return int : number of spike generators in segmenter, -1 for failure
/// 
/// \brief count spike generators in segmenter
/// 

static
int 
SegmenterSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    int *piSpikeGens = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike generator

    int iType = TstrGetActualType(ptstr);

    if (subsetof_attachment(iType)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted segments

	(*piSpikeGens)++;
    }

    //- return result

    return(iResult);
}

int SegmenterCountSpikeGenerators
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse segment symbol, counting spike generators

    if (SymbolTraverseSpikeGenerators
	(&psegr->bio.ioh.iol.hsle, ppist, SegmenterSpikeGeneratorCounter, NULL, (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg psegr symbol to get parameter for.
/// \arg ppist context of symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol.
/// 

struct symtab_Parameters * 
SegmenterGetParameter
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&psegr->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if total length

	if (0 == strcmp(pcName, "TOTALLENGTH"))
	{
	    //- get length

	    double dLength = SegmenterGetTotalLength(psegr, ppist);

	    //- set length of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegr->bio.ioh.iol.hsle, "TOTALLENGTH", dLength);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if total surface

	else if (0 == strcmp(pcName, "TOTALSURFACE"))
	{
	    //- get surface

	    double dSurface = SegmenterGetTotalSurface(psegr, ppist);

	    //- set surface of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegr->bio.ioh.iol.hsle, "TOTALSURFACE", dSurface);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if total volume

	else if (0 == strcmp(pcName, "TOTALVOLUME"))
	{
	    //- get volume

	    double dVolume = SegmenterGetTotalVolume(psegr, ppist);

	    //- set volume of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&psegr->bio.ioh.iol.hsle, "TOTALVOLUME", dVolume);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

    }

    //- return result

    return(pparResult);
}


/// 
/// \arg psegr segment to get length for.
/// \arg ppist context of segment.
/// 
/// \return double : segment length, DBL_MAX for failure.
/// 
/// \brief get total length of segmenter.
/// 

static
int 
SegmenterLengthCalculator
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to total length

    double *pdTotalLength = (double *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get length

    double dLength = SymbolParameterResolveValue(phsle, ptstr->ppist, "LENGTH");

    if (dLength != DBL_MAX)
    {
	*pdTotalLength += dLength;
    }

    //- return result

    return(iResult);
}

static
double
SegmenterGetTotalLength
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : 0

    double dResult = 0.0;

    //- traverse segments and computer length

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterLengthCalculator,
	 NULL,
	 (void *)&dResult)
	== FALSE)
    {
	dResult = DBL_MAX;
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegr segment to get surface for.
/// \arg ppist context of segment.
/// 
/// \return double : segment surface, DBL_MAX for failure.
/// 
/// \brief get total surface of segmenter.
/// 

static
int 
SegmenterSurfaceCalculator
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to total surface

    double *pdTotalSurface = (double *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get surface

    double dSurface = SymbolParameterResolveValue(phsle, ptstr->ppist, "SURFACE");

    if (dSurface != DBL_MAX)
    {
	*pdTotalSurface += dSurface;
    }

    //- return result

    return(iResult);
}

static
double
SegmenterGetTotalSurface
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : 0

    double dResult = 0.0;

    //- traverse segments and computer surface

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterSurfaceCalculator,
	 NULL,
	 (void *)&dResult)
	== FALSE)
    {
	dResult = DBL_MAX;
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegr segment to get volume for.
/// \arg ppist context of segment.
/// 
/// \return double : segment volume, DBL_MAX for failure.
/// 
/// \brief get total volume of segmenter.
/// 

static
int 
SegmenterVolumeCalculator
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to total volume

    double *pdTotalVolume = (double *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get volume

    double dVolume = SymbolParameterResolveValue(phsle, ptstr->ppist, "VOLUME");

    if (dVolume != DBL_MAX)
    {
	*pdTotalVolume += dVolume;
    }

    //- return result

    return(iResult);
}

static
double
SegmenterGetTotalVolume
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : 0

    double dResult = 0.0;

    //- traverse segments and computer volume

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterVolumeCalculator,
	 NULL,
	 (void *)&dResult)
	== FALSE)
    {
	dResult = DBL_MAX;
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegr segmenter to init
/// 
/// \return void
/// 
/// \brief init segmenter
/// 

void SegmenterInit(struct symtab_Segmenter *psegr)
{
    //- set: no segments linearized

    psegr->desegmenter.iSegments = -1;

    //- set: not known how many segments without parents

    psegr->desegmenter.iNoParents = -1;

    //- set: not known how many tips there are

    psegr->desegmenter.iTips = -1;

    //- initialize base symbol

    BioComponentInit(&psegr->bio);

    //- set type

    psegr->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_segmenter;
}


/// 
/// \arg psegr segmenter to traverse segments for
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// 
/// \return int
/// 
///	TRUE if spherical.
/// 
/// \brief Check if a segmenter is spherical.
/// 

int SegmenterIsSpherical(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result: cylindrical

    int iResult = 0;

    //- if the has no length

    double dLength = SymbolParameterResolveValue(&psegr->bio.ioh.iol.hsle, ppist, "LENGTH");

    if (dLength == 0.0
	|| dLength == DBL_MAX)
    {
	//- is spherical

	iResult = 1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segmenter to traverse segments for
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Linearize the segments of the segmenter.
///
/// \details 
/// 
///	If the linearization has already been done, return success.
/// 
///	See also ... building indices using the linearized segment
///	arrays.
/// 

static
int 
SegmenterSegmentLinearizer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment counter

    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if segment

    int iType = TstrGetActualType(ptstr);

    if (subsetof_segment(iType))
    {
	//- get cable structure to fill in

	struct cable_structure *pcs
	    = &psegr->desegmenter.pcs[psegr->desegmenter.iSegments];

	/// initialize what we don't know

	pcs->iParentIndex = -1;

	//- fill in serial

	/// \note note: always use absolute serials,
	/// \note ie. PidinStackLookupTopSymbol(), not
	/// \note TstrGetPrincipalSerial().

	PidinStackLookupTopSymbol(ptstr->ppist);

	pcs->iSerial = PidinStackToSerial(ptstr->ppist);

	//- lookup parent

	struct symtab_Parameters *pparParent
	    = SymbolFindParameter(phsle, ptstr->ppist, "PARENT");

	if (pparParent)
	{
	    struct PidinStack *ppistParent
		= ParameterResolveToPidinStack(pparParent, ptstr->ppist);

	    if (ppistParent)
	    {
		PidinStackLookupTopSymbol(ppistParent);

		int iParent = PidinStackToSerial(ppistParent);

		/// \todo check for error

		if (iParent != INT_MAX)
		{
		    pcs->iParentSerial = iParent;
		}
		else
		{
		    /// \note parent does not exist

		    /// \note makes sense if the user wants to examine only a part of the tree

		    char pc[1000];

		    char pcParent[1000];

		    PidinStackString(ptstr->ppist, pc, 1000);

		    PidinStackString(ppistParent, pcParent, 1000);

		    fprintf(stderr, "warning: cannot find parent segment %s for segment %s\n", pcParent, pc);

		    pcs->iParentSerial = -1;

/* 		    free(psegr->desegmenter.pcs); */

/* 		    psegr->desegmenter.pcs = NULL; */

/* 		    iResult = TSTR_PROCESSOR_ABORT; */
		}
	    }
	    else
	    {
		/// \note parent does not exist

		/// \note makes sense if the user wants to examine only a part of the tree

		char pc[1000];

		char pcParent[1000];

		PidinStackString(ptstr->ppist, pc, 1000);

		PidinStackString(ppistParent, pcParent, 1000);

		fprintf(stderr, "warning: cannot find parent segment %s for segment %s\n", pcParent, pc);

		pcs->iParentSerial = -1;

/* 		free(psegr->desegmenter.pcs); */

/* 		psegr->desegmenter.pcs = NULL; */

/* 		iResult = TSTR_PROCESSOR_ABORT; */
	    }
	}
	else
	{
	    pcs->iParentSerial = -1;
	}

	//- increment number of segments found

	psegr->desegmenter.iSegments++;
    }

    //- return result

    return(iResult);
}

static int SegmenterSegmentLinker(struct symtab_Segmenter *psegr)
{
    //- set default result : ok

    int iResult = TRUE;

    //- default: no segments without parents

    psegr->desegmenter.iNoParents = 0;

    //- loop over all segments

    int iSegment;

    for (iSegment = 0 ; iSegment < psegr->desegmenter.iSegments ; iSegment++)
    {
	//- get current segment

	struct cable_structure *pcs = &psegr->desegmenter.pcs[iSegment];

	//- get parent serial

	int iParentSerial = pcs->iParentSerial;

	if (iParentSerial != -1)
	{
	    //- search all segments

	    int i;

	    for (i = 0 ; i < psegr->desegmenter.iSegments ; i++)
	    {
		//- get current segment

		struct cable_structure *pcsParent = &psegr->desegmenter.pcs[i];

		//- if is parent

		if (pcsParent->iSerial == iParentSerial)
		{
		    //- ok, stop searching loop

		    break;
		}
	    }

	    //- set current segment parent index

	    if (i < psegr->desegmenter.iSegments)
	    {
		pcs->iParentIndex = i;
	    }
	    else
	    {
		/// \note not found, this is an internal error

		fprintf
		    (stderr,
		     "internal error: parent segment %i found during traversal, but not during linking\n",
		     iParentSerial);
	    }
	}
	else
	{
	    /// \note no error, this is ok for populations, networks etc.
	    /// \note note that we are not compiling like heccer does.

	    psegr->desegmenter.iNoParents++;
	}
    }

    //- return result

    return(iResult);
}

static int SegmenterSegmentOffspringIndexer(struct symtab_Segmenter *psegr)
{
    //- set default result : ok

    int iResult = TRUE;

    //- default: no tips

    psegr->desegmenter.iTips = 0;

    //- get total number of segments

    int iSegments = psegr->desegmenter.iSegments;

    //- allocate structural analyzers

    unsigned int uSegments = iSegments;

    int *piChildren = (int *)calloc(uSegments, sizeof(int));

    int **ppiChildren = (int **)calloc(uSegments, sizeof(int *));

    //- analyze

    //- loop over all segments

    int i;

    for (i = 0; i < iSegments; i++)
    {
	//- set current segment

	struct cable_structure *pcs = &psegr->desegmenter.pcs[i];

	//- if segment has parent

	if (pcs->iParentIndex != -1)
	{
	    if (pcs->iParentIndex == i
		|| pcs->iParentIndex >= iSegments)
	    {
		/// \note the segment array does not describe a valid tree
		/// \note structure, but that is ok for networks and
		/// \note populations.
	    }

	    //- increment number of children for the parent segment

	    piChildren[pcs->iParentIndex] += 1;
	}
    }

    //- build indices for children

    //- i loop over all segments

    for (i = 0; i < iSegments; i++)
    {
	//- clear number of children for this segment

	int iChildren = 0;

	//- if segment has no children

	if (piChildren[i] == 0)
	{
	    //- it's a terminal branch

	    ppiChildren[i] = NULL;

	    //- increment number of tips

	    psegr->desegmenter.iTips++;
	}

	//- else

	else
	{
	    //- allocate for number of children

	    ppiChildren[i] = (int *)calloc(piChildren[i], sizeof(int));

	    //- j loop over all segments

	    int j;

	    for (j = 0; j < iSegments; j++)
	    {
		//- if parent of j segment is i segment

		if (psegr->desegmenter.pcs[j].iParentIndex == i)
		{
		    //- remember j as a children of i

		    ppiChildren[i][iChildren] = j;

		    //- increment number of children

		    iChildren++;
		}
	    }
	}
    }
	
    //- set children pointers

    psegr->desegmenter.piChildren = piChildren;
    psegr->desegmenter.ppiChildren = ppiChildren;

    //- return result

    return(iResult);
}

int
SegmenterLinearize
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result : ok

    int iResult = 1;

    if (psegr->desegmenter.iSegments != -1)
    {
	return(1);
    }

    //- count segments

    psegr->desegmenter.iSegments = SymbolCountSegments(&psegr->bio.ioh.iol.hsle, ppist);

    //- allocate

    psegr->desegmenter.pcs
	= (struct cable_structure *)calloc(psegr->desegmenter.iSegments, sizeof(struct cable_structure));

    if (!psegr->desegmenter.pcs)
    {
	psegr->desegmenter.iSegments = -1;

	return(0);
    }

    //- fill in the allocated arrays

    psegr->desegmenter.iSegments = 0;

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterSegmentLinearizer,
	 NULL,
	 (void *)psegr)
	== FALSE)
    {
	psegr->desegmenter.iSegments = -1;

	free(psegr->desegmenter.pcs);

	iResult = 0;
    }

    //- link segments to parents

    iResult = iResult && SegmenterSegmentLinker(psegr);

    //- build offspring indices

    iResult = iResult && SegmenterSegmentOffspringIndexer(psegr);

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segmenter to mesh.
/// \arg ppist context of given element.
/// \arg dLength maximum length of a segment.
/// 
/// \return int
/// 
///	Number of generated segments, -1 for failure.
/// 
/// \brief Remesh a segmenter.
/// 

struct SegmenterMesherOnLength_data
{
    /// maximal length

    double dLength;

    /// processor result

    HSolveList hslAliasses;

    /// number of elements in result list

    int iAliasses;

    /// total number of segments created

    int iTotalSegments;

    /// original segments that have been resegmented, including their names

    int iSegmented;

    struct PidinStack **pppistSegmented;

    /// count for resegmented symbols

    int *piSegmentCount;

    /// pidinstack for result

    struct PidinStack *ppistResult;

    /// root symbol for result

    struct symtab_RootSymbol *prootResult;
};


static
int
SegmenterMesherOnLengthProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to info of interest

    struct SegmenterMesherOnLength_data *psmold
	= (struct SegmenterMesherOnLength_data *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if this is not a segment

    int iType = TstrGetActualType(ptstr);

    if (!subsetof_segment(iType))
    {
	//- set current context in result

	PidinStackPushSymbol(psmold->ppistResult, phsle /* Alias */);

	//- return success

	return(TSTR_PROCESSOR_SUCCESS);
    }

    //- so this is a segment of some sort

    //- get segment length

    double dLength = SymbolParameterResolveValue(phsle, ptstr->ppist, "LENGTH");

    if (dLength == DBL_MAX)
    {
	return(TSTR_PROCESSOR_ABORT);
    }

    //- get orientations

    double dX = SymbolParameterResolveValue(phsle, ptstr->ppist, "rel_X");
    double dY = SymbolParameterResolveValue(phsle, ptstr->ppist, "rel_Y");
    double dZ = SymbolParameterResolveValue(phsle, ptstr->ppist, "rel_Z");

    //- get DIA

    double dDia = SymbolParameterResolveValue(phsle, ptstr->ppist, "DIA");

    //- get parent DIA

    struct symtab_Parameters *pparParent
	= SymbolFindParameter(phsle, ptstr->ppist, "PARENT");

    if (!pparParent)
    {
	/// \note e.g. the soma, don't touch

	//- set current context in result

	PidinStackPushSymbol(psmold->ppistResult, phsle /* Alias */);

	//- return success

	return(TSTR_PROCESSOR_SUCCESS);
    }

    struct PidinStack *ppistParent
	= ParameterResolveToPidinStack(pparParent, ptstr->ppist);

    if (!ppistParent)
    {
	return(TSTR_PROCESSOR_ABORT);
    }

    struct symtab_HSolveListElement *phsleParent
	= PidinStackLookupTopSymbol(ppistParent);

    if (!phsleParent)
    {
	char pc[1000];

	PidinStackString(ppistParent, pc, sizeof(pc[0]) * 1000);

	fprintf
	    (stderr,
	     "for segment %s, parent %s not found\n",
	     SymbolGetName(phsle),
	     pc);

	return(TSTR_PROCESSOR_ABORT);
    }

    double dDiaParent
	= SymbolParameterResolveValue(phsleParent, ppistParent, "DIA");

    //- if longer than requested maximum

    if (dLength > psmold->dLength)
    {
	//- determine number of replacements

	int iCount = ceil(dLength / psmold->dLength);

	/// \todo set count for this segment

	struct PidinStack *ppistSegment = PidinStackDuplicate(ptstr->ppist);

	psmold->pppistSegmented[psmold->iSegmented] = ppistSegment;

	psmold->piSegmentCount[psmold->iSegmented] = iCount;

	psmold->iSegmented++;

	//- create aliasses

	HSolveListInit(&psmold->hslAliasses);

	psmold->iAliasses = 0;

	int iAliassed
	    = BioComponentCreateAliasses
	      (&((struct symtab_Segment *)phsle)->segr.bio, iCount, &psmold->hslAliasses);

	if (!iAliassed)
	{
	    /// \todo free everything in hsl

	    return(TSTR_PROCESSOR_ABORT);
	}

	psmold->iAliasses = iCount;

	psmold->iTotalSegments += iCount;

	//- calculate derived parameters

	double dXIncrement = dX / iCount;
	double dYIncrement = dY / iCount;
	double dZIncrement = dZ / iCount;

	double dDiaIncrement = (dDia - dDiaParent) / iCount;

	//- loop over the created aliasses

	int iCounter = 0;

	struct symtab_HSolveListElement *phsleAlias
	    = (struct symtab_HSolveListElement *)HSolveListHead(&psmold->hslAliasses);

	while (HSolveListValidSucc(&phsleAlias->hsleLink))
	{
	    //- remove parameters LENGTH, SURFACE, VOLUME, TOTALSURFACE, DIA

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "LENGTH", DBL_MAX);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "SURFACE", DBL_MAX);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "VOLUME", DBL_MAX);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "TOTALSURFACE", DBL_MAX);

	    //- set new parameters rel_X, rel_Y, rel_Z, DIA

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "rel_X", dXIncrement);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "rel_Y", dYIncrement);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "rel_Z", dZIncrement);

	    BioComponentSetParameterDouble
		((struct symtab_BioComponent *)phsleAlias, "DIA", dDia + (dDiaIncrement * iCounter));

	    //- set parent parameter of new segments

	    /// \todo use PidinStackNewFromParameterSymbols() and PidinStackToPidinQueue() for this
	    /// \todo so probably I need PidinQueueNewFromParameterSymbols() ?

	    //- for the first alias in list

	    if (iCounter == 0)
	    {
		/// \todo inherits name from previous, but gets maximum count from previous
		/// \todo we need to keep a list of counts for each meshed segment

		//- lookup parent segment count

		int iParentCount = -1;

		int iLast = psmold->iSegmented - 1;

		int iCurrent;

		for (iCurrent = iLast ; iCurrent >= 0 ; iCurrent--)
		{
		    if (PidinStackEqual(ppistParent, psmold->pppistSegmented[iCurrent]))
		    {
			iParentCount = psmold->piSegmentCount[iCurrent];

			break;
		    }
		}

		char pc[1000];

		//- if not found

		if (iParentCount == -1)
		{
		    //- construct from the plain parent

		    sprintf(pc, "%s", SymbolGetName(phsleParent));
		}

		//- if found

		else
		{
		    //- construct name using parent segment count

		    /// \todo get a better identifier generation interface for this.

		    /// \todo perhaps using a varags constructor, args being strings ?

		    sprintf(pc, "%s_%i", SymbolGetName(phsleParent), iParentCount - 1);
		}

		char *pcName = calloc(1, 1 + strlen(pc));

		if (!pcName)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		strcpy(pcName, pc);

		struct symtab_IdentifierIndex *pidin2 = IdinNewFromChars(pcName);
		struct symtab_IdentifierIndex *pidin1 = IdinNewFromChars("..");

		if (pidin1 && pidin2)
		{
		    pidin1->pidinNext = pidin2;

		    pidin1->pidinRoot = pidin1;
		    pidin2->pidinRoot = pidin1;

		    //- allocate room for symbolic parameter

		    struct symtab_Parameters *pparParent
			= ParameterCalloc();

		    //- fill up structure

		    ParameterSetName(pparParent, "PARENT");

		    ParameterSetSymbolName(pparParent, pidin1->pidinRoot);

		    pparParent->pparFirst = pparParent;

		    BioComponentParameterLinkAtEnd
			((struct symtab_BioComponent *)phsleAlias, pparParent);
		}
		else
		{
		    free(pcName);

		    if (pidin1)
		    {
			free(pidin1);
		    }

		    if (pidin2)
		    {
			free(pidin2);
		    }

		    return(TSTR_PROCESSOR_ABORT);
		}
	    }

	    //- for the non-firsts in the alias list

	    else
	    {
		//- other ones are fixed here.

		/// \todo get a better identifier generation interface for this.

		/// \todo perhaps using a varags constructor, args being strings ?

		char pc[1000];

		sprintf(pc, "%s_%i", SymbolGetName(phsle), iCounter - 1);

		char *pcName = calloc(1, 1 + strlen(pc));

		if (!pcName)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		strcpy(pcName, pc);

		struct symtab_IdentifierIndex *pidin2 = IdinNewFromChars(pcName);
		struct symtab_IdentifierIndex *pidin1 = IdinNewFromChars("..");

		if (pidin1 && pidin2)
		{
		    pidin1->pidinNext = pidin2;

		    pidin1->pidinRoot = pidin1;
		    pidin2->pidinRoot = pidin1;

		    //- allocate room for symbolic parameter

		    struct symtab_Parameters *pparParent
			= ParameterCalloc();

		    //- fill up structure

		    ParameterSetName(pparParent, "PARENT");

		    ParameterSetSymbolName(pparParent, pidin1->pidinRoot);

		    pparParent->pparFirst = pparParent;

		    BioComponentParameterLinkAtEnd
			((struct symtab_BioComponent *)phsleAlias, pparParent);
		}
		else
		{
		    free(pcName);

		    if (pidin1)
		    {
			free(pidin1);
		    }

		    if (pidin2)
		    {
			free(pidin2);
		    }

		    return(TSTR_PROCESSOR_ABORT);
		}
	    }

	    //- go to next alias

	    iCounter++;

	    phsleAlias
		= (struct symtab_HSolveListElement *)
		  HSolveListNext(&phsleAlias->hsleLink);
	}

    }

    //- if aliasses were created

    if (psmold->iAliasses)
    {
	//- get current result element

	struct symtab_HSolveListElement *phsleCurrent
	    = PidinStackLookupTopSymbol(psmold->ppistResult);

	//- link aliasses into the list

	struct symtab_HSolveListElement *phsleAlias
	    = (struct symtab_HSolveListElement *)HSolveListHead(&psmold->hslAliasses);

	struct symtab_HSolveListElement *phsleAliasNext
	    = (struct symtab_HSolveListElement *)HSolveListNext(&phsleAlias->hsleLink);

	struct symtab_HSolveListElement *phsleAliasLast = NULL;

	while (HSolveListValidSucc(&phsleAlias->hsleLink))
	{
	    SymbolAddChild(phsleCurrent, phsleAlias);

	    //- go to next alias

	    phsleAliasLast = phsleAlias;

	    phsleAlias = phsleAliasNext;

	    if (HSolveListValidSucc(&phsleAliasNext->hsleLink))
	    {
		phsleAliasNext
		    = (struct symtab_HSolveListElement *)
		      HSolveListNext(&phsleAliasNext->hsleLink);
	    }
	}

	//- set current context in result: we assume the last create alias

	PidinStackPushSymbol(psmold->ppistResult, phsleAliasLast);

    }

    //- no aliasses created

    else
    {
	//- set current context in result

	PidinStackPushSymbol(psmold->ppistResult, phsle /* Alias */);

    }

    //- free allocated memory

    PidinStackFree(ppistParent);

    //- return result

    return (iResult);
}


static
int
SegmenterMesherOnLengthFinalizer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to info of interest

    struct SegmenterMesherOnLength_data *psmold
	= (struct SegmenterMesherOnLength_data *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- pop result context

    PidinStackPop(psmold->ppistResult);

    //- if aliasses have been created

    if (psmold->iAliasses)
    {
	//- insert the aliasses

	HSolveListElement *phsleFrom = HSolveListHead(&psmold->hslAliasses);

	HSolveListElement *phsleTo = HSolveListTail(&psmold->hslAliasses);

	/// \todo this one creates an infinite loop for /grouped_two_segments, meshing of main[0]_0 and main[0]_1

	HSolveListMergeWithSucc(phsleFrom, phsleTo, &phsle->hsleLink);

	//- remove the original from the original forestspace

	struct symtab_HSolveListElement *phsleParent
	    = TstrGetActualParent(ptstr);

	SymbolDeleteChild(phsleParent, phsle);

	//- reset alias counter

	psmold->iAliasses = 0;
    }

    //- return result

    return (iResult);
}


int
SegmenterMesherOnLength
(struct symtab_Segmenter *psegr, struct PidinStack *ppist, double dLength)
{
    //- set default result: failure

    int iResult = -1;

    //- construct info of interest

    struct SegmenterMesherOnLength_data smold =
    {
	/// maximal length

	dLength,

	/// processor result

	{
	    /// two joint nodes (one for head, one for tail)

	    /// pointer to head of list

	    NULL,

	    /// tail of list, always NULL

	    NULL,

	    /// last entry in list

	    NULL,
	},

	/// number of elements in result list

	0,

	/// total number of segments created

	0,

	/// original segments that have been resegmented, including their names

	0,

	NULL,

	/// count for resegmented symbols

	NULL,

	/// pidinstack for result

	NULL,

	/// root symbol for result

	NULL,
    };

    smold.ppistResult = PidinStackCalloc();

    smold.prootResult = RootSymbolCalloc();

    PidinStackPushSymbol(smold.ppistResult, &smold.prootResult->hsle);

    //- allocated for contexts of resegmented segments

    int iSegments
	= SymbolCountSegments(&psegr->bio.ioh.iol.hsle, ppist);

    smold.pppistSegmented
	= (struct PidinStack **)calloc(sizeof(struct PidinStack *), iSegments);

    smold.piSegmentCount
	= (int *)calloc(sizeof(int), iSegments);

    if (smold.pppistSegmented && smold.piSegmentCount)
    {
	//- resegment segment symbols

	struct TreespaceTraversal *ptstr
	    = TstrNew
	      (ppist,
	       NULL,
	       NULL,
	       SegmenterMesherOnLengthProcessor,
	       (void *)&smold,
	       SegmenterMesherOnLengthFinalizer,
	       (void *)&smold);

	//- traverse segment symbol

	iResult = TstrGo(ptstr, &psegr->bio.ioh.iol.hsle);

	//- delete treespace traversal

	TstrDelete(ptstr);

	if (iResult != 1)
	{
	    iResult = FALSE;
	}
    }

    //- free allocated memory

    RootSymbolFree(smold.prootResult);

    PidinStackFree(smold.ppistResult);

    if (smold.piSegmentCount)
    {
	free(smold.piSegmentCount);
    }

    if (smold.pppistSegmented)
    {
	int i;

	for (i = 0 ; i < smold.iSegmented ; i++)
	{
	    free(smold.pppistSegmented[i]);
	}

	free(smold.pppistSegmented);
    }

    //- recalculate serial ID's for affected symbols

    SymbolRecalcAllSerials(&psegr->bio.ioh.iol.hsle, ppist);

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segment to scale value for
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specify type of scaling
/// 
/// \return double : scaled value, DBL_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 

double
SegmenterParameterScaleValue
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = DBL_MAX;

    /// \note safety and robustness first

    if (dValue == DBL_MAX)
    {
	return(DBL_MAX);
    }

    //- get segment surface

    struct symtab_Parameters *pparSurface
	= SymbolFindParameter(&psegr->bio.ioh.iol.hsle, ppist, "SURFACE");

    double dSurface
	= pparSurface
	  ? ParameterResolveValue(pparSurface, ppist)
	  : DBL_MAX ;

    //- get segment length

    struct symtab_Parameters *pparLength
	= SymbolFindParameter(&psegr->bio.ioh.iol.hsle, ppist, "LENGTH");

    double dLength
	= pparLength
	  ? ParameterResolveValue(pparLength, ppist)
	  : DBL_MAX ;

    //- get segment diameter

    struct symtab_Parameters *pparDia
	= SymbolFindParameter(&psegr->bio.ioh.iol.hsle, ppist, "DIA");

    double dDia
	= pparDia
	  ? ParameterResolveValue(pparDia, ppist)
	  : DBL_MAX ;

    //- get channel parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if membrane resistance

    if (0 == strcmp(pcName, "RM"))
    {
	//- scale value : divide through surface

	if (dSurface != DBL_MAX)
	{
	    dResult = dValue / dSurface;
	}
	else
	{
	    return(DBL_MAX);
	}
    }

    //- else if membrane capacitance

    else if (0 == strcmp(pcName, "CM"))
    {
	//- scale value : multiply with surface

	if (dSurface != DBL_MAX)
	{
	    dResult = dValue * dSurface;
	}
	else
	{
	    return(DBL_MAX);
	}
    }

    //- else if segment axial resistance

    else if (0 == strcmp(pcName, "RA"))
    {
	//- if spherical

	if (SegmenterIsSpherical(psegr, ppist))
	{
	    /* Thinking of the 'one-dimensional' cable resistance of a 
	    ** sphere is a bit of a challenge...  As an approximation we
	    ** choose here the Ra of an equivalent cylinder C with the same
	    ** surface and volume as the sphere S: 
	    **  lenC = 3/2 diaS  and  diaC = 2/3 diaS
	    */

	    //- scale value

	    if (dDia != DBL_MAX)
	    {
		dResult = 13.50 * dValue / (dDia * M_PI);
	    }
	    else
	    {
		return(DBL_MAX);
	    }
	}

	//- else

	else
	{
	    //- scale value

	    if (dDia != DBL_MAX
		&& dLength != DBL_MAX)
	    {
		dResult = 4.0 * dValue * dLength / (dDia * dDia * M_PI);
	    }
	    else
	    {
		return(DBL_MAX);
	    }
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg psegr segmenter to check.
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// 
/// \return int
/// 
///	1 if segmenter has a tree structure, 0 otherwise.
/// 
/// \brief Check if a segmenter has a tree structure.
/// 

int
SegmenterParentCount
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    if (!PidinStackLookupTopSymbol(ppist))
    {
	fprintf(stderr, "cannot build context caches for %s, aborting\n", SymbolGetName(&psegr->bio.ioh.iol.hsle));

	return(0);
    }

    //- build linear caches and indices for the segmenter

    iResult = iResult && SegmenterLinearize(psegr, ppist);

    if (iResult)
    {
	struct cable_structure *pcs = &psegr->desegmenter.pcs[0];

	//- give header output

	fprintf
	    (stdout,
	     "---\nparent_count:\n  name: %s\n  value: %i\n",
	     SymbolGetName(&psegr->bio.ioh.iol.hsle),
	     psegr->desegmenter.iNoParents);
    }

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segmenter to set as base container.
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Set this segmenter as base for all the segments it contains.
/// 

static
int 
SegmenterBaseSetter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to work fixed context

    struct PidinStack *ppistFixed = (struct PidinStack *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if segment

    int iType = TstrGetActualType(ptstr);

    if (subsetof_segment(iType))
    {
	//- set parameter: segmenter base is the fixed context

	SymbolSetParameterContext(phsle, "SEGMENTER_BASE", ppistFixed);
    }

    //- return result

    return(iResult);
}

int
SegmenterSetBase
(struct symtab_Segmenter *psegr, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    //- get a fixed context

    struct PidinStack *ppistFixed
	= PidinStackDuplicate(ppist);

    if (PidinStackIsRooted(ppistFixed))
    {
	fprintf(stderr, "warning: using rooted context as segmentation base\n");
    }

    //- traverse segmenter symbol, counting segments

    if (SymbolTraverseSegments
	(&psegr->bio.ioh.iol.hsle,
	 ppist,
	 SegmenterBaseSetter,
	 NULL,
	 (void *)ppistFixed)
	== FALSE)
    {
	iResult = 0;
    }

    //- free allocated memory

    PidinStackFree(ppistFixed);

    //- return result

    return(iResult);
}


/// 
/// \arg psegr segmenter to get tips for.
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// \arg iSerials set to 1 if serials should be reported too?
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Print tips of the segmenter to stdout.
/// 

int
SegmenterTips
(struct symtab_Segmenter *psegr, struct PidinStack *ppist, int iSerials)
{
    //- set default result: ok

    int iResult = 1;

    if (!PidinStackLookupTopSymbol(ppist))
    {
	fprintf(stderr, "cannot build context caches for %s, aborting\n", SymbolGetName(&psegr->bio.ioh.iol.hsle));

	return(0);
    }

    //- build linear caches and indices for the segmenter

    iResult = iResult && SegmenterLinearize(psegr, ppist);

    if (!iResult)
    {
	fprintf(stderr, "cannot build segment linearization caches for %s, aborting\n", SymbolGetName(&psegr->bio.ioh.iol.hsle));

	return(0);
    }

    struct cable_structure *pcs = &psegr->desegmenter.pcs[0];

    //- give header output

    fprintf(stdout, "---\ntips:\n  name: %s\n", SymbolGetName(&psegr->bio.ioh.iol.hsle));

    //- loop over all segments in the cache

    fprintf(stdout, "  names:\n");

    int i;

    for (i = 0 ; i < psegr->desegmenter.iSegments ; i++)
    {
	//- if this segment has no children

	if (psegr->desegmenter.piChildren[i] == 0)
	{
	    //- get serial and context of the tip

	    struct cable_structure *pcsTip = &pcs[i];

	    int iTip = pcsTip->iSerial - PidinStackToSerial(ppist);

	    struct PidinStack *ppistTip
		= SymbolPrincipalSerial2Context(&psegr->bio.ioh.iol.hsle, ppist, iTip);

	    //- give output

	    char pc[1000];

	    PidinStackString(ppistTip, pc, 1000);

	    fprintf(stdout, "    - %s\n", pc);

	    //- free allocated memory

	    PidinStackFree(ppistTip);
	}
    }

    //- if serials requested

    if (iSerials)
    {
	//- loop over all segments in the cache

	fprintf(stdout, "  serials:\n");

	for (i = 0 ; i < psegr->desegmenter.iSegments ; i++)
	{
	    //- if this segment has no children

	    if (psegr->desegmenter.piChildren[i] == 0)
	    {
		//- get serial and context of the tip

		struct cable_structure *pcsTip = &pcs[i];

		int iTip = pcsTip->iSerial - PidinStackToSerial(ppist);

		//- give output

		fprintf(stdout, "    - %i\n", iTip);
	    }
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg phsle segmenter to traverse segments for
/// \arg ppist context of segmenter, segmenter assumed to be on top
/// \arg pfProcesor segment processor
/// \arg pfFinalizer segment finalizer
/// \arg pvUserdata any user data
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse segments, call pfProcessor on each of them
/// 

static int 
SegmenterSegmentSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if below segment level

    //t must be done with biolevels

    int iType = TstrGetActualType(ptstr);

    if (in_dimension_mechanism(phsle))
    {
	//- do not process, continue with siblings

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- else if non-segment

    else if (!subsetof_segment(iType))
    {
	//- do not process but continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


int
SegmenterTraverseSegments
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init segmenter treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SegmenterSegmentSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse segmenter symbol

    iResult = TstrGo(ptstr, &psegr->bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


