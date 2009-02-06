//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: randomvalue.h 1.21 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef RANDOMVALUE_H
#define RANDOMVALUE_H


#include <stdio.h>

#include "biocomp.h"
#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_Randomvalue;
struct symtab_Randomvalue;



struct symtab_Randomvalue * RandomvalueCalloc(void);

struct symtab_HSolveListElement * 
RandomvalueCreateAlias
(struct symtab_Randomvalue *pranv,
 struct symtab_IdentifierIndex *pidin);

struct symtab_HSolveListElement *
RandomvalueGetSpikeGenerator
(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist);

void RandomvalueInit(struct symtab_Randomvalue *pranv);

struct symtab_HSolveListElement *
RandomvalueLookupHierarchical
(struct symtab_Randomvalue *pranv,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);


/* #include "equation.h" */
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"


/// \struct
/// \struct randomvalue description
/// \struct

struct descr_Randomvalue
{
    /// dummy

    int iType;
};


/// \struct
/// \struct struct symtab_Randomvalue
/// \struct

struct symtab_Randomvalue
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// randomvalue description

    struct descr_Randomvalue deranv;
};


#endif


