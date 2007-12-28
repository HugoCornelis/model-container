//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pool.c 1.56 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>


#include "neurospaces/pool.h"
#include "neurospaces/idin.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/segmenter.h"
#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


static double PoolGetBeta
(struct symtab_Pool *ppool, struct PidinStack *ppist);


/// **************************************************************************
///
/// SHORT: PoolCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Pool * 
///
///	Newly allocated pool, NULL for failure
///
/// DESCR: Allocate a new pool symbol table element
///
/// **************************************************************************

struct symtab_Pool * PoolCalloc(void)
{
    //- set default result : failure

    struct symtab_Pool *ppoolResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/pool_vtable.c"

    //- allocate pool

    ppoolResult
	= (struct symtab_Pool *)
	  SymbolCalloc(1, sizeof(struct symtab_Pool), _vtable_pool, HIERARCHY_TYPE_symbols_pool);

    //- initialize pool

    PoolInit(ppoolResult);

    //- return result

    return(ppoolResult);
}


/// **************************************************************************
///
/// SHORT: PoolCreateAlias()
///
/// ARGS.:
///
///	ppool.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
PoolCreateAlias
(struct symtab_Pool *ppool,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Pool *ppoolResult = PoolCalloc();

    //- set name and prototype

    SymbolSetName(&ppoolResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&ppoolResult->bio.ioh.iol.hsle, &ppool->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_pool);

    //- return result

    return(&ppoolResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: PoolGetBeta()
///
/// ARGS.:
///
///	ppool..: pool to get unscaled beta for.
///	ppist..: context of pool.
///
/// RTN..: double : always 1.
///
/// DESCR: Get time constant of segment.
///
///	Beta is completely dependent on other values, so this value is
///	ignored.
///
/// **************************************************************************

static double PoolGetBeta
(struct symtab_Pool *ppool, struct PidinStack *ppist)
{
    //- set default result : always one

    //! beta is completely dependent on other values, so this is ignored.

    double dResult = 1;

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: PoolGetParameter()
///
/// ARGS.:
///
///	ppool..: symbol to get parameter for
///	pcName.: name of parameter
///
/// RTN..: struct symtab_Parameters * : parameter structure
///
/// DESCR: Get parameter of symbol.
///
/// **************************************************************************

struct symtab_Parameters * 
PoolGetParameter
(struct symtab_Pool *ppool,
 char *pcName,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&ppool->bio, pcName, ppist);

    //- if not found

    if (!pparResult)
    {
	//- if surface

	if (0 == strcmp(pcName,"BETA"))
	{
	    //- get beta

	    double dBeta = PoolGetBeta(ppool, ppist);

	    //- set beta of pool, value will be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppool->bio.ioh.iol.hsle, "BETA", dBeta);
	}
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: PoolInit()
///
/// ARGS.:
///
///	ppool.: pool to init
///
/// RTN..: void
///
/// DESCR: init pool
///
/// **************************************************************************

void PoolInit(struct symtab_Pool *ppool)
{
    //- initialize base symbol

    BioComponentInit(&ppool->bio);

    //- set type

    ppool->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_pool;
}


/// **************************************************************************
///
/// SHORT: PoolLookupHierarchical()
///
/// ARGS.:
///
///	ppool.: pool container
///	ppist.: name(s) to search
///	iLevel: active level of ppist
///	bAll..: set TRUE if next entries in ppist have to be searched
///
/// RTN..: struct symtab_HSolveListElement * :
///
///	found symbol, NULL for not found
///
/// DESCR: Hierarchical lookup in pool subsymbols.
///
///	Always fails.
///
/// **************************************************************************

struct symtab_HSolveListElement *
PoolLookupHierarchical
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: PoolParameterScaleValue()
///
/// ARGS.:
///
///	ppool...: pool to scale value for
///	ppist...: context of given element
///	dValue..: value to scale
///	ppar....: parameter that specify type of scaling
///
/// RTN..: double : scaled value, FLT_MAX for failure
///
/// DESCR: Scale value according to parameter type and symbol type
///
/// **************************************************************************

double
PoolParameterScaleValue
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = FLT_MAX;

    //- get pool parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if beta

    if (0 == strcmp(pcName,"BETA"))
    {
	//v parent segment

	struct symtab_HSolveListElement *phsleComp = NULL;

	//- get pool diameter

	struct symtab_Parameters *pparPoolDia
	    = SymbolFindParameter
	      ((struct symtab_HSolveListElement *)ppool,"DIA",ppist);

	double dPoolDia = ParameterResolveValue(pparPoolDia,ppist);

	//- get shell thickness

	struct symtab_Parameters *pparThickness
	    = SymbolFindParameter
	      ((struct symtab_HSolveListElement *)ppool,"THICK",ppist);

	double dThickness
	    = ParameterResolveValue(pparThickness,ppist);

	if (dPoolDia == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(dResult);
	}

	//- calculate pseudo diameter

	double dDia = 2 * dThickness;

	//- copy context stack

	struct PidinStack *ppistComp = PidinStackDuplicate(ppist);

	//- loop

	do
	{
	    //- pop element

	    PidinStackPop(ppistComp);

	    //- get top symbol

	    phsleComp = PidinStackLookupTopSymbol(ppistComp);

	    //t this is a realy hack, to solve need to revisit all of
	    //t pidinstack and make it more consistent with:
	    //t
	    //t root symbols
	    //t rooted pidinstacks
	    //t namespaces
	    //t namespaced pidinstacks
	    //t
	    //t see also channel.c for a comparable hack.
	    //t

	    if (instanceof_root_symbol(phsleComp))
	    {
		phsleComp = NULL;
	    }
	}

	//- while not segment and more symbols to pop

	while (phsleComp && !instanceof_segment(phsleComp) && PidinStackTop(ppistComp));

	int iSpherical = 0;

	//- if found segment

	if (phsleComp && instanceof_segment(phsleComp))
	{
	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp))
	    {
		iSpherical = 1;
	    }
	}

	//v volume

	double dVolume;

	if (iSpherical)
	{
	    //! calculation of shell volume when compartment is spherical,
	    //! factor between parentheses comes from
	    //! (dCompDia^3 - (dCompDia - dDia)^3)
	    //! (optimized to minimize cancellations)

	    dVolume
		= (3 * dPoolDia * dPoolDia * dDia
		   - 3 * dPoolDia * dDia * dDia
		   + dDia * dDia * dDia)
		* M_PI
		/ 6.0;
	}
	else
	{
	    //- get pool length

	    struct symtab_Parameters *pparPoolLength
		= SymbolFindParameter
		((struct symtab_HSolveListElement *)ppool,"LENGTH",ppist);

	    double dPoolLength
		= ParameterResolveValue(pparPoolLength,ppist);

	    //! factor between parentheses comes from (see above)
	    //! (dCompDia^2 - (dCompDia - dDia)^2)

	    dVolume
		= (2 * dPoolDia * dDia
		   - dDia * dDia) * dPoolLength * M_PI / 4.0;
	}

	//- scale valency to pool volume of segment

	//t 2.0 is valency, get this from parameter

	dResult = 1.0 / (2.0 * 96494 * dVolume);

	//- free context of compartment

	PidinStackFree(ppistComp);
    }

    //- return result

    return(dResult);
}


