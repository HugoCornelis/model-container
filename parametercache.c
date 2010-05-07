//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parametercache.c 1.6 Fri, 29 Jun 2007 22:21:27 -0500 hugo $
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



#include <stdlib.h>
#include <string.h>

#include "neurospaces/cachedparameter.h"
#include "neurospaces/exporter.h"
#include "neurospaces/parametercache.h"
#include "neurospaces/parameters.h"


/// 
/// \arg pparcac parameter cache.
/// \arg iSerial context of parameter value.
/// \arg ppar parameter to cache.
/// 
/// \return struct CachedParameter *
/// 
///	Newly added cached parameter, NULL for failure.
/// 
/// \brief Add a parameter to the cache.
/// 

struct CachedParameter *
ParameterCacheAdd
(struct ParameterCache *pparcac, int iSerial, struct symtab_Parameters *ppar)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    pcacparResult = CachedParameterNewFromParameter(iSerial, ppar);

    if (!pcacparResult)
    {
	return(NULL);
    }

    //- insert the parameter in the cache

    ParameterCacheInsert(pparcac, pcacparResult);

    //- return result

    return(pcacparResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg dNumber parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	Newly added cached parameter, NULL for failure.
/// 
/// \brief Add a parameter to the cache.
/// 

struct CachedParameter *
ParameterCacheAddDouble
(struct ParameterCache *pparcac, int iSerial, char *pcName, double dNumber)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    pcacparResult = CachedParameterNewFromNumber(iSerial, pcName, dNumber);

    if (!pcacparResult)
    {
	return(NULL);
    }

    //- insert the parameter in the cache

    ParameterCacheInsert(pparcac, pcacparResult);

    //- return result

    return(pcacparResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg iSerial context of parameter value.
/// \arg pcName name of parameter value.
/// \arg pcValue parameter value.
/// 
/// \return struct CachedParameter *
/// 
///	Newly added cached parameter, NULL for failure.
/// 
/// \brief Add a parameter to the cache.
/// 

struct CachedParameter *
ParameterCacheAddString
(struct ParameterCache *pparcac, int iSerial, char *pcName, char *pcValue)
{
    //- set default result : failure

    struct CachedParameter * pcacparResult = NULL;

    //- allocate parameter for double

    pcacparResult = CachedParameterNewFromString(iSerial, pcName, pcValue);

    if (!pcacparResult)
    {
	return(NULL);
    }

    //- insert the parameter in the cache

    ParameterCacheInsert(pparcac, pcacparResult);

    //- return result

    return(pcacparResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg ppist context.
/// \arg iIndent start indentation level.
/// \arg iType type of export (0: NDF, 1: XML).
/// \arg pfile file to export to, NULL for stdout.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Export a parameter cache to a file.
/// 

int
ParameterCacheExport
(struct ParameterCache *pparcac, struct PidinStack *ppist, int iIndent, int iType, FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(ppist);

    if (!phsle)
    {
	return(0);
    }

    //- export header

    PrintIndent(iIndent, pfile);

    if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf(pfile, "FORWARDPARAMETERS\n");
    }
    else
    {
	fprintf(pfile, "<forwardparameters>\n");
    }

    //- loop over parameters in the cache

    int i = 0;

    struct symtab_Parameters *ppar = &pparcac->pcacpar->par;

    while (ppar)
    {
	//- convert serial to context

	int iSerial = ppar->iFlags;

	struct PidinStack *ppistRelative = PidinStackParse("");

	// ppistRelative creates relative references, ppist absolute ones.

	struct PidinStack *ppistSerial
	    = SymbolPrincipalSerial2Context(phsle, ppist/* Relative */, iSerial);

	char pcSerial[1000];

	PidinStackString(ppistSerial, pcSerial, 1000);

	char pcField[1000];

	sprintf(pcField, "%s->%s", pcSerial, ppar->pcIdentifier);

	//- fill in reference parameter structure

	static struct symtab_Parameters parReference =
	    {
		/// link structures into list

		NULL,

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		-1,

		/// flags

		0,

		/// name of parameter

		"NAME_1",

		/// value : number, identifier or function for parameter

		{
		    0.0,
		},
	    };

	char pcName[100];

	sprintf(pcName, "NAME_%i", i);

	parReference.pcIdentifier = pcName;

	parReference.iType = TYPE_PARA_STRING;

	parReference.uValue.pcString = pcField;

	//- print parameter info

	if (!ParameterExport(&parReference, ppist, iIndent + 2, iType, pfile))
	{
	    iResult = 0;

	    break;
	}

	//- fill in value parameter structure

	static struct symtab_Parameters parValue =
	    {
		/// link structures into list

		NULL,

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		TYPE_PARA_NUMBER,

		/// flags

		0,

		/// name of parameter

		"VALUE_1",

		/// value : number, identifier or function for parameter

		{
		    0.0,
		},
	    };

	char pcValue[100];

	sprintf(pcValue, "VALUE_%i", i);

	parValue.pcIdentifier = pcValue;

	parValue.iType = ppar->iType;

	parValue.uValue = ppar->uValue;

	//- print parameter info

	if (!ParameterExport(&parValue, ppist, iIndent + 2, iType, pfile))
	{
	    iResult = 0;

	    break;
	}

	PidinStackFree(ppistSerial);

	PidinStackFree(ppistRelative);

	//- go to next parameter

	i++;

	ppar = ppar->pparNext;
    }

    //- export trailer

    PrintIndent(iIndent, pfile);

    if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf(pfile, "END FORWARDPARAMETERS\n");
    }
    else
    {
	fprintf(pfile, "</forwardparameters>\n");
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pparcac parameter cache.
/// \arg ppar parameter to be cached.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Insert a parameter in the cache.
/// 

int
ParameterCacheInsert
(struct ParameterCache *pparcac, struct CachedParameter *pcacpar)
{
    //- set default result : failure

    int iResult = FALSE;

    //- get first and last cached parameter in the given list

    struct CachedParameter *pcacparFirst = pcacpar;

    struct CachedParameter *pcacparLast = pcacpar;

    while (pcacparLast->par.pparNext)
    {
	pcacparLast = (struct CachedParameter *)pcacparLast->par.pparNext;
    }

    //- insert the new parameter list in the existing list

    pcacparLast->par.pparNext = &pparcac->pcacpar->par;

    pparcac->pcacpar = pcacparFirst;

    //- increment number of parameters in the cache

    pparcac->iParameters++;

    //- return result

    return(iResult);
}


/// 
/// \return struct ParameterCache * 
/// 
///	New parameter cache, NULL for failure.
/// 
/// \brief Initialize new parameter cache.
/// 

struct ParameterCache * ParameterCacheNew(void)
{
    //- set default result : failure

    struct ParameterCache *pccResult = NULL;

    //- allocate parameter cache

    pccResult = (struct ParameterCache *)calloc(1,sizeof(struct ParameterCache));

    //- init

    pccResult->iParameters = 0;

    pccResult->pcacpar = NULL;

    //- set used memory

    pccResult->iMemoryUsed = sizeof(struct ParameterCache);

    //- return result

    return(pccResult);
}


