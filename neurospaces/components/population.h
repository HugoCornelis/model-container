//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: population.h 1.48 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef POPULATION_H
#define POPULATION_H


#include <stdio.h>


/// \struct structure declarations

struct descr_Population;
struct symtab_Population;


#include "neurospaces/treespacetraversal.h"
#include "segmenter.h"



struct symtab_Population * PopulationCalloc(void);

int PopulationCountCells
(struct symtab_Population *ppopu,
 struct PidinStack *ppist);

struct symtab_HSolveListElement * 
PopulationCreateAlias
(struct symtab_Population *ppopu,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
PopulationGetParameter
(struct symtab_Population *ppopu,
 struct PidinStack *ppist,
 char *pcName);

void PopulationInit(struct symtab_Population *ppopu);

int PopulationLookupSpikeReceiverSerialID
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsleSerial,
 struct PidinStack *ppistSerial);

int PopulationTraverseCells
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata);


#include "biocomp.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symboltable.h"


/// \struct
/// \struct population description
/// \struct

struct descr_Population
{
    /// type of population data

    int iType;

    /// population specific flags (OPTIONS keyword)

    int iFlags;
};


/// \struct
/// \struct struct symtab_Population
/// \struct

struct symtab_Population
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// population description

    struct descr_Population depopu;
};


#endif


