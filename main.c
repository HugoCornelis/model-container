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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#if !defined(__APPLE__)
#include <malloc.h>
#endif
#include <stdlib.h>

#include "neurospaces/neurospaces.h"


/// 
/// \arg std. ANSI main() args
/// 
/// \return int : success of operation
/// 
/// \brief Construct neurospaces from given command line.
/// 
/// \details 
/// 
///	Constructs a struct NeuroSpaces {} with NeuroSpacesNewFromCmdLine()
///	from given command line.
/// 

int main(int argc, char *argv[])
{

#if !defined(__APPLE__)

    void *pv = (void *)mallopt;

#endif

    //- call parser routine

    struct Neurospaces *pneuro = NeurospacesNewFromCmdLine(argc, argv);

    if (pneuro && pneuro->iErrorCount)
    {
	exit(EXIT_FAILURE);
    }
    else
    {
	exit(EXIT_SUCCESS);
    }
}


