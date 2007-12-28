//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: purkinjespine.c 1.47 Wed, 10 Oct 2007 17:55:28 -0500 hugo $
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/alias.h"
#include "neurospaces/cell.h"
#include "neurospaces/segment.h"
#include "neurospaces/D3segment.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/modelevent.h"
#include "neurospaces/algorithm.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/proxy.h"
#include "neurospaces/vector.h"

#include "neurospaces/segmentvirtual_protos.h"
#include "neurospaces/symbolvirtual_protos.h"


//s event associations for spine algorithm

static ParserEventListener SpineSegmentParserEventListener;

static ParserEventAssociation pevasSpines[] = 
{
    {
	//m listens to any segment event

	EVENT_TYPE_SEGMENT,

	//m function to call

	SpineSegmentParserEventListener,
    },
    {
	EVENT_TYPE_CELL,
	SpineSegmentParserEventListener,
    }
};


static ParserEventAssociationTable evatSpines =
{
    //m number of entries

    sizeof(*pevasSpines) / sizeof(ParserEventAssociation),

    //m event associations

    pevasSpines,
};


//s algorithm handlers for spine algorithm

static AlgorithmHandler SpineInitAlgorithm;

static AlgorithmHandler SpinePrintInfo;

static struct AlgorithmHandlerLibrary pfSpineHandlers =
{
    //m after constructor, global is parser context, data is init string

    SpineInitAlgorithm,

    //m after init, before destruct

    NULL,

    //m print info handler

    SpinePrintInfo,
};


//s algorithm description

static struct symtab_Algorithm modSpinesEvents =
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

    "Spines_with_events",

    //m algorithm handlers

    &pfSpineHandlers,

    //m event association table

    &evatSpines
};

struct symtab_Algorithm *palgSpinesEvents = &modSpinesEvents;


//s spine algorithm private data

/*s */
/*s struct with spine options */
/*S */

struct SpineOptions_type
{
    /*m name of prototype for random spines */

    char *pcRandomSpineProto;

    /*m random spines maximal dendritic diameter for segment */

    float fRandomDendrDiaMax;

    /*m random spines minimal dendritic diameter for segment */

    float fRandomDendrDiaMin;

    /*m spine density */

    float fSpineDensity;

    /*m spine frequency */

    float fSpineFrequency;

    /*m average length */

    //float fAverageLength;

    /*m spine surface */

    //float fSpineSurface;

    /*m count of number of added spines */

    //int iAddedSpines;
};

typedef struct SpineOptions_type SpineOptions;


static SpineOptions soSpineOptions;


//s
//s spine variables
//s

struct SpineVariables_type
{
    //m current cell to add spines to

    struct symtab_Cell *pcell;

    //m symbol of prototype for random spines

    struct symtab_HSolveListElement *phsleSpineProto;

    /*m spine surface */

    double dSpineSurface;

    //m number of added spines for this cell

    int iPhysicalSpines;

    //m number of (physical + virtual) spines for this cell

    double dAllSpines;

    //m flags event generation for creation of spines

    //! prevents infinite loops

    int iParserEventSpineCreation;
};

typedef struct SpineVariables_type SpineVariables;


static SpineVariables svSpineVariables;


// local functions

//static int SpineAdd(struct symtab_HSolveListElement *phsle);

static int SpineCreateAndAdd
(struct symtab_HSolveListElement *phsle,
 double dSpines,
 struct PidinStack *ppist,
 struct symtab_D3Segment * pD3segm);

static int SpineDoAdjustments
(struct PidinStack *ppist,struct symtab_D3Segment *pD3segm);


/// **************************************************************************
///
/// SHORT: SpineCreateAndAdd()
///
/// ARGS.:
///
///	phsle...: spine prototype to use for created spines
///	dSpines.: number of virtual spines
///	pD3segm.: segment to add spines to
///	ppist...: context of segment
///
/// RTN..: int : number of created spines
///
/// DESCR: Create spines and link them into a list
///
///	dSpines is the number of spines that influence the surface of the
///	segment if no physical spines would be added.
///
/// **************************************************************************

static int SpineCreateAndAdd
(struct symtab_HSolveListElement *phsle,
 double dSpines,
 struct PidinStack *ppist,
 struct symtab_D3Segment * pD3segm)
{
    //- set default result : no spines added

    int iResult = 0;

    //v segment

    char *pcSegment = NULL;
/*     int iSegment = -1; */

    //v name of segment

    struct symtab_IdentifierIndex * pidinName = NULL;

    //v proxy for new spine symbol table element

    struct symtab_Proxy *pproxSpine = NULL;

    //- get name/index of parent segment

    pcSegment = IdinName(SymbolGetPidin(&pD3segm->segment.bio.ioh.iol.hsle));
/*     iSegment = IdinIndex(SymbolGetPidin(&pD3segm->segment.bio.ioh.iol.hsle)); */

    //- calloc idin and set name,index

    pidinName = IdinCalloc();

    IdinSetName(pidinName,soSpineOptions.pcRandomSpineProto);
    //IdinSetIndex(pidinName,svSpineVariables.iPhysicalSpines);

    //- calloc symbol table element for new spine

//extern struct symtab_Proxy * ProxyCalloc(void);

    pproxSpine = ProxyCalloc();

    //- link symbol with prototype

    ProxySetPrototypeName(pproxSpine,IdinName(SymbolGetPidin(phsle)));
    ProxySetPrototype(pproxSpine,phsle);

    //- link idin

    ProxySetName(pproxSpine,pidinName);

    {
	//v prototype symbol with spine segments

	struct symtab_HSolveListElement *phsleSegms = phsle;

	//- resolve dependency symbols of spine prototype

	phsleSegms = AliasResolve((struct symtab_Alias *)phsleSegms);

	//- sanity check : if segment container

	if (instanceof_v_segment(phsleSegms))
	{
	    //v sections in spine segment container

	    struct symtab_HSolveListElement *phsleSection = NULL;

	    //- get pointer to segment container of spines

	    struct symtab_Vector *pvectContainer
		= (struct symtab_Vector *)phsleSegms;

	    //- construct context with this segment

	    struct PidinStack pistContainer = *ppist;

	    PidinStackPush(&pistContainer,pD3segm->segment.bio.pidinName);

	    //- add container element to context

	    //! still using private data here

	    PidinStackPush(&pistContainer,pidinName);

	    //- loop over sections in the spine segment container

	    phsleSection
		= (struct symtab_HSolveListElement *)
		  HSolveListHead(&pvectContainer->bio.ioh.iohc);

	    while (HSolveListValidSucc(&phsleSection->hsleLink))
	    {
		//- get pointer to segment

		struct symtab_D3Segment *pD3segm
		    = (struct symtab_D3Segment *)phsleSection;

		    //- construct context with this segment

		    struct PidinStack pistSpine = pistContainer;

/* 		    PidinStackPush(&pistSpine,pD3segm->segment.bio.pidinName); */

		    //- generate segment event

		    //! because we generate a parser event here,
		    //! this algorithm should be derived from a parser algorithm

		    ParserEventGenerate
			(EVENT_TYPE_SEGMENT | EVENT_ACTION_CREATE,
			 phsleSection,
			 &pistSpine);

		//- go to next section

		phsleSection
		    = (struct symtab_HSolveListElement *)
		      HSolveListNext(&phsleSection->hsleLink);
	    }
	}
    }

    //- add symbol to section list of parent segment

    HSolveListEntail
	(&pD3segm->segment.bio.ioh.iohc,&pproxSpine->alia.hsle.hsleLink);

    {
	//v prototype symbol with spine segments

	struct symtab_HSolveListElement *phsleSegms = phsle;

	//- resolve dependency symbols of spine prototype

	phsleSegms
	    = AliasResolve((struct symtab_Alias *)phsleSegms);

	//- sanity check : if segment container

	if (instanceof_v_segment(phsleSegms))
	{
	    //v sections in spine segment container

	    struct symtab_HSolveListElement *phsleSection = NULL;

	    //- get pointer to segment container of spines

	    struct symtab_Vector *pvectContainer
		= (struct symtab_Vector *)phsleSegms;

	    //- construct context with this segment

	    struct PidinStack pistContainer = *ppist;

	    PidinStackPush(&pistContainer,pD3segm->segment.bio.pidinName);

	    //- add container element to context

	    //! still using private data here

	    PidinStackPush(&pistContainer,pidinName);

	    //- loop over sections in the spine segment container

	    phsleSection
		= (struct symtab_HSolveListElement *)
		  HSolveListHead(&pvectContainer->bio.ioh.iohc);

	    while (HSolveListValidSucc(&phsleSection->hsleLink))
	    {
		//- get pointer to segment

		struct symtab_D3Segment *pD3segm
		    = (struct symtab_D3Segment *)phsleSection;

		    //- construct context with this segment

		    struct PidinStack pistSpine = pistContainer;

/* 		    PidinStackPush(&pistSpine,pD3segm->segment.bio.pidinName); */

		    //- generate segment event

		    //! add event because parent segment is already added,
		    //! thus the spine is now already part of the model

		    ParserEventGenerate
			(EVENT_TYPE_SEGMENT | EVENT_ACTION_ADD,
			 phsleSection,
			 &pistSpine);

		//- go to next section

		phsleSection
		    = (struct symtab_HSolveListElement *)
		      HSolveListNext(&phsleSection->hsleLink);
	    }
	}
    }

    //- increment spine count

    svSpineVariables.iPhysicalSpines++;

    //- set result

    iResult++;

    //- return result

    return (iResult);
}


/// **************************************************************************
///
/// SHORT: SpineSegmentCheck()
///
/// ARGS.:
///
///	ppist..: context of segment
///	psegment..: segment candidate for spines
///
/// RTN..: int : success of operation
///
/// DESCR: Check if segment needs spines
///
///	See hines_read.c
///
/// **************************************************************************

static int SpineSegmentCheck
(struct PidinStack *ppist,struct symtab_Segment *psegment)
{
    //- set default result : ok

    int bResult = TRUE;

    //v segment parameters

    double dDia;
    double dLength;

    //v surface of all spines

    double dSpines = 0.0;

    //- cast segment to positioned segment

    //t this hack should disappear if struct symtab_D3Segment is split
    //t into D3 segment and segment enumeration
    //t the code below still need adjustements

    struct symtab_D3Segment * pD3segm = (struct symtab_D3Segment *)psegment;

    //- if segment spherical

    if (D3SegmentIsSpherical(pD3segm))
    {
	//- return ok

	return(TRUE);
    }

    //- get segment diameter

    dDia
	= SymbolParameterResolveValue
	  (&pD3segm->segment.bio.ioh.iol.hsle,"DIA",ppist);

    //- if not found

    if (dDia == -1)
    {
	fprintf
	    (stderr,
	     "Purkinje spines : %s doesn't have a diameter\n",
	     IdinName(SymbolGetPidin(&psegment->bio.ioh.iol.hsle)));

	//- return failure

	return(FALSE);
    }

    //- if diameter small enough

    if (dDia <= soSpineOptions.fRandomDendrDiaMax)
    {
	//- if diameter appropriate for physical spines

	if (dDia > soSpineOptions.fRandomDendrDiaMin

	    //- and physical spines requested

	    && soSpineOptions.fSpineDensity != 0.0)
	{
	    //- do spine adjustments

	    SpineDoAdjustments(ppist,pD3segm);
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SpineDoAdjustments()
///
/// ARGS.:
///
///	ppist..: context of segment
///	pD3segm: segment candidate for spines
///
/// RTN..: int : TRUE : spines added, FALSE : no spines added
///
/// DESCR: Do spine adjustment on segment : add spines, update surface
///
///	See hines_read.c
///
/// **************************************************************************

static int SpineDoAdjustments
(struct PidinStack *ppist,struct symtab_D3Segment *pD3segm)
{
    //- set default result : ok

    int bResult = TRUE;

    double dLength;
    double dSpines;

    int iSpines = 0;

    //- if already doing spine adjustments

    if (svSpineVariables.iParserEventSpineCreation == 1)
    {
	//- return result

	return(FALSE);
    }

    //- get segment length

    dLength
	= SymbolParameterResolveValue
	  (&pD3segm->segment.bio.ioh.iol.hsle,"LENGTH",ppist);

    //- calculate surface for virtual spines and physical spines

    //! here we assume fSpineDensity has units spines/m
    //! probably better to get this into spines/m^2
    //!
    //! for now this is a compatibility issue with the old reader

    dSpines = dLength * soSpineOptions.fSpineDensity * 1e6;

    //- flag adding/creation of spines

    svSpineVariables.iParserEventSpineCreation = 1;

    //- if physical spine frequency set

    if (soSpineOptions.fSpineFrequency != 0.0)
    {
	//- add physical spines

	iSpines
	    = SpineCreateAndAdd
	      (svSpineVariables.phsleSpineProto,dSpines,ppist,pD3segm);
    }

    //- if there were any spines

    if (dSpines > 0)
    {
	//- get surface of segment

	double dSegment
	    = SymbolParameterResolveValue
	      (&pD3segm->segment.bio.ioh.iol.hsle,"SURFACE",ppist);

	if (dSegment == -1 || dSegment == FLT_MAX)
	{
	    fprintf
		(stderr,
		 "Purkinje spines : %s doesn't have a surface\n",
		 IdinName(SymbolGetPidin(&pD3segm->segment.bio.ioh.iol.hsle)));
	}

	//- recalculate segment surface

	dSegment
	    += (dSpines - iSpines)
	       * svSpineVariables.dSpineSurface;

	//- set new surface

	SymbolSetParameterDouble
	    (&pD3segm->segment.bio.ioh.iol.hsle,"SURFACE",dSegment);
    }

    //- increment spine count

    svSpineVariables.dAllSpines += dSpines;

    //- unflag adding/creation of spines

    svSpineVariables.iParserEventSpineCreation = 0;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SpineSegmentParserEventListener()
///
/// ARGS.:
///
///	std ParserEventListener args
///
/// RTN..: int : std ParserEventListener return value
///
/// DESCR: ParserEvent listener to attach spines
///
///	For cell type events, a new cell is registered, 
///	For segment type events, spines are attached to the 
///	registered cell.
///
/// **************************************************************************

static int SpineSegmentParserEventListener
(struct ParserEvent *pev,
 struct symtab_Algorithm *palg)
{
    //- set default result : ok

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
	    //t can we ever get here ?

	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- check for creation of spine prototype

	    if (SpineSegmentCheck
		(&pev->pist,(struct symtab_Segment *)pev->uInfo.phsle)
		== FALSE)
	    {
		bResult = FALSE;
	    }

	    break;
	}
	}

	break;
    }

    //- for cell

    case EVENT_TYPE_CELL:
    {
	//- look at event action

	switch (pev->iType & EVENT_MASK_ACTIONS)
	{
	//- if creation phase

	case EVENT_ACTION_CREATE:
	{
	    break;
	}

	//- if add phase

	case EVENT_ACTION_ADD:
	{
	    //- register cell as spine candidate

	    svSpineVariables.pcell = (struct symtab_Cell *)pev->uInfo.phsle;

	    // empty spine list

	    //HSolveListInit(&svSpineVariables.hslSpines);

	    // unregister the cell as spine candidate

	    //svSpineVariables.pcell = NULL;

	    //printf("%i spines added\n",svSpineVariables.iPhysicalSpines);

	    // empty spine list

	    //HSolveListInit(&svSpineVariables.hslSpines);

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
	     "Propagation of event type %i not implemented\n",
	     pev->iType);

	break;
    }
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SpineInitAlgorithm()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to init spine algorithm
///
/// **************************************************************************

static int SpineInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result : ok

    int bResult = TRUE;

    //- set parser context

    PARSERCONTEXT *pacContext = (PARSERCONTEXT *)pvGlobal;

    //- set init string (after '{')

    char *pcInit = &((char *)pvData)[1];

    //v argument seperator

    char pcSeperator[] = " \t,;/}";

    //v next arg

    char *pcArg = NULL;

    //v length of arg

    int iLength = -1;

    //- skip first white space

    pcArg = strpbrk(pcInit,pcSeperator);
    while (pcArg == pcInit)
    {
	pcInit++;
	pcArg = strpbrk(pcInit,pcSeperator);
    }

    //- get length for prototype name

    pcArg = strpbrk(pcInit,pcSeperator);

    iLength = pcArg - pcInit;

    //- scan prototype name

    soSpineOptions.pcRandomSpineProto
	= (char *)calloc(iLength + 1,sizeof(char));

    strncpy(soSpineOptions.pcRandomSpineProto,pcInit,iLength);

    soSpineOptions.pcRandomSpineProto[iLength] = '\0';

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan min dia

    soSpineOptions.fRandomDendrDiaMin = 1e-6 * strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    soSpineOptions.fRandomDendrDiaMax = 1e-6 * strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan min dia

    soSpineOptions.fSpineDensity = strtod(pcInit,&pcArg);

    //- go to next arg

    pcInit = &pcArg[1];

    //- scan max dia

    soSpineOptions.fSpineFrequency = strtod(pcInit,&pcArg);

    // go to next arg

    //pcInit = &pcArg[1];

    //- initialize spine count

    svSpineVariables.iPhysicalSpines = 0;
    svSpineVariables.dAllSpines = 0.0;

    //- if lookup prototype in symbol table

    svSpineVariables.phsleSpineProto
	= ParserLookupPrivateModel(soSpineOptions.pcRandomSpineProto);

    if (svSpineVariables.phsleSpineProto)
    {
	//v loops over sections

	struct symtab_HSolveListElement * phsleSection = NULL;

	//- get pointer to prototype

	struct symtab_HSolveListElement * phslePrototype
	    = svSpineVariables.phsleSpineProto;

	//- resolve dependencies for prototype

	phslePrototype = AliasResolve((struct symtab_Alias *)phslePrototype);

	//- initialize spine surface : 0.0

	svSpineVariables.dSpineSurface = 0.0;

	//- loop over sections in prototype

	phsleSection
	    = (struct symtab_HSolveListElement *)
	      HSolveListHead
	      (&((struct symtab_Vector *)phslePrototype)->bio.ioh.iohc);

	while (HSolveListValidSucc(&phsleSection->hsleLink))
	{
	    //- add surface of segment to surface of spine

	    svSpineVariables.dSpineSurface
		+= SymbolParameterResolveValue(phsleSection,"SURFACE",NULL);

	    //- go to next section

	    phsleSection
		= (struct symtab_HSolveListElement *)
		  HSolveListNext(&phsleSection->hsleLink);
	}
    }

    //- else

    else
    {
	//- set result : failure

	bResult = FALSE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SpinePrintInfo()
///
/// ARGS.:
///
///	std AlgorithmHandler args
///
/// RTN..: int : std AlgorithmHandler return value
///
/// DESCR: Algorithm handler to print info on serial segment algorithm
///
/// **************************************************************************

static int SpinePrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    //v loop var

    int i;

    struct symtab_IdentifierIndex *pidin
	= svSpineVariables.phsleSpineProto
	  ? SymbolGetPidin(svSpineVariables.phsleSpineProto)
	  : NULL ;

    char *pcSpine = pidin ? IdinName(pidin) : "No spine found";

    //- get pointer to file

    FILE * pfile = (FILE *)pvData;

    //- print info

    fprintf
	(pfile,
	 "\n\n"
	 "SpineAlgorithm : \n"
	 "-----------------\n"
	 "\tNumber of added/virtual spines : %i/%f\n",
	 svSpineVariables.iPhysicalSpines,
	 svSpineVariables.dAllSpines);

    fprintf(pfile,"\tSpine prototype : %s\n",pcSpine);

    fprintf
	(pfile,
	 "\tSpine surface : %g\n",
	 svSpineVariables.dSpineSurface);

/* //s */
/* //s spine variables */
/* //s */

/* struct SpineVariables_type */
/* { */
/*     //m current cell to add spines to */

/*     struct symtab_Cell *pcell; */

/*     //m symbol of prototype for random spines */

/*     struct symtab_HSolveListElement *phsleSpineProto; */

/*     /*m spine surface * */

/*     double dSpineSurface; */

/*     //m number of added spines for this cell */

/*     int iPhysicalSpines; */

/*     //m number of (physical + virtual) spines for this cell */

/*     double dAllSpines; */

/*     //m flags event generation for creation of spines */

/*     //! prevents infinite loops */

/*     int iParserEventSpineCreation; */
/* }; */

/* static SpineVariables svSpineVariables; */

    //- return result

    return(bResult);
}


