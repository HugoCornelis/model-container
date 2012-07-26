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
/// \brief Handle context subtraction query.
/// 

extern int QueryHandlerContextSubtract
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct PidinStack *ppist3 = NULL;

    char pc3[1000];

    //- get first pidinstack

    struct PidinStack *ppist1 = PidinStackParse(&pcLine[iLength]);

    //- get second pidinstack

    /// \note will core for invalid command lines

    struct PidinStack *ppist2
	= PidinStackParse(strpbrk(&pcLine[iLength + 1], " \t"));

    //- subtract two contexts

    ppist3 = PidinStackSubtract(ppist1, ppist2);

    PidinStackString(ppist3, pc3, 1000);

    fprintf(stdout, "---\n");

    fprintf(stdout, "first-second: %s\n", pc3);

    PidinStackFree(ppist3);

    //- subtract two contexts, reverse order

    ppist3 = PidinStackSubtract(ppist2, ppist1);

    PidinStackString(ppist3, pc3, 1000);

    fprintf(stdout, "second-first: %s\n", pc3);

    PidinStackFree(ppist3);

    //- free memory

    PidinStackFree(ppist2);
    PidinStackFree(ppist1);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle aliases query
/// 

extern int QueryHandlerCountAliases
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get total number of created aliases

    int iCreatedAliases = SymbolGetNumberOfAliases();

    //- get number of created aliases by type

    int * piCreatedAliases = SymbolGetArrayOfNumberOfAliases();

    //- give results

    int i;

    fprintf(stdout, "  0\tcreated aliases of type\tthe empty type(0)\n");

    for (i = 1 ; i < piCreatedAliases[0] ; i++)
    {
	fprintf
	    (stdout,
	     "  %i\tcreated aliases of type\t%s(%i)\n",
	     piCreatedAliases[i],
	     SymbolHSLETypeDescribe(i),
	     i);
    }

    fprintf(stdout, "  %i created aliases\n", iCreatedAliases);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Handle allocated symbols query
/// 

extern int QueryHandlerCountAllocatedSymbols
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print total number of allocated symbols

    fprintf(stdout, "  %i total allocated symbols\n", iTotalAllocatedSymbols);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Delete a component
///
/// \details 
/// 
///	delete <symbol>
/// 

extern
int
QueryHandlerDelete
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- lookup child symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleChild
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- lookup parent symbol

    PidinStackPop(ppist);

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleParent
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if both found

    if (phsleParent && phsleChild)
    {
	//- delete child

	if (SymbolDeleteChild(phsleParent, phsleChild))
	{
	    //- recalc serials

	    SymbolRecalcAllSerials(NULL, NULL);
	}
	else
	{
	    fprintf(stdout, "error during deletion\n");
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
/// \brief Echo args to the terminal.
///
/// \details 
/// 
///	echo <something>
/// 

extern
int
QueryHandlerEcho
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- print to terminal

    puts(&pcLine[iLength]);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Expand a wildcard.
///
/// \details 
/// 
///	expand <wildcard>
/// 

static
int
QueryMachineWildcardTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct PidinStack *ppistWildcard
	= (struct PidinStack *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- give diag's

    char pc[1000];

    PidinStackString(ptstr->ppist, pc, 1000);

    fprintf(stdout, "- %s\n", pc);

    //- return result

    return(iResult);
}


extern
int
QueryHandlerExpand
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = 1;

    struct symtab_HSolveListElement *phsle = NULL;

    struct symtab_HSolveListElement *phsleTraversal = NULL;

    struct PidinStack *ppistTraversal = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- check if we can find a selector

    struct symtab_IdentifierIndex *pidin = PidinStackElementPidin(ppist, 0);

    if (!pidin)
    {
	fprintf(stdout, "no symbols selector found\n");

	return(FALSE);
    }
 
    //- if the wildcard is namespaced

    if (PidinStackIsNamespaced(ppist))
    {
	//- find namespace

	struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

	if (!pif)
	{
	    fprintf(stdout, "cannot find namespace\n");

	    return(0);
	}

	struct symtab_RootSymbol *prootNamespace = ImportedFileGetRootSymbol(pif);

	//- set variables for traversal

	phsleTraversal = &prootNamespace->hsle;
	ppistTraversal = PidinStackDuplicate(ppist);

	//- convert full context to one with only namespaces

	if (PidinStackNumberOfEntries(ppistTraversal))
	{
	    struct symtab_IdentifierIndex *pidinTraversal
		= PidinStackTop(ppistTraversal);

	    //- pop all elements that are part of the wildcard

	    while (pidinTraversal && !IdinIsNamespaced(pidinTraversal))
	    {
		PidinStackPop(ppistTraversal);

		pidinTraversal
		    = PidinStackTop(ppistTraversal);
	    }
	}
    }

    //- without namespace

    else
    {
	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    fprintf(stdout, "cannot allocate a context\n");

	    return(0);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	//- set variables for traversal

	phsleTraversal = phsleRoot;
	ppistTraversal = ppistRoot;
    }

    //- if there is a symbol candidate for traversal

    /// \note so phsleRoot can be NULL if the model description file was not found

    if (phsleTraversal)
    {
	//- start yaml output

	fprintf(stdout, "---\n");

	//- traverse symbols that match with wildcard

	int iResult
	    = SymbolTraverseWildcard
	      (phsleTraversal,
	       ppistTraversal,
	       ppist,
	       QueryMachineWildcardTraverser,
	       NULL,
	       NULL);

	if (iResult != 1)
	{
	    fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");
	}
    }
    else
    {
	//- diag's

	fprintf(stdout, "no model loaded\n");
    }

    //- free allocated memory

    PidinStackFree(ppistTraversal);
    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Export a model in one of the available formats.
///
/// \details 
/// 
///	export <flags> <info|ndf|xml> <filename> <wildcard> <symbol>
/// 

extern
int
QueryHandlerExport
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result: ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- get flags

    int iFlags = -1;

    char pcSeparator[] = " \t,;\n";

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "export flags not specified on command line\n");

	return(FALSE);
    }

    char *pcFlags = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    if (strcmp(pcFlags, "all") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL;
    }
    else if (strcmp(pcFlags, "all_library") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_LIBRARY;
    }
    else if (strcmp(pcFlags, "all_library_names") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_LIBRARY | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "all_names") == 0)
    {
	iFlags = EXPORTER_FLAG_ALL | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "library") == 0)
    {
	iFlags = EXPORTER_FLAG_LIBRARY;
    }
    else if (strcmp(pcFlags, "library_names") == 0)
    {
	iFlags = EXPORTER_FLAG_LIBRARY | EXPORTER_FLAG_NAMESPACES;
    }
    else if (strcmp(pcFlags, "names") == 0)
    {
	iFlags = EXPORTER_FLAG_NAMESPACES;
    }
    else
    {
	iFlags = 0;
    }

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "export type not specified on command line\n");

	return(FALSE);
    }

    //- get type

    int iType = -1;

    char *pcType = &pcLine[iLength + 1];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    pcLine[iLength] = '\0';

    iLength++;

    if (strcmp(pcType, "info") == 0)
    {
	iType = EXPORTER_TYPE_INFO;
    }
    else if (strcmp(pcType, "ndf") == 0)
    {
	iType = EXPORTER_TYPE_NDF;
    }
    else if (strcmp(pcType, "xml") == 0)
    {
	iType = EXPORTER_TYPE_XML;
    }
    else
    {
	iType = -1;
    }

    if (iType == -1)
    {
	fprintf(stdout, "export of type %s not supported\n", pcType);

	return(FALSE);
    }

    //- parse filename

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "filename not found on command line\n");

	return(FALSE);
    }

    if (!strpbrk(&pcLine[iLength + 1], pcSeparator))
    {
	fprintf(stdout, "wildcard not found on command line\n");

	return(FALSE);
    }

    char *pcFilename = &pcLine[iLength];

    iLength += strpbrk(&pcLine[iLength + 1], pcSeparator) - &pcLine[iLength];

    if (!pcLine[iLength]
	|| !pcLine[iLength + 1])
    {
	fprintf(stdout, "wildcard not found on command line\n");

	return(FALSE);
    }

    pcLine[iLength] = '\0';

    iLength++;

/*     char *pcNamespace = &pcLine[iLength + 1]; */

/*     if (strpbrk(&pcLine[iLength + 1], pcSeparator)) */
/*     { */
/* 	strpbrk(&pcLine[iLength + 1], pcSeparator)[0] = '\0'; */
/*     } */

    //- parse command line element

    struct PidinStack *ppistWildcard = PidinStackParse(&pcLine[iLength]);

    //- if the wildcard is namespaced

    struct symtab_IdentifierIndex *pidinWildcard = PidinStackElementPidin(ppistWildcard, 0);

    if (!pidinWildcard)
    {
	fprintf(stdout, "no symbols selector found\n");

	return(FALSE);
    }

    if (IdinIsNamespaced(pidinWildcard))
    {
	fprintf(stdout, "wildcard expansion cannot be combined with namespaces.\n");

	return(FALSE);
    }

    int iSuccess = SymbolRecalcAllSerials(NULL, NULL);

    if (!iSuccess)
    {
	fprintf(stdout, "SymbolRecalcAllSerials() failed, output in %s may be incorrect.", pcFilename);

	return(FALSE);
    }

    //- export model

    int iExported = ExporterModel(ppistWildcard, iType, iFlags, pcFilename);

    if (!iExported)
    {
	return(FALSE);
    }

    //- free allocated memory

    PidinStackFree(ppistWildcard);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Insert a new component.
///
/// \details 
/// 
///	insert <source> <target>
/// 

extern
int
QueryHandlerInsert
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- parse command line element

    struct PidinStack *ppistSource = PidinStackParse(&pcLine[iLength]);

    //- get target context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a target\n");

	return(FALSE);
    }

    struct PidinStack *ppistTarget = PidinStackParse(pcBreak);

    //- lookup source symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleSource
	= SymbolsLookupHierarchical(pneuro->psym, ppistSource);

    if (!phsleSource)
    {
	fprintf(stdout, "source symbol not found\n");

	return(FALSE);
    }

    //- register the name of the target

    struct symtab_IdentifierIndex *pidinTarget
	= PidinStackPop(ppistTarget);

    //- lookup target symbol

    struct symtab_HSolveListElement *phsleTarget
	= SymbolsLookupHierarchical(pneuro->psym, ppistTarget);

    if (!phsleTarget)
    {
	fprintf(stdout, "target symbol not found\n");

	return(FALSE);
    }

    //- create an alias of the source

    struct symtab_IdentifierIndex *pidinNew
	= IdinCallocUnique(IdinName(pidinTarget));

    //t have to fill in namespace

    struct symtab_HSolveListElement *phsleAlias
	= SymbolCreateAlias(phsleSource, NULL, pidinNew);

/*     //- disable traversals of the alias */

/*     SymbolSetOptions */
/* 	(phsleAlias, (SymbolGetOptions(phsleAlias) | BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL)); */

    //- link the alias into the symbol table

    int iSuccess1 = SymbolAddChild(phsleTarget, phsleAlias);

    if (!iSuccess1)
    {
	fprintf(stdout, "SymbolAddChild() failed\n");

	return(FALSE);
    }

    int iSuccess2 = SymbolRecalcAllSerials(NULL, NULL);

    if (!iSuccess2)
    {
	fprintf(stdout, "SymbolRecalcAllSerials() failed");

	return(FALSE);
    }

    //- return result

    return(bResult);
}


