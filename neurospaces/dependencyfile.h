//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: dependencyfile.h 1.9 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#ifndef DEPENDENCYFILE_H
#define DEPENDENCYFILE_H


#include "importedfile.h"
#include "symboltable.h"


/// \struct
/// \struct one dependency file
/// \struct
/// \struct A dependency file is valid if it is already imported. we use this to
/// \struct link this structure with struct ImportedFile
/// \struct

struct DependencyFile
{
    /// links elements in list

    HSolveListElement hsleLink;

    /// name space

    char *pcNamespace;

    /// pointer to imported file its symbols

    struct ImportedFile *pifSymbols;
};


struct DependencyFile *
DependencyFileCallocNameSpaceImportedFile(char *pc, struct ImportedFile *pif);

struct ImportedFile *
DependencyFileGetImportedFile(struct DependencyFile *pdf);

char *
DependencyFileGetNameSpace(struct DependencyFile *pdf);

int
DependencyFilePrint
(struct DependencyFile *pdf, int iIndent, int iType, FILE *pfile);

int
DependencyFileSetImportedFile
(struct DependencyFile *pdf, struct ImportedFile *pif);

int
DependencyFileSetNameSpace
(struct DependencyFile *pdf, char *pc);


#endif


