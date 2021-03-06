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
    /// human readable solver ID

    char *pcSolver;

    /// internal solver ID, solver or proxy

    void *pvSolver;

    /// context stack of solved symbol

    struct PidinStack *ppist;
};


/// all solver registrations

struct SolverRegistry
{
    /// array of registrations.

    struct SolverInfo **ppsiRegistrations;

    /// total number of registrations in the array

    int iRegistrationMax;

    /// number of active registrations in the array

    int iRegistrations;

};


#include "pidinstack.h"
#include "projectionquery.h"


struct SolverInfo * SolverInfoCalloc(void);

int SolverInfoCountIncomingConnections
(struct SolverInfo *psi,struct ProjectionQuery *ppq);

void SolverInfoFree(struct SolverInfo * psi);

char * SolverInfoGetSolverString(struct SolverInfo *psi);

struct PidinStack *
SolverInfoLookupContextFromPrincipalSerial
(struct SolverInfo *psi, int iPrincipal);

int SolverInfoLookupPrincipalSerial
(struct SolverInfo *psi, struct PidinStack *ppist);

int SolverInfoLookupRelativeSerial(struct SolverInfo *psi, int iSerial);

struct symtab_HSolveListElement *
SolverInfoLookupTopSymbol(struct SolverInfo *psi, struct PidinStack *ppist);

struct PidinStack * SolverInfoPidinStack(struct SolverInfo * psi);

#ifdef TREESPACES_SUBSET_SEGMENT
int 
SolverInfoPrincipalSerial2SegmentSerial
(struct SolverInfo *psi, int iPrincipal);
#endif

int SolverInfoSerialInSolvedSet(struct SolverInfo *psi, int iSerial);

int SolverRegistryAdd(struct SolverRegistry *psr, struct SolverInfo *psi);

struct SolverInfo *
SolverRegistryAddFromContext
(struct SolverRegistry *psr, void *pvSolver, struct PidinStack *ppist, char *pcSolver);

int SolverRegistryEnumerate(struct SolverRegistry *psr);

struct SolverInfo * 
SolverRegistryGet(struct SolverRegistry *psr, struct PidinStack *ppist);

struct SolverInfo *
SolverRegistryGetForAbsoluteSerial(struct SolverRegistry *psr, int iSerial);

struct SolverRegistry * SolverRegistryCalloc(int iSize);


#endif


