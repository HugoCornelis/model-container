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
//' Copyright (C) 1999-2008 Hugo Cornelis
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


/// 
/// 
/// \return struct AlgorithmClass * 
/// 
///	Newly allocated algorithm, NULL for failure
/// 
/// \brief Allocate a new algorithm symbol table element
/// \details 
/// 

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


/// 
/// 
/// \arg palgc algorithm to get name for
/// 
/// \return char * : name of algorithm, NULL for failure
/// 
/// \brief get name of algorithm
/// \details 
/// 
///	Return value is pointer to symbol table read only data
/// 

char * AlgorithmClassGetName(struct AlgorithmClass *palgc)
{
    //- set default result : no name

    char *pcResult = NULL;

    //- set result from name

    pcResult = palgc->pcIdentifier;

    //- return result

    return(pcResult);
}


/// 
/// 
/// \arg palgc algorithm to init
/// 
/// \return void
/// 
/// \brief init algorithm
/// \details 
/// 

void AlgorithmClassInit(struct AlgorithmClass *palgc)
{
    //- initialize algorithm

    memset(palgc,0,sizeof(*palgc));

    /// \todo init handlers
}


