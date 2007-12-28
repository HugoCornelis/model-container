//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: fiber.h 1.12 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef FIBER_H
#define FIBER_H


//s structure declarations

struct descr_Fiber;
struct symtab_Fiber;


#include "idin.h"
#include "pidinstack.h"
#include "segmenter.h"
#include "symboltable.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_Fiber * FiberCalloc(void);

int FiberCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
FiberCreateAlias
(struct symtab_Fiber *pfibr,
 struct symtab_IdentifierIndex *pidin);

void FiberInit(struct symtab_Fiber *pfibr);

struct symtab_Fiber * FiberNewAtXYZ(double dx,double dy,double dz);


#include "inputoutput.h"
#include "biocomp.h"


//s
//s fiber
//s

struct descr_Fiber
{
    int iHappy;
};


//s
//s struct symtab_Fiber
//s

struct symtab_Fiber
{
    //m base struct : segmenter

    struct symtab_Segmenter segr;

    //m fiber description

    struct descr_Fiber defibr;
};


#endif


