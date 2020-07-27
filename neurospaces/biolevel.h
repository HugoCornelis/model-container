//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: biolevel.h 1.4 Sat, 26 May 2007 21:19:13 -0500 hugo $
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
** biolevels and their groupings
*/

#ifndef BIOLEVEL_H
#define BIOLEVEL_H


/// \def biological levels
///
/// The levels are mainly taken from my phd thesis,
/// some of them will be useless.
///

#define BIOLEVEL_NERVOUS_SYSTEM		10
#define BIOLEVEL_BRAIN			20
#define BIOLEVEL_BRAIN_STRUCTURE	30
#define BIOLEVEL_BRAIN_REGION		40
#define BIOLEVEL_NETWORK		50
#define BIOLEVEL_POPULATION		60
#define BIOLEVEL_SUBPOPULATION		70
#define BIOLEVEL_CELL			80
#define BIOLEVEL_SEGMENT		90
#define BIOLEVEL_MECHANISM		100
#define BIOLEVEL_CHEMICAL_PATHWAY	110
#define BIOLEVEL_MOLECULAR		120
#define BIOLEVEL_ATOMIC			130

#define DIVIDER_BIOLEVEL	BIOLEVEL_NERVOUS_SYSTEM


/// \def highest index used in an array of types
/// equals total number of different types (excluding empty type),
/// types must first be divided by DIVIDER_BIOLEVEL

#define COUNT_BIOLEVEL			((BIOLEVEL_ATOMIC - BIOLEVEL_NERVOUS_SYSTEM) / DIVIDER_BIOLEVEL + 1)


/// \struct select biolevels for traversal

struct BiolevelSelection
{
    /// chained user data

    void *pvUserdata;

    /// mode : exclusive, inclusive

    int iMode;

    /// selected level

    int iLevel;

    /// all levels follow, not used for now

    int iBiolevel_Nervous_System;
    int iBiolevel_Brain;
    int iBiolevel_Brain_Structure;
    int iBiolevel_Brain_Region;
    int iBiolevel_Network;
    int iBiolevel_Population;
    int iBiolevel_Subpopulation;
    int iBiolevel_Cell;
    int iBiolevel_Mechanism;
    int iBiolevel_Chemical_Pathway;
    int iBiolevel_Molecular;
    int iBiolevel_Atomic;
};


/// \def inclusive biolevel selection

#define SELECTOR_BIOLEVEL_INCLUSIVE	1


/// \def exclusive biolevel selection

#define SELECTOR_BIOLEVEL_EXCLUSIVE	2


/// map a symbol type to a biological level, where I am currently
/// unsure, you will get -1 for failure.  No compromises allowed for the
/// moment.

#ifndef SWIG
extern int piSymbolType2Biolevel[];
#endif


/// map a biological level to its group, where I am currently
/// unsure, you will get -1 for failure.  No compromises allowed for the
/// moment.

#ifndef SWIG
extern int piBiolevel2Biolevelgroup[];
#endif


/// give biolevels a human readable form

#ifndef SWIG
extern char *ppcBiolevel[];
#endif


/// map a biological group to its lowest biological level, where I am currently
/// unsure, you will get -1 for failure.  No compromises allowed for the
/// moment.

#ifndef SWIG
extern int piBiolevelgroup2Biolevel[];
#endif


/// give biological groups a human readable form

#ifndef SWIG
extern char *ppcBiolevelgroup[];
#endif


/// \def biological level groups

#define BIOLEVELGROUP_NERVOUS_SYSTEM		100000
#define BIOLEVELGROUP_BRAIN_STRUCTURE		200000
#define BIOLEVELGROUP_NETWORK			300000
#define BIOLEVELGROUP_CELL			400000
#define BIOLEVELGROUP_SEGMENT			500000
#define BIOLEVELGROUP_MECHANISM			600000

#define DIVIDER_BIOLEVELGROUP	BIOLEVELGROUP_NERVOUS_SYSTEM


/// \def highest index used in an array of types
/// equals total number of different types (excluding empty type),
/// types must first be divided by DIVIDER_BIOLEVEL

#define COUNT_BIOLEVELGROUP			((BIOLEVELGROUP_MECHANISM - BIOLEVELGROUP_NERVOUS_SYSTEM) / DIVIDER_BIOLEVELGROUP + 1)


#include <string.h>


/// 
/// \arg iLevel biological level to get biogroup for.
/// 
/// \return int : biogroup of bio level, -1 for failure.
/// 
/// \brief Get biogroup of bio level.
/// 

#ifndef SWIG
static inline
#endif
int
Biolevel2Biolevelgroup(int iLevel)
{
    //- set default result : failure

    int iResult = -1;

    //- set result from carefully pre-encoded array...

    iResult = piBiolevel2Biolevelgroup[iLevel / DIVIDER_BIOLEVEL];

    //- return result

    return(iResult);
}


/// 
/// \arg pcLevel biolevel to get internal code for.
/// 
/// \return int : biolevel, -1 for failure.
/// 
/// \brief Get internal code for biolevel.
/// 

#ifndef SWIG
static inline
#endif
int
Biolevel(char *pcLevel)
{
    //- set default result : failure

    int iResult = -1;

    int i;

    for (i = 0 ; ppcBiolevel[i] ; i++)
    {
	if (strcmp(pcLevel, ppcBiolevel[i]) == 0)
	{
	    iResult = i * DIVIDER_BIOLEVEL;

	    break;
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pcGroup biogroup to get internal code for.
/// 
/// \return int : biogroup, -1 for failure.
/// 
/// \brief Get internal code for biogroup.
/// 

#ifndef SWIG
static inline
#endif
int
Biolevelgroup(char *pcGroup)
{
    //- set default result : failure

    int iResult = -1;

    int i;

    for (i = 0 ; ppcBiolevelgroup[i] ; i++)
    {
	if (strcmp(pcGroup, ppcBiolevelgroup[i]) == 0)
	{
	    iResult = i * DIVIDER_BIOLEVELGROUP;

	    break;
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg iGroup biogroup to get biological level for.
/// 
/// \return int : bio level of biogroup, -1 for failure.
/// 
/// \brief Get bio level of biogroup.
/// 

#ifndef SWIG
static inline
#endif
int
Biolevelgroup2Biolevel(int iGroup)
{
    //- set default result : failure

    int iResult = -1;

    //- set result from carefully pre-encoded array...

    iResult = piBiolevelgroup2Biolevel[iGroup / DIVIDER_BIOLEVELGROUP];

    //- return result

    return(iResult);
}


/// 
/// \arg iType symbol type to get biological level for.
/// 
/// \return int : biolevel of symbol, -1 for failure.
/// 
/// \brief Get biolevel of symbol.
/// 

#ifndef SWIG
static inline
#endif
int
SymbolType2Biolevel(int iType)
{
    //- set default result : failure

    int iResult = -1;

    //- set result from carefully pre-encoded array...

    iResult = piSymbolType2Biolevel[iType];

    //- return result

    return(iResult);
}


#endif


