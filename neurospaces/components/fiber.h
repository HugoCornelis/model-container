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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef FIBER_H
#define FIBER_H


/// \struct structure declarations

struct descr_Fiber;
struct symtab_Fiber;


#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"
#include "segmenter.h"



struct symtab_Fiber * FiberCalloc(void);

int FiberCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
FiberCreateAlias
(struct symtab_Fiber *pfibr,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void FiberInit(struct symtab_Fiber *pfibr);

struct symtab_Fiber * FiberNewAtXYZ(double dx,double dy,double dz);


#include "biocomp.h"
#include "neurospaces/inputoutput.h"


/// \struct
/// \struct fiber
/// \struct

struct descr_Fiber
{
    int iHappy;
};


/// \struct
/// \struct struct symtab_Fiber
/// \struct

struct symtab_Fiber
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// fiber description

    struct descr_Fiber defibr;
};


#endif


