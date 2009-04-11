//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: emcontour.h 1.2 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef EMCONTOUR_H
#define EMCONTOUR_H


#include <stdio.h>


/// \struct structure declarations

struct descr_EMContour;
struct symtab_EMContour;


#include "neurospaces/idin.h"



struct symtab_EMContour * EMContourCalloc(void);

struct symtab_HSolveListElement * 
EMContourCreateAlias
(struct symtab_EMContour *pemc,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void EMContourInit(struct symtab_EMContour *pemc);


#include "biocomp.h"


/// \struct
/// \struct EM contour description
/// \struct

struct descr_EMContour
{
    /// compiler happy

    int iHappy;
};


/// \struct
/// \struct struct symtab_EMContour
/// \struct

struct symtab_EMContour
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// EM contour description

    struct descr_EMContour degatk;
};


#endif


