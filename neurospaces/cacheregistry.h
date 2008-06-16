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


//d declarations

struct CacheRegistry;
struct RegisteredCache;


//f exported functions

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


//f exported inlines


/* #include "cachedcoordinate.h" */


struct RegisteredCache
{
    //m type: client specified

    int iType;

    //m identifier: client specified

    int iIdentifier;

    //m size: client specified

    int iSize;

    //m cache payload

    void *pvCache;
};


struct CacheRegistry
{
    //m size

    int iSize;

    //m number of registered caches

    int iRegistered;

    //m registered caches

    struct RegisteredCache *prc;
};



//f exported inlines

#endif


