//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmclass.c 1.8 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmclass.h"


/// **************************************************************************
///
/// SHORT: AlgorithmClassCalloc()
///
/// ARGS.:
///
/// RTN..: struct AlgorithmClass * 
///
///	Newly allocated algorithm, NULL for failure
///
/// DESCR: Allocate a new algorithm symbol table element
///
/// **************************************************************************

struct AlgorithmClass * AlgorithmClassCalloc(void)
{
    //- set default result : failure

    struct AlgorithmClass *palgcResult = NULL;

    //- allocate algorithm

    palgcResult
	= (struct AlgorithmClass *)
	  calloc(1,sizeof(*palgcResult));

    //- initialize algorithm

    AlgorithmClassInit(palgcResult);

    //- return result

    return(palgcResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmClassGetName()
///
/// ARGS.:
///
///	palgc.: algorithm to get name for
///
/// RTN..: char * : name of algorithm, NULL for failure
///
/// DESCR: get name of algorithm
///
///	Return value is pointer to symbol table read only data
///
/// **************************************************************************

char * AlgorithmClassGetName(struct AlgorithmClass *palgc)
{
    //- set default result : no name

    char *pcResult = NULL;

    //- set result from name

    pcResult = palgc->pcIdentifier;

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: AlgorithmClassInit()
///
/// ARGS.:
///
///	palgc.: algorithm to init
///
/// RTN..: void
///
/// DESCR: init algorithm
///
/// **************************************************************************

void AlgorithmClassInit(struct AlgorithmClass *palgc)
{
    //- initialize algorithm

    memset(palgc,0,sizeof(*palgc));

    //t init handlers
}


