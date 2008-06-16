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
    //m normal double linked list, never NULL

    struct hsolve_list_element *phsleNext;
    struct hsolve_list_element *phslePrev;
};


struct hsolve_list
{
    //m two joint nodes (one for head, one for tail)

    //m pointer to head of list

    struct hsolve_list_element *phsleHead;

    //m tail of list, always NULL

    struct hsolve_list_element *phsleTail;

    //m last entry in list

    struct hsolve_list_element *phsleLast;
};



//d
//d test type(phsl) == struct hsolve_list * at compile time
//d

#define CompileTimeTestHSolveList(phsl)					\
do {									\
    struct hsolve_list hsl;						\
    (phsl) == &hsl;							\
} while (0)


//d
//d test type(phsle) == struct hsolve_list_element * at compile time
//d

#define CompileTimeTestHSolveListElement(phsle)				\
do {									\
    struct hsolve_list_element hsle;					\
    (phsle) == &hsle;							\
} while (0)


//d
//d init an element
//d

#define HSolveListElementInit(phsle)					\
do {									\
    CompileTimeTestHSolveListElement(phsle);				\
    (phsle)->phslePrev = NULL;						\
    (phsle)->phsleNext = NULL;						\
} while (0)


//d
//d link two individual elements that are not yet in a list with a header
//d

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


//d initialize a list

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


//d test if a list is empty (this is just one of three possibilities)
//d	last == &list,
//d	head->next == NULL,
//d	tail->prev == NULL
//d
//d This one is the most efficient ?
//d

#define HSolveListIsEmpty(phslList)					\
	(int)((phslList)->phsleLast == (HSolveListElement *)(phslList))	\


//d insert element after predecessor
//d set predecessor to ->phsleHead to insert at first position
//d
//d dangerous macro if used with pp macro for tail of list

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


//d insert element before successor
//d set successor to ->phsleLast to add element at the very end
//d
//d dangerous macro if used with pp macro for head of list

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


//d add element to head of list
//d
//d should use insert with predecessor here

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


//d add element to tail of list
//d should use insert with successor here

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


//d give pointer to first element in list
//d
//d can give problems if used on an empty list

#define HSolveListHead(phslList)					\
	((HSolveList *)(phslList))->phsleHead				\


//d give pointer to last element in list
//d
//d can give problems if used on an empty list

#define HSolveListTail(phslList)					\
	((HSolveList *)(phslList))->phsleLast				\


//d give pointer to next element in list

#define HSolveListNext(phsleElement)					\
	(phsleElement)->phsleNext					\


//d give pointer to previous element in list

#define HSolveListPrev(phsleElement)					\
	(phsleElement)->phslePrev					\


//d say if element is a valid successor

#define HSolveListValidSucc(phsleElement)				\
	((phsleElement)->phsleNext != NULL)


//d say if element is a valid successor

#define HSolveListValidPred(phsleElement)				\
	((phsleElement)->phslePrev != NULL)


//d remove element from list
//d
//d do not use with a pp argument (like HSolveListHead() )
//d var's are always possible

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


//d remove head from list

#define HSolveListRemoveHead(phslList)					\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
									\
	HSolveListElement *phsleHead = HSolveListHead(phslList);	\
									\
	HSolveListRemove(phsleHead);					\
    } while (0)


//d remove tail from list

#define HSolveListRemoveTail(phslList)					\
    do {								\
	CompileTimeTestHSolveList(phslList);				\
									\
	HSolveListElement *phsleTail = HSolveListTail(phslList);	\
									\
	HSolveListRemove(phsleTail);					\
    } while (0)


//d unlink from - to elements

#define HSolveListUnMerge(phsleFrom,phsleTo)				\
    do {								\
	CompileTimeTestHSolveListElement(phsleFrom);			\
	CompileTimeTestHSolveListElement(phsleTo);			\
									\
	(phsleFrom)->phslePrev->phsleNext = (phsleTo)->phsleNext;	\
	(phsleTo)->phsleNext->phslePrev = (phsleFrom)->phslePrev;	\
    } while (0)


//d link from - to elements with predecessor
//d
//d do not use HSolveListHead() or HSolveListTail() as pp arg predecessor

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


//d link from - to elements with successor
//d
//d do not use HSolveListHead() or HSolveListTail() as pp arg predecessor

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


//d link from - to elements at head
//d

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


//d link from - to elements at tail
//d

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


