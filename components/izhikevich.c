//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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
#include "neurospaces/components/izhikevich.h"
#include "neurospaces/idin.h"


/// 
/// \return struct symtab_Izhikevich * 
/// 
///	Newly allocated izhikevich, NULL for failure
/// 
/// \brief Allocate a new izhikevich symbol table element
/// 

struct symtab_Izhikevich * IzhikevichCalloc(void)
{
    //- set default result : failure

    struct symtab_Izhikevich *pihziResult = NULL;

#include "hierarchy/output/symbols/izhikevich_vtable.c"

    //- allocate izhikevich

    pihziResult
	= (struct symtab_Izhikevich *)
	  SymbolCalloc(1, sizeof(struct symtab_Izhikevich), _vtable_izhikevich, HIERARCHY_TYPE_symbols_izhikevich);

    //- initialize izhikevich

    IzhikevichInit(pihziResult);

    //- return result

    return(pihziResult);
}


/// 
/// \arg pihzi izhikevich to count spike generators for
/// \arg ppist context, izhikevich on top
/// 
/// \return int : number of spike generators in izhikevich, -1 for failure
/// 
/// \brief count all spike generators in izhikevich
/// 

static int 
IzhikevichSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    int *piSpikeGens = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike generator

    int iType = TstrGetActualType(ptstr);

    if (subsetof_attachment(iType)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted spike generators

	(*piSpikeGens)++;
    }

    //- return result

    return(iResult);
}

int IzhikevichCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse izhikevich spike generators and count them

    if (SymbolTraverseSpikeGenerators
	(phsle, ppist, IzhikevichSpikeGeneratorCounter, NULL, (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pihzi symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
IzhikevichCreateAlias
(struct symtab_Izhikevich *pihzi,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Izhikevich *pihziResult = IzhikevichCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pihziResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pihziResult->segr.bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pihziResult->segr.bio.ioh.iol.hsle, &pihzi->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_izhikevich);

    //- return result

    return(&pihziResult->segr.bio.ioh.iol.hsle);
}


/// 
/// \arg pihzi izhikevich to init
/// 
/// \return void
/// 
/// \brief init izhikevich
/// 

void IzhikevichInit(struct symtab_Izhikevich *pihzi)
{
    //- initialize base symbol

    SegmenterInit(&pihzi->segr);

    //- set type

    pihzi->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_izhikevich;
}


/// 
/// \arg dx X coordinate
/// \arg dy Y coordinate
/// \arg dz Z coordinate
/// 
/// \return struct symtab_Izhikevich * : resulting cell, NULL for failure
/// 
/// \brief Allocate cell, put at specified position.
///
/// \details
/// 
///	Contains memory leak.
/// 

struct symtab_Izhikevich * IzhikevichNewAtXYZ(double dx, double dy, double dz)
{
    //- set result : new cell

    struct symtab_Izhikevich *pihziResult 
	= IzhikevichCalloc();

    //- put at position

    if (!BioComponentSetAtXYZ(&pihziResult->segr.bio, dx, dy, dz, 0))
    {
	return(NULL);
    }

    //- return result

    return(pihziResult);
}


