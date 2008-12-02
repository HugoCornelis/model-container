//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: contourpoint.h 1.3 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef CONTOURPOINT_H
#define CONTOURPOINT_H


#include <stdio.h>


/// \struct structure declarations

struct descr_ContourPoint;
struct symtab_ContourPoint;


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"



struct symtab_ContourPoint * ContourPointCalloc(void);

struct symtab_HSolveListElement * 
ContourPointCreateAlias
(struct symtab_ContourPoint *pcpnt,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
ContourPointGetParameter
(struct symtab_ContourPoint *pcpnt,
 struct PidinStack *ppist,
 char *pcName);

void ContourPointInit(struct symtab_ContourPoint *pcpnt);


#include "biocomp.h"


/// \struct
/// \struct contour point description
/// \struct

struct descr_ContourPoint
{
    /// compiler happy

    int iHappy;
};


/// \struct
/// \struct struct symtab_ContourPoint
/// \struct

struct symtab_ContourPoint
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// contour point description

    struct descr_ContourPoint degatk;
};


#endif


