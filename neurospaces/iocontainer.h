//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iocontainer.h 1.6.1.23 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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


/*
** symbol table grammatical structures
*/

#ifndef IOCONTAINER_H
#define IOCONTAINER_H


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


//s
//s gives transparant access to I/O structures
//s

struct symtab_IOContainer
{
    //m input/output relations

    struct symtab_InputOutput *pio;
};


//d
//d test type(pio) == struct symtab_InputOutput * at compile time
//d

#define CompileTimeTestInputOutput(pio)					\
do {									\
    struct symtab_InputOutput io;					\
    (pio) == &io;							\
} while (0)


//d
//d get info for next iteration
//d

#define IOContainerNextRelation(pio)					\
({									\
    CompileTimeTestInputOutput(pio);					\
    (pio)->pioNext;							\
})


//#include "pidinstack.h"


struct PidinStack;
struct symtab_IOList;


// prototype functions

struct symtab_IOContainer * IOContainerCalloc(void);

int IOContainerCountIOs(struct symtab_IOContainer * pioc);

void IOContainerInit(struct symtab_IOContainer * pioc);

struct symtab_InputOutput *
IOContainerLookupRelation
(struct symtab_IOContainer * pioc,char *pc,int iCount);

struct PidinStack * 
IOContainerResolve
(struct symtab_IOContainer * pioc,
 struct PidinStack *ppist,
 char *pc,
 int iPosition);

int 
IOContainerResolvePosition
(struct symtab_IOContainer * piocTarget,
 struct PidinStack *ppist,
 struct symtab_IOList * piolSource);


#include "inputoutput.h"


/* //f static inline prototypes */

#ifndef SWIG
static inline
#endif
void
IOContainerAssignRelations
(struct symtab_IOContainer *pioc,  struct symtab_InputOutput *pio);

#ifndef SWIG
static inline
#endif
struct symtab_InputOutput *
IOContainerGetRelations(struct symtab_IOContainer *pioc);

#ifndef SWIG
static inline
#endif
int
IOContainerHasRelation(struct symtab_IOContainer *pioc, char *pc, int i);

#ifndef SWIG
static inline
#endif
struct symtab_InputOutput *
IOContainerIterateRelations(struct symtab_IOContainer *pioc);

#ifndef SWIG
static inline
#endif
struct symtab_IOContainer *
IOContainerNewFromIO(struct symtab_InputOutput *pio);


///
/// assign I/O list from container
///

#ifndef SWIG
static inline
#endif
void
IOContainerAssignRelations
(struct symtab_IOContainer *pioc,  struct symtab_InputOutput *pio)
{
    pioc->pio = pio;
}


///
/// get I/O list from container
///

#ifndef SWIG
static inline
#endif
struct symtab_InputOutput *
IOContainerGetRelations(struct symtab_IOContainer *pioc)
{
    return(pioc->pio);
}


///
/// check if named relation present
///

#ifndef SWIG
static inline
#endif
int
IOContainerHasRelation(struct symtab_IOContainer *pioc, char *pc, int i)
{
    return(IOContainerLookupRelation(pioc, pc, i) != NULL);
}


///
/// start iterate over all I/O's
///

#ifndef SWIG
static inline
#endif
struct symtab_InputOutput *
IOContainerIterateRelations(struct symtab_IOContainer *pioc)
{
    struct symtab_InputOutput *pio = IOContainerGetRelations(pioc);

    if (pio)
    {
	return(pio->pioFirst);
    }
    else
    {
	return(NULL);
    }
}


///
/// construct I/O container from I/O relations
///

#ifndef SWIG
static inline
#endif
struct symtab_IOContainer *
IOContainerNewFromIO(struct symtab_InputOutput *pio)
{
    struct symtab_IOContainer *pioc = IOContainerCalloc();

    pioc->pio = pio;

    return(pioc);
}


#endif


