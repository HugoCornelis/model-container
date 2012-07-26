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
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter-name>
/// 

static int
QueryMachineWildcardParameterTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    char *pcPar = (char *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- lookup parameter

    struct symtab_Parameters *ppar
	= SymbolFindParameter(phsle, ptstr->ppist, pcPar);

    //- if parameter found

    if (ppar)
    {
	//- give diag's

	char pc[1000];

	PidinStackString(ptstr->ppist, pc, 1000);

	fprintf(stdout, "%s->%s", pc, pcPar);

	//- for numeric indirect parameter values

	if (ParameterIsNumber(ppar)
	    || ParameterIsFunction(ppar)
	    || ParameterIsField(ppar))
	{
	    //- resolve parameter value

	    double d = ParameterResolveValue(ppar, ptstr->ppist);

	    //- print result

	    fprintf(stdout, " = %g\n", d);
	}

	//- for string parameter values

	else if (ParameterIsString(ppar))
	{
	    //- print string parameter values

	    char *pc = ParameterGetString(ppar);

	    fprintf(stdout, " = \"%s\"\n", pc);
	}
/* 	else if (ParameterIsFunction(ppar)) */
/* 	{ */
/* 	    //- give diagnostics: not implemented yet */

/* 	    fprintf(stdout, "\nreporting of function parameters is not implemented yet\n"); */
/* 	} */
/* 	else if (ParameterIsField(ppar)) */
/* 	{ */
/* 	    //- give diagnostics: not implemented yet */

/* 	    fprintf(stdout, "\nreporting of field parameters is not implemented yet\n"); */
/* 	} */

	//- otherwise

	else if (ParameterIsSymbolic(ppar))
	{
	    //- give diagnostics: not implemented yet

	    fprintf(stdout, "\nreporting of symbolic parameters is not implemented yet\n");
	}
	else if (ParameterIsAttribute(ppar))
	{
	    //- give diagnostics: not implemented yet

	    fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter1-name> <parameter2-name>
/// 

extern int QueryHandlerPrintParameter
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
	    //- traverse symbols that match with wildcard

	    int iResult
		= SymbolTraverseWildcard
		  (phsleRoot,
		   ppistRoot,
		   ppist,
		   QueryMachineWildcardParameterTraverser,
		   NULL,
		   (void *)pcPar);

	    if (iResult != 1)
	    {
		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- lookup parameter

	    struct symtab_Parameters *ppar
		= SymbolFindParameter(phsle, ppist, pcPar);

	    //- if parameter found

	    if (ppar)
	    {
		//- for numeric indirect parameter values

		if (ParameterIsNumber(ppar)
		    || ParameterIsFunction(ppar)
		    || ParameterIsField(ppar))
		{
		    //- resolve parameter value

		    double d = ParameterResolveValue(ppar, ppist);

		    //- print result

		    fprintf(stdout, "value = %g\n", d);
		}

		//- for string parameter values

		else if (ParameterIsString(ppar))
		{
		    //- print string result

		    char *pc = ParameterGetString(ppar);

		    fprintf(stdout, "value = \"%s\"\n", pc);
		}
/* 		else if (ParameterIsFunction(ppar)) */
/* 		{ */
/* 		    //- give diagnostics: not implemented yet */

/* 		    fprintf(stdout, "\nreporting of function parameters is not implemented yet\n"); */
/* 		} */
/* 		else if (ParameterIsField(ppar)) */
/* 		{ */
/* 		    //- give diagnostics: not implemented yet */

/* 		    fprintf(stdout, "\nreporting of field parameters is not implemented yet\n"); */
/* 		} */

		//- otherwise

		else if (ParameterIsSymbolic(ppar))
		{
		    //- give diagnostics: not implemented yet

		    fprintf(stdout, "\nreporting of symbolic parameters is not implemented yet\n");
		}
		else if (ParameterIsAttribute(ppar))
		{
		    //- give diagnostics: not implemented yet

		    fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");
		}
	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "parameter not found in symbol\n");
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameter <context> <parameter1-name> <parameter2-name>
/// 

extern int QueryHandlerPrintParameterInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
	    //- traverse symbols that match with wildcard

	    int iResult
		= SymbolTraverseWildcard
		  (phsleRoot,
		   ppistRoot,
		   ppist,
		   QueryMachineWildcardParameterTraverser,
		   NULL,
		   (void *)pcPar);

	    if (iResult != 1)
	    {
		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- lookup parameter

	    struct symtab_Parameters *ppar
		= SymbolFindParameter(phsle, ppist, pcPar);

	    //- if parameter found

	    if (ppar)
	    {
		fprintf(stdout, "%s", "---\n");

		int iResult = ParameterPrintInfoRecursive(ppar, ppist, 0, stdout);

		if (!iResult)
		{
		    bResult = 0;
		}
	    }
	    else
	    {
		fprintf(stdout, "parameter not found\n");
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printparameterinput <context> <parameter1-name> <parameter2-name>
/// 

extern int
QueryHandlerPrintParameterInput
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    int iSize = -1;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    if (!ppist)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    //- parse parameter

    char pcPar1[100];
    char pcPar2[100];

    char pcSeparator[] = " \t,;\n";

    //- get parameter 1

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	fprintf(stdout, "please specify a context and two parameters on the command line\n");

	return(FALSE);
    }

    iSize = strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    strncpy(pcPar1, &pcLine[iLength + 1], iSize);

    pcPar1[iSize - 1] = '\0';

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    //- get parameter 2

    if (strpbrk(&pcLine[iLength + 1], pcSeparator) == NULL)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];
    }

    strncpy(pcPar2, &pcLine[iLength + 1], iSize);

    pcPar2[iSize] = '\0';

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    /// \note does not allow namespacing

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- lookup parameter

	struct symtab_HSolveListElement *phsleInput
	    = SymbolResolveParameterFunctionalInput(phsle, ppist, pcPar1, pcPar2, 0);

	//- if parameter found

	if (phsleInput)
	{
	    //- print result

	    fprintf(stdout, "value = %s\n", SymbolGetName(phsleInput));
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "input not found\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle scaled parameter query
///

extern int QueryHandlerPrintParameterScaled
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse parameter

    char pcSeparator[] = " \t,;\n";

    char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPar)
    {
	fprintf(stdout, "parameter not found on command line\n");

	return(FALSE);
    }

    pcPar++;

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    /// \note does not allow namespacing

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- lookup parameter

	struct symtab_Parameters *ppar
	    = SymbolFindParameter(phsle, ppist, pcPar);

	//- if parameter found

	if (ppar || 1)
	{
	    //- resolve value

	    double d = SymbolParameterResolveScaledValue(phsle, ppist, pcPar);

	    //- print result

	    fprintf(stdout, "scaled value = %g\n",d);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "parameter not found in symbol\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter set query
///
/// \details 
/// 
///	printparameterset <context>
/// 
/// \todo 
/// 
///	This function should also be able to get the parameters from
///	functions.  First functions must be included in the principal
///	set before that can happen.
/// 

struct VectorParameters
{
    /// number of parameters

    int iParameters;

    /// parameters

    struct symtab_Parameters *ppparameters[100];
};

static int
ParameterNameComparator
(const void * pvParameter1, const void * pvParameter2)
{
    /// \note never saw this construct, but I got it right from the first
    /// \note time, I 'understand' this code, and it _does_ makes sense

    struct symtab_Parameters * const * pppar1 = pvParameter1;
    struct symtab_Parameters * const * pppar2 = pvParameter2;

    char *pc1 = ParameterGetName(*pppar1);
    char *pc2 = ParameterGetName(*pppar2);

    return strcmp(pc1, pc2);
}

static int
QueryMachineWildcardParameterSetTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct VectorParameters *pvpars = (struct VectorParameters *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if this is a biological component

    int iType = TstrGetActualType(ptstr);

    if (subsetof_bio_comp(iType))
    {
	/// \todo this code is one more reason to implement traversals that are
	/// \todo orthogonal to the model's axis.

	//- loop over all prototypes including self

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	while (pbio)
	{
	    //- loop over parameters of this prototype

	    struct symtab_Parameters *ppar
		= ParContainerIterateParameters(pbio->pparc);

	    while (ppar)
	    {
		//- lookup the parameter in the stored ones

		char *pcNew = ParameterGetName(ppar);

		int i;

		for (i = 0 ; i < pvpars->iParameters ; i++)
		{
		    //- if found

		    char *pcStored = ParameterGetName(pvpars->ppparameters[i]);

		    if (strcmp(pcStored, pcNew) == 0)
		    {
			//- loop index signals were found

			//- break loop

			break;
		    }
		}

		//- if not found

		if (i == pvpars->iParameters)
		{
		    //- store this parameter

		    pvpars->ppparameters[pvpars->iParameters] = ppar;

		    pvpars->iParameters++;
		}

		//- go to next parameter

		ppar = ParContainerNextParameter(ppar);
	    }

	    //- go to next prototype

	    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	}
    }
    else if (subsetof_algorithm_symbol(iType)
	     || subsetof_connection(iType)
	     || subsetof_connection_symbol(iType))
    {
    }
    else
    {
	//- give diagnostics : not supported

	fprintf
	    (stdout,
	     "printparameterset: only biocomponents are supported (%s is not a biocomponent)\n",
	     SymbolGetName(phsle));

	//- abort traversal

	iResult = TSTR_PROCESSOR_ABORT;
    }

    //- return result

    return(iResult);
}

extern int QueryHandlerPrintParameterSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    /// \note so phsleRoot can be NULL if the model description file was not found

    if (phsleRoot)
    {
	//- get parameters

	struct VectorParameters vpars =
	    {
		/// number of parameters

		0,

		/// parameters

		{
		    NULL,
		},
	    };

	//- traverse symbols that match with wildcard

	int iResult
	    = SymbolTraverseWildcard
	      (phsleRoot,
	       ppistRoot,
	       ppist,
	       QueryMachineWildcardParameterSetTraverser,
	       NULL,
	       (void *)&vpars);

	if (iResult == 1)
	{
	    //- sort things

	    qsort
		(&vpars.ppparameters[0],
		 vpars.iParameters,
		 sizeof(vpars.ppparameters[0]),
		 ParameterNameComparator);

	    //- loop over all parameters found

	    int i;

	    for (i = 0 ; i < vpars.iParameters ; i++)
	    {
		//- diags: parameter name

		char *pcStored = ParameterGetName(vpars.ppparameters[i]);

		fprintf(stdout, "Parameter (%s)\n", pcStored);
	    }

	}
	else
	{
	    fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n");
	}
    }
    else
    {
	//- diag's

	fprintf(stdout, "no model loaded\n");
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of segments.
/// 

extern int QueryHandlerPrintSegmentCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- obtain segment count

	int iChildren = SymbolCountSegments(phsle, ppist);

	//- print segment count

	fprintf(stdout, "Number of segments : %i\n", iChildren);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections for a spikereceiver in a projection.
///
/// \details 
/// 
///	spikereceivercount <projection> <spike-receiver>
/// 

extern int QueryHandlerPrintSpikeReceiverCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get projection context

    struct PidinStack *ppistProjection = PidinStackParse(&pcLine[iLength]);

    //- get spike receiver context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike receiver\n");

	return(FALSE);
    }

    struct PidinStack *ppistReceiver = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppistProjection);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    struct symtab_Projection *pproj = NULL;
	    int iConnections = -1;

	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	    {
		//return(FALSE);
	    }

	    //- print connection count

	    pproj = (struct symtab_Projection *)phsle;

	    iConnections
		= ProjectionGetNumberOfConnectionsForSpikeReceiver
		  (pproj, ppistProjection, ppistReceiver);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    //- print connection count

	    fprintf(stdout, "Number of connections : %i\n", iConnections);

	    //i
	    //i Bug: These print statements can lead to a stall when stdout is blocking I/O on the 
	    //i      fprintf statement. 
	    //i      Bug only seems to be present in Mac OSX Leopard when the machine has other 
	    //i      programs loaded and is running the nesting.t test in neurospaces_harness. 
	    //i      Could be a sign of another subprocess putting an I/O lock on stdout.

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- print : not a projection

	    fprintf(stdout, "%s is not a projection\n",SymbolName(phsle));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "projection symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistReceiver);
    PidinStackFree(ppistProjection);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print unique ID for symbol with respect to container.
///
/// \details 
/// 
///	spikereceiverserialID <population> <spike-receiver>
/// 

extern int QueryHandlerPrintSpikeReceiverSerialID
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phslePopulation = NULL;
    struct symtab_HSolveListElement *phsleReceiver = NULL;

    //- get population context

    struct PidinStack *ppistPopulation = PidinStackParse(&pcLine[iLength]);

    //- get spike receiver context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike receiver\n");

	return(FALSE);
    }

    struct PidinStack *ppistReceiver = PidinStackParse(pcBreak);

    //- lookup symbols

    /// \note allows namespacing, yet incompatible with parameter caches.

    phslePopulation = SymbolsLookupHierarchical(pneuro->psym, ppistPopulation);

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleReceiver = SymbolsLookupHierarchical(pneuro->psym, ppistReceiver);

    //- if found

    if (phslePopulation)
    {
	//- if population

	if (instanceof_population(phslePopulation))
	{
	    //- set serial ID

	    int iID
		= PopulationLookupSpikeReceiverSerialID
		  (phslePopulation,
		   ppistPopulation,
		   phsleReceiver,
		   ppistReceiver);

	    //- print serial ID

	    fprintf(stdout, "Serial ID : %i\n",iID);
	}

	//- else

	else
	{
	    //- print : not a population

	    fprintf(stdout, "%s is not a population\n",SymbolName(phslePopulation));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistReceiver);
    PidinStackFree(ppistPopulation);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections for a spikesender in a projection.
///
/// \details 
/// 
///	spikesendercount <projection> <spike-sender>
/// 

extern int QueryHandlerPrintSpikeSenderCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get projection context

    struct PidinStack *ppistProjection = PidinStackParse(&pcLine[iLength]);

    //- get spike sender context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a spike sender\n");

	return(FALSE);
    }

    struct PidinStack *ppistSender = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppistProjection);

    //- if found

    if (phsle)
    {
	//- if projection

	if (instanceof_projection(phsle))
	{
	    struct symtab_Projection *pproj = NULL;
	    int iConnections = -1;

	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
	    {
		//return(FALSE);
	    }

	    //- print connection count

	    pproj = (struct symtab_Projection *)phsle;

	    iConnections
		= ProjectionGetNumberOfConnectionsForSpikeGenerator
		  (pproj, ppistProjection, ppistSender);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruAfter))
	    {
		//return(FALSE);
	    }

	    //- compute time to execute query

	    timeval_subtract
		(&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
	    timeval_subtract
		(&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    fprintf(stdout, "Number of connections : %i\n", iConnections);

	    //- diag's

	    fprintf
		(stdout,
		 "user time = %lis, %lius\n",
		 tvUser.tv_sec,
		 (long int)tvUser.tv_usec);
	    fprintf
		(stdout,
		 "system time = %lis, %lius\n",
		 tvSystem.tv_sec,
		 (long int)tvSystem.tv_usec);

	}

	//- else

	else
	{
	    //- print : not a projection

	    fprintf(stdout, "%s is not a projection\n",SymbolName(phsle));
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "projection symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistSender);
    PidinStackFree(ppistProjection);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle parameter query
///
/// \details 
/// 
///	printsymbolparameters <context>
/// 

extern int QueryHandlerPrintSymbolParameters
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

/*     //- parse parameter */

/*     char pcSeparator[] = " \t,;\n"; */

/*     char *pcPar = strpbrk(&pcLine[iLength + 1], pcSeparator); */

/*     if (!pcPar) */
/*     { */
/* 	fprintf(stdout, "parameter not found on command line\n"); */

/* 	return(FALSE); */
/*     } */

/*     pcPar++; */

    //- if the context is a wildcard

    if (PidinStackIsWildcard(ppist))
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
/* 	    //- traverse symbols that match with wildcard */

/* 	    int iResult */
/* 		= SymbolTraverseWildcard */
/* 		  (phsleRoot, */
/* 		   ppistRoot, */
/* 		   ppist, */
/* 		   QueryMachineWildcardParameterTraverser, */
/* 		   NULL, */
/* 		   (void *)pcPar); */

/* 	    if (iResult != 1) */
/* 	    { */
/* 		fprintf(stdout, "SymbolTraverseWildcard() failed (or aborted)\n"); */
/* 	    } */
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "no model loaded\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);
    }

    //- else single parameter query

    else
    {
	//- lookup symbol

/* 	/// \note allows namespacing, yet incompatible with parameter caches. */

/* 	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

	/// \note does not allow namespacing

	phsle = PidinStackLookupTopSymbol(ppist);

	//- if found

	if (phsle)
	{
	    //- if biocomponent

	    if (instanceof_bio_comp(phsle))
	    {
		struct symtab_BioComponent *pbio
		    = (struct symtab_BioComponent *)phsle;

		if (!BioComponentExportParametersYAML(pbio, ppist, 0, NULL))
		{
		    bResult = 0;
		}

		//- else

		else
		{
		    //- diag's

		    fprintf(stdout, "export failed\n");
		}
	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbol is not a biocomponent\n");
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


