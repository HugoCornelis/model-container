//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: traversablealgorithm.h 1.4 Fri, 07 Sep 2007 15:00:26 -0500 hugo $
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


#ifndef TRAVERSABLEALGORITHM_H
#define TRAVERSABLEALGORITHM_H


#include <stdio.h>


//s structure declarations

struct descr_TraversableAlgorithm;
struct symtab_TraversableAlgorithm;


#include "algorithminstance.h"
#include "idin.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_TraversableAlgorithm *
TraversableAlgorithmCalloc(void);

void
TraversableAlgorithmInit
(struct symtab_TraversableAlgorithm *ptalg);

int
TraversableAlgorithmTraverse
(struct TreespaceTraversal *ptstr, struct symtab_TraversableAlgorithm *ptalg);


#include "symboltable.h"


//f inline prototypes

static inline
char *
TraversableAlgorithmGetName(struct symtab_TraversableAlgorithm *ptalg);

static inline
struct symtab_IdentifierIndex *
TraversableAlgorithmGetPidin(struct symtab_TraversableAlgorithm *ptalg);


//s
//s traversable algorithm description
//s

struct descr_TraversableAlgorithm
{
    int iHappy;
};


//s
//s struct symtab_TraversableAlgorithm
//s

struct symtab_TraversableAlgorithm
{
    //m base struct: algorithm symbol

    struct symtab_AlgorithmSymbol algs;
};


#endif


