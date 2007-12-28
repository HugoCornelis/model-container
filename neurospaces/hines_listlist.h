
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
    //m list of lists

    HSolveList hslHeader;
};


struct HSolveListListElement
{
    //m link elements into regular list

    HSolveListElement hsleLink;

    //m list of elements

    HSolveList hslList;
};



//d
//d test type(phsll) == struct HSolveListList * at compile time
//d

#define CompileTimeTestHSolveListList(phsll)				\
do {									\
    struct HSolveListList hsll;						\
    (phsll) == &hsll;							\
} while (0)


//d
//d test type(phslle) == struct HSolveListListElement * at compile time
//d

#define CompileTimeTestHSolveListListElement(phslle)			\
do {									\
    struct HSolveListListElement hslle;					\
    (phslle) == &hslle;							\
} while (0)


//d give pointer to hsolve list of given element

#define HSolveListListList(phslleListElement)				\
    (&(phslleListElement)->hslList)


//d initialize a list of lists

#define HSolveListListInit(phsllList)					\
    do {								\
	CompileTimeTestHSolveListList(phsllList);			\
									\
	HSolveListInit(&(phsllList)->hslHeader);			\
    } while (0)


//d initialize the list of an element of list of lists
//d
//d it is permitted to initialize the list of an element already in a list

#define HSolveListListElementListInit(phslleList)			\
    do {								\
	CompileTimeTestHSolveListListElement(phslleList);		\
									\
	HSolveListInit(&(phslleList)->hslList);				\
    } while (0)


//d add list element to head of list
//d
//d should use insert with predecessor here

#define HSolveListListEnqueue(phsllList,phslleNew)			\
    do {								\
	CompileTimeTestHSolveListList(phsllList);			\
	CompileTimeTestHSolveListListElement(phslleNew);		\
									\
	HSolveListEnqueue						\
	    (&(phsllList)->hslHeader,					\
	     &(phslleNew)->hsleLink);					\
    } while (0)


//d remove list element from list
//d
//d do not use with a pp argument (like HSolveListHead() )
//d var's are always possible

#define HSolveListListRemove(phslleElement)				\
    do {								\
	CompileTimeTestHSolveListListElement(phslleNew);		\
									\
	HSolveListRemove(&(phslleElement)->hsleLink);			\
    } while (0)


// functions

int HSolveListListIsEmpty(HSolveListList *phsllList);


#endif


