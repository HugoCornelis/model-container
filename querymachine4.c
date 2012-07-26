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
/// \brief Print information about an input.
///
/// \details 
/// 
///	input-info <wildcard>
/// 

extern
int
QueryHandlerInputInfo
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup symbol

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(ppist);

    if (phsle)
    {
	if (instanceof_bio_comp(phsle))
	{
	    int i = 0;

	    struct symtab_BioComponent *pbio
		= (struct symtab_BioComponent *)phsle;

	    //- construct all input types

	    fprintf(stdout, "inputs:\n");

	    while (pbio)
	    {
		//- if input info

		struct symtab_IOContainer *pioc = SymbolGetInputs(phsle);

		if (pioc)
		{
		    //- loop over inputs

		    struct symtab_InputOutput *pio = IOContainerIterateRelations(pioc);

		    for ( ; pio ; i++)
		    {
			char pc[100];

			//- get info about input

			struct symtab_HSolveListElement *phsleInput = SymbolGetChildFromInput(phsle, pio);

			//- print info about input

			IdinFullName(pio->pidinField, pc);

			fprintf
			    (stdout,
			     "%s input %i: %s, %s\n",
			     SymbolName(&pbio->ioh.iol.hsle),
			     i,
			     pc,
			     phsleInput
			     ? SymbolHSLETypeDescribe(phsleInput->iType)
			     : "child not defined in this context");

			//- go to next input

			pio = IOContainerNextRelation(pio);
		    }
		}

		//- next prototype

		pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	    }
	}
	else
	{
	    fprintf(stdout, "symbol is not a biocomponent\n");
	}
    }
    else
    {
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
/// \brief Handle print query
/// 

extern int QueryHandlerImportedFiles
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    /// \note remember if ppist is zero length, root namespace ('::') is default.
    /// \note this lookup is neglected in the rest of this function.

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- print imported table to stdout

    SymbolsPrintImportedFiles(pneuro->psym,stdout);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args.
/// 
/// \return int : QueryHandler return value.
/// 
/// \brief Import a file.
/// 

extern
int
QueryHandlerImportFile
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse filename

    char pcSeparator[] = " \t,;\n";

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "filename not found on command line\n");

	return(FALSE);
    }

    char *pcFilename = &pcLine[iLength + 1];

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "namespace not found on command line\n");

	return(FALSE);
    }

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "namespace not found on command line\n");

	return(FALSE);
    }

    pcLine[iLength] = '\0';

    char *pcNamespace = &pcLine[iLength + 1];

    if (strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	strpbrk(&pcLine[iLength + 1], pcSeparator)[0] = '\0';
    }

    //- allocate memory for permanent storage

    pcFilename = strdup(pcFilename);

    pcNamespace = strdup(pcNamespace);

    //- qualify the filename

    char *pcQualified = ParserContextQualifyFilename(NULL, pcFilename);

    fprintf(stdout, "importing file %s as %s\n", pcFilename, pcQualified);

    //- import the file

    if (!ParserImport(pneuro->pacRootContext, pcQualified, pcFilename, pcNamespace))
    {
	fprintf(stdout, "importing file %s failed\n", pcFilename);
    }
    else
    {
	fprintf(stdout, "importing file %s ok\n", pcFilename);
    }

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

extern int QueryHandlerListSymbols
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- if found

    if (pif)
    {
	//- print namespaces to stdout

	ImportedFilePrint(pif, 0, EXPORTER_TYPE_INFO, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "no imported file with given namespace found\n");
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Mesh a cell or group of segments.
/// 

extern int QueryHandlerMesh
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse maximum length

    char pcSeparator[] = " \t,;\n";

    char *pcLength = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcLength)
    {
	fprintf(stdout, "maximum length not found on command line\n");

	return(FALSE);
    }

    pcLength++;

    double dLength = strtod(pcLength, NULL);

    if (dLength == 0.0)
    {
	fprintf(stdout, "length of 0.0 not allowed\n");

	return(FALSE);
    }

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    if (!phsle)
    {
	fprintf(stdout, "symbol not found\n");

	PidinStackFree(ppist);

	return(FALSE);
    }

    //- if this is a segmenter

    if (instanceof_segmenter(phsle))
    {
	//- call the segmentation routine

	struct symtab_Segmenter *psegr = (struct symtab_Segmenter *)phsle;

	SymbolMesherOnLength(&psegr->bio.ioh.iol.hsle, ppist, dLength);
    }
    else
    {
	fprintf(stdout, "symbol is not a segmenter\n");

	PidinStackFree(ppist);

	return(FALSE);
    }

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle namespaces query.
/// 

extern int QueryHandlerNameSpaces
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- find namespace

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- if found

    if (pif)
    {
	//- print namespaces to stdout

	ImportedFilePrintNameSpaces(pif, 0, stdout);
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "no imported file with given namespace found\n");
    }

    //- free allocated memory

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Partition a model (and cache the result for later use).
///
/// \details 
/// 
///	partition <context> <partitions> <this-node>
/// 

extern int QueryHandlerPartition
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- parse number of partitions needed

    char pcSeparator[] = " \t,;\n";

    char *pcPartitions = strpbrk(&pcLine[iLength + 1], pcSeparator);

    if (!pcPartitions)
    {
	fprintf(stdout, "number of partition nodes not found on command line\n");

	return(FALSE);
    }

    pcPartitions++;

    int iPartitions = strtol(pcPartitions, (char **)NULL, 0);

    //- parse number of this node

    char *pcThisNode = strpbrk(pcPartitions, pcSeparator);

    if (!pcThisNode)
    {
	fprintf(stdout, "number for this node not found on command line\n");

	return(FALSE);
    }

    pcThisNode++;

    int iThisNode = strtol(pcThisNode, (char **)NULL, 0);

    //- lookup symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     phsle = SymbolsLookupHierarchical(pneuro->psym, ppist); */

    phsle = PidinStackLookupTopSymbol(ppist);

    //- if found

    if (phsle)
    {
	//- get cumulative workload

	struct workload_info *pwi
	    = WorkloadNew(phsle, ppist, BIOLEVEL_ATOMIC, 0);

	//- if workload_cumulative ok

	if (pwi)
	{
	    WorkloadPartition(pwi, iPartitions);

	    WorkloadPrint(pwi, stdout);

/* 	    NeurospacesRegisterWorkload(pneuro, ptiWorkload, iThisNode); */

	    WorkloadFree(pwi);

	    fprintf(stdout, "workload ok\n");
	}
	else
	{
	    fprintf(stdout, "traversal failure (no children ?)\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "symbol not found\n");
    }

    //- free context info

    if (ppist)
    {
	PidinStackFree(ppist);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Match of two contexts ?
/// 

extern int QueryHandlerPidinStackMatch
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get first pidinstack

    struct PidinStack *ppist1 = PidinStackParse(&pcLine[iLength]);

    //- get second pidinstack

    /// \note will core for invalid command lines

    struct PidinStack *ppist2
	= PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));

    //- diag's on matching

    if (PidinStackMatch(ppist1, ppist2))
    {
	fprintf(stdout, "Match\n");
    }
    else
    {
	fprintf(stdout, "No match\n");
    }

    //- free pidinstacks

    PidinStackFree(ppist2);
    PidinStackFree(ppist1);

    //- return result

    return(bResult);
}


