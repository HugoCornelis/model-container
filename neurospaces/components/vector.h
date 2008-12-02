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


/// \struct structure declarations

struct descr_Vector;
struct symtab_Vector;



void VectorInit(struct symtab_Vector *pvect);


#include "biocomp.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"


/// \struct
/// \struct vector description
/// \struct

struct descr_Vector
{
    int iHappy;
};


/// \struct
/// \struct struct symtab_Vector
/// \struct

struct symtab_Vector
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// enumeration container

    struct descr_Vector devect;
};


#endif


