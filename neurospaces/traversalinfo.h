//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: traversalinfo.h 1.6 Thu, 10 May 2007 20:53:37 -0500 hugo $
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


#ifndef TRAVERSALINFO_H
#define TRAVERSALINFO_H


#include "pidinstack.h"
#include "positionD3.h"


/// \def traversal info collector flags

#define TRAVERSAL_INFO_CONTEXTS			1
#define TRAVERSAL_INFO_NAMES			2
#define TRAVERSAL_INFO_TYPES			4
#define TRAVERSAL_INFO_COORDS_LOCAL		8
#define TRAVERSAL_INFO_COORDS_ABSOLUTE		16
// #define TRAVERSAL_INFO_COORDS_LOCAL_PARENT	32
#define TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT	64
#define TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL	128
#define TRAVERSAL_INFO_WORKLOAD_BOUNDARIES	256
#define TRAVERSAL_INFO_WORKLOAD_CUMULATIVE	512

#define CHILDREN_TRAVERSAL_FIXED_RETURN		1


struct traversal_info
{
    /// information request flags

    int iFlagsInfo;

    /// traversal method flags

    int iFlagsTraversal;

    /// traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

    int iTraversalResult;

    /// current child index

    int iChildren;

    /// pidinstack pointing to root

    struct PidinStack *ppistRoot;

    /// serials of symbols

    int *piSerials;

    /// types of symbols

    int *piTypes;

    /// chars with complete contexts

    char **ppcContexts;

    /// chars with symbol names

    char **ppcNames;

    /// chars with symbol types

    char **ppcTypes;

    /// local coordinates of symbols

    struct D3Position **ppD3CoordsLocal;

    /// absolute coordinates of symbols

    struct D3Position **ppD3CoordsAbsolute;

    /// absolute coordinates of parent segments

    struct D3Position **ppD3CoordsAbsoluteParent;

    double *pdDia;

    /// non-cumulative workload for symbols

    int *piWorkloadIndividual;

    /// cumulative workload for symbols

    int *piWorkloadCumulative;

    /// current cumulative workload

    int iWorkloadCumulative;

    /// stack top

    int iStackTop;

    /// stack used for accumulation

    int *piWorkloadStack;

    /// stack used to track the traversal index of visited symbols

    int *piCurrentSymbol;

    /// allocation count

    int iAllocated;
};



int
TraversalInfoCumulativeInfoCollectorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

int
TraversalInfoCollectorProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

void TraversalInfoFree(struct traversal_info *pti);


#endif


