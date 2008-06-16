//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: randomize.c 1.15 Sun, 20 May 2007 22:11:53 -0500 hugo $
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

#include "neurospaces/cell.h"
#include "neurospaces/group.h"
#include "neurospaces/idin.h"
#include "neurospaces/iohier.h"
#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "randomize.h"
#include "randomizeinstance.h"


//s algorithm handlers for Randomize algorithm

static AlgorithmClassInstanceCreator RandomizeClassCreateInstance;

static AlgorithmClassHandler RandomizeClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfRandomizeClassHandlers =
{
    //m class info handler

    RandomizeClassPrintInfo,

    //m symbol handler

    RandomizeClassCreateInstance,
};


//s spines class derives from algorithm class

struct RandomizeClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct RandomizeClass rcRandomize =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"Randomize",

	//m algorithm handlers

	&pfRandomizeClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcRandomize = &rcRandomize.algc;


/// **************************************************************************
///
/// SHORT: RandomizeClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of Randomize algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
RandomizeClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= RandomizeInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to randomize class

	struct RandomizeClass *prc = (struct RandomizeClass *)palgc;

	//- increment number of created instances

	prc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: RandomizeClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on randomize algorithm class.
///
/// **************************************************************************

static
int
RandomizeClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to randomize class

    struct RandomizeClass *prc = (struct RandomizeClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: RandomizeClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 prc->iInstances);

    //- return result

    return(bResult);
}


