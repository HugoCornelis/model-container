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


/// 
/// \return struct symtab_Parameters * 
/// 
///	Newly allocated parameters, NULL for failure
/// 
/// \brief Allocate a new parameters symbol table element
/// 

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
/// \arg ppar parameter.
/// \arg ppist context.
/// 
/// \return struct PidinStack *
/// 
///	Context attached to this function parameter in this context,
///	NULL for none.
/// 
/// \brief Get context attached to this function parameter.
/// 

struct PidinStack *
ParameterContextGetFunctionContext
(struct symtab_Parameters *ppar, struct PidinStack *ppist)
{
    //- set default result: duplicate context

    struct PidinStack *ppistResult = PidinStackDuplicate(ppist);

    //- while this parameter is not a function

    while (!ParameterIsFunction(ppar))
    {
	//- get context referenced to by the parameter

	struct PidinStack *ppistPar = ParameterResolveToPidinStack(ppar, ppistResult);

	struct symtab_HSolveListElement *phslePar = PidinStackLookupTopSymbol(ppistPar);

	//- if there is a parameter field name

	char *pcFieldname = ParameterGetFieldName(ppar);

	if (pcFieldname)
	{
	    //- find field in referenced context

	    ppar = SymbolFindParameter(phslePar, ppistPar, pcFieldname);

	    ppistResult = PidinStackDuplicate(ppistPar);

	    PidinStackFree(ppistPar);
	}

	//- else no field name

	else
	{
	    //- break loop

	    break;
	}
    }

    //- if the resolved parameter is a function

    if (ParameterIsFunction(ppar))
    {
	//- return result

	return(ppistResult);
    }

    //- else no function

    else
    {
	//- free allocated memory

	PidinStackFree(ppistResult);

	//- return failure

	return(NULL);
    }
}


/// 
/// \arg ppar parameter.
/// \arg ppist context.
/// 
/// \return struct symtab_Function *
/// 
///	Function attached to this parameter in this context, NULL for
///	none.
/// 
/// \brief Get function attached to this parameter.
/// 

struct symtab_Function *
ParameterContextGetFunction
(struct symtab_Parameters *ppar, struct PidinStack *ppist)
{
    //- create a working context

    struct PidinStack *ppistPar1 = PidinStackDuplicate(ppist);

    //- while this parameter is not a function

    while (!ParameterIsFunction(ppar))
    {
	//- get context referenced to by the parameter

	struct PidinStack *ppistPar2 = ParameterResolveToPidinStack(ppar, ppistPar1);

	struct symtab_HSolveListElement *phsle2 = PidinStackLookupTopSymbol(ppistPar2);

	//- if there is a parameter field name

	char *pcFieldname = ParameterGetFieldName(ppar);

	if (pcFieldname)
	{
	    //- find field in referenced context

	    ppar = SymbolFindParameter(phsle2, ppistPar2, pcFieldname);

	    ppistPar1 = PidinStackDuplicate(ppistPar2);

	    PidinStackFree(ppistPar2);
	}

	//- else no field name

	else
	{
	    //- break loop

	    break;
	}
    }

    //- free allocated memory

    PidinStackFree(ppistPar1);

    //- if the resolved parameter is a function

    if (ParameterIsFunction(ppar))
    {
	//- return function of the resolved parameter

	return(ParameterGetFunction(ppar));
    }

    //- return failure

    return(NULL);
}


/// 
/// \arg ppar parameter
/// 
/// \return void
/// 
/// \brief Free memory of given parameters.
/// 

void ParameterFree(struct symtab_Parameters *ppar)
{
    //- look at parameter type

    switch (ppar->iType)
    {
	//- if parameter with symbolic value in idin

    case TYPE_PARA_SYMBOLIC:
    {
	/// \todo free idin set

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
	/// \todo free function set

/* 	    FunctionFree(ppar->uValue.pfun); */

	break;
    }

    //- if parameter for attribute, can have optionally a value in uValue

    case TYPE_PARA_ATTRIBUTE:
    {
	/// \todo free idin set

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


/// 
/// \arg ppar parameter
/// 
/// \return char * : name of referenced field, NULL for none
/// 
/// \brief Get field name of referenced field
/// 

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


/// 
/// \arg ppar parameter to obtain string from.
/// 
/// \return char *
/// 
///	string value, NULL for failure.
/// 
/// \brief Get string from parameter.
/// 

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


/// 
/// \arg ppar parameter list to search
/// \arg pcName name of parameter to lookup
/// 
/// \return struct symtab_Parameters * : parameter, NULL for failure
/// 
/// \brief Search for named parameter
/// 

struct symtab_Parameters *
ParameterLookup
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


/// 
/// \arg pcName name of parameter, will be copied.
/// \arg pfun function that generates the parameter value.
/// 
/// \return struct symtab_Parameters *
/// 
///	New parameter, NULL for failure.
/// 
/// \brief Allocate parameter that depends on the given function.
/// 

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


/// 
/// \arg pcName name of parameter, will be copied.
/// \arg dNumber value.
/// 
/// \return struct symtab_Parameters *
/// 
///	New parameter.
/// 
/// \brief Allocate parameter for double value and initialize.
/// 

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


/// 
/// \arg pcName name of parameter, will be copied.
/// \arg pidin pidin queue, list used as queue.
/// \arg iType type of parameter (symbolic or field).
/// 
/// \return struct symtab_Parameters *
/// 
///	New parameter
/// 
/// \brief Allocate symbolic parameter for given pidin queue (list).
/// 

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


/// 
/// \arg pcName name of parameter, will be copied.
/// \arg pcValue value
/// 
/// \return struct symtab_Parameters *
/// 
///	New parameter.
/// 
/// \brief Allocate parameter for string value and initialize.
/// 

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


/* ///  */
/* /// \arg ppar parameter. */
/* /// \arg ppist context. */
/* ///  */
/* /// \return int */
/* ///  */
/* ///	success of operation. */
/* ///  */
/* /// \brief Print parameter info. */
/* ///  */

/* int */
/* ParameterPrintInfo */
/* (struct symtab_Parameters *ppar, struct PidinStack *ppist) */
/* { */
/*     if (ParameterIsNumber(ppar)) */
/*     { */
/* 	double d = ParameterResolveValue(ppar, ppist); */

/* 	//- print result */

/* 	fprintf(stdout,"---\n"); */
/* 	fprintf(stdout,"  type: Number\n"); */
/* 	fprintf(stdout,"  value: %g\n", d); */
/* 	fprintf(stdout,"  flags: %i\n",ppar->iFlags); */

/* 	return 1; */
/*     } */

/*     if (ParameterIsFunction(ppar)) */
/*     { */
/* 	struct symtab_Function *pfun = ParameterContextGetFunction(ppar, ppist); */

/* /* 	if (!pfun) * */
/* /* 	{ * */
/* /* 	    pfun = ppar->uValue.pfun; * */
/* /* 	} * */
		
/* 	fprintf(stdout,"---\n"); */
/* 	fprintf(stdout,"  type: Function\n"); */
/* 	fprintf(stdout,"  Function name: %s\n", FunctionGetName(pfun)); */

/* 	fprintf(stdout,"  Parameters:\n"); */

/* 	struct symtab_Parameters *pparFunCurr */
/* 	    = pfun->pparc->ppars; */

/* 	for ( ; pparFunCurr ; pparFunCurr = pparFunCurr->pparNext) */
/* 	{ */

/* 	    switch(pparFunCurr->iType) */
/* 	    { */
/* 	    case TYPE_PARA_NUMBER: */

/* 		fprintf(stdout, "    %s: %g\n", */
/* 			pparFunCurr->pcIdentifier, */
/* 			pparFunCurr->uValue.dNumber); */
/* 		return 1; */

/* 		break; */

/* 	    case TYPE_PARA_FIELD:		       */

/* 		fprintf(stdout, "    %s: %s\n", */
/* 			pparFunCurr->pcIdentifier, */
/* 			pparFunCurr->uValue.dNumber); */

/* 		break; */

/* 	    case TYPE_PARA_STRING: */

/* 		fprintf(stdout, "    %s: %s\n", */
/* 			pparFunCurr->pcIdentifier, */
/* 			pparFunCurr->uValue.pcString); */
/* 		break; */
/* 	    } */
/* 	} */
/*     } */

/*     if (ParameterIsField(ppar)) */
/*     { */
/* 	/// \defouble d = ParameterResolveValue(ppar, ppist); */

/* 	char *pcFieldName = ParameterGetFieldName(ppar); */
      
/* 	struct symtab_IdentifierIndex *pidinField = ParameterGetFieldPidin(ppar); */

/* 	//      struct PidinStack *ppistPar = ParameterResolveToPidinStack( */
/* 	fprintf(stdout,"    type: Field\n"); */
/* 	fprintf(stdout,"    field name: %s\n", pcFieldName); */
/*     } */

/*     //- for string parameter values */

/*     else if (ParameterIsString(ppar)) */
/*     { */
/* 	//- print string result */

/* 	char *pc = ParameterGetString(ppar); */
/* 	fprintf(stdout,"---\n"); */
/* 	fprintf(stdout,"  type: String\n"); */
/* 	fprintf(stdout,"  value: \"%s\"\n", pc); */
/* 	fprintf(stdout,"  flags: %i\n",ppar->iFlags); */

/* 	return 1; */
/*     } */

/*     //- for symbolic parameter values */

/*     else if (ParameterIsSymbolic(ppar)) */
/*     { */
/* 	//- give diagnostics: not implemented yet */

/* 	fprintf(stdout, "\nreporting of symbolic parameters is not implemented yet\n"); */
/*     } */

/*     //- for attribute parameter values */

/*     else if (ParameterIsAttribute(ppar)) */
/*     { */
/* 	//- give diagnostics: not implemented yet */

/* 	fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n"); */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- diag's */

/* 	fprintf(stdout, "parameter (%s) not found in symbol\n", ppar->pcIdentifier); */
/*     } */

/*     return 1; */
/* } */


/// 
/// \arg ppar parameter.
/// \arg ppist context.
/// \arg iLevel indentation depth.
/// \arg pfile serialization stream.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Print parameter info, following symbolic references.
/// 

int
ParameterPrintInfoRecursive
(struct symtab_Parameters *ppar, struct PidinStack *ppist, int iLevel, FILE *pfile)
{
    int iIndent = (iLevel == 0) ? 0 : (iLevel * 2);

    PrintIndent(iIndent, pfile);
    fprintf(pfile, "'parameter name': %s\n", ParameterGetName(ppar));

    //- for straight number values

    if (ParameterIsNumber(ppar))
    {
	double d = ParameterResolveValue(ppar, ppist);

	//- print result

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "type: number\n");
	PrintIndent(iIndent, pfile);
	fprintf(pfile, "value: %g\n", d);

	return 1;
    }

    //- for field references

    else if (ParameterIsField(ppar))
    {
	char *pcFieldName = ParameterGetFieldName(ppar);

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "'field name': %s\n", pcFieldName);

	PrintIndent(iIndent, pfile);      
	fprintf(pfile, "type: field\n");

	char pc[1024];

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "%s", "value: ");

	{
	    struct PidinStack *ppist2 = PidinStackCalloc();

	    PidinStackPushAll(ppist2, ppar->uValue.pidin);

	    PidinStackPrint(ppist2, pfile);

	    PidinStackFree(ppist2);      
	}

	fprintf(pfile, "%s", "\n");

	{
	    struct PidinStack *ppistValue = ParameterResolveToPidinStack(ppar, ppist);

	    PrintIndent(iIndent, pfile);
	    PidinStackString(ppistValue, pc, sizeof(pc));  
	    fprintf(pfile, "'resolved value': %s%s%s\n", pc, "->", pcFieldName);

	    PidinStackFree(ppistValue);
	}

	return 1;
    }

    //- for string parameter values

    else if (ParameterIsString(ppar))
    {
	//- print string result

	char *pc = ParameterGetString(ppar);

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "type: string\n");
	PrintIndent(iIndent, pfile);
	fprintf(pfile, "value: \"%s\"\n\n", pc);

	return 1;
    }

    //- for symbolic references

    else if (ParameterIsSymbolic(ppar))
    {
	PrintIndent(iIndent, pfile);
	fprintf(pfile, "type: symbolic\n");

	struct PidinStack *ppistPar = PidinStackCalloc();

	PidinStackPushAll(ppistPar, ppar->uValue.pidin);

	PrintIndent(iIndent, pfile);

	fprintf(pfile,"value: ");

	PidinStackPrint(ppistPar, pfile);

	PidinStackFree(ppistPar);

	fprintf(pfile, "\n");

	return 1;
    }

    //- for attribute

    else if (ParameterIsAttribute(ppar))
    {
	//- give diagnostics: not implemented yet

	fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");

	return 0;
    }

    //- for functions

    else if (ParameterIsFunction(ppar))
    {
	struct symtab_Function *pfun = ParameterContextGetFunction(ppar, ppist);
		
	PrintIndent(iIndent, pfile);
	fprintf(pfile, "type: function\n");

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "'function name': %s\n", FunctionGetName(pfun));

	PrintIndent(iIndent, pfile);
	fprintf(pfile, "'function parameters':\n\n");

	struct symtab_Parameters *pparFunCurr
	    = pfun->pparc->ppars;

	for( ; pparFunCurr ; pparFunCurr = pparFunCurr->pparNext)
	{
	    PrintIndent(iIndent, pfile);
	    fprintf(pfile, "  -\n");

	    ParameterPrintInfoRecursive(pparFunCurr, ppist, iLevel + 2, pfile); 

/* 	    fprintf(pfile, "%s", "\n"); */
	}

	return 1;
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "parameter (%s) has an unknown type\n", ppar->pcIdentifier);

	return 0;
    }

    return 1;
}


/// 
/// \arg ppar parameter.
/// \arg ppist context.
/// \arg iLevel indentation depth.
/// \arg iType type of export (0: NDF, 1: XML).
/// \arg pfile serialization stream.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Print parameter info in NDF format, following symbolic
/// references.
/// 

int
ParameterExport
(struct symtab_Parameters *ppar, struct PidinStack *ppist, int iLevel, int iType, FILE *pfile)
{
    int iIndent = (iLevel == 0) ? 0 : (iLevel * 2);

    PrintIndent(iIndent, pfile);

    if (iType == 0)
    {
	fprintf(pfile, "PARAMETER ( %s = ", ParameterGetName(ppar));
    }
    else
    {
	fprintf(pfile, "<parameter> <name>%s</name>", ParameterGetName(ppar));
    }

    //- for straight number values

    if (ParameterIsNumber(ppar))
    {
	double d = ParameterResolveValue(ppar, ppist);

	//- print result

	if (iType == 0)
	{
	    fprintf(pfile, "%g ),\n", d);
	}
	else
	{
	    fprintf(pfile, "<value>%g</value>\n", d);
	}

	return 1;
    }

    //- for field references

    else if (ParameterIsField(ppar))
    {
	struct PidinStack *ppist2 = PidinStackCalloc();

	PidinStackPushAll(ppist2, ppar->uValue.pidin);

	if (iType == 0)
	{
	    PidinStackPrint(ppist2, pfile);

	    fprintf(pfile, " ),\n");
	}
	else
	{
	    char pc[1000];

	    PidinStackString(ppist2, pc, sizeof(pc));

	    //t escape entities

	    fprintf(pfile, "<field>%s</field>\n", pc);
	}

	PidinStackFree(ppist2);      

	return 1;
    }

    //- for string parameter values

    else if (ParameterIsString(ppar))
    {
	//- print string result

	char *pc = ParameterGetString(ppar);

	if (iType == 0)
	{
	    fprintf(pfile, "\"%s\" ),\n", pc);
	}
	else
	{
	    fprintf(pfile, "<string>%s</string>\n", pc);
	}

	return 1;
    }

    //- for symbolic references

    else if (ParameterIsSymbolic(ppar))
    {
	struct PidinStack *ppistPar = PidinStackCalloc();

	PidinStackPushAll(ppistPar, ppar->uValue.pidin);

	if (iType == 0)
	{
	    PidinStackPrint(ppistPar, pfile);

	    fprintf(pfile, " ),\n");
	}
	else
	{
	    char pc[1000];

	    PidinStackString(ppistPar, pc, sizeof(pc));

	    //t escape entities

	    fprintf(pfile, "<symbol>%s</symbol>\n", pc);
	}

	PidinStackFree(ppistPar);

	return 1;
    }

    //- for attribute

    else if (ParameterIsAttribute(ppar))
    {
	//- give diagnostics: not implemented yet

	fprintf(stdout, "\nreporting of attribute parameters is not implemented yet\n");

	return 0;
    }

    //- for functions

    else if (ParameterIsFunction(ppar))
    {
	struct symtab_Function *pfun = ParameterContextGetFunction(ppar, ppist);
		
	fprintf(pfile, "\n");

	PrintIndent(iIndent + 2, pfile);

	if (iType == 0)
	{
	    fprintf(pfile, "%s\n", FunctionGetName(pfun));
	}
	else
	{
	    fprintf(pfile, "<function> <name>%s</name>\n", FunctionGetName(pfun));
	}

	PrintIndent(iIndent + 4, pfile);

	if (iType == 0)
	{
	    fprintf(pfile, "(\n");
	}
	else
	{
	}

	struct symtab_Parameters *pparFunCurr
	    = pfun->pparc->ppars;

	for( ; pparFunCurr ; pparFunCurr = pparFunCurr->pparNext)
	{
	    ParameterExport(pparFunCurr, ppist, iLevel + 8, iType, pfile); 
	}

	PrintIndent(iIndent + 4, pfile);

	if (iType == 0)
	{
	    fprintf(pfile, "),\n");
	}
	else
	{
	    fprintf(pfile, "</function>\n");
	}

	return 1;
    }

    //- else

    else
    {
	//- diag's

	fprintf(stdout, "parameter (%s) has an unknown type\n", ppar->pcIdentifier);

	return 0;
    }

    return 1;
}


/// 
/// \arg ppar parameter to print symbols for
/// \arg bAll TRUE print full list, FALSE print only given parameter
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info for parameter
/// 

#define PrintParameterIndent(iIndent,pfile)				\
do									\
{									\
    PrintIndent(iIndent,pfile);						\
    fprintf(pfile,"PARA  ");						\
}									\
while (0)								\

int
ParameterPrint
(struct symtab_Parameters *ppar, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    /// section element

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


/// 
/// \arg ppar parameter to resolve input for
/// \arg ppist context of parameter
/// \arg pcInput name of input on function of parameter
/// \arg iPosition input identifier in instantiation
/// 
/// \return struct symtab_HSolveListElement * : symbol that gives input
/// 
/// \brief Find symbol that gives input to functional parameter
/// 

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

    struct symtab_Function *pfun
	  = ParameterContextGetFunction(ppar,ppist);

    if (pfun)
    {
	//- get function context

	struct PidinStack *ppistFun = ParameterContextGetFunctionContext(ppar,ppist);

	//- set result : input from function

	phsleResult
	    = FunctionResolveInput(pfun, ppistFun, pcInput, iPosition);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg ppar parameter to scale value for
/// \arg ppist context of parameter
/// 
/// \return double : scaled parameter value
/// 
/// \brief Resolve & scale value of parameter in given context
///
/// \details 
/// 
///	Scaling means taking volume or surface of an ancestor symbol into
///	account to get the actual value for the parameter.
///	e.g. for a channel means multiplying conductance density with 
///	surface of segment, for a segment could mean dividing axial 
///	resistance by volume of segment and multiplying with length of
///	segment.
/// 
/// \note 
/// 
///	See notes of ParameterResolveValue() 
/// 

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


/// 
/// \arg ppar parameter to resolve input for
/// \arg ppist context of parameter
/// 
/// \return struct symtab_HSolveListElement * : symbol pointed to by parameter
/// 
/// \brief Resolve (symbolic) parameter
/// 

struct symtab_HSolveListElement *
ParameterResolveSymbol
(struct symtab_Parameters *ppar,
 struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- loop over the parameters referenced by the one given

    struct PidinStack *ppistPar1 = PidinStackDuplicate(ppist);

    while (ParameterIsSymbolic(ppar) || ParameterIsField(ppar))
    {
	//- lookup symbol from parameter elements

	struct PidinStack *ppistPar2
	    = ParameterResolveToPidinStack(ppar, ppistPar1);

	phsleResult = PidinStackLookupTopSymbol(ppistPar2); 

	if (phsleResult)
	{
	    //- if there is a field name and the symbol was found

	    char *pcFieldname = ParameterGetFieldName(ppar); 

	    /// \note if pcFieldname is an IO, ppar will become NULL, that seems ok ?

	    /// \note Since this is a pointer to the parameter argument I'm not certain
	    /// \note changing this value is always safe. 

	    ppar = SymbolFindParameter(phsleResult, ppistPar2, pcFieldname);

	    if (ppar)
	    {
		ppistPar1 = PidinStackDuplicate(ppistPar2);

		PidinStackFree(ppistPar2);
	    }

	    //- else

	    else
	    {
		//- no symbol referenced

		break;
	    }
	}
	else
	{
	    break;
	}
    }

    //- free pidin stack

    PidinStackFree(ppistPar1);

    //- return result

    return(phsleResult);
}


/// 
/// \arg ppar parameter to resolve input for
/// \arg ppist context of parameter
/// 
/// \return struct PidinStack *
/// 
///	Context pointed to by parameter
/// 
/// \brief Resolve a parameter to a context.
///
/// \details 
/// 
///	The symbolic parameter is dereferenced, a number parameter is
///	left alone, a copy is returned.
/// 
///	The resulting context looses the field specification from the
///	given parameter (if any).
/// 

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

	/// \todo rewrite using only one allocation :
	/// \todo 
	/// \todo means we need something like 
	/// \todo PidinStackAppendCompactFromParameterSymbols()

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

	/// \todo rewrite using only one allocation :
	/// \todo 
	/// \todo means we need something like 
	/// \todo PidinStackAppendCompactFromParameterSymbols()

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

		/// \todo memory leak: fist ppistResult
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

			/// \todo memory leak: fist ppistResult

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

			/// \note count gets reset by getting out of the recursion

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


/// 
/// \arg ppar parameter to resolve input for
/// \arg ppist context of parameter
/// 
/// \return double : parameter value, FLT_MAX if failure
/// 
/// \brief Resolve value of parameter in given context
/// 
/// \note 
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

    /// \todo ParameterValue() also checks for ParameterIsNumber().

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
		/// \note e.g. searching for 'none' as the somatopetal of a segment.

		/// \note e.g. resolving beta for an isolated pool

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

		    /// \note note that this will fail for symbolic parameters that
		    /// \note point to a symbol instead of a field.

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

			    /// \note count gets reset by getting out of the recursion

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


/// 
/// \arg ppar parameter to print.
/// 
/// \return void
/// 
/// \brief Print parameter to stdout.
/// 

void ParameterTo_stdout(struct symtab_Parameters *ppar)
{
    IdinPrint(ppar->uValue.pidin, NULL);

    fprintf(stdout, "\n");
}


/// 
/// \arg ppar parameter to obtain value for
/// 
/// \return double : value, FLT_MAX for failure
/// 
/// \brief Get value from parameter
/// 

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


