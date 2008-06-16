//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parsersupport.h 1.44 Sat, 13 Oct 2007 20:56:19 -0500 hugo $
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
** parser support routines
*/

#ifndef PARSERSUPPORT_H
#define PARSERSUPPORT_H

#include <stdio.h>
#include <stdlib.h>

struct ParserContext;
typedef struct ParserContext PARSERCONTEXT;


#include "neurospaces.h"
#include "hines_list.h"
#include "hines_listlist.h"
#include "idin.h"
#include "pidinstack.h"
#include "symboltable.h"



#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


struct ParserContext
{
    //m link to next, previous context

    struct ParserContext *pacNext;
    struct ParserContext *pacPrev;

    //m filename from this context

    char *pcFilename;

    //m directory name from this context
    //m ending in '/' or empty string

    char *pcDirectory;

    //m current line number

    int iLineNumber;

    //m nesting level of imported files

    int iNestingLevel;

    //m pointer to ANSI FILE structure

    FILE *pFILE;

    //m lexical state for this parser context

    struct yy_buffer_state *pyyBuffer;

    //m pointer to currently parsed file its symbols

    struct ImportedFile *pifInParse;

    //m pointer to neurospaces (with e.g. symbol table)

    struct Neurospaces *pneuro;

    //m state of parser context

    int iState;

    //m current element stack : max depth is 20 at the moment

    struct PidinStack pist;

    //m current element being defined

    //m this should be set after the symbol has been defined,
    //m before the symbol is added
    //m such that the symbol can first be inspected before
    //m being added
    //m e.g. by spine algorithm, cell position filter etc.

    struct symtab_HSolveListElement *phsleActual;
};


//d parsing header

#define PARSER_STATE_HEADER		1

//d parsing dependencies

#define PARSER_STATE_DEPENDENCIES	2

//d parsing private models

#define PARSER_STATE_PRIVATEMODELS	3

//d parsing public models

#define PARSER_STATE_PUBLICMODELS	4


//d parser context is root context

#define PARSER_FLAG_ROOTCONTEXT		8


//d all parsing states

#define PARSER_MASK_STATES		7


//f static inline prototypes

#ifndef SWIG
static inline 
#endif
char * ParserContextGetDirectory(PARSERCONTEXT *pacContext);

#ifndef SWIG
static inline 
#endif
char * ParserContextGetFilename(PARSERCONTEXT *pacContext);

#ifndef SWIG
static inline 
#endif
int ParserContextGetLineNumber(PARSERCONTEXT *pacContext);


///
/// get associated directory
///

#ifndef SWIG
static inline 
#endif
char * ParserContextGetDirectory(PARSERCONTEXT *pacContext)
{
    return(pacContext->pcDirectory);
}


///
/// get associated filename
///

#ifndef SWIG
static inline 
#endif
char * ParserContextGetFilename(PARSERCONTEXT *pacContext)
{
    return(pacContext->pcFilename);
}


///
/// get associated line number
///

#ifndef SWIG
static inline 
#endif
int ParserContextGetLineNumber(PARSERCONTEXT *pacContext)
{
    return(pacContext->iLineNumber);
}


//d
//d test type(pac) == struct ParserContext * at compile time
//d

#define CompileTimeTestParserContext(pac)				\
do {									\
    struct ParserContext ac;						\
    (pac) == &ac;							\
} while (0)


//d
//d get imported file attached to parser context
//d

#define ParserContextGetImportedFile(pac)				\
({									\
    CompileTimeTestParserContext(pac);					\
    (pac)->pifInParse;							\
})


//d
//d get current pidin context stack
//d

#define ParserContextGetPidinContext(pac)				\
({									\
    CompileTimeTestParserContext(pac);					\
    &(pac)->pist;							\
})


//d
//d get parser state
//d

#define ParserContextGetState(pac)					\
({									\
    CompileTimeTestParserContext(pac);					\
    (pac)->iState & PARSER_MASK_STATES;					\
})


#include "algorithminstance.h"
#include "algorithmsymbol.h"


// parsing function itself

int parserparse(void *);


// support functios

int ParserAddModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle);

/* static */ int ParserAddPrivateModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle);

/* static */ int ParserAddPublicModel
(PARSERCONTEXT *pacContext,
 struct symtab_HSolveListElement *phsle);

PARSERCONTEXT *ParserContextCalloc(void);

void ParserClearContext(void);

void ParserClearRootContext(void);

struct symtab_Vector * ParserContextActualContainer(void);

void * ParserContextActualState(void);

struct symtab_HSolveListElement *ParserContextGetActual(PARSERCONTEXT *pac);

void ParserContextInit(PARSERCONTEXT *pac);

struct symtab_Vector * ParserContextPopContainer(void);

void * ParserContextPopAlgorithmState(void);

void *ParserContextPopState(void);

int ParserContextPushContainer(struct symtab_Vector * pvect);

int ParserContextPushAlgorithmState(void *pv);

#define PARSERSTATE_ALGORITHM			((void *)	-1)

#define PARSERSTATE_START_ALGORITHMS		((void *)	-2)


int ParserContextPushState(void *pv);

char *ParserContextQualifyFilename(PARSERCONTEXT *pac,char *pc);

char *ParserContextQualifyToConfiguration(PARSERCONTEXT *pac, char *pc);

char *ParserContextQualifyToParsingDirectory(PARSERCONTEXT *pac,char *pc);

char *ParserContextQualifyToEnvironment(char *pc);

struct symtab_HSolveListElement *
ParserContextSetActual
(PARSERCONTEXT *pac,struct symtab_HSolveListElement *phsle);

void ParserContextSetImportedFile(PARSERCONTEXT *pac,struct ImportedFile *pif);

struct symtab_IdentifierIndex * 
ParserCurrentElementPop
(PARSERCONTEXT *pac);

void ParserCurrentElementPopAll(PARSERCONTEXT *pac);

int ParserCurrentElementPush
(PARSERCONTEXT *pac,struct symtab_IdentifierIndex *pidinName);

void ParserFinish(void);

int
ParserImport
(PARSERCONTEXT *pacParserContext,
 char *pcFilename,
 char *pcNameSpace);

struct symtab_HSolveListElement *
ParserLookupDependencyModel
(PARSERCONTEXT *pacContext,struct symtab_IdentifierIndex *pidin);

struct symtab_HSolveListElement *
ParserLookupPrivateModel(char *pcIdentifier);

struct symtab_HSolveListElement *
ParserLookupSymbol
(struct PidinStack *ppist, struct symtab_IdentifierIndex *pidin);

int ParserMessage
(PARSERCONTEXT *pacContext,
 int iPriority,
 char *pcContext,
 char *pcMessage,...);

int ParserAlgorithmDisable
(PARSERCONTEXT *pacContext,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance,
 char *pcInit);

int
ParserAlgorithmHandle
(PARSERCONTEXT *pac,
 struct symtab_HSolveListElement *phsle,
 struct AlgorithmInstance *palgi,
 char *pcName,
 char *pcInstance,
 char *pcInit);

struct AlgorithmInstance *
ParserAlgorithmImport
(PARSERCONTEXT *pacContext,
 char *pcName,
 char *pcInstance,
 char *pcInit,
 struct symtab_Parameters *ppar,
 struct symtab_AlgorithmSymbol *palgs);

int ParserParse
(PARSERCONTEXT *pacParserContext,
 struct ImportedFile *pifToParse);

void ParserSetContext(PARSERCONTEXT *pac);

void ParserSetRootContext(PARSERCONTEXT *pac);

void ParserStart(void);


#endif


