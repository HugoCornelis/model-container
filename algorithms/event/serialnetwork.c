//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialnetwork.c 1.18 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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

#include "neurospaces/cell.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/algorithm.h"
#include "neurospaces/network.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/vector.h"

#include "algorithms/event/serialcell.h"
#include "algorithms/event/serialconnection.h"
#include "algorithms/event/serialnetwork.h"
#include "algorithms/event/serialpopulation.h"
#include "algorithms/event/serialprojection.h"


//s event associations for serial network algorithm

static ParserEventListener SerialNetworkParserEventListener;

static ParserEventAssociation pevasSerialNetwork[] = 
{
    {
	//m listens to any network event

	EVENT_TYPE_NETWORK,

	//m function to call

	SerialNetworkParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialNetwork =
{
    //m number of entries

    sizeof(*pevasSerialNetwork) / sizeof(ParserEventAssociation),

    //m event associations

    pevasSerialNetwork,
};


//s algorithm handlers for serial network algorithm

static AlgorithmHandler SerialNetworkInitAlgorithm;

static AlgorithmHandler SerialNetworkPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialNetworkHandlers =
{
    //m after constructor, global is parser context, data is init string

    SerialNetworkInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    SerialNetworkPrintInfo,
};


//s algorithm description

static struct symtab_Algorithm modSerialNetwork =
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

    "SerialNetwork",

    //m algorithm handlers

    &pfSerialNetworkHandlers,

    //m event association table

    &evatSerialNetwork
};

struct symtab_Algorithm *palgSerialNetwork = &modSerialNetwork;


//d default number of serial networks

#define ENTRIES_SERIAL_NETWORKS		10000


//v serial network array

struct SerialNetworkVariables sernetwVariables;


/// **************************************************************************
///
/// SHORT: SerialNetworkParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to put networks in a serial array
///
/// **************************************************************************

static int SerialNetworkParserEventListener
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
	    //- register cell start for next network

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksCreated].iFirstCell
		= sercellVariables.iCellsAdded;

	    //- register population start for next network

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksCreated].iFirstPopulation
		= serpopuVariables.iPopulationsAdded;

	    //- register connection start for next network

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksCreated].iFirstConnection
		= serconnVariables.iConnectionsAdded;

	    //- register projection start for next network

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksCreated].iFirstProjection
		= serprojVariables.iProjectionsAdded;

	    //- register network symbol

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksCreated].pnetw
		= (struct symtab_Network *)pev->uInfo.phsle;

	    //- increment number of created networks

	    sernetwVariables.iNetworksCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register number of cells

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksAdded].iCells
		= sercellVariables.iCellsCreated
		  - sernetwVariables.psymsernetw
		    [sernetwVariables.iNetworksAdded].iFirstCell;

	    //- register number of populations

	    sernetwVariables.psymsernetw
		[sernetwVariables.iNetworksAdded].iPopulations
		= serpopuVariables.iPopulationsCreated
		  - sernetwVariables.psymsernetw
		    [sernetwVariables.iNetworksAdded].iFirstPopulation;

	    //- register number of connections

	    sernetwVariables.psymsernetw[sernetwVariables.iNetworksAdded].iConnections
		= serconnVariables.iConnectionsCreated
		  - sernetwVariables.psymsernetw
		    [sernetwVariables.iNetworksAdded].iFirstConnection;

	    //- register number of projections

	    sernetwVariables.psymsernetw[sernetwVariables.iNetworksAdded].iProjections
		= serprojVariables.iProjectionsCreated
		  - sernetwVariables.psymsernetw
		    [sernetwVariables.iNetworksAdded].iFirstProjection;

	    //- increment number of added networks

	    sernetwVariables.iNetworksAdded++;

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
	     "SerialNetworkParserEventListener : "
	     "ParserEvent type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialNetworkInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init serial network algorithm
///
/// **************************************************************************

static int SerialNetworkInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize network array

    sernetwVariables.psymsernetw
	= (struct SymbolSerialNetwork *)
	  calloc
	  (ENTRIES_SERIAL_NETWORKS,sizeof(struct SymbolSerialNetwork));

    if (!sernetwVariables.psymsernetw)
    {
	return(FALSE);
    }

    //- initialize number of networks

    sernetwVariables.iNetworksCreated = 0;
    sernetwVariables.iNetworksAdded = 0;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialNetworkPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on serial network algorithm
///
/// **************************************************************************

static int SerialNetworkPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //v loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerNetwAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added networks : %i/%i\n",
	 sernetwVariables.iNetworksCreated,
	 sernetwVariables.iNetworksAdded);

    //- loop over network array

    for (i = 0; i < sernetwVariables.iNetworksAdded; i++)
    {
	//- print network info

	fprintf
	    (pfile,
	     "%i\tNetwork (%s,%i), \n"
	     "\tcells (%i,%i), populations (%i,%i), \n"
	     "\tconnections (%i,%i), projections (%i,%i)\n",
	     i,
	     NetworkName(sernetwVariables.psymsernetw[i].pnetw),
	     NetworkIndex(sernetwVariables.psymsernetw[i].pnetw),
	     sernetwVariables.psymsernetw[i].iFirstCell,
	     sernetwVariables.psymsernetw[i].iCells,
	     sernetwVariables.psymsernetw[i].iFirstPopulation,
	     sernetwVariables.psymsernetw[i].iPopulations,
	     sernetwVariables.psymsernetw[i].iFirstConnection,
	     sernetwVariables.psymsernetw[i].iConnections,
	     sernetwVariables.psymsernetw[i].iFirstProjection,
	     sernetwVariables.psymsernetw[i].iProjections);
    }

    //- return result

    return(bResult);
}


