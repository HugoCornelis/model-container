//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parcontainer.c 1.14 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include "neurospaces/exporter.h"
#include "neurospaces/parcontainer.h"
#include "neurospaces/symbols.h"


/// 
/// \arg pparc parameter container.
/// \arg ppar new parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign parameters.
/// 

int
ParContainerAssignParameters
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    pparc->ppars = ppar;

    return(TRUE);
};


/// 
/// \return struct symtab_ParContainer * 
/// 
///	Newly allocated parameter container, NULL for failure
/// 
/// \brief Allocate a parameter container
/// 

struct symtab_ParContainer * ParContainerCalloc(void)
{
    //- set default result : failure

    struct symtab_ParContainer *pparcResult = NULL;

    //- allocate parameters

    pparcResult
	= (struct symtab_ParContainer *)
	  calloc(1, sizeof(struct symtab_ParContainer));

    //- initialize parameter container

    ParContainerInit(pparcResult);

    //- return result

    return(pparcResult);
}


/// 
/// \arg pparc parameter container.
/// \arg ppar parameter.
/// 
/// \return int success of operations.
/// 
/// \brief Delete a parameter from its container.
/// 

int
ParContainerDelete
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    //- set default result: success

    int iResult = 1;

    //- if not first in list

    if (ppar->pparPrev)
    {
	//- remove from forward list

	ppar->pparPrev->pparNext = ppar->pparNext;
    }

    //- first in list

    else
    {
	//- set first in list

	pparc->ppars = ppar->pparNext;

	//- loop over all parameters

	struct symtab_Parameters *pparLoop = pparc->ppars;

	while (pparLoop)
	{
	    //- set first in list

	    pparLoop->pparFirst = pparc->ppars;

	    //- next

	    pparLoop = pparLoop->pparNext;
	}
    }

    //- if not last in list

    if (ppar->pparNext)
    {
	//- remove from reverse list

	ppar->pparNext->pparPrev = ppar->pparPrev;
    }

    //- last in list

    else
    {
    }

    //- mark the parameter as deleted

    ppar->pparNext = NULL;
    ppar->pparPrev = NULL;
    ppar->pparFirst = NULL;

    //- return result

    return(iResult);
}


/// 
/// \arg pparc parameter container.
/// \arg ppist context.
/// \arg iIndent start indentation level.
/// \arg pfile file to export to, NULL for stdout.
/// 
/// \return int success of operation.
/// 
/// \brief export all parameters to YAML.
///
/// \todo pfile does not propagate through yet.  What did I mean with
/// propagate again ?
///

int
ParContainerExportYAML
(struct symtab_ParContainer *pparc, struct PidinStack *ppist, int iIndent, FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    //- default output file (should be)

    if (!pfile)
    {
	pfile = stdout;
    }

    //- loop over parameters

    struct symtab_Parameters *pparLoop = pparc->ppars;

    while (pparLoop)
    {
	int iIndent = 0;

	PrintIndent(iIndent, stdout);
	fprintf(stdout, "  -\n");

	//- print parameter info

	// \todo add pfile to arguments.

	if (!ParameterPrintInfoRecursive(pparLoop, ppist, iIndent + 2, pfile))
	{
	    iResult = 0;

	    break;
	}

	//- next parameter

	pparLoop = pparLoop->pparNext;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pparc parameter container.
/// \arg ppist context.
/// \arg iIndent start indentation level.
/// \arg iType type of export (0: NDF, 1: XML).
/// \arg pfile file to export to, NULL for stdout.
/// 
/// \return int success of operation.
/// 
/// \brief export all parameters.
///

int
ParContainerExport
(struct symtab_ParContainer *pparc, struct PidinStack *ppist, int iIndent, int iType, FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    if (!pparc->ppars)
    {
	return(1);
    }

    //- default output file (should be)

    if (!pfile)
    {
	pfile = stdout;
    }

    PrintIndent(iIndent, pfile);

    if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf(pfile, "PARAMETERS\n");
    }
    else
    {
	fprintf(pfile, "<parameters>\n");
    }

    //- loop over parameters

    struct symtab_Parameters *pparLoop = pparc->ppars;

    while (pparLoop)
    {
	//- print parameter info

	if (!ParameterExport(pparLoop, ppist, iIndent + 2, iType, pfile))
	{
	    iResult = 0;

	    break;
	}

	//- next parameter

	pparLoop = pparLoop->pparNext;
    }

    PrintIndent(iIndent, pfile);

    if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf(pfile, "END PARAMETERS\n");
    }
    else
    {
	fprintf(pfile, "</parameters>\n");
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pparc container to init
/// 
/// \return void
/// 
/// \brief Init a parameter container
/// 

void ParContainerInit(struct symtab_ParContainer * pparc)
{
    //- unset pointers

    pparc->ppars = NULL;
}


/// 
/// \arg pparc container
/// \arg ppar parameter to link
/// 
/// \return void
/// 
/// \brief Insert new parameter at head of parameter list
///
/// \details 
/// 
///	This function scales with the size of the parameter list,
///	use it with caution.
/// 

void ParContainerInsert
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    //- lookup old value

    struct symtab_Parameters *pparOld
	= ParameterLookup(pparc->ppars, ParameterGetName(ppar));

    if (pparOld)
    {
	ParContainerDelete(pparc, pparOld);
    }

    //- insert

    ppar->pparNext = pparc->ppars;
    ppar->pparPrev = NULL;
    if (pparc->ppars)
    {
	pparc->ppars->pparPrev = ppar;
    }
    pparc->ppars = ppar;

    //- update ->pparFirst for entire list

    struct symtab_Parameters *pparLoop = pparc->ppars;
    do
    {
	pparLoop->pparFirst = pparc->ppars;
	pparLoop = pparLoop->pparNext;
    }
    while (pparLoop);
}


/// 
/// \arg pparc container
/// \arg ppar parameter list to link
/// 
/// \return void
/// 
/// \brief Link new parameter at end of parameter list
/// 

void
ParContainerLinkAtEnd
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar)
{
    //- if already parameters

    if (pparc->ppars)
    {
	//- modify last parameter to link new one

	struct symtab_Parameters *pparLoop = pparc->ppars;

	while (pparLoop->pparNext)
	{
	    pparLoop = pparLoop->pparNext;
	}
	ppar->pparFirst = pparc->ppars;

	pparLoop->pparNext = ppar;
	ppar->pparPrev = pparLoop;
    }

    //- else

    else
    {
	//- modify parameter container

	ppar->pparFirst = ppar;
	pparc->ppars = ppar;
    }
}


/// 
/// \arg ppars parameter list, NULL terminated.
/// 
/// \return struct symtab_ParContainer parameter container, NULL if
/// failure.
/// 
/// \brief Allocate a parameter container and insert the given
/// parameters.
/// 

struct symtab_ParContainer *
ParContainerNewFromList
(struct symtab_Parameters *ppar, ... )
{
    //- allocate default result: empty container

    struct symtab_ParContainer *pparcResult = NULL;

    //- allocate a container

    pparcResult = ParContainerCalloc();

    //- get start of stdargs

    va_list vaList;

    va_start(vaList, ppar);

    //- loop over parameters

    struct symtab_Parameters *pparLoop = ppar;

    while (pparLoop)
    {
	//- insert parameters

	ParContainerInsert(pparcResult, pparLoop);

	//- next parameter

	pparLoop = va_arg(vaList, struct symtab_Parameters *);
    }

    //- end stdargs

    va_end(vaList);

    //- return result

    return(pparcResult);
}


/// 
/// \arg pparc container
/// 
/// \return int success of operation.
/// 
/// \brief Remove all undefined parameters.
/// 

int
ParContainerReduce(struct symtab_ParContainer *pparc)
{
    //- if there are parameters

    if (pparc->ppars)
    {
	//- loop

	struct symtab_Parameters *pparPrev = NULL;

	struct symtab_Parameters *ppar = pparc->ppars;

	while (ppar)
	{
	    //- if this parameter is numerical

	    if (ParameterIsNumber(ppar))
	    {
		//- if is undefined

		if (ppar->uValue.dNumber == DBL_MAX)
		{
		    //- remove this parameter from the list

		    struct symtab_Parameters *pparNext = ppar->pparNext;

		    ParContainerDelete(pparc, ppar);

		    ppar = pparNext;
		}

		//- parameter is defined

		else
		{
		    //- go to next parameter

		    ppar = ppar->pparNext;
		}
	    }

	    //- not numerical

	    else
	    {
		//- go to next parameter

		ppar = ppar->pparNext;
	    }
	}

	//- now set the first parameter for all

	{
	    struct symtab_Parameters *ppar = pparc->ppars;

	    while (ppar)
	    {
		ppar->pparFirst = pparc->ppars;

		ppar = ppar->pparNext;
	    }
	}
    }

    //- return success

    return(1);
}


