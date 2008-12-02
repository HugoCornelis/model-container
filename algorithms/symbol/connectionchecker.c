//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectionchecker.c 1.16 Sun, 20 May 2007 22:11:53 -0500 hugo $
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "connectionchecker.h"
#include "connectioncheckerinstance.h"

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"


/// \struct algorithm handlers for connection checker algorithm

static AlgorithmClassInstanceCreator ConnectionCheckerClassCreateInstance;

static AlgorithmClassHandler ConnectionCheckerClassPrintInfo;


/// \struct algorithm class method table

static struct AlgorithmClassHandlerLibrary pfConnectionCheckerClassHandlers =
{
    /// class info handler

    ConnectionCheckerClassPrintInfo,

    /// create instance from class (self, name, context, init string)

    ConnectionCheckerClassCreateInstance,
};


/// \struct ConnectionChecker class derives from algorithm class

struct ConnectionCheckerClass
{
    /// base struct : algorithm class

    struct AlgorithmClass algc;

    /// number of created instances

    int iInstances;
};


/// \struct algorithm class description

static struct ConnectionCheckerClass scConnectionChecker =
{
    /// base struct : algorithm class

    {
	/// link

	{
	    NULL,
	    NULL,
	},

	/// name

	"ConnectionChecker",

	/// algorithm handlers

	&pfConnectionCheckerClassHandlers,
    },

    /// number of instances

    0,
};


struct AlgorithmClass *palgcConnectionChecker = &scConnectionChecker.algc;


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of connection checker algorithm.
/// \details 
/// 

static
struct AlgorithmInstance *
ConnectionCheckerClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= ConnectionCheckerInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to connection checker class

	struct ConnectionCheckerClass * pccc
	    = (struct ConnectionCheckerClass *)palgc;

	//- increment number of created instances

	pccc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on connection checker algorithm class.
/// \details 
/// 

static int ConnectionCheckerClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to connection checker class

    struct ConnectionCheckerClass * pccc
	= (struct ConnectionCheckerClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ConnectionCheckerClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pccc->iInstances);

    //- return result

    return(bResult);
}


