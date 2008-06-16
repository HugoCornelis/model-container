//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: spines.c 1.43 Sun, 20 May 2007 22:11:53 -0500 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/idin.h"
#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/segment.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "spines.h"
#include "spinesinstance.h"


//s algorithm handlers for spine algorithm

static AlgorithmClassInstanceCreator SpinesClassCreateInstance;

static AlgorithmClassHandler SpinesClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfSpinesClassHandlers =
{
    //m class info handler

    SpinesClassPrintInfo,

    //m create instance from class (self, name, context, init string)

    SpinesClassCreateInstance,
};


//s spines class derives from algorithm class

struct SpinesClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct SpinesClass scSpines =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"Spines",

	//m algorithm handlers

	&pfSpinesClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcSpines = &scSpines.algc;


/// **************************************************************************
///
/// SHORT: SpinesClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of spines algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
SpinesClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= SpinesInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to spines class

	struct SpinesClass * psc = (struct SpinesClass *)palgc;

	//- increment number of created instances

	psc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: SpinesClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on spines algorithm class.
///
/// **************************************************************************

static int SpinesClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to spines class

    struct SpinesClass * psc = (struct SpinesClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: SpinesClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 psc->iInstances);

    //- return result

    return(bResult);
}


