//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: segmenter.h 1.15 Mon, 08 Oct 2007 22:55:25 -0500 hugo $
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


#ifndef SEGMENTER_H
#define SEGMENTER_H


#include <stdio.h>


//s structure declarations

struct descr_Segmenter;
struct symtab_Segmenter;


#include "idin.h"
#include "parameters.h"
#include "treespacetraversal.h"


//d
//d test type(psegr) == struct symtab_Segmenter * at compile time
//d

#define CompileTimeTestSegmenter(psegr)					\
do {									\
    struct symtab_Segmenter segr;					\
    (psegr) == &segr;							\
} while (0)


//d
//d test if segment is cylindrical
//d

//t this function is called for pool parameter calculation.

#define SegmenterIsCylindrical(psegr)					\
({									\
    CompileTimeTestSegmenter(psegr);					\
    ( ! SegmenterIsSpherical(psegr));					\
})


//d
//d test if segment is spherical
//d

//t this function is called for pool parameter calculation.

#define SegmenterIsSpherical(psegr)					\
({									\
    CompileTimeTestSegmenter(psegr);					\
    (SymbolGetOptions(&(psegr)->bio.ioh.iol.hsle) & FLAG_SEGMENTER_SPHERICAL) \
    ? 1 								\
    : 0 ;								\
})


//d segment is spherical

#define FLAG_SEGMENTER_SPHERICAL		1


//f exported functions

struct symtab_Segmenter * SegmenterCalloc(void);

int
SegmenterCountSegments
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist);

int
SegmenterCountSpikeGenerators
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

struct symtab_Parameters * 
SegmenterGetParameter
(struct symtab_Segmenter *psegr,
 char *pcName,
 struct PidinStack *ppist);

void SegmenterInit(struct symtab_Segmenter *psegr);

int
SegmenterLinearize
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

int
SegmenterMesherOnLength(struct symtab_Segmenter *psegr, struct PidinStack *ppist, double dLength);

double
SegmenterParameterScaleValue
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar);

int
SegmenterParentCount
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

int
SegmenterSetBase
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

int
SegmenterTips
(struct symtab_Segmenter *psegr, struct PidinStack *ppist);

int
SegmenterTraverseSegments
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "biocomp.h"


//s
//s segmenter description
//s

struct cable_structure
{
    //m serial of this segment

    int iSerial;

    //m serial of parent segment, -1 if none

    int iParentSerial;

    //m index of parent segment, -1 if none

    int iParentIndex;
};


struct descr_Segmenter
{
    //m number of segments in the structural indices if allocated, -1 means not initialized

    int iSegments;

    //m number of segments without parents

    int iNoParents;

    //m number of terminals

    int iTips;

    //m cable and morphology structure

    //! note that this can encode the structure for entire networks,
    //! yet without gap junctions.

    struct cable_structure *pcs;

    //m number of children

    int *piChildren;

    //m children indices

    int **ppiChildren;
};


//s
//s struct symtab_Segmenter
//s

struct symtab_Segmenter
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m segmenter description

    struct descr_Segmenter desegmenter;
};



#endif


