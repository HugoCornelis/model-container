//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: replacer.c 1.1 Sun, 24 Jun 2007 21:50:17 -0500 hugo $
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

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "replacer.h"
#include "replacerinstance.h"


//s algorithm handlers for spine algorithm

static AlgorithmClassInstanceCreator ReplacerClassCreateInstance;

static AlgorithmClassHandler ReplacerClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfReplacerClassHandlers =
{
    //m class info handler

    ReplacerClassPrintInfo,

    //m create instance from class (self, name, context, init string)

    ReplacerClassCreateInstance,
};


//s replacer class derives from algorithm class

struct ReplacerClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct ReplacerClass rcReplacer =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"Replacer",

	//m algorithm handlers

	&pfReplacerClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcReplacer = &rcReplacer.algc;


/// **************************************************************************
///
/// SHORT: ReplacerClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of replacer algorithm.
///
/// **************************************************************************

static
struct AlgorithmInstance *
ReplacerClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= ReplacerInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to replacer class

	struct ReplacerClass * prc = (struct ReplacerClass *)palgc;

	//- increment number of created instances

	prc->iInstances++;
    }

    //- return result

    return(palgiResult);
}


/// **************************************************************************
///
/// SHORT: ReplacerClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on replacer algorithm class.
///
/// **************************************************************************

static int ReplacerClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to replacer class

    struct ReplacerClass * prc = (struct ReplacerClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: ReplacerClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 prc->iInstances);

    //- return result

    return(bResult);
}


