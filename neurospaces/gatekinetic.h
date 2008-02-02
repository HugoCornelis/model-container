//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: gatekinetic.h 1.7 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef GATEKINETIC_H
#define GATEKINETIC_H


#include <stdio.h>


//s structure declarations

struct descr_GateKinetic;
struct symtab_GateKinetic;


#include "pidinstack.h"


//f exported functions

struct symtab_GateKinetic * GateKineticCalloc(void);

struct symtab_HSolveListElement * 
GateKineticCreateAlias
(struct symtab_GateKinetic *pgatk,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
GateKineticGetParameter
(struct symtab_GateKinetic *pgatk,
 char *pcName,
 struct PidinStack *ppist);

void GateKineticInit(struct symtab_GateKinetic *pgatk);


#include "biocomp.h"


//s
//s gate kinetic description
//s

struct descr_GateKinetic
{
    //m compiler happy

    int iHappy;
};


//s
//s struct symtab_GateKinetic
//s

struct symtab_GateKinetic
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m gate kinetic description

    struct descr_GateKinetic degatk;
};


#endif


