//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cerebellum.c 1.19 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithm.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/connection.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/parsersupport.h"


//s event associations for cerebellum algorithm

static ParserEventListener CerebellumParserEventListener;

static ParserEventAssociation pevasCerebellum[] = 
{
    {
	//m listens to any segment event

	EVENT_TYPE_NETWORK,

	//m function to call

	CerebellumParserEventListener,
    },
};


static ParserEventAssociationTable evatCerebellum =
{
    //m number of entries

    sizeof(*pevasCerebellum) / sizeof(ParserEventAssociation),

    //m event associations

    pevasCerebellum,
};


//s algorithm handlers for cerebellum algorithm

static AlgorithmHandler CerebellumInitAlgorithm;

static struct AlgorithmHandlerLibrary pfCerebellumHandlers =
{
    //m after constructor, global is parser context, data is init string

    CerebellumInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    NULL,
};


//s algorithm description

static struct symtab_Algorithm modCerebellum =
{
    //m link

    {
	NULL,
	NULL,
    },

    //m type

    0,

    //m flags

    0,

    //m name

    "CerebellumConnections",

    //m algorithm handlers

    &pfCerebellumHandlers,

    //m event association table

    &evatCerebellum
};

struct symtab_Algorithm *palgCerebellum = &modCerebellum;


//s cerebellum algorithm private data

/*s */
/*s struct with cerebellum options */
/*S */

struct CerebellumOptions_type
{
};

typedef struct CerebellumOptions_type CerebellumOptions;


static CerebellumOptions coCerebellumOptions;


//s
//s cerebellum variables
//s

struct CerebellumVariables_type
{
};

typedef struct CerebellumVariables_type CerebellumVariables;


static CerebellumVariables cvCerebellumVariables;


/// **************************************************************************
///
/// SHORT: CerebellumCheck()
///
/// ARGS.:
///
///	ppist..: context of network
///	pnetw..: network candidate for additional connections
///
/// RTN..: int : success of operation
///
/// DESCR: Check if network needs cerebellum like connections
///
/// **************************************************************************

static int CerebellumCheck
(struct PidinStack *ppist,struct symtab_Network *pnetw)
{
    //- set default result : ok

    int bResult = TRUE;

    // give diag's
    
    //fprintf(stdout,"Adding cerebellum like connections\n");

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: CerebellumParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to attach spines
///
///	For cell type events, a new cell is registered, 
///	For segment type events, spines are attached to the 
///	registered cell.
///
/// **************************************************************************

static int CerebellumParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result : ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- for network

    case EVENT_TYPE_NETWORK:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //t can we ever get here ?

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- check for creation of additional connections

	    if (CerebellumCheck
		(&pev->pist,(struct symtab_Network *)pev->uInfo.phsle)
		== FALSE)
	    {
		bResult = FALSE;
	    }

	    break;
	}
	}

	break;
    }

    //- else

    default:
    {
	//- give diagnostics : not implemented

	fprintf
	    (stderr,
	     "CerebellumParserEventListener : handling of event type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: CerebellumInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init spine algorithm
///
/// **************************************************************************

static int CerebellumInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- set parser context

    PARSERCONTEXT *pacContext = (PARSERCONTEXT *)pvGlobal;

    //- set init string (after '{')

    char *pcInit = &((char *)pvData)[1];

    //v argument seperator

    char pcSeperator[] = " \t,;/}";

    //v next arg

    char *pcArg = NULL;

    //v length of arg

    int iLength = -1;

    //- skip first white space

    pcArg = strpbrk(pcInit,pcSeperator);
    while (pcArg == pcInit)
    {
	pcInit++;
	pcArg = strpbrk(pcInit,pcSeperator);
    }

    //- get length for prototype name

    pcArg = strpbrk(pcInit,pcSeperator);

    iLength = pcArg - pcInit;

    //- scan prototype name

/*
    soCerebellumOptions.pcRandomSpineProto
	= (char *)calloc(iLength + 1,sizeof(char));

    strncpy(soCerebellumOptions.pcRandomSpineProto,pcInit,iLength);

    soCerebellumOptions.pcRandomSpineProto[iLength] = '\0';
*/

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan min dia

    //soCerebellumOptions.fRandomDendrDiaMin = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    //soCerebellumOptions.fRandomDendrDiaMax = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan min dia

    //soCerebellumOptions.fSpineDensity = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    //soCerebellumOptions.fSpineFrequency = strtod(pcInit,&pcArg);

    // go to next arg

    //pcInit = &pcArg[1];

    //- return result

    return(bResult);
}


