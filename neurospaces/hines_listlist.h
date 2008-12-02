
/* Version EDSUA23a 98/10/05, Hugo Cornelis, BBF-UIA 10/98 */

/*
** $Log: hines_conn.h,v $
** header for connection functionality between different solvers
**
*/


#ifndef HINES_LISTLIST_H
#define HINES_LISTLIST_H


/* system includes */

/* application includes */

/* local includes */

#include "hines_list.h"


typedef struct HSolveListListElement HSolveListListElement;

typedef struct HSolveListList HSolveListList;


struct HSolveListList
{
    /// list of lists

    HSolveList hslHeader;
};


struct HSolveListListElement
{
    /// link elements into regular list

    HSolveListElement hsleLink;

    /// list of elements

    HSolveList hslList;
};



/// \def
/// \def test type(phsll) == struct HSolveListList * at compile time
/// \def

#define CompileTimeTestHSolveListList(phsll)				\
do {									\
    struct HSolveListList hsll;						\
    (phsll) == &hsll;							\
} while (0)


/// \def
/// \def test type(phslle) == struct HSolveListListElement * at compile time
/// \def

#define CompileTimeTestHSolveListListElement(phslle)			\
do {									\
    struct HSolveListListElement hslle;					\
    (phslle) == &hslle;							\
} while (0)


/// \def give pointer to hsolve list of given element

#define HSolveListListList(phslleListElement)				\
    (&(phslleListElement)->hslList)


/// \def initialize a list of lists

#define HSolveListListInit(phsllList)					\
    do {								\
	CompileTimeTestHSolveListList(phsllList);			\
									\
	HSolveListInit(&(phsllList)->hslHeader);			\
    } while (0)


/// \def initialize the list of an element of list of lists
/// \def
/// \def it is permitted to initialize the list of an element already in a list

#define HSolveListListElementListInit(phslleList)			\
    do {								\
	CompileTimeTestHSolveListListElement(phslleList);		\
									\
	HSolveListInit(&(phslleList)->hslList);				\
    } while (0)


/// \def add list element to head of list
/// \def
/// \def should use insert with predecessor here

#define HSolveListListEnqueue(phsllList,phslleNew)			\
    do {								\
	CompileTimeTestHSolveListList(phsllList);			\
	CompileTimeTestHSolveListListElement(phslleNew);		\
									\
	HSolveListEnqueue						\
	    (&(phsllList)->hslHeader,					\
	     &(phslleNew)->hsleLink);					\
    } while (0)


/// \def remove list element from list
/// \def
/// \def do not use with a pp argument (like HSolveListHead() )
/// \def var's are always possible

#define HSolveListListRemove(phslleElement)				\
    do {								\
	CompileTimeTestHSolveListListElement(phslleNew);		\
									\
	HSolveListRemove(&(phslleElement)->hsleLink);			\
    } while (0)


// functions

int HSolveListListIsEmpty(HSolveListList *phsllList);


#endif


