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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef GROUP_H
#define GROUP_H


/// \struct structure declarations

struct descr_Group;
struct symtab_Group;


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"



struct symtab_Group * GroupCalloc(void);

int GroupCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
GroupCreateAlias
(struct symtab_Group *pgrup,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void GroupInit(struct symtab_Group *pgrup);

struct symtab_Group * GroupNewAtXYZ(double dx,double dy,double dz);


#include "biocomp.h"
#include "neurospaces/inputoutput.h"


/// \struct group

struct descr_Group
{
    int iHappy;
};


/// \struct struct symtab_Group

struct symtab_Group
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// group description

    struct descr_Group degrup;
};


#endif


