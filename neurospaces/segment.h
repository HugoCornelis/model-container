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
//' Copyright (C) 1999-2007 Hugo Cornelis
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
#include "hines_list.h"
#include "inputoutput.h"
#include "pidinstack.h"
#include "segmenter.h"


//s structure declarations

struct descr_Segment;
struct symtab_Segment;


#include "treespacetraversal.h"


//f exported functions

struct symtab_Segment * SegmentCalloc(void);

struct symtab_HSolveListElement * 
SegmentCreateAlias
(struct symtab_Segment *psegment,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
SegmentGetParameter
(struct symtab_Segment *psegment,
 char *pcName,
 struct PidinStack *ppist);

void SegmentInit(struct symtab_Segment *psegment);


#include "equation.h"
#include "idin.h"
#include "parameters.h"


//s
//s segment description
//s

struct descr_Segment
{
    //m type of segment data

    int iType;

    //m segment specific flags (OPTIONS keyword)

    int iFlags;
};


//s
//s struct symtab_Segment
//s

struct symtab_Segment
{
    //m base struct : segmenter

    struct symtab_Segmenter segr;

    //m segment description

    struct descr_Segment desegment;
};


#endif


