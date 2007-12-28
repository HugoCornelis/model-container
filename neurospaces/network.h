//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: network.h 1.36 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef NETWORK_H
#define NETWORK_H


#include <stdio.h>


#include "biocomp.h"
#include "hines_list.h"
#include "inputoutput.h"
#include "pidinstack.h"
#include "segmenter.h"


//s structure declarations

struct descr_Network;
struct symtab_Network;


//f exported functions

struct symtab_Network * NetworkCalloc(void);

int NetworkCountCells
(struct symtab_Network *pnetw,struct PidinStack *ppist);

int NetworkCountConnections
(struct symtab_Network *pnetw,struct PidinStack *ppist);

struct symtab_HSolveListElement * 
NetworkCreateAlias
(struct symtab_Network *pnetw,
 struct symtab_IdentifierIndex *pidin);

void NetworkInit(struct symtab_Network *pnetw);

int NetworkTraverseCells
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);

int
NetworkTraverseConnections
(struct symtab_Network *pnetw,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "hines_list.h"
#include "idin.h"
#include "inputoutput.h"
#include "parameters.h"
#include "pidinstack.h"
#include "symboltable.h"


//s
//s network description
//s

struct descr_Network
{
    //m dummy

    int iDummy;
};


//s
//s struct symtab_Network
//s

struct symtab_Network
{
    //m base struct : segmenter

    struct symtab_Segmenter segr;

    //m network description

    struct descr_Network denetw;
};


#endif


