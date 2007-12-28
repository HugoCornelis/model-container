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
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include <stdlib.h>
#include <string.h>


#include "neurospaces/randomvalue.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/attachment.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// **************************************************************************
///
/// SHORT: RandomvalueCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Randomvalue * 
///
///	Newly allocated randomvalue, NULL for failure
///
/// DESCR: Allocate a new randomvalue symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: RandomvalueCreateAlias()
///
/// ARGS.:
///
///	pranv.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
RandomvalueCreateAlias
(struct symtab_Randomvalue *pranv,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Randomvalue *pranvResult = RandomvalueCalloc();

    //- set name and prototype

    SymbolSetName(&pranvResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pranvResult->bio.ioh.iol.hsle, &pranv->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_randomvalue);

    //- return result

    return(&pranvResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: RandomvalueGetSpikeGenerator()
///
/// ARGS.:
///
///	pranv.: randomvalue 
///	ppist.: occurence context
///
/// RTN..: struct symtab_HSolveListElement *
///
///	Spike generator, NULL if not found, -1 for failure
///
/// DESCR: Get (first) spike generator for give randomvalue.
///
/// **************************************************************************

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

    //v result from traversal

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


/// **************************************************************************
///
/// SHORT: RandomvalueInit()
///
/// ARGS.:
///
///	pranv.: randomvalue to init
///
/// RTN..: void
///
/// DESCR: init randomvalue
///
/// **************************************************************************

void RandomvalueInit(struct symtab_Randomvalue *pranv)
{
    //- initialize base symbol

    BioComponentInit(&pranv->bio);

    //- set type

    pranv->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_randomvalue;
}


/// **************************************************************************
///
/// SHORT: RandomvalueLookupHierarchical()
///
/// ARGS.:
///
///	pranv.: randomvalue container
///	ppist.: name(s) to search
///	iLevel: active level of ppist
///	bAll..: set TRUE if next entries in ppist have to be searched
///
/// RTN..: struct symtab_HSolveListElement * :
///
///	found symbol, NULL for not found
///
/// DESCR: Hierarchical lookup in randomvalue subsymbols
///
///	Always fails.
///
/// **************************************************************************

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


