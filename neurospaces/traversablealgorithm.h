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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef TRAVERSABLEALGORITHM_H
#define TRAVERSABLEALGORITHM_H


#include <stdio.h>


/// \struct structure declarations

struct descr_TraversableAlgorithm;
struct symtab_TraversableAlgorithm;


#include "algorithminstance.h"
#include "idin.h"
#include "treespacetraversal.h"



struct symtab_TraversableAlgorithm *
TraversableAlgorithmCalloc(void);

void
TraversableAlgorithmInit
(struct symtab_TraversableAlgorithm *ptalg);

int
TraversableAlgorithmTraverse
(struct TreespaceTraversal *ptstr, struct symtab_TraversableAlgorithm *ptalg);


#include "symboltable.h"



static inline
char *
TraversableAlgorithmGetName(struct symtab_TraversableAlgorithm *ptalg);

static inline
struct symtab_IdentifierIndex *
TraversableAlgorithmGetPidin(struct symtab_TraversableAlgorithm *ptalg);


/// \struct
/// \struct traversable algorithm description
/// \struct

struct descr_TraversableAlgorithm
{
    int iHappy;
};


/// \struct
/// \struct struct symtab_TraversableAlgorithm
/// \struct

struct symtab_TraversableAlgorithm
{
    /// base struct: algorithm symbol

    struct symtab_AlgorithmSymbol algs;
};


#endif


