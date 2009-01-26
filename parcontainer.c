//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parcontainer.c 1.14 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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
#include <stdlib.h>


#include "neurospaces/parcontainer.h"


/// 
/// \arg pparc parameter container.
/// \arg ppar new parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign parameters.
/// 

int
ParContainerAssignParameters
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    pparc->ppars = ppar;

    return(TRUE);
};


/// 
/// \return struct symtab_ParContainer * 
/// 
///	Newly allocated parameter container, NULL for failure
/// 
/// \brief Allocate a parameter container
/// 

struct symtab_ParContainer * ParContainerCalloc(void)
{
    //- set default result : failure

    struct symtab_ParContainer *pparcResult = NULL;

    //- allocate parameters

    pparcResult
	= (struct symtab_ParContainer *)
	  calloc(1, sizeof(struct symtab_ParContainer));

    //- initialize parameter container

    ParContainerInit(pparcResult);

    //- return result

    return(pparcResult);
}


/// 
/// \arg pparc container to init
/// 
/// \return void
/// 
/// \brief Init a parameter container
/// 

void ParContainerInit(struct symtab_ParContainer * pparc)
{
    //- unset pointers

    pparc->ppars = NULL;
}


/// 
/// \arg pparc container
/// \arg ppar parameter to link
/// 
/// \return void
/// 
/// \brief Insert new parameter at head of parameter list
///
/// \details 
/// 
///	This function scales with the size of the parameter list,
///	use it with caution.
/// 

void ParContainerInsert
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    //- insert

    ppar->pparNext = pparc->ppars;
    pparc->ppars = ppar;

    //- update ->pparFirst for entire list

    struct symtab_Parameters *pparLoop = pparc->ppars;
    do
    {
	pparLoop->pparFirst = pparc->ppars;
	pparLoop = pparLoop->pparNext;
    }
    while (pparLoop);
}


/// 
/// \arg pparc container
/// \arg ppar parameter list to link
/// 
/// \return void
/// 
/// \brief Link new parameter at end of parameter list
/// 

void ParContainerLinkAtEnd
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    //- if already parameters

    if (pparc->ppars)
    {
	//- modify last parameter to link new one

	struct symtab_Parameters *pparLoop = pparc->ppars;

	while (pparLoop->pparNext)
	{
	    pparLoop = pparLoop->pparNext;
	}
	ppar->pparFirst = pparc->ppars;

	pparLoop->pparNext = ppar;
    }

    //- else

    else
    {
	//- modify parameter container

	ppar->pparFirst = ppar;
	pparc->ppars = ppar;
    }
}


