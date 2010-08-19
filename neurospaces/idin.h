//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: idin.h 1.36 Wed, 14 Nov 2007 16:12:38 -0600 hugo $
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


#ifndef IDIN_H
#define IDIN_H


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/// \struct
/// \struct identifier with optional index
/// \struct

struct symtab_IdentifierIndex
{
    /// link structures in list

    struct symtab_IdentifierIndex *pidinNext;

    /// give each idin pointer to root for hierarchical idins

    struct symtab_IdentifierIndex *pidinRoot;

    /// flags, see FLAG_IDENTINDEX_*

    int iFlags;

    /// name of identifier

    char *pcIdentifier;
};


/// \note some if these should be done via inheritance :
/// \note function ?
/// \note wildcards ?

/// \def no index given

#define FLAG_IDENTINDEX_NOINDEX		1

/// \def is pointer to parent

#define FLAG_IDENTINDEX_PARENT		2

/// \def is field name

#define FLAG_IDENTINDEX_FIELD		4

/* /// \def contains converted value */

/* #define FLAG_IDENTINDEX_VALUE		8 */

/// \def identifier is not given

#define FLAG_IDENTINDEX_NOIDENTIFIER	16

/// \def identifier of function

#define FLAG_IDENTINDEX_FUNCTION	32

/// \def pidinNext is pointer to function parameters

#define FLAG_IDENTINDEX_NEXTPARAMETERS	64

/// \def idin is root item of INPUT relation

#define FLAG_IDENTINDEX_INPUTROOT	128

/// \def idin contains IO relation

#define FLAG_IDENTINDEX_IO		256

/// \def idin is rooted

#define FLAG_IDENTINDEX_ROOTED		512

/// \def idin is namespaced

#define FLAG_IDENTINDEX_NAMESPACED	1024

/// \def idin is unique generated

#define FLAG_IDENTINDEX_UNIQUE		2048

/// \def is pointer to current

#define FLAG_IDENTINDEX_CURRENT		4096


/// \def idin contains range

/* #define FLAG_IDENTINDEX_RANGE		256 */


struct symtab_IdentifierIndex * IdinCalloc(void);

struct symtab_IdentifierIndex * IdinCallocUnique(char *pc);

struct symtab_IdentifierIndex *
IdinCreateAlias(struct symtab_IdentifierIndex *pidin, int iCount);

void IdinFullName(struct symtab_IdentifierIndex *pidin, char *pcName);

char * IdinName(struct symtab_IdentifierIndex *pidin);

struct symtab_IdentifierIndex *IdinNewFromChars(char *pc);

void IdinPrint(struct symtab_IdentifierIndex *pidin, FILE *pfile);



#ifndef SWIG
static inline
#endif
int IdinEqual(struct symtab_IdentifierIndex *pidin1, struct symtab_IdentifierIndex *pidin2);

#ifndef SWIG
static inline
#endif
void IdinFree(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinGetFlag(struct symtab_IdentifierIndex *pidin, int iFlag);

#ifndef SWIG
static inline 
#endif
int IdinIsField(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinIsNamespaced(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinIsPrintable(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinIsRooted(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinIsWildCard(struct symtab_IdentifierIndex *pidin, char *pc);

#ifndef SWIG
static inline
#endif
int IdinMatch(struct symtab_IdentifierIndex *pidin1, struct symtab_IdentifierIndex *pidin2);

#ifndef SWIG
static inline
#endif
int IdinPointsToCurrent(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinPointsToParent(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinSetFlags(struct symtab_IdentifierIndex *pidin, int iFlags);

#ifndef SWIG
static inline
#endif
int IdinSetName(struct symtab_IdentifierIndex *pidin, char *pc);

#ifndef SWIG
static inline
#endif
int IdinSetNamespaced(struct symtab_IdentifierIndex *pidin);

#ifndef SWIG
static inline
#endif
int IdinSetRooted(struct symtab_IdentifierIndex *pidin);


/// 
/// check if two idins are equal
/// 

#ifndef SWIG
static inline
#endif
int IdinEqual(struct symtab_IdentifierIndex *pidin1, struct symtab_IdentifierIndex *pidin2)
{
    if (pidin1 == pidin2)
    {
	return(TRUE);
    }

    if (IdinIsPrintable(pidin1)
	&& IdinIsPrintable(pidin2))
    {
	return (strcmp(pidin1->pcIdentifier,pidin2->pcIdentifier) == 0);
    }

    return(FALSE);
}


/// 
/// free idin
/// 

#ifndef SWIG
static inline
#endif
void IdinFree(struct symtab_IdentifierIndex *pidin)
{
    free(pidin);
}


/// 
/// check if given flags set for idin
/// 

#ifndef SWIG
static inline
#endif
int IdinGetFlag(struct symtab_IdentifierIndex *pidin, int iFlag)
{
    return
	(pidin->iFlags & iFlag
	 ? TRUE
	 : FALSE);
}


/// 
/// check if idin points to field
/// 

#ifndef SWIG
static inline 
#endif
int IdinIsField(struct symtab_IdentifierIndex *pidin)
{
    if (!IdinIsPrintable(pidin))
    {
	return(FALSE);
    }
    else
    {
	return(IdinGetFlag(pidin,FLAG_IDENTINDEX_FIELD));
    }
}


/// 
/// check if idin is namespaced
/// 

#ifndef SWIG
static inline
#endif
int IdinIsNamespaced(struct symtab_IdentifierIndex *pidin)
{
    if (!IdinIsPrintable(pidin))
    {
	return(FALSE);
    }
    else
    {
	return(IdinGetFlag(pidin,FLAG_IDENTINDEX_NAMESPACED));
    }
}


/// 
/// check if idin is printable
/// 

#ifndef SWIG
static inline
#endif
int IdinIsPrintable(struct symtab_IdentifierIndex *pidin)
{
// > 0x80000

    /// \todo this gives a warning on 64bit architectures.
    /// \todo I might need to do a different cast here.

    if ((int)pidin & 1)
    {
	return(FALSE);
    }
    else
    {
	return(TRUE);
    }
}


/// 
/// check if idin is recursive
/// 

#ifndef SWIG
static inline
#endif
int IdinIsRecursive(struct symtab_IdentifierIndex *pidin)
{
    if (strcmp("**", pidin->pcIdentifier) == 0)
    {
	return(TRUE);
    }
    else
    {
	return(FALSE);
    }
}


/// 
/// check if idin is rooted
/// 

#ifndef SWIG
static inline
#endif
int IdinIsRooted(struct symtab_IdentifierIndex *pidin)
{
    return(IdinGetFlag(pidin,FLAG_IDENTINDEX_ROOTED));
}


/// 
/// check if idin matches given wildcard
/// 

#ifndef SWIG
static inline
#endif
int IdinIsWildCard(struct symtab_IdentifierIndex *pidin, char *pc)
{
    return(strcmp(pidin->pcIdentifier, pc) == 0);
}


/// 
/// check if two idins are match
/// 

#ifndef SWIG
static inline
#endif
int IdinMatch(struct symtab_IdentifierIndex *pidin1, struct symtab_IdentifierIndex *pidin2)
{
    /// \note this test is needed and sufficient for non printable idins

    if (pidin1 == pidin2)
    {
	return(TRUE);
    }

    if (IdinIsRecursive(pidin2))
    {
	return(TRUE);
    }

    if (IdinIsPrintable(pidin1)
	&& IdinIsPrintable(pidin2))
    {
	char * pcPattern = strpbrk(pidin2->pcIdentifier, "*");

	if (pcPattern)
	{
	    size_t sLength = pcPattern - pidin2->pcIdentifier;

	    if (strncmp(pidin1->pcIdentifier, pidin2->pcIdentifier, sLength) == 0)
	    {
		/// \todo this ignores anything after '*'

		return(TRUE);
	    }
	}

	if (strcmp(pidin1->pcIdentifier, pidin2->pcIdentifier) == 0)
	{
	    return(TRUE);
	}
	else
	{
	    return(FALSE);
	}
    }

    return(FALSE);
}


/// 
/// check if idin points to current symbol
/// 

#ifndef SWIG
static inline
#endif
int IdinPointsToCurrent(struct symtab_IdentifierIndex *pidin)
{
    return(IdinGetFlag(pidin, FLAG_IDENTINDEX_CURRENT));
}


/// 
/// check if idin points to parent symbol
/// 

#ifndef SWIG
static inline
#endif
int IdinPointsToParent(struct symtab_IdentifierIndex *pidin)
{
    return(IdinGetFlag(pidin, FLAG_IDENTINDEX_PARENT));
}


///
/// set flags for idin
///

#ifndef SWIG
static inline
#endif
int IdinSetFlags(struct symtab_IdentifierIndex *pidin, int iFlags)
{
    pidin->iFlags |= iFlags;

    return(pidin->iFlags);
}


///
/// set name of idin
///

#ifndef SWIG
static inline
#endif
int IdinSetName(struct symtab_IdentifierIndex *pidin, char *pc)
{
    pidin->pcIdentifier = pc;
}


///
/// remember idin is namespaced
///

#ifndef SWIG
static inline
#endif
int IdinSetNamespaced(struct symtab_IdentifierIndex *pidin)
{
    return(IdinSetFlags(pidin, FLAG_IDENTINDEX_NAMESPACED));
}


///
/// remember idin is rooted
///

#ifndef SWIG
static inline
#endif
int IdinSetRooted(struct symtab_IdentifierIndex *pidin)
{
    return(IdinSetFlags(pidin, FLAG_IDENTINDEX_ROOTED));
}


#endif


