//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialconnection.c 1.25 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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
#include "neurospaces/components/connection.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/parsersupport.h"

#include "algorithms/event/serialconnection.h"

#include "neurospaces/symbolvirtual_protos.h"


//s event associations for serial connection algorithm

static ParserEventListener SerialConnectionParserEventListener;

static ParserEventAssociation pevasSerialConnection[] = 
{
    {
	//m listens to any connection event

	EVENT_TYPE_CONNECTION,

	//m function to call

	SerialConnectionParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialConnection =
{
    //m number of entries

    sizeof(*pevasSerialConnection) / sizeof(ParserEventAssociation),

    //m event associations

    pevasSerialConnection,
};


//s algorithm handlers for serial connection algorithm

static AlgorithmHandler SerialConnectionInitAlgorithm;

static AlgorithmHandler SerialConnectionPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialConnectionHandlers =
{
    //m after constructor, global is parser context, data is init string

    SerialConnectionInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    SerialConnectionPrintInfo,
};


//s algorithm description

static struct symtab_Algorithm modSerialConnection =
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

    "SerialConnection",

    //m algorithm handlers

    &pfSerialConnectionHandlers,

    //m event association table

    &evatSerialConnection
};

struct symtab_Algorithm *palgSerialConnection = &modSerialConnection;


//d default number of serial connections

#define ENTRIES_SERIAL_CONNECTIONS	10000


//v serial connection array

struct SerialConnectionVariables serconnVariables;


// local functions

static int SerialConnectionFinish(void);


/// **************************************************************************
///
/// SHORT: SerialConnectionParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to put connections in a serial array
///
/// **************************************************************************

static int SerialConnectionParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result : ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- if pure event

    case 0:
    {
	//- look at action of event

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- for EVENT_ACTION_START

	case EVENT_ACTION_START:
	{
	    //? can we do something here

	    break;
	}

	//- for EVENT_ACTION_FINISH

	case EVENT_ACTION_FINISH:
	{
	    //- finish all connections

	    SerialConnectionFinish();

	    break;
	}

	}

	break;
    }

    //- for connection

    case EVENT_TYPE_CONNECTION:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //- increment number of created connections

	    serconnVariables.iConnectionsCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register connection symbol

	    serconnVariables
		.psymserconn[serconnVariables.iConnectionsAdded].pconn
		= (struct symtab_Connection *)pev->uInfo.phsle;

	    //- increment number of added connections

	    serconnVariables.iConnectionsAdded++;

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
	     "SerialConnectionParserEventListener : "
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
/// SHORT: SerialConnectionFinish()
///
/// ARGS.:
///
/// RTN..: int : success of operation
///
/// DESCR: Resolve connections
///
/// **************************************************************************

static int SerialConnectionFinish(void)
{
    //- set default result : ok

    int bResult = TRUE;

    //v loop var

    int i;

    //- loop over connection array

    for (i = 0; i < serconnVariables.iConnectionsAdded; i++)
    {
	// source & target of connection

	//struct PidinStack pistSource;
	//struct PidinStack pistTarget;

	//- get pointer to current connection symbol

	struct symtab_Connection *pconn
	    = serconnVariables.psymserconn[i].pconn;

/* 	//- get idin for source & target symbol */

/* 	struct symtab_IdentifierIndex *pidinSource  */
/* 	    = ConnectionSourcePidin(pconn); */
/* 	struct symtab_IdentifierIndex *pidinTarget  */
/* 	    = ConnectionTargetPidin(pconn); */

/* 	//- resolve source & target symbol */

/* 	//PidinStackPushCompactAll(&pistSource,pidinSource); */
/* 	//PidinStackPushCompactAll(&pistTarget,pidinTarget); */

/* 	pconn->deconn.phsleSource */
/* 	    = ParserLookupSymbol(NULL,pidinSource); */
/* 	pconn->deconn.phsleTarget */
/* 	    = ParserLookupSymbol(NULL,pidinTarget); */
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialConnectionInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init serial connection algorithm
///
/// **************************************************************************

static int SerialConnectionInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize connection array

    serconnVariables.psymserconn
	= (struct SymbolSerialConnection *)
	  calloc
	  (ENTRIES_SERIAL_CONNECTIONS,sizeof(struct SymbolSerialConnection));

    if (!serconnVariables.psymserconn)
    {
	return(FALSE);
    }

    //- initialize number of connections

    serconnVariables.iConnectionsCreated = 0;
    serconnVariables.iConnectionsAdded = 0;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialConnectionPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on serial connection algorithm
///
/// **************************************************************************

static int SerialConnectionPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //v loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerConnAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added connections : %i/%i\n",
	 serconnVariables.iConnectionsCreated,
	 serconnVariables.iConnectionsAdded);

    //- loop over connection array

    for (i = 0; i < serconnVariables.iConnectionsAdded; i++)
    {
	char pcSource[100] = "";
	char pcTarget[100] = "";

/* 	//- get source and target strings */

/* 	IdinFullName */
/* 	    (pcSource, */
/* 	     ConnectionSourcePidin(serconnVariables.psymserconn[i].pconn)); */
/* 	IdinFullName */
/* 	    (pcTarget, */
/* 	     ConnectionTargetPidin(serconnVariables.psymserconn[i].pconn)); */

	//- print connection info

	fprintf
	    (pfile,
	     "%i\tConnection %s("/* %s */") to %s("/* %s */"))\n",
	     i,
	     pcSource,
/* 	     SymbolHSLETypeDescribe */
/* 	     (serconnVariables.psymserconn[i] */
/* 	      .pconn->deconn.phsleSource->iType), */
	     pcTarget,
/* 	     SymbolHSLETypeDescribe */
/* 	     (serconnVariables.psymserconn[i] */
/* 	      .pconn->deconn.phsleTarget->iType)); */
	     NULL);
    }

    //- return result

    return(bResult);
}


