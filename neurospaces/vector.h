//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vector.h 1.32 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#ifndef VECTOR_H
#define VECTOR_H


#include <stdio.h>


//s structure declarations

struct descr_Vector;
struct symtab_Vector;


//f exported functions

void VectorInit(struct symtab_Vector *pvect);


#include "biocomp.h"
#include "hines_list.h"
#include "idin.h"
#include "inputoutput.h"
#include "parameters.h"
#include "pidinstack.h"
#include "symboltable.h"


//s
//s vector description
//s

struct descr_Vector
{
    int iHappy;
};


//s
//s struct symtab_Vector
//s

struct symtab_Vector
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m enumeration container

    struct descr_Vector devect;
};


#endif


