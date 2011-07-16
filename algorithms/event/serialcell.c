//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialcell.c 1.24 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithm.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/parsersupport.h"

#include "algorithms/event/serialcell.h"
#include "algorithms/event/serialsegment.h"


/// \struct event associations for serial cell algorithm

static ParserEventListener SerialCellParserEventListener;

static ParserEventAssociation pevasSerialCell[] = 
{
    {
	/// listens to any cell event

	EVENT_TYPE_CELL,

	/// function to call

	SerialCellParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialCell =
{
    /// number of entries

    sizeof(*pevasSerialCell) / sizeof(ParserEventAssociation),

    /// event associations

    pevasSerialCell,
};


/// \struct algorithm handlers for serial cell algorithm

static AlgorithmHandler SerialCellInitAlgorithm;

static AlgorithmHandler SerialCellPrintInfo;

static AlgorithmHandler SerialCellSerialQuery;


static struct AlgorithmHandlerLibrary pfSerialCellHandlers =
{
    /// after constructor, global is parser context, data is init string

    SerialCellInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    SerialCellPrintInfo,

    /// serial query handler

    SerialCellSerialQuery,
};


/// \struct algorithm description

static struct symtab_Algorithm modSerialCell =
{
    /// link

    {
	NULL,
	NULL,
    },

    /// type

    0,

    /// flags

    0,

    /// name

    "SerialCell",

    /// algorithm handlers

    &pfSerialCellHandlers,

    /// event association table

    &evatSerialCell
};

struct symtab_Algorithm *palgSerialCell = &modSerialCell;


/// \def default number of serial cells

#define ENTRIES_SERIAL_CELLS		10000


/// serial cell array

struct SerialCellVariables sercellVariables;


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int : std ParserEventListener return value
/// 
/// \brief ParserEvent listener to put cells in a serial array
/// \details 
/// 

static int SerialCellParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result  ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {
    //- for cell

    case EVENT_TYPE_CELL:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //- register segment start for next cell

	    sercellVariables.psymsercell
		[sercellVariables.iCellsCreated].iFirstSegment
		= sersegmentVariables.iSegmentsAdded;

	    //- register cell symbol

	    sercellVariables.psymsercell[sercellVariables.iCellsCreated].pcell
		= (struct symtab_Cell *)pev->uInfo.phsle;

	    //- increment number of created cells

	    sercellVariables.iCellsCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register number of segments

	    /// \note number of created segments == until last created cell

	    sercellVariables.psymsercell[sercellVariables.iCellsAdded].iSegments
		= sersegmentVariables.iSegmentsCreated
		  - sercellVariables.psymsercell
		    [sercellVariables.iCellsAdded].iFirstSegment;

	    //- increment number of added cells

	    sercellVariables.iCellsAdded++;

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
	     "SerialCellParserEventListener : "
	     "ParserEvent type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to init serial cell algorithm
/// \details 
/// 

static int SerialCellInitAlgorithm
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize cell array

    sercellVariables.psymsercell
	= (struct SymbolSerialCell *)
	  calloc
	  (ENTRIES_SERIAL_CELLS,sizeof(struct SymbolSerialCell));

    if (!sercellVariables.psymsercell)
    {
	return(FALSE);
    }

    //- initialize number of cells

    sercellVariables.iCellsCreated = 0;
    sercellVariables.iCellsAdded = 0;

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on serial cell algorithm
/// \details 
/// 

static int SerialCellPrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    /// loop var

    int i;

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SerCellAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added cells  %i/%i\n",
	 sercellVariables.iCellsCreated,
	 sercellVariables.iCellsAdded);

    //- loop over cell array

    for (i = 0; i < sercellVariables.iCellsAdded; i++)
    {
	//- print cell info

	fprintf
	    (pfile,
	     "%i\tCell (%s,%i) at %i with %i segments\n",
	     i,
	     SymbolName(&sercellVariables.psymsercell[i].pcell->segr.bio.ioh.iol.hsle),
	     CellIndex(sercellVariables.psymsercell[i].pcell),
	     sercellVariables.psymsercell[i].iFirstSegment,
	     sercellVariables.psymsercell[i].iSegments);
    }

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
///	pvGlobal query spec
///	pvData...: query result array
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to query serial cell algorithm
/// \details 
/// 

static int SerialCellSerialQuery
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : failures

    int bResult = FALSE;

    /// loop var

    int i;

    //- get pointer to query

    struct SerialCellQuery * pq = (struct SerialCellQuery *)pvData;

    //- get pointer to independent symbol to look for

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)pq->pcell;

    //- loop over cell array

    for (i = 0; i < sercellVariables.iCellsAdded; i++)
    {
	//- if cell match

	if (sercellVariables.psymsercell[i].pcell == pq->pcell)
	{
	    //- fill in result

	    pq->iIndexCell = i;
	    pq->psymsersegment = &sersegmentVariables.psymsersegment[sercellVariables.psymsercell[i].iFirstSegment];
	    pq->iIndexSegment
		= sercellVariables.psymsercell[i].iFirstSegment;
	    pq->iSegments
		= sercellVariables.psymsercell[i].iSegments;

	    //- set result : success

	    bResult = TRUE;

	    //- break searching loop

	    break;
	}
    }

    //- return result

    return(bResult);
}


