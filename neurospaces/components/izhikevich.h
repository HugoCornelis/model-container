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


#ifndef IZHIKEVICH_H
#define IZHIKEVICH_H


/// \struct structure declarations

struct descr_Izhikevich;
struct symtab_Izhikevich;


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"
#include "segmenter.h"



struct symtab_Izhikevich * IzhikevichCalloc(void);

int IzhikevichCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
IzhikevichCreateAlias
(struct symtab_Izhikevich *pihzi,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void IzhikevichInit(struct symtab_Izhikevich *pihzi);

struct symtab_Izhikevich * IzhikevichNewAtXYZ(double dx, double dy, double dz);


#include "biocomp.h"
#include "neurospaces/inputoutput.h"


/// \struct izhikevich

struct descr_Izhikevich
{
    int iHappy;
};


/// \struct struct symtab_Izhikevich

struct symtab_Izhikevich
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// izhikevich description

    struct descr_Izhikevich deihzi;
};


#endif


