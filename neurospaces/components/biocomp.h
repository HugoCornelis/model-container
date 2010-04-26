//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: biocomp.h 1.6.1.83 Mon, 08 Oct 2007 22:55:25 -0500 hugo $
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
** symbol table grammatical structures
*/

#ifndef BIOCOMP_H
#define BIOCOMP_H


#include <float.h>
#include <limits.h>


#include "iohier.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/parcontainer.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// \struct
/// \struct gives transparant access to hierarchical structures with input/output
/// \struct and parameters, inherits from hierarchical structure
/// \struct
/// \struct supposed to be base bio component
/// \struct

struct symtab_BioComponent
{
    /// base symbol

    struct symtab_IOHierarchy ioh;

    /// optional identifier with index for name of segment

    struct symtab_IdentifierIndex *pidinName;

/*     /// optional name of prototype */

/*     char *pcPrototype; */

    /// prototype symbol

    struct symtab_HSolveListElement *phslePrototype;

    /// allocation identifier of the prototype symbol

    int iPrototype;

    /// parameters

    struct symtab_ParContainer *pparc;

    /// generic option container

    int iOptions;

    /// namespace

    //! only valid for true aliasses, not sure about the typing.

    char *pcNamespace;
};


// \def option only used for tagging

#define BIOCOMP_OPTION_TAG_SET 64

// \def option to disable the prototype traversal of this bio component

#define BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL 128


#include "neurospaces/pidinstack.h"


// prototype functions

int
BioComponentAssignUniquePrototypeID(struct symtab_BioComponent *pbio);

int BioComponentCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

int BioComponentCountSpikeReceivers
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
BioComponentCreateAlias
(struct symtab_BioComponent *pbio,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

int
BioComponentCreateAliasses
(struct symtab_BioComponent *pbio, int iCount, HSolveList *phslResult);

int
BioComponentExportParametersYAML
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 int iIndent,
 FILE *pfile);

struct symtab_HSolveListElement * 
BioComponentGetChildFromInput
(struct symtab_BioComponent *pbio,
 struct symtab_InputOutput *pio);

struct symtab_Parameters * 
BioComponentGetModifiableParameter
(struct symtab_BioComponent * pbio,
 char *pcName,
 struct PidinStack *ppist);

struct symtab_Parameters *
BioComponentGetParameter
(struct symtab_BioComponent * pbio,
 struct PidinStack *ppist,
 char *pcName);

void BioComponentInit(struct symtab_BioComponent * pbio);

struct symtab_InputOutput *
BioComponentLookupBindableIO
(struct symtab_BioComponent *pbio, char *pcInput, int i);

struct symtab_HSolveListElement *
BioComponentLookupHierarchical
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);

int BioComponentLookupSerialID
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsleSearched,
 struct PidinStack *ppistSearched);

int BioComponentPrint
(struct symtab_BioComponent *pbio, int bAll, int iIndent, FILE *pfile);

int BioComponentReduce
(struct symtab_BioComponent *pbio, struct PidinStack *ppist);

struct symtab_HSolveListElement *
BioComponentResolveParameterFunctionalInput
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 char *pcParameter,
 char *pcInput,
 int iPosition);

struct symtab_Parameters * 
BioComponentSetParameterContext
(struct symtab_BioComponent * pbio,
 char *pcName,
 struct PidinStack *ppistValue);

struct symtab_Parameters *
BioComponentSetParameterDouble
(struct symtab_BioComponent * pbio,
 char *pcName,
 double dNumber);

struct symtab_Parameters * 
BioComponentSetParameterMayBeCopyString
(struct symtab_BioComponent * pbio,
 char *pcName,
 char *pcValue,
 int iFlags);

struct symtab_Parameters * 
BioComponentSetParameterString
(struct symtab_BioComponent * pbio,
 char *pcName,
 char *pcValue);

int
BioComponentTraverse
(struct TreespaceTraversal *ptstr,
 struct symtab_BioComponent *pbio);

int
BioComponentTraverseSpikeGenerators
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
BioComponentTraverseSpikeReceivers
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "neurospaces/parameters.h"


//f static inline prototypes

#ifndef SWIG
static inline
#endif
int
BioComponentAssignParameters
(struct symtab_BioComponent *pbio, struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
BioComponentChangeParameter
(struct symtab_BioComponent * pbio, struct symtab_Parameters *ppar);

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* char * */
/* BioComponentGetID */
/* (struct symtab_BioComponent *pbio, struct PidinStack *ppist); */

#ifndef SWIG
static inline
#endif
char *
BioComponentGetName(struct symtab_BioComponent *pbio);

#ifndef SWIG
static inline
#endif
int
BioComponentGetOptions(struct symtab_BioComponent *pbio);

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
BioComponentGetPidin(struct symtab_BioComponent *pbio);

#ifndef SWIG
static inline
#endif
struct symtab_HSolveListElement *
BioComponentGetPrototype(struct symtab_BioComponent *pbio);

#ifndef SWIG
static inline
#endif
int
BioComponentParameterLinkAtEnd
(struct symtab_BioComponent *pbio, struct symtab_Parameters *ppar);

#ifndef SWIG
static inline
#endif
double
BioComponentParameterResolveValue
(struct symtab_BioComponent *pbio, struct PidinStack *ppist, char *pcName);

#ifndef SWIG
static inline
#endif
int
BioComponentSetAtXYZ
(struct symtab_BioComponent *pbio, double dx, double dy, double dz, int iFlags);

#ifndef SWIG
static inline
#endif
int
BioComponentSetName
(struct symtab_BioComponent *pbio, struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int
BioComponentSetNamespace
(struct symtab_BioComponent *pbio, char *pc);

#ifndef SWIG
static inline
#endif
int
BioComponentSetOptions
(struct symtab_BioComponent * pbio,
 int iOptions);

#ifndef SWIG
static inline
#endif
int
BioComponentSetPrototype
(struct symtab_BioComponent *pbio, struct symtab_BioComponent *pbioProto);


/// 
/// \arg pbio symbol to assign parameters to.
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
BioComponentAssignParameters
(struct symtab_BioComponent *pbio, struct symtab_Parameters *ppar)
{
    return(ParContainerAssignParameters(pbio->pparc, ppar));
}


/// 
/// \arg pbio symbol to get parameter for.
/// \arg ppar new parameter.
/// 
/// \return struct symtab_Parameters * : new parameter, NULL for failure.
/// 
/// \brief Set parameter with given name.
/// 
/// \note 
/// 
///	After calling this function, you must use the return value for
///	the new parameter.  What can happen internally, is that an
///	existing parameter structure gets changed, and is returned as
///	result, while the ppar argument is freed.
/// 

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
BioComponentChangeParameter
(struct symtab_BioComponent * pbio, struct symtab_Parameters *ppar)
{
    //- set default result : from given parameter

    struct symtab_Parameters *pparResult = ppar;

    //- detach the prototype identifier

    BioComponentAssignUniquePrototypeID(pbio);

    //- insert new parameter

    ParContainerInsert(pbio->pparc, pparResult);

    //- return result

    return(pparResult);
}


/* ///  */
/* /// get a unique string representation identifying this symbol */
/* /// content. */
/* ///  */

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* char * */
/* BioComponentGetID */
/* (struct symtab_BioComponent *pbio, struct PidinStack *ppist) */
/* { */
/*     //- set default result: none */

/*     char *pcResult = NULL; */

/*     /// \todo check for availability of parameters in parameter caches */
/*     /// \todo if none found, */
/*     /// \todo   loop over prototypes, */
/*     /// \todo     check for parameters in this symbol */
/*     /// \todo     if found, */
/*     /// \todo       return this symbol string representation */

/*     //- define result */

/*     static char pc[100]; */

/*     if (sprintf(pc, "%p", pbio) >= 0) */
/*     { */
/* 	pcResult = pc; */
/*     } */

/*     //- return result */

/*     return(pcResult); */
/* } */


/// 
/// get name of biocomponent
/// 

#ifndef SWIG
static inline
#endif
char *
BioComponentGetName(struct symtab_BioComponent *pbio)
{
    return(IdinName(BioComponentGetPidin(pbio)));
}


/// 
/// get options for a bio component
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentGetOptions
(struct symtab_BioComponent *pbio)
{
    return(pbio->iOptions);
}


/// 
/// get count of created aliases by type.
/// 

#ifndef SWIG
static inline
#endif
struct symtab_IdentifierIndex *
BioComponentGetPidin(struct symtab_BioComponent *pbio)
{
    return(pbio->pidinName);
}


/// 
/// get prototype of component
/// 

#ifndef SWIG
static inline
#endif
struct symtab_HSolveListElement *
BioComponentGetPrototype(struct symtab_BioComponent *pbio)
{
    return(pbio->phslePrototype);
}


/// 
/// link parameters at end of parameters list
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentParameterLinkAtEnd
(struct symtab_BioComponent *pbio, struct symtab_Parameters *ppar)
{
    ParContainerLinkAtEnd(pbio->pparc, ppar);

    return(TRUE);
}


/// 
/// resolve parameter value.
/// 

#ifndef SWIG
static inline
#endif
double
BioComponentParameterResolveValue
(struct symtab_BioComponent *pbio, struct PidinStack *ppist, char *pcName)
{
    double dResult = DBL_MAX;

    struct symtab_Parameters *ppar;

    //- if there is a context

    if (ppist)
    {
	//- consult caches if possible

	ppar = SymbolFindParameter(&(pbio->ioh.iol.hsle), ppist, pcName);
    }

    //- else

    /// \todo SymbolFindParameter() also uses SymbolGetParameter(), and that
    /// \todo seems a conflict to me, not sure, have to check out what exactly
    /// \todo the consequences are.

    else
    {
	//- do a direct lookup

	ppar = SymbolGetParameter(&(pbio->ioh.iol.hsle), ppist, pcName);
    }

    if (ppar)
    {
	dResult = ParameterResolveValue(ppar, ppist);
    }

    return(dResult);
}


/// 
/// set options of component
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentSetOptions
(struct symtab_BioComponent * pbio,
 int iOptions)
{
    int iResult = TRUE;

    pbio->iOptions = iOptions;

    return(iResult);
}


/// 
/// set prototype of component
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentSetPrototype
(struct symtab_BioComponent *pbio, struct symtab_BioComponent *pbioProto)
{
    //- set default result : success

    int iResult = TRUE;

    //- set prototype

    pbio->phslePrototype = &pbioProto->ioh.iol.hsle;

    //- if the prototype has already a prototype identifier assigned

    if (pbioProto->iPrototype)
    {
	//- inherit the prototype identifier

	pbio->iPrototype = pbioProto->iPrototype;
    }

    //- else

    else
    {
	//- create a new unique prototype identifier

	BioComponentAssignUniquePrototypeID(pbio);
    }

#ifdef PRE_PROTO_TRAVERSAL

    SymbolSetInvisibleNumOfSuccessors
	(&pbio->ioh.iol.hsle,
	 SymbolGetPrincipalNumOfSuccessors(&pbioProto->ioh.iol.hsle));

    SymbolSetPrincipalNumOfSuccessors
	(&pbio->ioh.iol.hsle,
	 SymbolGetPrincipalNumOfSuccessors(&pbioProto->ioh.iol.hsle));

#ifdef TREESPACES_SUBSET_MECHANISM
    SymbolSetMechanismNumOfSuccessors
	(&pbio->ioh.iol.hsle,
	 SymbolGetMechanismNumOfSuccessors(&pbioProto->ioh.iol.hsle));
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    SymbolSetSegmentNumOfSuccessors
	(&pbio->ioh.iol.hsle,
	 SymbolGetSegmentNumOfSuccessors(&pbioProto->ioh.iol.hsle));
#endif

#else


#error BioComponents only supports PRE_PROTO_TRAVERSAL for now.

/// \todo #defines to maintain prototype links
/// \todo 
/// \todo do nothing for #SU ?

#endif

    //- return result

    return(iResult);
}


/// 
/// set coordinates and apply parameter flags.
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentSetAtXYZ
(struct symtab_BioComponent *pbio, double dx, double dy, double dz, int iFlags)
{
    //- set default result : ok

    int bResult = TRUE;

    //- allocate & insert parameters

    {
	struct symtab_Parameters *ppar
	    = SymbolSetParameterDouble(&pbio->ioh.iol.hsle, "X", dx);

	ppar->iFlags = iFlags;
    }

    {
	struct symtab_Parameters *ppar
	= SymbolSetParameterDouble(&pbio->ioh.iol.hsle, "Y", dy);

	ppar->iFlags = iFlags;
    }

    {
	struct symtab_Parameters *ppar
	    = SymbolSetParameterDouble(&pbio->ioh.iol.hsle, "Z", dz);

	ppar->iFlags = iFlags;
    }

    //- return result

    return(bResult);
}


/// 
/// set name of component
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentSetName
(struct symtab_BioComponent *pbio, struct symtab_IdentifierIndex *pidin)
{
    pbio->pidinName = pidin;
}


/// 
/// set namespace of component
/// 

#ifndef SWIG
static inline
#endif
int
BioComponentSetNamespace
(struct symtab_BioComponent *pbio, char *pc)
{
    pbio->pcNamespace = pc;
}


#endif


