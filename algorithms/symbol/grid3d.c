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

#include "neurospaces/cell.h"
#include "neurospaces/group.h"
#include "neurospaces/idin.h"
#include "neurospaces/iohier.h"
#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "grid3d.h"
#include "grid3dinstance.h"


//s algorithm handlers for Grid3D algorithm

static AlgorithmClassInstanceCreator Grid3DClassCreateInstance;

static AlgorithmClassHandler Grid3DClassPrintInfo;


//s algorithm class method table

static struct AlgorithmClassHandlerLibrary pfGrid3DClassHandlers =
{
    //m class info handler

    Grid3DClassPrintInfo,

    //m symbol handler

    Grid3DClassCreateInstance,
};


//s spines class derives from algorithm class

struct Grid3DClass
{
    //m base struct : algorithm class

    struct AlgorithmClass algc;

    //m number of created instances

    int iInstances;
};


//s algorithm class description

static struct Grid3DClass g3Grid3D =
{
    //m base struct : algorithm class

    {
	//m link

	{
	    NULL,
	    NULL,
	},

	//m name

	"Grid3D",

	//m algorithm handlers

	&pfGrid3DClassHandlers,
    },

    //m number of instances

    0,
};


struct AlgorithmClass *palgcGrid3D = &g3Grid3D.algc;


/// **************************************************************************
///
/// SHORT: Grid3DClassCreateInstance()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: struct AlgorithmInstance * : 
///
///	created algorithm instance, NULL for failure
///
/// DESCR: Algorithm handler to create instance of Grid3D algorithm.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: Grid3DClassPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on grid 3d algorithm class.
///
/// **************************************************************************

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


