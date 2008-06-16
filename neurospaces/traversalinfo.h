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


//d traversal info collector flags

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
    //m information request flags

    int iFlagsInfo;

    //m traversal method flags

    int iFlagsTraversal;

    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

    int iTraversalResult;

    //m current child index

    int iChildren;

    //m pidinstack pointing to root

    struct PidinStack *ppistRoot;

    //m serials of symbols

    int *piSerials;

    //m types of symbols

    int *piTypes;

    //m chars with complete contexts

    char **ppcContexts;

    //m chars with symbol names

    char **ppcNames;

    //m chars with symbol types

    char **ppcTypes;

    //m local coordinates of symbols

    struct D3Position **ppD3CoordsLocal;

    //m absolute coordinates of symbols

    struct D3Position **ppD3CoordsAbsolute;

    //m absolute coordinates of parent segments

    struct D3Position **ppD3CoordsAbsoluteParent;

    double *pdDia;

    //m non-cumulative workload for symbols

    int *piWorkloadIndividual;

    //m cumulative workload for symbols

    int *piWorkloadCumulative;

    //m current cumulative workload

    int iWorkloadCumulative;

    //m stack top

    int iStackTop;

    //m stack used for accumulation

    int *piWorkloadStack;

    //m stack used to track the traversal index of visited symbols

    int *piCurrentSymbol;

    //m allocation count

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


