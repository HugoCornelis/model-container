//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: namespace.c 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/// **************************************************************************
//o
//o namespace seperators :
//o ----------------------
//o
//o	Always remember that this set of interfaces needs a rewrite, 
//o	currently they are inconsistent.
//o
//o	'::' : namespace operator, ends a token,
//o		at start of string == default namespace
//o		no namespaces == default namespace
//o	'/' : child operator, starts a token, 
//o		at start of hierarchical string == root of current namespace
//o
//o	'->' : field operator, addresses a parameter or I/O relation
//o		starts a token.
//o
//o e.g. :
//o
//o	1. all the same :
//o
//o		Purkinje::thickd::Purk_thickd/stellate1
//o		::Purkinje::thickd::Purk_thickd/stellate1
//o		Purkinje::thickd::/Purk_thickd/stellate1
//o
//o	2. 
//o
/// **************************************************************************

#include <limits.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/namespace.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


// all legal seperators in a table of strings

static char *ppcSeperators[] =
{
/*     "..", */
/*     ".", */
    "::",
    "->",
    "/",
    " ",
    "\t",
    NULL,
};


// all legal chars in tokens in a table of strings

static char *ppcTokens[] =
{
    "abcdefghijklmnopqrstuvwxyz",
    "0123456789",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "[]()_",
    NULL,
};


/// **************************************************************************
///
/// SHORT: NameSpaceEndThisToken()
///
/// ARGS.:
///
///	pc..: char string to parse
///
/// RTN..: int : offset of next non identifier char, -1 for failure
///
/// DESCR: Parse char stream and stop at non identifier char
///
/// **************************************************************************

int NameSpaceEndThisToken(char *pc)
{
    //- set default result : failure

    int iResult = -1;

    //- default : no seperator found

    int iSeparator = INT_MAX;

    int i;

    //- loop over seperators

    for (i = 0 ; ppcSeperators[i] ; i++)
    {
	//- find start of current seperator

	char *pcArg = strpbrk(pc,ppcSeperators[i]);

	//- if found

	if (pcArg)
	{
	    //- calculate offset

	    int iOffset = pcArg - pc;

	    //- if less than current

	    if (iOffset < iSeparator)
	    {
		//- register smallest offset

		iSeparator = iOffset;
	    }
	}
    }

    //- if found a seperator

    if (iSeparator != INT_MAX)
    {
	//- set result

	iResult = iSeparator;
    }

    //- else

    else
    {
	//- set result : end of string

	iResult = strlen(pc);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: NameSpaceIsChildOperator()
///
/// ARGS.:
///
///	pc..: char string to check
///
/// RTN..: int : TRUE if child operator
///
/// DESCR: Check for child operator
///
/// **************************************************************************

int NameSpaceIsChildOperator(char *pc)
{
    //- set default result : no

    int bResult = FALSE;

    //- next operator is here

    int iOp = 0;

    //- if namespace operator

    if (0 == strncmp
	     (&pc[iOp],
	      IDENTIFIER_CHILD_STRING,
	      strlen(IDENTIFIER_CHILD_STRING)))
    {
	//- set result : ok

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NameSpaceIsChildToken()
///
/// ARGS.:
///
///	pc..: char string to check
///
/// RTN..: int : TRUE if can be child token
///
/// DESCR: Check if child token
///
/// **************************************************************************

int NameSpaceIsChildToken(char *pc)
{
    //- set default result : no

    int bResult = FALSE;

    //- start next token

    int iToken = NameSpaceStartNextToken(pc);

    //- if at same position

    if (iToken == 0)
    {
	//- ok, could be

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NameSpaceIsNameSpaceOperator()
///
/// ARGS.:
///
///	pc..: char string to check
///
/// RTN..: int : TRUE if namespace operator
///
/// DESCR: Check for namespace operator
///
/// **************************************************************************

int NameSpaceIsNameSpaceOperator(char *pc)
{
    //- set default result : no

    int bResult = FALSE;

    //- next operator is here

    int iOp = 0;

    //- if namespace operator

    if (0 == strncmp
	     (&pc[iOp],
	      IDENTIFIER_NAMESPACE_STRING,
	      strlen(IDENTIFIER_NAMESPACE_STRING)))
    {
	//- set result : ok

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NameSpaceIsNameSpaceToken()
///
/// ARGS.:
///
///	pc..: char string to check
///
/// RTN..: int : TRUE if namespace operator found
///
/// DESCR: Check for namespace operator
///
/// **************************************************************************

int NameSpaceIsNameSpaceToken(char *pc)
{
    //- set default result : no

    int bResult = FALSE;

    //- find next operator

    int iOp = NameSpaceEndThisToken(pc);

    //- if namespace operator

    if (pc[iOp] && NameSpaceIsNameSpaceOperator(&pc[iOp]))
    {
	//- set result : ok

	bResult = TRUE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NameSpaceStartNextToken()
///
/// ARGS.:
///
///	pc..: char string to parse
///
/// RTN..: int : offset of next identifier char, -1 for failure
///
/// DESCR: Parse char stream and stop at identifier char
///
/// **************************************************************************

int NameSpaceStartNextToken(char *pc)
{
    //- set default result : failure

    int iResult = -1;

    //- default : no seperator found

    int iSeparator = INT_MAX;

    int i;

    //- loop over seperators

    for (i = 0 ; ppcTokens[i] ; i++)
    {
	//- find start of current seperator

	char *pcArg = strpbrk(pc,ppcTokens[i]);

	//- if found

	if (pcArg)
	{
	    //- calculate offset

	    int iOffset = pcArg - pc;

	    //- if less than current

	    if (iOffset < iSeparator)
	    {
		//- register smallest offset

		iSeparator = iOffset;
	    }
	}
    }

    //- if found a seperator

    if (iSeparator != INT_MAX)
    {
	//- set result

	iResult = iSeparator;
    }

    //- return result

    return(iResult);
}


