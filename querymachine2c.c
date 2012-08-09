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


