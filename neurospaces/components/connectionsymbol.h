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


/// \struct structure declarations

struct descr_ConnectionSymbol;
struct symtab_ConnectionSymbol;


#include "neurospaces/treespacetraversal.h"



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


/// \struct
/// \struct connectionsymbol description
/// \struct

struct descr_ConnectionSymbol
{
    /// compiler happy

    int iHappy;

};


/// \struct
/// \struct struct symtab_ConnectionSymbol
/// \struct

struct symtab_ConnectionSymbol
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// connectionSymbol description

    struct descr_ConnectionSymbol de;
};


#endif


