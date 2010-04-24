//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pulse.c 1.56 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>


#include "neurospaces/components/pulsegen.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// 
/// \return struct symtab_PulseGen * 
/// 
///	Newly allocated pulsegen, NULL for failure
/// 
/// \brief Allocate a new pulsegen symbol table element
/// 

struct symtab_PulseGen * PulseGenCalloc(void)
{
    //- set default result : failure

    struct symtab_PulseGen *ppulsegenResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/pulse_gen_vtable.c"

    //- allocate pulsegen

    ppulsegenResult
	= (struct symtab_PulseGen *)
	  SymbolCalloc(1, sizeof(struct symtab_PulseGen), _vtable_pulse_gen, HIERARCHY_TYPE_symbols_pulse_gen);

    //- initialize pulsegen

    PulseGenInit(ppulsegenResult);

    //- return result

    return(ppulsegenResult);
}


/// 
/// \arg ppulsegen symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
PulseGenCreateAlias
(struct symtab_PulseGen *ppulsegen,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_PulseGen *ppulsegenResult = PulseGenCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&ppulsegenResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&ppulsegenResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&ppulsegenResult->bio.ioh.iol.hsle, &ppulsegen->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_pulse_gen);

    //- return result

    return(&ppulsegenResult->bio.ioh.iol.hsle);
}


/// 
/// \arg ppulsegen pulsegen to init
/// 
/// \return void
/// 
/// \brief init pulsegen
/// 

void PulseGenInit(struct symtab_PulseGen *ppulsegen)
{
    //- initialize base symbol

    BioComponentInit(&ppulsegen->bio);

    //- set type

    ppulsegen->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_pulse_gen;
}


/// 
/// \arg ppulsegen pulsegen container
/// \arg ppist name(s) to search
/// \arg iLevel: active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in pulsegen subsymbols.
///
/// \details 
/// 
///	Always fails.
/// 

struct symtab_HSolveListElement *
PulseGenLookupHierarchical
(struct symtab_PulseGen *ppulsegen,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- return result

    return(phsleResult);
}


