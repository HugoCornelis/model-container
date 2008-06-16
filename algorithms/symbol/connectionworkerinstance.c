//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectionworkerinstance.c 1.6 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include "neurospaces/algorithminstance.h"

#include "connectionworkerinstance.h"


/// **************************************************************************
///
/// SHORT: ConnectionWorkerInstanceGetNetwork()
///
/// ARGS.:
///
/// RTN..: struct PidinStack * : 
///
///	Network context.
///
/// DESCR: Get network context.
///
/// **************************************************************************

struct PidinStack *
ConnectionWorkerInstanceGetParameterContext
(struct AlgorithmInstance *palgi)
{
    return NULL;
}

struct PidinStack *
ConnectionWorkerInstanceGetNetwork
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result : info about current symbol

    struct PidinStack *ppistResult = ParserContextGetPidinContext(pac);

    //- lookup symbol

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(ppistResult);

    //- sanity check

    if (!instanceof_network(phsle))
    {
	PidinStackFree(ppistResult);

	ppistResult = NULL;
    }

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionWorkerInstanceGetProjection()
///
/// ARGS.:
///
/// RTN..: struct PidinStack * : 
///
///	Projection context.
///
/// DESCR: Get projection context.
///
/// **************************************************************************

struct PidinStack *
ConnectionWorkerInstanceGetProjection
(struct AlgorithmInstance *palgi, struct ParserContext *pac, char *pcProjection)
{
    //- set default result : none

    struct PidinStack *ppistResult = NULL;

    //- get network

    struct PidinStack * ppistNetwork = NULL;
/* AlgorithmInstanceGetNetwork(palgi, pac); */

    //- duplicate

    ppistResult = PidinStackDuplicate(ppistNetwork);

    //- add given argument, gives projection context

    struct PidinStack * ppistArgument = PidinStackParse(pcProjection);

    PidinStackAppendCompact(ppistResult, ppistArgument);

    //- free allocated memory

    PidinStackFree(ppistArgument);

    //- lookup symbol

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(ppistResult);

    //- sanity check

    if (!instanceof_projection(phsle))
    {
	PidinStackFree(ppistResult);

	ppistResult = NULL;
    }

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionWorkerInstanceGetSource()
///
/// ARGS.:
///
/// RTN..: struct PidinStack * : 
///
///	Network context.
///
/// DESCR: Get source context.
///
/// **************************************************************************

struct PidinStack *
ConnectionWorkerInstanceGetSource
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result : info about current symbol

    struct PidinStack *ppistResult = ParserContextGetPidinContext(pac);

    //- return result

    return(ppistResult);
}


