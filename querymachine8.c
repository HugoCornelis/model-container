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
/// \brief Print info on spikesender or receiver for a given set of
/// projections.
///
/// \details 
/// 
///	projectionquery <caching = c|n> <attachment-path> <projection-path> ...
/// 

struct QM_pq_traversal_data
{
    /// set first serial ID : 0

    int iSerial;

    /// projection query

    struct ProjectionQuery *ppq;
};


static int
QueryMachineConnectionTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_pq_traversal_data *pqtd
	= (struct QM_pq_traversal_data *)pvUserdata;

    //- get actual symbol type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- if connection

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- give diag's

	fprintf
	    (stdout,
	     "Connection (%5.5i)\n",
	     pqtd->iSerial);

/* 	fprintf */
/* 	    (stdout, */
/* 	     "----------------------------------------------------\n"); */

/* 	fprintf */
/* 	    (stdout, */
/* 	     "Projection source (%i), Projection target (%i)\n", */
/* 	     ProjectionQueryGetCurrentSourceSerial(pqtd->ppq), */
/* 	     ProjectionQueryGetCurrentTargetSerial(pqtd->ppq)); */

	if (subsetof_cached_connection(iType))
	{
	    CachedConnectionPrint(pconn, TRUE, 8, stdout);
	}
	else if (subsetof_connection(iType))
	{
	    ConnectionPrint(pconn, TRUE, 8, stdout);
	}

	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
/* 	fprintf(stdout, "--------------------------------\n", pqtd->iSerial); */
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(iResult);
}


extern int QueryHandlerProjectionQuery
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    struct PidinStack *pppistProjections[10];
    int iProjections = 0;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    //- get projections

    for (iProjections = 0 
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

	if (pcBreak)
	{
	    pppistProjections[iProjections] = PidinStackParse(pcBreak);
	}
    }

    pppistProjections[iProjections] = NULL;

    //- if spike(gen|rec) found

    if (phsleAttachment)
    {
	//- create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections, iProjections);

	//- if projection query ok

	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	ProjectionQueryFree(ppq2);

	if (ppq)
	{
	    struct QM_pq_traversal_data qtd =
	    {
		/// set first serial ID : 0

		0,

		/// projection query

		ppq,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq, bCaching);

	    //- if attachment

	    if (instanceof_attachment(phsleAttachment))
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
		{
		    //return(FALSE);
		}

		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser, &ruAfter.ru_utime, &ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem, &ruAfter.ru_stime, &ruBefore.ru_stime);

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbol must be attachment\n");
	    }

	    //- free projection query

	    ProjectionQueryFree(ppq);

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
	    //- diag's

	    fprintf(stdout, "symbols must be projection\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	PidinStackFree(pppistProjections[iProjections]);
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections optionally on spikesender or
/// receiver for a given set of projections.
///
/// \details 
/// 
///	projectionquerycount \
///		<caching = c|n> \
///		<attachment-path>? \
///		<projection-path> ...
/// 

static int
QueryMachineConnectionCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_pq_traversal_data *pqtd
	= (struct QM_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n", pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


extern int QueryHandlerProjectionQueryCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
    struct PidinStack *pppistProjections[10];
    int iProjections = 0;
    int bCaching = FALSE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    //- get caching option

    if (pcLine[iLength + 1] == 'c')
    {
	bCaching = TRUE;
    }
    else if (pcLine[iLength + 1] == 'n')
    {
	bCaching = FALSE;
    }
    else
    {
	fprintf(stdout, "please indicate caching status (c|n)\n");
	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    if (!phsleAttachment)
    {
	fprintf(stdout, "symbol not found\n");

	PidinStackFree(ppistAttachment);

	return(FALSE);
    }

    if (phsleAttachment && !instanceof_attachment(phsleAttachment))
    {
	fprintf
	    (stdout,
	     "first symbol is not attachment,"
	     " will be used as part of projectionquery\n");
    }

    //- if is projection

    if (instanceof_projection(phsleAttachment))
    {
	//- fill in projection array

	pppistProjections[iProjections] = ppistAttachment;

	iProjections++;

	ppistAttachment = NULL;
	phsleAttachment = NULL;
    }

    //- get projections

    for (/* iProjections = 0  */
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

	if (pcBreak)
	{
	    pppistProjections[iProjections] = PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));
	}
    }

    pppistProjections[iProjections] = NULL;

    {
	//- create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections, iProjections);

	if (!ppq)
	{
	    fprintf(stdout, "Could not allocate projection query\n");

	    return(FALSE);
	}

	//- if projection query ok

	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	ProjectionQueryFree(ppq2);

	if (ppq)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    struct QM_pq_traversal_data qtd =
	    {
		/// set count : 0

		0,

		/// projection query

		ppq,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq, bCaching);

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	    {
		//return(FALSE);
	    }

	    //- if selective count

	    if (ppistAttachment)
	    {
		//- if incoming attachment

		if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connections arriving on spike receiver

		    ProjectionQueryTraverseConnectionsForSpikeReceiver
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq,
			 ppistAttachment,
			 QueryMachineConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

	    }

	    //- else

	    else
	    {
		//- traverse connections arriving on spike receiver

		ProjectionQueryTraverseConnections
		    (ppq,
		     QueryMachineConnectionCounter,
		     NULL,
		     (void *)&qtd);
	    }

/* 	    { */
/* 		int i; */

/* 		for (i = 10000000 ; i > 0 ; i --); */
/* 	    } */

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

	    //- diag's

	    fprintf(stdout, "#connections = %i\n", qtd.iSerial);

	    fprintf
		(stdout,
		 "#memory used by projection query = %i\n",
		 ProjectionQueryGetMemorySize(ppq));

	    fprintf
		(stdout,
		 "#memory used by connection cache = %i\n",
		 ppq->pcc
		 ? ConnectionCacheGetMemorySize(ppq->pcc)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 1  = %i\n",
		 ppq->poccPre
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPre)
		 : 0 );

	    fprintf
		(stdout,
		 "#memory used by ordered cache 2  = %i\n",
		 ppq->poccPost
		 ? OrderedConnectionCacheGetMemorySize(ppq->poccPost)
		 : 0 );

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

	    //- free projection query

	    ProjectionQueryFree(ppq);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbols must be projection\n");
	}
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	free(pppistProjections[iProjections]);
    }

    //- free attachment info

    if (ppistAttachment)
    {
	PidinStackFree(ppistAttachment);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Recalculate serial mappings for a symbol relative.
///
/// \details 
/// 
///	recalculate <context>
/// 

extern
int
QueryHandlerRecalculate
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- if there is a context argument

    if (pcLine[iLength])
    {
	//- parse command line element

	struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

	//- lookup symbol

	/// \note allows namespacing, yet incompatible with parameter caches.
	/// \note note : can be lookup for root, so PidinStackLookupTopSymbol()
	/// \note does not work, should be fixed ?

	struct symtab_HSolveListElement *phsle
	    = SymbolsLookupHierarchical(pneuro->psym, ppist);

	//- if found

	if (phsle)
	{
	    char pc[1000];

	    PidinStackString(ppist, pc, 1000);

	    fprintf(stdout, "recalc serials for %s\n", pc);

	    //- recalc serials

	    SymbolRecalcAllSerials(phsle, ppist);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");
	}

	//- free allocated memory

	PidinStackFree(ppist);
    }
    else
    {
	fprintf(stdout, "recalc all serials\n");

	//- recalc all serials

	SymbolRecalcAllSerials(NULL, NULL);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Reduce parameters of a component, all if no component
/// given.
///
/// \details 
/// 
///	reduce <component>
/// 

extern
int
QueryHandlerReduce
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int iResult = 1;

    struct PidinStack *ppist = NULL;
    struct symtab_HSolveListElement *phsle = NULL;

    if (pcLine[iLength])
    {
	//- parse command line element

	ppist = PidinStackParse(&pcLine[iLength]);

	//- lookup symbol

	/// \note allows namespacing, yet incompatible with parameter caches.

	phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

	if (!phsle)
	{
	    //- diag's

	    fprintf(stdout, "symbol not found\n");

	    //- return failure

	    return(0);
	}

    }

    //- if symbol found

    if (phsle)
    {
	//- reduce parameters of only this symbol

	iResult = SymbolReduce(phsle, ppist);
    }

    //- else

    else
    {
	//- reduce everything

	iResult = NeurospacesReduce(pneuro);
    }

    if (ppist)
    {
	//- free context

	PidinStackFree(ppist);
    }

    //- return result

    return(iResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Get solver info for symbol.
///
/// \details 
/// 
///	resolvesolver <solved-context>
/// 

extern int QueryHandlerResolveSolverID
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
	//- if projection

	if (instanceof_projection(phsle))
	{
	    //- diag's

	    fprintf(stdout, "not implemented for projections\n");
	}

	//- if instance of biocomponent

	else if (instanceof_bio_comp(phsle))
	{
	    int iSerialID = -1;
	    struct SolverInfo *psi = NULL;
	    struct PidinStack *ppistSerial = NULL;

	    //- get solver info for symbol

	    psi = SolverRegistryGet(pneuro->psr, ppist);

	    if (!psi)
	    {
		fprintf(stdout, "Could not find solver info\n", iSerialID);
		return(FALSE);
	    }

	    //- lookup serial ID

	    iSerialID = SolverInfoLookupPrincipalSerial(psi, ppist);

	    //- diag's

	    fprintf
		(stdout,
		 "Solver = %s, solver serial ID = %i\n",
		 SolverInfoGetSolverString(psi),
		 iSerialID);

	    //- convert serial back to context

	    ppistSerial
		= SolverInfoLookupContextFromPrincipalSerial(psi, iSerialID);

	    if (ppistSerial)
	    {
		//- diag's

		fprintf
		    (stdout,
		     "Solver serial context for %i = \n\t",
		     iSerialID);

		PidinStackPrint(ppistSerial, stdout);

		fprintf(stdout, "\n");

		//- free context

		PidinStackFree(ppistSerial);
	    }
	    else
	    {
		fprintf
		    (stdout,
		     "Solver serial context for %i = \n\t(NULL)\n",
		     iSerialID);
	    }
	}
	else
	{
	    fprintf(stdout, "not a biocomponent\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free context

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Linearize the segments in a segmenter in an internal cache.
/// 

extern
int
QueryHandlerSegmenterLinearize
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
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    int iSuccess = SymbolLinearize(phsle, ppist);

	    //- print segment count

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    fprintf(stdout, "---\n", psegr->desegmenter.iSegments);
	    fprintf(stdout, "Number of segments: %i\n", psegr->desegmenter.iSegments);
	    fprintf(stdout, "Number of segments without parents: %i\n", psegr->desegmenter.iNoParents);
	    fprintf(stdout, "Number of segment tips: %i\n", psegr->desegmenter.iTips);

	    if (!iSuccess)
	    {
		fprintf(stdout, "linearization failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
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
/// \brief Report the parent count in a segmenter.
/// 

extern
int
QueryHandlerSegmenterParentCount
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
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterParentCount(psegr, ppist);

	    if (!iSuccess)
	    {
		fprintf(stdout, "parent count report failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
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
/// \brief Set the segmenter base for a group of segments.
///
/// \details 
/// 
///	segmentersetbase <segmenter-base-context>
/// 

extern
int
QueryHandlerSegmenterSetBase
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
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- linearize

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterSetBase(psegr, ppist);

	    if (!iSuccess)
	    {
		fprintf(stdout, "setting segmentation base component failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
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
/// \brief Report the segment tips in a segmenter.
/// 

extern
int
QueryHandlerSegmenterTips
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
	//- if segmenter

	if (instanceof_segmenter(phsle))
	{
	    //- report tips

	    struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	    int iSuccess = SegmenterTips(psegr, ppist, 0);

	    if (!iSuccess)
	    {
		fprintf(stdout, "tip report failed\n");
	    }
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "symbol is not a segmenter\n");
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


