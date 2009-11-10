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


/// \struct structure declarations

struct descr_Segmenter;
struct symtab_Segmenter;


#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/treespacetraversal.h"


/// \def
/// \def test type(psegr) == struct symtab_Segmenter * at compile time
/// \def

#define CompileTimeTestSegmenter(psegr)					\
do {									\
    struct symtab_Segmenter segr;					\
    (psegr) == &segr;							\
} while (0)


/// \def
/// \def test if segment is cylindrical
/// \def

/// \todo this function is called for pool parameter calculation.

#define SegmenterIsCylindrical(psegr)					\
({									\
    CompileTimeTestSegmenter(psegr);					\
    ( ! SegmenterIsSpherical(psegr));					\
})


/// \def
/// \def test if segment is spherical
/// \def

/// \todo this function is called for pool parameter calculation.

#define SegmenterIsSpherical(psegr)					\
({									\
    CompileTimeTestSegmenter(psegr);					\
    (SymbolGetOptions(&(psegr)->bio.ioh.iol.hsle) & FLAG_SEGMENTER_SPHERICAL) \
    ? 1 								\
    : 0 ;								\
})


/// \def segment is spherical

#define FLAG_SEGMENTER_SPHERICAL		1



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
 struct PidinStack *ppist,
 char *pcName);

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
(struct symtab_Segmenter *psegr, struct PidinStack *ppist, int iSerials);

int
SegmenterTraverseSegments
(struct symtab_Segmenter *psegr,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "biocomp.h"


/// \struct
/// \struct segmenter description
/// \struct

struct cable_structure
{
    /// serial of this segment

    int iSerial;

    /// serial of parent segment, -1 if none

    int iParentSerial;

    /// index of parent segment, -1 if none

    int iParentIndex;
};


struct descr_Segmenter
{
    /// number of segments in the structural indices if allocated, -1 means not initialized

    int iSegments;

    /// number of segments without parents

    int iNoParents;

    /// number of terminals

    int iTips;

    /// cable and morphology structure

    /// \note note that this can encode the structure for entire networks,
    /// \note yet without gap junctions.

    struct cable_structure *pcs;

    /// number of children

    int *piChildren;

    /// children indices

    int **ppiChildren;
};


/// \struct
/// \struct struct symtab_Segmenter
/// \struct

struct symtab_Segmenter
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// segmenter description

    struct descr_Segmenter desegmenter;
};



#endif


