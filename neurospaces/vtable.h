//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vtable.h 1.22 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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
** support for run-time binding of functions in various flavours.
*/

#ifndef VTABLE_H
#define VTABLE_H


#include "components/iohier.h"


// type maintenance structures

struct _vtable
{
    union rt_selector_symbols
    {
	char *(*pcFunc)();
	double (*dFunc)();
	int (*iFunc)();

	struct PidinStack *(*ppistFunc)();
	struct symtab_BioComponent *(*pbioFunc)();
	struct symtab_HSolveListElement *(*phsleFunc)();
	struct symtab_IOContainer *(*piocFunc)();
	struct symtab_IOList *(*piolFunc)();
	struct symtab_IdentifierIndex *(*pidinFunc)();
	struct symtab_Parameters *(*pparFunc)();

	IOHContainer * (*piohcFunc)();
    }
	uSelector;
};


typedef struct _vtable VTable_symbols;


struct _typeinfo_symbols
{
    int iType;
    struct _vtable *_vptr;
};


// convenience defines for the above

/// \def get pointer to ttable

#define typeinfo_symbols(phsle) \
    ((struct _typeinfo_symbols *)&((struct _typeinfo_symbols *)phsle)[-1])


#include "hierarchy/output/symbols/entries.h"


#define attach_typeinfo_symbols(phsle, vtable, iType)			\
do {									\
    struct _typeinfo_symbols *_tptr = typeinfo_symbols(phsle);		\
    _tptr->_vptr = _vtable;						\
    _tptr->iType = iType;						\
} while (0)


#endif


