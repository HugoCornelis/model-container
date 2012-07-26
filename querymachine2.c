//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: querymachine.c 1.231 Fri, 07 Dec 2007 11:59:10 -0600 hugo $
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



#if !defined(__APPLE__)
#include <malloc.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>


#ifdef HAVE_LIBHISTORY
#ifdef HAVE_LIBREADLINE
#ifdef HAVE_LIBCURSES
#define USE_READLINE
#endif
#endif
#endif


#ifdef USE_READLINE

#ifdef	__cplusplus
extern "C" {
#endif

#include <readline/readline.h>
#include <readline/history.h>

#ifdef	__cplusplus
}
#endif

#endif


#include "neurospaces/algorithmset.h"
#include "neurospaces/biolevel.h"
#include "neurospaces/cachedconnection.h"
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/root.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/coordinatecache.h"
#include "neurospaces/exporter.h"
#include "neurospaces/function.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/namespace.h"
#include "neurospaces/parameters.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/projectionquery.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/workload.h"


#include "neurospaces/symbolvirtual_protos.h"


#ifndef MIN
#define MIN(x,y) ((x) <= (y) ? (x) : (y))
#endif

#ifndef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#endif


// copied from GNU libc.
// modified : 
//	- const *x, *y
//	- changed to ANSI/ISO arg passing.

/* Subtract the `struct timeval' values X and Y,
**   storing the result in RESULT.
**   Return 1 if the difference is negative, otherwise 0.  */
     
static int
timeval_subtract
(struct timeval *result, struct timeval *x, struct timeval *y)
{
    // copy y before modifications

    struct timeval tv = *y;

    /* Perform the carry for the later subtraction by updating Y. */
    if (x->tv_usec < tv.tv_usec) {
	int nsec = (tv.tv_usec - x->tv_usec) / 1000000 + 1;
	tv.tv_usec -= 1000000 * nsec;
	tv.tv_sec += nsec;
    }
    if (x->tv_usec - tv.tv_usec > 1000000) {
	int nsec = (x->tv_usec - tv.tv_usec) / 1000000;
	tv.tv_usec += 1000000 * nsec;
	tv.tv_sec -= nsec;
    }
     
    /* Compute the time remaining to wait.
       `tv_usec' is certainly positive. */
    result->tv_sec = x->tv_sec - tv.tv_sec;
    result->tv_usec = x->tv_usec - tv.tv_usec;
     
    /* Return 1 if result is negative. */
    return x->tv_sec < tv.tv_sec;
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

extern int QueryHandlerAlgorithmClass
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

    char *pcName = &pcLine[iLength];

    if (pcName[0] != '\0')
    {
	pcName++;
    }

    bResult = AlgorithmSetClassPrint(pneuro->psym->pas, pcName, stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

extern int QueryHandlerAlgorithmInstance
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

    char *pcName = &pcLine[iLength];

    if (pcName[0] != '\0')
    {
	pcName++;
    }

    bResult = AlgorithmSetInstancePrint(pneuro->psym->pas, pcName, stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Instantiate an algorithm interactively.
/// 

extern int QueryHandlerAlgorithmInstantiate
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = TRUE;

/*     GENESIS3::Commands::querymachine("algorithminstantiate Grid3D createmap_$target $prototype $positionX $positionY 0 $deltaX $deltaY 0"); */

    //- get algorithm name

    char pcSeparator[] = " \t,;\n";

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "prototype symbol not specified on the commandl line\n");

	return(FALSE);
    }

    char *pcName = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "instance name not specified on command line\n");

	return(FALSE);
    }

    //- get instance name

    char *pcInstance = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    pcInstance = strdup(pcInstance);

    struct symtab_AlgorithmSymbol *palgs = NULL;

    struct PidinStack pistTmp = pneuro->pacRootContext->pist;

    struct AlgorithmInstance *palgi = NULL;

    if (0 == strcmp(pcName, "Grid3D"))
    {
	//- get target name

	char *pcTarget = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	while (pcTarget[0] == '/' || pcTarget[0] == ':')
	{
	    pcTarget++;
	}

	pcTarget = strdup(pcTarget);

	//- get prototype name

	char *pcPrototype = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	//- get x count

	char *pcXCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dXCount = strtod(pcXCount, NULL);

	//- get y count

	char *pcYCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dYCount = strtod(pcYCount, NULL);

	//- get z count

	char *pcZCount = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dZCount = strtod(pcZCount, NULL);

	//- get x distance

	char *pcXDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dXDistance = strtod(pcXDistance, NULL);

	//- get y distance

	char *pcYDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dYDistance = strtod(pcYDistance, NULL);

	//- get z distance

	char *pcZDistance = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	if (iLength >= 0)
	{
	    pcLine[iLength] = '\0';
	}

	double dZDistance = strtod(pcZDistance, NULL);

	//! see also the ns-sli for other examples of the usage of this function

	struct symtab_ParContainer *pparcAlgorithm
	    = ParContainerNewFromList
	      (/* ParameterNewFromString("INSTANCE_NAME", pcInstanceTemplate), */
		ParameterNewFromString("PROTOTYPE", pcPrototype),
		ParameterNewFromNumber("X_DISTANCE", dXDistance),
		ParameterNewFromNumber("Y_DISTANCE", dYDistance),
		ParameterNewFromNumber("Z_DISTANCE", dZDistance),
		ParameterNewFromNumber("X_COUNT", dXCount),
		ParameterNewFromNumber("Y_COUNT", dYCount),
		ParameterNewFromNumber("Z_COUNT", dZCount),
		NULL);

	struct symtab_Parameters *ppar = pparcAlgorithm->ppars;

	//- import & init algorithm

	//t error checking

	palgs = AlgorithmSymbolCalloc();

	//t pparc is lost, memory leak

	AlgorithmSymbolAssignParameters(palgs, ppar);

	palgi
	    = ParserAlgorithmImport
	      (pneuro->pacRootContext,
	       pcName,
	       pcInstance,
	       ppar,
	       palgs);

	if (palgi)
	{
	    AlgorithmSymbolSetAlgorithmInstance(palgs, palgi);

	    struct symtab_Population *ppopuTarget = PopulationCalloc();

	    struct PidinStack *ppistTarget = PidinStackParse(pcTarget);

	    struct PidinStack *ppistParent = PidinStackDuplicate(ppistTarget);

	    struct symtab_IdentifierIndex *pidinTarget
		= PidinStackPop(ppistParent);

	    struct symtab_HSolveListElement *phsleParent
		= PidinStackLookupTopSymbol(ppistParent);

	    if (phsleParent)
	    {
		SymbolSetName(&ppopuTarget->segr.bio.ioh.iol.hsle, pidinTarget);

		SymbolAddChild(phsleParent, &ppopuTarget->segr.bio.ioh.iol.hsle);

		PidinStackPop(ppistTarget);

		PidinStackLookupTopSymbol(ppistTarget);

		pneuro->pacRootContext->pist = *ppistTarget;

		ParserContextSetActual(pneuro->pacRootContext, &ppopuTarget->segr.bio.ioh.iol.hsle);

		struct symtab_HSolveListElement *phsleActual
		    = ParserContextGetActual(pneuro->pacRootContext);

		SymbolAddChild(phsleActual, &palgs->hsle);
	    }
	    else
	    {
		//- let's make things simple here, but really incorrect

		palgi = NULL;

		NeurospacesError
		    (pneuro->pacRootContext,
		     "QueryHandlerAlgorithmInstantiate",
		     " Failed to import algorithm (%s),"
		     " Cannot find parent of model component (%s)",
		     pcName,
		     pcTarget);
	    }

	    PidinStackFree(ppistTarget);

	    PidinStackFree(ppistParent);
	}
	else
	{
	    NeurospacesError
		(pneuro->pacRootContext,
		 "QueryHandlerAlgorithmInstantiate",
		 " Failed to import algorithm (%s)",
		 pcName);
	}
    }
    else if (0 == strcmp(pcName, "ProjectionVolume"))
    {
	//- get network name

	char *pcNetwork = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcNetwork = strdup(pcNetwork);

	//- get projection name

	char *pcProjection = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcProjection = strdup(pcProjection);

	//- get projection source name

	char *pcProjectionSource = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcProjectionSource = strdup(pcProjectionSource);

	//- get projection target name

	char *pcProjectionTarget = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcProjectionTarget = strdup(pcProjectionTarget);

	//- get source name

	char *pcSource = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcSource = strdup(pcSource);

	//- get target name

	char *pcTarget = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcTarget = strdup(pcTarget);

	//- get pre name

	char *pcPre = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcPre = strdup(pcPre);

	//- get post name

	char *pcPost = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcPost = strdup(pcPost);

	//- get source type

	char *pcSourceType = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcSourceType = strdup(pcSourceType);

	//- get source region

	char *pcSourceX1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceX1 = strtod(pcSourceX1, NULL);

	char *pcSourceY1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceY1 = strtod(pcSourceY1, NULL);

	char *pcSourceZ1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceZ1 = strtod(pcSourceZ1, NULL);

	char *pcSourceX2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceX2 = strtod(pcSourceX2, NULL);

	char *pcSourceY2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceY2 = strtod(pcSourceY2, NULL);

	char *pcSourceZ2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dSourceZ2 = strtod(pcSourceZ2, NULL);

	//- get target type

	char *pcTargetType = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcTargetType = strdup(pcTargetType);

	//- get target region

	char *pcTargetX1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetX1 = strtod(pcTargetX1, NULL);

	char *pcTargetY1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetY1 = strtod(pcTargetY1, NULL);

	char *pcTargetZ1 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetZ1 = strtod(pcTargetZ1, NULL);

	char *pcTargetX2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetX2 = strtod(pcTargetX2, NULL);

	char *pcTargetY2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetY2 = strtod(pcTargetY2, NULL);

	char *pcTargetZ2 = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dTargetZ2 = strtod(pcTargetZ2, NULL);

	char *pcWeightIndicator = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	char *pcWeight = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dWeight = strtod(pcWeight, NULL);

	char *pcDelayIndicator = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	char *pcDelayType = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	pcDelayType = strdup(pcDelayType);

	char *pcDelay = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dDelay = strtod(pcDelay, NULL);

	char *pcVelocityIndicator = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	char *pcVelocity = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	pcLine[iLength] = '\0';

	double dVelocity = strtod(pcVelocity, NULL);

	//- hole options

	char *pcHole = &pcLine[iLength + 1];

	char *pcDestinationHoleType = NULL;
	char *pcDestinationHoleX1 = NULL;
	double dDestinationHoleX1 = DBL_MAX;
	char *pcDestinationHoleY1 = NULL;
	double dDestinationHoleY1 = DBL_MAX;
	char *pcDestinationHoleZ1 = NULL;
	double dDestinationHoleZ1 = DBL_MAX;
	char *pcDestinationHoleX2 = NULL;
	double dDestinationHoleX2 = DBL_MAX;
	char *pcDestinationHoleY2 = NULL;
	double dDestinationHoleY2 = DBL_MAX;
	char *pcDestinationHoleZ2 = NULL;
	double dDestinationHoleZ2 = DBL_MAX;

	if (0 == strncasecmp(pcHole, "destination_hole", strlen("destination_hole")))
	{
	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    //- hole type

	    pcDestinationHoleType = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    //- get destination_hole region

	    pcDestinationHoleX1 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleX1 = strtod(pcDestinationHoleX1, NULL);

	    pcDestinationHoleY1 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleY1 = strtod(pcDestinationHoleY1, NULL);

	    pcDestinationHoleZ1 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleZ1 = strtod(pcDestinationHoleZ1, NULL);

	    pcDestinationHoleX2 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleX2 = strtod(pcDestinationHoleX2, NULL);

	    pcDestinationHoleY2 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleY2 = strtod(pcDestinationHoleY2, NULL);

	    pcDestinationHoleZ2 = &pcLine[iLength + 1];

	    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	    pcLine[iLength] = '\0';

	    dDestinationHoleZ2 = strtod(pcDestinationHoleZ2, NULL);
	}

	//- define probability

	char *pcProbability = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	if (iLength >= 0)
	{
	    pcLine[iLength] = '\0';
	}

	double dProbability = strtod(pcProbability, NULL);

	//- define random seed

	char *pcRandomSeed = &pcLine[iLength + 1];

	iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

	if (iLength >= 0)
	{
	    pcLine[iLength] = '\0';
	}

	double dRandomSeed = strtod(pcRandomSeed, NULL);

	double dFixedDelay = dDelay;

	//! see also the ns-sli for other examples of the usage of this function

	struct symtab_ParContainer *pparcAlgorithm
	    = ParContainerNewFromList
	      (/* ParameterNewFromString("INSTANCE_NAME", pcInstanceTemplate), */
		  ParameterNewFromString("PROJECTION_NAME", pcProjection),
		  ParameterNewFromNumber("RANDOMSEED", dRandomSeed),
		  ParameterNewFromNumber("PROBABILITY", dProbability),
		  ParameterNewFromString("SOURCE_CONTEXT", pcSource),
		  ParameterNewFromString("TARGET_CONTEXT", pcTarget),
		  ParameterNewFromString("PRE", pcPre),
		  ParameterNewFromString("POST", pcPost),

		  ParameterNewFromString("SOURCE_TYPE", pcSourceType),

		  ParameterNewFromNumber("SOURCE_X1", dSourceX1),
		  ParameterNewFromNumber("SOURCE_Y1", dSourceY1),
		  ParameterNewFromNumber("SOURCE_Z1", dSourceZ1),

		  ParameterNewFromNumber("SOURCE_X2", dSourceX2),
		  ParameterNewFromNumber("SOURCE_Y2", dSourceY2),
		  ParameterNewFromNumber("SOURCE_Z2", dSourceZ2),

		  ParameterNewFromString("DESTINATION_TYPE", pcTargetType),

		  ParameterNewFromNumber("DESTINATION_X1", dTargetX1),
		  ParameterNewFromNumber("DESTINATION_Y1", dTargetY1),
		  ParameterNewFromNumber("DESTINATION_Z1", dTargetZ1),

		  ParameterNewFromNumber("DESTINATION_X2", dTargetX2),
		  ParameterNewFromNumber("DESTINATION_Y2", dTargetY2),
		  ParameterNewFromNumber("DESTINATION_Z2", dTargetZ2),

		  ParameterNewFromNumber("WEIGHT", dWeight),

		  ParameterNewFromString("DELAY_TYPE", pcDelayType),

		  ParameterNewFromNumber("FIXED_DELAY", dFixedDelay),
		  ParameterNewFromNumber("VELOCITY", dVelocity),
		  NULL);

	if (pcDestinationHoleType)
	{
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromString("DESTINATION_HOLE_TYPE", pcDestinationHoleType));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_X1", dDestinationHoleX1));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_Y1", dDestinationHoleY1));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_Z1", dDestinationHoleZ1));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_X2", dDestinationHoleX2));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_Y2", dDestinationHoleY2));
	    ParContainerLinkAtEnd(pparcAlgorithm, ParameterNewFromNumber("DESTINATION_HOLE_Z2", dDestinationHoleZ2));
	}

	struct symtab_Parameters *ppar = pparcAlgorithm->ppars;

	//- import & init algorithm

	//t error checking

	palgs = AlgorithmSymbolCalloc();

	//t pparc is lost, memory leak

	AlgorithmSymbolAssignParameters(palgs, ppar);

	palgi
	    = ParserAlgorithmImport
	      (pneuro->pacRootContext,
	       pcName,
	       pcInstance,
	       ppar,
	       palgs);

	if (palgi)
	{
	    AlgorithmSymbolSetAlgorithmInstance(palgs, palgi);

	    struct PidinStack *ppistProjection = PidinStackParse(pcProjection);

	    struct symtab_HSolveListElement *phsleProjection
		= PidinStackLookupTopSymbol(ppistProjection);

	    struct PidinStack *ppistNetwork = PidinStackParse(pcNetwork);

	    struct symtab_HSolveListElement *phsleNetwork
		= PidinStackLookupTopSymbol(ppistNetwork);

	    if (phsleNetwork)
	    {
		if (!phsleProjection)
		{
		    struct symtab_Projection *pprojProjection = ProjectionCalloc();

		    phsleProjection = &pprojProjection->bio.ioh.iol.hsle;

		    struct symtab_IdentifierIndex *pidinProjection
			= PidinStackPop(ppistProjection);

		    SymbolSetName(&pprojProjection->bio.ioh.iol.hsle, pidinProjection);

		    struct symtab_HSolveListElement *phsleParent
			= PidinStackLookupTopSymbol(ppistProjection);

		    SymbolAddChild(phsleParent, &pprojProjection->bio.ioh.iol.hsle);
		}

/* 		PidinStackPop(ppistProjection); */

/* 		PidinStackLookupTopSymbol(ppistProjection); */

		struct symtab_ParContainer *pparcProjection
		    = ParContainerNewFromList
		      (
			  ParameterNewFromPidinQueue("SOURCE", PidinStackToPidinQueue(PidinStackParse(pcProjectionSource)), TYPE_PARA_SYMBOLIC),
			  ParameterNewFromPidinQueue("TARGET", PidinStackToPidinQueue(PidinStackParse(pcProjectionTarget)), TYPE_PARA_SYMBOLIC),
			  NULL);

		SymbolAssignParameters(phsleProjection, pparcProjection->ppars);

		pneuro->pacRootContext->pist = *ppistNetwork;

		ParserContextSetActual(pneuro->pacRootContext, phsleNetwork);

		struct symtab_HSolveListElement *phsleActual
		    = ParserContextGetActual(pneuro->pacRootContext);

		SymbolAddChild(phsleActual, &palgs->hsle);
	    }
	    else
	    {
		//- let's make things simple here, but really incorrect

		palgi = NULL;

		NeurospacesError
		    (pneuro->pacRootContext,
		     "QueryHandlerAlgorithmInstantiate",
		     " Failed to import algorithm (%s),"
		     " Cannot find parent of model component (%s)",
		     pcName,
		     pcProjection);
	    }

	    PidinStackFree(ppistProjection);

	    PidinStackFree(ppistNetwork);
	}
	else
	{
	    NeurospacesError
		(pneuro->pacRootContext,
		 "QueryHandlerAlgorithmInstantiate",
		 " Failed to import algorithm (%s)",
		 pcName);
	}
    }

    //- handling, in the parser this happens with a pop

    if (palgi)
    {
	//- if algorithm handlers are not disabled by the options

	if (!(pneuro->pacRootContext->pneuro->pnsc->nso.iFlags & NSOFLAG_DISABLE_ALGORITHM_HANDLING))
	{
	    //- call algorithm on current symbol

	    ParserAlgorithmHandle
		(pneuro->pacRootContext,
		 ParserContextGetActual(pneuro->pacRootContext),
		 palgi,
		 pcName,
		 pcInstance);
	}

	//- disable the algorithm

	ParserAlgorithmDisable
	    (pneuro->pacRootContext,
	     palgi,
	     pcName,
	     pcInstance);
    }

    pneuro->pacRootContext->pist = pistTmp;

    SymbolRecalcAllSerials(NULL, NULL);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print algorithm info.
/// 

extern int QueryHandlerAlgorithmSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : delegate

    int bResult = AlgorithmSetPrint(pneuro->psym->pas,stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle allocation info query
/// 

extern int QueryHandlerAllocations
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

#if !defined(__APPLE__)

    //- get memory statistics

    struct mallinfo mi;

    mi = mallinfo();

    //- diag's

    fprintf(stdout, "This is the total size of memory allocated with `sbrk' by\n");
    fprintf(stdout, "`malloc', in bytes.\n");
    fprintf(stdout, "\t\t`int arena' = %i\n",mi.arena);

    fprintf(stdout, "This is the number of chunks not in use.  (The storage\n");
    fprintf(stdout, "allocator internally gets chunks of memory from the operating\n");
    fprintf(stdout, "system, and then carves them up to satisfy individual\n");
    fprintf(stdout, "`malloc' requests; see *Note Efficiency and Malloc::.)\n");
    fprintf(stdout, "\t\t`int ordblks' = %i\n",mi.ordblks);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int smblks' = %i\n",mi.smblks);

    fprintf(stdout, "This is the total number of chunks allocated with `mmap'.\n");
    fprintf(stdout, "\t\t`int hblks' = %i\n",mi.hblks);

    fprintf(stdout, "This is the total size of memory allocated with `mmap', in\n");
    fprintf(stdout, "bytes.\n");
    fprintf(stdout, "\t\t`int hblkhd' = %i\n",mi.hblkhd);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int usmblks' = %i\n",mi.usmblks);

    fprintf(stdout, "This field is unused.\n");
    fprintf(stdout, "\t\t`int fsmblks' = %i\n",mi.fsmblks);

    fprintf(stdout, "This is the total size of memory occupied by chunks handed\n");
    fprintf(stdout, "out by `malloc'.\n");
    fprintf(stdout, "\t\t`int uordblks' = %i\n",mi.uordblks);

    fprintf(stdout, "This is the total size of memory occupied by free (not in\n");
    fprintf(stdout, "use) chunks.\n");
    fprintf(stdout, "\t\t`int fordblks' = %i\n",mi.fordblks);

    fprintf(stdout, "This is the size of the top-most, releaseable chunk that\n");
    fprintf(stdout, "normally borders the end of the heap (i.e. the \"brk\" of the\n");
    fprintf(stdout, "process).\n");
    fprintf(stdout, "\t\t`int keepcost' = %i\n",mi.keepcost);

    fprintf(stdout, "\n");

#else

    fprintf(stdout,"Memory reporting not available in MAC OSX.\n");

#endif

    //- return result

    return(bResult);
}




/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Bio group 2 bio level conversion.
/// 

extern int QueryHandlerBiogroup2Biolevel
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- default no group

    int iGroup = -1;

    //- check command line for extra argument

    if (pcLine[iLength] == '\0'
	|| pcLine[iLength + 1] == '\0')
    {
	return(FALSE);
    }

    //- attempt to parse integer

    if (pcLine[iLength + 1] >= '0'
	&& pcLine[iLength + 1] <= '9')
    {
	iGroup = atoi(&pcLine[iLength + 1]);
    }

    //- attempt to parse element context

    else if (pcLine[iLength + 1] == '/')
    {
	//- find symbol

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength + 1]);

	struct symtab_HSolveListElement *phsle
	    = PidinStackLookupTopSymbol(ppist);

	PidinStackFree(ppist);

	if (!phsle)
	{
	    fprintf(stdout, "symbol not found\n");

	    return(FALSE);
	}

	//- get group of symbol

	iGroup = piBiolevel2Biolevelgroup[SymbolType2Biolevel(phsle->iType) / DIVIDER_BIOLEVEL];
    }

    //- or attempt to parse a literal biogroup string

    else
    {
	iGroup = Biolevelgroup(&pcLine[iLength + 1]);
    }

    //- if group was found

    if (iGroup > 0)
    {
	int iLevel = piBiolevelgroup2Biolevel[iGroup / DIVIDER_BIOLEVELGROUP];

	//- report group and matching level

	fprintf(stdout, "biogroup %s has %s as lowest component\n",ppcBiolevelgroup[iGroup / DIVIDER_BIOLEVELGROUP], ppcBiolevel[iLevel / DIVIDER_BIOLEVEL]);
    }
    else
    {
	//- diag's

	fprintf(stdout, "Unable to resolve biogroup %i\n",iGroup);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Bio level 2 bio group conversion.
/// 

extern int QueryHandlerBiolevel2Biogroup
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- default no level

    int iLevel = -1;

    //- check command line for extra argument

    if (pcLine[iLength] == '\0'
	|| pcLine[iLength + 1] == '\0')
    {
	return(FALSE);
    }

    //- attempt to parse integer

    if (pcLine[iLength + 1] >= '0'
	&& pcLine[iLength + 1] <= '9')
    {
	iLevel = atoi(&pcLine[iLength + 1]);
    }

    //- attempt to parse element context

    else if (pcLine[iLength + 1] == '/')
    {
	//- find symbol

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength + 1]);

	struct symtab_HSolveListElement *phsle
	    = PidinStackLookupTopSymbol(ppist);

	PidinStackFree(ppist);

	if (!phsle)
	{
	    fprintf(stdout, "symbol not found\n");

	    return(FALSE);
	}

	//- get level of symbol

	iLevel = SymbolType2Biolevel(phsle->iType);
    }

    //- or attempt to parse a literal biolevel string

    else
    {
	iLevel = Biolevel(&pcLine[iLength + 1]);
    }

    //- if level was found

    if (iLevel > 0)
    {
	int iGroup = piBiolevel2Biolevelgroup[iLevel / DIVIDER_BIOLEVEL];

	//- report group and matching level

	fprintf(stdout, "biolevel %s has %s as biogroup\n",ppcBiolevel[iLevel / DIVIDER_BIOLEVEL], ppcBiolevelgroup[iGroup / DIVIDER_BIOLEVELGROUP]);
    }
    else
    {
	//- diag's

	fprintf(stdout, "Unable to resolve biolevel %i\n",iLevel);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle context info query.
/// 

extern int QueryHandlerContextInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup child symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle1
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    struct symtab_HSolveListElement *phsle2
	= PidinStackLookupTopSymbol(ppist);

    fprintf(stdout, "---\n- parsed context: ");

    PidinStackPrint(ppist, stdout);

    fprintf(stdout, "\n");

    if (phsle1)
    {
	fprintf(stdout, "- found using SymbolsLookupHierarchical()\n");
    }
    else
    {
	fprintf(stdout, "- not found using SymbolsLookupHierarchical()\n");
    }

    if (phsle2)
    {
	fprintf(stdout, "- found using PidinStackLookupTopSymbol()\n");
    }
    else
    {
	fprintf(stdout, "- not found using PidinStackLookupTopSymbol()\n");
    }

    //- return result

    return(bResult);
}


