//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cachedparameter.c 1.5 Fri, 29 Jun 2007 22:21:27 -0500 hugo $
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


/// 
/// \arg ppar parameter
/// 
/// \return struct CachedParameter *
/// 
///	New cached parameter, NULL for failure.
/// 
/// \details 
/// 
///	Create a new cached parameter for the given parameter.
/// 

static struct CachedParameter *
CachedParameterNew(struct symtab_Parameters *ppar)
{
    //- set default result : dirty conversion

    struct CachedParameter * pcacparResult
	= (struct CachedParameter *)ppar;

    //- return result

    return(pcacparResult);
}


/// 
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg dNumber parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	New cached parameter, NULL for failure.
/// 
/// \details 
/// 
///	Create a new cached parameter with the given value for the
///	given context.
/// 

struct CachedParameter *
CachedParameterNewFromNumber
(int iSerial, char *pcName, double dNumber)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    struct symtab_Parameters *ppar = ParameterNewFromNumber(pcName, dNumber);

    if (!ppar)
    {
	return(NULL);
    }

    pcacparResult = CachedParameterNew(ppar);

    //- set serial

    /// \note flags are not used for cached parameters, or a small redesign
    /// is needed.

    pcacparResult->par.iFlags = iSerial;

    //- return result

    return(pcacparResult);
}


/// 
/// \arg iSerial context of parameter value.
/// \arg ppar parameter with name and value.
/// 
/// \return struct CachedParameter *
/// 
///	New cached parameter, NULL for failure.
/// 
/// \details 
/// 
///	Create a new cached parameter with the given value for the
///	given context.  Note that this function does not do memory
///	allocation of the inserted parameter.
/// 

struct CachedParameter *
CachedParameterNewFromParameter
(int iSerial, struct symtab_Parameters *ppar)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    pcacparResult = CachedParameterNew(ppar);

    //- set serial

    /// \note flags are not used for cached parameters, or a small redesign
    /// is needed.

    pcacparResult->par.iFlags = iSerial;

    //- return result

    return(pcacparResult);
}


/// 
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg pcValue parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	New cached parameter, NULL for failure.
/// 
/// \details 
/// 
///	Create a new cached parameter with the given value for the
///	given context.
/// 
/// \note 
/// 
///	Parameter caches have a notion of independence, so they do
///	their own memory allocation when appropriate.  For this
///	function it means that pcValue is duplicated using strdup().
///	Note again that this is very different from pidinstacks and
///	regular parameters.
/// 

struct CachedParameter *
CachedParameterNewFromString
(int iSerial, char *pcName, char *pcValue)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for string

    pcValue = strdup(pcValue);

    if (!pcValue)
    {
	return(NULL);
    }

    struct symtab_Parameters *ppar = ParameterNewFromString(pcName, pcValue);

    if (!ppar)
    {
	return(NULL);
    }

    pcacparResult = CachedParameterNew(ppar);

    //- set serial

    /// \note flags are not used for cached parameters, or a small redesign
    /// is needed.

    pcacparResult->par.iFlags = iSerial;

    //- return result

    return(pcacparResult);
}


