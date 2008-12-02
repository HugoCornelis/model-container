//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cacheregistry.h 1.2 Sun, 10 Jun 2007 21:11:20 -0500 hugo $
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



#ifndef CACHEREGISTRY_H
#define CACHEREGISTRY_H


/// \def declarations

struct CacheRegistry;
struct RegisteredCache;



struct CacheRegistry *
CacheRegistryCalloc(int iSize);

struct RegisteredCache *
CacheRegistryLookup(struct CacheRegistry *pcr, int iIdentifier);

struct RegisteredCache *
CacheRegistryRegisterCache
(struct CacheRegistry *pcr,
 int iType,
 int iIdentifier,
 int iSize,
 void *pvCache);




/* #include "cachedcoordinate.h" */


struct RegisteredCache
{
    /// type: client specified

    int iType;

    /// identifier: client specified

    int iIdentifier;

    /// size: client specified

    int iSize;

    /// cache payload

    void *pvCache;
};


struct CacheRegistry
{
    /// size

    int iSize;

    /// number of registered caches

    int iRegistered;

    /// registered caches

    struct RegisteredCache *prc;
};




#endif


