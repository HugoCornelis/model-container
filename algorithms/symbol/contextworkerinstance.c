//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: contextworkerinstance.c 1.4 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include "neurospaces/algorithminstance.h"

#include "contextworkerinstance.h"


/// **************************************************************************
///
/// SHORT: ContextWorkerInstanceGetContext()
///
/// ARGS.:
///
/// RTN..: struct PidinStack * : 
///
///	Context.
///
/// DESCR: Get context.
///
/// **************************************************************************

struct PidinStack *
ContextWorkerInstanceGetContext
(struct AlgorithmInstance *palgi)
{
    //- set default result : none

    struct PidinStack *ppistResult = NULL;

    //- return result

    return(ppistResult);
}


