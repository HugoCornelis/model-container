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


//s
//s one dependency file
//s
//s A dependency file is valid if it is already imported. we use this to
//s link this structure with struct ImportedFile
//s

struct DependencyFile
{
    //m links elements in list

    HSolveListElement hsleLink;

    //m name space

    char *pcNameSpace;

    //m pointer to imported file its symbols

    struct ImportedFile *pifSymbols;
};


//d
//d test type(pdf) == struct DependencyFile * at compile time
//d

#define CompileTimeTestDependencyFile(pdf)				\
do {									\
    struct DependencyFile df;						\
    (pdf) == &df;							\
} while (0)


//d
//d get namespace attached to this dependency file
//d

#define DependencyFileGetImportedFile(pdf)				\
({									\
    CompileTimeTestDependencyFile(pdf);					\
    (pdf)->pifSymbols;							\
})


//d
//d get namespace attached to this dependency file
//d

#define DependencyFileGetNameSpace(pdf)					\
({									\
    CompileTimeTestDependencyFile(pdf);					\
    (pdf)->pcNameSpace;							\
})


//d
//d set namespace attached to this dependency file
//d

#define DependencyFileSetImportedFile(pdf,pif)				\
({									\
    CompileTimeTestDependencyFile(pdf);					\
    (pdf)->pifSymbols = (pif);						\
})


//d
//d set namespace attached to this dependency file
//d

#define DependencyFileSetNameSpace(pdf,pc)				\
({									\
    CompileTimeTestDependencyFile(pdf);					\
    (pdf)->pcNameSpace = (pc);						\
})


struct DependencyFile *
DependencyFileCallocNameSpaceImportedFile(char *pc,struct ImportedFile *pif);

int DependencyFilePrint
(struct DependencyFile *pdf,int iIndent,FILE *pfile);


#endif


