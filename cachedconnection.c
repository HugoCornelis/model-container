//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cachedconnection.c 1.7 Mon, 10 Sep 2007 15:45:45 -0500 hugo $
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

#include "neurospaces/cachedconnection.h"


/// **************************************************************************
///
/// SHORT: CachedConnectionPrint()
///
/// ARGS.:
///
///	pcconn...: cached connection to print symbols for
///	bAll.....: TRUE == full list of symbols, FALSE == only given conn
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Print symbol info for connection
///
/// **************************************************************************

#define PrintCachedConnectionIndent(iIndent,pfile)			\
do									\
{									\
    PrintIndent(iIndent, pfile);					\
    fprintf(pfile, "CCONN  ");						\
}									\
while (0)								\

int
CachedConnectionPrint
(struct CachedConnection *pcconn, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- do indent

    PrintCachedConnectionIndent(iIndent, pfile);

    //- print pre, post

    fprintf
	(pfile,
	 "pre(%f) -> post(%f)\n",
	 (double)pcconn->iPre,
	 (double)pcconn->iPost);

    //- do indent

    PrintCachedConnectionIndent(iIndent, pfile);

    //- print weight, delay

    fprintf
	(pfile,
	 "Delay, Weight (%f,%f)\n",
	 pcconn->dDelay,
	 pcconn->dWeight);

    //- return result

    return(bResult);
}


