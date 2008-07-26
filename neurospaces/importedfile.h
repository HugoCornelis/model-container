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


//s
//s one imported file
//s

struct ImportedFile
{
    //m links elements in list

    HSolveListElement hsleLink;

    //m name of imported file

    char *pcFilename;

    //m flags (ao level type of file, file not found)

    int iFlags;

    //m defined symbols for this file

    struct DefinedSymbols *pdefsym;

    //t add kind dependency list ?
    //t check NeurospacesImport() for this
};


#define IMPORTEDFILE_FLAG_ROOT		1


//d
//d test type(pif) == struct ImportedFile * at compile time
//d

#define CompileTimeTestImportedFile(pif)				\
do {									\
    struct ImportedFile imported;					\
    (pif) == &imported;							\
} while (0)


//d
//d set defined symbols for an imported file
//d

#define ImportedFileGetDefinedSymbols(pif)				\
({									\
    CompileTimeTestImportedFile(pif);					\
    (pif)->pdefsym;							\
})


//d
//d get filename for an imported file
//d

#define ImportedFileGetFilename(pif)					\
({									\
    CompileTimeTestImportedFile(pif);					\
    (pif)->pcFilename;							\
})


//d
//d set set of defined symbols for an imported file
//d

#define ImportedFileSetDefinedSymbols(pif,pds)				\
({									\
    CompileTimeTestImportedFile(pif);					\
    (pif)->pdefsym = (pds);						\
})


//d
//d set filename for an imported file
//d

#define ImportedFileSetFilename(pif,pc)					\
({									\
    CompileTimeTestImportedFile(pif);					\
    (pif)->pcFilename = (pc);						\
})


#include "pidinstack.h"


struct ImportedFile *ImportedFileCalloc(char *pc);

void ImportedFileClearRootImport(void);

struct DependencyFile *
ImportedFileFindDependencyFile(struct ImportedFile *pif,char *pc);

struct symtab_RootSymbol *ImportedFileGetBaseRootSymbol(void);

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

int ImportedFilePrint(struct ImportedFile *pif,int iIndent,FILE *pfile);

int ImportedFilePrintNameSpaces
(struct ImportedFile *pif,int iIndent,FILE *pfile);

void ImportedFilePrintRootImport(void);

int ImportedFilePrintProperties
(struct ImportedFile *pif,int iIndent,FILE *pfile);

void ImportedFileSetRootImport(struct ImportedFile *pif);


#endif


