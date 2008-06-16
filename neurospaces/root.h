//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: root.h 1.15 Fri, 14 Sep 2007 22:28:37 -0500 hugo $
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



#ifndef ROOT_H
#define ROOT_H


#include <stdio.h>

#include "hines_list.h"
#include "symboltable.h"


//s
//s hypothetical root symbol
//s

struct symtab_RootSymbol
{
    //m base symbol

    struct symtab_HSolveListElement hsle;

    //m subsymbols

    HSolveList hslSubs;
};


#include "pidinstack.h"


//f exported functions

int
RootSymbolAddChild
(struct symtab_RootSymbol *phyro,struct symtab_HSolveListElement *phsle);

struct symtab_RootSymbol * RootSymbolCalloc(void);

void RootSymbolInit(struct symtab_RootSymbol *phyro);

struct symtab_HSolveListElement *
RootSymbolLookup(struct symtab_RootSymbol *phyro,char *pcName);

void RootSymbolFree(struct symtab_RootSymbol *phyro);

struct symtab_IdentifierIndex *
RootSymbolGetPidin(struct symtab_RootSymbol *phyro);

struct symtab_HSolveListElement *
RootSymbolLookupHierarchical
(struct symtab_RootSymbol *phyro,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);

int
RootSymbolPrint
(struct symtab_RootSymbol *phyro,int iIndent,FILE *pfile);

int
RootSymbolTraverse
(struct TreespaceTraversal *ptstr,
 struct symtab_RootSymbol *phyro);

int
RootSymbolTraverseSpikeGenerators
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
RootSymbolTraverseSpikeReceivers
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#endif


