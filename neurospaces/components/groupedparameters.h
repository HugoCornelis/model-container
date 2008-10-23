//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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


#ifndef GROUPEDPARAMETERS_H
#define GROUPEDPARAMETERS_H


//s structure declarations

struct symtab_GroupedParameters;


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"


//f exported functions

struct symtab_GroupedParameters * GroupedParametersCalloc(void);

void GroupedParametersInit(struct symtab_GroupedParameters *pgrpp);


#include "neurospaces/components/biocomp.h"


//s
//s struct symtab_GroupedParameters
//s

struct symtab_GroupedParameters
{
    //m base struct: bio component

    struct symtab_BioComponent bio;

};


#endif


