//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: parcontainer.h 1.18 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#ifndef PARCONTAINER_H
#define PARCONTAINER_H


#include <stdio.h>


//s structure declarations

struct symtab_ParContainer;


#include "parameters.h"


//s
//s parameter container
//s

struct symtab_ParContainer
{
    //m link structures into list

    struct symtab_Parameters *ppars;
};


//d
//d test type(ppar) == struct symtab_Parameters * at compile time
//d

#define CompileTimeTestParameter(ppar)					\
do {									\
    struct symtab_Parameters par;					\
    (ppar) == &par;							\
} while (0)


//d
//d test type(pparc) == struct symtab_ParContainer * at compile time
//d

#define CompileTimeTestParContainer(pparc)				\
do {									\
    struct symtab_ParContainer parc;					\
    (pparc) == &parc;							\
} while (0)


//d
//d get parameter list from container
//d

#define ParContainerGetParameters(pparc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    (pparc)->ppars;							\
})


//d
//d start iterate over all parameters
//d

#define ParContainerIterateParameters(pparc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParContainerGetParameters(pparc);					\
})


//d
//d lookup parameter
//d

#define ParContainerLookupParameter(pparc,pc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParameterLookup((pparc)->ppars,(pc));				\
})


//d
//d get info for next iteration
//d

#define ParContainerNextParameter(ppar)					\
({									\
    CompileTimeTestParameter(ppar);					\
    (ppar)->pparNext;							\
})


//d
//d print parameters inside container
//d

#define ParContainerPrint(pparc,bAll,iIndent,pfile)			\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParameterPrint((pparc)->ppars,(bAll),(iIndent),(pfile));		\
})


//d
//d get element attached to named parameter input
//d

#define ParContainerResolveParameterFunctionalInput(pparc,ppist,pcParameter,pcInput,i)\
({									\
    struct symtab_HSolveListElement *phsleResult = NULL;		\
    struct symtab_Parameters *ppar = NULL;				\
									\
    CompileTimeTestParContainer(pparc);					\
    CompileTimeTestPidinStack(ppist);					\
									\
    ppar = ParContainerLookupParameter((pparc),(pcParameter));		\
									\
    if (ppar)								\
    {									\
	phsleResult							\
		= ParameterResolveFunctionalInput			\
		  (ppar,(ppist),(pcInput),(i));				\
    }									\
    phsleResult;							\
})


//f exported functions

int
ParContainerAssignParameters
(struct symtab_ParContainer *pparc, struct symtab_Parameters *ppar);

struct symtab_ParContainer * ParContainerCalloc(void);

void ParContainerInit(struct symtab_ParContainer * pparc);

void ParContainerInsert
(struct symtab_ParContainer *pparc,struct symtab_Parameters *ppar);

void ParContainerLinkAtEnd
(struct symtab_ParContainer *pparc,struct symtab_Parameters *pparNew);


#endif


