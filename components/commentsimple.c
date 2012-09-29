//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/commentsimple.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"

#include "neurospaces/symbolvirtual_protos.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif



/// 
/// \return struct symtab_CommentSimple * 
/// 
///	Newly allocated comment, NULL for failure
/// 
/// \brief Allocate a new comment symbol table element
/// 

struct symtab_CommentSimple * CommentSimpleCalloc(void)
{
    //- set default result : failure

    struct symtab_CommentSimple *pcommsResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/comment_simple_vtable.c"

    //- allocate comment symbol

    pcommsResult
	= (struct symtab_CommentSimple *)
	  SymbolCalloc(1, sizeof(struct symtab_CommentSimple), _vtable_comment_simple, HIERARCHY_TYPE_symbols_comment_simple);

    //- initialize comment symbol

    CommentSimpleInit(pcommsResult);

    //- return result

    return(pcommsResult);
}


/// 
/// \arg pcomms symbol to collect mandatory parameters for.
/// \arg ppist context.
/// 
/// \return int : success of operation.
/// 
/// \brief Collect mandatory simulation parameters for this symbol,
/// instantiate them in cache such that they are present during
/// serialization.
/// 

int
CommentSimpleCollectMandatoryParameterValues
(struct symtab_CommentSimple *pcomms, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    static char *ppc_comment_simple_mandatory_parameter_names[] =
	{
	    "TEXT",
	    (char *)0,
	};

    int i;

/*     for (i = 0 ; ppc_comment_simple_mandatory_parameter_names[i] ; i++) */
/*     { */
/* 	struct symtab_Parameters *pparValue */
/* 	    = SymbolFindParameter(&pcomms->hsle, ppist, ppc_comment_simple_mandatory_parameter_names[i]); */

/* 	struct symtab_Parameters *pparOriginal */
/* 	    = ParameterLookup(pcomms->bio.pparc->ppars, ppc_comment_simple_mandatory_parameter_names[i]); */

/* 	if (pparValue && (!pparOriginal || ParameterIsSymbolic(pparOriginal) || ParameterIsField(pparOriginal))) */
/* 	{ */
/* 	    double dValue = ParameterResolveValue(pparValue, ppist); */

/* 	    struct symtab_Parameters *pparDuplicate = ParameterNewFromNumber(ppc_comment_simple_mandatory_parameter_names[i], dValue); */

/* 	    BioComponentChangeParameter(&pcomms->bio, pparDuplicate); */
/* 	} */
/*     } */

    //- return result

    return(iResult);
}


/// 
/// \arg pcomms symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
CommentSimpleCreateAlias
(struct symtab_CommentSimple *pcomms,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_CommentSimple *pcommsResult = CommentSimpleCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pcommsResult->hsle, pidin);
    SymbolSetNamespace(&pcommsResult->hsle, pcNamespace);
    SymbolSetPrototype(&pcommsResult->hsle, &pcomms->hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_comment_simple);

    //- return result

    return(&pcommsResult->hsle);
}


/// 
/// \arg pcomms comment symbol to init
/// 
/// \return void
/// 
/// \brief init comment symbol
/// 

void CommentSimpleInit(struct symtab_CommentSimple *pcomms)
{
    //- init base symbol

    SymbolInit(&pcomms->hsle);

    //- set type

    pcomms->hsle.iType = HIERARCHY_TYPE_symbols_comment_simple;

/*     //- create default bindables for the CommentSimple. */

/*     static char *ppcParameters[] = { */
/* 	"TEXT", */
/* 	NULL, */
/*     }; */

/*     static int piTypes[] = { */
/* 	INPUT_TYPE_INPUT, */
/* 	INPUT_TYPE_OUTPUT, */
/* 	INPUT_TYPE_OUTPUT, */
/* 	INPUT_TYPE_INVALID, */
/*     }; */

/*     static struct symtab_IOContainer *piocCommentSimpleDefault = NULL; */

/*     if (!piocCommentSimpleDefault) */
/*     { */
/* 	piocCommentSimpleDefault = IOContainerNewFromList(ppcParameters, piTypes); */
/*     } */

/*     SymbolAssignBindableIO(&pcomms->hsle, piocCommentSimpleDefault); */
}


/* ///  */
/* /// \arg pcomms comment symbol to reduce. */
/* /// \arg ppist context of comment symbol. */
/* ///  */
/* /// \return int success of operation. */
/* ///  */
/* /// \brief Reduce the parameters of a comment symbol. */
/* /// */
/* /// \details Reduces: */
/* /// */

/* int */
/* CommentSimpleReduce */
/* (struct symtab_CommentSimple *pcomms, struct PidinStack *ppist) */
/* { */
/*     //- set default result: success */

/*     int iResult = 1; */

/*     { */
/* 	//- get G_MAX parameter */

/* 	struct symtab_Parameters *pparG */
/* 	    = SymbolGetParameter(&pcomms->bio.ioh.iol.hsle, ppist, "G_MAX"); */

/* 	//- if has GENESIS2 function */

/* 	if (0 */
/* 	    && pparG */
/* 	    && ParameterIsFunction(pparG) */
/* 	    && strcmp(FunctionGetName(ParameterGetFunction(pparG)), "GENESIS2") == 0) */
/* 	{ */
/* 	    //- get scaled conductance */

/* 	    double dGScaled = ParameterResolveScaledValue(pparG, ppist); */

/* 	    //- find parent segment */

/* 	    struct PidinStack *ppistComp */
/* 		= SymbolFindParentSegment(&pcomms->bio.ioh.iol.hsle, ppist); */

/* 	    //- if found segment */

/* 	    if (ppistComp) */
/* 	    { */
/* /* 		//- remove the previous G_MAX parameter * */

/* /* 		ParContainerDelete(pcomms->bio.pparc, pparG); * */

/* 		/// surface */

/* 		double dSurface; */

/* 		//- get segment diameter */

/* 		struct symtab_HSolveListElement *phsle */
/* 		    = PidinStackLookupTopSymbol(ppistComp); */

/* 		double dDia */
/* 		    = SymbolParameterResolveValue(phsle, ppistComp, "DIA"); */

/* 		//- if spherical */

/* 		if (SegmenterIsSpherical((struct symtab_Segmenter *)phsle, ppistComp)) */
/* 		{ */
/* 		    //- calculate surface */

/* 		    dSurface = dDia * dDia * M_PI; */
/* 		} */

/* 		//- else */

/* 		else */
/* 		{ */
/* 		    //- get segment length */

/* 		    double dLength */
/* 			= SymbolParameterResolveValue(phsle, ppistComp, "LENGTH"); */

/* 		    //- calculate surface */

/* 		    dSurface = dDia * dLength * M_PI; */
/* 		} */

/* 		//- free allocated memory */

/* 		PidinStackFree(ppistComp); */

/* 		//- unscale conductance to surface of segment */

/* 		double dGUnscaled = dGScaled / dSurface; */

/* 		//- set this as G_MAX */

/* 		SymbolSetParameterDouble(&pcomms->bio.ioh.iol.hsle, "G_MAX", dGUnscaled); */

/* 	    } */
/* 	} */
/*     } */

/*     //- reduce bio component */

/*     iResult = iResult && BioComponentReduce(&pcomms->bio, ppist); */

/*     //- return result */

/*     return(iResult); */
/* } */


