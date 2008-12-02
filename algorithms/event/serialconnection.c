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


/// \struct event associations for serial connection algorithm

static ParserEventListener SerialConnectionParserEventListener;

static ParserEventAssociation pevasSerialConnection[] = 
{
    {
	/// listens to any connection event

	EVENT_TYPE_CONNECTION,

	/// function to call

	SerialConnectionParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialConnection =
{
    /// number of entries

    sizeof(*pevasSerialConnection) / sizeof(ParserEventAssociation),

    /// event associations

    pevasSerialConnection,
};


/// \struct algorithm handlers for serial connection algorithm

static AlgorithmHandler SerialConnectionInitAlgorithm;

static AlgorithmHandler SerialConnectionPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialConnectionHandlers =
{
    /// after constructor, global is parser context, data is init string

    SerialConnectionInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    SerialConnectionPrintInfo,
};


/// \struct algorithm description

static struct symtab_Algorithm modSerialConnection =
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

    "SerialConnection",

    /// algorithm handlers

    &pfSerialConnectionHandlers,

    /// event association table

    &evatSerialConnection
};

struct symtab_Algorithm *palgSerialConnection = &modSerialConnection;


/// \def default number of serial connections

#define ENTRIES_SERIAL_CONNECTIONS	10000


/// serial connection array

struct SerialConnectionVariables serconnVariables;


// local functions

static int SerialConnectionFinish(void);


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int : std ParserEventListener return value
/// 
/// \brief ParserEvent listener to put connections in a serial array
/// \details 
/// 

static int SerialConnectionParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result  ok

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


/// 
/// 
/// \return int : success of operation
/// 
/// \brief Resolve connections
/// \details 
/// 

static int SerialConnectionFinish(void)
{
    //- set default result : ok

    int bResult = TRUE;

    /// loop var

    int i;

    //- loop over connection array

    for (i = 0; i < serconnVariables.iConnectionsAdded; i++)
    {
	// source & target of connection

	/// \structtruct PidinStack pistSource;
	/// \structtruct PidinStack pistTarget;

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to init serial connection algorithm
/// \details 
/// 

static int SerialConnectionInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on serial connection algorithm
/// \details 
/// 

static int SerialConnectionPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    /// loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerConnAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added connections  %i/%i\n",
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


