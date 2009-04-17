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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include <stdlib.h>
#include <string.h>

#include "neurospaces/exporter.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"

#include "neurospaces/symbolvirtual_protos.h"



static struct symtab_InputOutput * InputOutputCalloc(void);


/// 
/// \return struct symtab_InputOutput * 
/// 
///	Newly allocated input, NULL for failure.
/// 
/// \brief Allocate a new input/output symbol table element.
/// 

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


///
/// \arg pio input/output to export.
/// \arg ppist context of input/output.
/// \arg iIndent current indentation level.
/// \arg iType type of export, see exporter.h.
/// \arg pfile stream to export to.
///
/// \return int success of operation.
///
/// \brief export this input/output.
///

int
InputOutputExport
(struct symtab_InputOutput *pio,
 struct PidinStack *ppist,
 int iIndent,
 int iType,
 FILE *pfile)
{
    //- set default result: success

    int iResult = 1;

    PrintIndent(iIndent, pfile);

    //- for an input

    if (pio->iType == INPUT_TYPE_INPUT)
    {
	//- export input

	struct PidinStack *ppist2 = PidinStackCalloc();

	PidinStackPushAll(ppist2, pio->pidinField);

	char pc[1000];

	PidinStackString(ppist2, pc, sizeof(pc));

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "INPUT %s,\n", pc);
	}
	else
	{
	    fprintf(pfile, "<input> <name>%s</name> </input>\n", pc);
	}

	PidinStackFree(ppist2);      
    }

    //- for an output

    else if (pio->iType == INPUT_TYPE_OUTPUT)
    {
	//- export output

	struct PidinStack *ppist2 = PidinStackCalloc();

	PidinStackPushAll(ppist2, pio->pidinField);

	char pc[1000];

	PidinStackString(ppist2, pc, sizeof(pc));

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "OUTPUT %s,\n", pc);
	}
	else
	{
	    fprintf(pfile, "<output> <name>%s</name> </output>\n", pc);
	}

	PidinStackFree(ppist2);
    }
    else
    {
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pio input/output to get field name for.
/// 
/// \return char * : name of input/output field, NULL for failure.
/// 
/// \brief get name of input/output field.
///
/// \details 
/// 
///	Return value is pointer to symbol table read only data.
/// 
/// \note  
/// 
///	Use InputOutputHierarchicalName() to get a complete input/output 
///	description, this function only returns the field name.
/// 

char * InputOutputFieldName(struct symtab_InputOutput *pio)
{
    //- set default result : no name

    char *pcResult = NULL;

    /// last found idin

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


/// 
/// \arg pio input/output to init.
/// 
/// \return int success of operation.
/// 
/// \brief init input.
/// 

int InputOutputInit(struct symtab_InputOutput *pio)
{
    //- set default result: success

    int iResult = 1;

    //- zero out all fields

    memset((void *)pio,0,sizeof(*pio));

    //- return result

    return(iResult);
}


/// 
/// \arg iType type to allocate, INPUT_TYPE_INPUT or INPUT_TYPE_OUTPUT.
/// 
/// \return struct symtab_InputOutput * 
/// 
///	Newly allocated input, NULL for failure.
/// 
/// \brief Allocate a new input/output symbol table element.
/// 

struct symtab_InputOutput * InputOutputNewForType(int iType)
{
    //- set default result: failure

    struct symtab_InputOutput *pioResult = InputOutputCalloc();

    //- set type

    pioResult->iType = iType;

    pioResult->pioFirst = pioResult;

    //- return result

    return(pioResult);
}


/// 
/// \arg pio input/output.
/// \arg ppist stack with context.
/// 
/// \return struct PidinStack *
/// 
///	Context attached to this input.
/// 
/// \brief find element that is attached to the given input.
/// 

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

	//- if idin points to current

	else if (IdinPointsToCurrent(pidin))
	{
	    //- we do nothing
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

    /// \todo I need to check here what should happen if the returned symbol
    /// \todo has input redirection to another symbol, e.g. for grouped symbols.
    ///
    /// \todo can probably be solved with a recursive call ?

    //- return result

    return(ppistResult);
}


