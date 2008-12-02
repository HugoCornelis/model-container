//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: defsym.h 1.16 Fri, 14 Sep 2007 22:28:37 -0500 hugo $
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



#ifndef DEFSYM_H
#define DEFSYM_H


#include <stdio.h>

#include "hines_list.h"


/// \struct
/// \struct defined symbols on a per file basis
/// \struct

struct DefinedSymbols
{
    /// list of dependency files

    HSolveList hslDependencyFiles;

    /// number of dependency files

    int iDependencyFiles;

    /// symbols from private models

    /// \note private models can contain cross references into foreign models
    /// \note meaning symbols not contained in this struct DefinedSymbols

    HSolveList hslPrivateModels;

    struct symtab_RootSymbol *prootPrivate;

    /// symbols from public models

    HSolveList hslPublicModels;

    struct symtab_RootSymbol *prootPublic;
};


#include "symboltable.h"


int DefSymAddPublicModel
(struct DefinedSymbols *pdefsym,
 struct symtab_HSolveListElement *phsle);

int DefSymAddPrivateModel
(struct DefinedSymbols *pdefsym,
 struct symtab_HSolveListElement *phsle);

struct DefinedSymbols *DefSymCalloc(void);

int DefSymInit(struct DefinedSymbols *pdefsym);

struct symtab_RootSymbol *
DefSymGetRootSymbol(struct DefinedSymbols *pdefsym);

int
DefSymIncrementDependencyFiles(struct DefinedSymbols *pdefsym);

struct symtab_HSolveListElement *
DefSymLookup
(struct DefinedSymbols *pdefsym,
 char *pcNameSpace,
 char *pcName,
 int iFlags);

#define FLAG_SYMBOL_DEPENDENCY		1
#define FLAG_SYMBOL_PRIVATEMODEL	2
#define FLAG_SYMBOL_PUBLICMODEL		4


int DefSymPrint
(struct DefinedSymbols *pdefsym,int iFlags,int iIndent,FILE *pfile);

int DefSymPrintNameSpaces
(struct DefinedSymbols *pdefsym,int iIndent,FILE *pfile);


#endif


