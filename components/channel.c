//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: channel.c 1.87 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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

#include "neurospaces/components/attachment.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/projectionquery.h"

#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif



static
char *
ChannelGetChannelType
(struct symtab_Channel *pchan, struct PidinStack *ppist);

static
int
ChannelGetNumberOfSynapses
(struct symtab_Channel *pchan, struct PidinStack *ppist);

static int ChannelTable_READ(struct symtab_Channel *pchan, char *pcFilename);


/// \def check if genesis style object present

#define ChannelHasGenesisObject(pchan)					\
({									\
    ((pchan)->dechan.genObject.iType != 0);				\
})


/// 
/// \return struct symtab_Channel * 
/// 
///	Newly allocated channel, NULL for failure
/// 
/// \brief Allocate a new channel symbol table element
/// 

struct symtab_Channel * ChannelCalloc(void)
{
    //- set default result : failure

    struct symtab_Channel *pchanResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/channel_vtable.c"

    //- allocate channel

    pchanResult
	= (struct symtab_Channel *)
	  SymbolCalloc(1, sizeof(struct symtab_Channel), _vtable_channel, HIERARCHY_TYPE_symbols_channel);

    //- initialize channel

    ChannelInit(pchanResult);

    //- return result

    return(pchanResult);
}


/// 
/// \arg pchan symbol to collect mandatory parameters for.
/// \arg ppist context.
/// 
/// \return int : success of operation.
/// 
/// \brief Collect mandatory simulation parameters for this symbol,
/// instantiate them in cache such that they are present during
/// serialization.
/// 

int
ChannelCollectMandatoryParameterValues
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    static char *ppc_channel_mandatory_parameter_names[] =
	{
	    "Erev",
	    (char *)0,
	};

    int i;

    for (i = 0 ; ppc_channel_mandatory_parameter_names[i] ; i++)
    {
	struct symtab_Parameters *pparValue
	    = SymbolFindParameter(&pchan->bio.ioh.iol.hsle, ppist, ppc_channel_mandatory_parameter_names[i]);

	struct symtab_Parameters *pparOriginal
	    = ParameterLookup(pchan->bio.pparc->ppars, ppc_channel_mandatory_parameter_names[i]);

	if (pparValue && (!pparOriginal || ParameterIsSymbolic(pparOriginal) || ParameterIsField(pparOriginal)))
	{
	    double dValue = ParameterResolveValue(pparValue, ppist);

	    struct symtab_Parameters *pparDuplicate = ParameterNewFromNumber(ppc_channel_mandatory_parameter_names[i], dValue);

	    BioComponentChangeParameter(&pchan->bio, pparDuplicate);
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pchan symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
ChannelCreateAlias
(struct symtab_Channel *pchan,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Channel *pchanResult = ChannelCalloc();

    //\todo this is a hack that also introduces a memory leak: release
    // the IO list

    SymbolAssignBindableIO(&pchanResult->bio.ioh.iol.hsle, NULL);

    //- set name, namespace and prototype

    SymbolSetName(&pchanResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pchanResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pchanResult->bio.ioh.iol.hsle, &pchan->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_channel);

    //- return result

    return(&pchanResult->bio.ioh.iol.hsle);
}


/// 
/// \arg pchan channel to get channel type for.
/// \arg ppist context of channel.
/// 
/// \return char *
/// 
///	Textual description of the channel type, NULL for failure.
/// 
/// \brief Get CHANNEL_TYPE parameter for this channel.
/// 

struct channel_children_counts
{
    /// number of gates

    int iGates;

    /// number of voltage gate kinetics

    int iGateKineticsVoltage;

    /// number of concentration gate kinetics

    int iGateKineticsConcentration;

    /// number of equations

    int iEquations;

    /// number of event receivers

    int iReceivers;

    /// others

    int iOthers;

};

static
int 
ChannelTyper
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to specific data

    struct channel_children_counts *pccc
	= (struct channel_children_counts *)pvUserdata;

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

    //- count types

    int iType = TstrGetActualType(ptstr);

    if (subsetof_equation_exponential(iType))
    {
	pccc->iEquations++;
    }
    else if (subsetof_h_h_gate(iType))
    {
	pccc->iGates++;
    }
    else if (subsetof_gate_kinetic(iType))
    {
	pccc->iGateKineticsVoltage++;
    }
    else if (subsetof_concentration_gate_kinetic(iType))
    {
	pccc->iGateKineticsConcentration++;
    }
    else if (subsetof_attachment(iType))
    {
	pccc->iReceivers++;
    }
    else
    {
	pccc->iOthers++;
    }

    //- return result

    return(iResult);
}

static
char *
ChannelGetChannelType
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result: failure

    char *pcResult = NULL;

    /// number of children according to their type found in the channel

    struct channel_children_counts ccc =
    {
	/// number of gates

	0,

	/// number of voltage gate kinetics

	0,

	/// number of concentration gate kinetics

	0,

	/// number of equations

	0,

	/// number of event receivers

	0,

	/// others

	0,

    };

    //- traverse channel symbol, figure out the type

    if (SymbolTraverseDescendants
	(&pchan->bio.ioh.iol.hsle,
	 ppist,
	 ChannelTyper,
	 NULL,
	 (void *)&ccc)
	== FALSE)
    {
	pcResult = NULL;
    }
    else
    {
	//- set result according to children found

	if (ccc.iEquations == 1
	    && ccc.iGateKineticsVoltage == 0
	    && ccc.iGateKineticsConcentration == 0
	    && ccc.iGates == 0
	    && ccc.iOthers == 0)
	{
	    pcResult = "ChannelSynchan";
	}
	else if (ccc.iEquations == 0
		 && ccc.iGateKineticsVoltage == 2
		 && ccc.iGateKineticsConcentration == 0
		 && ccc.iGates == 1
		 && ccc.iOthers == 0
		 && ccc.iReceivers == 0)
	{
	    pcResult = "ChannelAct";
	}
	else if (ccc.iEquations == 0
		 && ccc.iGateKineticsConcentration == 0
		 && ccc.iGateKineticsVoltage == 4
		 && ccc.iGates == 2
		 && ccc.iOthers == 0
		 && ccc.iReceivers == 0)
	{
	    pcResult = "ChannelActInact";
	}
	else if (ccc.iEquations == 0
		 && (ccc.iGateKineticsConcentration == 1
		     || ccc.iGateKineticsConcentration == 2)
		 && ccc.iGateKineticsVoltage == 2
		 && ccc.iGates == 2
		 && ccc.iOthers == 0
		 && ccc.iReceivers == 0)
	{
	    pcResult = "ChannelActConc";
	}
	else if (ccc.iEquations == 0
		 && (ccc.iGateKineticsConcentration == 1
		     || ccc.iGateKineticsConcentration == 2)
		 && ccc.iGateKineticsVoltage == 0
		 && ccc.iGates == 1
		 && ccc.iOthers == 0
		 && ccc.iReceivers == 0)
	{
	    pcResult = "ChannelConc";
	}
    }

    //- return result

    return(pcResult);
}


static int 
ChannelEquationChecker
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if equation

    int iType = TstrGetActualType(ptstr);

    if (subsetof_equation_exponential(iType))
    {
	//- set result : ok

	*(struct symtab_HSolveListElement **)pvUserdata = phsle;

	//- set result : abort traversal

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}

/// 
/// \arg pchan channel to check
/// \arg ppist context of channel
/// 
/// \return struct symtab_HSolveListElement * : 
/// 
///	channel equation, NULL if none, -1 for failure
/// 
/// \brief get channel equation
/// 

struct symtab_HSolveListElement *
ChannelGetEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist)
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
	   ChannelEquationChecker,
	   (void *)&phsleResult,
	   NULL,
	   NULL);

    //- traverse channel children, check for equation

    iTraversal = TstrGo(ptstr, &pchan->bio.ioh.iol.hsle);

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
/// \arg pchan channel to check
/// 
/// \return struct descr_genesis_object * : genesis object, NULL for failure
/// 
/// \brief get channel genesis object
/// 

struct descr_genesis_object *
ChannelGetGenesisObject(struct symtab_Channel *pchan)
{
    //- set default result : failure

    struct descr_genesis_object *pgenResult = NULL;

    //- if not valid

    while (pchan && !ChannelHasGenesisObject(pchan))
    {
	//- get channel prototype

	pchan = (struct symtab_Channel *)SymbolGetPrototype(&pchan->bio.ioh.iol.hsle);
    }

    //- if valid

    if (pchan && ChannelHasGenesisObject(pchan))
    {
	//- set result

	pgenResult = &pchan->dechan.genObject;
    }

    //- return result

    return(pgenResult);
}


/// 
/// \arg pchan channel to get channel type for.
/// \arg ppist context of channel.
/// \arg pcr cache registry.
/// 
/// \return int
/// 
///	number of connections of this channel, -1 for failure.
/// 
/// \brief Get nsynapses parameter for this channel.
/// 

static
int
ChannelGetNumberOfSynapses
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result: failure

    int iResult = -1;

    // \todo this should come from ppist

    extern struct Neurospaces *pneuroGlobal;

    struct ProjectionQuery *ppq = NeurospacesGetProjectionQuery(pneuroGlobal);

/*     //- get serial of channel */

/*     PidinStackLookupTopSymbol(ppist); */

/*     int iChannel = PidinStackToSerial(ppist); */

    //- compute the number of connections for this channel

    iResult = ProjectionQueryCountConnectionsForSpikeReceiver(ppq, ppist);

    if (iResult == -1)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pchan channel to check
/// \arg ppist context of channel
/// 
/// \return struct symtab_HSolveListElement * : 
/// 
///	incoming attachment, NULL if none, -1 for failure
/// 
/// \brief get channel incoming attachment.
/// 

static int 
ChannelIncomingVirtualChecker
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, continue with children

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if attachment

    int iType = TstrGetActualType(ptstr);

    if (subsetof_attachment(iType))
    {
	//- if incoming attachment

	if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
	{
	    //- set result : ok

	    *(struct symtab_HSolveListElement **)pvUserdata = phsle;

	    //- set result : abort traversal

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }

    //- return result

    return(iResult);
}

struct symtab_HSolveListElement *
ChannelGetIncomingVirtual
(struct symtab_Channel *pchan, struct PidinStack *ppist)
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
	   ChannelIncomingVirtualChecker,
	   (void *)&phsleResult,
	   NULL,
	   NULL);

    //- traverse channel children, check for equation

    iTraversal = TstrGo(ptstr, &pchan->bio.ioh.iol.hsle);

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
/// \arg pchan symbol to get parameter for
/// \arg ppist context of symbol.
/// \arg pcName name of parameter
/// 
/// \return struct symtab_Parameters *
/// 
///	Parameter structure, NULL for failure.
/// 
/// \brief Get specific parameter of symbol.
/// 

struct symtab_Parameters * 
ChannelGetParameter
(struct symtab_Channel *pchan,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *  pparResult = NULL;

    //- get parameter from bio component

    pparResult = BioComponentGetParameter(&pchan->bio, ppist, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if channel type

	if (0 == strcmp(pcName, "CHANNEL_TYPE"))
	{
	    //- get channel type

	    char *pc = ChannelGetChannelType(pchan, ppist);

	    //- set channel type

	    pparResult
		= SymbolSetParameterString
		  (&pchan->bio.ioh.iol.hsle, "CHANNEL_TYPE", pc);
	}
	else if (0 == strcmp(pcName, "nsynapses"))
	{
	    //- get number of connections

	    int iConnections = ChannelGetNumberOfSynapses(pchan, ppist);

	    //- set parameter

	    pparResult
		= SymbolSetParameterDouble
		  (&pchan->bio.ioh.iol.hsle, "nsynapses", (double) iConnections);
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pchan channel to check
/// \arg ppist context of channel
/// 
/// \return int : TRUE if channel contains an equation.
/// 
/// \brief Check if channel contains an equation.
/// 

int ChannelHasEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- check for equation and return if found

    return(ChannelGetEquation(pchan, ppist) != NULL);
}


/// 
/// \arg pchan channel to check
/// \arg ppist context of channel
/// 
/// \return int : TRUE if channel MG block dependent
/// 
/// \brief Check if channel conductance is blocked by magnesium.
/// 

int
ChannelHasMGBlockGMAX
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if GMAX present

    struct symtab_Parameters *pparGMAX
	= SymbolFindParameter(&(pchan->bio.ioh.iol.hsle), ppist, "G_MAX");

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
/// \arg pchan channel to check
/// \arg ppist context of channel
/// 
/// \return int : TRUE if channel has nernst
/// 
/// \brief Check if channel Erev nernst-equation controlled
/// 

int ChannelHasNernstErev
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result : false

    int bResult = FALSE;

    //- if Erev present

    struct symtab_Parameters *pparErev
	= SymbolFindParameter(&(pchan->bio.ioh.iol.hsle), ppist, "Erev");

    if (pparErev)
    {
	//- if Erev is function

      //  if (ParameterIsFunction(pparErev))
	{
	    //- get function

	    struct symtab_Function *pfunErev
	      = ParameterContextGetFunction(pparErev, ppist);

	    //- if function name is NERNST
	    if(pfunErev)
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
/// \arg pchan channel to init
/// 
/// \return void
/// 
/// \brief init channel
/// 

void ChannelInit(struct symtab_Channel *pchan)
{
    //- initialize base symbol

    BioComponentInit(&pchan->bio);

    //- set type

    pchan->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_channel;

    //- create default bindables for the Channel.

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

    static struct symtab_IOContainer *piocChannelDefault = NULL;

    if (!piocChannelDefault)
    {
	piocChannelDefault = IOContainerNewFromList(ppcParameters, piTypes);
    }

    SymbolAssignBindableIO(&pchan->bio.ioh.iol.hsle, piocChannelDefault);
}


/// 
/// \arg pchan channel to scale value for
/// \arg ppist context of given element
/// \arg dValue value to scale
/// \arg ppar parameter that specify type of scaling
/// 
/// \return double : scaled value, DBL_MAX for failure
/// 
/// \brief Scale value according to parameter type and symbol type
/// 

double
ChannelParameterScaleValue
(struct symtab_Channel *pchan,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)
{
    //- set default result : none

    double dResult = DBL_MAX;

    //- get channel parameter field name

    char *pcName = ParameterGetName(ppar);

    if (!pcName)
    {
	return(dResult);
    }

    //- if conductance

    if (0 == strcmp(pcName, "G_MAX"))
    {
	//- find parent segment

	struct PidinStack *ppistComp
	    = SymbolFindParentSegment(&pchan->bio.ioh.iol.hsle, ppist);

	//- if found segment

	if (ppistComp)
	{
	    struct symtab_HSolveListElement *phsle
		= PidinStackLookupTopSymbol(ppistComp);

	    /// surface

	    double dSurface;

	    //- get segment diameter

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

	    //- scale conductance to surface of segment

	    dResult = dValue * dSurface;

	    //- free allocated memory

	    PidinStackFree(ppistComp);
	}
    }

    //- return result

    return(dResult);
}


/// 
/// \arg pchan channel to check.
/// \arg ppist context of channel.
/// 
/// \return int : TRUE if receives spikes.
/// 
/// \brief Check if channel receives spikes.
/// 

int ChannelReceivesSpikes
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- check for incoming attachment and return if found

    return(ChannelGetIncomingVirtual(pchan, ppist) != NULL);
}


/// 
/// \arg pchan channel to reduce.
/// \arg ppist context of channel.
/// 
/// \return int success of operation.
/// 
/// \brief Reduce the parameters of a channel.
///
/// \details Reduces:
///
///	CHANNEL_TYPE
///	G_MAX
/// 

int
ChannelReduce
(struct symtab_Channel *pchan, struct PidinStack *ppist)
{
    //- set default result: success

    int iResult = 1;

    {
	//- get CHANNEL_TYPE parameter

	struct symtab_Parameters *pparType
	    = SymbolGetParameter(&pchan->bio.ioh.iol.hsle, ppist, "CHANNEL_TYPE");

	//- get inferred channel type

	char *pcType = ChannelGetChannelType(pchan, ppist);

	//- if they read the same

	if (pparType
	    && pcType
	    && strcmp(ParameterGetString(pparType), pcType) == 0)
	{
	    //- remove channel type parameter

	    iResult = iResult && ParContainerDelete(pchan->bio.pparc, pparType);

	    if (iResult)
	    {
		ParameterFree(pparType);
	    }
	}
    }

    {
	//- get G_MAX parameter

	struct symtab_Parameters *pparG
	    = SymbolGetParameter(&pchan->bio.ioh.iol.hsle, ppist, "G_MAX");

	//- if has GENESIS2 function

	if (pparG
	    && ParameterIsFunction(pparG)
	    && strcmp(FunctionGetName(ParameterGetFunction(pparG)), "GENESIS2") == 0)
	{
	    //- get scaled conductance

	    double dGScaled = ParameterResolveScaledValue(pparG, ppist);

	    //- find parent segment

	    struct PidinStack *ppistComp
		= SymbolFindParentSegment(&pchan->bio.ioh.iol.hsle, ppist);

	    //- if found segment

	    if (ppistComp)
	    {
/* 		//- remove the previous G_MAX parameter */

/* 		ParContainerDelete(pchan->bio.pparc, pparG); */

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

		SymbolSetParameterDouble(&pchan->bio.ioh.iol.hsle, "G_MAX", dGUnscaled);

	    }
	}
    }

    //- reduce bio component

    iResult = iResult && BioComponentReduce(&pchan->bio, ppist);

    //- return result

    return(iResult);
}


/// 
/// \arg pchan channel to set table parameters for
/// \arg pcFilename filename of table to read
/// 
/// \return int : success of operation
/// 
/// \brief Initialize tabulated channel.
///
/// \details 
/// 
///	Call ChannelSetup() after all bindable I/O relations have been 
///	assigned.
/// 

int
ChannelSetTableParameters
(struct symtab_Channel *pchan, struct ParserContext *pac, char *pcFilename)
{
    //- set default result : ok

    int bResult = TRUE;

    //- qualify filename

    pcFilename = ParserContextQualifyToParsingDirectory(pac, pcFilename);

    //- init channel

    pchan->dechan.iType = TYPE_CHANNEL_TABLEFILE;
    pchan->dechan.pcFilename = pcFilename;

    //- return result

    return(bResult);
}


/// 
/// \arg pchan channel to setup
/// 
/// \return int : success of operation
/// 
/// \brief Setup tabulated channel
///
/// \details 
/// 
///	Reads tables according to bindable I/O relations
///	Sets power parameters and indices in genesis structure.
/// 
/// \note  needs HH parameters, these have to be hardcoded.
/// 

int ChannelSetup(struct symtab_Channel *pchan, struct ParserContext *pac)
{
    //- set default result : ok

    int bResult = TRUE;

    int ttype = -1;

    //- if tabulated channel

    if (pchan->dechan.iType == TYPE_CHANNEL_TABLEFILE)
    {
	//- allocate & read channel data

	ChannelTable_READ(pchan, pchan->dechan.pcFilename);
    }

    ttype = pchan->dechan.genObject.iType;

    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
    {
	struct neurospaces_tab_channel_type *chan1
	    = pchan->dechan.genObject.uElement.tabchan;

	struct symtab_Parameters *ppar = NULL;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Xpower");
	chan1->Xpower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Ypower");
	chan1->Ypower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Zpower");
	chan1->Zpower = ppar ? ParameterValue(ppar) : 0.0 ;

	/// \note not used at the moment

	chan1->instant = 0;

	break;
    }
    case CHANNEL_TYPE_DOUBLE_TABLE:
    {
	struct neurospaces_tab2channel_type *chan2
	    = pchan->dechan.genObject.uElement.tab2chan;

	struct symtab_Parameters *ppar = NULL;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Xpower");
	chan2->Xpower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Ypower");
	chan2->Ypower = ppar ? ParameterValue(ppar) : 0.0 ;
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Zpower");
	chan2->Zpower = ppar ? ParameterValue(ppar) : 0.0 ;

	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Xindex");
	chan2->Xindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Yindex");
	chan2->Yindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );
	ppar = SymbolGetParameter(&(pchan->bio.ioh.iol.hsle), NULL, "Zindex");
	chan2->Zindex = (short) ( ppar ? ParameterValue(ppar) : 0.0 );

	/// \note not used at the moment

	chan2->instant = 0;

	break;
    }
    case CHANNEL_TYPE_CURRENT:
    {
	struct neurospaces_tab_current_type *curr
	    = pchan->dechan.genObject.uElement.tabcurr;

	struct symtab_Parameters *ppar = NULL;

	fprintf(stderr, "tabulated current not implemented\n");

	break;
    }
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pchan channel to print symbols for
/// \arg pcFilename filename of table to read
/// 
/// \return int : success of operation
/// 
/// \brief Initialize tabulated channel
/// 

static int
ChannelTable_dims
(struct descr_genesis_object  *genObject,
 int *itype,
 int *ntype);

static int
ChannelTable_ptrs
(struct descr_genesis_object  *genObject,
 int i,
 int bConcen,
 struct neurospaces_interpol_struct	**ipolA,
 struct neurospaces_interpol_struct	**ipolB,
 struct neurospaces_interpol2d_struct	**ipol2A,
 struct neurospaces_interpol2d_struct	**ipol2B);

static int
GenObjectSetup
(struct descr_genesis_object  *genObject);

static int
Interpol1DAllocateTable
(struct neurospaces_interpol_struct *ipol,
 int xdivs);

static int
Interpol2DAllocateTable
(struct neurospaces_interpol2d_struct *ipol,
 int xdivs,
 int ydivs);

static int tabiread(FILE *fp, int doflip);

static double tabfread(FILE *fp, int doflip);

static int ChannelTable_READ(struct symtab_Channel *pchan, char *pcFilename)
{
    int	i, j, k, n=0, ttype, itype, ntype, doflip;
    int	dsize, isize;
    char	version;
    FILE	*fp = NULL;
    struct neurospaces_tab_channel_type	*chan1;
    struct neurospaces_tab2channel_type	*chan2;
    struct neurospaces_tab_current_type	*curr;
    struct neurospaces_interpol_struct *ipolA, *ipolB;
    struct neurospaces_interpol2d_struct *ipol2A, *ipol2B;
    double	v, *A, *B;
    int	tabiread();
    double	tabfread();

    int bConcen = FALSE;

    dsize=sizeof(double);
    isize=sizeof(int);

    //- remember if channel has concen input

    bConcen = SymbolHasBindableIO(&pchan->bio.ioh.iol.hsle, "concen", 0);

    /* open the file */
    if (!(fp = fopen(pcFilename, "r"))) {
	//Error();
	printf(" can't open file '%s'\n", pcFilename);
	return(FALSE);
    }

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-result"

    /* read header: in versions 1-3 this was an integer, now it is a byte */
    for (i=0; i<4; i++) {
        fread(&version, 1, 1, fp);
	if (version>0) break;
    }

#pragma GCC diagnostic pop

    if ((version<1)||((version==2)&&(ttype==CHANNEL_TYPE_CURRENT))||(version>4)) {
	//Error();
	printf(" can't read file '%s': wrong version #%d\n", pcFilename, version);
	fclose(fp);
	return(FALSE);
    }

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-result"

    if (version>=4) {
	/* test for binary type */
        fread(&v, dsize, 1, fp);
	doflip=(v!=4.0);
    } else {
	doflip=0;
    }

#pragma GCC diagnostic pop

    //- read type of channel

    i = tabiread(fp, doflip);

    pchan->dechan.genObject.iType = i;

    ttype = i;
    if (i!=ttype) {
	//Error();
	printf(" can't read file '%s': wrong object type (%d)\n", pcFilename, i);
	fclose(fp);
	return(FALSE);
    }

    //- initialize genesis interface object

    GenObjectSetup(&pchan->dechan.genObject);

    //- read number of gates in file

    i = tabiread(fp, doflip);

    n = i;
    if (i!=n) {
	//Error();
	printf(" can't read file '%s': wrong number of tables (%d)\n", pcFilename, i);
	fclose(fp);
	return(FALSE);
    }

    //- loop through all the gates

    for (i = 0 ; i < n ; i++)
    {
	//- get dimensions of tables according to element type

	ChannelTable_dims(&pchan->dechan.genObject, &itype, &ntype);

	//- read dimension for current table

	k = tabiread(fp, doflip);

	//itype = k;

	if (k!=itype) {
	    //Error();
	    printf("can't read file '%s': wrong dimension of table (%d: %d)\n", pcFilename, itype, k);
	    fclose(fp);
	    return(FALSE);
	}

	//- read type of table, no clue what this is about

	k = tabiread(fp, doflip);

	//ntype = 2;

	if (k!=ntype) {
	    //Error();
	    printf("can't read file '%s': wrong type of table (%d: %d)\n", pcFilename, ntype, k);
	    fclose(fp);
	    return(FALSE);
	}

	//- get pointers to rate tables which should be read

	ChannelTable_ptrs(&pchan->dechan.genObject, i, bConcen, &ipolA, &ipolB, &ipol2A, &ipol2B);

	//- if single dimension

	if (itype==1)
	{
	    //- read table sizes, calc number of entries in a table

	    k = tabiread(fp, doflip);

	    ipolA->xdivs = k;
	    ipolB->xdivs = k;

	    if ((k!=ipolA->xdivs) || 
		((ttype<CHANNEL_TYPE_CURRENT)&&(k!=ipolB->xdivs))) {
		//Error();
		printf("can't read file '%s': wrong xdivs for table (%d: %d)\n", pcFilename, k, ipolA->xdivs);
		fclose(fp);
		return(FALSE);
	    }

	    ipolA->xmin=tabfread(fp, doflip);
	    ipolA->xmax=tabfread(fp, doflip);
	    ipolA->dx=tabfread(fp, doflip);
	    ipolA->invdx=1.0/ipolA->dx;

	    //- allocate interpol tables

	    Interpol1DAllocateTable(ipolA, ipolA->xdivs);

	    if (ntype>1) {
		ipolB->xmin=ipolA->xmin;
		ipolB->xmax=ipolA->xmax;
		ipolB->dx=ipolA->dx;
		ipolB->invdx=1.0/ipolA->dx;

		Interpol1DAllocateTable(ipolB, ipolB->xdivs);
	    }

	    //- read the tables

	    A=ipolA->table;
	    if (ntype>1) B=ipolB->table;
	    k=ipolA->xdivs;
	    for (j=0; j<=k; j++) {
		*A++=tabfread(fp, doflip);
		if (ntype>1) *B++=tabfread(fp, doflip);
	    }
	}

	//- else (two dimensions)

	else
	{	/* itype==2 */
	    /* read table sizes */

	    //- read table sizes, calc number of entries in a table

	    k = tabiread(fp, doflip);

	    ipol2A->xdivs = k;
	    ipol2B->xdivs = k;

	    if ((k!=ipol2A->xdivs) || ((n>1)&&(k!=ipol2B->xdivs))) {
		//Error();
		printf(" can't read file '%s': wrong xdivs for table (%d: %d)\n", pcFilename, k, ipol2A->xdivs);
		fclose(fp);
		return(FALSE);
	    }
	    ipol2A->xmin=tabfread(fp, doflip);
	    ipol2A->xmax=tabfread(fp, doflip);
	    ipol2A->dx=tabfread(fp, doflip);
	    ipol2A->invdx=1.0/ipol2A->dx;

	    k = tabiread(fp, doflip);

	    ipol2A->ydivs = k;
	    ipol2B->ydivs = k;

	    if ((k!=ipol2A->ydivs) || ((ntype>1)&&(k!=ipol2B->ydivs))) {
		//Error();
		printf(" can't read file '%s': wrong ydivs for table (%d: %d)\n", pcFilename, k, ipol2A->ydivs);
		fclose(fp);
		return(FALSE);
	    }
	    ipol2A->ymin=tabfread(fp, doflip);
	    ipol2A->ymax=tabfread(fp, doflip);
	    ipol2A->dy=tabfread(fp, doflip);
	    ipol2A->invdy=1.0/ipol2A->dy;

	    //- allocate interpol tables

	    Interpol2DAllocateTable(ipol2A, ipol2A->xdivs, ipol2A->ydivs);

	    if (ntype>1) {
		ipol2B->xmin=ipol2A->xmin;
		ipol2B->xmax=ipol2A->xmax;
		ipol2B->dx=ipol2A->dx;
		ipol2B->invdx=1.0/ipol2A->dx;
		ipol2B->ymin=ipol2A->ymin;
		ipol2B->ymax=ipol2A->ymax;
		ipol2B->dy=ipol2A->dy;
		ipol2B->invdy=1.0/ipol2A->dy;

		Interpol2DAllocateTable(ipol2B, ipol2B->xdivs, ipol2B->ydivs);
	    }

	    //- read the tables

	    for (j=0; j<=ipol2A->xdivs; j++) {
		A=ipol2A->table[j];
		if (ntype>1) B=ipol2B->table[j];
		for (k=0; k<=ipol2A->ydivs; k++) {
		    *A++=tabfread(fp, doflip);
		    if (ntype>1) *B++=tabfread(fp, doflip);
		}
	    }
	}
    }

    fclose(fp);

    return(TRUE);
}


static int
ChannelTable_dims
(struct descr_genesis_object  *genObject,
 int *itype,
 int *ntype)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
	*itype=1;
	*ntype=2;
	break;

    case CHANNEL_TYPE_DOUBLE_TABLE:
	*itype=2;
	*ntype=2;
	break;

    case CHANNEL_TYPE_CURRENT:
	*itype=2;
	*ntype=2;
	break;
    }

    return(0);
}

static int
ChannelTable_ptrs
(struct descr_genesis_object  *genObject,
 int i,
 int bConcen,
 struct neurospaces_interpol_struct	**ipolA,
 struct neurospaces_interpol_struct	**ipolB,
 struct neurospaces_interpol2d_struct	**ipol2A,
 struct neurospaces_interpol2d_struct	**ipol2B)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
    {
	struct neurospaces_interpol_struct	**ppipolA = NULL;
	struct neurospaces_interpol_struct	**ppipolB = NULL;

	struct neurospaces_tab_channel_type	*chan1 = genObject->uElement.tabchan;

	short int *pbAllocated = NULL;

	if (/* chan1->X_alloced &&  */(i==0)) {
	    ppipolA = &chan1->X_A;
	    ppipolB = &chan1->X_B;
	    pbAllocated = &chan1->X_alloced;
	} else if (/* chan1->Y_alloced &&  */(!bConcen) && ((i==0)||(i==1))) {
	    ppipolA = &chan1->Y_A;
	    ppipolB = &chan1->Y_B;
	    pbAllocated = &chan1->Y_alloced;
	} else if (bConcen/* chan1->Z_alloced */) {
	    ppipolA = &chan1->Z_A;
	    ppipolB = &chan1->Z_B;
	    pbAllocated = &chan1->Z_alloced;
	}

	/// \note could do sanity check here on pbAllocated

	if (!(*ppipolA))
	{
	    *ppipolA
		= (struct neurospaces_interpol_struct *)
		  calloc(1, sizeof(struct neurospaces_interpol_struct));
	}
	if (!(*ppipolB))
	{
	    *ppipolB
		= (struct neurospaces_interpol_struct *)
		  calloc(1, sizeof(struct neurospaces_interpol_struct));
	}

	//- remember allocation has been done

	*pbAllocated = TRUE;

	//- set result pointers

	*ipolA = *ppipolA;
	*ipolB = *ppipolB;

	break;
    }
    case CHANNEL_TYPE_DOUBLE_TABLE:
    {
	struct neurospaces_interpol2d_struct	**ppipol2A = NULL;
	struct neurospaces_interpol2d_struct	**ppipol2B = NULL;

	struct neurospaces_tab2channel_type	*chan2 = genObject->uElement.tab2chan;

	short int *pbAllocated = NULL;

	if (/* chan2->X_alloced &&  */(i==0)) {
	    ppipol2A = &chan2->X_A;
	    ppipol2B = &chan2->X_B;
	    pbAllocated = &chan2->X_alloced;
	} else if (/* chan2->Y_alloced &&  */(!bConcen) && (i<2)) {
	    ppipol2A = &chan2->Y_A;
	    ppipol2B = &chan2->Y_B;
	    pbAllocated = &chan2->Y_alloced;
	} else if (bConcen/* chan2->Z_alloced */) {
	    ppipol2A = &chan2->Z_A;
	    ppipol2B = &chan2->Z_B;
	    pbAllocated = &chan2->Z_alloced;
	}

	/// \note could do sanity check here on pbAllocated

	if (!(*ppipol2A))
	{
	    *ppipol2A
		= (struct neurospaces_interpol2d_struct *)
		  calloc(1, sizeof(struct neurospaces_interpol2d_struct));
	}
	if (!(*ppipol2B))
	{
	    *ppipol2B
		= (struct neurospaces_interpol2d_struct *)
		  calloc(1, sizeof(struct neurospaces_interpol2d_struct));
	}

	//- remember allocation has been done

	*pbAllocated = TRUE;

	//- set result pointers

	*ipol2A = *ppipol2A;
	*ipol2B = *ppipol2B;

	break;
    }
    case CHANNEL_TYPE_CURRENT:
    {
	struct neurospaces_tab_current_type	*curr = genObject->uElement.tabcurr;

	if (i==0) {
	    *ipol2A=curr->G_tab;
	    *ipol2B=curr->I_tab;
	}
	break;
    }
    }

    return(0);
}

static int
GenObjectSetup
(struct descr_genesis_object  *genObject)
{
    int ttype = genObject->iType;

    /* get table pointers */
    switch (ttype) {
    case CHANNEL_TYPE_SINGLE_TABLE:
	genObject->uElement.tabchan
	    = (struct neurospaces_tab_channel_type *)
	      calloc(1, sizeof(struct neurospaces_tab_channel_type));
	break;

    case CHANNEL_TYPE_DOUBLE_TABLE:
	genObject->uElement.tab2chan
	    = (struct neurospaces_tab2channel_type *)
	      calloc(1, sizeof(struct neurospaces_tab2channel_type));
	break;

    case CHANNEL_TYPE_CURRENT:
	genObject->uElement.tabcurr
	    = (struct neurospaces_tab_current_type *)
	      calloc(1, sizeof(struct neurospaces_tab_current_type));
	break;
    }

    return(0);
}

static int
Interpol1DAllocateTable
(struct neurospaces_interpol_struct *ipol,
 int xdivs)
{
    ipol->table = (double *)calloc(xdivs + 1, sizeof(double));

    ipol->allocated = 1;

    return(0);
}

static int
Interpol2DAllocateTable
(struct neurospaces_interpol2d_struct *ipol2,
 int xdivs,
 int ydivs)
{
    int i;

    ipol2->table = (double **)calloc(xdivs + 1, sizeof(double*));

    for (i = 0 ; i <= xdivs ; i++)
    {
	ipol2->table[i] = (double *)calloc(ydivs + 1, sizeof(double));
    }

    ipol2->allocated = 1;
}

/* reads integer value from file and flips it if needed */
static int tabiread(FILE *fp, int doflip)
{
int     n=sizeof(int);
int	val1, val2;
char  	*pval1, *pval2;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-result"

	if (doflip) {
	    fread(&(val1), n, 1, fp);
	    pval1=(char *)(&(val1))+n-1;
	    pval2=(char *)(&(val2));
	    for (;n>0;n--) *pval2++=*pval1--;
	} else {
	    fread(&(val2), n, 1, fp);
	}

#pragma GCC diagnostic pop

	return(val2);
}

/* reads double value from file and flips it if needed */
static double tabfread(FILE *fp, int doflip)
{
int     n=sizeof(double);
double	val1, val2;
char  	*pval1, *pval2;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-result"

	if (doflip) {
	    fread(&(val1), n, 1, fp);
	    pval1=(char *)(&(val1))+n-1;
	    pval2=(char *)(&(val2));
	    for (;n>0;n--) *pval2++=*pval1--;
	} else {
	    fread(&(val2), n, 1, fp);
	}

#pragma GCC diagnostic pop

	return(val2);
}

