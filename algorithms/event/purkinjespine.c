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


/// \struct event associations for spine algorithm

static ParserEventListener SpineSegmentParserEventListener;

static ParserEventAssociation pevasSpines[] = 
{
    {
	/// listens to any segment event

	EVENT_TYPE_SEGMENT,

	/// function to call

	SpineSegmentParserEventListener,
    },
    {
	EVENT_TYPE_CELL,
	SpineSegmentParserEventListener,
    }
};


static ParserEventAssociationTable evatSpines =
{
    /// number of entries

    sizeof(*pevasSpines) / sizeof(ParserEventAssociation),

    /// event associations

    pevasSpines,
};


/// \struct algorithm handlers for spine algorithm

static AlgorithmHandler SpineInitAlgorithm;

static AlgorithmHandler SpinePrintInfo;

static struct AlgorithmHandlerLibrary pfSpineHandlers =
{
    /// after constructor, global is parser context, data is init string

    SpineInitAlgorithm,

    /// after init, before destruct

    NULL,

    /// print info handler

    SpinePrintInfo,
};


/// \struct algorithm description

static struct symtab_Algorithm modSpinesEvents =
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

    "Spines_with_events",

    /// algorithm handlers

    &pfSpineHandlers,

    /// event association table

    &evatSpines
};

struct symtab_Algorithm *palgSpinesEvents = &modSpinesEvents;


/// \struct spine algorithm private data

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


/// \struct
/// \struct spine variables
/// \struct

struct SpineVariables_type
{
    /// current cell to add spines to

    struct symtab_Cell *pcell;

    /// symbol of prototype for random spines

    struct symtab_HSolveListElement *phsleSpineProto;

    /*m spine surface */

    double dSpineSurface;

    /// number of added spines for this cell

    int iPhysicalSpines;

    /// number of (physical + virtual) spines for this cell

    double dAllSpines;

    /// flags event generation for creation of spines

    /// \note prevents infinite loops

    int iParserEventSpineCreation;
};

typedef struct SpineVariables_type SpineVariables;


static SpineVariables svSpineVariables;


// local functions

/// \structtatic int SpineAdd(struct symtab_HSolveListElement *phsle);

static int SpineCreateAndAdd
(struct symtab_HSolveListElement *phsle,
 double dSpines,
 struct PidinStack *ppist,
 struct symtab_D3Segment * pD3segm);

static int SpineDoAdjustments
(struct PidinStack *ppist,struct symtab_D3Segment *pD3segm);


/// 
/// 
/// \arg phsle spine prototype to use for created spines
/// \arg dSpines number of virtual spines
///	pD3segm.: segment to add spines to
/// \arg ppist context of segment
/// 
/// \return int : number of created spines
/// 
/// \brief Create spines and link them into a list
/// \details 
/// 
///	dSpines is the number of spines that influence the surface of the
///	segment if no physical spines would be added.
/// 

static int SpineCreateAndAdd
(struct symtab_HSolveListElement *phsle,
 double dSpines,
 struct PidinStack *ppist,
 struct symtab_D3Segment * pD3segm)
{
    //- set default result : no spines added

    int iResult = 0;

    /// segment

    char *pcSegment = NULL;
/*     int iSegment = -1; */

    /// name of segment

    struct symtab_IdentifierIndex * pidinName = NULL;

    /// proxy for new spine symbol table element

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
	/// prototype symbol with spine segments

	struct symtab_HSolveListElement *phsleSegms = phsle;

	//- resolve dependency symbols of spine prototype

	phsleSegms = AliasResolve((struct symtab_Alias *)phsleSegms);

	//- sanity check : if segment container

	if (instanceof_v_segment(phsleSegms))
	{
	    /// sections in spine segment container

	    struct symtab_HSolveListElement *phsleSection = NULL;

	    //- get pointer to segment container of spines

	    struct symtab_Vector *pvectContainer
		= (struct symtab_Vector *)phsleSegms;

	    //- construct context with this segment

	    struct PidinStack pistContainer = *ppist;

	    PidinStackPush(&pistContainer,pD3segm->segment.bio.pidinName);

	    //- add container element to context

	    /// \note still using private data here

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

		    /// \note because we generate a parser event here,
		    /// \note this algorithm should be derived from a parser algorithm

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
	/// prototype symbol with spine segments

	struct symtab_HSolveListElement *phsleSegms = phsle;

	//- resolve dependency symbols of spine prototype

	phsleSegms
	    = AliasResolve((struct symtab_Alias *)phsleSegms);

	//- sanity check : if segment container

	if (instanceof_v_segment(phsleSegms))
	{
	    /// sections in spine segment container

	    struct symtab_HSolveListElement *phsleSection = NULL;

	    //- get pointer to segment container of spines

	    struct symtab_Vector *pvectContainer
		= (struct symtab_Vector *)phsleSegms;

	    //- construct context with this segment

	    struct PidinStack pistContainer = *ppist;

	    PidinStackPush(&pistContainer,pD3segm->segment.bio.pidinName);

	    //- add container element to context

	    /// \note still using private data here

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

		    /// \note add event because parent segment is already added,
		    /// \note thus the spine is now already part of the model

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


/// 
/// 
/// \arg ppist context of segment
/// \arg psegment segment candidate for spines
/// 
/// \return int : success of operation
/// 
/// \brief Check if segment needs spines
/// \details 
/// 
///	See hines_read.c
/// 

static int SpineSegmentCheck
(struct PidinStack *ppist,struct symtab_Segment *psegment)
{
    //- set default result : ok

    int bResult = TRUE;

    /// segment parameters

    double dDia;
    double dLength;

    /// surface of all spines

    double dSpines = 0.0;

    //- cast segment to positioned segment

    /// \todo this hack should disappear if struct symtab_D3Segment is split
    /// \todo into D3 segment and segment enumeration
    /// \todo the code below still need adjustements

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
	  (&pD3segm->segment.bio.ioh.iol.hsle, ppist, "DIA");

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


/// 
/// 
/// \arg ppist context of segment
///	pD3segm: segment candidate for spines
/// 
/// \return int : TRUE : spines added, FALSE : no spines added
/// 
/// \brief Do spine adjustment on segment : add spines, update surface
/// \details 
/// 
///	See hines_read.c
/// 

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
	  (&pD3segm->segment.bio.ioh.iol.hsle, ppist, "LENGTH");

    //- calculate surface for virtual spines and physical spines

    /// \note here we assume fSpineDensity has units spines/m
    /// \note probably better to get this into spines/m^2
    ///
    /// \note for now this is a compatibility issue with the old reader

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
	      (&pD3segm->segment.bio.ioh.iol.hsle, ppist, "SURFACE");

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


/// 
/// 
/// \arg std ParserEventListener args
/// 
/// \return int  std ParserEventListener return value
/// 
/// \brief ParserEvent listener to attach spines
/// \details 
/// 
///	For cell type events, a new cell is registered, 
///	For segment type events, spines are attached to the 
///	registered cell.
/// 

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
	    /// \todo can we ever get here ?

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

	    /// \structvSpineVariables.pcell = NULL;

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to init spine algorithm
/// \details 
/// 

static int SpineInitAlgorithm
    (struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result  ok

    int bResult = TRUE;

    //- set parser context

    PARSERCONTEXT *pacContext = (PARSERCONTEXT *)pvGlobal;

    //- set init string (after '{')

    char *pcInit = &((char *)pvData)[1];

    /// argument seperator

    char pcSeperator[] = " \t,;/}";

    /// next arg

    char *pcArg = NULL;

    /// length of arg

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
	/// loops over sections

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
		+= SymbolParameterResolveValue(phsleSection, NULL, "SURFACE");

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


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on serial segment algorithm
/// \details 
/// 

static int SpinePrintInfo
(struct symtab_Algorithm *palgSelf,char *pcName,void *pvGlobal,void *pvData)
{
    //- set default result

    int bResult = TRUE;

    /// loop var

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

/* /// \struct */
/* /// \struct spine variables */
/* /// \struct */

/* struct SpineVariables_type */
/* { */
/*     /// current cell to add spines to */

/*     struct symtab_Cell *pcell; */

/*     /// symbol of prototype for random spines */

/*     struct symtab_HSolveListElement *phsleSpineProto; */

/*     /*m spine surface * */

/*     double dSpineSurface; */

/*     /// number of added spines for this cell */

/*     int iPhysicalSpines; */

/*     /// number of (physical + virtual) spines for this cell */

/*     double dAllSpines; */

/*     /// flags event generation for creation of spines */

/*     /// \note prevents infinite loops */

/*     int iParserEventSpineCreation; */
/* }; */

/* static SpineVariables svSpineVariables; */

    //- return result

    return(bResult);
}


