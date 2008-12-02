//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: contourpoint.c 1.6 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/components/contourpoint.h"

#include "neurospaces/symbolvirtual_protos.h"


static double ContourPointGetThickness
(struct symtab_ContourPoint *pcpnt, struct PidinStack *ppist);


/// 
/// 
/// \return struct symtab_ContourPoint * 
/// 
///	Newly allocated contour point, NULL for failure
/// 
/// \brief Allocate a new contour point symbol table element
/// \details 
/// 

struct symtab_ContourPoint * ContourPointCalloc(void)
{
    //- set default result : failure

    struct symtab_ContourPoint *pcpntResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/contour_point_vtable.c"

    //- allocate contour point

    pcpntResult
	= (struct symtab_ContourPoint *)
	  SymbolCalloc(1, sizeof(struct symtab_ContourPoint), _vtable_contour_point, HIERARCHY_TYPE_symbols_contour_point);

    //- initialize contour point

    ContourPointInit(pcpntResult);

    //- return result

    return(pcpntResult);
}


/// 
/// 
/// \arg pcpnt symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
ContourPointCreateAlias
(struct symtab_ContourPoint *pcpnt,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_ContourPoint *pcpntResult = ContourPointCalloc();

    //- set name and prototype

    SymbolSetName(&pcpntResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pcpntResult->bio.ioh.iol.hsle, &pcpnt->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_contour_point);

    //- return result

    return(&pcpntResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pcpnt symbol to get parameter for
/// \arg ppist context.
/// \arg pcName name of parameter
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get specific parameter of symbol.
/// \details 
/// 

struct symtab_Parameters * 
ContourPointGetParameter
(struct symtab_ContourPoint *pcpnt,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&pcpnt->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if somatopetal distance

	if (0 == strcmp(pcName, "THICKNESS"))
	{
	    //- get distance

	    double dThickness = ContourPointGetThickness(pcpnt, ppist);

	    //- set distance of segment

	    pparResult
		= SymbolSetParameterDouble
		  (&pcpnt->bio.ioh.iol.hsle, "THICKNESS", dThickness);
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// 
/// \arg pcpnt contour point.
/// \arg ppist context.
/// 
/// \return double
/// 
///	thickness for contour to which the contour point belongs.
/// 
/// \brief Obtain thickness for contour to which the point belongs.
/// \details 
/// 

static
double
ContourPointGetThickness
(struct symtab_ContourPoint *pcpnt, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- create a working context

    struct PidinStack *ppistWorking = PidinStackDuplicate(ppist);

    //- find a cell in the context

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppistWorking);

    while (!instanceof_e_m_contour(phsle))
    {
	if (!PidinStackPop(ppistWorking))
	{
	    return(FLT_MAX);
	}

	phsle = PidinStackLookupTopSymbol(ppistWorking);
    }

    //- get length of contour

    dResult = SymbolParameterResolveValue(phsle, ppistWorking, "THICKNESS");

    //- return result

    return(dResult);
}


/// 
/// 
/// \arg pcpnt contour point to init
/// 
/// \return void
/// 
/// \brief init contour point
/// \details 
/// 

void ContourPointInit(struct symtab_ContourPoint *pcpnt)
{
    //- initialize base symbol

    BioComponentInit(&pcpnt->bio);

    //- set type

    pcpnt->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_contour_point;
}


