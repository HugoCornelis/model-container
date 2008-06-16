//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: biolevel.c 1.21 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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



#include <stddef.h>

#include "neurospaces/biolevel.h"
#include "neurospaces/symboltable.h"


//v map a symbol type to a biological level, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.



int piSymbolType2Biolevel[COUNT_HIERARCHY_TYPE_symbols + 2] =
{
#include "hierarchy/output/symbols/annotations/piSymbolType2Biolevel"
/*     -1, // n */
/*     -1, // group */
/*     -1, // n */
/*     -1, // n */
/*     -1, // equation */
/*     BIOLEVEL_MECHANISM, // channel */
/*     BIOLEVEL_MECHANISM, // pool */
/*     BIOLEVEL_SEGMENT, // segment */
/*     BIOLEVEL_SEGMENT, // n */
/*     BIOLEVEL_CELL, // cell */
/*     -1, // attachment */
/*     BIOLEVEL_POPULATION, // population */
/*     BIOLEVEL_NETWORK, // network */
/*     -1, // vector */
/*     BIOLEVEL_POPULATION, // projection */
/*     BIOLEVEL_CELL, // connection */
/*     -1, // n */
/*     -1, // n */
/*     BIOLEVEL_SEGMENT, // randomvalue */
/*     BIOLEVEL_NERVOUS_SYSTEM, // root_symbol */
/*     BIOLEVEL_POPULATION, // v_connection_symbol */
/*     -1, // v_segment */
/*     BIOLEVEL_CELL, // fiber */
/*     -1, // invisible */
/*     BIOLEVEL_SEGMENT, // axon_hillock */
/*     BIOLEVEL_MECHANISM, // hh gate */
/*     BIOLEVEL_MECHANISM, // gate_kinetic */
/*     -1, // algorithm_symbol */
/*     BIOLEVEL_SEGMENT, // segmenter */
/*     -1, // traversable_algorithm */
/*     BIOLEVEL_MECHANISM, // concentration gate kinetic */
/*     BIOLEVEL_ATOMIC, // e_m_contour */
/*     BIOLEVEL_ATOMIC, // contour_point */
/*     -1, // v_contour */
/*     -1, // connection symbol */
/*     BIOLEVEL_POPULATION, // v_connection */
/*     0 */
};


//v map a biological level to its group, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.

int piBiolevel2Biolevelgroup[COUNT_BIOLEVEL + 2] =
{
    -1,
    BIOLEVELGROUP_NERVOUS_SYSTEM,
    BIOLEVELGROUP_BRAIN_STRUCTURE,
    BIOLEVELGROUP_BRAIN_STRUCTURE,
    BIOLEVELGROUP_BRAIN_STRUCTURE,
    BIOLEVELGROUP_NETWORK,
    BIOLEVELGROUP_NETWORK,
    BIOLEVELGROUP_NETWORK,
    BIOLEVELGROUP_CELL,
    BIOLEVELGROUP_SEGMENT,
    BIOLEVELGROUP_MECHANISM,
    BIOLEVELGROUP_MECHANISM,
    BIOLEVELGROUP_MECHANISM,
    BIOLEVELGROUP_MECHANISM,
    0,
};


//v give biolevels a human readable form

char *ppcBiolevel[COUNT_BIOLEVEL + 2] =
{
    "Invalid",
    "BIOLEVEL_NERVOUS_SYSTEM",
    "BIOLEVEL_BRAIN",
    "BIOLEVEL_BRAIN_STRUCTURE",
    "BIOLEVEL_BRAIN_REGION",
    "BIOLEVEL_NETWORK",
    "BIOLEVEL_POPULATION",
    "BIOLEVEL_SUBPOPULATION",
    "BIOLEVEL_CELL",
    "BIOLEVEL_SEGMENT",
    "BIOLEVEL_MECHANISM",
    "BIOLEVEL_CHEMICAL_PATHWAY",
    "BIOLEVEL_MOLECULAR",
    "BIOLEVEL_ATOMIC",
    NULL,
};


//v map a biological group to its lowest biological level, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.

int piBiolevelgroup2Biolevel[COUNT_BIOLEVELGROUP + 2] =
{
    -1,
    BIOLEVEL_NERVOUS_SYSTEM,
    BIOLEVEL_BRAIN_REGION,
    BIOLEVEL_SUBPOPULATION,
    BIOLEVEL_CELL,
    BIOLEVEL_SEGMENT,
    BIOLEVEL_ATOMIC,
    0,
};


//v give biological groups a human readable form

char *ppcBiolevelgroup[COUNT_BIOLEVELGROUP + 2] =
{
    "Invalid",
    "BIOLEVELGROUP_NERVOUS_SYSTEM",
    "BIOLEVELGROUP_BRAIN_STRUCTURE",
    "BIOLEVELGROUP_NETWORK",
    "BIOLEVELGROUP_CELL",
    "BIOLEVELGROUP_SEGMENT",
    "BIOLEVELGROUP_MECHANISM",
    NULL,
};


