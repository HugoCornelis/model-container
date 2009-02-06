//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: segment.h 1.104 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef SEGMENT_H
#define SEGMENT_H


#include <stdio.h>

#include "biocomp.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/pidinstack.h"
#include "segmenter.h"


/// \struct structure declarations

struct descr_Segment;
struct symtab_Segment;


#include "neurospaces/treespacetraversal.h"



struct symtab_Segment * SegmentCalloc(void);

struct symtab_HSolveListElement * 
SegmentCreateAlias
(struct symtab_Segment *psegment,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
SegmentGetParameter
(struct symtab_Segment *psegment,
 struct PidinStack *ppist,
 char *pcName);

void SegmentInit(struct symtab_Segment *psegment);


/* #include "equation.h" */
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"


/// \struct
/// \struct segment description
/// \struct

struct descr_Segment
{
    /// type of segment data

    int iType;

    /// segment specific flags (OPTIONS keyword)

    int iFlags;
};


/// \struct
/// \struct struct symtab_Segment
/// \struct

struct symtab_Segment
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// segment description

    struct descr_Segment desegment;
};


#endif


