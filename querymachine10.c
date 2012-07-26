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


/*
 * \fun extern int QueryHandlerSymbolPrintParameterTraversal
 *          (char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
 * 
 *  Prints out all parameters associated with a given symbol.
 */
extern int QueryHandlerSymbolPrintParameterTraversal
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int iResult = 1;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);
 
    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	iResult = SymbolPrintParameterTraversal(phsle,ppist);
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

    return(iResult);
}


struct QM_SegmentValidator_data
{
    /// base symbol.

    struct symtab_HSolveListElement *phsleBase;

    /// number of entries in context ?

    int iEntries;
};

static
int
SegmentValidator
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
SegmentValidator
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : success

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to segment vector

    struct QM_SegmentValidator_data *pd
	= (struct QM_SegmentValidator_data *)pvUserdata;

    struct symtab_HSolveListElement *phsleBase = pd->phsleBase;

    int iEntries = pd->iEntries;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    struct PidinStack *ppist = ptstr->ppist;

    //- if this segment has a named parent segment

    struct symtab_Parameters *pparParent
	= SymbolGetParameter(phsle, ppist, "PARENT");

    if (pparParent)
    {
/* 	//- if parent symbol exists */

/* 	struct symtab_HSolveListElement *phsleParent */
/* 	    = ParameterResolveSymbol(pparParent, ppist); */

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar
	    = ParameterResolveToPidinStack(pparParent, ppist);

	if (ppistPar)
	{
	    {
		//- if parent symbol exists

		struct symtab_HSolveListElement *phsleParent = NULL;

		if (iEntries < PidinStackNumberOfEntries(ppistPar))
		{
		    phsleParent
			= SymbolLookupHierarchical
			  (phsleBase, ppistPar, iEntries, 1);
		}

		if (!phsleParent)
		{
		    char pc1[1000];
		    char pc2[1000];

		    PidinStackString(ppistPar, pc1, 1000);

		    PidinStackString(ppist, pc2, 1000);

		    fprintf(stdout, "not found using SymbolLookupHierarchical() for %s: %s\n", pc2, pc1);
		}
	    }

	    {
		//- if parent symbol exists

		struct symtab_HSolveListElement *phsleParent
		    = PidinStackLookupTopSymbol(ppistPar);

		if (!phsleParent)
		{
		    char pc1[1000];
		    char pc2[1000];

		    PidinStackString(ppistPar, pc1, 1000);

		    PidinStackString(ppist, pc2, 1000);

		    fprintf(stdout, "not found using PidinStackLookupTopSymbol() for %s: %s\n", pc2, pc1);
		}
	    }

	    //- free allocated memory

	    PidinStackFree(ppistPar);
	}
	else
	{
	    /// \note not sure if this is ok.

	    fprintf(stderr, "Warning: cannot find parent symbols in SegmentValidator()\n");
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
/// \brief Give version information.
/// 

extern
int
QueryHandlerValidateSegmentGroup
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get symbol context

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	struct QM_SegmentValidator_data d =
	{
	    phsle,

	    PidinStackNumberOfEntries(ppist),
	};

	//- if a cell

	if (instanceof_cell(phsle))
	{
	    //- traverse segments

	    int iTraverse
		= SymbolTraverseSegments(phsle, ppist, SegmentValidator, NULL, &d);
	}

	//- if a segment group

	else if (instanceof_v_segment(phsle))
	{
	    //- traverse segments

	    int iTraverse
		= SymbolTraverseSegments(phsle, ppist, SegmentValidator, NULL, &d);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol must be a cell or segment group\n");

	    bResult = FALSE;
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
/// \brief Give version information.
/// 

extern int QueryHandlerVersion
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- diag's

    char *pcVersion = NeurospacesGetVersion();

    fprintf(stdout, "Version info : %s\n", pcVersion);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write library of symbols.
///
/// \details 
/// 
///	writelibrary <nesting-depth> <file.nld> symbol symbol
/// 
///	For every given symbol on command line
///		Traverse in-symbol until nesting-depth reached,
///			tag used symbols at nesting-depth,
///			lookup tagged symbols, 
///				get info about imported files, 
///				build table on imported files,
///		write info on imported files in table,
///		write info on private models from tagged symbols,
///		Writes in-symbol until nesting-depth reached,
///			afterwards makes references to used symbols.
///	Write library file of given symbols.
/// 

extern int QueryHandlerWriteLibrary
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write modular description of symbol.
///
/// \details 
/// 
///	writemodular \
///		<public-nesting-depth> \
///		<private-nesting-depth> \
///		<file-prefix> \
///		<symbols>
/// 
///	writes <file-prefix>_<symbol-label>.nsd file for each symbol.
/// 

extern int QueryHandlerWriteModular
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Write selfcontained symbol description.
///
/// \details 
/// 
///	writesymbol \
///		<public-nesting-depth> \
///		<private-nesting-depth> \
///		<file-name.nsd> \
///		<symbols>
/// 
///	Nesting depths are used as maximum nesting depths in the
///	respective section of the description file before references are 
///	used, '-1' means infinite.
///	Writes file without any external dependencies on model description
///	files for a nesting depth of '-1'.  
/// 

extern int QueryHandlerWriteSymbol
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- return result

    return(bResult);
}


