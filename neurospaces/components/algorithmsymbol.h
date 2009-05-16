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
//' Copyright (C) 1999-2008 Hugo Cornelis
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


/// \struct structure declarations

struct descr_AlgorithmSymbol;
struct symtab_AlgorithmSymbol;


#include "neurospaces/algorithminstance.h"
#include "neurospaces/idin.h"
#include "neurospaces/treespacetraversal.h"



struct symtab_AlgorithmSymbol *AlgorithmSymbolCalloc(void);

struct symtab_HSolveListElement *
AlgorithmSymbolCreateAlias
(struct symtab_AlgorithmSymbol *palgs,
 char *pcNamespace,
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


#include "neurospaces/parcontainer.h"
#include "neurospaces/symboltable.h"



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
 struct PidinStack *ppist,
 char *pcName);

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
(struct symtab_AlgorithmSymbol *palgs, struct PidinStack *ppist, char *pcName);


/// \struct
/// \struct algorithm symbol description
/// \struct

struct descr_AlgorithmSymbol
{
    /// algorithm instance

    struct AlgorithmInstance *palgi;

    /// symbol table identifier, should be same as name of the algorithm instance

    struct symtab_IdentifierIndex *pidin;
};


/// \struct
/// \struct struct symtab_AlgorithmSymbol
/// \struct

struct symtab_AlgorithmSymbol
{
    /// base struct : symbol

    struct symtab_HSolveListElement hsle;

    /// algorithm symbol description

    struct descr_AlgorithmSymbol dealgs;

    /// parameters

    struct symtab_ParContainer *pparc;

};


#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \arg palgs symbol to assign parameters to.
/// \arg ppar new parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign parameter to symbol.
/// 

#ifndef SWIG
static inline
#endif
int
AlgorithmSymbolAssignParameters
(struct symtab_AlgorithmSymbol *palgs, struct symtab_Parameters *ppar)
{
    return(ParContainerAssignParameters(palgs->pparc, ppar));
}


/// 
/// \arg palgs symbol to get parameter for.
/// \arg ppar new parameter.
/// 
/// \return struct symtab_Parameters * : new parameter.
/// 
/// \brief Set parameter with given name.
/// 

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


/// 
/// \arg palgs component to get parameter for
/// \arg ppist context of symbol
/// \arg pcName name of parameter to search for
/// 
/// \return struct symtab_Parameters * : parameter, NULL for failure
/// 
/// \brief Get parameter with given name
/// 

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
AlgorithmSymbolGetParameter
(struct symtab_AlgorithmSymbol * palgs,
 struct PidinStack *ppist,
 char *pcName)
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
(struct symtab_AlgorithmSymbol *palgs, struct PidinStack *ppist, char *pcName)
{
    double dResult = FLT_MAX;

    struct symtab_Parameters *ppar;

    //- if there is a context

    if (ppist)
    {
	//- consult caches if possible

	struct symtab_Parameters *
	    SymbolFindParameter
	    (struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, char *pc);

	ppar = SymbolFindParameter(&palgs->hsle, ppist, pcName);
    }

    //- else

    /// \todo SymbolFindParameter() also uses SymbolGetParameter(), and that
    /// \todo seems a conflict to me, not sure, have to check out what exactly
    /// \todo the consequences are.

    else
    {
	//- do a direct lookup

	struct symtab_Parameters *
	    SymbolGetParameter
	    (struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, char *pc);

	ppar = SymbolGetParameter(&palgs->hsle, ppist, pcName);
    }

    if (ppar)
    {
	dResult = ParameterResolveValue(ppar, ppist);
    }

    return(dResult);
}


#endif


