//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithminstance.h 1.12 Mon, 16 Apr 2007 22:19:04 -0500 hugo $
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


/*
** algorithm instance structures
*/

#ifndef ALGORITHMINSTANCE_H
#define ALGORITHMINSTANCE_H


#include <stdio.h>


// declarations

struct AlgorithmInstanceHandlerLibrary;
struct AlgorithmInstance;



#ifndef SWIG
static inline 
#endif
char * AlgorithmInstanceGetName(struct AlgorithmInstance *palgi);

#ifndef SWIG
static inline 
#endif
void AlgorithmInstanceSetName(struct AlgorithmInstance *palgi, char *pc);


#include "parsersupport.h"
#include "symboltable.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


//f
//f

/* typedef */
/* int AlgorithmInstanceHandler */
/*     (struct AlgorithmInstance *palgi,char *pcName,void *pvGlobal,void *pvData); */

/* typedef */
/* int AlgorithmInstanceSymbolHandler */
/*     (struct AlgorithmInstance *palgi, struct ParserContext *pac); */


/// \struct
/// \struct algorithm handler library
/// \struct

/* struct AlgorithmInstanceHandlerLibrary */
/* { */
/*     /// print info handler */

/*     AlgorithmInstanceHandler *pfPrintInfo; */

/*     /// symbol handler to call for symbol to which algorithm has been attached */

/*     AlgorithmInstanceSymbolHandler *pfSymbolHandler; */
/* }; */


#include "hines_list.h"
#include "algorithmclass.h"
#include "algorithminstance_vtable.h"


/// \struct
/// \struct gives transparant access to all algorithm instances, links into hsolve list
/// \struct

struct AlgorithmInstance
{
    /// link elements into list

    HSolveListElement hsleLink;

    /// points to class from which this is an instance

    struct AlgorithmClass *palgc;

    /// flags

    int iFlags;

    /// identifier of algorithm instance

    char *pcIdentifier;

/*     /// algorithm handlers */

/*     struct AlgorithmInstanceHandlerLibrary *ppfHandlers; */

/*     /// event association table with event listeners */

/*     ParserEventAssociationTable *pevatListeners; */
};


//#include "parsersupport.h"
struct ParserContext;


// functions

struct AlgorithmInstance * AlgorithmInstanceCalloc/* (void) */
(size_t nmemb, size_t size, VTable_algorithm_instances * _vtable, int iType);

int
AlgorithmInstanceDisable
(struct AlgorithmInstance *palgi,char *pcName,struct ParserContext *pacContext);

/* char * AlgorithmInstanceGetName(struct AlgorithmInstance *palgi); */

void
AlgorithmInstanceInit(struct AlgorithmInstance *palgi);
/* (struct AlgorithmInstance *palgi, */
/*  char *pc, */
/*  struct AlgorithmInstanceHandlerLibrary *ppf); */

int AlgorithmInstancePrintInfo(struct AlgorithmInstance *palgi, FILE *pfile);

int AlgorithmInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);



#ifndef SWIG
static inline 
#endif
char * AlgorithmInstanceGetName(struct AlgorithmInstance *palgi)
{
    return(palgi->pcIdentifier);
}


#ifndef SWIG
static inline 
#endif
void AlgorithmInstanceSetName(struct AlgorithmInstance *palgi, char *pc)
{
    palgi->pcIdentifier = pc;
}


#endif


