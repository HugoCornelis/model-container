//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projection.h 1.40 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef PROJECTION_H
#define PROJECTION_H


#include <stdio.h>


/// \struct structure declarations

struct descr_Projection;
struct symtab_Projection;


#include "connection.h"
#include "neurospaces/treespacetraversal.h"



struct symtab_Projection * ProjectionCalloc(void);

int ProjectionCountConnections
(struct symtab_Projection *pproj,struct PidinStack *ppist);

struct symtab_HSolveListElement * 
ProjectionCreateAlias
(struct symtab_Projection *pproj,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

int
ProjectionGetNumberOfConnectionsForSpikeGenerator
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeGen);

int
ProjectionGetNumberOfConnectionsForSpikeReceiver
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeRec);

/* int */
/* ProjectionGetNumberOfConnectionsOnThisTarget */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistTarget); */

int
ProjectionGetSourceSerial
(struct symtab_Projection *pproj,struct PidinStack *ppist);

int
ProjectionGetTargetSerial
(struct symtab_Projection *pproj,struct PidinStack *ppist);

void ProjectionInit(struct symtab_Projection *pproj);

int ProjectionTraverseConnections
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
ProjectionTraverseConnectionsForPostSerial
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 int iReceiver,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
ProjectionTraverseConnectionsForSpikeGenerator
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikeGen,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

/* int */
/* ProjectionTraverseConnectionsForSpikeGeneratorOfSolver */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistSpikegen, */
/*  struct SolverInfo *psi, */
/*  SymbolProcessor *pfProcessor, */
/*  SymbolProcessor *pfFinalizer, */
/*  void *pvUserdata); */

int
ProjectionTraverseConnectionsForSpikeReceiver
(struct symtab_Projection *pproj,
 struct PidinStack *ppist,
 struct PidinStack *ppistSpikerec,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

/* int */
/* ProjectionTraverseConnectionsForSpikeReceiverOfSolver */
/* (struct symtab_Projection *pproj, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistSpikerec, */
/*  struct SolverInfo *psi, */
/*  SymbolProcessor *pfProcessor, */
/*  SymbolProcessor *pfFinalizer, */
/*  void *pvUserdata); */


#include "biocomp.h"


/// \struct
/// \struct projection description
/// \struct

struct descr_Projection
{
    int iDummy;
};


/// \struct
/// \struct struct symtab_Projection
/// \struct

struct symtab_Projection
{
    /// base struct : biocomp

    struct symtab_BioComponent bio;

    /// projection description

    struct descr_Projection deproj;
};


struct PQ_ConnsForTarget_Result
{
    /// result : number of connections

    int iConnections;

    /// original projection

    struct symtab_Projection *pproj;

    /// context of projection

    struct PidinStack *ppistProjection;

    /// context of target

    struct PidinStack *ppistTarget;
};


struct PQ_ConnsForSpikegen_Result
{
    /// original projection

    struct symtab_Projection *pproj;

    /// context of projection

    struct PidinStack *ppistProjection;

    /// context of spikegen

    struct PidinStack *ppistSpikegen;

    /// processor to act on individual selected connections
    /// ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    /// finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    /// user data from caller

    void *pvUserdata;
};


struct PQ_ConnsForPreSerial_Result
{
    /// original projection

    struct symtab_Projection *pproj;

    /// context of projection

    struct PidinStack *ppistProjection;

    /// context of spikegen

    struct PidinStack *ppistSpikeGenerator;

    /// serial of spikegen

    int iPre;

    /// processor to act on individual selected connections
    /// ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    /// finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    /// user data from caller

    void *pvUserdata;
};


/* struct PQ_ConnsForSpikegenOfSolver_Result */
/* { */
/*     /// original projection */

/*     struct symtab_Projection *pproj; */

/*     /// context of projection */

/*     struct PidinStack *ppistProjection; */

/*     /// context of spikegen */

/*     struct PidinStack *ppistSpikegen; */

/*     /// solver info to traverse connections for */

/*     struct SolverInfo *psi; */

/*     /// processor to act on individual selected connections */
/*     /// ie connections that have the spike gen as source */

/*     SymbolProcessor *pfProcessor; */

/*     /// finalizer to act on individual selected connections */

/*     SymbolProcessor *pfFinalizer; */

/*     /// user data from caller */

/*     void *pvUserdata; */
/* }; */


struct PQ_ConnsForSpikerec_Result
{
    /// original projection

    struct symtab_Projection *pproj;

    /// context of projection

    struct PidinStack *ppistProjection;

    /// context of spikerec

    struct PidinStack *ppistSpikerec;

    /// processor to act on individual selected connections
    /// ie connections that have the spike rec as post

    TreespaceTraversalProcessor *pfProcessor;

    /// finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    /// user data from caller

    void *pvUserdata;
};


struct PQ_ConnsForPostSerial_Result
{
    /// original projection

    struct symtab_Projection *pproj;

    /// context of projection

    struct PidinStack *ppistProjection;

    /// context of spikerec

    struct PidinStack *ppistSpikeReceiver;

    /// serial of spikerec

    int iPost;

    /// processor to act on individual selected connections
    /// ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    /// finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    /// user data from caller

    void *pvUserdata;
};


/* struct PQ_ConnsForSpikerecOfSolver_Result */
/* { */
/*     /// original projection query */

/*     struct symtab_Projection *pproj; */

/*     /// context of projection */

/*     struct PidinStack *ppistProjection; */

/*     /// context of spikerec */

/*     struct PidinStack *ppistSpikerec; */

/*     /// solver info to traverse connections for */

/*     struct SolverInfo *psi; */

/*     /// processor to act on individual selected connections */
/*     /// ie connections that have the spike rec as post */

/*     SymbolProcessor *pfProcessor; */

/*     /// finalizer to act on individual selected connections */

/*     SymbolProcessor *pfFinalizer; */

/*     /// user data from caller */

/*     void *pvUserdata; */
/* }; */


#endif


