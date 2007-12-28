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
//' Copyright (C) 1999-2007 Hugo Cornelis
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


//s
//s defined symbols on a per file basis
//s

struct DefinedSymbols
{
    //m list of dependency files

    HSolveList hslDependencyFiles;

    //m number of dependency files

    int iDependencyFiles;

    //m symbols from private models

    //! private models can contain cross references into foreign models
    //! meaning symbols not contained in this struct DefinedSymbols

    HSolveList hslPrivateModels;

    struct symtab_RootSymbol *prootPrivate;

    //m symbols from public models

    HSolveList hslPublicModels;

    struct symtab_RootSymbol *prootPublic;
};


//d
//d test type(pdefsym) == struct DefinedSymbols * at compile time
//d

#define CompileTimeTestDefinedSymbols(pdefsym)				\
do {									\
    struct DefinedSymbols defsym;					\
    (pdefsym) == &defsym;						\
} while (0)


//d
//d get namespace attached to this dependency file
//d

#define DefSymIncrementDependencyFiles(pdefsym)				\
({									\
    CompileTimeTestDefinedSymbols(pdefsym);				\
    (pdefsym)->iDependencyFiles++;					\
})


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
DefSymGetHyptheticalRoot(struct DefinedSymbols *pdefsym);

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


