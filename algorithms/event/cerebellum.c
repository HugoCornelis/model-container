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


/// \struct event associations for cerebellum algorithm

static ParserEventListener CerebellumParserEventListener;

static ParserEventAssociation pevasCerebellum[] = 
{
    {
	/// listens to any segment event

	EVENT_TYPE_NETWORK,

	/// function to call

	CerebellumParserEventListener,
    },
};


static ParserEventAssociationTable evatCerebellum =
{
    /// number of entries

    sizeof(*pevasCerebellum) / sizeof(ParserEventAssociation),

    /// event associations

    pevasCerebellum,
};


/// \struct algorithm handlers for cerebellum algorithm

static AlgorithmHandler CerebellumInitAlgorithm;

static struct AlgorithmHandlerLibrary pfCerebellumHandlers =
{
    /// after constructor, global is parser context, data is init string

    CerebellumInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    NULL,
};


/// \struct algorithm description

static struct symtab_Algorithm modCerebellum =
{
    /// link

    {
	NULL,
	NULL,
    },

    /// type

    0,

    /// flags

    0,

    /// name

    "CerebellumConnections",

    /// algorithm handlers

    &pfCerebellumHandlers,

    /// event association table

    &evatCerebellum
};

struct symtab_Algorithm *palgCerebellum = &modCerebellum;


/// \struct cerebellum algorithm private data

/*s */
/*s struct with cerebellum options */
/*S */

struct CerebellumOptions_type
{
};

typedef struct CerebellumOptions_type CerebellumOptions;


static CerebellumOptions coCerebellumOptions;


/// \struct
/// \struct cerebellum variables
/// \struct

struct CerebellumVariables_type
{
};

typedef struct CerebellumVariables_type CerebellumVariables;


static CerebellumVariables cvCerebellumVariables;


/// 
/// 
/// \arg ppist context of network
/// \arg pnetw network candidate for additional connections
/// 
/// \return int : success of operation
/// 
/// \brief Check if network needs cerebellum like connections
/// \details 
/// 

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


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int  std ParserEventListener return value
/// 
/// \brief ParserEvent listener to attach spines
/// \details 
/// 
///	For cell type events, a new cell is registered, 
///	For segment type events, spines are attached to the 
///	registered cell.
/// 

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
	    /// \todo can we ever get here ?

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to init spine algorithm
/// \details 
/// 

static int CerebellumInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

    int bResult = TRUE;

    //- set parser context

    PARSERCONTEXT *pacContext = (PARSERCONTEXT *)pvGlobal;

    //- set init string (after '{')

    char *pcInit = &((char *)pvData)[1];

    /// argument seperator

    char pcSeperator[] = " \t,;/}";

    /// next arg

    char *pcArg = NULL;

    /// length of arg

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

    /// \structoCerebellumOptions.fRandomDendrDiaMin = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    /// \structoCerebellumOptions.fRandomDendrDiaMax = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan min dia

    /// \structoCerebellumOptions.fSpineDensity = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    /// \structoCerebellumOptions.fSpineFrequency = strtod(pcInit,&pcArg);

    // go to next arg

    //pcInit = &pcArg[1];

    //- return result

    return(bResult);
}


