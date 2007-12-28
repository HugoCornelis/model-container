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
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <stdlib.h>
#include <string.h>

#include "neurospaces/cachedparameter.h"


/// **************************************************************************
///
/// SHORT: CachedParameterNewFromNumber()
///
/// ARGS.:
///
///	ppar..: parameter
///
/// RTN..: struct CachedParameter *
///
///	New cached parameter, NULL for failure.
///
/// DESCR:
///
///	Create a new cached parameter for the given parameter.
///
/// **************************************************************************

static struct CachedParameter *
CachedParameterNew(struct symtab_Parameters *ppar)
{
    //- set default result : dirty conversion

    struct CachedParameter * pcacparResult
	= (struct CachedParameter *)ppar;

    //- return result

    return(pcacparResult);
}


/// **************************************************************************
///
/// SHORT: CachedParameterNewFromNumber()
///
/// ARGS.:
///
///	iSerial.: context of parameter value.
///	pcName..: name of parameter value.
///	dNumber.: parameter value.
///
/// RTN..: struct CachedParameter *
///
///	New cached parameter, NULL for failure.
///
/// DESCR:
///
///	Create a new cached parameter with the given value for the
///	given context
///
/// **************************************************************************

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

    //! flags are not used for cached parameters, or a small redesign
    //! is needed.

    pcacparResult->par.iFlags = iSerial;

    //- return result

    return(pcacparResult);
}


/// **************************************************************************
///
/// SHORT: CachedParameterNewFromString()
///
/// ARGS.:
///
///	iSerial.: context of parameter value.
///	pcName..: name of parameter value.
///	pcValue.: parameter value.
///
/// RTN..: struct CachedParameter *
///
///	New cached parameter, NULL for failure.
///
/// DESCR:
///
///	Create a new cached parameter with the given value for the
///	given context
///
/// **************************************************************************

struct CachedParameter *
CachedParameterNewFromString
(int iSerial, char *pcName, char *pcValue)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    struct symtab_Parameters *ppar = ParameterNewFromString(pcName, pcValue);

    if (!ppar)
    {
	return(NULL);
    }

    pcacparResult = CachedParameterNew(ppar);

    //- set serial

    //! flags are not used for cached parameters, or a small redesign
    //! is needed.

    pcacparResult->par.iFlags = iSerial;

    //- return result

    return(pcacparResult);
}


