//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: hines_list.h 1.10 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/* Version EDSUA23a 98/10/05, Hugo Cornelis, BBF-UIA 10/98 */

/*
** $Log: hines_conn.h,v $
** header for connection functionality between different solvers
**
*/


#ifndef HINES_LIST_H
#define HINES_LIST_H


/* system includes */

/* application includes */

/* local includes */

//#include "hines_ext.h"


typedef struct hsolve_list_element HSolveListElement;

typedef struct hsolve_list HSolveList;


struct hsolve_list_element
{
    /// normal double linked list, never NULL

    struct hsolve_list_element *phsleNext;
    struct hsolve_list_element *phslePrev;
};


struct hsolve_list
{
    /// two joint nodes (one for head, one for tail)

    /// pointer to head of list

    struct hsolve_list_element *phsleHead;

    /// tail of list, always NULL

    struct hsolve_list_element *phsleTail;

    /// last entry in list

    struct hsolve_list_element *phsleLast;
};



/// \def
/// \def test type(phsl) == struct hsolve_list * at compile time
/// \def

#define CompileTimeTestHSolveList(phsl)					\
do {									\
    struct hsolve_list hsl;						\
    (phsl) == &hsl;							\
} while (0)


/// \def
/// \def test type(phsle) == struct hsolve_list_element * at compile time
/// \def

#define CompileTimeTestHSolveListElement(phsle)				\
do {									\
    struct hsolve_list_element hsle;					\
    (phsle) == &hsle;							\
} while (0)


/// \def
/// \def init an element
/// \def

#define HSolveListElementInit(phsle)					\
do {									\
    CompileTimeTestHSolveListElement(phsle);				\
    (phsle)->phslePrev = NULL;						\
    (phsle)->phsleNext = NULL;						\
} while (0)


/// \def
/// \def link two individual elements that are not yet in a list with a header
/// \def

#define HSolveListElementLink(phsle1,phsle2)				\
do {									\
    CompileTimeTestHSolveListElement(phsle1);				\
    CompileTimeTestHSolveListElement(phsle2);				\
    (phsle1)->phsleNext = (phsle2);					\
    (phsle2)->phslePrev = (phsle1);					\
									\
    if ((phsle1)->phslePrev)						\
    {									\
	(phsle1)->phslePrev->phsleNext = (phsle1);			\
    }									\
    if ((phsle2)->phsleNext)						\
    {									\
	(phsle2)->phsleNext->phslePrev = (phsle2);			\
    }									\
} while (0)


/// \def initialize a list

#define HSolveListInit(phslList)					\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
									\
	(phslList)->phsleHead						\
	    = (HSolveListElement *)&(phslList)->phsleTail;		\
	(phslList)->phsleTail = NULL;					\
	(phslList)->phsleLast						\
	    = (HSolveListElement *)&(phslList)->phsleHead;		\
    } while (0)


/// \def test if a list is empty (this is just one of three possibilities)
/// \def	last == &list,
/// \def	head->next == NULL,
/// \def	tail->prev == NULL
/// \def
/// \def This one is the most efficient ?
/// \def

#define HSolveListIsEmpty(phslList)					\
	(int)((phslList)->phsleLast == (HSolveListElement *)(phslList))	\


/// \def insert element after predecessor
/// \def set predecessor to ->phsleHead to insert at first position
/// \def
/// \def dangerous macro if used with pp macro for tail of list

#define HSolveListInsertWithPred(phsleNew,phslePred)			\
    do {								\
	CompileTimeTestHSolveListElement(phsleNew);			\
	CompileTimeTestHSolveListElement(phslePred);			\
									\
	(phsleNew)->phsleNext = (phslePred)->phsleNext;			\
	(phsleNew)->phslePrev = (phslePred);				\
									\
	(phslePred)->phsleNext->phslePrev = (phsleNew);			\
	(phslePred)->phsleNext = (phsleNew);				\
    } while (0)


/// \def insert element before successor
/// \def set successor to ->phsleLast to add element at the very end
/// \def
/// \def dangerous macro if used with pp macro for head of list

#define HSolveListInsertWithSucc(phsleNew,phsleSucc)			\
    do {								\
	CompileTimeTestHSolveListElement(phsleNew);			\
	CompileTimeTestHSolveListElement(phsleSucc);			\
									\
	(phsleNew)->phsleNext = (phsleSucc);				\
	(phsleNew)->phslePrev = (phsleSucc)->phslePrev;			\
									\
	(phsleSucc)->phslePrev->phsleNext = (phsleNew);			\
	(phsleSucc)->phslePrev = (phsleNew);				\
    } while (0)


/// \def add element to head of list
/// \def
/// \def should use insert with predecessor here

#define HSolveListEnqueue(phslList,phsleNew)				\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
	CompileTimeTestHSolveListElement(phsleNew);			\
									\
	HSolveListInsertWithPred					\
	    ((phsleNew),						\
	     ((HSolveListElement *)(&((HSolveList *)			\
				      (phslList))->phsleHead)));	\
    } while (0)


/// \def add element to tail of list
/// \def should use insert with successor here

#define HSolveListEntail(phslList,phsleNew)				\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
	CompileTimeTestHSolveListElement(phsleNew);			\
									\
	HSolveListInsertWithSucc					\
	    ((phsleNew),						\
	     ((HSolveListElement *)(&((HSolveList *)			\
				      (phslList))->phsleTail)));	\
    } while (0)


/// \def give pointer to first element in list
/// \def
/// \def can give problems if used on an empty list

#define HSolveListHead(phslList)					\
	((HSolveList *)(phslList))->phsleHead				\


/// \def give pointer to last element in list
/// \def
/// \def can give problems if used on an empty list

#define HSolveListTail(phslList)					\
	((HSolveList *)(phslList))->phsleLast				\


/// \def give pointer to next element in list

#define HSolveListNext(phsleElement)					\
	(phsleElement)->phsleNext					\


/// \def give pointer to previous element in list

#define HSolveListPrev(phsleElement)					\
	(phsleElement)->phslePrev					\


/// \def say if element is a valid successor

#define HSolveListValidSucc(phsleElement)				\
	((phsleElement)->phsleNext != NULL)


/// \def say if element is a valid successor

#define HSolveListValidPred(phsleElement)				\
	((phsleElement)->phslePrev != NULL)


/// \def remove element from list
/// \def
/// \def do not use with a pp argument (like HSolveListHead() )
/// \def var's are always possible

#define HSolveListRemove(phsleElement)					\
    do {								\
	CompileTimeTestHSolveListElement(phsleElement);			\
									\
	(phsleElement)->phslePrev->phsleNext				\
	    = (phsleElement)->phsleNext;				\
									\
	(phsleElement)->phsleNext->phslePrev				\
	    = (phsleElement)->phslePrev;				\
    } while (0)


/// \def remove head from list

#define HSolveListRemoveHead(phslList)					\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
									\
	HSolveListElement *phsleHead = HSolveListHead(phslList);	\
									\
	HSolveListRemove(phsleHead);					\
    } while (0)


/// \def remove tail from list

#define HSolveListRemoveTail(phslList)					\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
									\
	HSolveListElement *phsleTail = HSolveListTail(phslList);	\
									\
	HSolveListRemove(phsleTail);					\
    } while (0)


/// \def unlink from - to elements

#define HSolveListUnMerge(phsleFrom,phsleTo)				\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
									\
	(phsleFrom)->phslePrev->phsleNext = (phsleTo)->phsleNext;	\
	(phsleTo)->phsleNext->phslePrev = (phsleFrom)->phslePrev;	\
    } while (0)


/// \def link from - to elements with predecessor
/// \def
/// \def do not use HSolveListHead() or HSolveListTail() as pp arg predecessor

#define HSolveListMergeWithPred(phsleFrom,phsleTo,phslePred)		\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
	CompileTimeTestHSolveListElement(phslePred);			\
									\
	(phsleFrom)->phslePrev = (phslePred);				\
	(phsleTo)->phsleNext = (phslePred)->phsleNext;			\
									\
	(phslePred)->phsleNext->phslePrev = (phsleTo);			\
	(phslePred)->phsleNext = (phsleFrom);				\
    } while (0)


/// \def link from - to elements with successor
/// \def
/// \def do not use HSolveListHead() or HSolveListTail() as pp arg predecessor

#define HSolveListMergeWithSucc(phsleFrom,phsleTo,phsleSucc)		\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
	CompileTimeTestHSolveListElement(phsleSucc);			\
									\
	(phsleFrom)->phslePrev = (phsleSucc)->phslePrev;		\
	(phsleTo)->phsleNext = (phsleSucc);				\
									\
	(phsleSucc)->phslePrev->phsleNext = (phsleFrom);		\
	(phsleSucc)->phslePrev = (phsleTo);				\
    } while (0)


/// \def link from - to elements at head
/// \def

#define HSolveListMergeAtHead(phsleFrom,phsleTo,phslList)		\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
	CompileTimeTestHSolveList(phslList);				\
									\
	(phsleTo)->phsleNext = (phslList)->phsleHead;			\
	(phslList)->phsleHead->phslePrev = (phsleTo);			\
									\
	(phslList)->phsleHead = (phsleFrom);				\
	(phsleFrom)->phslePrev						\
	  = (HSolveListElement *)&(phslList)->phsleHead;		\
    } while (0)


/// \def link from - to elements at tail
/// \def

#define HSolveListMergeAtTail(phsleFrom,phsleTo,phslList)		\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
	CompileTimeTestHSolveList(phslList);				\
									\
	(phsleFrom)->phslePrev = (phslList)->phsleLast;			\
	(phslList)->phsleLast->phsleNext = (phsleFrom);			\
									\
	(phslList)->phsleLast = (phsleTo);				\
	(phsleTo)->phsleNext 						\
	  = (HSolveListElement *)&(phslList)->phsleTail;		\
    } while (0)


#endif


