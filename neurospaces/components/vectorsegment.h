//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorsegment.h 1.18 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef VECTORSEGMENT_H
#define VECTORSEGMENT_H


#include <stdio.h>


/// \struct structure declarations

struct descr_VSegment;
struct symtab_VSegment;



int
VSegmentRelative2Absolute
(struct symtab_VSegment *pvsegm, struct PidinStack *ppist);

struct symtab_VSegment * VSegmentCalloc(void);

int VSegmentCountSegments
(struct symtab_VSegment *pvsegm,
 struct PidinStack *ppist);

struct symtab_HSolveListElement * 
VSegmentCreateAlias
(struct symtab_VSegment *pvsegm,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void VSegmentInit(struct symtab_VSegment *pvsegm);

int VSegmentTraverseSegments
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "vector.h"


/// \struct
/// \struct vector description
/// \struct

struct descr_VSegment
{
    int iHappy;
};


/// \struct
/// \struct struct symtab_VSegment
/// \struct

struct symtab_VSegment
{
    /// base struct : vector

    struct symtab_Vector vect;

    /// enumeration container

    struct descr_VSegment devsegm;
};


#endif


