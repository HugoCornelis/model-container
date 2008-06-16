//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: positionD3.c 1.12 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include <math.h>
#include <float.h>

#include "neurospaces/positionD3.h"


/// nothing at the moment


/// **************************************************************************
///
/// SHORT: D3PositionInit()
///
/// ARGS.:
///
///	pD3.: D3 position to init
///
/// RTN..: void
///
/// DESCR: init D3 position
///
/// **************************************************************************

void D3PositionInit(struct D3Position *pD3)
{
    //- initialize D3 specifics

    D3Set(pD3, FLT_MAX, FLT_MAX, FLT_MAX);
}


