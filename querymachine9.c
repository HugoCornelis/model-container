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
/// \brief Report biocomp serial ID.
///
/// \details 
/// 
///	serialID <context> <child-context>
/// 

extern int QueryHandlerSerialID
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get child context

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify two symbols\n");

	return(FALSE);
    }

    struct PidinStack *ppistSearched = PidinStackParse(pcBreak);

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

	    fprintf
		(stdout,
		 "Get neurospaces C implementation prior to -r 405 to see"
		 " what happens here.\n");
	    fprintf
		(stdout,
		 "\tThat version has connections with hardcoded serial IDs"
		 " per connection.\n");
	}

	//- if instance of biocomponent

	else if (instanceof_bio_comp(phsle))
	{
	    int i;

	    //- lookup serial ID

	    int iSerialID 
		= BioComponentLookupSerialID
		  ((struct symtab_BioComponent *)phsle,
		   ppist,
		   NULL,
		   ppistSearched);

	    //- diag's

	    fprintf(stdout, "serial ID = %i\n",iSerialID);
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

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Output forestspace structure to a file.
///
/// \details 
/// 
///	serializeforestspace <type=a|x> <context> <filename>
/// 

struct QM_fs_traversal_data
{
    /// file to write to

    FILE *pfile;

    /// type of output

    char *pcType;

    /// symbol last visited

    char *pcLast;
};


/* static int  */
/* QueryMachineForestspaceSelector */
/* (struct TreespaceTraversal *ptstr, void *pvUserdata) */
/* { */
/*     //- set default result : process children of this symbol */

/*     int iResult = TSTR_SELECTOR_PROCESS_CHILDREN; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr); */

/* /*     //- if tagged * */

/* /*     if (SymbolGetFlags(phsle) & FLAGS_HSLE_TRAVERSAL != 0) * */
/* /*     { * */
/* /* 	//- do not process, continue with siblings * */

/* /* //	iResult = SYMBOL_SELECTOR_PROCESS_SIBLING; * */
/* /*     } * */

/*     //- return result */

/*     return(iResult); */
/* } */


static void
QueryMachineForestspaceEdgeSerializer
(struct symtab_HSolveListElement *phsleParent,
 struct symtab_HSolveListElement *phsle,
 struct QM_fs_traversal_data *pfsd)
{
    //- write info on symbol

    switch (pfsd->pcType[0])
    {
    case 'x':
    {
	fprintf(pfsd->pfile, "  edge:  {");
	fprintf(pfsd->pfile, "    sourcename: \"%p\"", phsleParent);
	fprintf(pfsd->pfile, "    targetname: \"%p\"", phsle);
	fprintf(pfsd->pfile, "    color: black }\n");
	break;
    }
    case 'a':
    {
	fprintf(pfsd->pfile, "  edge:  {");
	fprintf(pfsd->pfile, "    sourcename: \"%p\"", phsleParent);
	fprintf(pfsd->pfile, "    targetname: \"%p\"", phsle);
	fprintf(pfsd->pfile, "    color: black }\n");
	break;
    }
    }
}


static void
QueryMachineForestspaceNodeSerializer
(struct symtab_HSolveListElement *phsle,
 struct QM_fs_traversal_data *pfsd)
{
    //- write info on symbol

    switch (pfsd->pcType[0])
    {
    case 'x':
    {
	fprintf(pfsd->pfile, "  node:\n  {\n");
	fprintf(pfsd->pfile, "    title: \"%p\"\n", phsle);
	fprintf
	    (pfsd->pfile,
	     "    label: \"%s\"\n",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );
	fprintf
	    (pfsd->pfile,
	     "    info1: \"%s\"\n",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );

	fprintf(pfsd->pfile, "  }\n");
	break;
    }
    case 'a':
    {
	fprintf(pfsd->pfile, "  node:  {");
	fprintf(pfsd->pfile, "    title: \"%p\"", phsle);
	fprintf
	    (pfsd->pfile,
	     "    label: \"%s\"",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );
	fprintf
	    (pfsd->pfile,
	     "    info1: \"%s\"",
	     SymbolName(phsle) ? SymbolName(phsle) : "Unlabeled" );

	fprintf(pfsd->pfile, "  }\n");
	break;
    }
    }
}


static int 
QueryMachineForestspaceSerializer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct QM_fs_traversal_data *pfsd
	= (struct QM_fs_traversal_data *)pvUserdata;

    //- get actual symbol type

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- if not a connection

    if (!subsetof_connection_symbol(iType)
	&& !subsetof_connection(iType)
	&& !subsetof_v_connection_symbol(iType)
	&& !subsetof_projection(iType))
    {
	//- get parent symbol

	struct symtab_HSolveListElement *phsleParent
	    = TstrGetActualParent(ptstr);

	//- write info on symbol

	QueryMachineForestspaceNodeSerializer(phsle, pfsd);

	//- write info on to parent edge

	QueryMachineForestspaceEdgeSerializer(phsleParent, phsle, pfsd);
    }

    //- return result

    return(iResult);
}


extern int QueryHandlerSerializeForestspace
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    char * pcArg = NULL;
    char * pcType = NULL;
    char * pcFilename = NULL;

    //- get type of output

    /// \note will core for invalid command lines

    pcArg = strpbrk(&pcLine[iLength + 1], " \t");

    pcType = &pcArg[1];

    iLength += strpbrk(&pcLine[iLength + 1], " \t") - &pcLine[iLength];

    //- get filename

    pcArg = strpbrk(&pcLine[iLength + 1], " \t");

    pcFilename = &pcArg[1];

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
/* 	//- if instance of biocomponent */

/* 	if (InstanceOfBioComponent(phsle)) */
	{
	    struct QM_fs_traversal_data fsd =
		{
		    /// file to write to

		    NULL,

		    /// type of output

		    NULL,

		    /// symbol last visited

		    NULL,

		};

	    struct TreespaceTraversal *ptstr = NULL;
	    int iTraverse = -1;

	    //- open output file

	    fsd.pfile = fopen(pcFilename, "w");
	    fsd.pcType = pcType;

	    //- output header

	    switch (fsd.pcType[0])
	    {
	    case 'a':
	    {
		break;
	    }
	    case 'x':
	    {
		fprintf(fsd.pfile, "graph:\n{\n");
		fprintf(fsd.pfile, "  title: \"forestspace\"\n");
		fprintf(fsd.pfile, "  port_sharing: no\n");
		fprintf(fsd.pfile, "  layoutalgorithm: minbackward\n");
		fprintf(fsd.pfile, "  layout_downfactor: 39\n");
		fprintf(fsd.pfile, "  layout_upfactor: 0\n");
		fprintf(fsd.pfile, "  layout_nearfactor: 0\n");
		fprintf(fsd.pfile, "  nearedges: no\n");
		fprintf(fsd.pfile, "  splines: yes\n");
		fprintf(fsd.pfile, "  straight_phase: yes\n");
		fprintf(fsd.pfile, "  priority_phase: yes\n");
		fprintf(fsd.pfile, "  cmin: 10\n");
		break;
	    }
	    default:
		fprintf(stdout, "serializeforestspace:\n");
		fprintf
		    (stdout, " unrecognized output type (%c)\n",fsd.pcType[0]);
		break;
	    }

	    //- write info on first symbol

	    QueryMachineForestspaceNodeSerializer(phsle,&fsd);

	    //- init treespace traversal

	    ptstr
		= TstrNew
		  (ppist,
		   NULL,
		   NULL,
		   QueryMachineForestspaceSerializer,
		   (void *)&fsd,
		   NULL,
		   NULL);

	    //- traverse segment symbol

	    iTraverse = TstrGo(ptstr, phsle);

	    //- delete treespace traversal

	    TstrDelete(ptstr);

	    //- write tail of file

	    switch (fsd.pcType[0])
	    {
	    case 'x':
	    {
		fprintf(fsd.pfile, "\n}\n");
		break;
	    }
	    }

	    //- close output file

	    fclose(fsd.pfile);
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
/// \brief Get serial mappings for a symbol relative to another symbol.
///
/// \details 
/// 
///	serialMapping <context> <child-context>
/// 

extern int QueryHandlerSerialMapping
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get child context

    /// \note will core for invalid command lines

    char * pcSearched = strpbrk(&pcLine[iLength + 1], " \t");

    struct PidinStack *ppistSearched = NULL;

    if (pcSearched)
    {
	ppistSearched = PidinStackParse(pcSearched);
    }
    else
    {
	ppistSearched = ppist;
	ppist = PidinStackCalloc();
    }

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    /// \note note : can be lookup for root, so PidinStackLookupTopSymbol()
    /// \note does not work, should be fixed ?

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
/* 	//- if instance of biocomponent */

/* 	if (InstanceOfBioComponent(phsle)) */
	{
	    struct PidinStack pistDuplicate
		= *ppistSearched;

	    struct symtab_HSolveListElement *phsleDuplicate = phsle;

	    int i;

	    int iPrincipalSerial = -1;
	    int iPrincipalSuccessors = -1;
	    int iMechanismSerial = -1;
	    int iMechanismSuccessors = -1;
	    int iSegmentSerial = -1;
	    int iSegmentSuccessors = -1;

	    //- lookup serial ID

	    int iSerialID 
		= BioComponentLookupSerialID
		  ((struct symtab_BioComponent *)phsle,
		   ppist,
		   NULL,
		   ppistSearched);

	    //- look up all intermediate symbols

	    *ppistSearched = pistDuplicate;

	    phsle = PidinStackLookupTopSymbol(ppistSearched);

	    if (phsle)
	    {
		//- go through all found symbols

		iPrincipalSerial = 0;

		/// \note note additional protection on NULL phsle necessary
		/// \note for case that namespace operators are being used.

		while (phsle && phsle != phsleDuplicate)
		{
		    //- get principal serial from intermediate symbol

		    iPrincipalSerial += SymbolGetPrincipalSerialToParent(phsle);

		    //- get next symbol

		    if (PidinStackPop(ppistSearched) == NULL)
		    {
			//- if none, set error condition

			phsle = NULL;

			phsleDuplicate = NULL;

			break;
		    }

		    phsle = PidinStackLookupTopSymbol(ppistSearched);
		}

		if (phsleDuplicate)
		{
		    //- get principal successors

		    iPrincipalSuccessors
			= SymbolGetPrincipalNumOfSuccessors(phsleDuplicate);

#ifdef TREESPACES_SUBSET_MECHANISM
		    //- look up all intermediate symbols

		    *ppistSearched = pistDuplicate;

		    phsle = PidinStackLookupTopSymbol(ppistSearched);

		    //- go through all found symbols

		    iMechanismSerial = 0;

		    /// \note note additional protection on NULL phsle necessary
		    /// \note for case that namespace operators are being used.

		    while (phsle && phsle != phsleDuplicate)
		    {
			//- get mechanism serial from intermediate symbol

			iMechanismSerial += SymbolGetMechanismSerialToParent(phsle);

			//- get next symbol

			(void)PidinStackPop(ppistSearched);

			phsle = PidinStackLookupTopSymbol(ppistSearched);
		    }

		    //- get mechanism successors

		    iMechanismSuccessors
			= SymbolGetMechanismNumOfSuccessors(phsleDuplicate);
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
		    //- look up all intermediate symbols

		    *ppistSearched = pistDuplicate;

		    phsle = PidinStackLookupTopSymbol(ppistSearched);

		    //- go through all found symbols

		    iSegmentSerial = 0;

		    /// \note note additional protection on NULL phsle necessary
		    /// \note for case that namespace operators are being used.

		    while (phsle && phsle != phsleDuplicate)
		    {
			//- get segment serial from intermediate symbol

			iSegmentSerial += SymbolGetSegmentSerialToParent(phsle);

			//- get next symbol

			(void)PidinStackPop(ppistSearched);

			phsle = PidinStackLookupTopSymbol(ppistSearched);
		    }

		    //- get segment successors

		    iSegmentSuccessors
			= SymbolGetSegmentNumOfSuccessors(phsleDuplicate);
#endif
		}

		if (phsleDuplicate)
		{
		    //- diag's

		    fprintf(stdout, "Traversal serial ID = %i\n",iSerialID);
		    fprintf(stdout, "Principal serial ID = %i",iPrincipalSerial);
		    fprintf(stdout, " of %i Principal successors\n",iPrincipalSuccessors);
#ifdef TREESPACES_SUBSET_MECHANISM
		    fprintf(stdout, "Mechanism serial ID = %i",iMechanismSerial);
		    fprintf(stdout, " of %i Mechanism successors\n",iMechanismSuccessors);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
		    fprintf(stdout, "Segment  serial  ID = %i",iSegmentSerial);
		    fprintf(stdout, " of %i  Segment  successors\n",iSegmentSuccessors);
#endif
		}
		else
		{
		    fprintf(stdout, "symbol is not an ancestor\n");
		}
	    }
	    else
	    {
		fprintf(stdout, "symbol not found\n");
	    }
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
/// \brief Print context of serial relative to another context.
///
/// \details 
/// 
///	serial2context <path> <serial>
/// 

extern int QueryHandlerSerialToContext
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get serial ID to lookup

    char *pcBreak = strpbrk(&pcLine[iLength + 1], " \t");

    if (!pcBreak)
    {
	fprintf(stdout, "please specify a serial\n");

	return(FALSE);
    }

    int iSerial = strtol(pcBreak,&pcLine, 0);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    phsle = SymbolsLookupHierarchical(NULL, ppist);

    //- if found

    if (phsle)
    {
	//- get context

	struct PidinStack *ppistSerial
	    = SymbolPrincipalSerial2Context(phsle, ppist, iSerial);

	//- if found

	if (ppistSerial)
	{
	    //- diag's

	    fprintf(stdout, "serial id ");

	    PidinStackPrint(ppist, stdout);

	    fprintf(stdout, ",%i -> ", iSerial);

	    PidinStackPrint(ppistSerial, stdout);

	    fprintf(stdout, "\n");

	    PidinStackFree(ppistSerial);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "serial not found\n");
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
/// \brief Set the value of a parameter.
///
/// \details 
/// 
///	setparameter <parameter-base> <parameter-context> <parameter-name> <parameter-type> <parameter-value>
/// 

extern int QueryHandlerSetParameter
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppistBase = PidinStackParse(pcArg);

    //- get parameter context

    /// \note will core for invalid command lines

    pcArg = strpbrk(pcArg, pcSeparator);

    struct PidinStack *ppistParameter = PidinStackParse(pcArg);

    //- lookup base symbol

/*     /// \note allows namespacing, yet incompatible with parameter caches. */

/*     struct symtab_HSolveListElement *phsleBase */
/* 	= SymbolsLookupHierarchical(pneuro->psym, ppistBase); */

    struct symtab_HSolveListElement *phsleBase
	= PidinStackLookupTopSymbol(ppistBase);

    if (!phsleBase)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    int iBase = PidinStackToSerial(ppistBase);

    //- lookup parameter context symbol

    struct symtab_HSolveListElement *phsleParameter
	= SymbolLookupHierarchical(phsleBase, ppistParameter, 0, 1);

    if (phsleBase && phsleParameter)
    {
	struct symtab_Parameters *ppar = NULL;

	//- get serial of parameter symbol

	int iSerialBase = PidinStackToSerial(ppistBase);

	struct PidinStack *ppistAbsoluteParameter
	    = PidinStackDuplicate(ppistBase);

	PidinStackAppendCompact(ppistAbsoluteParameter, ppistParameter);

	if (phsleParameter != PidinStackLookupTopSymbol(ppistAbsoluteParameter))
	{
	    fprintf(stdout, "internal error: parameter symbol changed location\n");
	}

	int iSerialAbsolutParameter
	    = PidinStackToSerial(ppistAbsoluteParameter);

	int iParameterSymbol = iSerialAbsolutParameter - iSerialBase;

	if (iParameterSymbol == INT_MAX
	    || iSerialAbsolutParameter == INT_MAX
	    || iSerialBase == INT_MAX)
	{
	    fprintf(stdout, "internal error: cannot compute index of parameter symbol\n");

	    iParameterSymbol = INT_MAX;
	}

	//- get parameter name

	pcArg = &pcArg[1];

	pcArg = strpbrk(pcArg, pcSeparator);

	char *pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	char pcName[1000];

	strncpy(pcName, pcInit, pcArg - pcInit);

	pcName[pcArg - pcInit] = '\0';

	//- get parameter type

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    PidinStackFree(ppistAbsoluteParameter);
	    PidinStackFree(ppistBase);
	    PidinStackFree(ppistParameter);

	    fprintf(stdout, "error in command line processing, cannot determine parameeter type\n");

	    return(FALSE);
	}

	char pcType[1000];

	strncpy(pcType, pcInit, pcArg - pcInit);

	pcType[pcArg - pcInit] = '\0';

	//- get parameter value

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	char pcValue[1000];

	if (pcArg)
	{
	    strncpy(pcValue, pcInit, MIN(pcArg - pcInit, 999));

	    pcValue[MIN(pcArg - pcInit, 999)] = '\0';
	}
	else
	{
	    strncpy(pcValue, pcInit, 999);
	}

	if (iParameterSymbol == INT_MAX)
	{
	}

	//- for a number

	else if (strcmp("number", pcType) == 0)
	{
	    //- convert value to double

	    double dValue = atof(pcValue);

	    //- set parameter value

	    // if the base symbol is at the root of the hierarchy, we
	    // set the parameter relative to the root so that it
	    // becomes absolute, otherwise we set it as a relative
	    // parameter.

/* 	    printf("iBase = %i\n", iBase); */

/* 	    printf("iParameterSymbol = %i\n", iParameterSymbol); */

	    if (iBase == 1)
	    {
		ppar = SymbolSetParameterFixedDouble(phsleParameter, ppistAbsoluteParameter, pcName, dValue);
	    }
	    else
	    {
		ppar = SymbolCacheParameterDouble(phsleBase, iParameterSymbol, pcName, dValue);
	    }
	}

	//- for a string

	else if (strcmp("string", pcType) == 0)
	{
	    //- copy string

	    char *pc = strdup(pcValue);

	    //- set parameter value

	    if (iBase == 1)
	    {
		ppar = SymbolSetParameterFixedString(phsleParameter, ppistAbsoluteParameter, pcName, pc);
	    }
	    else
	    {
		ppar = SymbolCacheParameterString(phsleBase, iParameterSymbol, pcName, pc);
	    }
	}

	//- else for a symbolic reference

	else if (strcmp("symbolic", pcType) == 0)
	{
	    /// \todo convert to list of pidins

	    /// \todo use list of pidins to store the parameter

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	//- else for a function

	else if (strcmp("function", pcType) == 0)
	{
	    /// \todo do some additional parsing

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	else
	{
	    fprintf(stdout, "unsupported parameter type %s\n", pcType);
	}

	if (!ppar)
	{
	    fprintf
		(stdout,
		 "could not set parameter %s with type %s to %s\n",
		 pcName,
		 pcType,
		 pcValue);
	}

	//- free stacks

	PidinStackFree(ppistAbsoluteParameter);
    }
    else
    {
	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistBase);
    PidinStackFree(ppistParameter);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Set the value of a parameter.
///
/// \details 
/// 
///	setparameterconcept <namespaced-symbol> <parameter-name> <parameter-type> <parameter-value>
/// 

extern int QueryHandlerSetParameterConcept
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppistBase = PidinStackParse(pcArg);

    //- lookup base symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsleBase
	= SymbolsLookupHierarchical(pneuro->psym, ppistBase);

    if (!phsleBase)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    if (phsleBase)
    {
	struct symtab_Parameters *ppar = NULL;

	//- get parameter name

	pcArg = &pcArg[1];

	pcArg = strpbrk(pcArg, pcSeparator);

	char *pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    fprintf(stdout, "parameter-type not found (must be 'number')\n");

	    return(FALSE);
	}

	char pcName2[1000];

	strncpy(pcName2, pcInit, pcArg - pcInit);

	pcName2[pcArg - pcInit] = '\0';

	char *pcName = strdup(pcName2);

	//- get parameter type

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	if (!pcArg)
	{
	    fprintf(stdout, "value not found (must be a number)\n");

	    return(FALSE);
	}

	char pcType[1000];

	strncpy(pcType, pcInit, pcArg - pcInit);

	pcType[pcArg - pcInit] = '\0';

	//- get parameter value

	pcInit = &pcArg[1];

	/// \note will core for invalid command lines

	pcArg = strpbrk(pcInit, pcSeparator);

	/// \note pcArg can be NULL

	char pcValue[1000];

	if (pcArg)
	{
	    strncpy(pcValue, pcInit, MIN(pcArg - pcInit, 999));

	    pcValue[MIN(pcArg - pcInit, 999)] = '\0';
	}
	else
	{
	    strncpy(pcValue, pcInit, strlen(pcInit));

	    pcValue[strlen(pcInit)] = '\0';
	}

	//- for a number

	if (strcmp("number", pcType) == 0)
	{
	    //- convert value to double

	    double dValue = atof(pcValue);

	    //- set parameter value

	    ppar = SymbolSetParameterDouble(phsleBase, pcName, dValue);
	}

	//- else for a symbolic reference

	else if (strcmp("string", pcType) == 0)
	{
	    //- parse the reference

	    //! strdup() makes this useful from a scripting language.

	    char *pc = strdup(pcValue);

	    //- set parameter value

	    ppar = SymbolSetParameterString(phsleBase, pcName, pc);
	}

	//- else for a symbolic reference

	else if (strcmp("symbolic", pcType) == 0)
	{
	    //- parse the reference

	    //! strdup() makes this useful from a scripting language.

	    struct PidinStack *ppistValue
		= PidinStackParse(strdup(pcValue));

	    //- set parameter value

	    ppar = SymbolSetParameterContext(phsleBase, pcName, ppistValue);
	}

	//- else for a function

	else if (strcmp("function", pcType) == 0)
	{
	    /// \todo do some additional parsing

	    fprintf(stdout, "parameter type %s not supported yet\n", pcType);
	}

	else
	{
	    fprintf(stdout, "unsupported parameter type %s\n", pcType);
	}

	if (!ppar)
	{
	    fprintf
		(stdout,
		 "could not set parameter %s with type %s to %s\n",
		 pcName,
		 pcType,
		 pcValue);
	}
    }
    else
    {
	fprintf(stdout, "symbol not found\n");
    }

    //- free stacks

    PidinStackFree(ppistBase);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print solver registration for a context.
///
/// \details 
/// 
///	solverget <solved-context>
/// 

extern int QueryHandlerShowParameters
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    /// argument separator

    char pcSeparator[] = " \t,;\n";

    //- get base context

    char *pcArg = &pcLine[iLength + 1];

    struct PidinStack *ppist = PidinStackParse(pcArg);

    char pcContext[1000];

    PidinStackString(ppist, pcContext, 1000);

    //- lookup symbol

    /// \note allows namespacing, yet incompatible with parameter caches.

    struct symtab_HSolveListElement *phsle
	= SymbolsLookupHierarchical(pneuro->psym, ppist);

    if (!phsle)
    {
	fprintf(stdout, "symbol not found\n");

	return(FALSE);
    }

    if (phsle)
    {
	fprintf(stdout, "---\nshow_parameters:\n");

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
		//- get parameter name

		char *pc = ParameterGetName(ppar);

		//- print parameter info

		fprintf(stdout, "  - component_name: %s\n", pcContext);
		fprintf(stdout, "    field: %s\n", ParameterGetName(ppar));
		fprintf(stdout, "    value: %s\n", ParameterGetString(ppar));

		//- go to next parameter

		ppar = ParContainerNextParameter(ppar);
	    }

	    //- go to next prototype

	    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	}
    }
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Print solver registration for a context.
///
/// \details 
/// 
///	solverget <solved-context>
/// 

extern int QueryHandlerSolverGet
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- get symbol context

    struct PidinStack *ppist = PidinStackParse(&pcLine[iLength]);

    //- get solver registration

    struct SolverInfo *psi = SolverRegistryGet(pneuro->psr, ppist);

    //- if found

    if (psi)
    {
	//- get solver

	char *pcSolver = SolverInfoGetSolverString(psi);

	if (pcSolver)
	{
	    //- diag's

	    fprintf(stdout, "%s\n", pcSolver);
	}
	else
	{
	    //- diag's

	    fprintf(stdout, "No solver\n");
	}
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "solver info not found\n");
    }

    //- free stacks

    PidinStackFree(ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value.
/// 
/// \brief Print all solver registrations.
/// 

extern int QueryHandlerSolverRegistrations
(char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData)
{
    //- set result : ok

    int bResult = TRUE;

    //- give some info about all solver info registrations

    bResult = SolverRegistryEnumerate(pneuro->psr);

    //- return result

    return(bResult);
}


/// 
/// \arg std. QueryHandler args
/// 
/// \return int : QueryHandler return value
/// 
/// \brief Add solver registration
///
/// \details 
/// 
///	solverset <symbol-path> <solver-path>
/// 

extern int QueryHandlerSolverSet
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
	//- if not projection

	if (!instanceof_projection(phsle))
	{
	    //- get solver name

	    char *pcSolver = strpbrk(&pcLine[iLength + 1], " \t");

	    //- remove blank

	    pcSolver = &pcSolver[1];

	    //- set solver

	    SolverRegistryAddFromContext(pneuro->psr, NULL, ppist, pcSolver);
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol must not be projection\n");
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


