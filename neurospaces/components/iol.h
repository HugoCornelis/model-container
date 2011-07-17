//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iol.h 1.8.1.23 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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
** symbol table grammatical structures
*/

#ifndef IOL_H
#define IOL_H


#include "neurospaces/hines_list.h"
#include "neurospaces/symboltable.h"


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// \struct gives transparant access to structures with input/output, inherits from
/// linked list structure

struct symtab_IOList
{
    /// base symbol

    struct symtab_HSolveListElement hsle;

    /// bindable input/output relations for outside world

    struct symtab_IOContainer * piocBindable;

    /// bounded input from inside elements

    struct symtab_IOContainer * piocInputs;
};


#include "neurospaces/iocontainer.h"


/// static inline prototypes

#ifndef SWIG
static inline
#endif
int
IOListAssignBindableIO
(struct symtab_IOList *piol, struct symtab_IOContainer *pioc);

#ifndef SWIG
static inline
#endif
int
IOListAssignInputs
(struct symtab_IOList *piol, struct symtab_InputOutput *pio);

#ifndef SWIG
static inline
#endif
int
IOListHasBindableIO
(struct symtab_IOList *piol, char *pcInput, int i);

#ifndef SWIG
static inline
#endif
struct PidinStack *
IOListResolveInput
(struct symtab_IOList *piol, struct PidinStack *ppist, char *pcName, int i);


#ifndef SWIG
static inline
#endif
struct PidinStack *
IOListResolveTypedInput
(struct symtab_IOList *piol, struct PidinStack *ppist, char *pcName, char *pcType, int i);


// prototype functions

/* struct symtab_IOList * IOListCalloc(void); */

struct symtab_IOContainer *
IOListGetBindables
(struct symtab_IOList *piol);

struct symtab_IOContainer *
IOListGetInputs
(struct symtab_IOList *piol);

int IOListInit(struct symtab_IOList * piol);


#include "neurospaces/iocontainer.h"


/// 
/// assign inputs
/// 

#ifndef SWIG
static inline
#endif
int
IOListAssignBindableIO
(struct symtab_IOList *piol, struct symtab_IOContainer *pioc)
{
    piol->piocBindable = pioc;

    return(TRUE);
}


/// 
/// set outside bindable fields of given I/O element
/// 

/// \todo remove

#ifndef SWIG
static inline
#endif
void
IOContainerAssignRelations
(struct symtab_IOContainer *pioc,  struct symtab_InputOutput *pio);

#ifndef SWIG
static inline
#endif
int
IOListAssignInputs
(struct symtab_IOList *piol, struct symtab_InputOutput *pio)
{
    IOContainerAssignRelations(piol->piocInputs, pio);

    return(TRUE);
}


/// 
/// check if element has specified I/O
/// 

/// \todo remove

#ifndef SWIG
static inline
#endif
int
IOContainerHasRelation(struct symtab_IOContainer *pioc, char *pc, int i);

#ifndef SWIG
static inline
#endif
int
IOListHasBindableIO
(struct symtab_IOList *piol, char *pcInput, int i)
{
    return(IOContainerHasRelation(piol->piocBindable, pcInput, i));
}


/// 
/// find specified bindable I/O
/// 

#ifndef SWIG
static inline
#endif
struct symtab_InputOutput *
IOListLookupBindableIO
(struct symtab_IOList *piol, char* pcInput, int i)
{
    if (!piol->piocBindable)
    {
	return(NULL);
    }

    return(IOContainerLookupRelation(piol->piocBindable, pcInput, i));
}


/// 
/// find element that is attached to the given input
/// 

#ifndef SWIG
static inline
#endif
struct PidinStack *
IOListResolveInput
(struct symtab_IOList *piol, struct PidinStack *ppist, char *pcName, int i)
{
    return(IOContainerResolve(piol->piocInputs, ppist, pcName, i));
}


/// 
/// find element that is attached to the given input
/// 

#ifndef SWIG
static inline
#endif
struct PidinStack *
IOListResolveTypedInput
(struct symtab_IOList *piol, struct PidinStack *ppist, char *pcName, char *pcType, int i)
{
    return(IOContainerTypedResolve(piol->piocInputs, ppist, pcName, pcType, i));
}


#endif


