//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: group.h 1.29 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef GROUP_H
#define GROUP_H


//s structure declarations

struct descr_Group;
struct symtab_Group;


#include "idin.h"
#include "pidinstack.h"
#include "symboltable.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_Group * GroupCalloc(void);

int GroupCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
GroupCreateAlias
(struct symtab_Group *pgrup,
 struct symtab_IdentifierIndex *pidin);

void GroupInit(struct symtab_Group *pgrup);

struct symtab_Group * GroupNewAtXYZ(double dx,double dy,double dz);


#include "inputoutput.h"
#include "biocomp.h"


//s
//s group
//s

struct descr_Group
{
    int iHappy;
};


//s
//s struct symtab_Group
//s

struct symtab_Group
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m group description

    struct descr_Group degrup;
};


#endif


