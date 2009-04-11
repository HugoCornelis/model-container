//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: group.c 1.42 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/components/attachment.h"
#include "neurospaces/components/group.h"
#include "neurospaces/idin.h"


/// 
/// 
/// \return struct symtab_Group * 
/// 
///	Newly allocated group, NULL for failure
/// 
/// \brief Allocate a new group symbol table element
/// \details 
/// 

struct symtab_Group * GroupCalloc(void)
{
    //- set default result : failure

    struct symtab_Group *pgrupResult = NULL;

#include "hierarchy/output/symbols/group_vtable.c"

    //- allocate group

    pgrupResult
	= (struct symtab_Group *)
	  SymbolCalloc(1, sizeof(struct symtab_Group), _vtable_group, HIERARCHY_TYPE_symbols_group);

    //- initialize group

    GroupInit(pgrupResult);

    //- return result

    return(pgrupResult);
}


/// 
/// 
/// \arg pgrup group to count spike generators for
///	ppist.: context, group on top
/// 
/// \return int : number of spike generators in group, -1 for failure
/// 
/// \brief count all spike generators in group
/// \details 
/// 

static int 
GroupSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    int *piSpikeGens = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike generator

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted spike generators

	(*piSpikeGens)++;
    }

    //- return result

    return(iResult);
}

int GroupCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse group spike generators and count them

    if (SymbolTraverseSpikeGenerators
	(phsle, ppist, GroupSpikeGeneratorCounter, NULL, (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// 
/// \arg pgrup symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
GroupCreateAlias
(struct symtab_Group *pgrup,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Group *pgrupResult = GroupCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pgrupResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pgrupResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pgrupResult->bio.ioh.iol.hsle, &pgrup->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_group);

    //- return result

    return(&pgrupResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pgrup group to init
/// 
/// \return void
/// 
/// \brief init group
/// \details 
/// 

void GroupInit(struct symtab_Group *pgrup)
{
    //- initialize base symbol

    BioComponentInit(&pgrup->bio);

    //- set type

    pgrup->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_group;
}


/// 
/// 
/// \arg dx X coordinate
/// \arg dy Y coordinate
/// \arg dz Z coordinate
/// 
/// \return struct symtab_Group * : resulting cell, NULL for failure
/// 
/// \brief Allocate cell, put at specified position.
/// \details 
/// 
///	Contains memory leak.
/// 

struct symtab_Group * GroupNewAtXYZ(double dx, double dy, double dz)
{
    //- set result : new cell

    struct symtab_Group *pgrupResult 
	= GroupCalloc();

    //- allocate & insert parameters

    if (SymbolSetParameterDouble(&pgrupResult->bio.ioh.iol.hsle, "X", dx))
    {
	if (SymbolSetParameterDouble(&pgrupResult->bio.ioh.iol.hsle, "Y", dy))
	{
	    if (SymbolSetParameterDouble(&pgrupResult->bio.ioh.iol.hsle, "Z", dz))
	    {
	    }
	    else
	    {
		pgrupResult = NULL;
	    }
	}
	else
	{
	    pgrupResult = NULL;
	}
    }
    else
    {
	pgrupResult = NULL;
    }

    //- return result

    return(pgrupResult);
}


