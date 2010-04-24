//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: symboltable.h 1.44.1.69 Thu, 15 Nov 2007 13:04:36 -0600 hugo $
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

#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H


struct PidinStack;
struct symtab_HSolveListElement;
struct symtab_String;


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


#include "hines_list.h"
//#include "solverinfo.h"


// general structures


struct symtab_String
{
    /// actual string

    char *pcString;

    /// length of string

    int iLength;
};


/// \struct structure to do serial mappings contains serial indices
/// relative to different other symbols

struct SerialMapper
{
    /// #SU for *this

    int iSuccessors;

    /// serial relative to parent
    /// 
    /// reflect ordering only, will be same as previous
    /// if symbol does not belong to this subspace

    int iParent;

    /// \note we could add more here :
    /// child number
    /// number of children
    /// post order serial (usefull to init iParent above)
    /// post order ...
    /// more...
    ///
    /// \note Do we need a SerialMapper per space, or a single one
    /// for all spaces ?
};

/// \def some quick defines to give access to the serial ID's

#define SerialMapClearToParent(psmap)	\
	SerialMapSetToParent((psmap),0)
#define SerialMapClearNumOfSuccessors(psmap)	\
	SerialMapSetNumOfSuccessors((psmap),0)

#define SerialMapGetToParent(psmap)	((psmap)->iParent)
#define SerialMapGetNumOfSuccessors(psmap)	((psmap)->iSuccessors)

#define SerialMapSetToParent(psmap,i)	((psmap)->iParent = (i))
#define SerialMapSetNumOfSuccessors(psmap,i)	((psmap)->iSuccessors = (i))


struct symtab_HSolveListElement;


/// \struct gives transparant access to all other structures and links
/// them into a list.

struct symtab_HSolveListElement
{
    /// link elements into list

    HSolveListElement hsleLink;

/*     /// solver information */

/*     struct SolverInfo *psiSolverInfo; */

    /// allocation symbol identifier

    int iAllocationIdentifier;

    /// algorithm instance info

    struct AlgorithmInstance *palgi;

    /// parameter cache

    struct ParameterCache *pparcac;

    /// gives type of element

    int iType;

/*     /// flags */

/*     int iFlags; */

    /// struct to do invisible serial mappings

    struct SerialMapper smapInvisible;

    /// struct to do principal serial mappings

    struct SerialMapper smapPrincipal;

#ifdef TREESPACES_SUBSET_MECHANISM

    /// struct to do mechanism space serial mappings

    struct SerialMapper smapMechanism;

#endif

#ifdef TREESPACES_SUBSET_SEGMENT

    /// struct to do segment space serial mappings

    struct SerialMapper smapSegment;

#endif

};


#include "hierarchy/output/symbols/type_defines.h"


/// \def flags

/* /// \def is private model */

/* #define FLAGS_HSLE_PRIVATE		1 */

/* /// \def is public model */

/* #define FLAGS_HSLE_PUBLIC		2 */

/// \def solver information present

/* #define FLAGS_HSLE_SOLVER_INFO		4 */

/* /// \def symbol has been created by algorithm */

/* #define FLAGS_HSLE_ALGORITHM		8 */

/// \def is tagged by a traversal (do not forget to untag)

#define FLAGS_HSLE_TRAVERSAL		16


#include "hierarchy/output/symbols/instanceof_relationships.h"

#include "hierarchy/output/symbols/dimension_space_locators.h"


/// \def some quick defines to give access to the serial ID's

#ifdef PRE_PROTO_TRAVERSAL

#define SymbolClearInvisibleSerialToParent(phsle)	\
	SerialMapClearToParent(&(phsle)->smapInvisible)
#define SymbolClearInvisibleNumOfSuccessors(phsle)	\
	SerialMapClearNumOfSuccessors(&(phsle)->smapInvisible)

#define SymbolClearPrincipalSerialToParent(phsle)	\
	SerialMapClearToParent(&(phsle)->smapPrincipal)
#define SymbolClearPrincipalNumOfSuccessors(phsle)	\
	SerialMapClearNumOfSuccessors(&(phsle)->smapPrincipal)

#define SymbolClearMechanismSerialToParent(phsle)	\
	SerialMapClearToParent(&(phsle)->smapMechanism)
#define SymbolClearMechanismNumOfSuccessors(phsle)	\
	SerialMapClearNumOfSuccessors(&(phsle)->smapMechanism)

#define SymbolClearSegmentSerialToParent(phsle)	\
	SerialMapClearToParent(&(phsle)->smapSegment)
#define SymbolClearSegmentNumOfSuccessors(phsle)	\
	SerialMapClearNumOfSuccessors(&(phsle)->smapSegment)


#define SymbolGetInvisibleSerialToParent(phsle)	\
	SerialMapGetToParent(&(phsle)->smapInvisible)
#define SymbolGetInvisibleNumOfSuccessors(phsle)	\
	SerialMapGetNumOfSuccessors(&(phsle)->smapInvisible)

#define SymbolGetPrincipalSerialToParent(phsle)	\
	SerialMapGetToParent(&(phsle)->smapPrincipal)
#define SymbolGetPrincipalNumOfSuccessors(phsle)	\
	SerialMapGetNumOfSuccessors(&(phsle)->smapPrincipal)

#define SymbolGetMechanismSerialToParent(phsle)	\
	SerialMapGetToParent(&(phsle)->smapMechanism)
#define SymbolGetMechanismNumOfSuccessors(phsle)	\
	SerialMapGetNumOfSuccessors(&(phsle)->smapMechanism)

#define SymbolGetSegmentSerialToParent(phsle)	\
	SerialMapGetToParent(&(phsle)->smapSegment)
#define SymbolGetSegmentNumOfSuccessors(phsle)	\
	SerialMapGetNumOfSuccessors(&(phsle)->smapSegment)


#define SymbolSetInvisibleSerialToParent(phsle,i)	\
	SerialMapSetToParent(&(phsle)->smapInvisible,(i))
#define SymbolSetInvisibleNumOfSuccessors(phsle,i)	\
	SerialMapSetNumOfSuccessors(&(phsle)->smapInvisible,(i))

#define SymbolSetPrincipalSerialToParent(phsle,i)	\
	SerialMapSetToParent(&(phsle)->smapPrincipal,(i))
#define SymbolSetPrincipalNumOfSuccessors(phsle,i)	\
	SerialMapSetNumOfSuccessors(&(phsle)->smapPrincipal,(i))

#define SymbolSetMechanismSerialToParent(phsle,i)	\
	SerialMapSetToParent(&(phsle)->smapMechanism,(i))
#define SymbolSetMechanismNumOfSuccessors(phsle,i)	\
	SerialMapSetNumOfSuccessors(&(phsle)->smapMechanism,(i))

#define SymbolSetSegmentSerialToParent(phsle,i)	\
	SerialMapSetToParent(&(phsle)->smapSegment,(i))
#define SymbolSetSegmentNumOfSuccessors(phsle,i)	\
	SerialMapSetNumOfSuccessors(&(phsle)->smapSegment,(i))


#ifndef SWIG
static inline
#endif
void
SymbolAllSerialsClear(struct symtab_HSolveListElement *phsle);

#ifndef SWIG
static inline
#endif
void
SymbolAllSerialsEntailChild
(struct symtab_HSolveListElement *phsleParent,
 struct symtab_HSolveListElement *phsleChild);

/* static inline void  */
/* SymbolAllSerialsRecalculate */
/* (struct symtab_HSolveListElement *phsle, */
/*  int *piSuccessorsPrincipal, */
/*  int *piSuccessorsMechanism, */
/*  int *piSuccessorsSegment); */

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSerialsToParentGet
(struct symtab_HSolveListElement *phsle,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSerialsToParentSet
(struct symtab_HSolveListElement *phsle,
 int iSuccessorsInvisible,
 int iSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSuccessorsSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSuccessorsGet
(struct symtab_HSolveListElement *phsle,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
);

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSuccessorsSet
(struct symtab_HSolveListElement *phsle,
 int iSuccessorsInvisible,
 int iSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSuccessorsSegment
#endif
);

#ifndef SWIG
static inline
#endif
struct symtab_HSolveListElement *
BaseSymbolGetSymbol(struct symtab_HSolveListElement *phsle);

#ifndef SWIG
static inline
#endif
int * SymbolGetArrayOfNumberOfAliases();

#ifndef SWIG
static inline
#endif
int SymbolGetNumberOfAliases();

#ifndef SWIG
static inline
#endif
int
SymbolIncrementAliases(int iType);


int SymbolPrintParameterTraversal(
  struct symtab_HSolveListElement *phsle,
  struct PidinStack *ppist);



/// 
/// clear all known spaces
/// 

#ifndef SWIG
static inline
#endif
void
SymbolAllSerialsClear(struct symtab_HSolveListElement *phsle)
{
    SymbolClearInvisibleNumOfSuccessors(phsle);
    SymbolClearInvisibleSerialToParent(phsle);

    SymbolClearPrincipalNumOfSuccessors(phsle);
    SymbolClearPrincipalSerialToParent(phsle);

#ifdef TREESPACES_SUBSET_MECHANISM
    SymbolClearMechanismNumOfSuccessors(phsle);
    SymbolClearMechanismSerialToParent(phsle);
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    SymbolClearSegmentNumOfSuccessors(phsle);
    SymbolClearSegmentSerialToParent(phsle);
#endif
}


/// 
/// calculate mappings after entail of a child
/// 

#ifndef SWIG
static inline
#endif
void
SymbolAllSerialsEntailChild
(struct symtab_HSolveListElement *phsleParent,
 struct symtab_HSolveListElement *phsleChild)
{
    //- register to which subspaces the symbol belongs

    int iInvisible = 1;

    int iPrincipal = 1;

#ifdef TREESPACES_SUBSET_MECHANISM
    int iMechanism = in_dimension_mechanism(phsleChild) ? 1 : 0 ;
#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    int iSegment = instanceof_segment(phsleChild) ? 1 : 0 ;
#endif

    //- set serial ID of child relative to root (parent)
    //-     == serial ID of left child + #SU of left child
    //-     == set inside parent : next serial ID relative to this

    SymbolSetInvisibleSerialToParent
	(phsleChild,
	 SymbolGetInvisibleNumOfSuccessors(phsleParent) + iInvisible);

    SymbolSetPrincipalSerialToParent
	(phsleChild,
	 SymbolGetPrincipalNumOfSuccessors(phsleParent) + iPrincipal);

    //- update of next relative serial ID
    //-     += #SU of phsleChild + 1

    SymbolSetInvisibleNumOfSuccessors
	(phsleParent,
	 SymbolGetInvisibleNumOfSuccessors(phsleParent)
	 + SymbolGetInvisibleNumOfSuccessors(phsleChild)
	 + iInvisible);

    SymbolSetPrincipalNumOfSuccessors
	(phsleParent,
	 SymbolGetPrincipalNumOfSuccessors(phsleParent)
	 + SymbolGetPrincipalNumOfSuccessors(phsleChild)
	 + iPrincipal);

#ifdef TREESPACES_SUBSET_MECHANISM
    //- do same for mechanism space

    SymbolSetMechanismSerialToParent
	(phsleChild,
	 SymbolGetMechanismNumOfSuccessors(phsleParent) + iMechanism);

    SymbolSetMechanismNumOfSuccessors
	(phsleParent,
	 SymbolGetMechanismNumOfSuccessors(phsleParent)
	 + SymbolGetMechanismNumOfSuccessors(phsleChild)
	 + iMechanism);

#endif

#ifdef TREESPACES_SUBSET_SEGMENT
    //- do same for segment space

    SymbolSetSegmentSerialToParent
	(phsleChild,
	 SymbolGetSegmentNumOfSuccessors(phsleParent) + iSegment);

    SymbolSetSegmentNumOfSuccessors
	(phsleParent,
	 SymbolGetSegmentNumOfSuccessors(phsleParent)
	 + SymbolGetSegmentNumOfSuccessors(phsleChild)
	 + iSegment);
#endif
}


/* /// */
/* /// update serials after children have been added, but where  */
/* /// successors are already ok. */
/* /// e.g. spines algorithm */
/* /// */
/* /// *piSuccessorsPrincipal, *piSuccessorsMechanism, *piSuccessorsSegment must have been initialized with  */
/* /// zero before the first call for the same run (== same parent) */
/* /// afterwards *piSuccessorsPrincipal, *piSuccessorsMechanism, *piSuccessorsSegment are all updated */
/* /// */

/* static inline void  */
/* SymbolAllSerialsRecalculate */
/* (struct symtab_HSolveListElement *phsle, */
/*  int *piSuccessorsPrincipal, */
/*  int *piSuccessorsMechanism, */
/*  int *piSuccessorsSegment) */
/* { */
/*     /*- register to which subspaces the child section belongs * */

/*     int iPrincipal = 1; */

/*     int iMechanism = InstanceOfMechanism(phsle) ? 1 : 0 ; */

/*     int iSegment = InstanceOfSegment(phsle) ? 1 : 0 ; */

/*     /*- set serials relative to parent for current child * */

/*     /*- and update successor counts * */

/*     SymbolSetPrincipalSerialToParent */
/* 	(phsle,*piSuccessorsPrincipal + iPrincipal); */

/*     *piSuccessorsPrincipal */
/* 	+= SymbolGetPrincipalNumOfSuccessors(phsle) */
/* 	   + iPrincipal; */

/*     SymbolSetMechanismSerialToParent */
/* 	(phsle,*piSuccessorsMechanism + iMechanism); */

/*     *piSuccessorsMechanism */
/* 	+= SymbolGetMechanismNumOfSuccessors(phsle) */
/* 	  + iMechanism; */

/*     SymbolSetSegmentSerialToParent */
/* 	(phsle,*piSuccessorsSegment + iSegment); */

/*     *piSuccessorsSegment */
/* 	+= SymbolGetSegmentNumOfSuccessors(phsle) */
/* 	  + iSegment; */
/* } */


/// 
/// get serials in all known spaces
/// 

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSerialsToParentGet
(struct symtab_HSolveListElement *phsle,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
)
{
    *piInvisible = SymbolGetInvisibleSerialToParent(phsle);
    *piPrincipal = SymbolGetPrincipalSerialToParent(phsle);
#ifdef TREESPACES_SUBSET_MECHANISM
    *piMechanism = SymbolGetMechanismSerialToParent(phsle);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    *piSegment = SymbolGetSegmentSerialToParent(phsle);
#endif
}


/// 
/// set serials in all known spaces
/// 

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSerialsToParentSet
(struct symtab_HSolveListElement *phsle,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
)
{
    SymbolSetInvisibleSerialToParent(phsle,iInvisible);
    SymbolSetPrincipalSerialToParent(phsle,iPrincipal);
#ifdef TREESPACES_SUBSET_MECHANISM
    SymbolSetMechanismSerialToParent(phsle,iMechanism);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    SymbolSetSegmentSerialToParent(phsle,iSegment);
#endif
}


/// 
/// get successors in all known spaces
/// 

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSuccessorsGet
(struct symtab_HSolveListElement *phsle,
 int *piSuccessorsInvisible,
 int *piSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSuccessorsSegment
#endif
)
{
    *piSuccessorsInvisible = SymbolGetInvisibleNumOfSuccessors(phsle);
    *piSuccessorsPrincipal = SymbolGetPrincipalNumOfSuccessors(phsle);
#ifdef TREESPACES_SUBSET_MECHANISM
    *piSuccessorsMechanism = SymbolGetMechanismNumOfSuccessors(phsle);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    *piSuccessorsSegment = SymbolGetSegmentNumOfSuccessors(phsle);
#endif
}


/// 
/// set successors in all known spaces
/// 

#ifndef SWIG
static inline
#endif
int
BaseSymbolAllSuccessorsSet
(struct symtab_HSolveListElement *phsle,
 int iSuccessorsInvisible,
 int iSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSuccessorsSegment
#endif
)
{
    SymbolSetInvisibleNumOfSuccessors(phsle,iSuccessorsInvisible);
    SymbolSetPrincipalNumOfSuccessors(phsle,iSuccessorsPrincipal);
#ifdef TREESPACES_SUBSET_MECHANISM
    SymbolSetMechanismNumOfSuccessors(phsle,iSuccessorsMechanism);
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
    SymbolSetSegmentNumOfSuccessors(phsle,iSuccessorsSegment);
#endif
}


/// 
/// return a pointer to this symbol.
/// 

#ifndef SWIG
static inline
#endif
struct symtab_HSolveListElement *
BaseSymbolGetSymbol(struct symtab_HSolveListElement *phsle)
{
    //- return result: self

    return(phsle);
}


/// 
/// get count of created aliases by type.
/// 

#ifndef SWIG
static inline
#endif
int *
SymbolGetArrayOfNumberOfAliases()
{
    extern int iCreatedAliases;

    extern int piCreatedAliases[];

    return(piCreatedAliases);
}


/// 
/// get total count of created aliases.
/// 

#ifndef SWIG
static inline
#endif
int
SymbolGetNumberOfAliases()
{
    extern int iCreatedAliases;

    extern int piCreatedAliases[];

    return(iCreatedAliases);
}




/// 
/// increment count of created aliases by type.
/// 

#ifndef SWIG
static inline
#endif
int
SymbolIncrementAliases(int iType)
{
    extern int iCreatedAliases;

    extern int piCreatedAliases[];

    if (iType < COUNT_HIERARCHY_TYPE_symbols + 1)
    {
	piCreatedAliases[iType]++;
    }

    iCreatedAliases++;

    return(iCreatedAliases);
}


#else


#error Symbols only supports PRE_PROTO_TRAVERSAL for now.

/// \todo #defines to do mappings for POST_PROTO_TRAVERSAL
/// 
/// mapping must loop over references for prototypes,
/// and sum up #SU for each prototype

#endif


#endif


