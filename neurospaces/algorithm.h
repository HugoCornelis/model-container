//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithm.h 1.20 Sun, 11 Mar 2007 21:42:11 -0500 hugo $
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
** algorithm structures
*/

#ifndef ALGORITHM_H
#define ALGORITHM_H


#include <stdio.h>


// declarations

struct AlgorithmHandlerLibrary;
struct symtab_Algorithm;


#include "neurospaces.h"
#include "hines_list.h"
#include "modelevent.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


//f
//f

typedef
int AlgorithmHandler
    (struct symtab_Algorithm *palg,char *pcName,void *pvGlobal,void *pvData);

typedef
int AlgorithmSymbolHandler
    (struct symtab_Algorithm *palg,
     struct symtab_HSolveListElement *phsle,
     void *pvGlobal);


/// \struct
/// \struct algorithm handler library
/// \struct

struct AlgorithmHandlerLibrary
{
    /// after constructor, global is parser context, data is init string

    AlgorithmHandler *pfInit;

    /// after init, before destruct

    AlgorithmHandler *pfCleanup;

    /// print info handler

    AlgorithmHandler *pfPrintInfo;

    /// serial query handler

    AlgorithmHandler *pfSerialHandler;

    /// symbol handler to call for symbol to which algorithm has been attached

    AlgorithmSymbolHandler *pfSymbolHandler;
};


/// \struct
/// \struct gives transparant access to all algorithms, links algorithms into hsolve list
/// \struct

struct symtab_Algorithm
{
    /// link elements into list

    HSolveListElement hsleLink;

    /// gives type of algorithm

    int iType;

    /// flags

    int iFlags;

    /// principal name of entity (-1 for none)

    /// \note I'm wondering if it is usefull to put the index ascii encoded into
    /// \note the name. This can be very usefull for regex's or be contraproductive.
    /// \note Best to wait and see, but try to be compatible, use
    /// \note SymbolName() and SymbolIndex() to get the name (with or without index)
    /// \note and the index of the structure.

    char *pcIdentifier;

    // principal index of algorithm (-1 for none)

    //int iIndex;

    /// algorithm handlers

    struct AlgorithmHandlerLibrary *ppfAlgorithmHandlers;

    /// event association table with event listeners

    ParserEventAssociationTable *pevatListeners;
};


// functions

struct symtab_Algorithm * AlgorithmCalloc(void);

int
AlgorithmDisable
(HSolveList *phsl,char *pcName,PARSERCONTEXT *pacContext);

struct symtab_Algorithm * AlgorithmImport
(HSolveList *phsl,char *pcName,PARSERCONTEXT *pacContext,char *pcInit);

void AlgorithmInit(struct symtab_Algorithm *palg);

struct symtab_Algorithm * AlgorithmLoad(HSolveList *phsl,char *pcName);

struct symtab_Algorithm * AlgorithmLookup(HSolveList *phsl,char *pcName);

char * AlgorithmName(struct symtab_Algorithm *palg);

int AlgorithmPrint
(struct symtab_Algorithm *palg,int iIndent,FILE *pfile);

int AlgorithmsPropagateParserEvent(ParserEvent *pev);

/* int AlgorithmHandleSymbol */
/* (struct symtab_Algorithm *palg,struct symtab_HSolveListElement *phsle,void *pv); */

int AlgorithmsInit(HSolveList *phsl,struct Symbols *pisSymbols);

int AlgorithmsPrint(HSolveList *phsl,FILE *pfile);


#endif


