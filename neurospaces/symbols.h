//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: symbols.h 1.52 Sat, 13 Oct 2007 20:56:19 -0500 hugo $
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


/*
** symbol table main header
*/

#ifndef SYMBOLS_H
#define SYMBOLS_H

#include <stdio.h>
#include <stdlib.h>


/// \struct structure declarations

struct Symbols;


#include "neurospaces.h"
#include "algorithmset.h"
#include "pidinstack.h"
#include "symboltable.h"



#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// \struct global symbol table

struct Symbols
{
    /// list of imported files

    HSolveList hslFiles;

    /// set of algorithms

    AlgorithmSet *pas;
};


//#include "defsym.h"


struct ImportedFile *
SymbolsAddImportedFile
(struct Symbols *psymSymbols,
 char *pcQualified,
 char *pcRelative,
 struct ParserContext *pac);

struct Symbols * SymbolsCalloc(void);

struct ImportedFile *
SymbolsLookupImportedFile
(struct Symbols *psymSymbols,
 char *pcFilename,
 struct ParserContext *pac);

int SymbolsPrintImportedFiles(struct Symbols *psymSymbols, FILE *pfile);

int SymbolsInitialize(struct Symbols *psymSymbols);

struct symtab_HSolveListElement *
SymbolsLookupHierarchical
(struct Symbols *pisSymbols,
 struct PidinStack *ppist);

struct ImportedFile *
SymbolsLookupNameSpace
(struct Symbols *pisSymbols,
 struct PidinStack *ppist);


#define PrintIndent(iIndent,pfile) fprintf((pfile), "%-.*s", (iIndent), "                                                  ")
#define MoreIndent(iIndent) ((iIndent) + 4)
#define LessIndent(iIndent) ((iIndent) - 4)

#define PrintSymbolIndent(phsle, iIndent, pfile)			\
do									\
{									\
    PrintIndent(iIndent,pfile);						\
    fprintf								\
      (pfile,								\
       "%s",								\
       SymbolHSLETypeDescribeWith6Letters((phsle)->iType));		\
}									\
while (0)

int SymbolsPrint(struct Symbols *pisSymbols, int iType, FILE *pfile);

int SymbolsPrintModel
(struct symtab_HSolveListElement *phsle, int iIndent, FILE *pfile);


#endif


