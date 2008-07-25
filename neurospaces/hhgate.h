//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: hhgate.h 1.8 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef HHGATE_H
#define HHGATE_H


#include <stdio.h>


//s structure declarations

struct descr_HHGate;
struct symtab_HHGate;


#include "pidinstack.h"


//f exported functions

struct symtab_HHGate * HHGateCalloc(void);

struct symtab_HSolveListElement * 
HHGateCreateAlias
(struct symtab_HHGate *pgathh,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
HHGateGetParameter
(struct symtab_HHGate *pgathh,
 struct PidinStack *ppist,
 char *pcName);

void HHGateInit(struct symtab_HHGate *pgathh);


#include "biocomp.h"


//s
//s gate kinetic description
//s

struct descr_HHGate
{
    //m compiler happy

    int iHappy;
};


//s
//s struct symtab_HHGate
//s

struct symtab_HHGate
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m gate kinetic description

    struct descr_HHGate degathh;
};


#endif


