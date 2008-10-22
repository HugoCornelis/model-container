//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorcontour.h 1.2 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef VECTORCONTOUR_H
#define VECTORCONTOUR_H


#include <stdio.h>


//s structure declarations

struct descr_VContour;
struct symtab_VContour;


//f exported functions

struct symtab_VContour * VContourCalloc(void);

struct symtab_HSolveListElement * 
VContourCreateAlias
(struct symtab_VContour *pvcont,
 struct symtab_IdentifierIndex *pidin);

void VContourInit(struct symtab_VContour *pvcont);


#include "vector.h"


//s
//s vector description
//s

struct descr_VContour
{
    int iHappy;
};


//s
//s struct symtab_VContour
//s

struct symtab_VContour
{
    //m base struct : vector

    struct symtab_Vector vect;

    //m enumeration container

    struct descr_VContour devcont;
};


#endif


