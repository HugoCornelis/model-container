//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: neurospaces.h 1.74 Sat, 13 Oct 2007 20:48:28 -0500 hugo $
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


/*
**	main neurospaces header
*/

#ifndef NEUROSPACES_H
#define NEUROSPACES_H

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <sys/time.h>
#include <unistd.h>

struct ParserContext;
struct Neurospaces;
struct ProjectionQuery;


#include "cacheregistry.h"
#include "solvermapper.h"
#include "symbols.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


struct NeurospacesOptions
{
    //m option flags

    int iFlags;

    //m verbosity level

    int iVerbosity;

    //m debug file

    FILE *pfileDebug;

    //m timing report level

    int iTiming;

    //m start of timings

    struct timeval tvStart;

    //m model library

    char *pcModelLibrary;
};


#define NSOFLAG_DEBUGFILE			1
#define NSOFLAG_DISABLE_ALGORITHM_HANDLING	2
#define NSOFLAG_DISABLE_DEPCY_LOOKUP		4
#define NSOFLAG_DISABLE_IMPORTING		8
#define NSOFLAG_DISABLE_PRIVATE_LOOKUP		16
#define NSOFLAG_DISABLE_PUBLIC_LOOKUP		32
#define NSOFLAG_DISABLE_READLINE		64
#define NSOFLAG_EXCLUSIVEVERBOSE		128
#define NSOFLAG_HELP				256
#define NSOFLAG_IMPORTPRINT			512
#define NSOFLAG_PARSERDEBUG			1024
#define NSOFLAG_PRINTALGORITHMINFO		2048
#define NSOFLAG_PRINTSYMBOLTABLE		4096
#define NSOFLAG_QUERYMACHINE			8192
#define NSOFLAG_TIMINGS				16384
#define NSOFLAG_VERBOSE				32768


struct NeurospacesConfig
{
    //m original command line

    int iArgc;

    char **ppcArgv;

    //m options on command line

    struct NeurospacesOptions nso;

    //m \0 separated list of files to parse

    char pcFiles[10000];

    //m \0 separated list of query machine commands to execute

    char pcQueries[10000];
};


struct Neurospaces
{
    //m symbol table

    struct Symbols *psym;

    //m current projection query

    struct ProjectionQuery *ppq;

    //m solver mappers

    struct SolverMapper *psm;

    //m parsed command line

    struct NeurospacesConfig *pnsc;

    //m root parser context

    struct ParserContext *pacRootContext;

    //m cumulative number of errors so far

    int iErrorCount;

    //m cumulative number of files parsed

    int iFileParseCount;

    //m cache registry

    struct CacheRegistry *pcr;
};


#define YYPARSE_PARAM pacParserContext
#define YYLEX_PARAM pacParserContext

/* #ifdef DEBUGPARSER */
/* extern int parserdebug; */
/* #define YYDEBUG 1 */
/* #endif */
#ifndef SWIG
extern char parsertext[];
#endif
extern int parserleng;
extern FILE *parserin;


#include "parsersupport.h"


int
NeurospacesError(PARSERCONTEXT *pacContext, char *pcParser, char *pcError, ...);

char * NeurospacesGetVersion(void);

int NeurospacesHelp(int argc,char **argv);

int
NeurospacesImport
(struct Neurospaces *pneuro,
 char *pcAppl);

int
NeurospacesLogFileTree
(PARSERCONTEXT *pacContext, char *pcError,...);

#ifndef SWIG

//t I guess the va_list stuff gives problems on 64bit architectures.

int
NeurospacesMessage
(int iPriority,
 int iContext,
 char *pcFormat,
 va_list vaList);
#endif

//d message priority levels

//d level for important messages

#define LEVEL_GLOBALMSG_IMPORTANT	(5)

//d report import of files

#define LEVEL_GLOBALMSG_FILEIMPORT	(-10)

//d report import of algorithms

#define LEVEL_GLOBALMSG_ALGORITHMIMPORT	(-20)

//d report actions taken on 'END {PRIVATE,PUBLIC}_MODELS' etc.

#define LEVEL_GLOBALMSG_SYMBOLREPORT	(-30)

//d report add of symbols

#define LEVEL_GLOBALMSG_SYMBOLADD	(-40)

//d report creation of symbols

#define LEVEL_GLOBALMSG_SYMBOLCREATE	(-50)


char *
NeurospacesQualifyFilename(struct Neurospaces *pneuro, char *pc);

char *
NeurospacesQualifyToConfiguration(struct Neurospaces *pneuro, char *pc);

int NeurospacesRead(struct Neurospaces *pneuro, int argc, char **argv);

int NeurospacesRemoveProjectionQuery(struct Neurospaces *pneuro);

int
NeurospacesSetProjectionQuery
(struct Neurospaces *pneuro, struct ProjectionQuery *ppq);

int
NeurospacesSetSolverMapper
(struct Neurospaces *pneuro, struct SolverMapper *psm);

int
NeurospacesSetupSolverInstance
(struct Neurospaces *pneuro,
 char *pcName,
 struct PidinStack *ppist);


struct Neurospaces *NeurospacesNew(void);

struct Neurospaces *
NeurospacesNewFromCmdLine(int argc, char **argv);


#endif


