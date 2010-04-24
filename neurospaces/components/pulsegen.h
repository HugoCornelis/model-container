//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pulsegen.h 1.20.1.37 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef PULSEGEN_H
#define PULSEGEN_H


#include <stdio.h>

#include "biocomp.h"
#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_PulseGen;
struct symtab_PulseGen;



struct symtab_PulseGen * PulseGenCalloc(void);

struct symtab_HSolveListElement * 
PulseGenCreateAlias
(struct symtab_PulseGen *ppulsegen,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void PulseGenInit(struct symtab_PulseGen *ppulsegen);

struct symtab_HSolveListElement *
PulseGenLookupHierarchical
(struct symtab_PulseGen *ppulsegen,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);


/// \struct pulsegen description

struct descr_PulseGen
{
    /// keeping things happy

    int iHappy;

};


/// \struct struct symtab_PulseGen

struct symtab_PulseGen
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// pulsegen description

    struct descr_PulseGen depulsegen;
};


#endif


