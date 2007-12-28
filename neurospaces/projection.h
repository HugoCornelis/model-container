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
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef PROJECTION_H
#define PROJECTION_H


#include <stdio.h>


//s structure declarations

struct descr_Projection;
struct symtab_Projection;


#include "connection.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_Projection * ProjectionCalloc(void);

int ProjectionCountConnections
(struct symtab_Projection *pproj,struct PidinStack *ppist);

struct symtab_HSolveListElement * 
ProjectionCreateAlias
(struct symtab_Projection *pproj,
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


//s
//s projection description
//s

struct descr_Projection
{
    int iDummy;
};


//s
//s struct symtab_Projection
//s

struct symtab_Projection
{
    //m base struct : biocomp

    struct symtab_BioComponent bio;

    //m projection description

    struct descr_Projection deproj;
};


struct PQ_ConnsForTarget_Result
{
    //m result : number of connections

    int iConnections;

    //m original projection

    struct symtab_Projection *pproj;

    //m context of projection

    struct PidinStack *ppistProjection;

    //m context of target

    struct PidinStack *ppistTarget;
};


struct PQ_ConnsForSpikegen_Result
{
    //m original projection

    struct symtab_Projection *pproj;

    //m context of projection

    struct PidinStack *ppistProjection;

    //m context of spikegen

    struct PidinStack *ppistSpikegen;

    //m processor to act on individual selected connections
    //m ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    //m finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    //m user data from caller

    void *pvUserdata;
};


struct PQ_ConnsForPreSerial_Result
{
    //m original projection

    struct symtab_Projection *pproj;

    //m context of projection

    struct PidinStack *ppistProjection;

    //m context of spikegen

    struct PidinStack *ppistSpikeGenerator;

    //m serial of spikegen

    int iPre;

    //m processor to act on individual selected connections
    //m ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    //m finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    //m user data from caller

    void *pvUserdata;
};


/* struct PQ_ConnsForSpikegenOfSolver_Result */
/* { */
/*     //m original projection */

/*     struct symtab_Projection *pproj; */

/*     //m context of projection */

/*     struct PidinStack *ppistProjection; */

/*     //m context of spikegen */

/*     struct PidinStack *ppistSpikegen; */

/*     //m solver info to traverse connections for */

/*     struct SolverInfo *psi; */

/*     //m processor to act on individual selected connections */
/*     //m ie connections that have the spike gen as source */

/*     SymbolProcessor *pfProcessor; */

/*     //m finalizer to act on individual selected connections */

/*     SymbolProcessor *pfFinalizer; */

/*     //m user data from caller */

/*     void *pvUserdata; */
/* }; */


struct PQ_ConnsForSpikerec_Result
{
    //m original projection

    struct symtab_Projection *pproj;

    //m context of projection

    struct PidinStack *ppistProjection;

    //m context of spikerec

    struct PidinStack *ppistSpikerec;

    //m processor to act on individual selected connections
    //m ie connections that have the spike rec as post

    TreespaceTraversalProcessor *pfProcessor;

    //m finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    //m user data from caller

    void *pvUserdata;
};


struct PQ_ConnsForPostSerial_Result
{
    //m original projection

    struct symtab_Projection *pproj;

    //m context of projection

    struct PidinStack *ppistProjection;

    //m context of spikerec

    struct PidinStack *ppistSpikeReceiver;

    //m serial of spikerec

    int iPost;

    //m processor to act on individual selected connections
    //m ie connections that have the spike gen as source

    TreespaceTraversalProcessor *pfProcessor;

    //m finalizer to act on individual selected connections

    TreespaceTraversalProcessor *pfFinalizer;

    //m user data from caller

    void *pvUserdata;
};


/* struct PQ_ConnsForSpikerecOfSolver_Result */
/* { */
/*     //m original projection query */

/*     struct symtab_Projection *pproj; */

/*     //m context of projection */

/*     struct PidinStack *ppistProjection; */

/*     //m context of spikerec */

/*     struct PidinStack *ppistSpikerec; */

/*     //m solver info to traverse connections for */

/*     struct SolverInfo *psi; */

/*     //m processor to act on individual selected connections */
/*     //m ie connections that have the spike rec as post */

/*     SymbolProcessor *pfProcessor; */

/*     //m finalizer to act on individual selected connections */

/*     SymbolProcessor *pfFinalizer; */

/*     //m user data from caller */

/*     void *pvUserdata; */
/* }; */


#endif


