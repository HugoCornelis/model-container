//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: function.h 1.26 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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


#ifndef FUNCTION_H
#define FUNCTION_H


#include "parameters.h"
#include "parcontainer.h"


//s
//s function description
//s

struct symtab_Function
{
    //m parameters

    struct symtab_ParContainer *pparc;

    //m name of function

    char *pcName;
};


//d
//d test type(pfun) == struct symtab_Function * at compile time
//d

#define CompileTimeTestFunction(pfun)					\
do {									\
    struct symtab_Function fun;						\
    (pfun) == &fun;							\
} while (0)


//d
//d test type(ppar) == struct symtab_Parameters * at compile time
//d

#define CompileTimeTestParameter(ppar)					\
do {									\
    struct symtab_Parameters par;					\
    (ppar) == &par;							\
} while (0)


//d
//d get field name
//d

#define FunctionGetName(pfun)						\
({									\
    CompileTimeTestFunction(pfun);					\
									\
    (pfun)->pcName;							\
})

//d
//d get parameter
//d

#define FunctionGetParameter(pfun,pc)					\
({									\
    CompileTimeTestFunction(pfun);					\
									\
    ParContainerLookupParameter((pfun)->pparc,(pc));			\
})

#include "pidinstack.h"


//f exported functions

int
FunctionAssignParameters
(struct symtab_Function *pfun, struct symtab_Parameters *ppar);

int FunctionAllowsScaling(struct symtab_Function *pfun);

struct symtab_Function * FunctionCalloc(void);

void FunctionInit(struct symtab_Function *pfun);

int FunctionPrint
(struct symtab_Function *pfun,int bAll,int iIndent,FILE *pfile);

struct symtab_HSolveListElement *
FunctionResolveInput
(struct symtab_Function *pfun,
 struct PidinStack *ppist,
 char *pcInput,
 int iPosition);

int
FunctionSetName
(struct symtab_Function *pfun, char *pcName);

double
FunctionValue
(struct symtab_Function *pfun, struct PidinStack *ppist);


#endif


