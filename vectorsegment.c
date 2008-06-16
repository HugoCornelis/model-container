//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorsegment.c 1.35 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/segment.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/vectorsegment.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: VSegmentRelative2Absolute()
///
/// ARGS.:
///
///	pvsegm.: vector to init.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR:
///
///	Convert relative coordinates in a vector of segments to
///	absolute coordinates by accounting for coordinates of parent
///	segments.  Of course, this procedure does not convert absolute
///	Neurospaces coordinates.  See differences between relative and
///	absolute coordinates in a Genesis .p file.
///
/// NOTE:
///
///	This procedure will only work if the parent segments are being
///	processed before their children.  This order currently comes
///	directly from the description file.
///
/// **************************************************************************

struct VSegmentRelative2Absolute_data
{
    //m base symbol

    struct symtab_HSolveListElement *phsleBase;

    //m number of entries in base context

    int iEntries;
};


static
int
VSegmentSegmentRelocatorAbsolute
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : success

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment vector

    struct VSegmentRelative2Absolute_data *pvrad
	= (struct VSegmentRelative2Absolute_data *)pvUserdata;

    struct symtab_VSegment *pvsegm
	= (struct symtab_VSegment *)pvrad->phsleBase;

    int iEntries = pvrad->iEntries;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    struct PidinStack *ppist = ptstr->ppist;

    //- if this segment has a named parent segment

    struct symtab_Parameters *pparParent
	= SymbolGetParameter(phsle, "PARENT", ppist);

    if (pparParent)
    {
/* 	//- if parent symbol exists */

/* 	struct symtab_HSolveListElement *phsleParent */
/* 	    = ParameterResolveSymbol(pparParent, ppist); */

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar
	    = ParameterResolveToPidinStack(pparParent,ppist);

	if (ppistPar)
	{
	    //- if parent symbol exists

	    struct symtab_HSolveListElement *phsleParent = NULL;

	    if (iEntries < PidinStackNumberOfEntries(ppistPar))
	    {
		phsleParent
		    = SymbolLookupHierarchical
		      (&pvsegm->vect.bio.ioh.iol.hsle, ppistPar, iEntries, 1);
	    }

	    if (phsleParent)
	    {
		//- get coordinates of parent

		double dParentX = FLT_MAX;

		struct symtab_Parameters *pparParentX
		    = SymbolGetParameter(phsleParent, "X", ppist);

		if (pparParentX)
		{
		    dParentX = ParameterResolveValue(pparParentX,ppist);
		}

		double dParentY = FLT_MAX;

		struct symtab_Parameters *pparParentY
		    = SymbolGetParameter(phsleParent, "Y", ppist);

		if (pparParentY)
		{
		    dParentY = ParameterResolveValue(pparParentY,ppist);
		}

		double dParentZ = FLT_MAX;

		struct symtab_Parameters *pparParentZ
		    = SymbolGetParameter(phsleParent, "Z", ppist);

		if (pparParentZ)
		{
		    dParentZ = ParameterResolveValue(pparParentZ,ppist);
		}

		//- get relative coordinates of this symbol

		struct symtab_Parameters *pparXRel
		    = SymbolGetParameter(phsle, "rel_X", ppist);

		struct symtab_Parameters *pparYRel
		    = SymbolGetParameter(phsle, "rel_Y", ppist);

		struct symtab_Parameters *pparZRel
		    = SymbolGetParameter(phsle, "rel_Z", ppist);

		struct symtab_Parameters *pparX
		    = SymbolGetModifiableParameter(phsle, "X", ppist);

		struct symtab_Parameters *pparY
		    = SymbolGetModifiableParameter(phsle, "Y", ppist);

		struct symtab_Parameters *pparZ
		    = SymbolGetModifiableParameter(phsle, "Z", ppist);

		//- add coordinates

		if (pparXRel)
		{
		    double dx = ParameterValue(pparXRel);

		    dx += dParentX;

		    ParameterSetNumber(pparX, dx);
		}

		if (pparYRel)
		{
		    double dy = ParameterValue(pparYRel);

		    dy += dParentY;

		    ParameterSetNumber(pparY, dy);
		}

		if (pparZRel)
		{
		    double dz = ParameterValue(pparZRel);

		    dz += dParentZ;

		    ParameterSetNumber(pparZ, dz);
		}
	    }

	    //- free allocated memory

	    PidinStackFree(ppistPar);
	}
	else
	{
	    //! not sure if this is ok.

	    fprintf(stderr, "Warning: cannot find parent symbols in VSegmentSegmentRelocatorAbsolute()\n");
	}
    }

    //- return result

    return(iResult);
}


int VSegmentRelative2Absolute(struct symtab_VSegment *pvsegm, struct PidinStack *ppist)
{
    //- set default result : success

    int iResult = 1;

    struct VSegmentRelative2Absolute_data vrad =
    {
	//m base symbol

	&pvsegm->vect.bio.ioh.iol.hsle,

	//m number of entries in base context

	PidinStackNumberOfEntries(ppist),
    };


    //- traverse segments, convert to absolute

    iResult
	= VSegmentTraverseSegments
	  (&pvsegm->vect.bio.ioh.iol.hsle,
	   ppist,
	   VSegmentSegmentRelocatorAbsolute,
	   NULL,
	   &vrad);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: VSegmentCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_VSegment * 
///
///	Newly allocated vector, NULL for failure
///
/// DESCR: Allocate a new vector symbol table element
///
/// **************************************************************************

struct symtab_VSegment * VSegmentCalloc(void)
{
    //- set default result : failure

    struct symtab_VSegment *pvsegmResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/v_segment_vtable.c"

    //- allocate vector

    pvsegmResult
	= (struct symtab_VSegment *)
	  SymbolCalloc(1, sizeof(struct symtab_VSegment), _vtable_v_segment, HIERARCHY_TYPE_symbols_v_segment);

    //- initialize vector

    VSegmentInit(pvsegmResult);

    //- return result

    return(pvsegmResult);
}


/// **************************************************************************
///
/// SHORT: VSegmentCountSegments()
///
/// ARGS.:
///
///	pcell.: vector to count segments for
///
/// RTN..: int : number of segments in vector, -1 for failure
///
/// DESCR: count segments in vector
///
/// **************************************************************************

static int 
VSegmentSegmentCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment counter

    int *piSegments = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if segment

    if (instanceof_segment(phsle))
    {
	//- add to counted segments

	(*piSegments)++;
    }

    //- return result

    return(iResult);
}

int VSegmentCountSegments
(struct symtab_VSegment *pvsegm,
 struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse cell symbol, counting segments

    if (VSegmentTraverseSegments
	(&pvsegm->vect.bio.ioh.iol.hsle,
	 ppist,
	 VSegmentSegmentCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: VSegmentCreateAlias()
///
/// ARGS.:
///
///	pvsegm.: symbol to alias.
///	pidin.: name of new symbol.
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol.
///
/// DESCR: Create alias to given symbol.
///
/// **************************************************************************

struct symtab_HSolveListElement * 
VSegmentCreateAlias
(struct symtab_VSegment *pvsegm,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_VSegment *pvsegmResult = VSegmentCalloc();

    //- set name and prototype

    SymbolSetName(&pvsegmResult->vect.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pvsegmResult->vect.bio.ioh.iol.hsle, &pvsegm->vect.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_v_segment);

    //- return result

    return(&pvsegmResult->vect.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: VSegmentInit()
///
/// ARGS.:
///
///	pvsegm.: vector to init.
///
/// RTN..: void.
///
/// DESCR: init vector.
///
/// **************************************************************************

void VSegmentInit(struct symtab_VSegment *pvsegm)
{
    //- initialize base symbol

    VectorInit(&pvsegm->vect);

    //- set type

    pvsegm->vect.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_v_segment;
}


/// **************************************************************************
///
/// SHORT: VSegmentTraverseSegments()
///
/// ARGS.:
///
///	phsle.......: vector to traverse segments for
///	ppist.......: context of cell, cell assumed to be on top
///	pfProcesor..: segment processor
///	pfFinalizer.: segment finalizer
///	pvUserdata..: any user data
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse segments, call pfProcessor on each of them
///
/// **************************************************************************

static int 
VSegmentSegmentSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if below segment level

    if (InstanceOfMechanism(phsle))
    {
	//- do not process, continue with siblings

	iResult = TSTR_SELECTOR_PROCESS_SIBLING;
    }

    //- else if non-segment

    else if (!instanceof_segment(phsle))
    {
	//- do not process but continue with children

	iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;
    }

    //- return result

    return(iResult);
}


int VSegmentTraverseSegments
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init cell treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   VSegmentSegmentSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse cell symbol

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


