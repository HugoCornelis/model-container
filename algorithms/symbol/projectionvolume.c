//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionvolume.c 1.25 Sun, 20 May 2007 22:11:53 -0500 hugo $
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

#include "projectionvolume.h"
#include "projectionvolumeinstance.h"


//s algorithm handlers for projection algorithm

static AlgorithmClassInstanceCreator ProjectionVolumeClassCreateInstance;

static AlgorithmClassHandler ProjectionVolumeClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfProjectionVolumeClassHandlers =
{
    //m class info handler

    ProjectionVolumeClassPrintInfo,

    //m create instance from class (self, name, context, init string)

    ProjectionVolumeClassCreateInstance,
};


//s projectionVolume class derives from algorithm class

struct ProjectionVolumeClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct ProjectionVolumeClass pvcProjectionVolume =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"ProjectionVolume",

	//m algorithm handlers

	&pfProjectionVolumeClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcProjectionVolume = &pvcProjectionVolume.algc;


/// **************************************************************************
///
/// SHORT: ProjectionVolumeClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of projectionVolume algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
ProjectionVolumeClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= ProjectionVolumeInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to projectionVolume class

	struct ProjectionVolumeClass * pprc
	    = (struct ProjectionVolumeClass *)palgc;

	//- increment number of created instances

	pprc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ProjectionVolumeClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on projectionVolume algorithm class.
///
/// **************************************************************************

static int ProjectionVolumeClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to projectionVolume class

    struct ProjectionVolumeClass * pprc
	= (struct ProjectionVolumeClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ProjectionVolumeClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pprc->iInstances);

    //- return result

    return(bResult);
}


