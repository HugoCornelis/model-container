//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: grid3d.c 1.23 Sun, 20 May 2007 22:11:53 -0500 hugo $
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
#include "neurospaces/components/cell.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/iohier.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "grid3d.h"
#include "grid3dinstance.h"


/// \struct algorithm handlers for Grid3D algorithm

static AlgorithmClassInstanceCreator Grid3DClassCreateInstance;

static AlgorithmClassHandler Grid3DClassPrintInfo;


/// \struct algorithm class method table

static struct AlgorithmClassHandlerLibrary pfGrid3DClassHandlers =
{
    /// class info handler

    Grid3DClassPrintInfo,

    /// symbol handler

    Grid3DClassCreateInstance,
};


/// \struct spines class derives from algorithm class

struct Grid3DClass
{
    /// base struct : algorithm class

    struct AlgorithmClass algc;

    /// number of created instances

    int iInstances;
};


/// \struct algorithm class description

static struct Grid3DClass g3Grid3D =
{
    /// base struct : algorithm class

    {
	/// link

	{
	    NULL,
	    NULL,
	},

	/// name

	"Grid3D",

	/// algorithm handlers

	&pfGrid3DClassHandlers,
    },

    /// number of instances

    0,
};


struct AlgorithmClass *palgcGrid3D = &g3Grid3D.algc;


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of Grid3D algorithm.
/// \details 
/// 

static
struct AlgorithmInstance *
Grid3DClassCreateInstance
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : delegate to instance constructor

    struct AlgorithmInstance *palgiResult
	= Grid3DInstanceNew(palgc, pcInstance, pvGlobal, palgs);

    if (palgiResult)
    {
	//- get pointer to grid 3D class

	struct Grid3DClass *pg3c = (struct Grid3DClass *)palgc;

	//- increment number of created instances

	pg3c->iInstances++;
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
/// \brief Algorithm handler to print info on grid 3d algorithm class.
/// \details 
/// 

static
int
Grid3DClassPrintInfo
(struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to grid 3D class

    struct Grid3DClass *pg3c = (struct Grid3DClass *)palgc;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: Grid3DClass\n"
	 "report:\n"
	 "    number_of_created_instances: %i\n",
	 pg3c->iInstances);

    //- return result

    return(bResult);
}


