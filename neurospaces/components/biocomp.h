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


//s
//s gives transparant access to hierarchical structures with input/output
//s and parameters, inherits from hierarchical structure
//s
//s supposed to be base bio component
//s

struct symtab_BioComponent
{
    //m base symbol

    struct symtab_IOHierarchy ioh;

    //m optional identifier with index for name of segment

    struct symtab_IdentifierIndex *pidinName;

/*     //m optional name of prototype */

/*     char *pcPrototype; */

    //m prototype symbol

    struct symtab_HSolveListElement *phslePrototype;

    //m parameters

    struct symtab_ParContainer *pparc;

    //m generic option container

    int iOptions;
};


#include "neurospaces/pidinstack.h"


// prototype functions

int BioComponentCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

int BioComponentCountSpikeReceivers
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
BioComponentCreateAlias
(struct symtab_BioComponent *pbio,
 struct symtab_IdentifierIndex *pidin);

int
BioComponentCreateAliasses
(struct symtab_BioComponent *pbio, int iCount, HSolveList *phslResult);

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
(struct symtab_BioComponent *pbio,char *pcInput,int i);

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
(struct symtab_BioComponent *pbio,int bAll,int iIndent,FILE *pfile);

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
 struct PidinStack *ppistValue/* , */
/* struct PidinStack *ppist */);

struct symtab_Parameters *
BioComponentSetParameterDouble
(struct symtab_BioComponent * pbio,
 char *pcName,
 double dNumber/* , */
/* struct PidinStack *ppist */);

struct symtab_Parameters * 
BioComponentSetParameterString
(struct symtab_BioComponent * pbio,
 char *pcName,
 char *pcValue/* , */
/* struct PidinStack *ppist */);

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


/* //f static inline prototypes */

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
(struct symtab_BioComponent * pbio,struct symtab_Parameters *ppar);

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
(struct symtab_BioComponent *pbio, double dx, double dy, double dz);

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
BioComponentSetOptions
(struct symtab_BioComponent * pbio,
 int iOptions);

#ifndef SWIG
static inline
#endif
int
BioComponentSetPrototype
(struct symtab_BioComponent *pbio, struct symtab_BioComponent *pbioProto);


/// **************************************************************************
///
/// SHORT: BioComponentAssignParameters()
///
/// ARGS.:
///
///	pbio...: symbol to assign parameters to.
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
BioComponentAssignParameters
(struct symtab_BioComponent *pbio, struct symtab_Parameters *ppar)
{
    return(ParContainerAssignParameters(pbio->pparc, ppar));
}


/// **************************************************************************
///
/// SHORT: BioComponentChangeParameter()
///
/// ARGS.:
///
///	pbio...: symbol to get parameter for.
///	ppar...: new parameter.
///
/// RTN..: struct symtab_Parameters * : new parameter, NULL for failure.
///
/// DESCR: Set parameter with given name.
///
/// NOTE.:
///
///	After calling this function, you must use the return value for
///	the new parameter.  What can happen internally, is that an
///	existing parameter structure gets changed, and is returned as
///	result, while the ppar argument is freed.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
struct symtab_Parameters * 
BioComponentChangeParameter
(struct symtab_BioComponent * pbio,struct symtab_Parameters *ppar)
{
    //- set default result : from given parameter

    struct symtab_Parameters *pparResult = ppar;

    //- insert new parameter

    ParContainerInsert(pbio->pparc, pparResult);

    //- return result

    return(pparResult);
}


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
    double dResult = FLT_MAX;
    struct symtab_Parameters *ppar;

    //- if there is a context

    if (ppist)
    {
	//- consult caches if possible

	ppar = SymbolFindParameter(&(pbio->ioh.iol.hsle), ppist, pcName);
    }

    //- else

    //t SymbolFindParameter() also uses SymbolGetParameter(), and that
    //t seems a conflict to me, not sure, have to check out what exactly
    //t the consequences are.

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

//t #defines to maintain prototype links
//t 
//t do nothing for #SU ?

#endif

    //- return result

    return(iResult);
}


///
/// set coordinates.
///

#ifndef SWIG
static inline
#endif
int
BioComponentSetAtXYZ
(struct symtab_BioComponent *pbio, double dx, double dy, double dz)
{
    //- set default result : ok

    int bResult = TRUE;

    //- allocate & insert parameters

    if (SymbolSetParameterDouble(&pbio->ioh.iol.hsle,"X",dx))
    {
	if (SymbolSetParameterDouble(&pbio->ioh.iol.hsle,"Y",dy))
	{
	    if (SymbolSetParameterDouble(&pbio->ioh.iol.hsle,"Z",dz))
	    {
	    }
	    else
	    {
		bResult = FALSE;
	    }
	}
	else
	{
	    bResult = FALSE;
	}
    }
    else
    {
	bResult = FALSE;
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


#endif


