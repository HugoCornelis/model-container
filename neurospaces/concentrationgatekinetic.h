//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: concentrationgatekinetic.h 1.2 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef CONCENTRATIONGATEKINETIC_H
#define CONCENTRATIONGATEKINETIC_H


#include <stdio.h>


//s structure declarations

struct descr_ConcentrationGateKinetic;
struct symtab_ConcentrationGateKinetic;


#include "idin.h"


//f exported functions

struct symtab_ConcentrationGateKinetic * ConcentrationGateKineticCalloc(void);

struct symtab_HSolveListElement * 
ConcentrationGateKineticCreateAlias
(struct symtab_ConcentrationGateKinetic *pcgatc,
 struct symtab_IdentifierIndex *pidin);

void ConcentrationGateKineticInit(struct symtab_ConcentrationGateKinetic *pgatk);


#include "biocomp.h"


//s
//s gate kinetic description
//s

struct descr_ConcentrationGateKinetic
{
    //m compiler happy

    int iHappy;
};


//s
//s struct symtab_ConcentrationGateKinetic
//s

struct symtab_ConcentrationGateKinetic
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m gate kinetic description

    struct descr_ConcentrationGateKinetic degatc;
};


#endif


