//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: traversalinfo.c 1.17 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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



#include <float.h>
#include <string.h>

#include "neurospaces/traversalinfo.h"


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: TraversalInfoCollect() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pti.: traversal info. */
/* /// */
/* /// RTN..: */
/* /// */
/* ///	int : see TstrTraverse(), memory failures is covered with */
/* ///	a immediate abort error return. */
/* /// */
/* /// DESCR: */
/* /// */
/* ///	Collect traversal info, as specified by pti. */
/* /// */
/* /// ************************************************************************** */

/* int */
/* TraversalInfoCollect */
/* (struct traversal_info *pti, struct symtab_HSolveListElement *phsle, struct PidinStack *ppist) */
/* { */
/*     //- init treespace traversal */

/*     struct TreespaceTraversal *ptstr */
/* 	= TstrNew */
/* 	  (ppist, */
/* 	   NULL, */
/* 	   NULL, */
/* 	   SymbolChildrenInfoCollectorProcessor, */
/* 	   (void *)&ci, */
/* 	   NULL, */
/* 	   NULL); */

/*     //- traverse symbol */

/*     int iResult = TstrTraverse(ptstr,phsle); */

/*     //- delete treespace traversal */

/*     TstrDelete(ptstr); */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: TraversalInfoCollectorProcessor()
///
/// ARGS.:
///
///	std. SymbolProcessor args.
///
/// RTN..: int : SymbolProcessor return value.
///
/// DESCR:
///
///	Collect information about traversed symbols, see
///	TRAVERSAL_INFO_* defines.
///
/// **************************************************************************

int 
TraversalInfoCollectorProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process sibling

    int iResult = TSTR_PROCESSOR_FAILURE;

    //- get actual symbol & type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- get traversal data

    struct traversal_info *pti
	= (struct traversal_info *)pvUserdata;

    //- if not allocated yet

    if (pti->iAllocated == 0)
    {
	//- allocate for 1000 symbols

	pti->piSerials = malloc(1000 * sizeof(int));

	pti->piTypes = malloc(1000 * sizeof(int));

	if (pti->iFlagsInfo & TRAVERSAL_INFO_CONTEXTS)
	{
	    pti->ppcContexts = malloc(1000 * sizeof(char *));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_NAMES)
	{
	    pti->ppcNames = malloc(1000 * sizeof(char *));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_TYPES)
	{
	    pti->ppcTypes = malloc(1000 * sizeof(char *));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_LOCAL)
	{
	    pti->ppD3CoordsLocal = malloc(1000 * sizeof(struct D3Position *));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE)
	{
	    pti->ppD3CoordsAbsolute = malloc(1000 * sizeof(struct D3Position *));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT)
	{
	    pti->ppD3CoordsAbsoluteParent = malloc(1000 * sizeof(struct D3Position *));

	    //! assume we are going to draw things

	    pti->pdDia = malloc(1000 * sizeof(double));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL)
	{
	    pti->piWorkloadIndividual = malloc(1000 * sizeof(int));
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_CUMULATIVE)
	{
	    pti->piWorkloadCumulative = malloc(1000 * sizeof(int));

	    pti->iWorkloadCumulative = 0;

	    pti->iStackTop = -1;

/* 	    pci->piWorkloadStack = malloc(100 * sizeof(int)); */

	    pti->piCurrentSymbol = malloc(100 * sizeof(int));
	}

	pti->iAllocated = 1000;
    }

    //- if already allocated

    else
    {
	//- if need reallocation

	if (pti->iAllocated <= pti->iChildren)
	{
	    //- reallocate

	    int iSize = sizeof(*pti->piSerials) * (pti->iAllocated + 1000);

	    int *piSerials = (int *)realloc(pti->piSerials, iSize);

	    if (!piSerials)
	    {
		return(TSTR_PROCESSOR_ABORT);
	    }

	    pti->piSerials = piSerials;

	    iSize = sizeof(*pti->piTypes) * (pti->iAllocated + 1000);

	    int *piTypes = (int *)realloc(pti->piTypes, iSize);

	    if (!piTypes)
	    {
		return(TSTR_PROCESSOR_ABORT);
	    }

	    pti->piTypes = piTypes;

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_CONTEXTS)
	    {
		iSize = sizeof(*pti->ppcContexts) * (pti->iAllocated + 1000);

		char **ppcContexts = (char **)realloc(pti->ppcContexts, iSize);

		if (!ppcContexts)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppcContexts = ppcContexts;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_NAMES)
	    {
		iSize = sizeof(*pti->ppcNames) * (pti->iAllocated + 1000);

		char **ppcNames = (char **)realloc(pti->ppcNames, iSize);

		if (!ppcNames)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppcNames = ppcNames;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_TYPES)
	    {
		iSize = sizeof(*pti->ppcTypes) * (pti->iAllocated + 1000);

		char **ppcTypes = (char **)realloc(pti->ppcTypes, iSize);

		if (!ppcTypes)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppcTypes = ppcTypes;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_LOCAL)
	    {
		iSize = sizeof(*pti->ppD3CoordsLocal) * (pti->iAllocated + 1000);

		struct D3Position **ppD3CoordsLocal = (struct D3Position **)realloc(pti->ppD3CoordsLocal, iSize);

		if (!ppD3CoordsLocal)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppD3CoordsLocal = ppD3CoordsLocal;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE)
	    {
		iSize = sizeof(*pti->ppD3CoordsAbsolute) * (pti->iAllocated + 1000);

		struct D3Position **ppD3CoordsAbsolute = (struct D3Position **)realloc(pti->ppD3CoordsAbsolute, iSize);

		if (!ppD3CoordsAbsolute)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppD3CoordsAbsolute = ppD3CoordsAbsolute;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT)
	    {
		iSize = sizeof(*pti->ppD3CoordsAbsoluteParent) * (pti->iAllocated + 1000);

		struct D3Position **ppD3CoordsAbsoluteParent = (struct D3Position **)realloc(pti->ppD3CoordsAbsoluteParent, iSize);

		if (!ppD3CoordsAbsoluteParent)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->ppD3CoordsAbsoluteParent = ppD3CoordsAbsoluteParent;

		iSize = sizeof(*pti->pdDia) * (pti->iAllocated + 1000);

		double *pdDia = (double *)realloc(pti->pdDia, iSize);

		if (!pdDia)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->pdDia = pdDia;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL)
	    {
		iSize = sizeof(*pti->piWorkloadIndividual) * (pti->iAllocated + 1000);

		int *piWorkloadIndividual = (int *)realloc(pti->piWorkloadIndividual, iSize);

		if (!piWorkloadIndividual)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->piWorkloadIndividual = piWorkloadIndividual;
	    }

	    if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_CUMULATIVE)
	    {
		iSize = sizeof(*pti->piWorkloadCumulative) * (pti->iAllocated + 1000);

		int *piWorkloadCumulative = (int *)realloc(pti->piWorkloadCumulative, iSize);

		if (!piWorkloadCumulative)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		pti->piWorkloadCumulative = piWorkloadCumulative;
	    }

	    pti->iAllocated += 1000;
	}
    }

    //- fill in basic info for this symbol

    pti->piSerials[pti->iChildren] = TstrGetPrincipalSerial(ptstr);

    pti->piTypes[pti->iChildren] = iType;

    if (pti->iFlagsInfo & TRAVERSAL_INFO_CONTEXTS)
    {
	//- copy name to result

	char pc[1000];

	PidinStackString(ptstr->ppist, pc, 1000);

	pti->ppcContexts[pti->iChildren] = (char *)malloc(1 + strlen(pc));

	strcpy(pti->ppcContexts[pti->iChildren], pc);
    }

    if (pti->iFlagsInfo & TRAVERSAL_INFO_NAMES)
    {
	//- copy name to result

	char pc[1000];

	struct symtab_IdentifierIndex *pidin = SymbolGetPidin(phsle);

	if (IdinIsPrintable(pidin))
	{
	    IdinFullName(pidin, pc);
	}
	else
	{
	    strcpy(pc,"undef");
	}

	pti->ppcNames[pti->iChildren] = (char *)malloc(1 + strlen(pc));

	strcpy(pti->ppcNames[pti->iChildren],pc);
    }

    if (pti->iFlagsInfo & TRAVERSAL_INFO_TYPES)
    {
	//- get reference to type

	pti->ppcTypes[pti->iChildren] = ppc_symbols_short_descriptions[iType];
    }

    //- if a symbol with coordinates

    if (subsetof_bio_comp(iType))
    {
	//- copy current context

	struct PidinStack *ppistCurrent
	    = PidinStackDuplicate(ptstr->ppist);

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_LOCAL)
	{
	    pti->ppD3CoordsLocal[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    struct PidinStack *ppistParent = PidinStackDuplicate(ppistCurrent);

	    PidinStackPop(ppistParent);

	    //- compute and store coordinate of current symbol

	    SymbolParameterResolveCoordinateValue
		(phsle, ppistParent, ppistCurrent, pti->ppD3CoordsLocal[pti->iChildren]);

	    //- free allocated memory

	    PidinStackFree(ppistParent);
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE)
	{
	    if (!pti->ppistRoot)
	    {
		struct PidinStack *ppistRoot = PidinStackCalloc();

		if (!ppistRoot)
		{
		    return(TSTR_PROCESSOR_ABORT);
		}

		PidinStackSetRooted(ppistRoot);

		pti->ppistRoot = ppistRoot;
	    }

	    pti->ppD3CoordsAbsolute[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    SymbolParameterResolveCoordinateValue
		(phsle, pti->ppistRoot, ppistCurrent, pti->ppD3CoordsAbsolute[pti->iChildren]);
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT)
	{
	    pti->ppD3CoordsAbsoluteParent[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    //- if this segment has a named parent segment

	    struct symtab_Parameters *pparParentSegment
		= SymbolFindParameter(phsle, "PARENT", ppistCurrent);

	    if (pparParentSegment)
	    {
		//- get pidinstack from parameter elements

		struct PidinStack *ppistParentSegment
		    = ParameterResolveToPidinStack(pparParentSegment,ppistCurrent);

		//- if parent symbol exists

		struct symtab_HSolveListElement *phsleParentSegment
		    = PidinStackLookupTopSymbol(ppistParentSegment);

		if (phsleParentSegment)
		{
		    //- get coordinates of parent

		    SymbolParameterResolveCoordinateValue
			(phsleParentSegment, pti->ppistRoot, ppistParentSegment, pti->ppD3CoordsAbsoluteParent[pti->iChildren]);
		}

		//- else

		else
		{
		    //- mark as if the parameter was not found

		    //! e.g. soma has parent 'none'

		    pparParentSegment = NULL;
		}

		//- free allocated memory

		PidinStackFree(ppistParentSegment);
	    }

	    //- if there was no named parent segment

	    if (!pparParentSegment)
	    {
		//- if this segment has a length

		struct symtab_Parameters *pparLength
		    = SymbolFindParameter(phsle, "LENGTH", ppistCurrent);

		if (pparLength)
		{
		    //- compute length

		    double dLength = ParameterResolveValue(pparLength, ppistCurrent);

		    //- assume that this segment is aligned with the Z axis

		    *pti->ppD3CoordsAbsoluteParent[pti->iChildren] = *pti->ppD3CoordsAbsolute[pti->iChildren];

		    pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dz += dLength;
		}

		//- else

		else
		{
		    //- try diameter

		    struct symtab_Parameters *pparDia
			= SymbolFindParameter(phsle, "DIA", ppistCurrent);

		    if (pparDia)
		    {
			//- compute diameter

			double dDia = ParameterResolveValue(pparDia, ppistCurrent);

			//- assume that this segment is aligned with the Z axis

			*pti->ppD3CoordsAbsoluteParent[pti->iChildren] = *pti->ppD3CoordsAbsolute[pti->iChildren];

			pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dz += dDia;
		    }
		    else
		    {
			pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dx = FLT_MAX;
			pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dy = FLT_MAX;
			pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dz = FLT_MAX;
		    }
		}
	    }

	    //- try diameter

	    struct symtab_Parameters *pparDia
		= SymbolFindParameter(phsle, "DIA", ppistCurrent);

	    if (pparDia)
	    {
		//- compute diameter

		double dDia = ParameterResolveValue(pparDia, ppistCurrent);

		pti->pdDia[pti->iChildren] = dDia;
	    }
	    else
	    {
		pti->pdDia[pti->iChildren] = -1;
	    }
	}

	//- free allocated memory

	PidinStackFree(ppistCurrent);
    }

    //- else a symbol without coordinates

    else
    {
	//- set dummy coordinates

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_LOCAL)
	{
	    pti->ppD3CoordsLocal[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    pti->ppD3CoordsLocal[pti->iChildren]->dx = 0;
	    pti->ppD3CoordsLocal[pti->iChildren]->dy = 0;
	    pti->ppD3CoordsLocal[pti->iChildren]->dz = 0;
	}

	//t this should be inherited from the parent

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE)
	{
	    pti->ppD3CoordsAbsolute[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    pti->ppD3CoordsAbsolute[pti->iChildren]->dx = 0;
	    pti->ppD3CoordsAbsolute[pti->iChildren]->dy = 0;
	    pti->ppD3CoordsAbsolute[pti->iChildren]->dz = 0;
	}

	if (pti->iFlagsInfo & TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT)
	{
	    pti->ppD3CoordsAbsoluteParent[pti->iChildren] = (struct D3Position *)malloc(sizeof(struct D3Position));

	    pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dx = 0;
	    pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dy = 0;
	    pti->ppD3CoordsAbsoluteParent[pti->iChildren]->dz = 0;
	}
    }

    if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL)
    {
	//- get workload for this child

	pti->piWorkloadIndividual[pti->iChildren] = SymbolGetWorkloadIndividual(phsle, ptstr->ppist);
    }

    if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_CUMULATIVE)
    {
	//- register current cumulative workload for this symbol

	pti->piWorkloadCumulative[pti->iChildren] = pti->iWorkloadCumulative;

	//- register current cumulative workload

	int iWorkloadIndividual = SymbolGetWorkloadIndividual(phsle, ptstr->ppist);

	if (iWorkloadIndividual != -1)
	{
	    pti->iWorkloadCumulative += iWorkloadIndividual;
	}

	//- push workload on the stack

	pti->iStackTop++;

/* 	pci->piWorkloadStack[pci->iStackTop] = pci->iWorkloadCumulative; */

	//- push current child index for this traversal on the children count stack

	pti->piCurrentSymbol[pti->iStackTop] = pti->iChildren;
    }

    //- increment current child index

    pti->iChildren++;

    //- if the client function wants a fixed return value

    if (pti->iFlagsTraversal & CHILDREN_TRAVERSAL_FIXED_RETURN)
    {
	//- set result

	iResult = pti->iTraversalResult;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TraversalInfoCumulativeInfoCollectorProcessor()
///
/// ARGS.:
///
///	std. SymbolProcessor args.
///
/// RTN..: int : SymbolProcessor return value.
///
/// DESCR:
///
///	Collect cumulative information about children, see
///	TRAVERSAL_INFO_* defines.
///
/// **************************************************************************

int 
TraversalInfoCumulativeInfoCollectorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol (child)

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get traversal data

    struct traversal_info *pti
	= (struct traversal_info *)pvUserdata;

    if (pti->iFlagsInfo & TRAVERSAL_INFO_WORKLOAD_CUMULATIVE)
    {
/* 	//- register current cumulative workload */

/* 	int iWorkloadIndividual = SymbolGetWorkloadIndividual(phsle, ptstr->ppist); */

/* 	if (iWorkloadIndividual != -1) */
/* 	{ */
/* 	    pci->iWorkloadCumulative -= iWorkloadIndividual; */
/* 	} */

/* 	//- get workload from the stack */

/* 	int iWorkloadCumulative = pci->piWorkloadStack[pci->iStackTop]; */

	//- get current symbol index from the stack

	int iCurrentSymbol = pti->piCurrentSymbol[pti->iStackTop];

	//- pop the stack

	pti->iStackTop--;

	//- subtract pre-order registered cumulative workload to get the real cumulative workload

	pti->piWorkloadCumulative[iCurrentSymbol]
	    = pti->iWorkloadCumulative - pti->piWorkloadCumulative[iCurrentSymbol];
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: TraversalInfoFree()
///
/// ARGS.:
///
///	pti.: traversal info.
///
/// RTN..: void
///
/// DESCR: Free traversal info, NULL pointers left alone.
///
/// **************************************************************************

void TraversalInfoFree(struct traversal_info *pti)
{
    if (pti->ppistRoot)
    {
	PidinStackFree(pti->ppistRoot);
    }

    if (pti->piSerials)
    {
	free(pti->piSerials);
    }

    if (pti->piTypes)
    {
	free(pti->piTypes);
    }

    if (pti->ppcContexts)
    {
	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    free(pti->ppcContexts[i]);
	}

	free(pti->ppcContexts);
    }

    if (pti->ppcNames)
    {
	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    free(pti->ppcNames[i]);
	}

	free(pti->ppcNames);
    }

    if (pti->ppcTypes)
    {
/* 	for (i = 0; i < pti->iChildren; i++) */
/* 	{ */
/* 	    free(pti->ppcTypes[i]); */
/* 	} */

	free(pti->ppcTypes);
    }

    if (pti->ppD3CoordsLocal)
    {
	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    free(pti->ppD3CoordsLocal[i]);
	}

	free(pti->ppD3CoordsLocal);
    }

    if (pti->ppD3CoordsAbsolute)
    {
	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    free(pti->ppD3CoordsAbsolute[i]);
	}

	free(pti->ppD3CoordsAbsolute);
    }

    if (pti->ppD3CoordsAbsoluteParent)
    {
	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    free(pti->ppD3CoordsAbsoluteParent[i]);
	}

	free(pti->ppD3CoordsAbsoluteParent);

    }

    if (pti->pdDia)
    {
	free(pti->pdDia);
    }

    if (pti->piWorkloadIndividual)
    {
	free(pti->piWorkloadIndividual);
    }

    if (pti->piWorkloadCumulative)
    {
	free(pti->piWorkloadCumulative);
    }

/*     if (pti->piWorkloadStack) */
/*     { */
/* 	free(pti->piWorkloadStack); */
/*     } */

    if (pti->piCurrentSymbol)
    {
/* 	free(pti->piCurrentSymbol); */
    }

    pti->iAllocated = 0;
    pti->iChildren = 0;
}


