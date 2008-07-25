/* -*- c -*- */

/* swig -perl5 -makedefault -module Neurospaces neurospaces.i */
/* gcc -c neurospaces_wrap.c `perl -MExtUtils::Embed -e ccopts`  */
/* gcc -shared neurospaces_wrap.o -L. -lneurospaces -o neurospaces.so */

%module SwiggableNeurospaces

%typemap(in) void * {

    $1 = $input;
};

// This tells SWIG to treat char ** as a special case
%typemap(in) char ** {
	AV *tempav;
	I32 len;
	int i;
	SV  **tv;
	if (!SvROK($input))
	    croak("Argument $argnum is not a reference.");
        if (SvTYPE(SvRV($input)) != SVt_PVAV)
	    croak("Argument $argnum is not an array.");
        tempav = (AV*)SvRV($input);
	len = av_len(tempav);
	$1 = (char **) malloc((len+2)*sizeof(char *));
	for (i = 0; i <= len; i++) {
	    tv = av_fetch(tempav, i, 0);	
	    $1[i] = (char *) SvPV(*tv,PL_na);
        }
	$1[i] = NULL;
};

// This cleans up the char ** array after the function call
%typemap(freearg) char ** {
	free($1);
}

// Creates a new Perl array and places a NULL-terminated char ** into it
%typemap(out) char ** {
	AV *myav;
	SV **svs;
	int i = 0,len = 0;
	/* Figure out how many elements we have */
	while ($1[len])
	   len++;
	svs = (SV **) malloc(len*sizeof(SV *));
	for (i = 0; i < len ; i++) {
	    svs[i] = sv_newmortal();
	    sv_setpv((SV*)svs[i],$1[i]);
	};
	myav =	av_make(len,svs);
	free(svs);
        $result = newRV((SV*)myav);
        sv_2mortal($result);
        argvi++;
}

// perl variables are passed out unaltered
%typemap(out) SV * {
    $result = $1;

    //! not sure if this is correct and compatible

    argvi++;
}

// Now a few test functions
%inline %{
int print_args(char **argv) {
    int i = 0;
    while (argv[i]) {
         printf("argv[%d] = %s\n", i,argv[i]);
         i++;
    }
    return i;
}

// Returns a char ** list 
char **get_args() {
    static char *values[] = { "Dave", "Mike", "Susan", "John", "Michelle", 0};
    return &values[0];
}
%}


/* %typemap(ruby,in) (int size, int *ary) { */
/*    int i; */
/*    if (!rb_obj_is_kind_of($input,rb_cArray)) */
/*      rb_raise(rb_eArgError, "Expected Array of Integers"); */
/*    $1 = RARRAY($input)->len; */
/*    $2 = malloc($1*sizeof(int)); */
/*    for (i=0; i<$1; ++i) */
/*      ($2)[i] = NUM2INT(RARRAY($input)->ptr[i]); */
/* } */
/* %typemap(freearg) (int size, int *ary) { */
/*     if ($2) free($2); */
/* } */

/* %typemap(memberin) int [ANY] */
/* { */
/*     int i; */
/*     for (i = 0 ; i < $1_dim0 ; i++) */
/*     { */
/* 	$1[i] = $input[i]; */
/*     } */
/* } */

%{


#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithmsymbol.h"
#include "neurospaces/attachment.h"
#include "neurospaces/axonhillock.h"
#include "neurospaces/biocomp.h"
#include "neurospaces/biolevel.h"
#include "neurospaces/cell.h"
#include "neurospaces/channel.h"
#include "neurospaces/connection.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/equation.h"
#include "neurospaces/fiber.h"
#include "neurospaces/function.h"
#include "neurospaces/gatekinetic.h"
#include "neurospaces/group.h"
#include "neurospaces/hhgate.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/iocontainer.h"
#include "neurospaces/network.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/pool.h"
#include "neurospaces/population.h"
#include "neurospaces/positionD3.h"
#include "neurospaces/projection.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/randomvalue.h"
#include "neurospaces/segment.h"
#include "neurospaces/segmenter.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/traversalinfo.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/vector.h"
#include "neurospaces/vectorconnectionsymbol.h"
#include "neurospaces/vectorsegment.h"
#include "neurospaces/workload.h"

#include "neurospaces/symbolvirtual_protos.h"

#include "hierarchy/output/symbols/all_callees_headers.h"

%}

%inline %{


/// br2p derived

static
AV *
swigi_algorithms_2_array(struct Neurospaces *pneuro);

static
AV *
swigi_attachment_to_attachments_2_array
(struct Neurospaces *pneuro,
 struct symtab_HSolveListElement *phsleAttachment,
 struct PidinStack *ppistAttachment);

static
AV *
swigi_children_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

static
AV *
swigi_coordinates_2_array
    (struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iMode);

static
AV *
swigi_generators_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

static
AV *
swigi_parameters_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

static
AV *
swigi_projections_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

static
AV *
swigi_receivers_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

static
AV *
swigi_workload
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iNodes, int iLevel);

struct pq_traversal_data
{
    //m projection query

    struct ProjectionQuery *ppq;

    //m root context

    struct PidinStack *ppistRoot;

    //m root symbol

    struct symtab_HSolveListElement *phsleRoot;

    //m result array

    AV *pavConnections;
};


SV * parameter_2_SV(struct symtab_Parameters *ppar);

static int 
ConnectionTraverser
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok, but process sibling afterwards

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct pq_traversal_data *pqtd
	= (struct pq_traversal_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr);

    //- if connection

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	struct symtab_Connection *pconn = (struct symtab_Connection *)phsle;

	//t following code cannot work, although it should work.
	//t see ProjectionQueryTraverseConnectionsForSpikeGenerator()
	//t comments for projection queries with caching enabled.

/* 	//- get info on connection group (serial, context) */

/* 	int iConnectionGroup = TstrGetPrincipalSerial(ptstr); */

/* 	iConnectionGroup -= SymbolGetPrincipalSerialToParent(phsle); */

/* 	struct PidinStack *ppistConnectionGroup */
/* 	    = SymbolPrincipalSerial2Context(pqtd->phsleRoot, pqtd->ppistRoot, iConnectionGroup); */

/* 	char pcConnectionGroup[1000]; */

/* 	PidinStackString(ppistConnectionGroup, pcConnectionGroup, 1000); */

	//- default source and target are not set

	int iSource = 0;
	int iTarget = 0;

	//- if the projection query has not been loaded from a cache file

	if (pqtd->ppq->iCursor != 100000)
	{
	    //- set source and target

	    iSource = ProjectionQueryGetCurrentSourceSerial(pqtd->ppq);
	    iTarget = ProjectionQueryGetCurrentTargetSerial(pqtd->ppq);
	}

	//- get pre and post synaptic targets

	double dPre = SymbolParameterResolveValue(phsle, NULL, "PRE");
	double dPost = SymbolParameterResolveValue(phsle, NULL, "POST");

	//- compute generator and receiver

	int iGenerator = iSource + dPre;
	int iReceiver = iTarget + dPost;

	//- compute attributes (delay, weight)

	double dDelay = SymbolParameterResolveValue(phsle, NULL, "DELAY");
	double dWeight = SymbolParameterResolveValue(phsle, NULL, "WEIGHT");

	//- collect data about the generator

	struct PidinStack *ppistGenerator
	    = SymbolPrincipalSerial2Context(pqtd->phsleRoot, pqtd->ppistRoot, iGenerator);

	char pcGenerator[1000];

	PidinStackString(ppistGenerator, pcGenerator, 1000);

	//- collect data about the receiver

	struct PidinStack *ppistReceiver
	    = SymbolPrincipalSerial2Context(pqtd->phsleRoot, pqtd->ppistRoot, iReceiver);

	char pcReceiver[1000];

	PidinStackString(ppistReceiver, pcReceiver, 1000);

/* 	//- perlify connection info */

/* 	SV * psvGroupContext = newSVpv(pcConnectionGroup, 0); */
/* 	SV * psvGroupSerial = newSViv(iConnectionGroup); */

/* 	HV * phvConnectionGroup = newHV(); */

/* 	hv_store(phvConnectionGroup, "context", 7, psvGroupContext, 0); */
/* 	hv_store(phvConnectionGroup, "serial", 6, psvGroupSerial, 0); */

/* 	SV * psvConnectionGroup = newRV_noinc((SV *)phvConnectionGroup); */

	//- perlify attributes

	SV * psvDelay = newSVnv(dDelay);
	SV * psvWeight = newSVnv(dWeight);

	HV * phvAttributes = newHV();

	hv_store(phvAttributes, "delay", 5, psvDelay, 0);
	hv_store(phvAttributes, "weight", 6, psvWeight, 0);

	SV * psvAttributes = newRV_noinc((SV *)phvAttributes);

	//- perlify generator

	SV * psvGeneratorContext = newSVpv(pcGenerator, 0);
	SV * psvGeneratorSerial = newSViv(iGenerator);

	HV * phvGenerator = newHV();

	hv_store(phvGenerator, "context", 7, psvGeneratorContext, 0);
	hv_store(phvGenerator, "serial", 6, psvGeneratorSerial, 0);

	SV * psvGenerator = newRV_noinc((SV *)phvGenerator);

	//- perlify receiver

	SV * psvReceiverContext = newSVpv(pcReceiver, 0);
	SV * psvReceiverSerial = newSViv(iReceiver);

	HV * phvReceiver = newHV();

	hv_store(phvReceiver, "context", 7, psvReceiverContext, 0);
	hv_store(phvReceiver, "serial", 6, psvReceiverSerial, 0);

	SV * psvReceiver = newRV_noinc((SV *)phvReceiver);

	//- create tuple

	HV * phvConnection = newHV();

	hv_store(phvConnection, "attributes", 10, psvAttributes, 0);
	hv_store(phvConnection, "generator", 9, psvGenerator, 0);
/* 	hv_store(phvConnection, "group", 5, psvConnectionGroup, 0); */
	hv_store(phvConnection, "receiver", 8, psvReceiver, 0);

	SV * psvConnection = newRV_noinc((SV *)phvConnection);

	//- add tuple to the result

	av_push(pqtd->pavConnections, psvConnection);
    }

    //- else

    else
    {
	//- give diag's

	fprintf(stdout,"Non-connection in projection query (internal error)\n");
    }

    //- return result

    return(iResult);
}


static
AV *
swigi_algorithms_2_array(struct Neurospaces *pneuro)
{
    //- construct result

    AV * pavResult = newAV();

    AlgorithmSet * pas = pneuro->psym->pas;
    
    //- do not do anything for the moment with the algorithm classes

    struct AlgorithmClass * palgc
	= (struct AlgorithmClass *)HSolveListHead(&pas->hslClasses);

    //- loop through the instance list

    struct AlgorithmInstance * palgi
	= (struct AlgorithmInstance *)HSolveListHead(&pas->hslInstances);

    while (HSolveListValidSucc(&palgi->hsleLink))
    {
	//- if info handler available

/* 	if (palgi->ppfHandlers->pfPrintInfo) */
	{
	    //- algorithm class name

	    SV * psvClassName = newSVpv(!palgi->palgc ? "NULL" : palgi->palgc->pcIdentifier, 0);

	    //- algorithm instance name

	    SV * psvInstanceName = newSVpv(palgi->pcIdentifier, 0);

	    //- construct algorithm instance info

	    HV * phvInstance = newHV();

	    hv_store(phvInstance, "Class name", 10, psvClassName, 0);
	    hv_store(phvInstance, "Instance name", 13, psvInstanceName, 0);

	    SV * psvInstance = newRV_noinc((SV *)phvInstance);

	    //- add this algorithm to the result

	    av_push(pavResult, psvInstance);

/* 	    //- print algorithm info, remember result */

/* 	    bResult */
/* 		= bResult */
/* 		  && palgi->ppfHandlers->pfPrintInfo */
/* 		     (palgi,palgi->pcIdentifier,NULL,pfile); */
	}

	//- go to next element

	palgi = (struct AlgorithmInstance *)HSolveListNext(&palgi->hsleLink);
    }

    //- return result

    return(pavResult);
}


static
AV *
swigi_attachment_to_attachments_2_array
(struct Neurospaces *pneuro,
 struct symtab_HSolveListElement *phsleAttachment,
 struct PidinStack *ppistAttachment)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- if attachment

    if (!instanceof_attachment(phsleAttachment))
    {
	char pc[1000];

	PidinStackString(ppistAttachment, pc, 1000);

	printf("%s is not an attachment (type %i).\n", pc, phsleAttachment->iType);

	return(pavResult);
    }

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(NULL);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    //- if there is a projection query

    struct ProjectionQuery *ppq = pneuro->ppq;

    if (ppq)
    {
	struct pq_traversal_data qtd =
	    {
		//m projection query

		ppq,

		//m root context

		ppistRoot,

		//m root symbol

		phsleRoot,

		//m result array

		pavResult,
	    };

	//- if incoming attachment

	if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsleAttachment))
	{
	    //- traverse connections arriving on spike receiver

	    ProjectionQueryTraverseConnectionsForSpikeReceiver
		(ppq,
		 ppistAttachment,
		 ConnectionTraverser,
		 NULL,
		 (void *)&qtd);
	}

	//- if outgoing attachment

	else if (AttachmentPointIsOutgoing
		 ((struct symtab_Attachment *)phsleAttachment))
	{
	    //- traverse connection arriving on spike generator

	    ProjectionQueryTraverseConnectionsForSpikeGenerator
		(ppq,
		 ppistAttachment,
		 ConnectionTraverser,
		 NULL,
		 (void *)&qtd);
	}

    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_children_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- construct children info

    struct traversal_info ci =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_NAMES
	     | TRAVERSAL_INFO_TYPES
	     | TRAVERSAL_INFO_COORDS_LOCAL
	     | TRAVERSAL_INFO_COORDS_ABSOLUTE),

	    //m traversal method flags

	    0,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    0,

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   NULL,
	   NULL,
	   TraversalInfoCollectorProcessor,
	   (void *)&ci,
	   NULL,
	   NULL);

    //- traverse symbol

    int iTraverse = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if children found

    if (ci.iChildren)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < ci.iChildren; i++)
	{
	    //- copy name and type

	    SV * psvName = newSVpv(ci.ppcNames[i], 0);
	    SV * psvType = newSVpv(ci.ppcTypes[i], 0);

	    //- copy local coordinate

	    HV * phvCoordLocal = newHV();

	    SV * psvXLocal = newSVnv(ci.ppD3CoordsLocal[i]->dx);
	    SV * psvYLocal = newSVnv(ci.ppD3CoordsLocal[i]->dy);
	    SV * psvZLocal = newSVnv(ci.ppD3CoordsLocal[i]->dz);

	    hv_store(phvCoordLocal, "x", 1, psvXLocal, 0);
	    hv_store(phvCoordLocal, "y", 1, psvYLocal, 0);
	    hv_store(phvCoordLocal, "z", 1, psvZLocal, 0);

	    SV * psvCoordLocal = newRV_noinc((SV *)phvCoordLocal);

	    //- copy absolute coordinate

	    HV * phvCoordAbsolute = newHV();

	    SV * psvXAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dx);
	    SV * psvYAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dy);
	    SV * psvZAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dz);

	    hv_store(phvCoordAbsolute, "x", 1, psvXAbsolute, 0);
	    hv_store(phvCoordAbsolute, "y", 1, psvYAbsolute, 0);
	    hv_store(phvCoordAbsolute, "z", 1, psvZAbsolute, 0);

	    SV * psvCoordAbsolute = newRV_noinc((SV *)phvCoordAbsolute);

	    //- copy serial

	    SV * psvSerial = newSViv(ci.piSerials[i]);

	    //- create new empty perl array for this child

	    AV * pavChild = newAV();

	    av_push(pavChild, psvName);
	    av_push(pavChild, psvType);
	    av_push(pavChild, psvCoordLocal);
	    av_push(pavChild, psvCoordAbsolute);
	    av_push(pavChild, psvSerial);

	    //- add child info to result

	    SV * psvChild = newRV_noinc((SV *)pavChild);

 	    av_push(pavResult, psvChild);

/*  	    av_push(pavResult, psvName); */
	}
    }
    else
    {
	fprintf(stdout,"symbol has no children\n");
    }

    //- free allocated memory

    TraversalInfoFree(&ci);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_coordinates_2_array
    (struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iMode)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- construct children info

    struct traversal_info ci =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_NAMES
	     | TRAVERSAL_INFO_COORDS_LOCAL
	     | TRAVERSAL_INFO_COORDS_ABSOLUTE
	     | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT
	     | TRAVERSAL_INFO_TYPES),

	    //m traversal method flags

	    iMode == SELECTOR_BIOLEVEL_INCLUSIVE ? CHILDREN_TRAVERSAL_FIXED_RETURN : 0,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    iMode == SELECTOR_BIOLEVEL_INCLUSIVE ? TSTR_PROCESSOR_SUCCESS : 0,

/* 	    //m traversal method flags */

/* 	    0, */

/* 	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN */

/* 	    0, */

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    //t to get things to work with a network :
    //t implement SymbolTraverseSegments for
    //t a cell
    //t a population
    //t a network

    struct BiolevelSelection bls =
    {
	//m chained user data

	NULL,

	//m mode : exclusive, inclusive

	iMode,

	//m selected level

	iLevel,

	//m all levels follow, not used for now
    };

    int iSuccess
	= SymbolTraverseBioLevels
	  (phsle,
	   ppist,
	   &bls,
	   TraversalInfoCollectorProcessor,
	   NULL,
	   (void *)&ci);

    //- if children found

    if (iSuccess == 1 && ci.iChildren)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < ci.iChildren; i++)
	{
	    //- only for 'visible' children

	    //t replace with a generic call

	    if (strcmp(ci.ppcTypes[i], "segmen") == 0
		|| strcmp(ci.ppcTypes[i], "cell  ") == 0
		|| strcmp(ci.ppcTypes[i], "contou") == 0
		|| strcmp(ci.ppcTypes[i], "e_m_co") == 0
		|| strcmp(ci.ppcTypes[i], "fiber ") == 0
		|| strcmp(ci.ppcTypes[i], "popula") == 0
		|| strcmp(ci.ppcTypes[i], "networ") == 0
		|| strcmp(ci.ppcTypes[i], "random") == 0)
	    {
		//- copy serial and type

		SV * psvSerial = newSViv(ci.piSerials[i]);

		SV * psvType = newSVpv(ci.ppcTypes[i], 0);

		//- copy local coordinate

		HV * phvCoordLocal = newHV();

		SV * psvXLocal = newSVnv(ci.ppD3CoordsLocal[i]->dx);
		SV * psvYLocal = newSVnv(ci.ppD3CoordsLocal[i]->dy);
		SV * psvZLocal = newSVnv(ci.ppD3CoordsLocal[i]->dz);

		hv_store(phvCoordLocal, "x", 1, psvXLocal, 0);
		hv_store(phvCoordLocal, "y", 1, psvYLocal, 0);
		hv_store(phvCoordLocal, "z", 1, psvZLocal, 0);

		SV * psvCoordLocal = newRV_noinc((SV *)phvCoordLocal);

		//- process coordinates (segment and parent segment coordinates)

		HV *phvCoordinates = newHV();

		//- copy absolute coordinate

		HV * phvCoordAbsolute = newHV();

		SV * psvXAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dx);
		SV * psvYAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dy);
		SV * psvZAbsolute = newSVnv(ci.ppD3CoordsAbsolute[i]->dz);

		hv_store(phvCoordAbsolute, "x", 1, psvXAbsolute, 0);
		hv_store(phvCoordAbsolute, "y", 1, psvYAbsolute, 0);
		hv_store(phvCoordAbsolute, "z", 1, psvZAbsolute, 0);

		SV * psvCoordAbsolute = newRV_noinc((SV *)phvCoordAbsolute);

		hv_store(phvCoordinates, "this", 4, psvCoordAbsolute, 0);

		//- copy absolute coordinate of parent

		if (ci.ppD3CoordsAbsoluteParent[i]->dx != FLT_MAX)
		{
		    HV * phvCoordAbsoluteParent = newHV();

		    SV * psvXAbsoluteParent = newSVnv(ci.ppD3CoordsAbsoluteParent[i]->dx);
		    SV * psvYAbsoluteParent = newSVnv(ci.ppD3CoordsAbsoluteParent[i]->dy);
		    SV * psvZAbsoluteParent = newSVnv(ci.ppD3CoordsAbsoluteParent[i]->dz);

		    hv_store(phvCoordAbsoluteParent, "x", 1, psvXAbsoluteParent, 0);
		    hv_store(phvCoordAbsoluteParent, "y", 1, psvYAbsoluteParent, 0);
		    hv_store(phvCoordAbsoluteParent, "z", 1, psvZAbsoluteParent, 0);

		    SV * psvCoordAbsoluteParent = newRV_noinc((SV *)phvCoordAbsoluteParent);

		    hv_store(phvCoordinates, "parent", 6, psvCoordAbsoluteParent, 0);
		}

		SV * psvCoordinates = newRV_noinc((SV *)phvCoordinates);

		//- copy diameter value

		SV * psvDia = newSVnv(ci.pdDia[i]);

		//- copy name

		SV * psvName = newSVpv(ci.ppcNames[i], 0);

		//- create new empty perl array for this child

		AV * pavChild = newAV();

		av_push(pavChild, psvSerial);
		av_push(pavChild, psvType);
		av_push(pavChild, psvCoordLocal);
		av_push(pavChild, psvCoordinates);
		av_push(pavChild, psvDia);
		av_push(pavChild, psvName);

		//- add child info to result

		SV * psvChild = newRV_noinc((SV *)pavChild);

		av_push(pavResult, psvChild);
	    }
	}
    }
    else
    {
	if (iSuccess != 1)
	{
	    fprintf(stdout,"traversal preliminary aborted (internal error)\n");
	}
	else
	{
	    fprintf(stdout,"symbol has no children\n");
	}
    }

    //- free allocated memory

    TraversalInfoFree(&ci);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_generators_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- construct children info

    struct traversal_info ci =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_CONTEXTS),

	    //m traversal method flags

	    0,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    0,

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    //- traverse spike generators

    SymbolTraverseSpikeGenerators
	(phsle,
	 ppist,
	 TraversalInfoCollectorProcessor,
	 NULL,
	 (void *)&ci);

    //- if children found

    if (ci.iChildren)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < ci.iChildren; i++)
	{
	    //- copy serial

	    SV * psvSerial = newSViv(ci.piSerials[i]);

	    //- copy name and type

	    SV * psvContext = newSVpv(ci.ppcContexts[i], 0);

	    //- create new empty perl array for this child

	    AV * pavChild = newAV();

	    av_push(pavChild, psvContext);
	    av_push(pavChild, psvSerial);

	    //- add child info to result

	    SV * psvChild = newRV_noinc((SV *)pavChild);

 	    av_push(pavResult, psvChild);

/*  	    av_push(pavResult, psvName); */
	}
    }
    else
    {
	fprintf(stdout,"symbol has no generators\n");
    }

    //- free allocated memory

    TraversalInfoFree(&ci);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_parameters_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(NULL);
    }

    PidinStackSetRooted(ppistRoot);

    //- we did not report the parameters yet

    int iReported = 0;

    //- get parameters

    struct VectorParameters
    {
	//m number of parameters

	int iParameters;

	//m parameters

	struct symtab_Parameters *ppparameters[100];
    };


    struct VectorParameters vpars =
	{
	    //m number of parameters

	    0,

	    //m parameters

	    {
		NULL,
	    },
	};

    //- if this is a biological component

    //t the type can be externally defined, e.g. for vector connections,
    //t ie. simple connections

    if (instanceof_bio_comp(phsle))
    {
	//- loop over all prototypes including self

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	while (pbio)
	{
	    //- loop over parameters of this prototype

	    struct symtab_Parameters *ppar
		= ParContainerIterateParameters(pbio->pparc);

	    while (ppar)
	    {
		//- store this parameter

		vpars.ppparameters[vpars.iParameters] = ppar;

		vpars.iParameters++;

		//- go to next parameter

		ppar = ParContainerNextParameter(ppar);
	    }

	    //- go to next prototype

	    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);
	}
    }

    //- if this is an algorithm symbol

    else if (instanceof_algorithm_symbol(phsle))
    {
	//- loop over parameters

	struct symtab_AlgorithmSymbol *palgs
	    = (struct symtab_AlgorithmSymbol *)phsle;

	struct symtab_Parameters *ppar
	    = ParContainerIterateParameters(palgs->pparc);

	while (ppar)
	{
	    //- store this parameter

	    vpars.ppparameters[vpars.iParameters] = ppar;

	    vpars.iParameters++;

	    //- go to next parameter

	    ppar = ParContainerNextParameter(ppar);
	}

    }

    //- if this is a connection symbol

    else if (instanceof_connection_symbol(phsle))
    {
	//- get pre and post for connection

	HV * phvPre = newHV();

	SV * psvPreName = newSVpv("PRE", 0);

	hv_store(phvPre, "Name", 4, psvPreName, 0);

	int iPre = SymbolParameterResolveValue(phsle, NULL, "PRE");

	SV * psvPreValue = newSViv(iPre);

	hv_store(phvPre, "Value", 5, psvPreValue, 0);


	HV * phvPost = newHV();

	SV * psvPostName = newSVpv("POST", 0);

	hv_store(phvPost, "Name", 4, psvPostName, 0);

	int iPost = SymbolParameterResolveValue(phsle, NULL, "POST");

	SV * psvPostValue = newSViv(iPost);

	hv_store(phvPost, "Value", 5, psvPostValue, 0);


	//- get weight and delay

	HV * phvDelay = newHV();

	SV * psvDelayName = newSVpv("DELAY", 0);

	hv_store(phvDelay, "Name", 4, psvDelayName, 0);

	double dDelay = SymbolParameterResolveValue(phsle, NULL, "DELAY");

	SV * psvDelayValue = newSVnv(dDelay);

	hv_store(phvDelay, "Value", 5, psvDelayValue, 0);


	HV * phvWeight = newHV();

	SV * psvWeightName = newSVpv("WEIGHT", 0);

	hv_store(phvWeight, "Name", 4, psvWeightName, 0);

	double dWeight = SymbolParameterResolveValue(phsle, NULL, "WEIGHT");

	SV * psvWeightValue = newSVnv(dWeight);

	hv_store(phvWeight, "Value", 5, psvWeightValue, 0);


	//- store in result

	SV * psvPre = newRV_noinc((SV *)phvPre);
	SV * psvPost = newRV_noinc((SV *)phvPost);
	SV * psvDelay = newRV_noinc((SV *)phvDelay);
	SV * psvWeight = newRV_noinc((SV *)phvWeight);

	av_push(pavResult, psvPre);
	av_push(pavResult, psvPost);
	av_push(pavResult, psvDelay);
	av_push(pavResult, psvWeight);

	//- register that we reported the parameters

	iReported = 1;
    }
    else
    {
	//t error ?
    }

    //- if children found

    if (vpars.iParameters)
    {
	//- loop over the parameters found

	int i;

	for (i = 0; i < vpars.iParameters; i++)
	{
	    //- get name, type and value

	    SV * psvName = newSVpv(ParameterGetName(vpars.ppparameters[i]), 0);

	    int iType = ParameterGetType(vpars.ppparameters[i]);

	    SV * psvType = newSVpv(ppcParameterStructShort[iType], 0);

	    //- compute direct value

	    SV * psvDirect = parameter_2_SV(vpars.ppparameters[i]);

	    //- compute derived values : resolved value

	    double dResolved = ParameterResolveValue(vpars.ppparameters[i], ppist);

	    SV * psvResolved = NULL;

	    if (dResolved != FLT_MAX)
	    {
		psvResolved = newSVnv(dResolved);
	    }

	    //- compute derived values : scaled value

	    double dScaled = ParameterResolveScaledValue(vpars.ppparameters[i], ppist);

	    SV * psvScaled = NULL;

	    if (dScaled != FLT_MAX)
	    {
		psvScaled = newSVnv(dScaled);
	    }

	    //- store parameter info

	    HV * phvParameter = newHV();

	    hv_store(phvParameter, "Name", 4, psvName, 0);
	    hv_store(phvParameter, "Type", 4, psvType, 0);
	    hv_store(phvParameter, "Value", 5, psvDirect, 0);
	    psvResolved && hv_store(phvParameter, "Resolved Value", 14, psvResolved, 0);
	    psvScaled && hv_store(phvParameter, "Scaled Value", 12, psvScaled, 0);

	    SV * psvParameter = newRV_noinc((SV *)phvParameter);

	    //- add parameter to result

	    av_push(pavResult, psvParameter);
	}
    }
    else
    {
	if (!iReported)
	{
	    fprintf(stdout,"symbol has no parameters\n");
	}
    }

    PidinStackFree(ppistRoot);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_projections_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- construct children info

    struct traversal_info ci =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_CONTEXTS
	     | TRAVERSAL_INFO_TYPES),

	    //m traversal method flags

	    CHILDREN_TRAVERSAL_FIXED_RETURN,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    TSTR_PROCESSOR_SUCCESS,

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolProjectionSelector,
	   NULL,
	   TraversalInfoCollectorProcessor,
	   (void *)&ci,
	   NULL,
	   NULL);

    //- traverse symbol

    int iTraverse = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if children found

    if (ci.iChildren)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < ci.iChildren; i++)
	{
	    //- copy name and type

	    SV * psvContext = newSVpv(ci.ppcContexts[i], 0);
	    SV * psvType = newSVpv(ci.ppcTypes[i], 0);

	    //- copy serial

	    SV * psvSerial = newSViv(ci.piSerials[i]);

	    //- create new empty perl array for this child

	    AV * pavChild = newAV();

	    av_push(pavChild, psvContext);
	    av_push(pavChild, psvType);
	    av_push(pavChild, psvSerial);

	    //- add child info to result

	    SV * psvChild = newRV_noinc((SV *)pavChild);

 	    av_push(pavResult, psvChild);

/*  	    av_push(pavResult, psvName); */
	}
    }
    else
    {
	fprintf(stdout,"symbol has no projections\n");
    }

    //- free allocated memory

    TraversalInfoFree(&ci);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_receivers_2_array
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- construct children info

    struct traversal_info ci =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_CONTEXTS),

	    //m traversal method flags

	    0,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    0,

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    //- traverse spike generators

    SymbolTraverseSpikeReceivers
	(phsle,
	 ppist,
	 TraversalInfoCollectorProcessor,
	 NULL,
	 (void *)&ci);

    //- if children found

    if (ci.iChildren)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < ci.iChildren; i++)
	{
	    //- copy serial

	    SV * psvSerial = newSViv(ci.piSerials[i]);

	    //- copy name and type

	    SV * psvContext = newSVpv(ci.ppcContexts[i], 0);

	    //- create new empty perl array for this child

	    AV * pavChild = newAV();

	    av_push(pavChild, psvContext);
	    av_push(pavChild, psvSerial);

	    //- add child info to result

	    SV * psvChild = newRV_noinc((SV *)pavChild);

 	    av_push(pavResult, psvChild);

/*  	    av_push(pavResult, psvName); */
	}
    }
    else
    {
	fprintf(stdout,"symbol has no generators\n");
    }

    //- free allocated memory

    TraversalInfoFree(&ci);

    //- return resulting array

    return(pavResult);
}


static
AV *
swigi_workload
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iNodes, int iLevel)
{
    //- set default result : empty perl array

    AV * pavResult = newAV();

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(NULL);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    //- get cumulative workload

    struct workload_info *pwi
	= WorkloadNew(phsle, ppist, iLevel, TRAVERSAL_INFO_CONTEXTS);

    WorkloadPartition(pwi, iNodes);

    //- if workload_cumulative ok

    if (!pwi)
    {
	fprintf(stdout,"traversal failure (no workload ?)\n");

	return(pavResult);
    }

    struct traversal_info *pti = pwi->pti;

    if (0 && pti)
    {
	//- loop over the children found

	int i;

	for (i = 0; i < pti->iChildren; i++)
	{
	    //- copy local coordinate

	    HV * phvChild = newHV();

	    SV * psvSerial = newSViv(pti->piSerials[i]);

	    hv_store(phvChild, "serial", 6, psvSerial, 0);

/* 	    struct PidinStack *ppist */
/* 		= SymbolPrincipalSerial2Context(phsleRoot, ppistRoot, pti->piSerials[i]); */

	    SV * psvContext = newSVpv(pti->ppcContexts[i], 0);

	    hv_store(phvChild, "context", 7, psvContext, 0);

	    HV * phvWorkload = newHV();

	    SV * psvWorkloadIndividual = newSViv(pti->piWorkloadIndividual[i]);

	    hv_store(phvWorkload, "individual", 10, psvWorkloadIndividual, 0);

	    SV * psvWorkloadCumulative = newSViv(pti->piWorkloadCumulative[i]);

	    hv_store(phvWorkload, "cumulative", 10, psvWorkloadCumulative, 0);

	    SV * psvWorkload = newRV_noinc((SV *)phvWorkload);

	    hv_store(phvChild, "workload", 8, psvWorkload, 0);

	    //- add child info to result

	    SV * psvChild = newRV_noinc((SV *)phvChild);

	    av_push(pavResult, psvChild);
	}
    }
    else if (pwi)
    {
	//- construct workload report header

	HV * phvHeader = newHV();

	SV * psvWorkloadTotal = newSViv(pwi->iWorkloadTotal);

	hv_store(phvHeader, "Total workload", 14, psvWorkloadTotal, 0);

	SV * psvPartitions = newSViv(pwi->iPartitions);

	hv_store(phvHeader, "Number of partitions", 20, psvPartitions, 0);

	SV * psvWorkloadPartial = newSVnv(pwi->dWorkloadPartition);

	hv_store(phvHeader, "Partial workload", 16, psvWorkloadPartial, 0);

	SV * psvHeader = newRV_noinc((SV *)phvHeader);

	av_push(pavResult, psvHeader);

	//- loop over the partitions

	AV * pavChildren = newAV();

	int i;

	for (i = 0 ; i < pwi->iPartitions ; i++)
	{
	    HV * phvChild = newHV();

	    //- add the partition start serial

	    SV * psvSerial = newSViv(pwi->piPartitions[i]);

	    sv_catpvf(psvSerial, " -- %i", i + 1 < pwi->iPartitions ? pwi->piPartitions[i + 1] - 1 : -1);

	    hv_store(phvChild, "Serial Range", 12, psvSerial, 0);

	    //- add context for this serial

	    struct PidinStack *ppist
		= SymbolPrincipalSerial2Context(phsleRoot, ppistRoot, pwi->piPartitions[i]);

	    char pcContext[1000];

	    PidinStackString(ppist, pcContext, 1000);

	    SV * psvContext = newSVpv(pcContext, 0);

	    hv_store(phvChild, "Context", 7, psvContext, 0);

	    //- add the partition workload

	    SV * psvWorkload = newSViv(pwi->piWorkloads[i]);

	    hv_store(phvChild, "Workload", 8, psvWorkload, 0);

	    //- add child to the children array

	    SV * psvChild = newRV_noinc((SV *)phvChild);

	    av_push(pavChildren, psvChild);
	}

	//- add children info to result

	SV * psvChildren = newRV_noinc((SV *)pavChildren);

	av_push(pavResult, psvChildren);
    }
    else
    {
	fprintf(stdout,"traversal failure (no children ?)\n");
    }

    //- free allocated memory

    WorkloadFree(pwi);

    PidinStackFree(ppistRoot);

    //- return result

    return(pavResult);
}


SV * swig_attachment_to_connections(char *pcAttachment)
{
    //- attachment context

    struct PidinStack *ppistAttachment = PidinStackParse(pcAttachment);

    struct symtab_HSolveListElement *phsleAttachment = PidinStackLookupTopSymbol(ppistAttachment);

    printf("Getting attachments for %s\n", pcAttachment);

    extern struct Neurospaces *pneuroGlobal;

    AV * pavReceivers = swigi_attachment_to_attachments_2_array(pneuroGlobal, phsleAttachment, ppistAttachment);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavReceivers);

    return(psvResult);
}


int swig_context2serial(char *pcContext)
{
    struct PidinStack *ppist = PidinStackParse(pcContext);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    int iResult = PidinStackToSerial(ppist);

    return iResult;
}


SV * swig_get_algorithms(char *pcVoid)
{
    extern struct Neurospaces *pneuroGlobal;

    struct Neurospaces *pneuro = pneuroGlobal;

    if (!pneuroGlobal)
    {
	printf("pneuroGlobal\n");
    }

    //- create result

    AV * pavResult = swigi_algorithms_2_array(pneuroGlobal);

    SV * psvResult = newRV_noinc((SV *)pavResult);

    return(psvResult);
}


SV * swig_get_children(int iContext)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    //- get context

    struct PidinStack *ppistContext
	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iContext);

    //- get symbol under consideration

    struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext);

    if (!phsleContext)
    {
	PidinStackFree(ppistRoot);

	ppistRoot = NULL;

	PidinStackFree(ppistContext);

	ppistContext = NULL;

	printf("Unable to find this symbol, lookup failed (internal error).\n");

	return;
    }

    char pcContext[1000];

    PidinStackString(ppistContext,pcContext,1000);

    printf("Getting children from %s\n", pcContext);

    AV * pavChildren = swigi_children_2_array(phsleContext, ppistContext);

    //- free allocated memory

    PidinStackFree(ppistRoot);

    PidinStackFree(ppistContext);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavChildren);

    return(psvResult);
}


SV * swig_get_files()
{
    //- create result

    AV * pavResult = newAV();

    SV * psvResult = newRV_noinc((SV *)pavResult);

    //- get globally registered projection query

    extern struct Neurospaces *pneuroGlobal;

    struct Neurospaces *pneuro = pneuroGlobal;

    if (!pneuroGlobal)
    {
	printf("pneuroGlobal\n");
    }

    //m symbol table

    struct Symbols *pisSymbols = pneuroGlobal->psym;

    //- loop over the imported files

    struct ImportedFile *pifLoop
	= (struct ImportedFile *)
	  HSolveListHead(&pisSymbols->hslFiles);

    while (HSolveListValidSucc(&pifLoop->hsleLink))
    {
	//- get name of file

	SV * psvFilename = newSVpv(pifLoop->pcFilename, 0);

	//- add to result

	av_push(pavResult, psvFilename);

	//- go to next imported file

	pifLoop = (struct ImportedFile *)HSolveListNext(&pifLoop->hsleLink);
    }

    //- return result

    return psvResult;
}


SV * swig_get_generators(char *pcVoid)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    printf("Getting all generators\n");

    AV * pavGenerators = swigi_generators_2_array(phsleRoot, ppistRoot);

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavGenerators);

    return(psvResult);
}


SV * swig_get_namespaces(char *pcNamespace)
{
    //- create result

    AV * pavResult = newAV();

    //- get globally registered projection query

    extern struct Neurospaces *pneuroGlobal;

    struct Neurospaces *pneuro = pneuroGlobal;

    if (!pneuroGlobal)
    {
	printf("pneuroGlobal\n");
    }

    //- parse command line element

    struct PidinStack *ppist = PidinStackParse(pcNamespace);

    //- find namespace

    struct ImportedFile *pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

    //- if found

    if (pif)
    {
	//- get pointer to defined symbols in imported file

	struct DefinedSymbols *pdefsym
	    = ImportedFileGetDefinedSymbols(pif);

	//- loop over dependency files

	struct DependencyFile *pdf
	    = (struct DependencyFile *)
	      HSolveListHead(&pdefsym->hslDependencyFiles);

	if (HSolveListValidSucc(&pdf->hsleLink))
	{
	    while (HSolveListValidSucc(&pdf->hsleLink))
	    {
		//- get filename, namespace

		char *pcFilename = ImportedFileGetFilename(DependencyFileGetImportedFile(pdf));
		char *pcNamespace = DependencyFileGetNameSpace(pdf);

		//- put in result hash

		SV * psvFilename = newSVpv(pcFilename, 0);
		SV * psvNamespace = newSVpv(pcNamespace, 0);

		HV * phvDependencyFile = newHV();

		hv_store(phvDependencyFile, "filename", 8, psvFilename, 0);
		hv_store(phvDependencyFile, "namespace", 9, psvNamespace, 0);

		SV * psvDependencyFile = newRV_noinc((SV *)phvDependencyFile);

		av_push(pavResult, psvDependencyFile);

		//- goto next dependency file

		pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
	    }
	}
	else
	{
	    fprintf(stdout,"No namespaces\n");
	}

    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout,"no imported file with given namespace found\n");
    }

    //- free allocated memory

    PidinStackFree(ppist);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavResult);

    return psvResult;
}


SV * swig_get_parameters(int iContext)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return/* (NULL) */;
    }

    //- get context

    struct PidinStack *ppistContext
	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iContext);

    PidinStackFree(ppistRoot);

    ppistRoot = NULL;

    //- get symbol under consideration

    struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext);

    if (!phsleContext)
    {
	PidinStackFree(ppistRoot);

	ppistRoot = NULL;

	PidinStackFree(ppistContext);

	ppistContext = NULL;

	printf("Unable to find this symbol, lookup failed (internal error).\n");

	return;
    }

    char pcContext[1000];

    PidinStackString(ppistContext,pcContext,1000);

    printf("Getting parameters from %s\n", pcContext);

    AV * pavParameters = swigi_parameters_2_array(phsleContext, ppistContext);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavParameters);

/*     Inline_Stack_Vars; */
/*     Inline_Stack_Reset; */

/* #define ARRAY */
/* #ifdef ARRAY */

/*     I32 iMax = av_len(pavParameters); */

/*     I32 i; */

/*     for (i = 0; i <= iMax; i++) */
/*     { */
/* 	SV **ppsvParameter = av_fetch(pavParameters, i, 0); */

/* 	Inline_Stack_Push(*ppsvParameter); */
/*     } */

/* #else */

/*     SV * psvParameters = newRV_noinc((SV *)pavParameters); */

/*     Inline_Stack_Push(psvParameters); */

/* #endif */

/*     Inline_Stack_Done; */

    PidinStackFree(ppistRoot);

    ppistRoot = NULL;

    PidinStackFree(ppistContext);

    ppistContext = NULL;

    //- return resulting array

    return(psvResult);
}


SV * swig_get_projections(char *pcVoid)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    printf("Getting all projections\n");

    AV * pavProjections = swigi_projections_2_array(phsleRoot, ppistRoot);

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavProjections);

    return(psvResult);
}


SV * swig_get_receivers(char *pcVoid)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    printf("Getting all receivers\n");

    AV * pavReceivers = swigi_receivers_2_array(phsleRoot, ppistRoot);

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavReceivers);

    return(psvResult);
}


SV * swig_get_visible_coordinates(int iContext, int iLevel, int iMode)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    //- get context

    struct PidinStack *ppistContext
	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iContext);

    //- get symbol under consideration

    struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext);

    if (!phsleContext)
    {
	PidinStackFree(ppistRoot);

	ppistRoot = NULL;

	PidinStackFree(ppistContext);

	ppistContext = NULL;

	printf("Unable to find this symbol, lookup failed (internal error).\n");

	return;
    }

    char pcContext[1000];

    PidinStackString(ppistContext,pcContext,1000);

    printf("Getting children from %s\n", pcContext);

    AV * pavCoordinates = swigi_coordinates_2_array(phsleContext, ppistContext, iLevel, iMode);

    //- free allocated memory

    PidinStackFree(ppistRoot);

    PidinStackFree(ppistContext);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavCoordinates);

    return(psvResult);
}


SV * swig_get_workload(int iContext, int iNodes, int iLevel)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    //- get context

    struct PidinStack *ppistContext
	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iContext);

    //- get symbol under consideration

    struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext);

    if (!phsleContext)
    {
	PidinStackFree(ppistRoot);

	ppistRoot = NULL;

	PidinStackFree(ppistContext);

	ppistContext = NULL;

	printf("Unable to find this symbol, lookup failed (internal error).\n");

	return;
    }

    char pcContext[1000];

    PidinStackString(ppistContext,pcContext,1000);

    printf("Getting workload for %s\n", pcContext);

    AV * pavWorkload = swigi_workload(phsleContext, ppistContext, iNodes, iLevel);

    printf("Done workload for %s, %i entries\n", pcContext, av_len(pavWorkload));

    //- free allocated memory

    PidinStackFree(ppistRoot);

    PidinStackFree(ppistContext);

    //- return result

    SV * psvResult = newRV_noinc((SV *)pavWorkload);

    return(psvResult);
}


SV * swig_pq_get()
{
    //- create result

    HV * phvResult = newHV();

    SV * psvResult = newRV_noinc((SV *)phvResult);

    //- get globally registered projection query

    extern struct Neurospaces *pneuroGlobal;

    struct Neurospaces *pneuro = pneuroGlobal;

    if (!pneuroGlobal)
    {
	printf("pneuroGlobal\n");
    }

    struct ProjectionQuery *ppq = pneuro->ppq;

    if (!ppq)
    {
	printf("No projectionquery defined yet.\n");

	return(psvResult);
    }

    //- loop over projections

    AV * pavProjections = newAV();

    SV * psvProjections = newRV_noinc((SV *)pavProjections);

    int i;

    for (i = 0 ; i < ppq->iProjections ; i++)
    {
	//- create a hash for the current projection

	HV * phvProjection = newHV();

	//- context of this projection

	char pcContext[1000];

	PidinStackString(ppq->pppist[i], pcContext, 1000);

	SV * psvContext = newSVpv(pcContext, 0);

	hv_store(phvProjection, "context", 7, psvContext, 0);

	//- get serial

	int iSerial = PidinStackToSerial(ppq->pppist[i]);

	SV * psvSerial = newSViv(iSerial);

	hv_store(phvProjection, "serial", 6, psvSerial, 0);

	//- source of this projection

	SV * psvSource = newSViv(ppq->piSource[i]);

	hv_store(phvProjection, "source", 6, psvSource, 0);

	//- target of this projection

	SV * psvTarget = newSViv(ppq->piTarget[i]);

	hv_store(phvProjection, "target", 6, psvTarget, 0);

	//- add projection info to result

	SV * psvProjection = newRV_noinc((SV *)phvProjection);

	av_push(pavProjections, psvProjection);
    }

    //- create a hash for the cache

    HV * phvCache = newHV();

    SV * psvCache = newRV_noinc((SV *)phvCache);

    //- deal with caching entries

    if (ppq->bCaching)
    {
	//m connection cache

	struct ConnectionCache *pcc;

	//m connection cache sorted on pre synaptic principal

	struct OrderedConnectionCache *poccPre;

	//m connection cache sorted on post synaptic principal

	struct OrderedConnectionCache *poccPost;
    }

    //- store everything in the result

    hv_store(phvResult, "cache", 7, psvCache, 0);
/*     hv_store(phvResult, "connections", 11, psvConnections, 0); */
    hv_store(phvResult, "projections", 11, psvProjections, 0);

    //- return result

    return psvResult;
}


void swig_pq_set(char *pcLine)
{
    extern struct Neurospaces *pneuroGlobal;

    int bEOF = QueryMachineHandle(pneuroGlobal, pcLine);
}


/// traversal related

int
treespace_traversal_selector
(struct TreespaceTraversal *ptstr, void *pvUserdata);

int
treespace_traversal_processor
(struct TreespaceTraversal *ptstr, void *pvUserdata);

int
treespace_traversal_finalizer
(struct TreespaceTraversal *ptstr, void *pvUserdata);

typedef SV TreespaceTraversalProcessorPerl;

/* TreespacesTraversalSelector treespace_traversal_selector; */

/* TreespaceTraversalProcessor treespace_traversal_processor; */

/* TreespaceTraversalProcessor treespace_traversal_finalizer; */

struct traversal
{
    struct TreespaceTraversal *ptstr;
    
    void *pvPerlTraversal;
    void *pvSelector;
    void *pvProcessor;
    void *pvFinalizer;
};

/* int treespace_traversal_delete(struct traversal *pt) */
/* { */
/*     free(pt); */
/* } */


SV * objectify_context(struct PidinStack *ppistContext)
{
    //- get symbol under consideration

    struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext);

    if (!phsleContext)
    {
	printf("Unable to find this symbol, lookup failed (internal error).\n");

	return &PL_sv_undef;
    }

    int iContext = PidinStackToSerial(ppistContext);

    //- get serial of parent

    int iParent = iContext - SymbolGetPrincipalSerialToParent(phsleContext);

    //- construct perl value with serial

    SV * psvSerial = newSViv(iContext);

    //- construct perl value with parent serial

    SV * psvParent = newSViv(iParent);

    //- construct string with context

    char pcContext[10000];

    PidinStackString(ppistContext, pcContext, 10000);

    SV * psvContext = newSVpv(pcContext, 0);

    //- construct string with type

    SV * psvType = newSVpv(ppc_symbols_long_descriptions[phsleContext->iType], 0);

/*     fprintf(stdout, "Type is %s\n", ppc_symbols_long_descriptions[phsleContext->iType]); */

    //- construct the perl binding for the low level pointers

    //t construct this as a magic that points back to the swig table
    //t see SWIG_Perl_MakePtr() for how to do it (need to construct a tied hash)

    SV * obj_context = newSV(0);

    sv_setref_pv(obj_context, "SwiggableNeurospaces::PidinStack", ppistContext);

    SV * obj_symbol = newSV(0);

    sv_setref_pv(obj_symbol, "SwiggableNeurospaces::symtab_HSolveListElement", phsleContext);

    //- create result

    HV * phvResult = newHV();

    hv_store(phvResult, "_context", 8, obj_context, 0);
    hv_store(phvResult, "_symbol", 7, obj_symbol, 0);

    hv_store(phvResult, "context", 7, psvContext, 0);
    hv_store(phvResult, "parent", 6, psvParent, 0);
    hv_store(phvResult, "this", 4, psvSerial, 0);
    hv_store(phvResult, "type", 4, psvType, 0);

    SV * psvResult = newRV_noinc((SV *)phvResult);

    return psvResult;
}


/* SV * contextify_serial(int iSerial) */
/* { */
/*     //- root context */

/*     struct PidinStack *ppistRoot = PidinStackParse("/"); */

/*     struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot); */

/*     if (!phsleRoot) */
/*     { */
/* 	return(NULL); */
/*     } */

/*     //- get context */

/*     struct PidinStack *ppist */
/* 	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iSerial); */

/*     //- return context */

/*     return ppist; */
/* } */


SV * objectify_serial(int iSerial)
{
    //- root context

    struct PidinStack *ppistRoot = PidinStackParse("/");

    struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

    if (!phsleRoot)
    {
	return(NULL);
    }

    //- get context

    struct PidinStack *ppist
	= SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iSerial);

    //- return objectification for context

    return(objectify_context(ppist));
}


int
treespace_traversal_selector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
     //- set default result : continue with children, then post processing

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    struct traversal *pt = (struct traversal *)pvUserdata;

    if (pt->pvSelector
	&& SvROK((SV *)pt->pvSelector))
    {
	char pc[1000];

	PidinStackString(pt->ptstr->ppist, pc, 1000);

	dSP ;

	push_scope();
/* 	ENTER ; */
	SAVETMPS ;

	PUSHMARK(SP) ;
	XPUSHs(pt->pvPerlTraversal);
	XPUSHs(sv_2mortal(newSVpv(pc, 0)));
	PUTBACK ;

	//t G_EVAL ?

	I32 iCallbackResult = call_sv(pt->pvSelector, G_DISCARD | G_VOID);

	FREETMPS ;
	LEAVE ;

    }

    //- return result

    return(iResult);
}


int
treespace_traversal_processor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
     //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    struct traversal *pt = (struct traversal *)pvUserdata;

    if (pt->pvProcessor
	&& SvROK((SV *)pt->pvProcessor))
    {
/* 	int iSerial = PidinStackToSerial(pt->ptstr->ppist); */

	SV * psvObject = objectify_context(pt->ptstr->ppist);

	dSP ;

	push_scope();
/* 	ENTER ; */
	SAVETMPS ;

	PUSHMARK(SP) ;
	XPUSHs(pt->pvPerlTraversal);
	XPUSHs(sv_2mortal(psvObject));
	PUTBACK ;

	//t G_EVAL ?

	I32 iCallbackResult = call_sv(pt->pvProcessor, G_DISCARD | G_VOID);

	FREETMPS ;
	LEAVE ;

    }

    //- return result

    return(iResult);
}


int
treespace_traversal_finalizer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
     //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    struct traversal *pt = (struct traversal *)pvUserdata;

    if (pt->pvFinalizer
	&& SvROK((SV *)pt->pvFinalizer))
    {
	char pc[1000];

	PidinStackString(pt->ptstr->ppist, pc, 1000);

	dSP ;

	push_scope();
/* 	ENTER ; */
	SAVETMPS ;

	PUSHMARK(SP) ;
	XPUSHs(pt->pvPerlTraversal);
	XPUSHs(sv_2mortal(newSVpv(pc, 0)));
	PUTBACK ;

	//t G_EVAL ?

	I32 iCallbackResult = call_sv(pt->pvFinalizer, G_DISCARD | G_VOID);

	FREETMPS ;
	LEAVE ;

    }

    //- return result

    return(iResult);
}


SV * parameter_2_SV(struct symtab_Parameters *ppar)
{
    //- set default result: not defined

    SV * psvResult = &PL_sv_undef;

    if (ParameterIsNumber(ppar))
    {
	psvResult = newSVnv(ppar->uValue.dNumber);
    }
    else if (ParameterIsField(ppar)
	     || ParameterIsSymbolic(ppar))
    {
	char pcSymbol[100];

	IdinFullName(ppar->uValue.pidin, pcSymbol);

	psvResult = newSVpv(pcSymbol, 0);
    }
    else if (ParameterIsString(ppar))
    {
	char pcSymbol[1000];

	strncpy(pcSymbol, ParameterGetString(ppar), 999);

	pcSymbol[999] = '\0';

	psvResult = newSVpv(pcSymbol, 0);
    }

    else if (ParameterIsFunction(ppar))
    {
	//t this needs to be rewritten such that it uses
	//t recursion instead of code duplication.

	//- get an array for the function components

	AV * pavDirect = newAV();

	struct symtab_Function *pfun = ppar->uValue.pfun;

	//- store name

	SV * psvName = newSVpv(FunctionGetName(pfun), 0);

	av_push(pavDirect, psvName);

	//- loop over function parameters

	AV * pavParameters = newAV();

	struct symtab_Parameters *ppar
	    = ParContainerIterateParameters(pfun->pparc);

	while (ppar)
	{
	    //- get info of parameter

	    SV * psvName = newSVpv(ParameterGetName(ppar), 0);

	    int iType = ParameterGetType(ppar);

	    SV * psvType = newSVpv(ppcParameterStructShort[iType], 0);

	    SV * psvResult = &PL_sv_undef;

	    if (ParameterIsNumber(ppar))
	    {
		psvResult = newSVnv(ppar->uValue.dNumber);
	    }
	    else if (ParameterIsField(ppar)
		     || ParameterIsSymbolic(ppar))
	    {
		char pcSymbol[100];

		IdinFullName(ppar->uValue.pidin, pcSymbol);

		psvResult = newSVpv(pcSymbol, 0);
	    }
	    else
	    {
		//! YAML does not handle &PL_sv_undef well, so we first copy it.

		psvResult = newSVsv(psvResult);
	    }

	    //- store parameter info

	    HV * phvParameter = newHV();

	    hv_store(phvParameter, "Name", 4, psvName, 0);
	    hv_store(phvParameter, "Type", 4, psvType, 0);
	    hv_store(phvParameter, "Value", 5, psvResult, 0);
/* 			psvResolved && hv_store(phvParameter, "Resolved Value", 14, psvResolved, 0); */
/* 			psvScaled && hv_store(phvParameter, "Scaled Value", 12, psvScaled, 0); */

	    SV * psvParameter = newRV_noinc((SV *)phvParameter);

	    av_push(pavParameters, psvParameter);

	    //- go to next parameter

	    ppar = ParContainerNextParameter(ppar);
	}

	//- store parameter array

	SV * psvParameters = newRV_noinc((SV *)pavParameters);

	av_push(pavDirect, psvParameters);

	//- store parameter values

	psvResult = newRV_noinc((SV *)pavDirect);
    }
    else if (ParameterIsAttribute(ppar))
    {
	//! YAML does not handle &PL_sv_undef well, so we first copy it.

	psvResult = newSVsv(psvResult);
    }
    else
    {
	fprintf
	    (stdout,
	     "parameter_2_perl for unknown type (%i) not yet implemented.\n",
	     ParameterGetType(ppar));
    }

    //- return result

    return(psvResult);
}


SV * symbol_parameter_value(void *phsle, char *pc, void *ppist)
{
    if (!SvROK((SV *)phsle))
    {
	printf("In symbol_parameter_value(): could not dereference phsle\n");

	return(NULL);
    }

    if (!SvROK((SV *)ppist))
    {
	printf("In symbol_parameter_value(): could not dereference ppist\n");

	return(NULL);
    }

    //t from the Time::HiRes manpage, I conclude that this is close to
    //t the correct way of passing pointers around, including the casting:

    //t myNVtime = INT2PTR(double(*)(), SvIV(*svp));

    //t and the casts below, are a bit hacky, but probably mostly
    //t equivalent.

    phsle = (void *)SvIV(SvRV((SV *)phsle));

    ppist = (void *)SvIV(SvRV((SV *)ppist));

    //- get parameter

    struct symtab_Parameters *ppar = SymbolGetParameter(phsle, ppist, pc);

   //- convert to SV

    SV * psvResult = ppar ? parameter_2_SV(ppar) : NULL;

    //- return result

    return(psvResult);
}


double symbol_parameter_resolve_value(void *phsle, void *ppist, char *pc)
{
    if (!SvROK((SV *)phsle))
    {
	printf("In symbol_parameter_resolve_value(): could not dereference phsle\n");

	return(FLT_MAX);
    }

    if (!SvROK((SV *)ppist))
    {
	printf("In symbol_parameter_resolve_value(): could not dereference ppist\n");

	return(FLT_MAX);
    }

    //t see above on pointer casting

    phsle = (void *)SvIV(SvRV((SV *)phsle));

    ppist = (void *)SvIV(SvRV((SV *)ppist));

    return SymbolParameterResolveValue(phsle, ppist, pc);
}


double symbol_parameter_resolve_scaled_value(void *phsle, void *ppist, char *pc)
{
    if (!SvROK((SV *)phsle))
    {
	printf("In symbol_parameter_resolve_scaled_value(): could not dereference phsle\n");

	return(FLT_MAX);
    }

    if (!SvROK((SV *)ppist))
    {
	printf("In symbol_parameter_resolve_scaled_value(): could not dereference ppist\n");

	return(FLT_MAX);
    }

    //t see above on pointer casting

    phsle = (void *)SvIV(SvRV((SV *)phsle));

    ppist = (void *)SvIV(SvRV((SV *)ppist));

    return SymbolParameterResolveScaledValue(phsle, ppist, pc);
}


%}


%include ../neurospaces.i

%include "neurospaces/algorithminstance.h"
%include "neurospaces/algorithmsymbol.h"
%include "neurospaces/attachment.h"
%include "neurospaces/axonhillock.h"
%include "neurospaces/biocomp.h"
%include "neurospaces/biolevel.h"
%include "neurospaces/cell.h"
%include "neurospaces/channel.h"
%include "neurospaces/connection.h"
%include "neurospaces/dependencyfile.h"
%include "neurospaces/equation.h"
%include "neurospaces/fiber.h"
%include "neurospaces/function.h"
%include "neurospaces/gatekinetic.h"
%include "neurospaces/group.h"
%include "neurospaces/hhgate.h"
%include "neurospaces/idin.h"
%include "neurospaces/importedfile.h"
%include "neurospaces/inputoutput.h"
%include "neurospaces/iocontainer.h"
%include "neurospaces/network.h"
%include "neurospaces/neurospaces.h"
%include "neurospaces/parameters.h"
%include "neurospaces/parsersupport.h"
%include "neurospaces/pidinstack.h"
%include "neurospaces/pool.h"
%include "neurospaces/population.h"
%include "neurospaces/positionD3.h"
%include "neurospaces/projection.h"
%include "neurospaces/querymachine.h"
%include "neurospaces/randomvalue.h"
%include "neurospaces/segment.h"
%include "neurospaces/segmenter.h"
%include "neurospaces/solverinfo.h"
%include "neurospaces/symbols.h"
%include "neurospaces/symboltable.h"
%include "neurospaces/treespacetraversal.h"
%include "neurospaces/vector.h"
%include "neurospaces/vectorconnectionsymbol.h"
%include "neurospaces/vectorsegment.h"
%include "neurospaces/workload.h"

%include "neurospaces/symbolvirtual_protos.h"

%include "hierarchy/output/symbols/all_callees_headers.i"

