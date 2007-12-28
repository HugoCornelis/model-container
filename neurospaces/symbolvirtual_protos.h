//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: symbolvirtual_protos.h 1.94 Thu, 15 Nov 2007 13:04:36 -0600 hugo $
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



#ifndef SYMBOLVIRTUAL_PROTOS_H
#define SYMBOLVIRTUAL_PROTOS_H


#include "biolevel.h"
//#include "iohier.h"
#include "idin.h"
#include "positionD3.h"
#include "symboltable.h"


#include "hierarchy/output/symbols/long_descriptions.h"

#include "hierarchy/output/symbols/short_descriptions.h"


extern int iTotalAllocatedSymbols;


//d give description of type of HSLE struct

#define SymbolHSLETypeDescribe(iType)					\
    (ppc_symbols_long_descriptions[(iType)])


//d give 6 letter description of type of HSLE struct

#define SymbolHSLETypeDescribeWith6Letters(iType)			\
    (ppc_symbols_short_descriptions[(iType)])


//d
//d test type(phsle) == struct symtab_HSolveListElement * at compile time
//d

#define CompileTimeTestSymbol(phsle)					\
do {									\
    struct symtab_HSolveListElement hsle;				\
    (phsle) == &hsle;							\
} while (0)


//d
//d get next symbol in list
//d

#define SymbolContainerNext(phsle)					\
({									\
    CompileTimeTestSymbol(phsle);					\
    (struct symtab_HSolveListElement *)HSolveListNext(&phsle->hsleLink);\
})


//d
//d test if valid result after iteration
//d

#define SymbolIterateValid(phsle)					\
({									\
    CompileTimeTestSymbol(phsle);					\
    HSolveListValidSucc(&(phsle)->hsleLink);				\
})


//d
//d set solver info
//d

#define SymbolSetFlags(phsle,iF)					\
({									\
    CompileTimeTestSymbol(phsle);					\
    (phsle)->iFlags |= (iF);						\
})


/* //d give index of HSLE struct, should always be -1, 0 now for */
/* //d compatibility, but will be changed some time. */

/* #define SymbolIndex(phsle) (-1) */

/* #define SymbolIndex(phsle)						\ */
/* ({									\ */
/*     struct symtab_IdentifierIndex *pidin				\ */
/* 	= SymbolGetPidin(phsle);					\ */
/*     pidin ? IdinIndex(pidin) : -1;					\ */
/* }) */


//d give name of HSLE struct, NULL for none

#define SymbolName SymbolGetName

/* #define SymbolName(phsle)						\ */
/* ({									\ */
/*     struct symtab_IdentifierIndex *pidin				\ */
/* 	= SymbolGetPidin(phsle);					\ */
/*     pidin ? IdinName(pidin) : NULL;					\ */
/* }) */


//f static inline prototypes

#ifndef SWIG
static inline
#endif
int SymbolGetFlags(struct symtab_HSolveListElement *phsle);


#include <stdlib.h>

/* #include "iohier.h" */
#include "algorithminstance.h"
#include "treespacetraversal.h"
#include "vtable.h"


//f static inlines

///
/// get flags of symbol.
///

#ifndef SWIG
static inline
#endif
int SymbolGetFlags(struct symtab_HSolveListElement *phsle)
{
    return(phsle->iFlags);
}


#include "inputoutput.h"


//f exported functions

//t should go to the library of selectors and processors.

int SymbolDeleter(struct TreespaceTraversal *ptstr, void *pvUserdata);


struct symtab_Parameters *
SymbolCacheParameterDouble
(struct symtab_HSolveListElement *phsle, int iSerial, char *pcName, double dNumber);

struct symtab_Parameters *
SymbolCacheParameterString
(struct symtab_HSolveListElement *phsle, int iSerial, char *pcName, char *pcValue);

struct symtab_HSolveListElement *
SymbolCalloc(size_t nmemb, size_t size, VTable_symbols * _vtable, int iType);

struct symtab_Parameters *
SymbolFindCachedParameter
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist);

struct symtab_Parameters *
SymbolFindParameter
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist);

int SymbolFree(struct symtab_HSolveListElement *phsle);

struct AlgorithmInstance *
SymbolGetAlgorithmInstanceInfo(struct symtab_HSolveListElement *phsle);

int
SymbolGetWorkloadIndividual
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

void SymbolInit(struct symtab_HSolveListElement * phsle);

int
SymbolParameterResolveCoordinateValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistCoord,
 struct D3Position *pD3Coord);

double
SymbolParameterResolveScaledValue
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppist);

int
SymbolParameterTransformValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct symtab_Parameters *ppar,
 struct D3Position *pD3);

double
SymbolParameterResolveTransformedValue
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistCoord,
 char *pcName);

struct PidinStack *
SymbolPrincipalSerial2Context
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 int iPrincipal);

int SymbolRecalcAllSerials
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

int
SymbolSetAlgorithmInstanceInfo
(struct symtab_HSolveListElement *phsle,struct AlgorithmInstance *palgi);

struct symtab_Parameters *
SymbolSetParameterFixedDouble
(struct symtab_HSolveListElement *phsle,
 char *pcName,
 double dNumber,
 struct PidinStack *ppist);

int
SymbolTraverseBioLevels
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct BiolevelSelection *pbls,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
SymbolTraverseTagged
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
SymbolTraverseWildcard
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "hierarchy/output/symbols/all_callees_headers.h"


#endif


