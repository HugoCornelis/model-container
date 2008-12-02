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

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "inserter.h"
#include "inserterinstance.h"


/// \struct algorithm handlers for spine algorithm

static AlgorithmClassInstanceCreator InserterClassCreateInstance;

static AlgorithmClassHandler InserterClassPrintInfo;


/// \struct algorithm class method table

static struct AlgorithmClassHandlerLibrary pfInserterClassHandlers =
{
    /// class info handler

    InserterClassPrintInfo,

    /// create instance from class (self, name, context, init string)

    InserterClassCreateInstance,
};


/// \struct inserter class derives from algorithm class

struct InserterClass
{
    /// base struct : algorithm class

    struct AlgorithmClass algc;

    /// number of created instances

    int iInstances;
};


/// \struct algorithm class description

static struct InserterClass icInserter =
{
    /// base struct : algorithm class

    {
	/// link

	{
	    NULL,
	    NULL,
	},

	/// name

	"Inserter",

	/// algorithm handlers

	&pfInserterClassHandlers,
    },

    /// number of instances

    0,
};


struct AlgorithmClass *palgcInserter = &icInserter.algc;


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of inserter algorithm.
/// \details 
/// 

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on inserter algorithm class.
/// \details 
/// 

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


