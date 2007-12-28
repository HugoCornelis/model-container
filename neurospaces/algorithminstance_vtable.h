//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: algorithminstance_vtable.h 1.4 Sun, 10 Jun 2007 22:10:23 -0500 hugo $
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
** support for run-time binding of functions in various flavours.
*/

#ifndef ALGORITHMINSTANCE_VTABLE_H
#define ALGORITHMINSTANCE_VTABLE_H


// type maintenance structures

struct _algorithm_instances_vtable
{
    union rt_selector_algorithm_instances
    {
	int (*iFunc)();

	struct PidinStack *(*ppistFunc)();
    }
	uSelector;
};


typedef struct _algorithm_instances_vtable VTable_algorithm_instances;


struct _algorithm_instances_typeinfo
{
    int iType;
    struct _algorithm_instances_vtable *_vptr;
};


// convenience defines for the above

//d get pointer to ttable

#define typeinfo_algorithm_instances(palgi) \
    ((struct _algorithm_instances_typeinfo *)&((struct _algorithm_instances_typeinfo *)palgi)[-1])


#include "hierarchy/output/algorithm_instances/entries.h"


#define attach_typeinfo_algorithm_instances(palgi, vtable, iType)	\
do {									\
    struct _algorithm_instances_typeinfo *_tptr = typeinfo_algorithm_instances(palgi);	\
    _tptr->_vptr = _vtable;						\
    _tptr->iType = iType;						\
} while (0)


#endif


