//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialpopulation.c 1.22 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/cell.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/algorithm.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/population.h"
#include "neurospaces/vector.h"

#include "algorithms/event/serialcell.h"
#include "algorithms/event/serialpopulation.h"


//s event associations for serial population algorithm

static ParserEventListener SerialPopulationParserEventListener;

static ParserEventAssociation pevasSerialPopulation[] = 
{
    {
	//m listens to any population event

	EVENT_TYPE_POPULATION,

	//m function to call

	SerialPopulationParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialPopulation =
{
    //m number of entries

    sizeof(*pevasSerialPopulation) / sizeof(ParserEventAssociation),

    //m event associations

    pevasSerialPopulation,
};


//s algorithm handlers for serial population algorithm

static AlgorithmHandler SerialPopulationInitAlgorithm;

static AlgorithmHandler SerialPopulationPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialPopulationHandlers =
{
    //m after constructor, global is parser context, data is init string

    SerialPopulationInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    SerialPopulationPrintInfo,
};


//s algorithm description

static struct symtab_Algorithm modSerialPopulation =
{
    //m link

    {
	NULL,
	NULL,
    },

    //m type

    0,

    //m flags

    0,

    //m name

    "SerialPopulation",

    //m algorithm handlers

    &pfSerialPopulationHandlers,

    //m event association table

    &evatSerialPopulation
};

struct symtab_Algorithm *palgSerialPopulation = &modSerialPopulation;


//d default number of serial population

#define ENTRIES_SERIAL_POPULATIONS	10000


//v serial population array

struct SerialPopulationVariables serpopuVariables;


/// **************************************************************************
///
/// SHORT: SerialPopulationParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to put populations in a serial array
///
/// **************************************************************************

static int SerialPopulationParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result : ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- for population

    case EVENT_TYPE_POPULATION:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //- register cell start for next population

	    serpopuVariables.psymserpopu
		[serpopuVariables.iPopulationsCreated].iFirstCell
		= sercellVariables.iCellsAdded;

	    //- register population symbol

	    serpopuVariables.psymserpopu
		[serpopuVariables.iPopulationsCreated].ppopu
		= (struct symtab_Population *)pev->uInfo.phsle;

	    //- increment number of created populations

	    serpopuVariables.iPopulationsCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register number of cells

	    serpopuVariables.psymserpopu
		[serpopuVariables.iPopulationsAdded].iCells
		= sercellVariables.iCellsCreated
		  - serpopuVariables.psymserpopu
		    [serpopuVariables.iPopulationsAdded].iFirstCell;

	    //- increment number of added populations

	    serpopuVariables.iPopulationsAdded++;

	    break;
	}
	}

	break;
    }

    //- else

    default:
    {
	//- give diagnostics : not implemented

	fprintf
	    (stderr,
	     "SerialPopulationParserEventListener : "
	     "ParserEvent type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialPopulationInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init serial population algorithm
///
/// **************************************************************************

static int SerialPopulationInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize population array

    serpopuVariables.psymserpopu
	= (struct SymbolSerialPopulation *)
	  calloc
	  (ENTRIES_SERIAL_POPULATIONS,sizeof(struct SymbolSerialPopulation));

    if (!serpopuVariables.psymserpopu)
    {
	return(FALSE);
    }

    //- initialize number of populations

    serpopuVariables.iPopulationsCreated = 0;
    serpopuVariables.iPopulationsAdded = 0;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SerialPopulationPrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on serial population algorithm
///
/// **************************************************************************

static int SerialPopulationPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //v loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerPopuAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added populations : %i/%i\n",
	 serpopuVariables.iPopulationsCreated,
	 serpopuVariables.iPopulationsAdded);

    //- loop over population array

    for (i = 0; i < serpopuVariables.iPopulationsAdded; i++)
    {
	//- print population info

	fprintf
	    (pfile,
	     "%i\tPopulation (%s,%i)\n",
	     i,
	     IdinName
	     (SymbolGetPidin(&(serpopuVariables.psymserpopu[i].ppopu->segr.bio.ioh.iol.hsle))),
/* 	     IdinIndex */
/* 	     (SymbolGetPidin(&(serpopuVariables.psymserpopu[i].ppopu->segr.bio.ioh.iol.hsle))) */-1);
    }

    //- return result

    return(bResult);
}


