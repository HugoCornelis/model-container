//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmclass.h 1.10 Sun, 20 May 2007 22:11:53 -0500 hugo $
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
** algorithm class structures
*/

#ifndef ALGORITHMCLASS_H
#define ALGORITHMCLASS_H


#include <stdio.h>


// declarations

struct AlgorithmClassHandlerLibrary;
struct AlgorithmClass;


#include "algorithminstance.h"
#include "hines_list.h"
#include "neurospaces/components/algorithmsymbol.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


//f
//f algorithm class handler
//f

typedef
int AlgorithmClassHandler
    (struct AlgorithmClass *palgc,char *pcName,void *pvGlobal,void *pvData);

typedef
struct AlgorithmInstance *
AlgorithmClassInstanceCreator
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs);


//s
//s algorithm class handler library
//s

struct AlgorithmClassHandlerLibrary
{
    //m print info handler

    AlgorithmClassHandler *pfPrintInfo;

    //m create instance from class (self, name, context, init string)

    AlgorithmClassInstanceCreator *pfCreateInstance;
};


//s
//s gives transparant access to all algorithm classes, links into hsolve list
//s

struct AlgorithmClass
{
    //m link elements into list

    HSolveListElement hsleLink;

/*     //m gives type of algorithm */

/*     int iType; */

/*     //m flags */

/*     int iFlags; */

    //m name algorithm class

    char *pcIdentifier;

    //m algorithm handlers

    struct AlgorithmClassHandlerLibrary *ppfHandlers;
};


// functions

struct AlgorithmClass * AlgorithmClassCalloc(void);

char * AlgorithmClassGetName(struct AlgorithmClass *palgc);

void AlgorithmClassInit(struct AlgorithmClass *palgc);

/* struct AlgorithmClass * AlgorithmClassLoaded(struct AlgorithmClass *palgc); */


#endif


