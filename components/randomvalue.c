//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: randomvalue.c 1.36 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include "neurospaces/components/attachment.h"
#include "neurospaces/components/randomvalue.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// 
/// 
/// \return struct symtab_Randomvalue * 
/// 
///	Newly allocated randomvalue, NULL for failure
/// 
/// \brief Allocate a new randomvalue symbol table element
/// \details 
/// 

struct symtab_Randomvalue * RandomvalueCalloc(void)
{
    //- set default result : failure

    struct symtab_Randomvalue *pranvResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/randomvalue_vtable.c"

    //- allocate randomvalue

    pranvResult
	= (struct symtab_Randomvalue *)
	  SymbolCalloc(1, sizeof(struct symtab_Randomvalue), _vtable_randomvalue, HIERARCHY_TYPE_symbols_randomvalue);

    //- initialize randomvalue

    RandomvalueInit(pranvResult);

    //- return result

    return(pranvResult);
}


/// 
/// 
/// \arg pranv symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
RandomvalueCreateAlias
(struct symtab_Randomvalue *pranv,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Randomvalue *pranvResult = RandomvalueCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pranvResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pranvResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pranvResult->bio.ioh.iol.hsle, &pranv->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_randomvalue);

    //- return result

    return(&pranvResult->bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pranv randomvalue 
/// \arg ppist occurence context
/// 
/// \return struct symtab_HSolveListElement *
/// 
///	Spike generator, NULL if not found, -1 for failure
/// 
/// \brief Get (first) spike generator for give randomvalue.
/// \details 
/// 

static int 
RandomvalueSpikeGeneratorChecker
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if incoming attachment

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- set result : ok

	*(struct symtab_HSolveListElement **)pvUserdata = phsle;

	//- set result : abort traversal

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}

struct symtab_HSolveListElement *
RandomvalueGetSpikeGenerator
(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist)
{
    //- set default result : NULL

    struct symtab_HSolveListElement *phsleResult = NULL;

    /// result from traversal

    int iTraversal;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   NULL,
	   NULL,
	   RandomvalueSpikeGeneratorChecker,
	   (void *)&phsleResult,
	   NULL,
	   NULL);

    //- traverse channel children, check for equation

    iTraversal = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if failure

    if (iTraversal == 0)
    {
	//- set result : failure

	phsleResult = (struct symtab_HSolveListElement *)-1;
    }

    //- return result

    return(phsleResult);
}


/// 
/// 
/// \arg pranv randomvalue to init
/// 
/// \return void
/// 
/// \brief init randomvalue
/// \details 
/// 

void RandomvalueInit(struct symtab_Randomvalue *pranv)
{
    //- initialize base symbol

    BioComponentInit(&pranv->bio);

    //- set type

    pranv->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_randomvalue;
}


/// 
/// 
/// \arg pranv randomvalue container
/// \arg ppist name(s) to search
/// \arg iLevel: active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in randomvalue subsymbols
/// \details 
/// 
///	Always fails.
/// 

struct symtab_HSolveListElement *
RandomvalueLookupHierarchical
(struct symtab_Randomvalue *pranv,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- return result

    return(phsleResult);
}


