//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialsegment.c 1.30 Thu, 15 Nov 2007 13:04:36 -0600 hugo $
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
#include "neurospaces/symbolvirtual_protos.h"

#include "algorithms/event/serialsegment.h"


/// \struct event associations for serial segment algorithm

static ParserEventListener SerialSegmentParserEventListener;

static ParserEventAssociation pevasSerialSegment[] = 
{
    {
	/// listens to any segment event

	EVENT_TYPE_SEGMENT,

	/// function to call

	SerialSegmentParserEventListener,
    }
};


static ParserEventAssociationTable evatSerialSegment =
{
    /// number of entries

    sizeof(*pevasSerialSegment) / sizeof(ParserEventAssociation),

    /// event associations

    pevasSerialSegment,
};


/// \struct algorithm handlers for serial segment algorithm

static AlgorithmHandler SerialSegmentInitAlgorithm;

static AlgorithmHandler SerialSegmentPrintInfo;

static struct AlgorithmHandlerLibrary pfSerialSegmentHandlers =
{
    /// after constructor, global is parser context, data is init string

    SerialSegmentInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    SerialSegmentPrintInfo,
};


/// \struct algorithm description

static struct symtab_Algorithm modSerialSegment =
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

    "SerialSegment",

    /// algorithm handlers

    &pfSerialSegmentHandlers,

    /// event association table

    &evatSerialSegment
};

struct symtab_Algorithm *palgSerialSegment = &modSerialSegment;


/// \def default number of serial segments

#define ENTRIES_SERIAL_SEGMENTS	10000


/// serial segment array

struct SerialSegmentVariables sersegmentVariables;


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int : std ParserEventListener return value
/// 
/// \brief ParserEvent listener to put segments in a serial array
/// \details 
/// 

static int SerialSegmentParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result  ok

    int bResult = TRUE;

    //- look at type of event

    switch (pev->iType & EVENT_MASK_TYPES)
    {

    //- for segment

    case EVENT_TYPE_SEGMENT:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    //- increment number of created segments

	    sersegmentVariables.iSegmentsCreated++;

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    int i;

	    //- get parent id

	    /// \note call was removed

	    struct symtab_IdentifierIndex *pidinParent
		= NULL;
/* 		SegmentGetParentPidin */
/* 		  ((struct symtab_Segment *)pev->uInfo.phsle); */

	    //- register context of segment

	    sersegmentVariables
		.psymsersegment[sersegmentVariables.iSegmentsAdded].ppist
		= PidinStackDuplicate(&pev->pist);

	    //- register segment symbol

	    sersegmentVariables
		.psymsersegment[sersegmentVariables.iSegmentsAdded].psegment
		= (struct symtab_Segment *)pev->uInfo.phsle;

	    //- default : no parent segment

	    sersegmentVariables
		.psymsersegment
		[sersegmentVariables.iSegmentsAdded].iParent = -1;

	    //- if parent id

	    if (pidinParent)
	    {
		struct PidinStack *ppist = PidinStackCalloc();

		//- get working pidin stack for new element

		struct PidinStack *ppistNew = PidinStackDuplicate(&pev->pist);

		//- push & compact parent

		PidinStackPushCompact(ppistNew,pidinParent);

		//- loop over all previously registered segments

		for (i = sersegmentVariables.iSegmentsAdded - 1 ;
		     i >= 0;
		     i--)
		{
		    //- get pidinstack for registered segment

		    *ppist = *(sersegmentVariables.psymsersegment[i].ppist);

		    //- push registered segment name

		    PidinStackPushCompact
			(ppist,
			 SymbolGetPidin
			 (&sersegmentVariables.psymsersegment[i]
			  .psegment->segr.bio.ioh.iol.hsle));

		    //- if context matches

		    if (PidinStackEqual(ppistNew,ppist))
		    {
			//- register parent segment

			sersegmentVariables
			    .psymsersegment
			    [sersegmentVariables.iSegmentsAdded]
			    .psymsersegmentParent
			    = &sersegmentVariables.psymsersegment[i];

			sersegmentVariables
			    .psymsersegment
			    [sersegmentVariables.iSegmentsAdded].iParent = i;

			//- break searching loop

			break;
		    }
		}

		//- free tmp pidinstacks

		PidinStackFree(ppistNew);
		PidinStackFree(ppist);
	    }

	    //- increment number of added segments

	    sersegmentVariables.iSegmentsAdded++;

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
	     "SerialSegmentParserEventListener : "
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
/// \brief Algorithm handler to init serial segment algorithm
/// \details 
/// 

static int SerialSegmentInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

    int bResult = TRUE;

    //- get pointer to symbol table

    struct Symbols * pisSymbols = (struct Symbols *)pvData;

    //- initialize segment array

    sersegmentVariables.psymsersegment
	= (struct SymbolSerialSegment *)
	  calloc
	  (ENTRIES_SERIAL_SEGMENTS,sizeof(struct SymbolSerialSegment));

    if (!sersegmentVariables.psymsersegment)
    {
	return(FALSE);
    }

    //- initialize number of segments

    sersegmentVariables.iSegmentsCreated = 0;
    sersegmentVariables.iSegmentsAdded = 0;

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on serial segment algorithm
/// \details 
/// 

static int SerialSegmentPrintInfo
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
	 "SerSegmentAlgorithm : \n"
	 "---------------\n"
	 "Number of created/added segments  %i/%i\n",
	 sersegmentVariables.iSegmentsCreated,
	 sersegmentVariables.iSegmentsAdded);

    //- loop over segment array

    for (i = 0; i < sersegmentVariables.iSegmentsAdded; i++)
    {
	//- print segment info

/* 	fprintf */
/* 	    (pfile, */
/* 	     "%i\tSegment (%s,%i) with parent (%s,%i)\n", */
/* 	     i, */
/* 	     SegmentName(sersegmentVariables.psymsersegment[i].psegment), */
/* 	     SegmentIndex(sersegmentVariables.psymsersegment[i].psegment), */
/* 	     sersegmentVariables.psymsersegment[i].psegmentParent */
/* 	     ? SegmentName(sersegmentVariables.psymsersegment[i].psegmentParent) */
/* 	     : "Undefined", */
/* 	     sersegmentVariables.psymsersegment[i].psegmentParent */
/* 	     ? SegmentIndex(sersegmentVariables.psymsersegment[i].psegmentParent) */
/* 	     : -2); */

	fprintf
	    (pfile,
	     "%i\tSegment (%s,%i) with parent at %i (%s,%i)\n",
	     i,
	     SymbolName(&sersegmentVariables.psymsersegment[i].psegment->segr.bio.ioh.iol.hsle),
	     SegmentIndex(sersegmentVariables.psymsersegment[i].psegment),
	     sersegmentVariables.psymsersegment[i].iParent,
	     sersegmentVariables.psymsersegment[i].iParent != -1
	     ? SymbolName(&sersegmentVariables.psymsersegment[sersegmentVariables.psymsersegment[i].iParent].psegment->segr.bio.ioh.iol.hsle)
	     : "Undefined",
	     sersegmentVariables.psymsersegment[i].iParent != -1
	     ? -1
	     : -2);
    }

    //- return result

    return(bResult);
}


/// 
/// 
/// \arg sersegment serial segment entry
/// \arg ppist context stack receiving context of returned segment
/// 
/// \return struct symtab_Segment * : related segment
/// 
///	ppist....: context stack receiving context of returned segment
/// 
/// \brief start setup for segment
/// \details 
/// 
///	ppist has segment pidin on top.
/// 

struct symtab_Segment *
SerialSegmentSetupStart
(struct SymbolSerialSegment *sersegment,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Segment * psegmentResult = NULL;

    //- set result from serial segment

    psegmentResult = sersegment->psegment;

    /// \note in a cell in a network, I should use ppist to get the context of the
    /// \note segments and cat sersegment->ppist to give the full context of the
    /// \note returned segments.
    /// \note i.e. ppist gives the context of the cell the segments belong to.

    //- set context

    *ppist = *sersegment->ppist;

    //- return result

    return(psegmentResult);
}


/// 
/// 
/// \arg sersegment serial segment entry
/// \arg ppist context stack to restore
/// 
/// \return void
/// 
///	ppist....: context stack to restore
/// 
/// \brief end setup for segment
/// \details 
/// 

void
SerialSegmentSetupEnd
(struct SymbolSerialSegment *sersegment,
 struct PidinStack *ppist)
{
    /// \todo we need to restore the context pidinstack here
    /// \todo we could register the original (that should be restored)
    /// \todo in the serial segment (perhaps the serial segment array)
    /// \todo this means we need to lock the serial segment.
}


