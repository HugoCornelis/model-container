//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithmset.h 1.11 Fri, 18 May 2007 23:45:18 -0500 hugo $
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
** algorithm set structures
*/

#ifndef ALGORITHMSET_H
#define ALGORITHMSET_H


#include "hines_list.h"


/// \struct algorithm set

struct AlgorithmSet
{
    /// list of loaded algorithm classes

    HSolveList hslClasses;

    /// number of available classes

    int iClasses;

    /// list of algorithm instances

    HSolveList hslInstances;

    /// number of available instances

    int iInstances;
};

typedef struct AlgorithmSet AlgorithmSet;


//#include "modelevent.h"
#include "algorithminstance.h"
#include "neurospaces/components/algorithmsymbol.h"
#include "parameters.h"
#include "parsersupport.h"


AlgorithmSet * AlgorithmSetCalloc(void);

void AlgorithmSetFree(AlgorithmSet *pas);

struct AlgorithmInstance *
AlgorithmSetInstantiateAlgorithm
(AlgorithmSet *pas,
 PARSERCONTEXT *pacContext,
 char *pcName,
 char *pcInstance,
 struct symtab_Parameters *ppar,
 struct symtab_AlgorithmSymbol *palgs);

int AlgorithmSetInit(AlgorithmSet *pas);

struct AlgorithmClass * AlgorithmSetLoadAlgorithmClass(AlgorithmSet *pas,char *pcName);

struct AlgorithmClass * AlgorithmSetLookupAlgorithmClass(AlgorithmSet *pas,char *pcName);

int AlgorithmSetPrint(AlgorithmSet *pas,FILE *pfile);

int AlgorithmSetClassPrint(AlgorithmSet *pas, char *pc, FILE *pfile);

int AlgorithmSetInstancePrint(AlgorithmSet *pas, char *pc, FILE *pfile);

//int AlgorithmSetPropagateParserEvent(AlgorithmSet *pas,ParserEvent *pev);



#endif


