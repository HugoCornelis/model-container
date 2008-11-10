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


/// **************************************************************************
///
/// SHORT: VConnectionCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_VConnection * 
///
///	Newly allocated connection vector, NULL for failure
///
/// DESCR: Allocate a new connection vector symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IdinCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_IdentifierIndex * 
///
///	Newly allocated idin, NULL for failure
///
/// DESCR: Allocate a new idin symbol table element
///
/// **************************************************************************

struct symtab_IdentifierIndex * IdinCalloc(void)
{
    //- set default result : failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- allocate idin

    pidinResult
	= (struct symtab_IdentifierIndex *)
	  calloc(1,sizeof(struct symtab_IdentifierIndex));

    //- return result

    return(pidinResult);
}


/// **************************************************************************
///
/// SHORT: IdinCallocUnique()
///
/// ARGS.:
///
///	pc...: sprintf format, NULL for a default, %i gets count.
///
/// RTN..: struct symtab_IdentifierIndex * 
///
///	Newly allocated idin with a count in the name, NULL for
///	failure.
///
/// DESCR: Allocate a new idin, give unique name using a counter.
///
/// NOTE.: Do not exceed 50 chars with format.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IdinCreateAlias()
///
/// ARGS.:
///
///	pidin.: original id to create alias for.
///	iCount: count to make the created id unique.
///
/// RTN..: struct symtab_IdentifierIndex * 
///
///	Newly allocated idin, NULL for failure.
///
/// DESCR: Create an alias id.
///
/// NOTE.: not sure what to do with flags.
///
/// **************************************************************************

struct symtab_IdentifierIndex *
IdinCreateAlias(struct symtab_IdentifierIndex *pidin, int iCount)
{
    //- default result: failure

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- create a useful name, hopefully unique

    //! client needs to check for uniqueness

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
/*     pidinResult->iIndex = pidin->iIndex; */
    pidinResult->dValue = pidin->dValue;

    //- return result

    return(pidinResult);
}


/// **************************************************************************
///
/// SHORT: IdinFullName()
///
/// ARGS.:
///
///	pidin.: IdentifierIndex list to get name for
///	pcName: string receiving result
///
/// RTN..: void
///
///	pcName: string receiving result
///
/// DESCR: get name of IdentifierIndex list
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IdinName()
///
/// ARGS.:
///
///	pidin.: IdentifierIndex struct to get name for
///
/// RTN..: char * : name of IdentifierIndex struct, NULL for failure
///
/// DESCR: get name of IdentifierIndex struct
///
///	Return value is pointer to symbol table read only data
///
/// **************************************************************************

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

/* 	//! triggered during complete traversals. */

/* 	*(int *)0 = 0; */

	//! the lesser this code is triggered, the better.

	static char pcName[30] = "";

	//t gives a warning on 64bit machines.

	sprintf(pcName,"CONN %i",(int)pidin);

	//- set result : illegal pidin (from connection ?)

	pcResult = pcName;
    }

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: IdinNewFromChars()
///
/// ARGS.:
///
///	pc..: name of idin
///
/// RTN..: struct symtab_IdentifierIndex * : new idin
///
/// DESCR: Create idin with given name (no copy).
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: IdinPrint()
///
/// ARGS.:
///
///	pidin..: a pidin.
///	pfile..: file to print to, NULL is stdout.
///
/// RTN..: void.
///
/// DESCR: print pidin to a file.
///
/// **************************************************************************

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


