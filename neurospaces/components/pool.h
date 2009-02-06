//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pool.h 1.20.1.37 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef POOL_H
#define POOL_H


#include <stdio.h>

#include "biocomp.h"
#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_Pool;
struct symtab_Pool;



struct symtab_Pool * PoolCalloc(void);

struct symtab_HSolveListElement * 
PoolCreateAlias
(struct symtab_Pool *ppool,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
PoolGetParameter
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 char *pcName);

void PoolInit(struct symtab_Pool *ppool);

struct symtab_HSolveListElement *
PoolLookupHierarchical
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);

double
PoolParameterScaleValue
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar);


/* #include "equationexponential.h" */
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"


/// \struct
/// \struct pool description
/// \struct

struct descr_Pool
{
    /// keeping things happy

    int iHappy;

/*     /// type of pool data */

/*     int iType; */

/*     /// actual data : should still be changed */

/*     union  */
/*     { */
/* 	/// equation describing pool */

/* 	struct symtab_Equation *peq; */

/* 	/// file with table describing pool */

/* 	char *pcFilename; */
/*     } */
/*     uData; */
};


/// \struct
/// \struct struct symtab_Pool
/// \struct

struct symtab_Pool
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// pool description

    struct descr_Pool depool;
};


/// \def equation type

#define TYPE_POOL_EQUATION		1

/// \def table in file

#define TYPE_POOL_TABLEFILE		2

/// \def attachment point data

#define TYPE_POOL_VIRTUALCONNECTION	4

/// \def additional pool parameters

#define TYPE_POOL_PARAMETERS		5


#endif


