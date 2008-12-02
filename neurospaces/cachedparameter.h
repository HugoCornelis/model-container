//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cachedparameter.h 1.4 Fri, 29 Jun 2007 22:21:27 -0500 hugo $
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



#ifndef CACHEDPARAMETER_H
#define CACHEDPARAMETER_H



/// \def declarations

struct symtab_Parameters;


#include "parameters.h"


struct CachedParameter
{
    struct symtab_Parameters par;
};



static inline 
void CachedParameterFree(struct CachedParameter *pcacpar);

static inline
struct symtab_Parameters *
CachedParameterGetParameter(struct CachedParameter *pcacpar);

struct CachedParameter *
CachedParameterNewFromNumber
(int iSerial, char *pcName, double dNumber);

struct CachedParameter *
CachedParameterNewFromString
(int iSerial, char *pcName, char *pcValue);



/// 
/// free cached parameter.
/// 

static inline 
void CachedParameterFree(struct CachedParameter *pcacpar)
{
    free(pcacpar);
}


/// 
/// get parameter.
/// 

static inline
struct symtab_Parameters *
CachedParameterGetParameter(struct CachedParameter *pcacpar)
{
    return(&pcacpar->par);
}


#endif


