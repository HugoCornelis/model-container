//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialprojection.c 1.21 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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
#include "neurospaces/parsersupport.h"
#include "neurospaces/projection.h"
#include "neurospaces/vector.h"

#include "algorithms/event/serialconnection.h"
#include "algorithms/event/serialprojection.h"


//s event associations for serial projection algorithm

static ParserEventListener SerialProjectionParserEventListener;

static ParserEventAssociation pevasSerialProjection[] = 
{
    {
	//m listens to any projection event

	EVENT_TYPE_PROJECTION,

	//m function to call

	SerialProjectionParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialProjection =
{
    //m number of entries

    sizeof(*pevasSerialProjection) / sizeof(ParserEventAssociation),

    //m event associations

    pevasSerialProjection,
};


//s algorithm handlers for serial projection algorithm

static AlgorithmHandler SerialProjectionInitAlgorithm;

static AlgorithmHandler SerialProjectionPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialProjectionHandlers =
{
    //m after constructor, global is parser context, data is init string

    SerialProjectionInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    SerialProjectionPrintInfo,
};


//s algorithm description

static struct symtab_Algorithm modSerialProjection =
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

    "SerialProjection",

    //m algorithm handlers

    &pfSerialProjectionHandlers,

    //m event association table

    &evatSerialProjection
};

struct symtab_Algorithm *palgSerialProjection = &modSerialProjection;


//d default number of serial projections

#define ENTRIES_SERIAL_PROJECTIONS	10000


//v serial projection array

struct SerialProjectionVariables serprojVariables;


/// **************************************************************************
///
/// SHORT: SerialProjectionParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to put projections in a serial array
///
/// **************************************************************************

static int SerialProjectionParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result : ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- for projection

    case EVENT_TYPE_PROJECTION:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //- register connection start for next projection

	    serprojVariables.psymserproj
		[serprojVariables.iProjectionsCreated].iFirstConnection
		= serconnVariables.iConnectionsAdded;

	    //- register projection symbol

	    serprojVariables.psymserproj
		[serprojVariables.iProjectionsCreated].pproj
		= (struct symtab_Projection *)pev->uInfo.phsle;

	    //- increment number of created projections

	    serprojVariables.iProjectionsCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register number of connections

	    serprojVariables.psymserproj[serprojVariables.iProjectionsAdded].iConnections
		= serconnVariables.iConnectionsCreated
		  - serprojVariables.psymserproj
		    [serprojVariables.iProjectionsAdded].iFirstConnection;

	    //- increment number of added projections

	    serprojVariables.iProjectionsAdded++;

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
	     "SerialProjectionParserEventListener : "
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
/// SHORT: SerialProjectionInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init serial projection algorithm
///
/// **************************************************************************

static int SerialProjectionInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize projection array

    serprojVariables.psymserproj
	= (struct SymbolSerialProjection *)
	  calloc
	  (ENTRIES_SERIAL_PROJECTIONS,sizeof(struct SymbolSerialProjection));

    if (!serprojVariables.psymserproj)
    {
	return(FALSE);
    }

    //- initialize number of projections

    serprojVariables.iProjectionsCreated = 0;
    serprojVariables.iProjectionsAdded = 0;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialProjectionPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on serial projection algorithm
///
/// **************************************************************************

static int SerialProjectionPrintInfo
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
	 "SerProjAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added projections : %i/%i\n",
	 serprojVariables.iProjectionsCreated,
	 serprojVariables.iProjectionsAdded);

    //- loop over projection array

    for (i = 0; i < serprojVariables.iProjectionsAdded; i++)
    {
	//- print projection info

	fprintf
	    (pfile,
	     "%i\tProjection (%s,%i)\n",
	     i,
	     IdinName(SymbolGetPidin(&(serprojVariables.psymserproj[i].pproj->bio.ioh.iol.hsle))),
	     /* IdinIndex(SymbolGetPidin(&(serprojVariables.psymserproj[i].pproj->bio.ioh.iol.hsle))) */-1);
    }

    //- return result

    return(bResult);
}


