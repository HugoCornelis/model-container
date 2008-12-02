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

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "projectionrandomized.h"
#include "projectionrandomizedinstance.h"


/// \struct algorithm handlers for projection algorithm

static AlgorithmClassInstanceCreator ProjectionRandomizedClassCreateInstance;

static AlgorithmClassHandler ProjectionRandomizedClassPrintInfo;


/// \struct algorithm class method table

static struct AlgorithmClassHandlerLibrary pfProjectionRandomizedClassHandlers =
{
    /// class info handler

    ProjectionRandomizedClassPrintInfo,

    /// create instance from class (self, name, context, init string)

    ProjectionRandomizedClassCreateInstance,
};


/// \struct projectionRandomized class derives from algorithm class

struct ProjectionRandomizedClass
{
    /// base struct : algorithm class

    struct AlgorithmClass algc;

    /// number of created instances

    int iInstances;
};


/// \struct algorithm class description

static struct ProjectionRandomizedClass scProjectionRandomized =
{
    /// base struct : algorithm class

    {
	/// link

	{
	    NULL,
	    NULL,
	},

	/// name

	"ProjectionRandomized",

	/// algorithm handlers

	&pfProjectionRandomizedClassHandlers,
    },

    /// number of instances

    0,
};


struct AlgorithmClass *palgcProjectionRandomized = &scProjectionRandomized.algc;


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of projectionRandomized algorithm.
/// \details 
/// 

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on projectionRandomized algorithm class.
/// \details 
/// 

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


