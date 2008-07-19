//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connection.h 1.46 Wed, 12 Sep 2007 15:17:04 -0500 hugo $
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


#ifndef CONNECTION_H
#define CONNECTION_H


#include <stdio.h>


//s structure declarations

struct descr_Connection;
struct symtab_Connection;


#include "parcontainer.h"
#include "pidinstack.h"
#include "symboltable.h"


//f exported functions

/* int */
/* ConnectionAssignParameters */
/* (struct symtab_Connection *pconn,struct symtab_Parameters *ppar); */

struct symtab_Connection * ConnectionCalloc(void);

struct symtab_Parameters *
ConnectionGetParameter
(struct symtab_Connection *pconn,
 char *pcName,
 struct PidinStack *ppist);

struct PidinStack *
ConnectionGetSpikeGenerator
(struct symtab_Connection *pconn,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

struct PidinStack *
ConnectionGetSpikeReceiver
(struct symtab_Connection *pconn,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

void ConnectionInit(struct symtab_Connection *pconn);

/* struct symtab_HSolveListElement * */
/* ConnectionLookupHierarchical */
/* (struct symtab_Connection *pconn, */
/*  struct PidinStack *ppist, */
/*  int iLevel, */
/*  int bAll); */

struct symtab_Connection *
ConnectionNewForStandardConnection
(int iPreSynaptic,int iPostSynaptic,double dWeight,double dDelay);

double
ConnectionParameterResolveValue
(struct symtab_Connection *pconn,
 struct PidinStack *ppist,
 char *pcName);

int ConnectionPrint
(struct symtab_Connection *pconn,int bAll,int iIndent,FILE *pfile);

int
ConnectionTraverse
(struct TreespaceTraversal *ptstr, struct symtab_Connection *pconn);


//f exported inline functions

#ifndef SWIG
static inline
#endif
int
ConnectionAllSerialsToParentGet
(struct symtab_Connection *pconn,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
ConnectionAllSerialsToParentSet
(struct symtab_Connection *pconn,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
ConnectionAllSuccessorsGet
(struct symtab_Connection *pconn,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
ConnectionAllSuccessorsSet
(struct symtab_Connection *pconn,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
ConnectionGetPost
(struct symtab_Connection *pconn, int iTarget);

#ifndef SWIG
static inline
#endif
int
ConnectionGetPre
(struct symtab_Connection *pconn, int iSource);


#include "idin.h"
#include "parameters.h"


//s
//s connection description
//s

struct descr_Connection
{
/*     //m pre-synaptic principal serial */

/*     struct symtab_IdentifierIndex *pidin; */

    //m pre-synaptic principal serial

    int iPreSynaptic;

    //m post-synaptic principal serial

    int iPostSynaptic;

    //m weight of connection

    double dWeight;

    //m delay of connection

    double dDelay;
};


//s
//s struct symtab_Connection
//s

struct symtab_Connection
{
/*     //m base struct : symbol */

/*     struct symtab_HSolveListElement hsle; */

    //m connection description

    struct descr_Connection deconn;
};


#ifndef SWIG
static inline
#endif
int
ConnectionAllSerialsToParentGet
(struct symtab_Connection *pconn,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
)
{
    *piInvisible = 0;
    *piPrincipal = 0;
#ifdef TREESPACES_SUBSET_MECHANISM
    *piMechanism = 0;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    *piSegment = 0;
#endif

    return(1);
}


#ifndef SWIG
static inline
#endif
int
ConnectionAllSerialsToParentSet
(struct symtab_Connection *pconn,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
)
{
    return(1);
}


#ifndef SWIG
static inline
#endif
int
ConnectionAllSuccessorsGet
(struct symtab_Connection *pconn,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
)
{
    *piInvisible = 0;
    *piPrincipal = 0;
#ifdef TREESPACES_SUBSET_MECHANISM
    *piMechanism = 0;
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    *piSegment = 0;
#endif

    return(1);
}


#ifndef SWIG
static inline
#endif
int
ConnectionAllSuccessorsSet
(struct symtab_Connection *pconn,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
)
{
    return(1);
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ConnectionGetPidin() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pconn.: connection with pidin. */
/* /// */
/* /// RTN..: struct symtab_IdentifierIndex * : pidin of connection. */
/* /// */
/* /// DESCR: Get pidin of connection. */
/* /// */
/* /// ************************************************************************** */

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* struct symtab_IdentifierIndex * */
/* ConnectionGetPidin(struct symtab_Connection *pconn) */
/* { */
/*     return(pconn->deconn.pidin); */
/* } */


/// **************************************************************************
///
/// SHORT: ConnectionGetDelay()
///
/// ARGS.:
///
///	pconn.: connection.
///
/// RTN..: double : delay, FLT_MAX for failure
///
/// DESCR: Get connection delay.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
double
ConnectionGetDelay
(struct symtab_Connection *pconn)
{
    return(pconn->deconn.dDelay);
}


/// **************************************************************************
///
/// SHORT: ConnectionGetPost()
///
/// ARGS.:
///
///	pconn...: connection.
///	iTarget.: projection target serial.
///
/// RTN..: int : post principal serial, -1 for failure
///
/// DESCR: Get connection post principal serial.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
int
ConnectionGetPost
(struct symtab_Connection *pconn, int iTarget)
{
    return(iTarget + pconn->deconn.iPostSynaptic);
}


/// **************************************************************************
///
/// SHORT: ConnectionGetPre()
///
/// ARGS.:
///
///	pconn...: connection.
///	iSource.: projection source serial.
///
/// RTN..: int : pre principal serial, -1 for failure
///
/// DESCR: Get connection pre principal serial.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
int
ConnectionGetPre
(struct symtab_Connection *pconn, int iSource)
{
    return(iSource + pconn->deconn.iPreSynaptic);
}


/// **************************************************************************
///
/// SHORT: ConnectionGetWeight()
///
/// ARGS.:
///
///	pconn.: connection.
///
/// RTN..: double : weight, FLT_MAX for failure
///
/// DESCR: Get connection weight.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
double
ConnectionGetWeight
(struct symtab_Connection *pconn)
{
    return(pconn->deconn.dWeight);
}


#endif


