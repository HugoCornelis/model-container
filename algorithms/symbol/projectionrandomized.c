//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionrandomized.c 1.21 Sun, 20 May 2007 22:11:53 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
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

#include "neurospaces/idin.h"
#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/population.h"
#include "neurospaces/projection.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/vectorconnection.h"

#include "projectionrandomized.h"
#include "projectionrandomizedinstance.h"


//s algorithm handlers for projection algorithm

static AlgorithmClassInstanceCreator ProjectionRandomizedClassCreateInstance;

static AlgorithmClassHandler ProjectionRandomizedClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfProjectionRandomizedClassHandlers =
{
    //m class info handler

    ProjectionRandomizedClassPrintInfo,

    //m create instance from class (self, name, context, init string)

    ProjectionRandomizedClassCreateInstance,
};


//s projectionRandomized class derives from algorithm class

struct ProjectionRandomizedClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct ProjectionRandomizedClass scProjectionRandomized =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"ProjectionRandomized",

	//m algorithm handlers

	&pfProjectionRandomizedClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcProjectionRandomized = &scProjectionRandomized.algc;


/// **************************************************************************
///
/// SHORT: ProjectionRandomizedClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of projectionRandomized algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
ProjectionRandomizedClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= ProjectionRandomizedInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to projectionRandomized class

	struct ProjectionRandomizedClass * pprc
	    = (struct ProjectionRandomizedClass *)palgc;

	//- increment number of created instances

	pprc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionRandomizedClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on projectionRandomized algorithm class.
///
/// **************************************************************************

static int ProjectionRandomizedClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to projectionRandomized class

    struct ProjectionRandomizedClass * pprc
	= (struct ProjectionRandomizedClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ProjectionRandomizedClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pprc->iInstances);

    //- return result

    return(bResult);
}


