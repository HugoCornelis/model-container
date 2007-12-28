
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/hines_listlist.h"

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// **************************************************************************
///
/// SHORT: HSolveListIsEmpty()
///
/// ARGS.:
///
///	phsllList.: list of lists
///
/// RTN..: int : TRUE if list is empty
///
/// DESCR: test if no elements in the lists of the list of lists
///
/// **************************************************************************

int HSolveListListIsEmpty(HSolveListList *phsllList)
{
    //- set default result : empty

    int iResult = TRUE;

    //v loop vars

    HSolveListListElement *phsl = NULL;

    HSolveListElement *phsle = NULL;

    //- loop over the lists

    phsl = (HSolveListListElement *)HSolveListHead(&phsllList->hslHeader);

    while (HSolveListValidSucc(&phsl->hsleLink))
    {
	//- get pointer to first element of current list

	phsle = (HSolveListElement *)HSolveListHead(&phsl->hslList);

	//- if this is a valid element

	if (HSolveListValidSucc(phsle))
	{
	    //- set result : not empty

	    iResult = FALSE;

	    //- break loop

	    break;
	}
    }

    //- return result

    return(iResult);
}


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
/// DESCR: test list of lists
///
///	Options on command line are to appear first
///
/// **************************************************************************

#ifdef TEST_LISTLIST

//v total number of errors

int errorcount = 0;

int main(int argc,char *argv[])
{
    //- set default result

    int iResult = EXIT_SUCCESS;

    //- return result

    exit(iResult);
}

#endif

