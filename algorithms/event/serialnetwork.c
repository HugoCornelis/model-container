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

#include "neurospaces/algorithm.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/parsersupport.h"

#include "algorithms/event/serialcell.h"
#include "algorithms/event/serialconnection.h"
#include "algorithms/event/serialnetwork.h"
#include "algorithms/event/serialpopulation.h"
#include "algorithms/event/serialprojection.h"


/// \struct event associations for serial network algorithm

static ParserEventListener SerialNetworkParserEventListener;

static ParserEventAssociation pevasSerialNetwork[] = 
{
    {
	/// listens to any network event

	EVENT_TYPE_NETWORK,

	/// function to call

	SerialNetworkParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialNetwork =
{
    /// number of entries

    sizeof(*pevasSerialNetwork) / sizeof(ParserEventAssociation),

    /// event associations

    pevasSerialNetwork,
};


/// \struct algorithm handlers for serial network algorithm

static AlgorithmHandler SerialNetworkInitAlgorithm;

static AlgorithmHandler SerialNetworkPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialNetworkHandlers =
{
    /// after constructor, global is parser context, data is init string

    SerialNetworkInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    SerialNetworkPrintInfo,
};


/// \struct algorithm description

static struct symtab_Algorithm modSerialNetwork =
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

    "SerialNetwork",

    /// algorithm handlers

    &pfSerialNetworkHandlers,

    /// event association table

    &evatSerialNetwork
};

struct symtab_Algorithm *palgSerialNetwork = &modSerialNetwork;


/// \def default number of serial networks

#define ENTRIES_SERIAL_NETWORKS		10000


/// serial network array

struct SerialNetworkVariables sernetwVariables;


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int : std ParserEventListener return value
/// 
/// \brief ParserEvent listener to put networks in a serial array
/// \details 
/// 

static int SerialNetworkParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result  ok

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to init serial network algorithm
/// \details 
/// 

static int SerialNetworkInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on serial network algorithm
/// \details 
/// 

static int SerialNetworkPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    /// loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerNetwAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added networks  %i/%i\n",
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
	     SymbolName(&sernetwVariables.psymsernetw[i].pnetw->segr.bio.ioh.iol.hsle),
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


