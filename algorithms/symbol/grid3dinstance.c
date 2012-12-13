//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: grid3dinstance.c 1.22 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/iohier.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"

#include "grid3d.h"
#include "grid3dinstance.h"


/// \struct Grid3D algorithm private data

/*s */
/*s struct with Grid3D options */
/*S */

struct Grid3DOptions_type
{
    /*m name of prototype for random Grid3Ds */

    char *pcGrid3DProto;

    /*m name of public prototype for random Grid3Ds */

    /// this was added for the purpose of backward compatibility

    char *pcGrid3DProtoPublic;

    /*m name of instances to be created */

    /// this was added for the purpose of backward compatibility

    char *pcInstanceName;

    /*m X count */

    int ix;

    /*m X distance */

    float fx;

    /*m Y count */

    int iy;

    /*m Y distance */

    float fy;

    /*m Z count */

    int iz;

    /*m Z distance */

    float fz;
};

typedef struct Grid3DOptions_type Grid3DOptions;


/// \struct
/// \struct Grid3D variables
/// \struct

struct Grid3DVariables_type
{
    /// current population to add something to

    struct symtab_Population *ppopu;

    /// symbol of prototype for random Grid3Ds

    struct symtab_HSolveListElement *phsleProto;

    /*m count of number of created cells */

    int iAdded;
};

typedef struct Grid3DVariables_type Grid3DVariables;


/// \struct Grid3D instance, derives from algorithm instance

struct Grid3DInstance
{
    /// base struct

    struct AlgorithmInstance algi;

    /// options for this instance

    Grid3DOptions g3o;

    /// variables for this instance

    Grid3DVariables g3v;
};


// local functions

static int 
Grid3DAddComponents
(struct Grid3DInstance *pg3i,
 struct symtab_IOHierarchy *pioh,
 struct PidinStack *ppist);

static int Grid3DInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static
int
Grid3DInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of Grid3D algorithm.
/// 

struct AlgorithmInstance *
Grid3DInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

    //- allocate algorithm instance

#include "hierarchy/output/algorithm_instances/grid3d_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct Grid3DInstance *pg3i
	= (struct Grid3DInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct Grid3DInstance), _vtable_grid3d, HIERARCHY_TYPE_algorithm_instances_grid3d);

    AlgorithmInstanceSetName(&pg3i->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProto
	    = SymbolFindParameter(&palgs->hsle, ppist, "PROTOTYPE");

	//- scan prototype name

	if (pparProto)
	{
	    pg3i->g3o.pcGrid3DProto = ParameterGetString(pparProto);
	}

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparProtoPublic
	    = SymbolFindParameter(&palgs->hsle, ppist, "PUBLIC_PROTOTYPE");

	//- scan prototype name

	if (pparProtoPublic)
	{
	    pg3i->g3o.pcGrid3DProtoPublic = ParameterGetString(pparProtoPublic);
	}

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparInstanceName
	    = SymbolFindParameter(&palgs->hsle, ppist, "INSTANCE_NAME");

	//- scan prototype name

	if (pparInstanceName)
	{
	    pg3i->g3o.pcInstanceName = ParameterGetString(pparInstanceName);
	}
	else
	{
	    pg3i->g3o.pcInstanceName = "%i";
	}

	//- scan x count

	pg3i->g3o.ix = SymbolParameterResolveValue(&palgs->hsle, ppist, "X_COUNT");

	//- scan x distance

	pg3i->g3o.fx = SymbolParameterResolveValue(&palgs->hsle, ppist, "X_DISTANCE");

	//- scan y count

	pg3i->g3o.iy = SymbolParameterResolveValue(&palgs->hsle, ppist, "Y_COUNT");

	//- scan y distance

	pg3i->g3o.fy = SymbolParameterResolveValue(&palgs->hsle, ppist, "Y_DISTANCE");

	//- scan z count

	pg3i->g3o.iz = SymbolParameterResolveValue(&palgs->hsle, ppist, "Z_COUNT");

	//- scan z distance

	pg3i->g3o.fz = SymbolParameterResolveValue(&palgs->hsle, ppist, "Z_DISTANCE");

    }

    //- initialize Grid3D count

    pg3i->g3v.iAdded = 0;

    //- if lookup prototype in symbol table

    if (pg3i->g3o.pcGrid3DProto)
    {
	pg3i->g3v.phsleProto
	    = ParserLookupPrivateModel(pg3i->g3o.pcGrid3DProto);
    }
    else if (pg3i->g3o.pcGrid3DProtoPublic)
    {
	struct PidinStack *ppistProto
	    = PidinStackParse(pg3i->g3o.pcGrid3DProtoPublic);

	pg3i->g3v.phsleProto = PidinStackLookupTopSymbol(ppistProto);
    }

    if (!pg3i->g3v.phsleProto)
    {
	//- not found : give diag's : prototype not found

	NeurospacesError
	    (pacContext,
	     "Grid3D algorithm class",
	     "Private model %s not found\n",
	     pg3i->g3o.pcGrid3DProto);

	/// \todo memory leak

	//- return failure

	return(NULL);
    }

    //- not instance of biocomponent

    else if (!instanceof_bio_comp(pg3i->g3v.phsleProto))
    {
	//- give diag's : prototype must be biocomponent

	NeurospacesError
	    (pacContext,
	     "Grid3D algorithm class",
	     "Private model %s must be instance of biological component.\n",
	     /// \todo population, network,
	     /// \todo (every biocomponent that knows about 'X', 'Y', 'Z' ?)
	     pg3i->g3o.pcGrid3DProto);

	/// \todo memory leak

	//- return failure

	return(NULL);
    }

    //- set result

    palgiResult = &pg3i->algi;

    //- return result

    return(palgiResult);
}


/// 
/// \arg palg grid3d algorithm
/// \arg pioh symbol to add components to
/// \arg ppist current parser context
/// 
/// \return int : success of operation
/// 
/// \brief Add components as specified by options and variables.
///
/// \details 
/// 
///	After adding, used to call SymbolRecalcAllSerials() on given 
///	symbol, not done anymore, could be changed.
/// 

static int 
Grid3DAddComponents
(struct Grid3DInstance *pg3i,
 struct symtab_IOHierarchy *pioh,
 struct PidinStack *ppist)
{
    //- set default result : ok

    int bResult = TRUE;

    int iz;

    //- loop over z direction

    /// \todo incorporate logic for invisible subset

    /// \todo take logarithm base 2 of pg3i->g3o.iz and add 1 ?
    /// \todo for every even incarnation of iz, have to add an invisible
    /// \todo node layer and descend ?

    for (iz = 0 ; iz < pg3i->g3o.iz ; iz++)
    {
	int iy;

	//- loop over y direction

	/// \todo incorporate logic for invisible subset

	for (iy = 0 ; iy < pg3i->g3o.iy ; iy++)
	{
	    int ix;

	    //- loop over x direction

	    /// \todo incorporate logic for invisible subset

	    for (ix = 0 ; ix < pg3i->g3o.ix ; ix++)
	    {
		char *pc;
		char pcTmp[100];
		struct symtab_IdentifierIndex *pidin = NULL;
		struct symtab_HSolveListElement *phsleNew;
		double x,y,z;

		//- calculate coordinates

		x = ix * pg3i->g3o.fx;
		y = iy * pg3i->g3o.fy;
		z = iz * pg3i->g3o.fz;

		//- create new name

		/// \todo this is contrary to the invisible subset implementation.
		/// \todo to solve this : use regular parameter for naming
		/// \todo (is also logical), and see further below regarding
		/// \todo positions.
		///
		/// \todo or perhaps by making the element pidin valid only
		/// \todo if the element belongs to the principal subset ?

		sprintf(pcTmp, pg3i->g3o.pcInstanceName, pg3i->g3v.iAdded);

		pc = (char *)calloc(1 + strlen(pcTmp),sizeof(char));

		strcpy(pc,pcTmp);

		pidin = IdinCalloc();

		IdinSetName(pidin,pc);

		/// \todo check if we need to manipulate the invisible subset :
		///
		/// \todo add invisible node (invisible is 1, principal is 0),
		/// \todo descend if needed.

		//- create alias

		phsleNew = SymbolCreateAlias(pg3i->g3v.phsleProto, NULL, pidin);

		//- set algorithm info

		SymbolSetAlgorithmInstanceInfo(phsleNew, &pg3i->algi);

		//- set coordinates

		/// \todo have to use parameter caches in case we are using invible subsets ?

		SymbolSetAtXYZ(phsleNew, x, y, z, 0);

		//- add to population

		/// \todo should this be SymbolAddChild() ?

		IOHierarchyAddChild(pioh, phsleNew);

		//- increment count

		/// \todo take invisible subset compression into account, is
		/// \todo related to invisible layer depth.

		pg3i->g3v.iAdded++;
	    }

	    if (!bResult)
	    {
		break;
	    }
	}

	if (!bResult)
	{
	    break;
	}
    }

    // recalculate serial ID's for affected symbols

    /// \note not needed as long as we insert children of the given symbol
    /// \note if we insert children of children of the given symbol,
    /// \note then this is indeed needed.

    //SymbolRecalcAllSerials(phsle,ppist);

    //- return result

    return(bResult);
}


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on grid 3d instance actions.
/// 

static int Grid3DInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    /// loop var

    int i;

    //- get pointer to grid 3D instance

    struct Grid3DInstance *pg3i = (struct Grid3DInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pg3i->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: Grid3DInstance %s\n"
	 "report:\n"
	 "    number_of_created_components: %i\n",
	 pcInstance,
	 pg3i->g3v.iAdded);

    fprintf
	(pfile,
	 "    Grid3DInstance_prototype: %s\n",
	 pg3i->g3v.phsleProto
	 ? IdinName(SymbolGetPidin(pg3i->g3v.phsleProto))
	 : "(none)");

    fprintf
	(pfile,
	 "    Grid3DInstance_options: %i %f %i %f %i %f\n",
	 pg3i->g3o.ix,
	 pg3i->g3o.fx,
	 pg3i->g3o.iy,
	 pg3i->g3o.fy,
	 pg3i->g3o.iz,
	 pg3i->g3o.fz);

    //- return result

    return(bResult);
}


/// 
/// \arg AlgorithmSymbolHandler args.
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to add Grid3Ds on given symbol
///
/// \details 
/// 
///	Does it do a clean update of serials ?
/// 

static
int
Grid3DInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    if (!phsle)
    {
	char pc[1000];

	PidinStackString(ppist, pc, 1000);

	NeurospacesError
	    (pac,
	     "Grid3DInstance",
	     "(%s) Grid3DInstance symbol handler on"
	     " cannot find component %s\n",
	     AlgorithmInstanceGetName(palgi),
	     pc);

	return(0);
    }

/*     //- if population or network */

/*     if (instanceof_population(phsle) || instanceof_network(phsle)) */
    {
	//- add cells to population

	struct symtab_IOHierarchy *pioh = (struct symtab_IOHierarchy *)phsle;

	iResult
	    = Grid3DAddComponents
	      ((struct Grid3DInstance *)palgi, pioh, ppist);
    }

/*     //- else */

/*     else */
/*     { */
/* 	//- give some diag's */

/* 	NeurospacesError */
/* 	    (pac, */
/* 	     "Grid3DInstance", */
/* 	     "(%s) Grid3DInstance symbol handler on" */
/* 	     " non population and non network %s\n", */
/* 	     AlgorithmInstanceGetName(palgi), */
/* 	     SymbolName(phsle)); */
/*     } */

    //- return result

    return(iResult);
}


