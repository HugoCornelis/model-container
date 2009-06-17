//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: function.c 1.33 Thu, 19 Apr 2007 17:00:49 -0500 hugo $
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

#include "neurospaces/function.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parcontainer.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbols.h"


/// 
/// \arg pfun function
/// 
/// \return int : TRUE if function allows scaling.
/// 
/// \brief Check if function allows scaling.
/// 

int FunctionAllowsScaling(struct symtab_Function *pfun)
{
    //- set default result : TRUE

    int bResult = TRUE;

    //- get function name

    char *pcName = FunctionGetName(pfun);

    //- if fixed or backward compatibility

    if (0 == strcmp(pcName, "FIXED")
	|| 0 == strcmp(pcName, "GENESIS2"))
    {
	//- disallow scaling

	bResult = FALSE;
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pfun function.
/// \arg ppar new parameters.
/// 
/// \return int : success of operation.
/// 
/// \brief Assign parameters.
/// 

int
FunctionAssignParameters
(struct symtab_Function *pfun, struct symtab_Parameters *ppar)
{
    return(ParContainerAssignParameters(pfun->pparc, ppar));
}


/// 
/// \return struct symtab_Function * 
/// 
///	Newly allocated input, NULL for failure
/// 
/// \brief Allocate a new function symbol table element
/// 

struct symtab_Function * FunctionCalloc(void)
{
    //- set default result : failure

    struct symtab_Function *pfunResult = NULL;

    //- allocate input

    pfunResult
	= (struct symtab_Function *)
	  calloc(1, sizeof(struct symtab_Function));

    //- initialize input

    FunctionInit(pfunResult);

    //- return result

    return(pfunResult);
}


/// 
/// \arg pfun function.
/// 
/// \return char *
/// 
///	Name of the function.
/// 
/// \brief Get name of function.
/// 

char *
FunctionGetName(struct symtab_Function *pfun)
{
    return(pfun->pcName);
}


/// 
/// \arg pfun function.
/// \arg pc name of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	Searched parameter, NULL for not found.
/// 
/// \brief Get name function parameter.
/// 

struct symtab_Parameters *
FunctionGetParameter(struct symtab_Function *pfun, char *pc)
{
    return(ParContainerLookupParameter(pfun->pparc, pc));
}


/// 
/// \arg pfun function to init
/// 
/// \return void
/// 
/// \brief init input
/// 

void FunctionInit(struct symtab_Function *pfun)
{
    //- initialize function

    memset(pfun, 0, sizeof(*pfun));

    //- allocate parameter container

    pfun->pparc = ParContainerCalloc();
}


/// 
/// \arg pfun function to print symbols for
///	bAll.....: TRUE print full list of symbols, FALSE print only given cell
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info for function
/// 

#define PrintFunctionIndent(iIndent, pfile)				\
do									\
{									\
    PrintIndent(iIndent,pfile);						\
    fprintf(pfile,"FUNC  ");						\
}									\
while (0)								\

int FunctionPrint
(struct symtab_Function *pfun, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    /// section element

    struct symtab_HSolveListElement *phsle = NULL;

    //- do indent

    PrintFunctionIndent(iIndent, pfile);

    //- name

    fprintf(pfile, "Name (%s)\n", FunctionGetName(pfun));

    //- parameters

    ParContainerPrint(pfun->pparc, TRUE, iIndent + 4, pfile);

    //- return result

    return(bResult);
}


/// 
/// \arg pfun function to resolve input for
/// \arg ppist context of function
/// \arg pcInput name of input to function
/// \arg iPosition input identifier in instantiation
/// 
/// \return struct symtab_HSolveListElement * : symbol that gives input
/// 
/// \brief Find the specified input to function.
///
/// \details 
/// 
///	Function parameters are searched for a parameter with fieldname
///	'pcInput' with position 'iPosition' of parameters with that 
///	fieldname. The symbol to which the field belongs pointed to by the
///	matched parameter, is returned (so the returned symbol has an output
///	named 'pcInput' that is attached to the function parameter).
/// 

struct symtab_HSolveListElement *
FunctionResolveInput
(struct symtab_Function *pfun,
 struct PidinStack *ppist,
 char *pcInput,
 int iPosition)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    /// parameter iterator

    struct symtab_Parameters *ppar = NULL;

    int i = iPosition;

/*     // if any position ok (or first ok) */

/*     if (iPosition == -1 || iPosition == 0) */
/*     { */
/* 	// try to do normal lookup */

/* 	phsleResult = ParContainerLookupParameter(pfun->pparc,pcInput); */

/* 	// if found */

/* 	if (phsleResult) */
/* 	{ */
/* 	    // return result */

/* 	    return(phsleResult); */
/* 	} */
/*     } */

    //- loop over all parameters

    ppar = ParContainerIterateParameters(pfun->pparc);

    while (ppar)
    {
	//- get parameter field name

	char *pcField = ParameterGetName(ppar);

	//- if names match

	if (pcField && strcmp(pcInput, pcField) == 0)
	{
	    //- if any position

	    if (i == -1)
	    {
		//- break searching loop

		break;
	    }

	    //- if not any position

	    else
	    {
		//- decrement position counter

		i--;

		//- if position matches

		if (i == -1)
		{
		    //- break searching loop

		    break;
		}
	    }
	}

	//- go to next parameter

	ppar = ParContainerNextParameter(ppar);
    }

    //- if found

    if (ppar)
    {
	//- lookup symbol pointed to by parameter

	phsleResult = ParameterResolveSymbol(ppar, ppist);
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pfun function to set name of.
/// \arg pcName new name.
/// 
/// \return int : success of operation.
/// 
/// \brief Set name of function.
/// 

int
FunctionSetName
(struct symtab_Function *pfun, char *pcName)
{
    //- set default result : TRUE

    int bResult = TRUE;

    //- set function name

    pfun->pcName = pcName;

    //- return result

    return(bResult);
}


/// 
/// \arg pfun function to resolve input for
/// \arg ppist context of function
/// 
/// \return double : value of function, FLT_MAX if failure.
/// 
/// \brief Resolve value for given function in given context.
/// 
/// \todo  
/// 
///	For a function like NORMALIZE() to do normalization on the 
///	number of synapses, a query manager could be used to ask for 
///	the number of connections on ppist + (function parameter) and 
///	then divide by that value.  The query comes from a globally 
///	known projection query.
///	The same technique can be used for delay and weights of 
///	synapses, for position dependent distribution of a parameter etc.
/// 

double
FunctionValue
(struct symtab_Function *pfun, struct PidinStack *ppist)
{
    //- set default result : invalid

    double dResult = FLT_MAX;

    //- get function name

    char *pcName = FunctionGetName(pfun);

    //- if serial ID

    if (0 == strcmp(pcName, "SERIAL"))
    {
	//- get start

	struct symtab_Parameters *pparStart
	    = FunctionGetParameter(pfun, "start");

	double dStart
	    = pparStart ? ParameterResolveValue(pparStart, ppist) : 0 ;

	//- get stop

	struct symtab_Parameters *pparStop
	    = FunctionGetParameter(pfun, "stop");

	double dStop = pparStop ? ParameterResolveValue(pparStop, ppist) : -1 ;

	//- set result

	/// \todo take dStart and dStop into account,
	/// \todo what were they supposed to do ?

	dResult = PidinStackToSerial(ppist);
    }

    //- if minimum

    else if (0 == strcmp(pcName, "MINIMUM"))
    {
	//- get start

	struct symtab_Parameters *pparValue1
	    = FunctionGetParameter(pfun, "value1");

	double dValue1
	    = pparValue1 ? ParameterResolveValue(pparValue1, ppist) : FLT_MAX ;

	//- get stop

	struct symtab_Parameters *pparValue2
	    = FunctionGetParameter(pfun, "value2");

	double dValue2 = pparValue2 ? ParameterResolveValue(pparValue2, ppist) : FLT_MAX ;

	//- set result

	dResult = dValue1 < dValue2 ? dValue1 : dValue2;
    }

    //- if maximum

    else if (0 == strcmp(pcName, "MAXIMUM"))
    {
	//- get start

	struct symtab_Parameters *pparValue1
	    = FunctionGetParameter(pfun, "value1");

	double dValue1
	    = pparValue1 ? ParameterResolveValue(pparValue1, ppist) : FLT_MAX ;

	//- get stop

	struct symtab_Parameters *pparValue2
	    = FunctionGetParameter(pfun, "value2");

	double dValue2 = pparValue2 ? ParameterResolveValue(pparValue2, ppist) : FLT_MAX ;

	//- set result

	dResult = dValue1 > dValue2 ? dValue1 : dValue2;
    }

    //- if lower

    else if (0 == strcmp(pcName, "LOWER"))
    {
	//- get value

	struct symtab_Parameters *pparValue
	    = FunctionGetParameter(pfun, "value");

	double dValue
	    = pparValue ? ParameterResolveValue(pparValue, ppist) : FLT_MAX ;

	//- get comparator

	struct symtab_Parameters *pparComparator
	    = FunctionGetParameter(pfun, "comparator");

	double dComparator = pparComparator ? ParameterResolveValue(pparComparator, ppist) : FLT_MAX ;

	//- get value

	struct symtab_Parameters *pparResult1
	    = FunctionGetParameter(pfun, "result1");

	double dResult1
	    = pparResult1 ? ParameterResolveValue(pparResult1, ppist) : FLT_MAX ;

	struct symtab_Parameters *pparResult2
	    = FunctionGetParameter(pfun, "result2");

	double dResult2
	    = pparResult2 ? ParameterResolveValue(pparResult2, ppist) : FLT_MAX ;

	//- set result

	dResult = dValue < dComparator ? dResult1 : dResult2;
    }

    //- if higher

    else if (0 == strcmp(pcName, "HIGHER"))
    {
	//- get value

	struct symtab_Parameters *pparValue
	    = FunctionGetParameter(pfun, "value");

	double dValue
	    = pparValue ? ParameterResolveValue(pparValue, ppist) : FLT_MAX ;

	//- get comparator

	struct symtab_Parameters *pparComparator
	    = FunctionGetParameter(pfun, "comparator");

	double dComparator = pparComparator ? ParameterResolveValue(pparComparator, ppist) : FLT_MAX ;

	//- get value

	struct symtab_Parameters *pparResult1
	    = FunctionGetParameter(pfun, "result1");

	double dResult1
	    = pparResult1 ? ParameterResolveValue(pparResult1, ppist) : FLT_MAX ;

	struct symtab_Parameters *pparResult2
	    = FunctionGetParameter(pfun, "result2");

	double dResult2
	    = pparResult2 ? ParameterResolveValue(pparResult2, ppist) : FLT_MAX ;

	//- set result

	dResult = dValue > dComparator ? dResult1 : dResult2;
    }

    //- if negate

    else if (0 == strcmp(pcName, "NEGATE"))
    {
	//- get argument

	struct symtab_Parameters *pparValue1
	    = FunctionGetParameter(pfun, "value");

	double dValue1
	    = pparValue1 ? ParameterResolveValue(pparValue1, ppist) : 0 ;

	//- set result : negate

	dResult = -dValue1;
    }

    //- if minus

    else if (0 == strcmp(pcName, "MINUS"))
    {
	//- get two arguments

	struct symtab_Parameters *pparValue1
	    = FunctionGetParameter(pfun, "value1");

	double dValue1
	    = pparValue1 ? ParameterResolveValue(pparValue1, ppist) : 0 ;

	struct symtab_Parameters *pparValue2
	    = FunctionGetParameter(pfun, "value2");

	double dValue2
	    = pparValue2 ? ParameterResolveValue(pparValue2, ppist) : 0 ;

	//- set result : subtract

	dResult = dValue1 - dValue2;
    }

    //- if divide

    else if (0 == strcmp(pcName, "DIVIDE"))
    {
	//- get two arguments

	struct symtab_Parameters *pparArg1
	    = FunctionGetParameter(pfun, "DIVIDEND");

	double dArg1
	    = pparArg1 ? ParameterResolveValue(pparArg1, ppist) : 0 ;

	struct symtab_Parameters *pparArg2
	    = FunctionGetParameter(pfun, "DIVISOR");

	double dArg2
	    = pparArg2 ? ParameterResolveValue(pparArg2, ppist) : 1 ;

	//- if not zero

	/// \note mm, how to check for zero here ?

	if (dArg2 != 0.0)
	{
	    //- set result : divide

	    dResult = dArg1 / dArg2;
	}
	else
	{
	    dResult == FLT_MAX;

	    //- give diag's : not yet implemented

	    fprintf(stderr, "Function DIVIDE(): DIVISOR is zero\n");
	}
    }

    //- if time

    else if (0 == strcmp(pcName, "TIME"))
    {
	//- set result : always zero

	dResult = 0.0;
    }

    //- if step

    else if (0 == strcmp(pcName, "STEP"))
    {
	//- get value

	struct symtab_Parameters *pparValue
	    = FunctionGetParameter(pfun, "value");

	double dValue
	    = pparValue ? ParameterResolveValue(pparValue, ppist) : 0 ;

	//- get start

	struct symtab_Parameters *pparStart
	    = FunctionGetParameter(pfun, "start");

	double dStart
	    = pparStart ? ParameterResolveValue(pparStart, ppist) : 0 ;

	//- get stop

	struct symtab_Parameters *pparStop
	    = FunctionGetParameter(pfun, "stop");

	double dStop = pparStop ? ParameterResolveValue(pparStop, ppist) : 1 ;

	//- set result to one if start < value <= stop

	if (dStart < dValue
	    && dValue <= dStop)
	{
	    dResult = 1.0;
	}
	else
	{
	    dResult = 0.0;
	}
    }

    //- if fixed or backward compatibility

    else if (0 == strcmp(pcName, "FIXED")
	     || 0 == strcmp(pcName, "GENESIS2"))
    {
	//- get scale

	struct symtab_Parameters *pparScale
	    = FunctionGetParameter(pfun, "scale");

	//- get value

	struct symtab_Parameters *pparValue
	    = FunctionGetParameter(pfun, "value");

	if (pparScale && pparValue)
	{
	    double dScale = ParameterResolveValue(pparScale, ppist);

	    double dValue = ParameterResolveValue(pparValue, ppist);

	    //- set result

	    dResult = dValue * dScale;
	}
    }

    //- if randomized

    else if (0 == strcmp(pcName, "RANDOMIZE"))
    {
	//- get seed

	struct symtab_Parameters *pparSeed
	    = FunctionGetParameter(pfun, "seed");

	double dSeed = pparSeed ? ParameterResolveValue(pparSeed, ppist) : 0.0 ;

	//- get minimum

	struct symtab_Parameters *pparMin
	    = FunctionGetParameter(pfun, "min");

	//- get maximum

	struct symtab_Parameters *pparMax
	    = FunctionGetParameter(pfun, "max");

	if (pparMin && pparMax)
	{
	    double dMin = ParameterResolveValue(pparMin, ppist);
	    double dMax = ParameterResolveValue(pparMax, ppist);

	    double d1;
	    double d2;

	    //- set seed if requested

	    if (dSeed != 0.0)
	    {
		srand(dSeed * INT_MAX);
	    }

	    //- set result : for now uses ANSI rand()

	    d1 = (RAND_MAX + 1.0);
	    d2 = rand();

	    dResult = dMin + ((dMax - dMin) * (d2 / (d1)));
	}
    }

    //- if magnesium blocking

    else if (0 == strcmp(pcName, "MGBLOCK"))
    {
	//- get different parameters that apply to MG blocking

	struct symtab_Parameters *pparCMg
	    = FunctionGetParameter(pfun, "CMg");
	struct symtab_Parameters *pparKMg_A
	    = FunctionGetParameter(pfun, "KMg_A");
	struct symtab_Parameters *pparKMg_B
	    = FunctionGetParameter(pfun, "KMg_B");
	struct symtab_Parameters *pparGMax
	    = FunctionGetParameter(pfun, "G_MAX");
	struct symtab_Parameters *pparVm
	    = FunctionGetParameter(pfun, "Vm");

	if (pparCMg
	    && pparKMg_A
	    && pparKMg_B
	    && pparGMax
	    && pparVm)
	{
	    //- calculate parameter values

	    double dCMg = ParameterResolveValue(pparCMg, ppist);
	    double dKMg_A = ParameterResolveValue(pparKMg_A, ppist);
	    double dKMg_B = ParameterResolveValue(pparKMg_B, ppist);
	    double dGMax = ParameterResolveValue(pparGMax, ppist);
	    double dVm = ParameterResolveValue(pparVm, ppist);

	    //- calculate result : blocked conductance density value

	    double dKMg = dKMg_A * exp(dVm / dKMg_B);
	    dResult = dGMax * dKMg / (dKMg + dCMg);
	}
    }

    //- if nernst equation

    else if (0 == strcmp(pcName, "NERNST"))
    {
	//- get different parameters that apply to nernst equation

	struct symtab_Parameters *pparCIn
	    = FunctionGetParameter(pfun, "Cin");
	struct symtab_Parameters *pparCOut
	    = FunctionGetParameter(pfun, "Cout");
	struct symtab_Parameters *pparValency
	    = FunctionGetParameter(pfun, "valency");
	struct symtab_Parameters *pparT
	    = FunctionGetParameter(pfun, "T");

	if (pparCIn
	    && pparCOut
	    && pparValency
	    && pparT)
	{
	    //- calculate parameter values

	    double dCIn = ParameterResolveValue(pparCIn, ppist);
	    double dCOut = ParameterResolveValue(pparCOut, ppist);
	    double dValency = ParameterResolveValue(pparValency, ppist);
	    double dT = ParameterResolveValue(pparT, ppist);

	    //- calculate result : nernst potential

/* SI units */
#define GAS_CONSTANT	8.314			/* (V * C)/(deg K * mol) */
#define FARADAY		9.6487e4			/* C / mol */
#define ZERO_CELSIUS	273.15			/* deg */
#define R_OVER_F        8.6171458e-5		/* volt/deg */
#define F_OVER_R        1.1605364e4		/* deg/volt */

	    double dConstant = R_OVER_F * (dT + ZERO_CELSIUS) / dValency;
	    dResult = dConstant * log(dCOut / dCIn);
	}
    }

    //- else

    else
    {
	//- give diag's : not yet implemented

	fprintf(stderr, "Function %s not implemented\n", pcName);
    }

    //- return result

    return(dResult);
}


