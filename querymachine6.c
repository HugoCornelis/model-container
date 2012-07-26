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
/// \brief Handle print query
/// 

extern int QueryHandlerPrintCellCount
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
	//- obtain cell count

	int iCells = SymbolCountCells(phsle, ppist);

	//- print cell count

	fprintf(stdout, "Number of cells : %i\n", iCells);
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
/// \brief Handle print query
/// 

extern int QueryHandlerPrintChildren
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
	struct symtab_IOContainer *pioc = NULL;
	struct symtab_InputOutput *pio = NULL;
	IOHContainer *piohcChildren = NULL;
	struct symtab_HSolveListElement *phsleChild = NULL;
	int i = 0;

	//- if children info

	///
	/// \note never use this to do a traversal, use std traversals instead.
	///

	piohcChildren = SymbolGetChildren((struct symtab_IOHierarchy *)phsle);

	if (piohcChildren)
	{
	    fprintf(stdout, "children (if any) :\n");

	    phsleChild = IOHContainerIterate(piohcChildren);

	    //- loop over children

	    for (i = 0 ;
		 SymbolIterateValid(phsleChild) ;
		 i++)
	    {
		char pc[100];

		//- print info about child

		IdinFullName(SymbolGetPidin(phsleChild), pc);

		fprintf
		    (stdout,
		     "Child %i : %s,%s\n",
		     i,
		     pc,
		     SymbolHSLETypeDescribe(phsleChild->iType));

		//- go to next child

		phsleChild = SymbolContainerNext(phsleChild);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol has no children\n");
	}

	//- if input info

	pioc = SymbolGetInputs(phsle);

	if (pioc)
	{
	    fprintf(stdout, "inputs (if any) :\n");

	    //- loop over inputs

	    pio = IOContainerIterateRelations(pioc);

	    for (i = 0 ; pio ; i++)
	    {
		char pc[100];

		//- get info about input

		phsleChild = SymbolGetChildFromInput(phsle, pio);

		//- print info about input

		IdinFullName(pio->pidinField, pc);

		fprintf
		    (stdout,
		     "Input %i : %s,%s\n",
		     i,
		     pc,
		     phsleChild
		     ? SymbolHSLETypeDescribe(phsleChild->iType)
		     : "Child given as input, but not defined");

		//- go to next input

		pio = IOContainerNextRelation(pio);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol has no inputs\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print number of connections in given projection.
///
/// \details 
/// 
///	connectioncount <projection symbol>
/// 

extern int QueryHandlerPrintConnectionCount
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// time taken to execute query

    struct timeval tvUser;
    struct timeval tvSystem;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	int iConnections = -1;

	/// resources used before and after command executed

	struct rusage ruBefore, ruAfter;

	//- get resource usage

	if (-1 == getrusage(RUSAGE_SELF, &ruBefore))
	{
	    //return(FALSE);
	}

	//- obtain connection count

	iConnections = SymbolCountConnections(phsle, ppist);

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
/// \brief Handle coordinate query
///
/// \details 
/// 
///	printcoordinates <caching = c|n> <ancestor> <descendant>
/// 

extern int QueryHandlerPrintCoordinates
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

    //- go to next arg

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    struct symtab_HSolveListElement *phsle = NULL;
    struct symtab_HSolveListElement *phsleCoord = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get symbol to print coordinates for

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify two ancestor and descendant symbols\n");

	return(FALSE);
    }

    struct PidinStack *ppistCoord = PidinStackParse(pcBreak);

    //- lookup symbol

    /// \note need serial here

    phsle = PidinStackLookupTopSymbol(ppist);

    //- lookup coordinate symbol

    /// \note loads cache, ie cache is passed with parameter.

    phsleCoord = PidinStackLookupTopSymbol(ppistCoord);

    //- if both found

    if (phsle && phsleCoord)
    {
	//- if caching

	if (bCaching)
	{
	    /// resources used before and after command executed

	    struct rusage ruBefore, ruAfter;

	    //- get resource usage

	    if (-1 == getrusage(RUSAGE_SELF,&ruBefore))
	    {
		//return(FALSE);
	    }

	    //- init traversal for caches

	    struct TreespaceTraversal *ptstr
		= TstrNew
		  (ppist,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL,
		   NULL);

	    //- build caches

	    struct CoordinateCache *pcc = CoordinateCacheNewForTraversal(ptstr);

	    if (CoordinateCacheBuildCaches(pcc))
	    {
		//- lookup symbol in cache

		int iAncestor = PidinStackToSerial(ppist);

		int iDescendant = PidinStackToSerial(ppistCoord);

		int iCoord = iDescendant - iAncestor;

		struct CachedCoordinate *pccrd
		    = CoordinateCacheLookup(pcc, iCoord);

		//- print results

		fprintf(stdout, "cached coordinate x = %g\n", pccrd->D3.dx);
		fprintf(stdout, "cached coordinate y = %g\n", pccrd->D3.dy);
		fprintf(stdout, "cached coordinate z = %g\n", pccrd->D3.dz);

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

		//- print coordinate count

		fprintf(stdout, "#coordinates : %i\n", pcc->iCoordinates);
		fprintf
		    (stdout,
		     "#memory used by coordinate cache = %i\n",
		     pcc->iMemoryUsed);

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
	    else
	    {
		fprintf(stdout, "cannot build coordinate caches\n");
	    }

	    //- free cache

	    CoordinateCacheFree(pcc);

	    //- delete treespace traversal

	    TstrDelete(ptstr);

	}

	//- else non caching

	else
	{
	    struct D3Position D3Coord;

	    //- resolve coordinate values with default transformations

	    double x
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "X");

	    double y
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "Y");

	    double z
		= SymbolParameterResolveTransformedValue
		  (phsle, ppist, ppistCoord, "Z");

	    //- print results

	    fprintf(stdout, "transformed x = %g\n", x);
	    fprintf(stdout, "transformed y = %g\n", y);
	    fprintf(stdout, "transformed z = %g\n", z);

	    //- resolve coordinate

	    SymbolParameterResolveCoordinateValue
		(phsle, ppist, ppistCoord, &D3Coord);

	    //- print results

	    fprintf(stdout, "coordinate x = %g\n", D3Coord.dx);
	    fprintf(stdout, "coordinate y = %g\n", D3Coord.dy);
	    fprintf(stdout, "coordinate z = %g\n", D3Coord.dz);
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
/// \brief Handle print query
///
/// \details 
///
///	printinfo <type> <context>
/// 

extern
int
QueryHandlerPrintInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

/*     //- get type */

/*     int iType = -1; */

/*     char pcSeparator[] = " \t,;\n"; */

/*     if (!strpbrk(&pcLine[iLength + 1], pcSeparator)) */
/*     { */
/* 	fprintf(stdout, "export type not specified on command line\n"); */

/* 	return(FALSE); */
/*     } */

/*     char *pcType = &pcLine[iLength + 1]; */

/*     iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength]; */

/*     pcLine[iLength] = '\0'; */

/*     iLength++; */

/*     if (strcmp(pcType, "info") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_INFO; */
/*     } */
/*     else if (strcmp(pcType, "ndf") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_NDF; */
/*     } */
/*     else if (strcmp(pcType, "xml") == 0) */
/*     { */
/* 	iType = EXPORTER_TYPE_XML; */
/*     } */
/*     else */
/*     { */
/* 	iType = -1; */
/*     } */

/*     if (iType == -1) */
/*     { */
/* 	fprintf(stdout, "export of type %s not supported\n", pcType); */

/* 	return(FALSE); */
/*     } */

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- print info

	SymbolPrint(phsle, 4, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- return result

    return(bResult);
}


