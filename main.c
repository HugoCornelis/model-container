//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: main.c 1.18 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include <malloc.h>
#include <stdlib.h>

#include "neurospaces/neurospaces.h"


/// **************************************************************************
///
/// SHORT: main()
///
/// ARGS.:
///
///	std. ANSI main() args
///
/// RTN..: int : success of operation
///
/// DESCR: Construct neurospaces from given command line.
///
///	Constructs a struct NeuroSpaces {} with NeuroSpacesNewFromCmdLine()
///	from given command line.
///
/// **************************************************************************

int main(int argc,char *argv[])
{
    void *pv = (void *)mallopt;

    //- call parser routine

    struct Neurospaces *pneuro = NeurospacesNewFromCmdLine(argc,argv);

    if (pneuro && pneuro->iErrorCount)
    {
	exit(EXIT_FAILURE);
    }
    else
    {
	exit(EXIT_SUCCESS);
    }
}


