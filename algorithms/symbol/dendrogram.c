//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
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

#include "dendrogram.h"
#include "dendrograminstance.h"

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"


/// \struct algorithm handlers for dendrogram algorithm

static AlgorithmClassInstanceCreator DendrogramClassCreateInstance;

static AlgorithmClassHandler DendrogramClassPrintInfo;


/// \struct algorithm class method table

static struct AlgorithmClassHandlerLibrary pfDendrogramClassHandlers =
{
    /// class info handler

    DendrogramClassPrintInfo,

    /// create instance from class (self, name, context, init string)

    DendrogramClassCreateInstance,
};


/// \struct Dendrogram class derives from algorithm class

struct DendrogramClass
{
    /// base struct : algorithm class

    struct AlgorithmClass algc;

    /// number of created instances

    int iInstances;
};


/// \struct algorithm class description

static struct DendrogramClass scDendrogram =
{
    /// base struct : algorithm class

    {
	/// link

	{
	    NULL,
	    NULL,
	},

	/// name

	"Dendrogram",

	/// algorithm handlers

	&pfDendrogramClassHandlers,
    },

    /// number of instances

    0,
};


struct AlgorithmClass *palgcDendrogram = &scDendrogram.algc;


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of dendrogram algorithm.
/// 

static
struct AlgorithmInstance *
DendrogramClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= DendrogramInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to connection checker class

	struct DendrogramClass * pccc
	    = (struct DendrogramClass *)palgc;

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

static int DendrogramClassPrintInfo
(struct AlgorithmClass *palgc, char *pcName, void *pvGlobal, void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to connection checker class

    struct DendrogramClass * pccc
	= (struct DendrogramClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: DendrogramClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pccc->iInstances);

    //- return result

    return(bResult);
}


