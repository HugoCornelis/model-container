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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef PARCONTAINER_H
#define PARCONTAINER_H


#include <stdio.h>


/// \struct structure declarations

struct symtab_ParContainer;


#include "parameters.h"


/// \struct
/// \struct parameter container
/// \struct

struct symtab_ParContainer
{
    /// link structures into list

    struct symtab_Parameters *ppars;
};


/// \def
/// \def test type(ppar) == struct symtab_Parameters * at compile time
/// \def

#define CompileTimeTestParameter(ppar)					\
do {									\
    struct symtab_Parameters par;					\
    (ppar) == &par;							\
} while (0)


/// \def
/// \def test type(pparc) == struct symtab_ParContainer * at compile time
/// \def

#define CompileTimeTestParContainer(pparc)				\
do {									\
    struct symtab_ParContainer parc;					\
    (pparc) == &parc;							\
} while (0)


/// \def
/// \def get parameter list from container
/// \def

#define ParContainerGetParameters(pparc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    (pparc)->ppars;							\
})


/// \def
/// \def start iterate over all parameters
/// \def

#define ParContainerIterateParameters(pparc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParContainerGetParameters(pparc);					\
})


/// \def
/// \def lookup parameter
/// \def

#define ParContainerLookupParameter(pparc,pc)				\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParameterLookup((pparc)->ppars,(pc));				\
})


/// \def
/// \def get info for next iteration
/// \def

#define ParContainerNextParameter(ppar)					\
({									\
    CompileTimeTestParameter(ppar);					\
    (ppar)->pparNext;							\
})


/// \def
/// \def print parameters inside container
/// \def

#define ParContainerPrint(pparc,bAll,iIndent,pfile)			\
({									\
    CompileTimeTestParContainer(pparc);					\
    ParameterPrint((pparc)->ppars,(bAll),(iIndent),(pfile));		\
})


/// \def
/// \def get element attached to named parameter input
/// \def

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


