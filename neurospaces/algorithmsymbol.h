//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmsymbol.h 1.8 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef ALGORITHMSYMBOL_H
#define ALGORITHMSYMBOL_H


#include <float.h>
#include <stdio.h>


//s structure declarations

struct descr_AlgorithmSymbol;
struct symtab_AlgorithmSymbol;


#include "algorithminstance.h"
#include "idin.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_AlgorithmSymbol *AlgorithmSymbolCalloc(void);

struct symtab_HSolveListElement *
AlgorithmSymbolCreateAlias
(struct symtab_AlgorithmSymbol *palgs,
 struct symtab_IdentifierIndex *pidin);

int
AlgorithmSymbolInit(struct symtab_AlgorithmSymbol *palgs);

int
AlgorithmSymbolSetAlgorithmInstance
(struct symtab_AlgorithmSymbol *palgs,
 struct AlgorithmInstance *palgi);

int
AlgorithmSymbolTraverse
(struct TreespaceTraversal *ptstr, struct symtab_AlgorithmSymbol *palgs);


#include "parcontainer.h"
#include "symboltable.h"


//f inline prototypes

#ifndef SWIG
static inline
#endif
int
AlgorithmSymbolAssignParameters
(struct symtab_AlgorithmSymbol *palgs, struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
AlgorithmSymbolChangeParameter
(struct symtab_AlgorithmSymbol * palgs,struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
char *
AlgorithmSymbolGetName(struct symtab_AlgorithmSymbol *palgs);

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
AlgorithmSymbolGetParameter
(struct symtab_AlgorithmSymbol * palgs,
 char *pcName,
 struct PidinStack *ppist);

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
AlgorithmSymbolGetPidin(struct symtab_AlgorithmSymbol *palgs);

#ifndef SWIG
static inline
#endif
double
AlgorithmSymbolParameterResolveValue
(struct symtab_AlgorithmSymbol *palgs, char *pcName, struct PidinStack *ppist);


//s
//s algorithm symbol description
//s

struct descr_AlgorithmSymbol
{
    //m algorithm instance

    struct AlgorithmInstance *palgi;

    //m symbol table identifier, should be same as name of the algorithm instance

    struct symtab_IdentifierIndex *pidin;
};


//s
//s struct symtab_AlgorithmSymbol
//s

struct symtab_AlgorithmSymbol
{
    //m base struct : symbol

    struct symtab_HSolveListElement hsle;

    //m algorithm symbol description

    struct descr_AlgorithmSymbol dealgs;

    //m parameters

    struct symtab_ParContainer *pparc;

};


#include "symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: AlgorithmSymbolAssignParameters()
///
/// ARGS.:
///
///	palgs...: symbol to assign parameters to.
///	ppar...: new parameters.
///
/// RTN..: int : success of operation.
///
/// DESCR: Assign parameter to symbol.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
int
AlgorithmSymbolAssignParameters
(struct symtab_AlgorithmSymbol *palgs, struct symtab_Parameters *ppar)
{
    return(ParContainerAssignParameters(palgs->pparc, ppar));
}


/// **************************************************************************
///
/// SHORT: AlgorithmSymbolChangeParameter()
///
/// ARGS.:
///
///	palgs...: symbol to get parameter for.
///	ppar...: new parameter.
///
/// RTN..: struct symtab_Parameters * : new parameter.
///
/// DESCR: Set parameter with given name.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
AlgorithmSymbolChangeParameter
(struct symtab_AlgorithmSymbol * palgs,struct symtab_Parameters *ppar)
{
    //- set default result : from given parameter

    struct symtab_Parameters *pparResult = ppar;

    //- insert new parameter

    ParContainerInsert(palgs->pparc,pparResult);

    //- return result

    return(pparResult);
}


///
/// get name of algorithm symbol
///

#ifndef SWIG
static inline
#endif
char *
AlgorithmSymbolGetName(struct symtab_AlgorithmSymbol *palgs)
{
    return(IdinName(AlgorithmSymbolGetPidin(palgs)));
}


/// **************************************************************************
///
/// SHORT: AlgorithmSymbolGetParameter()
///
/// ARGS.:
///
///	palgs...: component to get parameter for
///	pcName..: name of parameter to search for
///	ppist...: context of symbol
///
/// RTN..: struct symtab_Parameters * : parameter, NULL for failure
///
/// DESCR: Get parameter with given name
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
AlgorithmSymbolGetParameter
(struct symtab_AlgorithmSymbol * palgs,
 char *pcName,
 struct PidinStack *ppist)
{
    //- lookup parameters value

    struct symtab_Parameters *pparResult
	= ParContainerLookupParameter(palgs->pparc, pcName);

    //- return result

    return(pparResult);
}


///
/// get identifier
///

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
AlgorithmSymbolGetPidin(struct symtab_AlgorithmSymbol *palgs)
{
    return(palgs->dealgs.pidin);
}


///
/// resolve parameter value.
///

#ifndef SWIG
static inline
#endif
double
AlgorithmSymbolParameterResolveValue
(struct symtab_AlgorithmSymbol *palgs, char *pcName, struct PidinStack *ppist)
{
    double dResult = FLT_MAX;

    struct symtab_Parameters *ppar;

    //- if there is a context

    if (ppist)
    {
	//- consult caches if possible

	struct symtab_Parameters *
	    SymbolFindParameter
	    (struct symtab_HSolveListElement *phsle, char *pc, struct PidinStack *ppist);

	ppar = SymbolFindParameter(&palgs->hsle, pcName, ppist);
    }

    //- else

    //t SymbolFindParameter() also uses SymbolGetParameter(), and that
    //t seems a conflict to me, not sure, have to check out what exactly
    //t the consequences are.

    else
    {
	//- do a direct lookup

	struct symtab_Parameters *
	    SymbolGetParameter
	    (struct symtab_HSolveListElement *phsle, char *pc, struct PidinStack *ppist);

	ppar = SymbolGetParameter(&palgs->hsle, pcName, ppist);
    }

    if (ppar)
    {
	dResult = ParameterResolveValue(ppar, ppist);
    }

    return(dResult);
}


#endif


