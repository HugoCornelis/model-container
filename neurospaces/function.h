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


/// \struct
/// \struct function description
/// \struct

struct symtab_Function
{
    /// parameters

    struct symtab_ParContainer *pparc;

    /// name of function

    char *pcName;
};


#include "pidinstack.h"



int
FunctionAssignParameters
(struct symtab_Function *pfun, struct symtab_Parameters *ppar);

int FunctionAllowsScaling(struct symtab_Function *pfun);

struct symtab_Function * FunctionCalloc(void);

char *
FunctionGetName(struct symtab_Function *pfun);

struct symtab_Parameters *
FunctionGetParameter(struct symtab_Function *pfun, char *pc);

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


