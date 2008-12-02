//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iohier.h 1.6.1.47 Sat, 20 Oct 2007 19:40:41 -0500 hugo $
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

#ifndef IOHIER_H
#define IOHIER_H


#include <stdio.h>


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


struct symtab_IOHierarchy;


/// \def IOHierarchy container

#define IOHContainer HSolveList

#define IOHContainerIterate(piohc) \
({ \
    (struct symtab_HSolveListElement *)HSolveListHead(piohc); \
})


#include "neurospaces/components/iol.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/pidinstack.h"


/// \struct
/// \struct gives transparant access to hierarchical structures with input/output, 
/// \struct inherits from linked list structure
/// \struct

struct symtab_IOHierarchy
{
    /// base symbol

    struct symtab_IOList iol;

    /// children relations

    IOHContainer iohc;
};


#include "neurospaces/treespacetraversal.h"


// prototype functions

int
IOHierarchyAddChild
(struct symtab_IOHierarchy *pioh,
 struct symtab_HSolveListElement *phsleChild);

#ifdef DELETE_OPERATION
int
IOHierarchyDeleteChild
(struct symtab_IOHierarchy *pioh,
 struct symtab_HSolveListElement *phsleChild);
#endif

/* int IOHierarchyGetNumberOfChildren(struct symtab_IOHierarchy * pioh); */

IOHContainer *
IOHierarchyGetChildren
(struct symtab_IOHierarchy *pioh);

void IOHierarchyInit(struct symtab_IOHierarchy * pioh);

struct symtab_HSolveListElement *
IOHierarchyLookupHierarchical
(struct symtab_IOHierarchy * pioh,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);

int IOHierarchyPrint
(struct symtab_IOHierarchy *pioh,int bAll,int iIndent,FILE *pfile);

/* int IOHierarchyRecalcChildrenSerialToParent(struct symtab_IOHierarchy *pioh); */

int IOHierarchyTraverse
(struct TreespaceTraversal *ptstr, struct symtab_IOHierarchy *pioh);


#endif


