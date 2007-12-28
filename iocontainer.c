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
//' Copyright (C) 1999-2007 Hugo Cornelis
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


/// **************************************************************************
///
/// SHORT: IOContainerInit()
///
/// ARGS.:
///
///	pioc.: list element with I/O to init
///
/// RTN..: void
///
/// DESCR: Init list element with I/O
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IOContainerCountIOs()
///
/// ARGS.:
///
///	pioc.: list element with I/O to count
///
/// RTN..: int : number of elements in the container
///
/// DESCR: Count element in I/O container
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IOContainerInit()
///
/// ARGS.:
///
///	pioc.: I/O container to init
///
/// RTN..: void
///
/// DESCR: Init list element with I/O
///
/// **************************************************************************

void IOContainerInit(struct symtab_IOContainer * pioc)
{
    //- init own fields

    pioc->pio = NULL;
}


/// **************************************************************************
///
/// SHORT: IOContainerLookupRelation()
///
/// ARGS.:
///
///	pioc...: I/O container to search
///	pc.....: relation to search for
///	iCount.: relation number with that name (starting at 0)
///
/// RTN..: struct symtab_InputOutput * : matching relation, NULL if not found
///
/// DESCR: Search for specified relation
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IOContainerResolve()
///
/// ARGS.:
///
///	pioc.....: I/O relations
///	ppist....: symbol stack with context
///	pc.......: name of input
///	iPosition: number of inputs with given name to skip
///
/// RTN..: struct PidinStack *
///
///	Context attached to this input.
///
/// DESCR: find element that is attached to the given input
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IOContainerResolvePosition()
///
/// ARGS.:
///
///	piocTarget.: bio with children
///	ppist......: symbol stack with context
///	piocSource.: element generating input
///
/// RTN..: int : position of child in input list (starts at zero)
///
/// DESCR: calculate position of given input element
///
/// **************************************************************************

int 
IOContainerResolvePosition
(struct symtab_IOContainer * piocTarget,
 struct PidinStack *ppist,
 struct symtab_IOList * piolSource)
{
    //- set default result : not found

    int iResult = -1;

    //v counter

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


