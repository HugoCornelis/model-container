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


#include "neurospaces/components/pulse.h"
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
PulseGetBeta
(struct symtab_Pulse *ppulse, struct PidinStack *ppist);

static
double
PulseGetVolume
(struct symtab_Pulse *ppulse, struct PidinStack *ppist);


/// 
/// \return struct symtab_Pulse * 
/// 
///	Newly allocated pulse, NULL for failure
/// 
/// \brief Allocate a new pulse symbol table element
/// 

struct symtab_Pulse * PulseCalloc(void)
{
    //- set default result : failure

    struct symtab_Pulse *ppulseResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/pulse_vtable.c"

    //- allocate pulse

    ppulseResult
	= (struct symtab_Pulse *)
	  SymbolCalloc(1, sizeof(struct symtab_Pulse), _vtable_pulse, HIERARCHY_TYPE_symbols_pulse);

    //- initialize pulse

    PulseInit(ppulseResult);

    //- return result

    return(ppulseResult);
}


/// 
/// \arg ppulse symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
PulseCreateAlias
(struct symtab_Pulse *ppulse,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Pulse *ppulseResult = PulseCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&ppulseResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&ppulseResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&ppulseResult->bio.ioh.iol.hsle, &ppulse->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_pulse);

    //- return result

    return(&ppulseResult->bio.ioh.iol.hsle);
}


/// 
/// \arg ppulse pulse to get unscaled beta for.
/// \arg ppist context of pulse.
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
PulseGetBeta
(struct symtab_Pulse *ppulse, struct PidinStack *ppist)
{
    //- set default result : always one

    /// \note beta is completely dependent on other values, so this is ignored.

    double dResult = 1;

    //- return result

    return(dResult);
}


/// 
/// \arg ppulse symbol to get parameter for.
/// \arg ppist context of given symbol.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters * : parameter structure
/// 
/// \brief Get parameter of symbol.
/// 

struct symtab_Parameters * 
PulseGetParameter
(struct symtab_Pulse *ppulse,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&ppulse->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if beta

	if (0 == strcmp(pcName, "BETA"))
	{
	    //- get beta

	    double dBeta = PulseGetBeta(ppulse, ppist);

	    //- set beta of pulse, value will be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulse->bio.ioh.iol.hsle, "BETA", dBeta);
	}

	//- if volume

	else if (0 == strcmp(pcName, "VOLUME"))
	{
	    //- get volume

	    double dVolume = PulseGetVolume(ppulse, ppist);

	    //- set volume of pulse, value should be ignored.

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulse->bio.ioh.iol.hsle, "VOLUME", dVolume);
	}

	//- if initial concentration

	else if (0 == strcmp(pcName, "concen_init"))
	{
	    //- get base

	    double dBase = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "BASE");

	    //- set initial concentration

	    pparResult
		= SymbolSetParameterDouble
		  (&ppulse->bio.ioh.iol.hsle, "concen_init", dBase);
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg ppulse pulse to get volume for.
/// \arg ppist context of pulse.
/// 
/// \return double : pulse volume, FLT_MAX for failure.
/// 
/// \brief get volume of pulse.
/// 

static
double
PulseGetVolume
(struct symtab_Pulse *ppulse, struct PidinStack *ppist)
{
    //- set default result : failure

    double dResult = FLT_MAX;

    //- by default we assume we are not working with a pulse embedded
    //- in a spherical segment.

    int iSpherical = 0;

    //- if parent compartment can be found

    struct PidinStack *ppistComp
	= SymbolFindParentSegment(&ppulse->bio.ioh.iol.hsle, ppist);

    double dDiaFromParent = FLT_MAX;

    if (ppistComp)
    {
	struct symtab_HSolveListElement *phsleComp
	    = PidinStackLookupTopSymbol(ppistComp);

	if (phsleComp)
	{
	    //- set spherical flag for pulse calculations

	    if (SegmenterIsSpherical((struct symtab_Segmenter *)phsleComp))
	    {
		iSpherical = 1;
	    }

	    dDiaFromParent
		= SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	}

	PidinStackFree(ppistComp);

    }

    //- if spherical pulse

    if (iSpherical)
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "DIA");

	//t not really sure if this is correct...

	if (dDiaSegment == FLT_MAX)
	{
	    dDiaSegment = dDiaFromParent;
	}

	double dThickness
	    = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "THICK");

	if (dDiaSegment == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(FLT_MAX);
	}

	double dDiaPulse = 2 * dThickness;

	double d = dDiaSegment - dDiaPulse;

	double d1 = dDiaSegment * dDiaSegment * dDiaSegment;

	double d2 = d * d * d;

	dResult = (d1 - d2) * M_PI / 6.0;

/* 	dResult */
/* 	    = (( */
/* 		   3 * dDiaSegment * dDiaSegment * dDiaPulse */
/* 		   - 3 * dDiaSegment * dDiaPulse * dDiaPulse */
/* 		   + dDiaPulse * dDiaPulse * dDiaPulse */
/* 		   ) */
/* 	       * M_PI */
/* 	       / 6.0); */
    }
    else
    {
	double dDiaSegment
	    = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "DIA");

	double dLengthSegment
	    = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "LENGTH");

	double dThickness
	    = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "THICK");

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

	double dDiaPulse = 2 * dThickness;

	double d = dDiaSegment - dDiaPulse;

	double d1 = dDiaSegment * dDiaSegment;

	double d2 = d * d;

	dResult = dLengthSegment * (d1 - d2) * M_PI / 4.0;

/* 	dResult */
/* 	    = (( */
/* 		   2 * dDiaSegment * dDiaPulse */
/* 		   - dDiaPulse * dDiaPulse */
/* 		   ) */
/* 	       * dLengthSegment */
/* 	       * M_PI */
/* 	       / 4.0); */
    }

    //- return result

    return(dResult);
}


/// 
/// \arg ppulse pulse to init
/// 
/// \return void
/// 
/// \brief init pulse
/// 

void PulseInit(struct symtab_Pulse *ppulse)
{
    //- initialize base symbol

    BioComponentInit(&ppulse->bio);

    //- set type

    ppulse->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_pulse;
}


/// 
/// \arg ppulse pulse container
/// \arg ppist name(s) to search
/// \arg iLevel: active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in pulse subsymbols.
///
/// \details 
/// 
///	Always fails.
/// 

struct symtab_HSolveListElement *
PulseLookupHierarchical
(struct symtab_Pulse *ppulse,
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
/// \arg ppulse pulse to scale value for
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specify type of scaling
/// 
/// \return double : scaled value, FLT_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 

double
PulseParameterScaleValue
(struct symtab_Pulse *ppulse,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = FLT_MAX;

    struct PidinStack *ppistComp = NULL;

    //- get pulse parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if beta

    if (0 == strcmp(pcName, "BETA"))
    {
	//- get pulse diameter

	double dPulseDia
	    = SymbolParameterResolveValue
	      ((struct symtab_HSolveListElement *)ppulse, ppist, "DIA");

	if (dPulseDia == FLT_MAX)
	{
	    ppistComp = SymbolFindParentSegment(&ppulse->bio.ioh.iol.hsle, ppist);

	    if (ppistComp)
	    {
		struct symtab_HSolveListElement *phsleComp
		    = PidinStackLookupTopSymbol(ppistComp);

		dPulseDia = SymbolParameterResolveValue(phsleComp, ppistComp, "DIA");
	    }
	}

	//- get shell thickness

	struct symtab_Parameters *pparThickness
	    = SymbolFindParameter
	      ((struct symtab_HSolveListElement *)ppulse, ppist, "THICK");

	double dThickness
	    = ParameterResolveValue(pparThickness, ppist);

	if (dPulseDia == FLT_MAX
	    || dThickness == FLT_MAX)
	{
	    return(dResult);
	}

	//- calculate pseudo diameter

	double dDia = 2 * dThickness;

	//- find parent segment

	if (!ppistComp)
	{
	    ppistComp = SymbolFindParentSegment(&ppulse->bio.ioh.iol.hsle, ppist);
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
		= (3 * dPulseDia * dPulseDia * dDia
		   - 3 * dPulseDia * dDia * dDia
		   + dDia * dDia * dDia)
		* M_PI
		/ 6.0;
	}
	else
	{
	    //- get pulse length

	    double dPulseLength
		= SymbolParameterResolveValue
		  ((struct symtab_HSolveListElement *)ppulse, ppist, "LENGTH");

	    if (dPulseLength == FLT_MAX)
	    {
		ppistComp = SymbolFindParentSegment(&ppulse->bio.ioh.iol.hsle, ppist);

		if (ppistComp)
		{
		    struct symtab_HSolveListElement *phsleComp
			= PidinStackLookupTopSymbol(ppistComp);

		    dPulseLength = SymbolParameterResolveValue(phsleComp, ppistComp, "LENGTH");
		}
	    }

	    /// \note factor between parentheses comes from (see above)
	    /// \note (dCompDia^2 - (dCompDia - dDia)^2)

	    dVolume
		= (2 * dPulseDia * dDia
		   - dDia * dDia) * dPulseLength * M_PI / 4.0;
	}

	//- scale valency to pulse volume of segment

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
/// \arg ppulse pulse to reduce.
/// \arg ppist context of pulse.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a pulse.
///
/// \details Reduces:
///
///	BETA
///	VOLUME
/// 

int
PulseReduce
(struct symtab_Pulse *ppulse, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    //- get volume

/*     double dVolume = SymbolParameterResolveValue(&ppulse->bio.ioh.iol.hsle, ppist, "VOLUME"); */

    //t if this one is enabled, PulseParameterScaleValue() for BETA
    //t will not find a pparPulseDia, and SEGV.

    //t when running tests/scripts/PurkM9_model/ACTIVE-soma1.g

    if (1)
    {
	//- get BETA parameter

	struct symtab_Parameters *pparBeta
	    = SymbolGetParameter(&ppulse->bio.ioh.iol.hsle, ppist, "BETA");

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

	    ParContainerDelete(ppulse->bio.pparc, pparBeta);
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
	    = SymbolGetParameter(&ppulse->bio.ioh.iol.hsle, ppist, "VOLUME");

	double dVolume = ParameterResolveValue(pparVolume, ppist);

	//- if present

	if (dVolume != FLT_MAX)
	{
	    double d = PulseGetVolume(ppulse, ppist);

	    if (MMGParmEQ(dVolume, d))
	    {
		//- remove VOLUME parameter

		ParContainerDelete(ppulse->bio.pparc, pparVolume);
	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&ppulse->bio, ppist);

    //- return result

    return(iResult);
}


