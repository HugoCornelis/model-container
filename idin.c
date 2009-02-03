//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: idin.c 1.31 Wed, 14 Nov 2007 16:12:38 -0600 hugo $
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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/namespace.h"
#include "neurospaces/symbols.h"


#include "neurospaces/components/vectorconnection.h"


/// 
/// \return struct symtab_VConnection * 
/// 
///	Newly allocated connection vector, NULL for failure
/// 
/// \brief Allocate a new connection vector symbol table element
/// 

struct symtab_VConnection * VConnectionCalloc(void)
{
    //- set default result : failure

    struct symtab_VConnection *pvconnResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/v_connection_vtable.c"

    //- allocate connection vector

    pvconnResult
	= (struct symtab_VConnection *)
	  SymbolCalloc(1, sizeof(struct symtab_VConnection), _vtable_v_connection, HIERARCHY_TYPE_symbols_v_connection);

    //- initialize connection vector

    VConnectionInit(pvconnResult);

    //- return result

    return(pvconnResult);
}


/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin, NULL for failure
/// 
/// \brief Allocate a new idin symbol table element
/// 

struct symtab_IdentifierIndex * IdinCalloc(void)
{
    //- set default result : failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- allocate idin

    pidinResult
	= (struct symtab_IdentifierIndex *)
	  calloc(1, sizeof(struct symtab_IdentifierIndex));

    //- return result

    return(pidinResult);
}


/// 
/// \arg pc sprintf format, NULL for a default, %i gets count.
/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin with a count in the name, NULL for
///	failure.
/// 
/// \brief Allocate a new idin, give unique name using a counter.
/// 
/// \note  Do not exceed 50 chars with format.
/// 

struct symtab_IdentifierIndex * IdinCallocUnique(char *pcFormat)
{
    //- set default result : failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    static int iUnique = 0;

    char pcUnique[1000];

    //- get a format

    char *pcDefaultFormat = "unique[%i]";

    if (!pcFormat)
    {
	pcFormat = pcDefaultFormat;
    }

    //- generate unique string

    sprintf(pcUnique, pcFormat, iUnique);

    iUnique++;

    //- allocate idin

    pidinResult = IdinCalloc();

    pidinResult->pcIdentifier = (char *)calloc(1, 1 + strlen(pcUnique));

    strcpy(pidinResult->pcIdentifier,pcUnique);

    pidinResult->iFlags |= FLAG_IDENTINDEX_UNIQUE;

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin original id to create alias for.
/// \arg iCount count to make the created id unique.
/// 
/// \return struct symtab_IdentifierIndex * 
/// 
///	Newly allocated idin, NULL for failure.
/// 
/// \brief Create an alias id.
/// 
/// \note  not sure what to do with flags.
/// 

struct symtab_IdentifierIndex *
IdinCreateAlias(struct symtab_IdentifierIndex *pidin, int iCount)
{
    //- default result: failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- create a useful name, hopefully unique

    /// \note client needs to check for uniqueness

    char pc[1000];

    sprintf(pc, "%s_%i", pidin->pcIdentifier, iCount);

    char *pcName = calloc(1, 1 + strlen(pc));

    if (!pcName)
    {
	return(NULL);
    }

    strcpy(pcName, pc);

    //- create result

    pidinResult = IdinNewFromChars(pcName);

    //- copy some members

    pidinResult->iFlags = pidin->iFlags;

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin IdentifierIndex list to get name for
/// \arg pcName: string receiving result
/// 
/// \return void
/// 
///	pcName: string receiving result
/// 
/// \brief get name of IdentifierIndex list
/// 

void IdinFullName(struct symtab_IdentifierIndex *pidin, char *pcName)
{
    //- if first idin is rooted

    if (IdinIsRooted(pidin))
    {
	//- first characters come from root symbol

	pcName[0] = ((char *)(SYMBOL_ROOT))[0];

	pcName++;
    }

    //- loop over idin list

    while (pidin)
    {
	//- if pidin has identifier

	if (!(pidin->iFlags & FLAG_IDENTINDEX_NOIDENTIFIER))
	{
	    //- copy name of idin

	    strcpy(&pcName[0], IdinName(pidin));

	    pcName = &pcName[strlen(IdinName(pidin))];

	    //- add seperator

	    pcName[0] = ((char *)(SYMBOL_CHAR_SEPERATOR))[0];

	    pcName++;
	}

	//- go to next idin

	pidin = pidin->pidinNext;
    }

    pcName[-1] = '\0';
}


/// 
/// \arg pidin IdentifierIndex struct to get name for
/// 
/// \return char * : name of IdentifierIndex struct, NULL for failure
/// 
/// \brief get name of IdentifierIndex struct
///
/// \details 
/// 
///	Return value is pointer to symbol table read only data
/// 

char * IdinName(struct symtab_IdentifierIndex *pidin)
{
    //- set default result : no name

    char *pcResult = NULL;

    //- if pidin is legal pidin

    if (IdinIsPrintable(pidin))
    {
	//- if points to parent

	if (IdinPointsToParent(pidin))
	{
	    pcResult = IDENTIFIER_SYMBOL_PARENT_STRING;
	}

	//- if points to current

	else if (IdinPointsToCurrent(pidin))
	{
	    pcResult = IDENTIFIER_SYMBOL_CURRENT_STRING;
	}

	//- if pidin has identifier

	else if (!(pidin->iFlags & FLAG_IDENTINDEX_NOIDENTIFIER))
	{
	    //- set result from pidin name

	    pcResult = pidin->pcIdentifier;
	}
    }

    //- else

    else
    {
/* 	//- check if this code is triggered */

/* 	/// \note triggered during complete traversals. */

/* 	*(int *)0 = 0; */

	/// \note the lesser this code is triggered, the better.

	static char pcName[30] = "";

	/// \todo gives a warning on 64bit machines.

	sprintf(pcName,"CONN %i",(int)pidin);

	//- set result : illegal pidin (from connection ?)

	pcResult = pcName;
    }

    //- return result

    return(pcResult);
}


/// 
/// \arg pc name of idin
/// 
/// \return struct symtab_IdentifierIndex * : new idin
/// 
/// \brief Create idin with given name (no copy).
/// 

struct symtab_IdentifierIndex *IdinNewFromChars(char *pc)
{
    //- allocate

    struct symtab_IdentifierIndex *pidinResult = IdinCalloc();

    //- set name

    IdinSetName(pidinResult, pc);

    if (strcmp(pc, IDENTIFIER_SYMBOL_PARENT_STRING) == 0)
    {
	IdinSetFlags(pidinResult, FLAG_IDENTINDEX_PARENT);
    }

    //- return result

    return(pidinResult);
}


/// 
/// \arg pidin a pidin.
/// \arg pfile file to print to, NULL is stdout.
/// 
/// \return void.
/// 
/// \brief print pidin to a file.
/// 

void IdinPrint(struct symtab_IdentifierIndex *pidin, FILE *pfile)
{
    if (!pfile)
    {
	pfile = stdout;
    }

    char pc[1000];

    IdinFullName(pidin, pc);

    fprintf(pfile, pc);
}


