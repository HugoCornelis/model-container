//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithminstance.c 1.12 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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

#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"


#define ALGORITHMINSTANCE_FLAG_MODELACTIVE 1


/// 
/// \return struct AlgorithmInstance * 
/// 
///	Newly allocated algorithm, NULL for failure
/// 
/// \brief Allocate a new algorithm symbol table element
/// 

struct AlgorithmInstance * AlgorithmInstanceCalloc/* (void) */
(size_t nmemb, size_t size, VTable_algorithm_instances * _vtable, int iType)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

/*     //- allocate algorithm */

/*     palgiResult */
/* 	= (struct AlgorithmInstance *) */
/* 	  calloc(1,sizeof(*palgiResult)); */

/*     //- initialize algorithm */

/*     AlgorithmInstanceInit(palgiResult,NULL,NULL); */



    //- calculate size of instance

    size_t vpsize = sizeof(struct _algorithm_instances_typeinfo);

    //- allocate instance

    palgiResult
	= (struct AlgorithmInstance *)
	  &((struct _algorithm_instances_typeinfo *)calloc(nmemb, size + vpsize))[1];

    //- initialize instance

    AlgorithmInstanceInit(palgiResult);

    //- initialize virtual table, type of instance.

    attach_typeinfo_algorithm_instances(palgiResult, _vtable, iType);



    //- return result

    return(palgiResult);
}


/// 
/// \arg pcName name of algorithm to import
/// 
/// \return int : success of operation
/// 
/// \brief disable algorithm with given name
/// 

int
AlgorithmInstanceDisable
(struct AlgorithmInstance *palgi,char *pcName,struct ParserContext *pacContext)
{
    //- set default result : failure

    int bResult = TRUE;

    //- set flag : algorithm inactive

    palgi->iFlags &= ~ALGORITHMINSTANCE_FLAG_MODELACTIVE;

    /// \todo could register where in file tree has been disabled etc.

    //- return result

    return(bResult);
}


/// 
/// \arg palgi algorithm to get name for
/// 
/// \return char * : name of algorithm, NULL for failure
/// 
/// \brief get name of algorithm
///
/// \details 
/// 
///	Return value is pointer to symbol table read only data
/// 

/* char * AlgorithmInstanceGetName(struct AlgorithmInstance *palgi) */
/* { */
/*     //- set default result : no name */

/*     char *pcResult = NULL; */

/*     //- set result from name */

/*     pcResult = palgi->pcIdentifier; */

/*     //- return result */

/*     return(pcResult); */
/* } */


/// 
/// \arg palgi algorithm to init
/// \arg pc name of instance.
/// \arg ppf algorithm instance handlers.
/// 
/// \return void
/// 
/// \brief init algorithm instance.
/// 

void
AlgorithmInstanceInit(struct AlgorithmInstance *palgi)
/* (struct AlgorithmInstance *palgi, */
/*  char *pc, */
/*  struct AlgorithmInstanceHandlerLibrary *ppf) */
{
    //- initialize algorithm

    memset(palgi,0,sizeof(*palgi));

/*     //- assign name */

/*     palgi->pcIdentifier = pc; */

/*     //- assign handlers */

/*     palgi->ppfHandlers = ppf; */
}


/// 
/// \arg palgi algorithm to handle symbol.
/// \arg pfile file to print to.
/// 
/// \return int : success of operation
/// 
/// \brief Print info about algorithm instance.
/// 

/// \todo extract function todo :
/// \todo fontify preview buffer.
/// \todo add function tags : inline, static etc.
/// \todo ask for filename for prototype.

int AlgorithmInstancePrintInfo(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result : ok

    int iResult = TRUE;

/*     //- if info handler available */

/*     if (palgi->ppfHandlers->pfPrintInfo) */
/*     { */
/* 	//- print algorithm info, remember result */

/* 	/// \todo use vtable */

/* 	iResult */
/* 	    = iResult */
/* 	      && palgi->ppfHandlers->pfPrintInfo */
/* 	         (palgi, palgi->pcIdentifier, NULL, pfile); */
/*     } */

    //- get pointer to ttable

    struct _algorithm_instances_typeinfo *_tptr = typeinfo_algorithm_instances(palgi);

    //- get pointer to vtable

    VTable_algorithm_instances * _vtable = _tptr->_vptr;

    //- if pointer to class function defined

    int (*func)() = _vtable[ENTRY_PRINT_INFO].uSelector.iFunc;

    if (func)
    {
	//- class call

	iResult = (*func)(palgi, pfile);
    }

    //- else

    else
    {
	//- not implemented

	fprintf(stdout, "AlgorithmInstancePrintInfo() not implemented\n");
    }

    //- return result

    return(iResult);
}


/// 
/// \arg palgi algorithm to handle symbol.
/// \arg pac parser context.
/// 
/// \return int : success of operation
/// 
/// \brief Ask algorithm to handle a current symbol in the parser context.
/// 

int AlgorithmInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result : ok

    int iResult = TRUE;

    //- call algorithm's symbol handler

    /// \todo use vtable

/*     iResult = palgi->ppfHandlers->pfSymbolHandler(palgi, pac); */

    //- get pointer to ttable

    struct _algorithm_instances_typeinfo *_tptr = typeinfo_algorithm_instances(palgi);

    //- get pointer to vtable

    VTable_algorithm_instances * _vtable = _tptr->_vptr;

    //- if pointer to class function defined

    int (*func)() = _vtable[ENTRY_SYMBOL_HANDLER].uSelector.iFunc;

    if (func)
    {
	//- class call

	iResult = (*func)(palgi, pac);
    }

    //- else

    else
    {
	//- not implemented

	fprintf(stdout, "AlgorithmInstanceHandleSymbol() not implemented\n");
    }

    //- return result

    return(iResult);
}


