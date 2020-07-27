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
/// \brief Count connections in projection query.
/// 

struct QM_neuro_pq_traversal_data
{
    /// set first serial ID : 0

    int iSerial;

    /// projection query

    struct ProjectionQuery *ppq;

    /// file to write to

    FILE *pfile;
};


static int 
QueryMachineNeuroConnectionCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

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
	fprintf(stdout, "--------------------------------\n"); // , pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


extern int QueryHandlerPQCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
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

    if (strpbrk(&pcLine[iLength + 1], " \t"))
    {
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
	    fprintf(stdout, "attachment symbol not found\n");

	    PidinStackFree(ppistAttachment);

	    return(FALSE);
	}
    }

    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    struct QM_neuro_pq_traversal_data qtd =
	    {
		/// set count : 0

		0,

		/// projection query

		ppq2,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq2, bCaching);

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
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionCounter,
			 NULL,
			 (void *)&qtd);
		}

	    }

	    //- else

	    else
	    {
		//- traverse all connections

		ProjectionQueryTraverseConnections
		    (ppq2,
		     QueryMachineNeuroConnectionCounter,
		     NULL,
		     (void *)&qtd);
	    }

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

	    fprintf(stdout, "#connections = %i\n",qtd.iSerial);

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

	    //- free cloned projection query

	    ProjectionQueryFree(ppq2);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "No projection query defined yet.\n");
	}
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
/// \brief Count pre-synaptic serials in projection query.
/// 

extern int QueryHandlerPQCountPre
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    fprintf(stdout, "number of pre-synaptic serials: %i\n", ProjectionQueryCountPreSerials(ppq));
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "No projection query defined yet.\n");
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print some info on registered projection query.
/// 

extern int QueryHandlerPQGet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print all projections in query

    if (pneuro->ppq)
    {
	int i;

	fprintf
	    (stdout, "bCaching(%s)\n", pneuro->ppq->bCaching ? "TRUE" : "FALSE");

	fprintf
	    (stdout,
	     "pcc(%s)\n",
	     pneuro->ppq->pcc ? "available" : "not available");

	fprintf
	    (stdout,
	     "pcc->iConnections(%i)\n",
	     pneuro->ppq->pcc ? pneuro->ppq->pcc->iConnections : -1);

	fprintf
	    (stdout,
	     "poccPre(%s)\n",
	     pneuro->ppq->poccPre ? "available" : "not available");

	fprintf
	    (stdout,
	     "poccPost(%s)\n",
	     pneuro->ppq->poccPost ? "available" : "not available");

	fprintf(stdout, "iCloned(%i)\n", pneuro->ppq->iCloned);

	fprintf(stdout, "iCursor(%i)\n", pneuro->ppq->iCursor);

	for (i = 0 ; i < pneuro->ppq->iProjections ; i++)
	{
	    fprintf
		(stdout,
		 "%i -> %i : ",
		 pneuro->ppq->piSource[i],
		 pneuro->ppq->piTarget[i]);

	    PidinStackPrint(pneuro->ppq->pppist[i], stdout);

	    fprintf(stdout, "\n");
	}
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Load a projection query from a file.
/// 

extern int QueryHandlerPQLoad
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    char pcFilename[1000];

    int iSize = -1;

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

    //- get filename

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }

    //pcFilename = malloc((1 + iSize) * sizeof(char));

    strncpy(pcFilename, &pcLine[iLength + 1], iSize);

    pcFilename[iSize] = '\0';

    char *pcQualified = pcFilename;

    if (pcQualified[0] != '/')
    {
	pcQualified = ParserContextQualifyToEnvironment(pcFilename);
    }

    if (!pcQualified)
    {
	fprintf(stdout, "Could not qualify %s\n", pcFilename);

	return(FALSE);
    }

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- open file

    FILE *pfile = fopen(pcQualified, "r");;

    if (!pfile)
    {
	fprintf(stdout, "Could not open file %s\n", pcQualified);

	return(FALSE);
    }

    //- read number of connections

    int iConnections;

    int iAssigned = fscanf(pfile, "Number of connections : %i\n", &iConnections);

    if (iAssigned != 1)
    {
	fclose(pfile);

	return(FALSE);
    }

/*     //- allocate connections */

/*     struct symtab_Connection **ppconn = calloc(iConnections, sizeof(struct symtab_Connection *)); */

/*     int iCount = 0; */

/*     while (iCount < iConnections) */
/*     { */
/* 	ppconn[iCount] = ConnectionCalloc(); */

/* 	iCount++; */
/*     } */

    //- allocate connection cache

    struct ConnectionCache *pcc = ConnectionCacheNew(iConnections);

    struct CachedConnection *pcconn = pcc->pcconn;

    //- loop

    int iCount = 0;

    while (iCount < iConnections)
    {
	//- read next connection from file

	int iPre;
	int iPost;
	double dDelay;
	double dWeight;

	(void) fscanf(pfile, "%i,%i(%lf,%lf)\n", &iPre, &iPost, &dDelay, &dWeight);

/* 	//- store connection data */

/* 	ConnectionInit(ppconn[iCount]); */

/* 	ppconn[iCount]->deconn.iPreSynaptic = iPre; */
/* 	ppconn[iCount]->deconn.iPostSynaptic = iPost; */

/* 	ppconn[iCount]->deconn.dDelay = dDelay; */
/* 	ppconn[iCount]->deconn.dWeight = dWeight; */

	//- store connection cache data

/* 	pcconn[iCount].iProjection = -1; */
/* 	pcconn[iCount].phsle = (struct symtab_HSolveListElement*)ppconn[iCount]; */

     0;
	pcconn[iCount].iPre = iPre;
	pcconn[iCount].iPost = iPost;
	pcconn[iCount].dDelay = dDelay;
	pcconn[iCount].dWeight = dWeight;

	//- increment count

	iCount++;
    }

    //- done reading from file

    fclose(pfile);

    /// \note following code nicely copied from projectionquery.c

    //- allocate projection query

    struct ProjectionQuery *ppq
	= (struct ProjectionQuery *)
	  calloc(1, sizeof(struct ProjectionQuery));

    //- set allocated memory counter

    ppq->iMemoryUsed = sizeof(struct ProjectionQuery);

    //- set caching status : must be caching

    ppq->bCaching = TRUE;

    //- block the cursor from being used

    ppq->iCursor = 100000;

    //- link the connections and the cache into the projection query

    ppq->pcc = pcc;

    //- keep track of used memory

    ppq->iMemoryUsed += ConnectionCacheGetMemorySize(ppq->pcc);

    //- initialize ordered connection caches

    if (!ProjectionQueryBuildOrderedConnectionCaches(ppq))
    {
	bResult = FALSE;
    }

    //- register projection query in neurospaces

    if (pneuro->ppq)
    {
	NeurospacesRemoveProjectionQuery(pneuro);
    }

    NeurospacesSetProjectionQuery(pneuro, ppq);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Store connections in projection query in a file.
///
/// \details 
/// 
///	pqsave <caching = c|n> <filename>
/// 

static int 
QueryMachineNeuroConnectionStore
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_cached_connection(iType)
	|| subsetof_connection(iType)
	|| subsetof_connection_symbol(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//- get source and target for current projection

	int iSource = ProjectionQueryGetCurrentSourceSerial(pqtd->ppq);

	int iTarget = ProjectionQueryGetCurrentTargetSerial(pqtd->ppq);

	//- get pre and post for connection

	int iPre = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "PRE");

	int iPost = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "POST");

	//- get weight and delay

	double dDelay
	    = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "DELAY");

	double dWeight
	    = SymbolParameterResolveValue((struct symtab_HSolveListElement *)pconn, NULL, "WEIGHT");

	fprintf
	    (pqtd->pfile,
	     "%i,%i(%f,%f)\n",
	     iSource + iPre,
	     iTarget + iPost,
	     dDelay,
	     dWeight);

	//- increment serial count

	pqtd->iSerial++;
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout, "Non-connection at serial (%5.5i)\n", pqtd->iSerial);
	fprintf(stdout, "--------------------------------\n"); // , pqtd->iSerial);
    }

    //- return result

    return(iResult);
}


extern int QueryHandlerPQSave
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    int bCaching = FALSE;

    char pcFilename[1000];

    int iSize = -1;

    //- get projection query

    struct ProjectionQuery *ppq = pneuro->ppq;

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

    //- get filename

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iSize = strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iSize = strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }

    //pcFilename = malloc((1 + iSize) * sizeof(char));

    strncpy(pcFilename,&pcLine[iLength + 1],iSize);

    pcFilename[iSize] = '\0';

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- if clone projection query

    if (ppq)
    {
	struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	struct QM_neuro_pq_traversal_data qtd =
	{
	    /// set first serial ID : 0

	    0,

	    /// projection query

	    ppq2,

	    /// file to write to

	    NULL,
	};

	//- give some diag's

	fprintf(stdout, "Storing connection matrix in file %s\n", pcFilename);

	//- set if projectionquery should use caches

	ProjectionQuerySetCaching(ppq2,bCaching);

	//- open output file

	qtd.pfile = fopen(pcFilename, "w");

	//- write number of connections

	int iConnections = ProjectionQueryCountConnections(ppq2);

	fprintf(qtd.pfile, "Number of connections : %i\n", iConnections);

	//- traverse connections in query

	ProjectionQueryTraverseConnections
	    (ppq2,
	     QueryMachineNeuroConnectionStore,
	     NULL,
	     (void *)&qtd);

	//- close file

	fclose(qtd.pfile);

	//- free cloned projection query

	ProjectionQueryFree(ppq2);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "No projection query defined yet.\n");
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
/// \brief Define a projection query.
/// 

extern int QueryHandlerPQSet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *pppistProjections[1000];
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

    //- get projections

    for (iProjections = 0 
/* 	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength] */;
	 strpbrk(&pcLine[iLength + 1], " \t") ;
	 iProjections++ ,
	     iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength])
    {
	pppistProjections[iProjections]
	    = PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));
    }

    pppistProjections[iProjections] = NULL;

    {
	//- if can create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pppistProjections,iProjections);

	//- failed to allocate a projection query

	if (ppq)
	{
	    //- if projection query ok

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    ProjectionQueryFree(ppq2);

	    if (ppq)
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

/* 		struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq); */

		//- set if projectionquery should use caches

		ProjectionQuerySetCaching(ppq,bCaching);

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
		{
		    //return(FALSE);
		}

		//- if should use caches

		if (bCaching)
		{
		    //- build caches

		    ProjectionQueryBuildCaches(ppq);
		}

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

		//- register projection query in neurospaces

		if (pneuro->ppq)
		{
		    NeurospacesRemoveProjectionQuery(pneuro);
		}

		NeurospacesSetProjectionQuery(pneuro, ppq);

		//- diag's

		fprintf
		    (stdout,
		     "# connections = %i\n",
		     ProjectionQueryCountConnections(ppq));
		fprintf
		    (stdout,
		     "caching = %s\n",
		     bCaching ? "yes" : "no");

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
	else
	{
	    //- diag's

	    fprintf(stdout, "cannot allocate projection query (no projections ?)\n");
	}
    }

    //- free projection info

    for (iProjections = 0 ; pppistProjections[iProjections] ; iProjections++)
    {
	PidinStackFree(pppistProjections[iProjections]);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Select all projections in the model for the projection query.
/// 

struct QM_projection_collector_traversal_data
{
    /// start of traversal

    struct PidinStack *ppistStart;

    /// number of projections found

    int iProjections;

    /// contexts of projections

    struct PidinStack *pppistProjections[1000];
};


static int 
QueryMachineProjectionContextCollector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_projection_collector_traversal_data *ppcd
	= (struct QM_projection_collector_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if a projection

    if (instanceof_projection(phsle))
    {
	//- allocate a context for this projection

	int iSerial = TstrGetPrincipalSerial(ptstr);

	struct symtab_HSolveListElement *phsleStart
	    = PidinStackLookupTopSymbol(ppcd->ppistStart);

	struct PidinStack *ppistProjection
	    = SymbolPrincipalSerial2Context(phsleStart, ppcd->ppistStart, iSerial);

	//- fill in context

	ppcd->pppistProjections[ppcd->iProjections] = ppistProjection;

	//- increment the number of projections found

	ppcd->iProjections++;
    }

    //- else

    else
    {
	//- signal internal error

	fprintf
	    (stdout,
	     "Internal error : asking for only projections, also encountering %i (%s)\n",
	     phsle->iType,
	     ppc_symbols_long_descriptions[phsle->iType]);
    }

    //- return result

    return(iResult);
}


extern int QueryHandlerPQSetAll
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

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

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct QM_projection_collector_traversal_data pcd =
	{
	    /// start of traversal

	    ppistRoot,

	    /// number of projections found

	    0,

	    /// contexts of projections

	    { NULL, },
	};

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppistRoot,
	   SymbolProjectionSelector,
	   NULL,
	   QueryMachineProjectionContextCollector,
	   (void *)&pcd,
	   NULL,
	   NULL);

    //- traverse symbol : get projections

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    int iTraverse = TstrGo(ptstr, phsleRoot);

    //- delete treespace traversal

    TstrDelete(ptstr);

    pcd.pppistProjections[pcd.iProjections] = NULL;

    {
	//- if can create projection query

	struct ProjectionQuery *ppq
	    = ProjectionQueryCallocFromProjections
	      (pcd.pppistProjections, pcd.iProjections);

	//- failed to allocate a projection query

	if (ppq)
	{
	    //- if projection query ok

	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    ProjectionQueryFree(ppq2);

	    if (ppq)
	    {
		/// resources used before and after command executed

		struct rusage ruBefore, ruAfter;

/* 		struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq); */

		//- set if projectionquery should use caches

		ProjectionQuerySetCaching(ppq,bCaching);

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
		{
		    //return(FALSE);
		}

		//- if should use caches

		if (bCaching)
		{
		    //- build caches

		    ProjectionQueryBuildCaches(ppq);
		}

		//- get resource usage

		if (-1 == getrusage(RUSAGE_SELF,&ruAfter))
		{
		    //return(FALSE);
		}

		//- compute time to execute query

		timeval_subtract
		    (&tvUser,&ruAfter.ru_utime,&ruBefore.ru_utime);
		timeval_subtract
		    (&tvSystem,&ruAfter.ru_stime,&ruBefore.ru_stime);

		//- register projection query in neurospaces

		if (pneuro->ppq)
		{
		    NeurospacesRemoveProjectionQuery(pneuro);
		}

		NeurospacesSetProjectionQuery(pneuro, ppq);

		//- diag's

		fprintf
		    (stdout,
		     "# connections = %i\n",
		     ProjectionQueryCountConnections(ppq));
		fprintf
		    (stdout,
		     "caching = %s\n",
		     bCaching ? "yes" : "no");

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
	else
	{
	    //- diag's

	    fprintf(stdout, "cannot allocate projection query (no projections ?)\n");
	}
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    for (pcd.iProjections = 0 ; pcd.pppistProjections[pcd.iProjections] ; pcd.iProjections++)
    {
	PidinStackFree(pcd.pppistProjections[pcd.iProjections]);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print info on connections in global projection query.
/// 

static int 
QueryMachineNeuroConnectionTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_neuro_pq_traversal_data *pqtd
	= (struct QM_neuro_pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

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
	fprintf(stdout, "--------------------------------\n"); // , pqtd->iSerial);
    }

    //- diag's

    fprintf(stdout, "\n");

    //- return result

    return(iResult);
}


extern int QueryHandlerPQTraverse
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppistAttachment = NULL;
    struct symtab_HSolveListElement *phsleAttachment = NULL;
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

    if (strpbrk(&pcLine[iLength + 1], " \t") == 0)
    {
	iLength += strlen(&pcLine[iLength + 1]);
    }
    else
    {
	iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];
    }


    //- parse command line element, get spike(gen|rec)

    ppistAttachment = PidinStackParse(&pcLine[iLength]);

    //- lookup attachment symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsleAttachment
	= SymbolsLookupHierarchical(pneuro->psym, ppistAttachment);

    //- if spike(gen|rec) found

    if (phsleAttachment)
    {
	//- get projection query

	struct ProjectionQuery *ppq = pneuro->ppq;

	//- if clone projection query

	if (ppq)
	{
	    struct ProjectionQuery *ppq2 = ProjectionQueryClone(ppq);

	    struct QM_neuro_pq_traversal_data qtd =
	    {
		/// set first serial ID : 0

		0,

		/// projection query

		ppq2,
	    };

	    //- set if projectionquery should use caches

	    ProjectionQuerySetCaching(ppq2, bCaching);

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
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

		//- if outgoing attachment

		else if (AttachmentPointIsOutgoing
			 ((struct symtab_Attachment *)phsleAttachment))
		{
		    //- traverse connection arriving on spike generator

		    ProjectionQueryTraverseConnectionsForSpikeGenerator
			(ppq2,
			 ppistAttachment,
			 QueryMachineNeuroConnectionTraverser,
			 NULL,
			 (void *)&qtd);
		}

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

	    }

	    //- else

	    else
	    {
		//- diag's

		fprintf(stdout, "symbol must be attachment\n");
	    }

	    //- free cloned projection query

	    ProjectionQueryFree(ppq2);

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

	    fprintf(stdout, "No projection query defined yet.\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
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


