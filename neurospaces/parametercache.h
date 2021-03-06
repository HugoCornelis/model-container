//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parametercache.h 1.6 Fri, 29 Jun 2007 22:21:27 -0500 hugo $
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



#ifndef PARAMETERCACHE_H
#define PARAMETERCACHE_H


#include <stdlib.h>


/// \def declarations

struct CachedParameter;
struct ParameterCache;
struct symtab_Parameters;



struct CachedParameter *
ParameterCacheAdd
(struct ParameterCache *pparcac, int iSerial, struct symtab_Parameters *ppar);

struct CachedParameter *
ParameterCacheAddDouble
(struct ParameterCache *pparcac, int iSerial, char *pcName, double dNumber);

struct CachedParameter *
ParameterCacheAddString
(struct ParameterCache *pparcac, int iSerial, char *pcName, char *pcValue);

struct ParameterCache * ParameterCacheNew(void);

int
ParameterCacheExport
(struct ParameterCache *pparcac, struct PidinStack *ppist, int iIndent, int iType, FILE *pfile);

int
ParameterCacheInsert
(struct ParameterCache *pparcac, struct CachedParameter *pcacpar);



static inline 
void ParameterCacheFree(struct ParameterCache *pparcac);

static inline
struct symtab_Parameters *
ParameterCacheLookup(struct ParameterCache *pparcac, int iSerial, char *pc);

static inline 
int ParameterCacheGetMemorySize(struct ParameterCache *pparcac);

static inline 
int ParameterCacheGetNumberOfParameters(struct ParameterCache *pparcac);


#include "cachedparameter.h"
#include "parameters.h"


struct ParameterCache
{
    /// memory used by this parameter cache.

    int iMemoryUsed;

    /// number of parameters involved

    int iParameters;

    /// cached parameters

    struct CachedParameter *pcacpar;
};




/// 
/// free parameter cache.
/// 

static inline 
void ParameterCacheFree(struct ParameterCache *pparcac)
{
    pparcac->iParameters = 0;
    free(pparcac->pcacpar);
    free(pparcac);
}


/// 
/// lookup a parameter in the cache
/// 

static inline
struct symtab_Parameters *
ParameterCacheLookup(struct ParameterCache *pparcac, int iSerial, char *pc)
{
    //- set default result : first parameter in the cache

    struct symtab_Parameters *ppar = &pparcac->pcacpar->par;

    //- loop over parameters in the cache

    while (ppar)
    {
	ppar = ParameterLookup(ppar, pc);

	//- if no candidate found

	if (!ppar)
	{
	    //- break searching loop

	    break;
	}

	//- if found

	if (ppar->iFlags == iSerial)
	{
	    //- break searching loop

	    break;
	}

	//- go to next parameter

	ppar = ppar->pparNext;
    }

    //- return result

    return(ppar);
}


/// 
/// get memory size taken by cache.
/// 

static inline 
int ParameterCacheGetMemorySize(struct ParameterCache *pparcac)
{
    return(pparcac->iMemoryUsed);
}


/// 
/// get number of parameters in cache.
/// 

static inline 
int ParameterCacheGetNumberOfParameters(struct ParameterCache *pparcac)
{
    return(pparcac->iParameters);
}


#endif


