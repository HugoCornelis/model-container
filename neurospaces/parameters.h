//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parameters.h 1.48 Sat, 10 Nov 2007 17:28:42 -0600 hugo $
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


#ifndef PARAMETERS_H
#define PARAMETERS_H


#include <stdio.h>

#include "double.h"
#include "idin.h"
/* #include "function.h" */


//v for error signalling

extern int iINT_MAX;

extern double dFLT_MAX;


//v table with description of types

#ifndef SWIG
extern char *ppcParameterStruct[];
#endif

#ifndef SWIG
extern char *ppcParameterStructShort[];
#endif


//s
//s parameters
//s

struct symtab_Parameters
{
    //m link structures into list

    struct symtab_Parameters *pparNext;

    //m first parameter of list

    struct symtab_Parameters *pparFirst;

    //m type of parameter

    int iType;

    //m flags

    int iFlags;

    //m name of parameter

    char *pcIdentifier;

    //m value : number, identifier or function for parameter

    union
    {
	double dNumber;
	struct symtab_IdentifierIndex *pidin;
	char *pcString;
	struct symtab_Function *pfun;
    }
    uValue;
};


//d parameter with symbolic value in idin (points to symbol, no numeric value)

#define TYPE_PARA_SYMBOLIC		1

//d parameter with numeric value in dNumber

#define TYPE_PARA_NUMBER		2

//d parameter with functional value in pidinFunction

#define TYPE_PARA_FUNCTION		3

//d parameter with field name in idin (points to field or IO, probably with a numeric value)

#define TYPE_PARA_FIELD			4

//d parameter for attribute, can have optionally a value in uValue

#define TYPE_PARA_ATTRIBUTE		5

//d parameter with a string

#define TYPE_PARA_STRING		6


//d parameter is read-only

#define FLAG_PARA_READONLY		1


//v table with description of types

#ifndef SWIG
extern char *ppcParameterStruct[];
#endif


//d give description of type of HSLE struct

#define ParameterTypeDescribe(iType)				\
    (ppcParameterStruct[(iType)])


//f static inline prototypes

#ifndef SWIG
static inline 
#endif
struct symtab_IdentifierIndex *
ParameterFirstIdin(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline 
#endif
char *
ParameterGetFieldName(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterGetFlags(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
char *ParameterGetName(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterGetType(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline 
#endif
struct symtab_Function *
ParameterGetFunction(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsField(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsFunction(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsNumber(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsReadOnly(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsString(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
int ParameterIsSymbolic(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
void
ParameterSetAttribute(struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
void 
ParameterSetFieldName
(struct symtab_Parameters *ppar, struct symtab_IdentifierIndex *pidinField);

#ifndef SWIG
static inline
#endif
void ParameterSetName(struct symtab_Parameters *ppar, char *pc);

#ifndef SWIG
static inline
#endif
void 
ParameterSetNumber
(struct symtab_Parameters *ppar, double dNumber);

#ifndef SWIG
static inline
#endif
void 
ParameterSetString
(struct symtab_Parameters *ppar, char *pc);

#ifndef SWIG
static inline
#endif
void 
ParameterSetSymbolName
(struct symtab_Parameters *ppar, struct symtab_IdentifierIndex *pidinSymbol);

#ifndef SWIG
static inline
#endif
void
ParameterSetType(struct symtab_Parameters *ppar, int iType);


//f static inlines

///
/// get first idin in field parameter
///

#ifndef SWIG
static inline 
#endif
struct symtab_IdentifierIndex *
ParameterFirstIdin(struct symtab_Parameters *ppar)
{
    return(ParameterIsField(ppar) || ParameterIsSymbolic(ppar)
	   ? ppar->uValue.pidin
	   : NULL);
}


///
/// get field name from parameter
///

#ifndef SWIG
static inline
#endif
char *
ParameterGetFieldName(struct symtab_Parameters *ppar)
{
    char *pcResult = NULL;

    struct symtab_IdentifierIndex *
    ParameterGetFieldPidin(struct symtab_Parameters *ppar);

    struct symtab_IdentifierIndex *pidinField
	= ParameterGetFieldPidin(ppar);

    if (pidinField)
    {
	pcResult = IdinName(pidinField);
    }

    return(pcResult);
}


///
/// get flags
///

#ifndef SWIG
static inline
#endif
int ParameterGetFlags(struct symtab_Parameters *ppar)
{
    return(ppar->iFlags);
}


///
/// get name
///

#ifndef SWIG
static inline
#endif
char *ParameterGetName(struct symtab_Parameters *ppar)
{
    return(ppar->pcIdentifier);
}


///
/// get type
///

#ifndef SWIG
static inline
#endif
int ParameterGetType(struct symtab_Parameters *ppar)
{
    return(ppar->iType);
}


///
/// get function from parameter
///

#ifndef SWIG
static inline
#endif
struct symtab_Function *
ParameterGetFunction(struct symtab_Parameters *ppar)
{
    return(ParameterIsFunction(ppar) ? ppar->uValue.pfun : NULL);
}


///
/// check if attribute
///

#ifndef SWIG
static inline
#endif
int ParameterIsAttribute(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_ATTRIBUTE);
}


///
/// check if field
///

#ifndef SWIG
static inline
#endif
int ParameterIsField(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_FIELD);
}


///
/// check if function
///

#ifndef SWIG
static inline
#endif
int ParameterIsFunction(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_FUNCTION);
}


///
/// check if number
///

#ifndef SWIG
static inline
#endif
int ParameterIsNumber(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_NUMBER);
}


///
/// check if read only
///

#ifndef SWIG
static inline
#endif
int ParameterIsReadOnly(struct symtab_Parameters *ppar)
{
    return(ParameterGetFlags(ppar) & FLAG_PARA_READONLY);
}


///
/// check if string
///

#ifndef SWIG
static inline
#endif
int ParameterIsString(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_STRING);
}


///
/// check if symbolic
///

#ifndef SWIG
static inline
#endif
int ParameterIsSymbolic(struct symtab_Parameters *ppar)
{
    return(ParameterGetType(ppar) == TYPE_PARA_SYMBOLIC);
}


///
/// flag parameter as attribute
///

#ifndef SWIG
static inline
#endif
void 
ParameterSetAttribute
(struct symtab_Parameters *ppar)
{
    ParameterSetType(ppar, TYPE_PARA_ATTRIBUTE);
}


///
/// set field name
///

#ifndef SWIG
static inline
#endif
void 
ParameterSetFieldName
(struct symtab_Parameters *ppar, struct symtab_IdentifierIndex *pidinField)
{
    ParameterSetType(ppar, TYPE_PARA_FIELD);

    ppar->uValue.pidin = pidinField;
}


///
/// set function
///

#ifndef SWIG
static inline
#endif
void 
ParameterSetFunction
(struct symtab_Parameters *ppar, struct symtab_Function *pfun)
{
    ParameterSetType(ppar, TYPE_PARA_FUNCTION);

    ppar->uValue.pfun = pfun;
}


///
/// set name
///

#ifndef SWIG
static inline
#endif
void ParameterSetName(struct symtab_Parameters *ppar, char *pc)
{
    ppar->pcIdentifier = pc;
}


///
/// set number value
///

#ifndef SWIG
static inline
#endif
void
ParameterSetNumber
(struct symtab_Parameters *ppar, double dNumber)
{
    ParameterSetType(ppar, TYPE_PARA_NUMBER);

    ppar->uValue.dNumber = dNumber;
}


///
/// set string value
///

#ifndef SWIG
static inline
#endif
void 
ParameterSetString
(struct symtab_Parameters *ppar, char *pc)
{
    ParameterSetType(ppar, TYPE_PARA_STRING);

    ppar->uValue.pcString = pc;
}


///
/// set symbol name
///

#ifndef SWIG
static inline
#endif
void 
ParameterSetSymbolName
(struct symtab_Parameters *ppar, struct symtab_IdentifierIndex *pidinSymbol)
{
    ParameterSetType(ppar, TYPE_PARA_SYMBOLIC);

    ppar->uValue.pidin = pidinSymbol;
}


///
/// set set parameter type
///

#ifndef SWIG
static inline
#endif
void
ParameterSetType(struct symtab_Parameters *ppar, int iType)
{
    ppar->iType = iType;
}


/* #include "pidinstack.h" */
struct PidinStack;


//f exported functions


struct symtab_Parameters * ParameterCalloc(void);

void ParameterFree(struct symtab_Parameters *ppar);

struct symtab_IdentifierIndex *
ParameterGetFieldPidin(struct symtab_Parameters *ppar);

char * ParameterGetString(struct symtab_Parameters *ppar);

struct symtab_Parameters * ParameterLookup
(struct symtab_Parameters * ppar, char *pcName);

struct symtab_Parameters *
ParameterNewFromFunction
(char *pcName, struct symtab_Function *pfun);

struct symtab_Parameters * 
ParameterNewFromNumber
(char *pcName, double dNumber);

struct symtab_Parameters * 
ParameterNewFromPidinQueue
(char *pcName, struct symtab_IdentifierIndex *pidin, int iType);

struct symtab_Parameters * 
ParameterNewFromString
(char *pcName, char *pcValue);

int ParameterPrint
(struct symtab_Parameters *ppar, int bAll, int iIndent, FILE *pfile);

struct symtab_HSolveListElement *
ParameterResolveFunctionalInput
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist,
 char *pcInput,
 int iPosition);

double
ParameterResolveScaledValue
(struct symtab_Parameters *ppar, struct PidinStack *ppist);

struct symtab_HSolveListElement *
ParameterResolveSymbol
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist);

struct PidinStack *
ParameterResolveToPidinStack
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist);

double
ParameterResolveValue
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist);

void ParameterTo_stdout(struct symtab_Parameters *ppar);

double ParameterValue(struct symtab_Parameters *ppar);


#endif


