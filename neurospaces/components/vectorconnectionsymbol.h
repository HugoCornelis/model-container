//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorconnectionsymbol.h 1.15 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef VECTORCONNECTIONSYMBOL_H
#define VECTORCONNECTIONSYMBOL_H


#include <stdio.h>


//s structure declarations

struct descr_VConnectionSymbol;
struct symtab_VConnectionSymbol;


//f exported functions

struct symtab_VConnectionSymbol * VConnectionSymbolCalloc(void);

struct symtab_HSolveListElement * 
VConnectionSymbolCreateAlias
(struct symtab_VConnectionSymbol *pvconsy,
 struct symtab_IdentifierIndex *pidin);

void VConnectionSymbolInit(struct symtab_VConnectionSymbol *pvconsy);


#include "vector.h"


//s
//s vector description
//s

struct descr_VConnectionSymbol
{
    int iHappy;
};


//s
//s struct symtab_VConnection
//s

struct symtab_VConnectionSymbol
{
    //m base struct : vector

    struct symtab_Vector vect;

    //m enumeration container

    struct descr_VConnectionSymbol devconsy;
};


#endif


