//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: importedfile.h 1.22 Sat, 13 Oct 2007 20:56:19 -0500 hugo $
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



#ifndef IMPORTEDFILE_H
#define IMPORTEDFILE_H


#include "defsym.h"
#include "neurospaces.h"
#include "hines_list.h"


/// \struct one imported file

struct ImportedFile
{
    /// links elements in list

    HSolveListElement hsleLink;

    /// name of imported file, qualified filename

    char *pcQualified;

    /// name of imported file, relative filename

    char *pcRelative;

    /// flags (ao level type of file, file not found)

    int iFlags;

    /// defined symbols for this file

    struct DefinedSymbols *pdefsym;

    /// \todo add kind dependency list ?
    /// \todo check NeurospacesImport() for this
};


#define IMPORTEDFILE_FLAG_ROOT		1


#include "pidinstack.h"


struct ImportedFile *
ImportedFileCalloc(char *pcQualified, char *pcRelative);

void ImportedFileClearRootImport(void);

struct DependencyFile *
ImportedFileFindDependencyFile(struct ImportedFile *pif, char *pc);

struct symtab_RootSymbol *ImportedFileGetBaseRootSymbol(void);

struct DefinedSymbols *
ImportedFileGetDefinedSymbols(struct ImportedFile *pif);

char *
ImportedFileGetQualified(struct ImportedFile *pif);

char *
ImportedFileGetRelative(struct ImportedFile *pif);

struct symtab_RootSymbol *
ImportedFileGetRootSymbol(struct ImportedFile *pif);

struct ImportedFile *ImportedFileGetRootImport(void);

struct symtab_HSolveListElement *
ImportedFileLookupHierarchical
(struct ImportedFile *pif,
 struct PidinStack *ppist,
 int iLevel);

struct ImportedFile *
ImportedFileLookupNameSpace
(struct ImportedFile *pif,
 struct PidinStack *ppist,
 int *piLevel);

int
ImportedFilePrint
(struct ImportedFile *pif, int iIndent, int iType, FILE *pfile);

int ImportedFilePrintNameSpaces
(struct ImportedFile *pif, int iIndent, FILE *pfile);

void ImportedFilePrintRootImport(void);

int ImportedFilePrintProperties
(struct ImportedFile *pif, int iIndent, FILE *pfile);

int
ImportedFileSetDefinedSymbols
(struct ImportedFile *pif, struct DefinedSymbols *pdefsym);

int
ImportedFileSetFilenames
(struct ImportedFile *pif, char *pcQualified, char *pcRelative);

void ImportedFileSetRootImport(struct ImportedFile *pif);


#endif


