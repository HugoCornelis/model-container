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


static
double
PulseGenGetBeta
(struct symtab_PulseGen *ppulsegen, struct PidinStack *ppist);

static
double
PulseGenGetVolume
(struct symtab_PulseGen *ppulsegen, struct PidinStack *ppist);


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
/// \arg ppulsegen pulsegen to get unscaled beta for.
/// \arg ppist context of pulsegen.
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
PulseGenGetBeta
(struct symtab_PulseGen *ppulsegen, struct PidinStack *ppist)
{
    //- set default result : always one

    /// \note beta is completely dependent on other values, so this is ignored.

    double dResult = 1;

    //- return result

    return(dResult);
}


/// 
/// \arg ppulsegen symbol to get parameter for.
/// \arg ppist context of given symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol.
/// 

struct symtab_Parameters * 
PulseGenGetParameter
(struct symtab_PulseGen *ppulsegen,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&ppulsegen->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if beta

	if (0 == strcmp(pcName, "BETA"))
	{
	    //- get beta

	    double dBeta = PulseGenGetBeta(ppulsegen, ppist);

	    //- set beta of pulsegen, value will be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulsegen->bio.ioh.iol.hsle, "BETA", dBeta);
	}

	//- if volume

	else if (0 == strcmp(pcName, "VOLUME"))
	{
	    //- get volume

	    double dVolume = PulseGenGetVolume(ppulsegen, ppist);

	    //- set volume of pulsegen, value should be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulsegen->bio.ioh.iol.hsle, "VOLUME", dVolume);
	}

	//- if initial concentration

	else if (0 == strcmp(pcName, "concen_init"))
	{
	    //- get base

	    double dBase = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "BASE");

	    //- set initial concentration

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulsegen->bio.ioh.iol.hsle, "concen_init", dBase);
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg ppulsegen pulsegen to get volume for.
/// \arg ppist context of pulsegen.
/// 
/// \return double : pulsegen volume, FLT_MAX for failure.
/// 
/// \brief get volume of pulsegen.
/// 

static
double
PulseGenGetVolume
(struct symtab_PulseGen *ppulsegen, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- by default we assume we are not working with a pulsegen embedded
    //- in a spherical segment.

    int iSpherical = 0;

    //- if parent compartment can be found

    struct PidinStack *ppistComp
	= SymbolFindParentSegment(&ppulsegen->bio.ioh.iol.hsle, ppist);

    double dDiaFromParent = FLT_MAX;

    if (ppistComp)
    {
	struct symtab_HSolveListElement *phsleComp
	    = PidinStackLookupTopSymbol(ppistComp);

	if (phsleComp)
	{
	    //- set spherical flag for pulsegen calculations

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp))
	    {
		iSpherical = 1;
	    }

	    dDiaFromParent
		= SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	}

	PidinStackFree(ppistComp);

    }

    //- if spherical pulsegen

    if (iSpherical)
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "DIA");

	//t not really sure if this is correct...

	if (dDiaSegment == FLT_MAX)
	{
	    dDiaSegment = dDiaFromParent;
	}

	double dThickness
	    = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "THICK");

	if (dDiaSegment == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(FLT_MAX);
	}

	double dDiaPulseGen = 2 * dThickness;

	double d = dDiaSegment - dDiaPulseGen;

	double d1 = dDiaSegment * dDiaSegment * dDiaSegment;

	double d2 = d * d * d;

	dResult = (d1 - d2) * M_PI / 6.0;

/* 	dResult */
/* 	    = (( */
/* 		   3 * dDiaSegment * dDiaSegment * dDiaPulseGen */
/* 		   - 3 * dDiaSegment * dDiaPulseGen * dDiaPulseGen */
/* 		   + dDiaPulseGen * dDiaPulseGen * dDiaPulseGen */
/* 		   ) */
/* 	       * M_PI */
/* 	       / 6.0); */
    }
    else
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "DIA");

	double dLengthSegment
	    = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "LENGTH");

	double dThickness
	    = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "THICK");

	if (dDiaSegment == FLT_MAX
	    || dLengthSegment == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(FLT_MAX);
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

	double dDiaPulseGen = 2 * dThickness;

	double d = dDiaSegment - dDiaPulseGen;

	double d1 = dDiaSegment * dDiaSegment;

	double d2 = d * d;

	dResult = dLengthSegment * (d1 - d2) * M_PI / 4.0;

/* 	dResult */
/* 	    = (( */
/* 		   2 * dDiaSegment * dDiaPulseGen */
/* 		   - dDiaPulseGen * dDiaPulseGen */
/* 		   ) */
/* 	       * dLengthSegment */
/* 	       * M_PI */
/* 	       / 4.0); */
    }

    //- return result

    return(dResult);
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


/// 
/// \arg ppulsegen pulsegen to scale value for
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specify type of scaling
/// 
/// \return double : scaled value, FLT_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 

double
PulseGenParameterScaleValue
(struct symtab_PulseGen *ppulsegen,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = FLT_MAX;

    struct PidinStack *ppistComp = NULL;

    //- get pulsegen parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if beta

    if (0 == strcmp(pcName, "BETA"))
    {
	//- get pulsegen diameter

	double dPulseGenDia
	    = SymbolParameterResolveValue
	      ((struct symtab_HSolveListElement *)ppulsegen, ppist, "DIA");

	if (dPulseGenDia == FLT_MAX)
	{
	    ppistComp = SymbolFindParentSegment(&ppulsegen->bio.ioh.iol.hsle, ppist);

	    if (ppistComp)
	    {
		struct symtab_HSolveListElement *phsleComp
		    = PidinStackLookupTopSymbol(ppistComp);

		dPulseGenDia = SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	    }
	}

	//- get shell thickness

	struct symtab_Parameters *pparThickness
	    = SymbolFindParameter
	      ((struct symtab_HSolveListElement *)ppulsegen, ppist, "THICK");

	double dThickness
	    = ParameterResolveValue(pparThickness, ppist);

	if (dPulseGenDia == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(dResult);
	}

	//- calculate pseudo diameter

	double dDia = 2 * dThickness;

	//- find parent segment

	if (!ppistComp)
	{
	    ppistComp = SymbolFindParentSegment(&ppulsegen->bio.ioh.iol.hsle, ppist);
	}

	int iSpherical = 0;

	//- if found segment

	if (ppistComp)
	{
	    struct symtab_HSolveListElement *phsleComp
		= PidinStackLookupTopSymbol(ppistComp);

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp))
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
		= (3 * dPulseGenDia * dPulseGenDia * dDia
		   - 3 * dPulseGenDia * dDia * dDia
		   + dDia * dDia * dDia)
		* M_PI
		/ 6.0;
	}
	else
	{
	    //- get pulsegen length

	    double dPulseGenLength
		= SymbolParameterResolveValue
		  ((struct symtab_HSolveListElement *)ppulsegen, ppist, "LENGTH");

	    if (dPulseGenLength == FLT_MAX)
	    {
		ppistComp = SymbolFindParentSegment(&ppulsegen->bio.ioh.iol.hsle, ppist);

		if (ppistComp)
		{
		    struct symtab_HSolveListElement *phsleComp
			= PidinStackLookupTopSymbol(ppistComp);

		    dPulseGenLength = SymbolParameterResolveValue(phsleComp, ppistComp, "LENGTH");
		}
	    }

	    /// \note factor between parentheses comes from (see above)
	    /// \note (dCompDia^2 - (dCompDia - dDia)^2)

	    dVolume
		= (2 * dPulseGenDia * dDia
		   - dDia * dDia) * dPulseGenLength * M_PI / 4.0;
	}

	//- scale valency to pulsegen volume of segment

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
/// \arg ppulsegen pulsegen to reduce.
/// \arg ppist context of pulsegen.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a pulsegen.
///
/// \details Reduces:
///
///	BETA
///	VOLUME
/// 

int
PulseGenReduce
(struct symtab_PulseGen *ppulsegen, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    //- get volume

/*     double dVolume = SymbolParameterResolveValue(&ppulsegen->bio.ioh.iol.hsle, ppist, "VOLUME"); */

    //t if this one is enabled, PulseGenParameterScaleValue() for BETA
    //t will not find a pparPulseGenDia, and SEGV.

    //t when running tests/scripts/PurkM9_model/ACTIVE-soma1.g

    if (1)
    {
	//- get BETA parameter

	struct symtab_Parameters *pparBeta
	    = SymbolGetParameter(&ppulsegen->bio.ioh.iol.hsle, ppist, "BETA");

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

	    ParContainerDelete(ppulsegen->bio.pparc, pparBeta);
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
	    = SymbolGetParameter(&ppulsegen->bio.ioh.iol.hsle, ppist, "VOLUME");

	double dVolume = ParameterResolveValue(pparVolume, ppist);

	//- if present

	if (dVolume != FLT_MAX)
	{
	    double d = PulseGenGetVolume(ppulsegen, ppist);

	    if (MMGParmEQ(dVolume, d))
	    {
		//- remove VOLUME parameter

		ParContainerDelete(ppulsegen->bio.pparc, pparVolume);
	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&ppulsegen->bio, ppist);

    //- return result

    return(iResult);
}


