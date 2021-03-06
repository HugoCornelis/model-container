//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: equation.c 1.31 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <stdlib.h>
#include <string.h>


#include "neurospaces/components/equationexponential.h"
#include "neurospaces/idin.h"


/// 
/// \return struct symtab_EquationExponential * 
/// 
///	Newly allocated equation, NULL for failure
/// 
/// \brief Allocate a new equation symbol table element
/// 

struct symtab_EquationExponential * EquationExponentialCalloc(void)
{
    //- set default result : failure

    struct symtab_EquationExponential *peqeResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/equation_exponential_vtable.c"

    //- allocate equation

    peqeResult
	= (struct symtab_EquationExponential *)
	  SymbolCalloc(1, sizeof(struct symtab_EquationExponential), _vtable_equation_exponential, HIERARCHY_TYPE_symbols_equation_exponential);

    //- init equation

    EquationExponentialInit(peqeResult);

    //- set type

    peqeResult->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_equation_exponential;

    //- return result

    return(peqeResult);
}


/// 
/// \arg pchan symbol to collect mandatory parameters for.
/// \arg ppist context.
/// 
/// \return int : success of operation.
/// 
/// \brief Collect mandatory simulation parameters for this symbol,
/// instantiate them in cache such that they are present during
/// serialization.
/// 

int
EquationExponentialCollectMandatoryParameterValues
(struct symtab_EquationExponential *peqe, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    static char *ppc_equation_exponential_mandatory_parameter_names[] =
	{
	    "TAU1",
	    "TAU2",
	    (char *)0,
	};

    int i;

    for (i = 0 ; ppc_equation_exponential_mandatory_parameter_names[i] ; i++)
    {
	struct symtab_Parameters *pparValue
	    = SymbolFindParameter(&peqe->bio.ioh.iol.hsle, ppist, ppc_equation_exponential_mandatory_parameter_names[i]);

	struct symtab_Parameters *pparOriginal
	    = ParameterLookup(peqe->bio.pparc->ppars, ppc_equation_exponential_mandatory_parameter_names[i]);

	if (pparValue && (!pparOriginal || ParameterIsSymbolic(pparOriginal) || ParameterIsField(pparOriginal)))
	{
	    double dValue = ParameterResolveValue(pparValue, ppist);

	    struct symtab_Parameters *pparDuplicate = ParameterNewFromNumber(ppc_equation_exponential_mandatory_parameter_names[i], dValue);

	    BioComponentChangeParameter(&peqe->bio, pparDuplicate);
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg peqe symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
EquationExponentialCreateAlias
(struct symtab_EquationExponential *peqe,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_EquationExponential *peqeResult = EquationExponentialCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&peqeResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&peqeResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&peqeResult->bio.ioh.iol.hsle, &peqe->bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_equation_exponential);

    //- return result

    return(&peqeResult->bio.ioh.iol.hsle);
}


/* ///  */
/* /// \arg peqe equation to init */
/* ///  */
/* /// \return int : type of equation (incoming, outgoing). */
/* ///  */
/* /// \brief Get type of equation. */
/* ///  */

/* int EquationExponentialGetType(struct symtab_EquationExponential *peqe) */
/* { */
/*     return(peqe->deeq.iType); */
/* } */


/// 
/// \arg peqe equation to init
/// 
/// \return void
/// 
/// \brief Init equation
/// 

void EquationExponentialInit(struct symtab_EquationExponential * peqe)
{
    //- initialize base symbol

    BioComponentInit(&peqe->bio);

    //- zero out own fields

    memset(&(&peqe->bio)[1],0,sizeof(*peqe) - sizeof(peqe->bio));

/*     //- set type: exponential */

/*     SymbolSetType(&peqe->bio.ioh.iol.hsle, TYPE_EQUATION_EXPONENTIAL); */
}


/* ///  */
/* /// \arg peqe equation to set type for. */
/* /// \arg iType type of equation. */
/* ///  */
/* /// \return int : success of operation. */
/* ///  */
/* /// \brief Set type of equation. */
/* ///  */

/* int EquationExponentialSetType(struct symtab_EquationExponential *peqe, int iType) */
/* { */
/*     //- set type, return success. */

/*     int iResult = TRUE; */

/*     peqe->deeq.iType = iType; */

/*     return(iResult); */
/* } */


