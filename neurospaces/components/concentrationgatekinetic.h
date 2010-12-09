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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef CONCENTRATIONGATEKINETIC_H
#define CONCENTRATIONGATEKINETIC_H


#include <stdio.h>


/// \struct structure declarations

struct descr_ConcentrationGateKinetic;
struct symtab_ConcentrationGateKinetic;


#include "neurospaces/pidinstack.h"



struct symtab_ConcentrationGateKinetic * ConcentrationGateKineticCalloc(void);

struct symtab_HSolveListElement * 
ConcentrationGateKineticCreateAlias
(struct symtab_ConcentrationGateKinetic *pcgatc,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
ConcentrationGateKineticGetParameter
(struct symtab_ConcentrationGateKinetic *pcgatc,
 struct PidinStack *ppist,
 char *pcName);

void ConcentrationGateKineticInit(struct symtab_ConcentrationGateKinetic *pgatk);


#include "biocomp.h"


/// \struct gate kinetic description

struct descr_ConcentrationGateKinetic
{
    /// compiler happy

    int iHappy;
};


/// \struct struct symtab_ConcentrationGateKinetic

struct symtab_ConcentrationGateKinetic
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// gate kinetic description

    struct descr_ConcentrationGateKinetic degatc;
};


#endif


