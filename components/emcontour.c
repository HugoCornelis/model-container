//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: emcontour.c 1.5 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/components/emcontour.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// 
/// \return struct symtab_EMContour * 
/// 
///	Newly allocated EM contour, NULL for failure
/// 
/// \brief Allocate a new EM contour symbol table element
/// \details 
/// 

struct symtab_EMContour * EMContourCalloc(void)
{
    //- set default result : failure

    struct symtab_EMContour *pemcResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/e_m_contour_vtable.c"

    //- allocate EM contour

    pemcResult
	= (struct symtab_EMContour *)
	  SymbolCalloc(1, sizeof(struct symtab_EMContour), _vtable_e_m_contour, HIERARCHY_TYPE_symbols_e_m_contour);

    //- initialize EM contour

    EMContourInit(pemcResult);

    //- return result

    return(pemcResult);
}


/// 
/// 
/// \arg pemc symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
EMContourCreateAlias
(struct symtab_EMContour *pemc,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_EMContour *pemcResult = EMContourCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pemcResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pemcResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pemcResult->bio.ioh.iol.hsle, &pemc->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_e_m_contour);

    //- return result

    return(&pemcResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pemc EM contour to init
/// 
/// \return void
/// 
/// \brief init EM contour
/// \details 
/// 

void EMContourInit(struct symtab_EMContour *pemc)
{
    //- initialize base symbol

    BioComponentInit(&pemc->bio);

    //- set type

    pemc->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_e_m_contour;
}


