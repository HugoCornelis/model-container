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
#include "pidinstack.h"


//s structure declarations

struct descr_Pool;
struct symtab_Pool;


//f exported functions

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


#include "equation.h"
#include "idin.h"
#include "inputoutput.h"
#include "parameters.h"


//s
//s pool description
//s

struct descr_Pool
{
    //m type of pool data

    int iType;

    //m actual data : should still be changed

    union 
    {
	//m equation describing pool

	struct symtab_Equation *peq;

	//m file with table describing pool

	char *pcFilename;
    }
    uData;
};


//s
//s struct symtab_Pool
//s

struct symtab_Pool
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m pool description

    struct descr_Pool depool;
};


//d equation type

#define TYPE_POOL_EQUATION		1

//d table in file

#define TYPE_POOL_TABLEFILE		2

//d attachment point data

#define TYPE_POOL_VIRTUALCONNECTION	4

//d additional pool parameters

#define TYPE_POOL_PARAMETERS		5


#endif


