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



#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/membraneleak.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"

#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif



/// 
/// \return struct symtab_MembraneLeak * 
/// 
///	Newly allocated membrane leak, NULL for failure
/// 
/// \brief Allocate a new membrane leak symbol table element
/// 

struct symtab_MembraneLeak * MembraneLeakCalloc(void)
{
    //- set default result : failure

    struct symtab_MembraneLeak *pmemlResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/membrane_leak_vtable.c"

    //- allocate membrane leak

    pmemlResult
	= (struct symtab_MembraneLeak *)
	  SymbolCalloc(1, sizeof(struct symtab_MembraneLeak), _vtable_membrane_leak, HIERARCHY_TYPE_symbols_membrane_leak);

    //- initialize membrane leak

    MembraneLeakInit(pmemlResult);

    //- return result

    return(pmemlResult);
}


/// 
/// \arg pmeml symbol to collect mandatory parameters for.
/// \arg ppist context.
/// 
/// \return int : success of operation.
/// 
/// \brief Collect mandatory simulation parameters for this symbol,
/// instantiate them in cache such that they are present during
/// serialization.
/// 

int
MembraneLeakCollectMandatoryParameterValues
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    static char *ppc_membrane_leak_mandatory_parameter_names[] =
	{
	    "Erev",
	    (char *)0,
	};

    int i;

    for (i = 0 ; ppc_membrane_leak_mandatory_parameter_names[i] ; i++)
    {
	struct symtab_Parameters *pparValue
	    = SymbolFindParameter(&pmeml->bio.ioh.iol.hsle, ppist, ppc_membrane_leak_mandatory_parameter_names[i]);

	struct symtab_Parameters *pparOriginal
	    = ParameterLookup(pmeml->bio.pparc->ppars, ppc_membrane_leak_mandatory_parameter_names[i]);

	if (pparValue && (!pparOriginal || ParameterIsSymbolic(pparOriginal) || ParameterIsField(pparOriginal)))
	{
	    double dValue = ParameterResolveValue(pparValue, ppist);

	    struct symtab_Parameters *pparDuplicate = ParameterNewFromNumber(ppc_membrane_leak_mandatory_parameter_names[i], dValue);

	    BioComponentChangeParameter(&pmeml->bio, pparDuplicate);
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pmeml symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
MembraneLeakCreateAlias
(struct symtab_MembraneLeak *pmeml,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_MembraneLeak *pmemlResult = MembraneLeakCalloc();

    //\todo this is a hack that also introduces a memory leak: release
    // the IO list

    SymbolAssignBindableIO(&pmemlResult->bio.ioh.iol.hsle, NULL);

    //- set name, namespace and prototype

    SymbolSetName(&pmemlResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pmemlResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pmemlResult->bio.ioh.iol.hsle, &pmeml->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_membrane_leak);

    //- return result

    return(&pmemlResult->bio.ioh.iol.hsle);
}


/// 
/// \arg pmeml membrane leak to check
/// \arg ppist context of membrane leak
/// 
/// \return int : TRUE if membrane leak MG block dependent
/// 
/// \brief Check if membrane leak conductance is blocked by magnesium.
/// 

int
MembraneLeakHasMGBlockGMAX
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if GMAX present

    struct symtab_Parameters *pparGMAX
	= SymbolFindParameter(&(pmeml->bio.ioh.iol.hsle), ppist, "G_MAX");

    if (pparGMAX)
    {
	//- if GMAX is function

	if (ParameterIsFunction(pparGMAX))
	{
	    //- get function

	    struct symtab_Function *pfunGMAX
		= ParameterGetFunction(pparGMAX);

	    //- if function name is MGBLOCK

	    if (strcmp(FunctionGetName(pfunGMAX), "MGBLOCK") == 0)
	    {
		//- set result : ok

		bResult = TRUE;
	    }
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pmeml membrane leak to check
/// \arg ppist context of membrane leak
/// 
/// \return int : TRUE if membrane leak has nernst
/// 
/// \brief Check if membrane leak Erev nernst-equation controlled
/// 

int MembraneLeakHasNernstErev
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if Erev present

    struct symtab_Parameters *pparErev
	= SymbolFindParameter(&(pmeml->bio.ioh.iol.hsle), ppist, "Erev");

    if (pparErev)
    {
	//- if Erev is function

	//  if (ParameterIsFunction(pparErev))
	{
	    //- get function

	    struct symtab_Function *pfunErev
		= ParameterContextGetFunction(pparErev, ppist);

	    //- if function name is NERNST

	    if (pfunErev)
	    {
		if (strcmp(FunctionGetName(pfunErev), "NERNST") == 0)
		{
		    //- set result : ok

		    bResult = TRUE;
		}
	    }
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pmeml membrane leak to init
/// 
/// \return void
/// 
/// \brief init membrane leak
/// 

void MembraneLeakInit(struct symtab_MembraneLeak *pmeml)
{
    //- initialize base symbol

    BioComponentInit(&pmeml->bio);

    //- set type

    pmeml->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_membrane_leak;

    //- create default bindables for the MembraneLeak.

    static char *ppcParameters[] = {
	"Vm",
	"G",
	"I",
	NULL,
    };

    static int piTypes[] = {
	INPUT_TYPE_INPUT,
	INPUT_TYPE_OUTPUT,
	INPUT_TYPE_OUTPUT,
	INPUT_TYPE_INVALID,
    };

    static struct symtab_IOContainer *piocMembraneLeakDefault = NULL;

    if (!piocMembraneLeakDefault)
    {
	piocMembraneLeakDefault = IOContainerNewFromList(ppcParameters, piTypes);
    }

    SymbolAssignBindableIO(&pmeml->bio.ioh.iol.hsle, piocMembraneLeakDefault);
}


/// 
/// \arg pmeml membrane leak to reduce.
/// \arg ppist context of membrane leak.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a membrane leak.
///
/// \details Reduces:
///

int
MembraneLeakReduce
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    {
	//- get G_MAX parameter

	struct symtab_Parameters *pparG
	    = SymbolGetParameter(&pmeml->bio.ioh.iol.hsle, ppist, "G_MAX");

	//- if has GENESIS2 function

	if (0
	    && pparG
	    && ParameterIsFunction(pparG)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparG)), "GENESIS2") == 0)
	{
	    //- get scaled conductance

	    double dGScaled = ParameterResolveScaledValue(pparG, ppist);

	    //- find parent segment

	    struct PidinStack *ppistComp
		= SymbolFindParentSegment(&pmeml->bio.ioh.iol.hsle, ppist);

	    //- if found segment

	    if (ppistComp)
	    {
/* 		//- remove the previous G_MAX parameter */

/* 		ParContainerDelete(pmeml->bio.pparc, pparG); */

		/// surface

		double dSurface;

		//- get segment diameter

		struct symtab_HSolveListElement *phsle
		    = PidinStackLookupTopSymbol(ppistComp);

		double dDia
		    = SymbolParameterResolveValue(phsle, ppistComp, "DIA");

		//- if spherical

		if (SegmenterIsSpherical((struct symtab_Segmenter *)phsle, ppistComp))
		{
		    //- calculate surface

		    dSurface = dDia * dDia * M_PI;
		}

		//- else

		else
		{
		    //- get segment length

		    double dLength
			= SymbolParameterResolveValue(phsle, ppistComp, "LENGTH");

		    //- calculate surface

		    dSurface = dDia * dLength * M_PI;
		}

		//- free allocated memory

		PidinStackFree(ppistComp);

		//- unscale conductance to surface of segment

		double dGUnscaled = dGScaled / dSurface;

		//- set this as G_MAX

		SymbolSetParameterDouble(&pmeml->bio.ioh.iol.hsle, "G_MAX", dGUnscaled);

	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&pmeml->bio, ppist);

    //- return result

    return(iResult);
}


