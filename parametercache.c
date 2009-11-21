//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parametercache.c 1.6 Fri, 29 Jun 2007 22:21:27 -0500 hugo $
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



#include <stdlib.h>
#include <string.h>

#include "neurospaces/cachedparameter.h"
#include "neurospaces/parametercache.h"
#include "neurospaces/parameters.h"


/// 
/// \arg pparcac parameter cache.
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg dNumber parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	Newly added cached parameter, NULL for failure.
/// 
/// \brief Add a parameter to the cache.
/// 

struct CachedParameter *
ParameterCacheAddDouble
(struct ParameterCache *pparcac, int iSerial, char *pcName, double dNumber)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    pcacparResult = CachedParameterNewFromNumber(iSerial, pcName, dNumber);

    if (!pcacparResult)
    {
	return(NULL);
    }

    //- insert the parameter in the cache

    ParameterCacheInsert(pparcac, pcacparResult);

    //- return result

    return(pcacparResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg pcValue parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	Newly added cached parameter, NULL for failure.
/// 
/// \brief Add a parameter to the cache.
/// 

struct CachedParameter *
ParameterCacheAddString
(struct ParameterCache *pparcac, int iSerial, char *pcName, char *pcValue)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    pcacparResult = CachedParameterNewFromString(iSerial, pcName, pcValue);

    if (!pcacparResult)
    {
	return(NULL);
    }

    //- insert the parameter in the cache

    ParameterCacheInsert(pparcac, pcacparResult);

    //- return result

    return(pcacparResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg ppar parameter to be cached.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Insert a parameter in the cache.
/// 

int
ParameterCacheInsert
(struct ParameterCache *pparcac, struct CachedParameter *pcacpar)
{
    //- set default result : failure

    int iResult = FALSE;

    //- insert the parameter in the list

    pcacpar->par.pparNext = &pparcac->pcacpar->par;

    pparcac->pcacpar = pcacpar;

    //- increment number of parameters in the cache

    pparcac->iParameters++;

    //- return result

    return(iResult);
}


/// 
/// \return struct ParameterCache * 
/// 
///	New parameter cache, NULL for failure.
/// 
/// \brief Initialize new parameter cache.
/// 

struct ParameterCache * ParameterCacheNew(void)
{
    //- set default result : failure

    struct ParameterCache *pccResult = NULL;

    //- allocate parameter cache

    pccResult = (struct ParameterCache *)calloc(1,sizeof(struct ParameterCache));

    //- init

    pccResult->iParameters = 0;

    pccResult->pcacpar = NULL;

    //- set used memory

    pccResult->iMemoryUsed = sizeof(struct ParameterCache);

    //- return result

    return(pccResult);
}


