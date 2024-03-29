//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: axonhillock.h 1.16 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef AXONHILLOCK_H
#define AXONHILLOCK_H


#include <stdio.h>


/// \struct structure declarations

struct descr_AxonHillock;
struct symtab_AxonHillock;


#include "neurospaces/idin.h"
#include "neurospaces/treespacetraversal.h"
#include "segmenter.h"



struct symtab_AxonHillock * AxonHillockCalloc(void);

struct symtab_HSolveListElement * 
AxonHillockCreateAlias
(struct symtab_AxonHillock *paxhi,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void AxonHillockInit(struct symtab_AxonHillock *paxhi);


#include "biocomp.h"


/// \struct
/// \struct axon hillock description
/// \struct

struct descr_AxonHillock
{
    /// the happy compiler

    int iHappy;
};


/// \struct
/// \struct struct symtab_AxonHillock
/// \struct

struct symtab_AxonHillock
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// axon hillock description

    struct descr_AxonHillock deaxhi;
};


#endif


