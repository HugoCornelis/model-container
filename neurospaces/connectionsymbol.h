//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectionsymbol.h 1.4 Sat, 08 Sep 2007 10:08:38 -0500 hugo $
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


#ifndef CONNECTIONSYMBOL_H
#define CONNECTIONSYMBOL_H


#include <stdio.h>


//s structure declarations

struct descr_ConnectionSymbol;
struct symtab_ConnectionSymbol;


#include "treespacetraversal.h"


//f exported functions

struct symtab_ConnectionSymbol * ConnectionSymbolCalloc(void);

struct PidinStack *
ConnectionSymbolGetSpikeGenerator
(struct symtab_ConnectionSymbol *pconsy,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

struct PidinStack *
ConnectionSymbolGetSpikeReceiver
(struct symtab_ConnectionSymbol *pconsy,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

void ConnectionSymbolInit(struct symtab_ConnectionSymbol *pcell);

int ConnectionSymbolPrint
(struct symtab_ConnectionSymbol *pconsy, int bAll, int iIndent, FILE *pfile);

double
ConnectionSymbolGetDelay(struct symtab_ConnectionSymbol *pconsy);

int
ConnectionSymbolGetPost(struct symtab_ConnectionSymbol *pconsy);

int
ConnectionSymbolGetPre(struct symtab_ConnectionSymbol *pconsy);

double
ConnectionSymbolGetWeight(struct symtab_ConnectionSymbol *pconsy);


#include "biocomp.h"


//s
//s connectionsymbol description
//s

struct descr_ConnectionSymbol
{
    //m compiler happy

    int iHappy;

};


//s
//s struct symtab_ConnectionSymbol
//s

struct symtab_ConnectionSymbol
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m connectionSymbol description

    struct descr_ConnectionSymbol de;
};


#endif


