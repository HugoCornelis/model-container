//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: biocomp.c 1.98 Fri, 16 Nov 2007 18:22:20 -0600 hugo $
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



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/attachment.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


struct ChildPositionData
{
    /// current position, is serial ID

    int iPosition;

    /// symbol to search for

    struct symtab_HSolveListElement *phsle;

    /// context of symbol to look for

    struct PidinStack *ppist;

    /// found flag

    int bFound;
};


/// 
/// \arg pbio biocomponent to count spike generators for
/// \arg ppist context, biocomponent on top
/// 
/// \return int : number of spike generators in biocomponent, -1 for failure
/// 
/// \brief count spike generators in biocomponent
/// 

static int 
BioComponentSpikeGeneratorCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike generator counter

    int *piSpikeGens = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike generator

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted segments

	(*piSpikeGens)++;
    }

    //- return result

    return(iResult);
}

int BioComponentCountSpikeGenerators
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse segment symbol, counting spike generators

    if (SymbolTraverseSpikeGenerators
	(phsle, ppist, BioComponentSpikeGeneratorCounter, NULL, (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pbio biocomponent to count spike receivers for
/// \arg ppist context, biocomponent on top
/// 
/// \return int : number of spike receivers in biocomponent, -1 for failure
/// 
/// \brief count spike receivers in biocomponent
/// 

static int 
BioComponentSpikeReceiverCounter
(struct TreespaceTraversal *ptstr,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to spike receiver counter

    int *piSpikerecs = (int *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike receiver

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- add to counted segments

	(*piSpikerecs)++;
    }

    //- return result

    return(iResult);
}

int BioComponentCountSpikeReceivers
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse symbol, counting spike receivers

    if (SymbolTraverseSpikeReceivers
	(phsle, ppist, BioComponentSpikeReceiverCounter, NULL, (void *)&iResult)
	== FALSE)
    {
	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pbio bio component to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
BioComponentCreateAlias
(struct symtab_BioComponent *pbio,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : failure

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- must never be called I guess

    ((int *)0)[0] = 0;

/*     //- set name, namespace and prototype */

/*     BioComponentSetName(pbioResult, pidin); */
/*     BioComponentSetNamespace(pbioResult, pcNamespace); */
/*     BioComponentSetPrototype(pbioResult, pbio); */

/*     //- increment number of created aliases */

     /// \note this is left here in a comment for the code consistency checkers.

/*     SymbolIncrementAliases(HIERARCHY_TYPE_symbols_bio_comp); */

    //- return result

    return(phsleResult);
}


/// 
/// \arg pbio bio component to replace.
/// \arg iCount replacement count.
/// \arg phslResult created aliasses (must be empty).
/// 
/// \return int
/// 
///	Success of operation, if failed, you still have to empty the
///	result list.
/// 
///	phslResult.: created aliasses (must be empty).
/// 
/// \brief Create aliasses for a biocomponent.
///
/// \details 
/// 
///	The names of the created aliasses are a concatenation of the
///	original name, underscore, count, where count is 0 .. iCount.
/// 

int
BioComponentCreateAliasses
(struct symtab_BioComponent *pbio, int iCount, HSolveList *phslResult)
{
    //- set default result : ok

    int iResult = 1;

    //- loop over the requested count

    int i;

    for (i = 0 ; i < iCount ; i++)
    {
	//- construct a name for the new component

	struct symtab_IdentifierIndex *pidinAlias
	    = IdinCreateAlias(SymbolGetPidin(&pbio->ioh.iol.hsle), i);

	if (pidinAlias)
	{
	    //- create alias

	    struct symtab_HSolveListElement *phsleAlias
		= SymbolCreateAlias(&pbio->ioh.iol.hsle, NULL, pidinAlias);

	    if (!phsleAlias)
	    {
		/// \note memory leak: pcIdentifier of idin.

		IdinFree(pidinAlias);

		return(0);
	    }

	    //- link alias into list

	    HSolveListEntail(phslResult, &phsleAlias->hsleLink);
	}
	else
	{
	    return(0);
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pbio bio component.
/// \arg ppist context.
/// \arg iIndent Start indentation level.
/// \arg pfile output stream, NULL for default of stdout.
/// 
/// \return int success of operation.
/// 
/// \brief Export all parameters in YAML format to the given stream.
/// 

int
BioComponentExportParametersYAML
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 int iIndent,
 FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    struct symtab_ParContainer *pparc = pbio->pparc;

    if (!ParContainerExportYAML(pparc, ppist, 0, pfile))
    {
	return(0);
    }

    //- if prototype

    struct symtab_BioComponent * pbioPrototype
	= (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

    if (pbioPrototype)
    {
	//- export prototype parameters

	iResult
	    = BioComponentExportParametersYAML(pbioPrototype, ppist, 0, pfile);
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pbio segment to get Cm for
/// \arg pio input to search
/// 
/// \return struct symtab_HSolveListElement * : symbol generating given input
/// 
/// \brief Look for symbol that generates given input
/// 

struct symtab_HSolveListElement * 
BioComponentGetChildFromInput
(struct symtab_BioComponent *pbio,
 struct symtab_InputOutput *pio)
{
    //- set default result : not found

    struct symtab_HSolveListElement * phsleResult = NULL;

/*     //- if input has registered child */

/*     if (InputOutputHasSymbol(pio)) */
/*     { */
/* 	//- set result from symbol */

/* 	phsleResult = InputOutputGetSymbol(pio); */
/*     } */

/*     //- else */

/*     else */
    {
	//- convert field name to pidinstack

	struct PidinStack pist;

	PidinStackInit(&pist);

	PidinStackPushCompactAll(&pist, pio->pidinField);

	//- pop field, all element names remain

	(void)PidinStackPop(&pist);

	//- hierarchical lookup inside segment

	phsleResult
	    = SymbolLookupHierarchical(&pbio->ioh.iol.hsle, &pist, 0, TRUE);

	/// \todo not sure why this is necessary and where it could be used.
	/// \todo it is not used by the neurospaces-hsolve bridge (checked).

/* 	//- register the input symbol */

/* 	InputOutputSetSymbol(pio,phsleResult); */
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pbio component to get parameter for
/// \arg pcName name of parameter to search for
/// \arg ppist context of symbol
/// 
/// \return struct symtab_Parameters * : parameter, NULL for failure
/// 
/// \brief Get parameter with given name, guaranteed to be writable.
/// 

struct symtab_Parameters * 
BioComponentGetModifiableParameter
(struct symtab_BioComponent * pbio,
 char *pcName,
 struct PidinStack *ppist)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- lookup parameter

    struct symtab_Parameters *ppar
	= SymbolGetParameter(&pbio->ioh.iol.hsle, ppist, pcName);

    //- if not found

    if (!ppar)
    {
	//- return failure

	/// \note auto vivification of parameters must not be handled here

	return(NULL);
    }

    //- if parameter read-only

    /// \note this check does not allow to interfere with parameter caches.

    if (ParameterIsReadOnly(ppar))
    {
	//- copy parameter

	pparResult = calloc(1, sizeof(struct symtab_Parameters));

	memcpy(pparResult, ppar, sizeof(struct symtab_Parameters));

	//- enqueue copy in parameter list

	ParContainerInsert(pbio->pparc, pparResult);
    }

    //- else

    else
    {
	//- set result

	pparResult = ppar;
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pbio component to get parameter for
/// \arg ppist context of symbol
/// \arg pcName name of parameter to search for
/// 
/// \return struct symtab_Parameters * : parameter, NULL for failure
/// 
/// \brief Get parameter with given name
/// 

struct symtab_Parameters * 
BioComponentGetParameter
(struct symtab_BioComponent * pbio,
 struct PidinStack *ppist,
 char *pcName)
{
/*     if (ppist && !PidinStackIsRooted(ppist)) */
/*     { */
/* 	char pc[1000]; */

/* 	PidinStackString(ppist, pc, 1000); */

/* 	fprintf(stderr, "PidinStackIsRooted() failed for %s\n", pc); */

/* 	*(int *)0 = 0; */

/* 	exit(1); */
/*     } */

    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- lookup parameters value

    pparResult = ParContainerLookupParameter(pbio->pparc, pcName);

    //- if not found

    if (!pparResult)
    {
	//- if prototype

	struct symtab_BioComponent * pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if (pbioPrototype)
	{
	    //- lookup parameter for prototype

	    pparResult
		= BioComponentGetParameter(pbioPrototype, ppist, pcName);
	}
    }

    //- if not found

    if (!pparResult)
    {
	/// \todo default values should be implemented in parcontainer or in
	/// \todo parameter.  if done so, symbols without parameters can still
	/// \todo obtain default values using static calls.

	//- if coordinate parameter

	if ((pcName[0] == 'X' || pcName[0] == 'Y' || pcName[0] == 'Z')
	    && pcName[1] == '\0')
	{
	    static struct symtab_Parameters parX =
	    {
		/// link structures into list

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		TYPE_PARA_NUMBER,

		/// flags

		FLAG_PARA_READONLY,

		/// name of parameter

		"X",

		/// value : number, identifier or function for parameter

		{
		    0.0,
		},
	    };

	    static struct symtab_Parameters parY =
	    {
		/// link structures into list

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		TYPE_PARA_NUMBER,

		/// flags

		FLAG_PARA_READONLY,

		/// name of parameter

		"Y",

		/// value : number, identifier or function for parameter

		{
		    0.0,
		},
	    };

	    static struct symtab_Parameters parZ =
	    {
		/// link structures into list

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		TYPE_PARA_NUMBER,

		/// flags

		FLAG_PARA_READONLY,

		/// name of parameter

		"Z",

		/// value : number, identifier or function for parameter

		{
		    0.0,
		},
	    };

	    //- set result : defaults to equal to zero

	    pparResult
		= pcName[0] == 'X'
		  ? &parX
		  : pcName[0] == 'Y'
		    ? &parY 
		    : &parZ ;
	}

	//- if serial parameter

	else if (strcmp(pcName, "SERIAL") == 0)
	{
	    static struct symtab_Parameters parSerial =
	    {
		/// link structures into list

		NULL,

		/// first parameter of list

		NULL,

		/// type of parameter

		TYPE_PARA_NUMBER,

		/// flags

		FLAG_PARA_READONLY,

		/// name of parameter

		"SERIAL",

		/// value : serial from context

		{
		    INT_MAX,
		},
	    };

	    //- set value

	    parSerial.uValue.dNumber = PidinStackToSerial(ppist);

	    //- set result : defaults to equal to zero

	    pparResult = &parSerial;
	}
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pbio biological component to init
/// 
/// \return void
/// 
/// \brief Init biological component
/// 

void BioComponentInit(struct symtab_BioComponent * pbio)
{
    //- init base symbol

    IOHierarchyInit(&pbio->ioh);

    //- zero out own fields

    memset(&(&pbio->ioh)[1], 0, sizeof(*pbio) - sizeof(pbio->ioh));

    //- allocate parameter container

    pbio->pparc = ParContainerCalloc();
}


/// 
/// \arg pbio biological container to search
/// \arg pcInput name of input to search
/// \arg i sequential input number
/// 
/// \return struct symtab_InputOutput * : input, NULL if not found
/// 
/// \brief Get element attached to named input
///
/// \details 
/// 
///	Only one element is searched. No mixing of inputs from elements
///	and prototypes allowed yet.
/// 

struct symtab_InputOutput *
BioComponentLookupBindableIO
(struct symtab_BioComponent *pbio, char *pcInput, int i)
{
    //- set result : from this element

    struct symtab_InputOutput *pioResult
	= IOListLookupBindableIO(&pbio->ioh.iol, pcInput, i);

    //- if not found

    if (!pioResult)
    {
	/// \todo count number of I/O relations, subtract from i

	//- if prototype

	struct symtab_BioComponent *pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if (pbioPrototype)
	{
	    //- lookup I/O from prototype

	    pioResult = BioComponentLookupBindableIO(pbioPrototype, pcInput, i);
	}
    }

    //- return result

    return(pioResult);
}


/// 
/// \arg pbio biological container to search
/// \arg ppist name(s) to search
/// \arg iLevel active level of ppist
/// \arg bAll set TRUE if next entries in ppist have to be searched
/// 
/// \return struct symtab_HSolveListElement * :
/// 
///	found symbol, NULL for not found
/// 
/// \brief Hierarchical lookup in subsymbols
///
/// \details 
/// 
///	First tries to match with container itself, if fails, returns failure
///	If match and subsymbols requested (bAll), tries to match next names
///	with subsymbols of container. Subsymbols come from IO hierarchy or
///	from prototype.
/// 

struct symtab_HSolveListElement *
BioComponentLookupHierarchical
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 int iLevel,
 int bAll)
{
    //- set default result from super symbol

    struct symtab_HSolveListElement *phsleResult
	= IOHierarchyLookupHierarchical(&pbio->ioh,ppist, iLevel, bAll);

    //- if not found

    if (!phsleResult)
    {
	//- try search in prototype

	pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if (pbio)
	{
	    phsleResult
		= BioComponentLookupHierarchical(pbio, ppist, iLevel, bAll);
	}
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pbio biological component to print symbols for
/// \arg bAll TRUE == full list of symbols, FALSE == only given comp
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info for biological component
///
/// \details 
/// 

int BioComponentPrint
(struct symtab_BioComponent *pbio, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    /// section element

    struct symtab_HSolveListElement *phsle = NULL;

    /// algorithm info

    struct AlgorithmInstance *palgi = NULL;

    //- do indent

    PrintSymbolIndent(&pbio->ioh.iol.hsle, iIndent, pfile);

    //- name

    fprintf
	(pfile,
	 "Name, index (%s,%i)\n",
	 SymbolName(&pbio->ioh.iol.hsle)
	 ? SymbolName(&pbio->ioh.iol.hsle)
	 : "Undefined",
	 -1);

    /// \todo I/O relations
    /// \todo type/flags

    //- algorithm info

    palgi = SymbolGetAlgorithmInstanceInfo(&pbio->ioh.iol.hsle);

    if (palgi)
    {
	PrintSymbolIndent(&pbio->ioh.iol.hsle, iIndent, pfile);

	fprintf
	    (pfile,"AlgorithmInstance (%s)\n",AlgorithmInstanceGetName(palgi));
    }

    //- parameters

    ParContainerPrint(pbio->pparc, TRUE, iIndent + 4, pfile);

    //- do indent

    PrintSymbolIndent(&pbio->ioh.iol.hsle, iIndent, pfile);

    //- begin section header

    fprintf(pfile,"{-- begin HIER sections ---\n");

    //- loop over sections

    phsle
	= (struct symtab_HSolveListElement *)HSolveListHead(&pbio->ioh.iohc);

    while (HSolveListValidSucc(&phsle->hsleLink))
    {
	//- print symbol

	if (!SymbolPrint(phsle, iIndent + 4, pfile))
	{
	    bResult = FALSE;
	    break;
	}

	//- go to next section

	phsle
	    = (struct symtab_HSolveListElement *)
	      HSolveListNext(&phsle->hsleLink);
    }

    //- do indent

    PrintSymbolIndent(&pbio->ioh.iol.hsle, iIndent, pfile);

    //- end section header

    fprintf(pfile,"}--  end  HIER sections ---\n");

    //- print prototype

    pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

    if (pbio)
    {
	bResult = BioComponentPrint(pbio,bAll, iIndent + 4, pfile);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pbio biological component to resolve input for
/// \arg ppist context of given element
/// \arg pcParameter: name of parameter with function
/// \arg pcInput name of input on function of parameter
/// \arg iPosition input identifier in instantiation
/// 
/// \return struct symtab_HSolveListElement * : symbol that gives input
/// 
/// \brief Find input to functional parameter
///
/// \details 
/// 

struct symtab_HSolveListElement *
BioComponentResolveParameterFunctionalInput
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 char *pcParameter,
 char *pcInput,
 int iPosition)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- find parameter

    struct symtab_Parameters *ppar
	= SymbolGetParameter(&pbio->ioh.iol.hsle, ppist, pcParameter);

    //- set result

    if (ppar)
    {
	phsleResult = ParameterResolveFunctionalInput(ppar, ppist, pcInput, iPosition);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pbio symbol with phsleSearched as subsymbol
/// \arg ppist context of given element
/// \arg phsleSearched symbol to look for, must be NULL
/// \arg ppistSearched context of symbol to look for
/// 
/// \return int : serial ID of given child, -1 for not found
/// 
/// \brief Obtain a serial ID for given child
///
/// \details 
/// 
///	Serial ID's start at 1 for the children. pbio is supposed to have
///	serial ID 0, this allows simple arithmetic operations on the serial
///	IDs.
///	e.g. if pbio has serial ID 4 relative to pbioRoot and phsleSearched
///	has serial ID 5 relative to pbio, then phsleSearched has serial
///	ID 9 relative to pbioRoot.
/// 

static 
int
BioComponentContextChildCompare
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get position data

    struct ChildPositionData *pcpd = (struct ChildPositionData *)pvUserdata;

    //- if symbols match

    if (PidinStackEqual(ptstr->ppist, pcpd->ppist))
    {
	//- set result : abort

	iResult = TSTR_PROCESSOR_ABORT;

	//- register symbol has been found

	pcpd->bFound = TRUE;
    }

    //- else

    else
    {
	//- increment position count

	pcpd->iPosition++;
    }

    //- return result

    return(iResult);
}

int BioComponentLookupSerialID
(struct symtab_BioComponent *pbio,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsleSearched,
 struct PidinStack *ppistSearched)
{
    //- set default result : failure

    int iResult = -1;

    struct TreespaceTraversal *ptstr = NULL;

    //- set selector : all children should be selected

    TreespaceTraversalSelector *pfPreSelector = NULL;

    //- init child position data

    struct ChildPositionData cpd =
    {
	1,
	phsleSearched,
	ppistSearched,
	FALSE,
    };

    //- init treespace traversal

    ptstr
	= TstrNew
	  (ppist,
	   pfPreSelector,
	   NULL,
	   BioComponentContextChildCompare,
	   (void *)&cpd,
	   NULL,
	   NULL);

    //- traverse segment symbol

    iResult = TstrGo(ptstr, &pbio->ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- if found

    if (cpd.bFound)
    {
	//- set result : registered position

	iResult = cpd.iPosition;
    }

    //- else

    else
    {
	//- set result : not found

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pbio symbol to get parameter for.
/// \arg pcName name of parameter.
/// \arg ppistValue parameter value.
/// \arg ppist context of symbol (not used at the moment, can be changed).
/// 
/// \return struct symtab_Parameters * : parameter structure.
/// 
/// \brief Set parameter with given name.
///
/// \details 
/// 

struct symtab_Parameters * 
BioComponentSetParameterContext
(struct symtab_BioComponent * pbio,
 char *pcName,
 struct PidinStack *ppistValue/* , */
/* struct PidinStack *ppist */)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- convert context to queue

    struct symtab_IdentifierIndex *pidinQueue
	= PidinStackToPidinQueue(ppistValue);

    //- lookup parameters value

    pparResult = ParContainerLookupParameter(pbio->pparc, pcName);

    //- if not found

    if (!pparResult)
    {
	//- allocate new parameter for give name, value

	pparResult = ParameterNewFromPidinQueue(pcName, pidinQueue, TYPE_PARA_SYMBOLIC);

	if (!pparResult)
	{
	    /// \note note that a pidinQueue is allocated as one block

	    free(pidinQueue);

	    return(NULL);
	}

	//- insert new parameter

	ParContainerInsert(pbio->pparc, pparResult);
    }

    //- else

    else
    {
	//- update parameter value

	ParameterSetFieldName(pparResult, pidinQueue);
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pbio symbol to get parameter for.
/// \arg pcName name of parameter.
/// \arg dNumber parameter value.
/// \arg ppist context of symbol (not used at the moment, can be changed).
/// 
/// \return struct symtab_Parameters * : parameter structure.
/// 
/// \brief Set parameter with given name.
///
/// \details 
/// 

struct symtab_Parameters * 
BioComponentSetParameterDouble
(struct symtab_BioComponent * pbio,
 char *pcName,
 double dNumber/* , */
/* struct PidinStack *ppist */)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- lookup parameters value

    pparResult = ParContainerLookupParameter(pbio->pparc, pcName);

    //- if not found

    if (!pparResult)
    {
	//- allocate new parameter for give name,value

	pparResult = ParameterNewFromNumber(pcName, dNumber);

	if (!pparResult)
	{
	    return(NULL);
	}

	//- insert new parameter

	ParContainerInsert(pbio->pparc, pparResult);
    }

    //- else

    else
    {
	//- update parameter value

	ParameterSetNumber(pparResult, dNumber);
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pbio symbol to get parameter for.
/// \arg pcName name of parameter.
/// \arg pcValue parameter value.
/// \arg ppist context of symbol (not used at the moment, can be changed).
/// 
/// \return struct symtab_Parameters * : parameter structure.
/// 
/// \brief Set parameter with given name.
///
/// \details 
/// 

struct symtab_Parameters * 
BioComponentSetParameterString
(struct symtab_BioComponent * pbio,
 char *pcName,
 char *pcValue/* , */
/* struct PidinStack *ppist */)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- lookup parameters value

    pparResult = ParContainerLookupParameter(pbio->pparc, pcName);

    //- if not found

    if (!pparResult)
    {
	//- allocate new parameter for give name,value

	pparResult = ParameterNewFromString(pcName, pcValue);

	if (!pparResult)
	{
	    return(NULL);
	}

	//- insert new parameter

	ParContainerInsert(pbio->pparc, pparResult);
    }

    //- else

    else
    {
	//- update parameter value

	ParameterSetString(pparResult, pcValue);
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pbio symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse biological symbols in tree manner
///
/// \details 
/// 

int
BioComponentTraverse
(struct TreespaceTraversal *ptstr,
 struct symtab_BioComponent *pbio)
{
    //- set default result : ok

    int iResult = 1;

#ifdef PRE_PROTO_TRAVERSAL

    //- if prototype

    struct symtab_BioComponent *pbioProto
	= (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

    if (pbioProto)
    {
	//- traverse prototype

	iResult = BioComponentTraverse(ptstr, pbioProto);

	//- if failure or abort

	if (iResult == 0 || iResult == -1)
	{
	    //- return result

	    return(iResult);
	}
    }

    //- traverse IO hierarchy

    iResult = IOHierarchyTraverse(ptstr, &pbio->ioh);

#else

#ifdef POST_PROTO_TRAVERSAL

    //- loop over components in prototype list

    do
    {
	//- set result from IO hierarchy

	iResult = IOHierarchyTraverse(ptstr, &pbio->ioh);

	//- if failure or abort

	if (iResult == 0 || iResult == -1)
	{
	    //- break loop

	    break;
	}

	//- go to next prototype

	pbio = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	/// \todo add proto bio #SU to serial mappings in treespace traversal
    }
    while (pbio);

#else

#error You must define exactly one of \
    PRE_PROTO_TRAVERSAL / POST_PROTO_TRAVERSAL

#endif

#endif

    //- return result

    return(iResult);
}


/// 
/// \arg phsle symbol to traverse spike generators for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pfProcesor spike generator processor
/// \arg pfFinalizer spike receiver finalizer
/// \arg pvUserdata any user data
/// 
/// \return see TstrTraverse()
/// 
/// \brief Traverse spike generators, call pfProcessor on each of them
///
/// \details 
/// 

static int 
SymbolSpikeGeneratorSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if an attachment point

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle))
    {
	//- select this one to process

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

    //- return result

    return(iResult);
}


int
BioComponentTraverseSpikeGenerators
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolSpikeGeneratorSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbol

    iResult = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/// 
/// \arg phsle symbol to traverse spike receivers for
/// \arg ppist context of symbol, symbol assumed to be on top
/// \arg pfProcesor spike receiver processor
/// \arg pfFinalizer spike receiver finalizer
/// \arg pvUserdata any user data
/// 
/// \return see TstrTraverse()
/// 
/// \brief Traverse spike receivers, call pfProcessor on each of them
///
/// \details 
/// 

static int 
SymbolSpikeReceiverSelector
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_ONLY_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if an attachment point

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
    {
	//- select this one to process

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

    //- return result

    return(iResult);
}


int
BioComponentTraverseSpikeReceivers
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolSpikeReceiverSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse symbol

    iResult = TstrGo(ptstr, phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


