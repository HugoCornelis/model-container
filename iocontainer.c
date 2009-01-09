//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iocontainer.c 1.6.1.17 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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

#include "neurospaces/iocontainer.h"
#include "neurospaces/inputoutput.h"


/// 
/// \arg pioc list element with I/O to init
/// 
/// \return void
/// 
/// \brief Init list element with I/O
/// 

struct symtab_IOContainer * IOContainerCalloc(void)
{
    //- allocate result

    struct symtab_IOContainer * piocResult
	= (struct symtab_IOContainer *)calloc(1,sizeof(*piocResult));

    //- init result

    IOContainerInit(piocResult);

    //- return result

    return(piocResult);
}


/// 
/// \arg pioc list element with I/O to count
/// 
/// \return int : number of elements in the container
/// 
/// \brief Count element in I/O container
/// 

int IOContainerCountIOs(struct symtab_IOContainer * pioc)
{
    //- set default result

    int iResult = 0;

    //- get pointer to IOs

    struct symtab_InputOutput * pio = IOContainerGetRelations(pioc);

    //- loop over IOs

    while (pio)
    {
	//- increment result

	iResult++;

	//- go to next i/o relation

	pio = pio->pioNext;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pioc I/O container to init
/// 
/// \return void
/// 
/// \brief Init list element with I/O
/// 

void IOContainerInit(struct symtab_IOContainer * pioc)
{
    //- init own fields

    pioc->pio = NULL;
}


/// 
/// \arg pioc I/O container to search
/// \arg pc relation to search for
/// \arg iCount relation number with that name (starting at 0)
/// 
/// \return struct symtab_InputOutput * : matching relation, NULL if not found
/// 
/// \brief Search for specified relation
/// 

struct symtab_InputOutput *
IOContainerLookupRelation
(struct symtab_IOContainer * pioc,char *pc,int iCount)
{
    //- set default result : not found

    struct symtab_InputOutput *pioResult = NULL;

    //- get pointer to IOs

    struct symtab_InputOutput * pio = IOContainerGetRelations(pioc);

    //- loop over IOs

    while (pio)
    {
	//- if match

	if (strcmp(InputOutputFieldName(pio),pc) == 0)
	{
	    //- decrement count

	    iCount--;

	    //- if negative count

	    if (iCount < 0)
	    {
		//- set result

		pioResult = pio;

		//- break searching loop

		break;
	    }
	}

	//- go to next i/o relation

	pio = pio->pioNext;
    }

    //- return result

    return(pioResult);
}


/// 
/// \arg ppcParameters Strings indicating parameters, NULL terminated.
/// \arg piTypes Integers indicating parameters are input or output. 
/// 
/// \return struct symtab_IOContainer
/// 
///	IO Container, NULL for failure.
/// 
/// \details 
/// 
///	 Creates an IOContainer from two arrays composed of strings of
///	 the parameters and a corresponding Type value.
/// 
/// \note 
/// 
///	It is recommended that piTypes is terminated by
///	INPUT_TYPE_INVALID.
/// 

struct symtab_IOContainer *
IOContainerNewFromList(char *ppcParameters[], int piTypes[])
{
    int i;

    int iParameterLen = 0;

    for (iParameterLen = 0 ; ppcParameters[iParameterLen] ; iParameterLen++);

    //- allocate IO structs memory

    /// \note allocated in one block.

    struct symtab_InputOutput ** pios
	= (struct symtab_InputOutput **)
          calloc(iParameterLen, sizeof(struct symtab_InputOutput *));

    //- First create the ios and idins

    for (i = 0; i < iParameterLen; i++)
    {
	struct symtab_IdentifierIndex *pidin = IdinNewFromChars(ppcParameters[i]);

	struct symtab_InputOutput *pio
	    = InputOutputNewForType( piTypes[i] );

	/// \note set the pidin in the pidinField
	pio->pidinField = pidin;

	/// \note put this pio into our pios array
	pios[i] = pio;

	/// \note go ahead and set this to point at element 0
	pios[i]->pioFirst = pios[0];
    }

    //- Now make each parameter point to the next in succession.

    for (i = 0 ; i < iParameterLen ; i++)
    {
	if (i == iParameterLen - 1)
	    pios[i]->pioNext = NULL;
	else
	    pios[i]->pioNext = pios[i + 1];
    }

    return IOContainerNewFromIO(pios[0]);
}


/// 
/// \arg pioc I/O relations
/// \arg ppist symbol stack with context
/// \arg pc name of input
/// \arg iPosition number of inputs with given name to skip
/// 
/// \return struct PidinStack *
/// 
///	Context attached to this input.
/// 
/// \brief find element that is attached to the given input
/// 

struct PidinStack *
IOContainerResolve
(struct symtab_IOContainer * pioc,
 struct PidinStack *ppist,
 char *pc,
 int iPosition)
{
    //- set default result : not found

    struct PidinStack * ppistResult = NULL;

    //- init position counter

    int i = iPosition;

    //- loop over inputs of symbol

    struct symtab_InputOutput * pio = IOContainerGetRelations(pioc);

    while (pio)
    {
	//- if input name matches

	if (strcmp(InputOutputFieldName(pio), pc) == 0)
	{
	    //- decrement position counter

	    i--;

	    //- if counter underflow

	    if (i < 0)
	    {
		//- symbolic resolve

		ppistResult = InputOutputResolve(pio, ppist);

		//- break loop

		break;
	    }
	}

	//- go to next input

	pio = pio->pioNext;
    }

    //- return result

    return(ppistResult);
}


/// 
/// \arg piocTarget bio with children
/// \arg ppist symbol stack with context
/// \arg piocSource element generating input
/// 
/// \return int : position of child in input list (starts at zero)
/// 
/// \brief calculate position of given input element
/// 

int 
IOContainerResolvePosition
(struct symtab_IOContainer * piocTarget,
 struct PidinStack *ppist,
 struct symtab_IOList * piolSource)
{
    //- set default result : not found

    int iResult = -1;

    /// counter

    int i = 0;

    //- loop over inputs of symbol

    struct symtab_InputOutput * pio = IOContainerGetRelations(piocTarget);

    while (pio)
    {
	//- get symbol from relation

	struct PidinStack *ppistRelation
	    = InputOutputResolve(pio, ppist);

	struct symtab_IOList *piolRelation
	    = (struct symtab_IOList *)PidinStackLookupTopSymbol(ppistRelation);

	PidinStackFree(ppistRelation);

	//- if symbols match

	if (piolSource == piolRelation)
	{
	    //- set result

	    iResult = i;

	    //- break loop

	    break;
	}

	//- go to next input

	pio = pio->pioNext;

	i++;
    }

    //- return result

    return(iResult);
}


