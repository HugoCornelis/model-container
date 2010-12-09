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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef GATEKINETIC_H
#define GATEKINETIC_H


#include <stdio.h>


/// \struct structure declarations

struct descr_GateKinetic;
struct symtab_GateKinetic;


#include "neurospaces/pidinstack.h"



struct symtab_GateKinetic * GateKineticCalloc(void);

struct symtab_HSolveListElement * 
GateKineticCreateAlias
(struct symtab_GateKinetic *pgatk,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
GateKineticGetParameter
(struct symtab_GateKinetic *pgatk,
 struct PidinStack *ppist,
 char *pcName);

void GateKineticInit(struct symtab_GateKinetic *pgatk);


#include "biocomp.h"


/// \struct gate kinetic description

struct descr_GateKinetic
{
    /// compiler happy

    int iHappy;
};


/// \struct struct symtab_GateKinetic

struct symtab_GateKinetic
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// gate kinetic description

    struct descr_GateKinetic degatk;
};


#endif


