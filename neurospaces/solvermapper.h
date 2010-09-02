//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: solvermapper.h 1.6 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#ifndef SOLVERMAPPER_H
#define SOLVERMAPPER_H


#include "neurospaces.h"
#include "pidinstack.h"
#include "symboltable.h"


/// function to call to do setup of solution engine.
/// 
/// \return int : success of operation

typedef 
int 
NeurospacesSetupSymbol
(struct Neurospaces *pneuro,
 void *pvUserdata,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);


/// \struct create array of this one to map named solver classes to solution
/// \struct engines.

struct SolverMapper
{
    char *pcSolverClass;
    int iSymbolType;
    void *pvUserdata;
    NeurospacesSetupSymbol *setup;
};


#endif


