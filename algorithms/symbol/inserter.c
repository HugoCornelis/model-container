//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: inserter.c 1.3 Sun, 24 Jun 2007 21:01:38 -0500 hugo $
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

#include "inserter.h"
#include "inserterinstance.h"


//s algorithm handlers for spine algorithm

static AlgorithmClassInstanceCreator InserterClassCreateInstance;

static AlgorithmClassHandler InserterClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfInserterClassHandlers =
{
    //m class info handler

    InserterClassPrintInfo,

    //m create instance from class (self, name, context, init string)

    InserterClassCreateInstance,
};


//s inserter class derives from algorithm class

struct InserterClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct InserterClass icInserter =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"Inserter",

	//m algorithm handlers

	&pfInserterClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcInserter = &icInserter.algc;


/// **************************************************************************
///
/// SHORT: InserterClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of inserter algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
InserterClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= InserterInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to inserter class

	struct InserterClass * pic = (struct InserterClass *)palgc;

	//- increment number of created instances

	pic->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: InserterClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on inserter algorithm class.
///
/// **************************************************************************

static int InserterClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to inserter class

    struct InserterClass * pic = (struct InserterClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: InserterClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pic->iInstances);

    //- return result

    return(bResult);
}


