//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parameters.c 1.71 Sat, 10 Nov 2007 17:28:42 -0600 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>


#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/iol.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"


int iINT_MAX = INT_MAX;

double dFLT_MAX = FLT_MAX;


char *ppcParameterStruct[] =
{
    "Invalid parameter type value",
    "TYPE_PARA_SYMBOLIC",
    "TYPE_PARA_NUMBER",
    "TYPE_PARA_FUNCTION",
    "TYPE_PARA_FIELD",
    "TYPE_PARA_ATTRIBUTE",
    "TYPE_PARA_STRING",
    NULL
};


char *ppcParameterStructShort[] =
{
    "Invalid",
    "SYMBOL ",
    "NUMBER ",
    "FUNCT  ",
    "FIELD  ",
    "ATTR   ",
    "STRING ",
    NULL
};


/// **************************************************************************
///
/// SHORT: ParameterCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Parameters * 
///
///	Newly allocated parameters, NULL for failure
///
/// DESCR: Allocate a new parameters symbol table element
///
/// **************************************************************************

struct symtab_Parameters * ParameterCalloc(void)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- allocate parameter

    pparResult
	= (struct symtab_Parameters *)
	  calloc(1,sizeof(struct symtab_Parameters));

    //- return result

    return(pparResult);
}



///
///
///
struct symtab_Function * 
ParameterContextGetFunction(struct symtab_Parameters *ppar, struct PidinStack *ppist)
{


    if (!ParameterIsField(ppar))
    {
	return NULL;
    }

    //t pcFieldname = ParameterGetFieldName(ppar)
    //t ppistPar1 = ppist
    //t while ParameterIsField(ppar)
    //t   ppistPar2 = ParameterResolveToPidinStack(ppar, ppistPar1)
    //t   phsle = PidinStackLookupTopSymbol(ppistPar2)
    //t   ppar = SymbolFindParameter(phsle, ppistPar2, pcFieldname)
    //t
    //t PidinStackFree(ppistPar2)
    //t if ParameterIsFunction(ppar)
    //t   return 1
    //t else
    //t   return 0
  
    struct PidinStack *ppistPar1 = ppist;

    while (ParameterIsField(ppar))
    {
	struct PidinStack *ppistPar2 = ParameterResolveToPidinStack(ppar,ppistPar1);

	struct symtab_HSolveListElement *phsle2 = PidinStackLookupTopSymbol(ppistPar2);

	char *pcFieldname = ParameterGetFieldName(ppar);

	ppar = SymbolFindParameter(phsle2,ppistPar2,pcFieldname);

	ppistPar1 = PidinStackDuplicate(ppistPar2);

	PidinStackFree(ppistPar2);
    }

    PidinStackFree(ppistPar1);

    if (ParameterIsFunction(ppar))
    {
	return ParameterGetFunction(ppar);
    }

    return NULL;
}






/// **************************************************************************
///
/// SHORT: ParameterFree()
///
/// ARGS.:
///
///	ppar...: parameter
///
/// RTN..: void
///
/// DESCR: Free memory of given parameters.
///
/// **************************************************************************

void ParameterFree(struct symtab_Parameters *ppar)
{
    //- look at parameter type

    switch (ppar->iType)
    {
	//- if parameter with symbolic value in idin

    case TYPE_PARA_SYMBOLIC:
    {
	//t free idin set

/* 	    IdinFree(ppar->uValue.pidin); */

	break;
    }

    //- if parameter with numeric value in dNumber

    case TYPE_PARA_NUMBER:
    {
	//- nothing

	break;
    }

    //- if parameter with functional value in pidinFunction

    case TYPE_PARA_FUNCTION:
    {
	//t free function set

/* 	    FunctionFree(ppar->uValue.pfun); */

	break;
    }

    //- if parameter for attribute, can have optionally a value in uValue

    case TYPE_PARA_ATTRIBUTE:
    {
	//t free idin set

/* 	    if (ppar->uValue.pidin) IdinFree(ppar->uValue.pidin); */

	break;
    }
    }

    //- if name

    if (ppar->pcIdentifier)
    {
	free(ppar->pcIdentifier);
    }

    //- free parameter struct

    free(ppar);
}


/// **************************************************************************
///
/// SHORT: ParameterGetFieldPidin()
///
/// ARGS.:
///
///	ppar...: parameter
///
/// RTN..: char * : name of referenced field, NULL for none
///
/// DESCR: Get field name of referenced field
///
/// **************************************************************************

struct symtab_IdentifierIndex *
ParameterGetFieldPidin(struct symtab_Parameters *ppar)
{
    //- set default result : none

    struct symtab_IdentifierIndex *pidinResult = NULL;

    //- if parameter contains field specification

    if (ParameterIsField(ppar))
    {
	//- loop over idins

	pidinResult = ppar->uValue.pidin;

	while (pidinResult && pidinResult->pidinNext)
	{
	    //- go to next pidin

	    pidinResult = pidinResult->pidinNext;
	}
    }

    //- return result

    return(pidinResult);
}


/// **************************************************************************
///
/// SHORT: ParameterGetString()
///
/// ARGS.:
///
///	ppar.....: parameter to obtain string from.
///
/// RTN..: char *
///
///	string value, NULL for failure.
///
/// DESCR: Get string from parameter.
///
/// **************************************************************************

char * ParameterGetString(struct symtab_Parameters *ppar)
{
    //- set default result: failure

    char *pcResult = NULL;

    //- if string present

    if (ParameterIsString(ppar))
    {
	//- set result

	pcResult = ppar->uValue.pcString;
    }

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: ParameterLookup()
///
/// ARGS.:
///
///	ppar...: parameter list to search
///	pcName.: name of parameter to lookup
///
/// RTN..: struct symtab_Parameters * : parameter, NULL for failure
///
/// DESCR: Search for named parameter
///
/// **************************************************************************

struct symtab_Parameters * ParameterLookup
(struct symtab_Parameters * ppar, char *pcName)
{
    //- set default result : not found

    struct symtab_Parameters *pparResult = NULL;

    //- loop over parameters

    while (ppar)
    {
	//- if names match

	if (strcmp(ParameterGetName(ppar), pcName) == 0)
	{
	    //- set result

	    pparResult = ppar;

	    //- break loop

	    break;
	}

	//- go to next parameter

	ppar = ppar->pparNext;
    }

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: ParameterNewFromFunction()
///
/// ARGS.:
///
///	pcName..: name of parameter, will be copied.
///	pfun....: function that generates the parameter value.
///
/// RTN..: struct symtab_Parameters *
///
///	New parameter, NULL for failure.
///
/// DESCR: Allocate parameter that depends on the given function.
///
/// **************************************************************************

struct symtab_Parameters *
ParameterNewFromFunction
(char *pcName, struct symtab_Function *pfun)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    char *pc = NULL;

    //- allocate parameter

    pparResult = ParameterCalloc();

    //- prepare name

    pc = (char *)calloc(1 + strlen(pcName), sizeof(char));

    strcpy(pc, pcName);

    //- fill up structure

    ParameterSetName(pparResult, pc);

    ParameterSetFunction(pparResult, pfun);

    pparResult->pparFirst = pparResult;

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: ParameterNewFromNumber()
///
/// ARGS.:
///
///	pcName..: name of parameter, will be copied.
///	dNumber.: value.
///
/// RTN..: struct symtab_Parameters *
///
///	New parameter.
///
/// DESCR: Allocate parameter for double value and initialize.
///
/// **************************************************************************

struct symtab_Parameters * 
ParameterNewFromNumber
(char *pcName, double dNumber)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    char *pc = NULL;

    //- allocate parameter

    pparResult = ParameterCalloc();

    //- prepare name

    pc = (char *)calloc(1 + strlen(pcName), sizeof(char));

    strcpy(pc, pcName);

    //- fill up structure

    ParameterSetName(pparResult, pc);

    ParameterSetNumber(pparResult, dNumber);

    pparResult->pparFirst = pparResult;

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: ParameterNewFromPidinQueue()
///
/// ARGS.:
///
///	pcName..: name of parameter, will be copied.
///	pidin...: pidin queue, list used as queue.
///	iType...: type of parameter (symbolic or field).
///
/// RTN..: struct symtab_Parameters *
///
///	New parameter
///
/// DESCR: Allocate symbolic parameter for given pidin queue (list).
///
/// **************************************************************************

struct symtab_Parameters * 
ParameterNewFromPidinQueue
(char *pcName, struct symtab_IdentifierIndex *pidin, int iType)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    char *pc = NULL;

    //- allocate parameter

    pparResult = ParameterCalloc();

    //- prepare name

    pc = (char *)calloc(1 + strlen(pcName), sizeof(char));

    strcpy(pc, pcName);

    //- fill up structure

    ParameterSetType(pparResult, iType);

    ParameterSetName(pparResult, pcName);

    pparResult->uValue.pidin = pidin;
    pparResult->pparFirst = pparResult;

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: ParameterNewFromString()
///
/// ARGS.:
///
///	pcName..: name of parameter, will be copied.
///	pcValue.: value
///
/// RTN..: struct symtab_Parameters *
///
///	New parameter.
///
/// DESCR: Allocate parameter for string value and initialize.
///
/// **************************************************************************

struct symtab_Parameters * 
ParameterNewFromString
(char *pcName, char *pcValue)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    char *pc = NULL;

    //- allocate parameter

    pparResult = ParameterCalloc();

    //- prepare name

    pc = (char *)calloc(1 + strlen(pcName), sizeof(char));

    strcpy(pc, pcName);

    //- fill up structure

    ParameterSetName(pparResult, pc);

    ParameterSetString(pparResult, pcValue);

    pparResult->pparFirst = pparResult;

    //- return result

    return(pparResult);
}


/// **************************************************************************
///
/// SHORT: ParameterPrint()
///
/// ARGS.:
///
///	ppar.....: parameter to print symbols for
///	bAll.....: TRUE print full list, FALSE print only given parameter
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Print symbol info for parameter
///
/// **************************************************************************

#define PrintParameterIndent(iIndent,pfile)				\
do									\
{									\
    PrintIndent(iIndent,pfile);						\
    fprintf(pfile,"PARA  ");						\
}									\
while (0)								\

int ParameterPrint
(struct symtab_Parameters *ppar, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //v section element

    struct symtab_HSolveListElement *phsle = NULL;

    //- loop over parameters

    while (bAll && ppar)
    {
	//- do indent

	PrintParameterIndent(iIndent, pfile);

	//- name

	fprintf
	    (pfile,
	     "Name (%s)\n",
	     ParameterGetName(ppar));

	//- do indent

	PrintParameterIndent(iIndent, pfile);

	//- print parameter type

	fprintf
	    (pfile,
	     "Type (%s), ",
	     ParameterTypeDescribe(ppar->iType));

	//- look at parameter type, print parameter value

	switch (ppar->iType)
	{
	case TYPE_PARA_SYMBOLIC:
	case TYPE_PARA_FIELD:
	{
	    struct PidinStack *ppist = PidinStackCalloc();

	    PidinStackPushAll(ppist, ppar->uValue.pidin);

/* 	    fprintf */
/* 		(pfile, */
/* 		 "Value : (first idin = '%s%s') | ", */
/* 		 IdinIsRooted(ppar->uValue.pidin) ? "/" : "", */
/* 		 IdinName(ppar->uValue.pidin)); */

	    fprintf(pfile,"Value : ");

	    PidinStackPrint(ppist, pfile);

	    PidinStackFree(ppist);

	    fprintf(pfile, "\n");
	    break;
	}
	case TYPE_PARA_NUMBER:
	{
	    fprintf(pfile,"Value(%e)\n", ppar->uValue.dNumber);
	    break;
	}
	case TYPE_PARA_FUNCTION:
	{
	    //- print function

	    fprintf(pfile,"Value(%s)\n", FunctionGetName(ppar->uValue.pfun));

	    bResult
		=  FunctionPrint(ppar->uValue.pfun, bAll, iIndent + 4, pfile);

	    break;
	}
	case TYPE_PARA_ATTRIBUTE:
	{
	    fprintf(pfile, "\n");
	    break;
	}
	}

	//- go to next parameter

	ppar = ppar->pparNext;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ParameterResolveFunctionalInput()
///
/// ARGS.:
///
///	ppar.......: parameter to resolve input for
///	ppist......: context of parameter
///	pcInput....: name of input on function of parameter
///	iPosition..: input identifier in instantiation
///
/// RTN..: struct symtab_HSolveListElement * : symbol that gives input
///
/// DESCR: Find symbol that gives input to functional parameter
///
/// **************************************************************************

struct symtab_HSolveListElement *
ParameterResolveFunctionalInput
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist,
 char *pcInput,
 int iPosition)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- if parameter is function

    if (ParameterIsFunction(ppar))
    {
	//- get function

	struct symtab_Function *pfun
	    = ParameterGetFunction(ppar);

	//- set result : input from function

	phsleResult
	    = FunctionResolveInput(pfun, ppist, pcInput, iPosition);
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ParameterResolveScaledValue()
///
/// ARGS.:
///
///	ppar.......: parameter to scale value for
///	ppist......: context of parameter
///
/// RTN..: double : scaled parameter value
///
/// DESCR: Resolve & scale value of parameter in given context
///
///	Scaling means taking volume or surface of an ancestor symbol into
///	account to get the actual value for the parameter.
///	e.g. for a channel means multiplying conductance density with 
///	surface of segment, for a segment could mean dividing axial 
///	resistance by volume of segment and multiplying with length of
///	segment.
///
/// NOTE:
///
///	See notes of ParameterResolveValue() 
///
/// **************************************************************************

double
ParameterResolveScaledValue
(struct symtab_Parameters *ppar, struct PidinStack *ppist)
{
    //- set default result : without scaling

    double dResult = ParameterResolveValue(ppar, ppist);

    //- if resolved

    if (dResult != FLT_MAX)
    {
	//- default : do scaling

	int bScale = TRUE;

	//- if function attached

	if (ParameterIsFunction(ppar))
	{
	    //- get function

	    struct symtab_Function *pfun
		= ParameterGetFunction(ppar);

	    //- if function does not allow scaling

	    if (!FunctionAllowsScaling(pfun))
	    {
		//- remember : don't scale

		bScale = FALSE;
	    }
	}
	    
	//- if scaling allowed

	if (bScale)
	{
	    //- lookup context symbol

	    struct symtab_HSolveListElement *phsle
		= PidinStackLookupTopSymbol(ppist);

	    //- ask symbol to scale this value

	    dResult
		= SymbolParameterScaleValue(phsle, ppist, dResult, ppar);
	}
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: ParameterResolveSymbol()
///
/// ARGS.:
///
///	ppar.......: parameter to resolve input for
///	ppist......: context of parameter
///
/// RTN..: struct symtab_HSolveListElement * : symbol pointed to by parameter
///
/// DESCR: Resolve (symbolic) parameter
///
/// **************************************************************************

struct symtab_HSolveListElement *
ParameterResolveSymbol
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- get pidinstack from parameter elements

    struct PidinStack *ppistPar
	= ParameterResolveToPidinStack(ppar, ppist);

    //- lookup symbol from pidinstack

    phsleResult = SymbolsLookupHierarchical(NULL, ppistPar);

    //- free pidin stack

    PidinStackFree(ppistPar);

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ParameterResolveToPidinStack()
///
/// ARGS.:
///
///	ppar.......: parameter to resolve input for
///	ppist......: context of parameter
///
/// RTN..: struct PidinStack *
///
///	Context pointed to by parameter
///
/// DESCR: Resolve a parameter to a context.
///
///	The symbolic parameter is dereferenced, a number parameter is
///	left alone, a copy is returned.
///
///	The resulting context looses the field specification from the
///	given parameter (if any).
///
/// **************************************************************************

struct PidinStack *
ParameterResolveToPidinStack
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist)
{
    //- set result : pidin stack from given context

    struct PidinStack *ppistResult
	= PidinStackDuplicate(ppist);

    //- if symbolic parameter

    if (ParameterIsSymbolic(ppar))
    {
/* 	//- set initial result: pidin stack from given context */

/* 	ppistResult = PidinStackDuplicate(ppist); */

	//t rewrite using only one allocation :
	//t 
	//t means we need something like 
	//t PidinStackAppendCompactFromParameterSymbols()

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar = PidinStackNewFromParameterSymbols(ppar);

	//- if rooted

	if (PidinStackIsRooted(ppistPar))
	{
	    PidinStackFree(ppistResult);

	    ppistResult = ppistPar;
	}

	//- else

	else
	{
	    //- append pidinstacks

	    PidinStackAppendCompact(ppistResult, ppistPar);

	    //- free parameter pidin stack

	    PidinStackFree(ppistPar);
	}
    }

    //- if field parameter

    else if (ParameterIsField(ppar))
    {
/* 	//- set initial result: pidin stack from given context */

/* 	ppistResult = PidinStackDuplicate(ppist); */

	//t rewrite using only one allocation :
	//t 
	//t means we need something like 
	//t PidinStackAppendCompactFromParameterSymbols()

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar = PidinStackNewFromParameterSymbols(ppar);

	//- append pidinstacks

	PidinStackAppendCompact(ppistResult, ppistPar);

	//- get field name of parameter

	struct symtab_IdentifierIndex *pidinField
	    = ParameterGetFieldPidin(ppar);

	//- lookup the parameter

	char *pcField = IdinName(pidinField);

	struct symtab_HSolveListElement *phsleField
	    = PidinStackLookupTopSymbol(ppistResult);

	if (phsleField)
	{
	    //- get named I/O from symbol

	    struct symtab_InputOutput *pio = NULL;

	    if (instanceof_bio_comp(phsleField))
	    {
		pio
		    = BioComponentLookupBindableIO
		      ((struct symtab_BioComponent *)phsleField, pcField, 0);
	    }

	    //- if I/O found

	    if (pio)
	    {
		struct symtab_Parameters *pparInit = NULL;

		//- get field name from I/O

		char *pcName = InputOutputFieldName(pio);

		//- add '_init' string

		char pcTmp[100];

		strcpy(pcTmp, pcName);

		strcat(pcTmp,"_init");

		//- find parameter in symbol

		pparInit = SymbolFindParameter(phsleField, ppistResult, pcTmp);

		//- resolve resulting parameter

		ppistResult = ParameterResolveToPidinStack(pparInit, ppistResult);

		//t memory leak: fist ppistResult
	    }

	    //- else

	    else
	    {
		//- try to get name field parameter (instead of I/O)

		struct symtab_Parameters *pparField
		    = SymbolFindParameter(phsleField, ppistResult, pcField);

		if (pparField)
		{
		    static int iCount = 0;

		    iCount++;

		    if (iCount < 100)
		    {
			//- resolve pidinstack

			ppistResult = ParameterResolveToPidinStack(pparField, ppistResult);

			//t memory leak: fist ppistResult

			iCount--;
		    }
		    else
		    {
			//- give some diag's : presumably unbound recursion

			fprintf
			    (stdout,
			     "ParameterResolveToPidinStack(): presumably unbound recursion"
			     " for %s, this parameter value depends on other parameter"
			     " values that depend back on this parameter value.\n",
			     ParameterGetName(ppar));

			//! count gets reset by getting out of the recursion

			iCount--;

			//- return failure

			PidinStackFree(ppistResult);

			ppistResult = NULL;
		    }
		}
		else
		{
		    PidinStackFree(ppistResult);

		    ppistResult = NULL;
		}
	    }
	}
	else
	{
	    PidinStackFree(ppistResult);

	    ppistResult = NULL;
	}

	//- free parameter pidin stack

	PidinStackFree(ppistPar);
    }

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: ParameterResolveValue()
///
/// ARGS.:
///
///	ppar.......: parameter to resolve input for
///	ppist......: context of parameter
///
/// RTN..: double : parameter value, FLT_MAX if failure
///
/// DESCR: Resolve value of parameter in given context
///
/// NOTE:
///
///	Field name of parameter must match bindable I/O relation of symbol
///	pointed to by parameter. First I/O relation is matched, this could 
///	be an architectural mistake ?
///	Second try is made : match against parameter as referenced. 
///
///	Symbols may not have same parameter names and I/O relation names.
///	To disambiguate this we could invent another symbol to make 
///	difference between field names and I/O relation names.
///	See TODO.txt.
///
/// **************************************************************************

double
ParameterResolveValue
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist)
{
    //- set default result : invalid

    double dResult = FLT_MAX;

    //- if string

    if (ParameterIsString(ppar))
    {
	//- return failure

	dResult = FLT_MAX;
    }

    //- if constant value

    //t ParameterValue() also checks for ParameterIsNumber().

    else if (ParameterIsNumber(ppar))
    {
	//- set result from stored value

	dResult = ParameterValue(ppar);
    }

    //- if symbolic parameter

    else if (ParameterIsSymbolic(ppar))
    {
	//- return failure

	dResult = FLT_MAX;
    }

    //- if field parameter

    else if (ParameterIsField(ppar))
    {
	//- get field name of parameter

	char *pcField = ParameterGetFieldName(ppar);

	//- get pidinstack from parameter elements

	struct PidinStack *ppistPar
	    = ParameterResolveToPidinStack(ppar, ppist);

	if (ppistPar)
	{
	    //- lookup symbol from pidinstack

	    struct symtab_HSolveListElement *phsle
		= SymbolsLookupHierarchical(NULL, ppistPar);

	    //- if symbol not found, or not a biocomponent

	    if (!phsle
		|| !instanceof_bio_comp(phsle))
	    {
		//! e.g. searching for 'none' as the somatopetal of a segment.

		//! e.g. resolving beta for an isolated pool

		//- free allocated memory

		PidinStackFree(ppistPar);

		//- return failure

		return(dResult);
	    }

	    //- else

	    else
	    {
		//- get named I/O from symbol

		struct symtab_InputOutput *pio
		    = BioComponentLookupBindableIO
		      ((struct symtab_BioComponent *)phsle, pcField, 0);

		//- if I/O found

		if (pio)
		{
		    struct symtab_Parameters *pparInit = NULL;

		    //- get field name from I/O

		    char *pcName = InputOutputFieldName(pio);

		    //- add '_init' string

		    char pcTmp[100];

		    strcpy(pcTmp,pcName);

		    strcat(pcTmp,"_init");

		    //- find parameter in symbol

		    pparInit = SymbolFindParameter(phsle, ppistPar, pcTmp);

		    //- resolve resulting parameter

		    dResult = ParameterResolveValue(pparInit, ppistPar);
		}

		//- else

		else
		{
		    //- try to find referenced parameter

		    //! note that this will fail for symbolic parameters that
		    //! point to a symbol instead of a field.

		    struct symtab_Parameters *pparReferenced
			= SymbolFindParameter(phsle, ppistPar, pcField);

		    //- if the referenced field / parameter is found

		    if (pparReferenced)
		    {
			//- resolve resulting parameter

			static int iCount = 0;

			iCount++;

			if (iCount < 100)
			{
			    dResult = ParameterResolveValue(pparReferenced, ppistPar);

			    iCount--;
			}
			else
			{
			    //- give some diag's : presumably unbound recursion

			    fprintf
				(stdout,
				 "ParameterResolveValue(): presumably unbound recursion"
				 " for %s, this parameter value depends on other parameter"
				 " values that depend back on this parameter value.\n",
				 ParameterGetName(ppar));

			    //! count gets reset by getting out of the recursion

			    iCount--;

			    //- free allocated memory

			    PidinStackFree(ppistPar);

			    //- return failure

			    return(dResult);
			}
		    }

		    //- else

		    else
		    {
			//- free allocated memory

			PidinStackFree(ppistPar);

			//- return failure

			return(dResult);
		    }
		}
	    }

	    //- free allocated memory

	    PidinStackFree(ppistPar);
	}
    }

    //- if function

    else if (ParameterIsFunction(ppar))
    {
	//- get function

	struct symtab_Function *pfun
	    = ParameterGetFunction(ppar);

	//- set result from function

	dResult = FunctionValue(pfun, ppist);
    }

    //- else

    else
    {
	//- give some diag's : not illegal situation

	fprintf
	    (stdout,
	     "ParameterResolveValue() : Could not determine parameter type"
	     " for %s\n",
	     ParameterGetName(ppar));
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: ParameterTo_stdout()
///
/// ARGS.:
///
///	ppar.: parameter to print.
///
/// RTN..: void
///
/// DESCR: Print parameter to stdout.
///
/// **************************************************************************

void ParameterTo_stdout(struct symtab_Parameters *ppar)
{
    IdinPrint(ppar->uValue.pidin, NULL);

    fprintf(stdout, "\n");
}


/// **************************************************************************
///
/// SHORT: ParameterValue()
///
/// ARGS.:
///
///	ppar.....: parameter to obtain value for
///
/// RTN..: double : value, FLT_MAX for failure
///
/// DESCR: Get value from parameter
///
/// **************************************************************************

double ParameterValue(struct symtab_Parameters *ppar)
{
    //- set default result

    double dResult = FLT_MAX;

    //- if number present

    if (ParameterIsNumber(ppar))
    {
	//- set result

	dResult = ppar->uValue.dNumber;
    }

    //- return result

    return(dResult);
}


