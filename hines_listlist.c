
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


/// 
/// 
/// \arg phsllList list of lists
/// 
/// \return int : TRUE if list is empty
/// 
/// \brief test if no elements in the lists of the list of lists
/// \details 
/// 

int HSolveListListIsEmpty(HSolveListList *phsllList)
{
    //- set default result : empty

    int iResult = TRUE;

    /// loop vars

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


/// 
/// 
/// \arg std. ANSI main() args
/// 
/// \return int : success of operation
/// 
/// \brief test list of lists
/// \details 
/// 
///	Options on command line are to appear first
/// 

#ifdef TEST_LISTLIST

/// total number of errors

int errorcount = 0;

int main(int argc,char *argv[])
{
    //- set default result

    int iResult = EXIT_SUCCESS;

    //- return result

    exit(iResult);
}

#endif

