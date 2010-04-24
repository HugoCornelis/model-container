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


#include "neurospaces/components/pool.h"
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


static
double
PoolGetBeta
(struct symtab_Pool *ppool, struct PidinStack *ppist);

static
double
PoolGetVolume
(struct symtab_Pool *ppool, struct PidinStack *ppist);


/// 
/// \return struct symtab_Pool * 
/// 
///	Newly allocated pool, NULL for failure
/// 
/// \brief Allocate a new pool symbol table element
/// 

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


/// 
/// \arg ppool symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
PoolCreateAlias
(struct symtab_Pool *ppool,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Pool *ppoolResult = PoolCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&ppoolResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&ppoolResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&ppoolResult->bio.ioh.iol.hsle, &ppool->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_pool);

    //- return result

    return(&ppoolResult->bio.ioh.iol.hsle);
}


/// 
/// \arg ppool pool to get unscaled beta for.
/// \arg ppist context of pool.
/// 
/// \return double : always 1.
/// 
/// \brief Get time constant of segment.
///
/// \details 
/// 
///	Beta is completely dependent on other values, so this value is
///	ignored.
/// 

static
double
PoolGetBeta
(struct symtab_Pool *ppool, struct PidinStack *ppist)
{
    //- set default result : always one

    /// \note beta is completely dependent on other values, so this is ignored.

    double dResult = 1;

    //- return result

    return(dResult);
}


/// 
/// \arg ppool symbol to get parameter for.
/// \arg ppist context of given symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol.
/// 

struct symtab_Parameters * 
PoolGetParameter
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&ppool->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if beta

	if (0 == strcmp(pcName, "BETA"))
	{
	    //- get beta

	    double dBeta = PoolGetBeta(ppool, ppist);

	    //- set beta of pool, value will be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppool->bio.ioh.iol.hsle, "BETA", dBeta);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if volume

	else if (0 == strcmp(pcName, "VOLUME"))
	{
	    //- get volume

	    double dVolume = PoolGetVolume(ppool, ppist);

	    //- set volume of pool, value should be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppool->bio.ioh.iol.hsle, "VOLUME", dVolume);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}

	//- if initial concentration

	else if (0 == strcmp(pcName, "concen_init"))
	{
	    //- get base

	    double dBase = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "BASE");

	    //- set initial concentration

	    pparResult
		= SymbolSetParameterDouble
		  (&ppool->bio.ioh.iol.hsle, "concen_init", dBase);

	    pparResult->iFlags |= FLAG_PARA_DERIVED;
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg ppool pool to get volume for.
/// \arg ppist context of pool.
/// 
/// \return double : pool volume, DBL_MAX for failure.
/// 
/// \brief get volume of pool.
/// 

static
double
PoolGetVolume
(struct symtab_Pool *ppool, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = DBL_MAX;

    //- by default we assume we are not working with a pool embedded
    //- in a spherical segment.

    int iSpherical = 0;

    //- if parent compartment can be found

    struct PidinStack *ppistComp
	= SymbolFindParentSegment(&ppool->bio.ioh.iol.hsle, ppist);

    double dDiaFromParent = DBL_MAX;

    if (ppistComp)
    {
	struct symtab_HSolveListElement *phsleComp
	    = PidinStackLookupTopSymbol(ppistComp);

	if (phsleComp)
	{
	    //- set spherical flag for pool calculations

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp, ppistComp))
	    {
		iSpherical = 1;
	    }

	    dDiaFromParent
		= SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	}

	PidinStackFree(ppistComp);

    }

    //- if spherical pool

    if (iSpherical)
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "DIA");

	//t not really sure if this is correct...

	if (dDiaSegment == DBL_MAX)
	{
	    dDiaSegment = dDiaFromParent;
	}

	double dThickness
	    = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "THICK");

	if (dDiaSegment == DBL_MAX
	    || dThickness == DBL_MAX)
	{
	    return(DBL_MAX);
	}

	double dDiaPool = 2 * dThickness;

	double d = dDiaSegment - dDiaPool;

	double d1 = dDiaSegment * dDiaSegment * dDiaSegment;

	double d2 = d * d * d;

	dResult = (d1 - d2) * M_PI / 6.0;

/* 	dResult */
/* 	    = (( */
/* 		   3 * dDiaSegment * dDiaSegment * dDiaPool */
/* 		   - 3 * dDiaSegment * dDiaPool * dDiaPool */
/* 		   + dDiaPool * dDiaPool * dDiaPool */
/* 		   ) */
/* 	       * M_PI */
/* 	       / 6.0); */
    }
    else
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "DIA");

	double dLengthSegment
	    = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "LENGTH");

	double dThickness
	    = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "THICK");

	if (dDiaSegment == DBL_MAX
	    || dLengthSegment == DBL_MAX
	    || dThickness == DBL_MAX)
	{
	    return(DBL_MAX);
	}

/* 	if (thick>0.0) { */
/* 		d=dia-2*thick; */
/*                 if (d<0.0) d=0.0; /* JMI * */
/* 	} else { */
/* 		d=0.0; */
/* 	} */
/* 	if (len == 0.0) {       /* SPHERICAL * */
/* 	    v1 =  dia * dia * dia; */
/* 	    v2 =  d * d * d; */
/* 	    volume=(v1-v2)*PI/6.0; */
/* 	} else {            /* CYLINDRICAL * */
/* 	    v1 = dia * dia; */
/* 	    v2 = d * d; */
/* 	    volume=len*(v1-v2)*PI/4.0; */
/* 	} */
/* 	return(volume); */

	double dDiaPool = 2 * dThickness;

	double d = dDiaSegment - dDiaPool;

	double d1 = dDiaSegment * dDiaSegment;

	double d2 = d * d;

	dResult = dLengthSegment * (d1 - d2) * M_PI / 4.0;

/* 	dResult */
/* 	    = (( */
/* 		   2 * dDiaSegment * dDiaPool */
/* 		   - dDiaPool * dDiaPool */
/* 		   ) */
/* 	       * dLengthSegment */
/* 	       * M_PI */
/* 	       / 4.0); */
    }

    //- return result

    return(dResult);
}


/// 
/// \arg ppool pool to init
/// 
/// \return void
/// 
/// \brief init pool
/// 

void PoolInit(struct symtab_Pool *ppool)
{
    //- initialize base symbol

    BioComponentInit(&ppool->bio);

    //- set type

    ppool->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_pool;
}


/// 
/// \arg ppool pool container
/// \arg ppist name(s) to search
/// \arg iLevel: active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in pool subsymbols.
///
/// \details 
/// 
///	Always fails.
/// 

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


/// 
/// \arg ppool pool to scale value for
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specify type of scaling
/// 
/// \return double : scaled value, DBL_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 

double
PoolParameterScaleValue
(struct symtab_Pool *ppool,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = DBL_MAX;

    struct PidinStack *ppistComp = NULL;

    //- get pool parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if beta

    if (0 == strcmp(pcName, "BETA"))
    {
	//- get pool diameter

	double dPoolDia
	    = SymbolParameterResolveValue
	      ((struct symtab_HSolveListElement *)ppool, ppist, "DIA");

	if (dPoolDia == DBL_MAX)
	{
	    ppistComp = SymbolFindParentSegment(&ppool->bio.ioh.iol.hsle, ppist);

	    if (ppistComp)
	    {
		struct symtab_HSolveListElement *phsleComp
		    = PidinStackLookupTopSymbol(ppistComp);

		dPoolDia = SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	    }
	}

	//- get shell thickness

	struct symtab_Parameters *pparThickness
	    = SymbolFindParameter
	      ((struct symtab_HSolveListElement *)ppool, ppist, "THICK");

	if (!pparThickness)
	{
	    if (ppistComp)
	    {
		PidinStackFree(ppistComp);
	    }

	    return(dResult);
	}

	double dThickness
	    = ParameterResolveValue(pparThickness, ppist);

	if (dPoolDia == DBL_MAX
	    || dThickness == DBL_MAX)
	{
	    if (ppistComp)
	    {
		PidinStackFree(ppistComp);
	    }

	    return(dResult);
	}

	//- calculate pseudo diameter

	double dDia = 2 * dThickness;

	//- find parent segment

	if (!ppistComp)
	{
	    ppistComp = SymbolFindParentSegment(&ppool->bio.ioh.iol.hsle, ppist);
	}

	int iSpherical = 0;

	//- if found segment

	if (ppistComp)
	{
	    struct symtab_HSolveListElement *phsleComp
		= PidinStackLookupTopSymbol(ppistComp);

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp, ppistComp))
	    {
		iSpherical = 1;
	    }
	}

	/// volume

	double dVolume;

	if (iSpherical)
	{
	    /// \note calculation of shell volume when compartment is spherical,
	    /// \note factor between parentheses comes from
	    /// \note (dCompDia^3 - (dCompDia - dDia)^3)
	    /// \note (optimized to minimize cancellations)

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

	    double dPoolLength
		= SymbolParameterResolveValue
		  ((struct symtab_HSolveListElement *)ppool, ppist, "LENGTH");

	    if (dPoolLength == DBL_MAX)
	    {
		ppistComp = SymbolFindParentSegment(&ppool->bio.ioh.iol.hsle, ppist);

		if (ppistComp)
		{
		    struct symtab_HSolveListElement *phsleComp
			= PidinStackLookupTopSymbol(ppistComp);

		    dPoolLength = SymbolParameterResolveValue(phsleComp, ppistComp, "LENGTH");
		}
	    }

	    /// \note factor between parentheses comes from (see above)
	    /// \note (dCompDia^2 - (dCompDia - dDia)^2)

	    dVolume
		= (2 * dPoolDia * dDia
		   - dDia * dDia) * dPoolLength * M_PI / 4.0;
	}

	//- scale valency to pool volume of segment

	/// \todo 2.0 is valency, get this from parameter

	dResult = 1.0 / (2.0 * 96494 * dVolume);

	//- free context of compartment

	if (ppistComp)
	{
	    PidinStackFree(ppistComp);
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg ppool pool to reduce.
/// \arg ppist context of pool.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a pool.
///
/// \details Reduces:
///
///	BETA
///	VOLUME
/// 

int
PoolReduce
(struct symtab_Pool *ppool, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    //- get volume

/*     double dVolume = SymbolParameterResolveValue(&ppool->bio.ioh.iol.hsle, ppist, "VOLUME"); */

    //t if this one is enabled, PoolParameterScaleValue() for BETA
    //t will not find a pparPoolDia, and SEGV.

    //t when running tests/scripts/PurkM9_model/ACTIVE-soma1.g

    if (1)
    {
	//- get BETA parameter

	struct symtab_Parameters *pparBeta
	    = SymbolGetParameter(&ppool->bio.ioh.iol.hsle, ppist, "BETA");

	//t THICKNESS known
	//t DIA required
	//t LENGTH required
	//t spherical flag required

	//t calculate volume
	//t spherical
	//t   shell_vol = (3*dia*dia*shell_dia - 3*dia*shell_dia*shell_dia + shell_dia*shell_dia*shell_dia)*{PI}/6.0
	//t   B = {1.0/(2.0*96494*shell_vol)}
	//t cylindrical
	//t   shell_vol = (2*dia*shell_dia - shell_dia*shell_dia)*len*{PI}/4.0
	//t   B = {1.0/(2.0*96494*shell_vol)}

	//- if has GENESIS2 function

	if (ParameterIsFunction(pparBeta)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparBeta)), "GENESIS2") == 0)
	{
	    //- remove BETA parameter

	    ParContainerDelete(ppool->bio.pparc, pparBeta);
	}
    }

    //t if this one is enabled, 'Running the purkinje cell soma by
    //t itself, active channels, current injections' fails.

    //t when running tests/scripts/PurkM9_model/ACTIVE-soma1.g

    if (1)
    {
	/// accuracy constant

	static double dGeoRoundOff = 0.00001;

/* #define MMGParmEQzero(d)				(int)( fabs(d) <= (dGeoRoundOff) ) */
#define MMGParmEQ(d1, d2)				(int)( /* (MMGParmEQzero((d1))  && MMGParmEQzero((d2))) || */ fabs((d1) - (d2)) <= ((dGeoRoundOff) * fabs((d2))) )

	//- get VOLUME parameter

	struct symtab_Parameters *pparVolume
	    = SymbolGetParameter(&ppool->bio.ioh.iol.hsle, ppist, "VOLUME");

	double dVolume = ParameterResolveValue(pparVolume, ppist);

	//- if present

	if (dVolume != DBL_MAX)
	{
	    double d = PoolGetVolume(ppool, ppist);

	    if (MMGParmEQ(dVolume, d))
	    {
		//- remove VOLUME parameter

		ParContainerDelete(ppool->bio.pparc, pparVolume);
	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&ppool->bio, ppist);

    //- return result

    return(iResult);
}


