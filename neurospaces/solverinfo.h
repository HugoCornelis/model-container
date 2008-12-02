//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: solverinfo.h 1.17 Sat, 10 Mar 2007 10:37:01 -0600 hugo $
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



#ifndef SOLVERINFO_H
#define SOLVERINFO_H


struct SolverInfo;


struct SolverInfo
{
    /// (absolute ?) path specification, identifies a solver

    char *pcSolver;

    /// context stack of solved symbol

    struct PidinStack *ppist;
};


#include "pidinstack.h"
#include "projectionquery.h"


struct SolverInfo * SolverInfoCalloc(void);

int SolverInfoCountIncomingConnections
(struct SolverInfo *psi,struct ProjectionQuery *ppq);

void SolverInfoFree(struct SolverInfo * psi);

char * SolverInfoGetSolver(struct SolverInfo *psi);

void SolverInfoInit
(struct SolverInfo * psi,struct PidinStack *ppist,char *pcSolver);

struct PidinStack *
SolverInfoLookupContextFromPrincipalSerial
(struct SolverInfo *psi,int iPrincipal);

int SolverInfoLookupPrincipalSerial
(struct SolverInfo *psi,struct PidinStack *ppist);

int SolverInfoLookupRelativeSerial(struct SolverInfo *psi,int iSerial);

struct symtab_HSolveListElement *
SolverInfoLookupTopSymbol(struct SolverInfo *psi,struct PidinStack *ppist);

struct PidinStack * SolverInfoPidinStack(struct SolverInfo * psi);

#ifdef TREESPACES_SUBSET_SEGMENT
int 
SolverInfoPrincipalSerial2SegmentSerial
(struct SolverInfo *psi,int iPrincipal);
#endif

int SolverInfoRegistrationAdd(void *pv,struct SolverInfo * psi);

struct SolverInfo *SolverInfoRegistrationAddFromContext
(void *pv,struct PidinStack *ppist,char *pcSolver);

int SolverInfoRegistrationEnumerate(void);

struct SolverInfo * 
SolverInfoRegistrationGet
(void *pv,struct PidinStack *ppist);

struct SolverInfo *
SolverInfoRegistrationGetForAbsoluteSerial(void *pv,int iSerial);

int SolverInfoSerialInSolvedSet(struct SolverInfo *psi,int iSerial);


#endif


