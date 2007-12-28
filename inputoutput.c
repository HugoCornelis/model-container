//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: inputoutput.c 1.23 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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

#include "neurospaces/inputoutput.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"

#include "neurospaces/symbolvirtual_protos.h"


//f local prototypes

static struct symtab_InputOutput * InputOutputCalloc(void);


/// **************************************************************************
///
/// SHORT: InputOutputCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_InputOutput * 
///
///	Newly allocated input, NULL for failure
///
/// DESCR: Allocate a new input/output symbol table element
///
/// **************************************************************************

static struct symtab_InputOutput * InputOutputCalloc(void)
{
    //- set default result : failure

    struct symtab_InputOutput *pioResult = NULL;

    //- allocate input

    pioResult
	= (struct symtab_InputOutput *)
	  calloc(1,sizeof(struct symtab_InputOutput));

    //- initialize input

    InputOutputInit(pioResult);

    //- return result

    return(pioResult);
}


/// **************************************************************************
///
/// SHORT: InputOutputFieldName()
///
/// ARGS.:
///
///	pio.: input/output to get field name for
///
/// RTN..: char * : name of input/output field, NULL for failure
///
/// DESCR: get name of input/output field
///
///	Return value is pointer to symbol table read only data.
///
/// NOTE: 
///
///	Use InputOutputHierarchicalName() to get a complete input/output 
///	description, this function only returns the field name.
///
/// **************************************************************************

char * InputOutputFieldName(struct symtab_InputOutput *pio)
{
    //- set default result : no name

    char *pcResult = NULL;

    //v last found idin

    struct symtab_IdentifierIndex *pidinLast = NULL;

    //- loop over idin list

    struct symtab_IdentifierIndex *pidin = pio->pidinField;

    do
    {
	pidinLast = pidin;

	pidin = pidin->pidinNext;
    }
    while (pidin);

    //- if last pidin found

    if (pidinLast)
    {
	//- set result from idin name

	pcResult = IdinName(pidinLast);
    }

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: InputOutputInit()
///
/// ARGS.:
///
///	pio.: input/output to init
///
/// RTN..: void
///
/// DESCR: init input
///
/// **************************************************************************

void InputOutputInit(struct symtab_InputOutput *pio)
{
    //- zero out all fields

    memset((void *)pio,0,sizeof(*pio));
}


/// **************************************************************************
///
/// SHORT: InputOutputNewForType()
///
/// ARGS.:
///
///	iType..: type to allocate, INPUT_TYPE_INPUT or INPUT_TYPE_OUTPUT
///
/// RTN..: struct symtab_InputOutput * 
///
///	Newly allocated input, NULL for failure
///
/// DESCR: Allocate a new input/output symbol table element
///
/// **************************************************************************

struct symtab_InputOutput * InputOutputNewForType(int iType)
{
    //- set default result : failure

    struct symtab_InputOutput *pioResult = InputOutputCalloc();

    //- set type

    pioResult->iType = iType;

    pioResult->pioFirst = pioResult;

    //- return result

    return(pioResult);
}


/// **************************************************************************
///
/// SHORT: InputOutputResolve()
///
/// ARGS.:
///
///	pio....: input/output
///	ppist..: stack with context
///
/// RTN..: struct PidinStack *
///
///	Context attached to this input.
///
/// DESCR: find element that is attached to the given input
///
/// **************************************************************************

struct PidinStack * 
InputOutputResolve
(struct symtab_InputOutput *pio, struct PidinStack *ppist)
{
    //- set default result : not found

    struct PidinStack * ppistResult = NULL;

    //- duplicate pidin stack

    struct PidinStack *ppistDupl = PidinStackDuplicate(ppist);

    //- loop over idin list

    struct symtab_IdentifierIndex *pidin = pio->pidinField;

    while (pidin && !IdinIsField(pidin))
    {
	//- if idin points to parent

	if (IdinPointsToParent(pidin))
	{
	    //- pop result from duplicate stack

	    PidinStackPop(ppistDupl);
	}

	//- else

	else
	{
	    //- push pidin on pidin stack

	    PidinStackPush(ppistDupl, pidin);

	    //- do lookup of pidin stack

	    struct symtab_HSolveListElement *phsle
		= PidinStackLookupTopSymbol(ppistDupl);

	    //- if not found

	    if (!phsle)
	    {
		//- free working stacks

		PidinStackFree(ppistDupl);

		//- return failure

		return(NULL);
	    }
	}

	//- go to next idin

	pidin = pidin->pidinNext;
    }

    //- set result from top of duplicate context stack

    ppistResult = ppistDupl;

    //t I need to check here what should happen if the returned symbol
    //t has input redirection to another symbol, e.g. for grouped symbols.
    //t
    //t can probably be solved with a recursive call ?

    //- return result

    return(ppistResult);
}


