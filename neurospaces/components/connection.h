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


/// \struct structure declarations

struct descr_Connection;
struct symtab_Connection;


#include "neurospaces/parcontainer.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"



struct symtab_Connection * ConnectionCalloc(void);

struct symtab_Parameters *
ConnectionGetParameter
(struct symtab_Connection *pconn,
 struct PidinStack *ppist,
 char *pcName);

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


#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"


/// \struct
/// \struct connection description
/// \struct

struct descr_Connection
{
/*     /// pre-synaptic principal serial */

/*     struct symtab_IdentifierIndex *pidin; */

    /// pre-synaptic principal serial

    int iPreSynaptic;

    /// post-synaptic principal serial

    int iPostSynaptic;

    /// weight of connection

    double dWeight;

    /// delay of connection

    double dDelay;
};


/// \struct
/// \struct struct symtab_Connection
/// \struct

struct symtab_Connection
{
/*     /// base struct : symbol */

/*     struct symtab_HSolveListElement hsle; */

    /// connection description

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


/// 
/// \arg pconn connection.
/// 
/// \return double : delay, DBL_MAX for failure
/// 
/// \brief Get connection delay.
/// 

#ifndef SWIG
static inline
#endif
double
ConnectionGetDelay
(struct symtab_Connection *pconn)
{
    return(pconn->deconn.dDelay);
}


/// 
/// \arg pconn connection.
/// \arg iTarget projection target serial.
/// 
/// \return int : post principal serial, -1 for failure
/// 
/// \brief Get connection post principal serial.
/// 

#ifndef SWIG
static inline
#endif
int
ConnectionGetPost
(struct symtab_Connection *pconn, int iTarget)
{
    return(iTarget + pconn->deconn.iPostSynaptic);
}


/// 
/// \arg pconn connection.
/// \arg iSource projection source serial.
/// 
/// \return int : pre principal serial, -1 for failure
/// 
/// \brief Get connection pre principal serial.
/// 

#ifndef SWIG
static inline
#endif
int
ConnectionGetPre
(struct symtab_Connection *pconn, int iSource)
{
    return(iSource + pconn->deconn.iPreSynaptic);
}


/// 
/// \arg pconn connection.
/// 
/// \return double : weight, DBL_MAX for failure
/// 
/// \brief Get connection weight.
/// 

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


