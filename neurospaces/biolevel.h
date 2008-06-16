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


//d
//d biological levels
//d
//d The levels are mainly taken from my phd thesis,
//d some of them will be useless.
//d

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


//d highest index used in an array of types
//d equals total number of different types (excluding empty type),
//d types must first be divided by DIVIDER_BIOLEVEL

#define COUNT_BIOLEVEL			((BIOLEVEL_ATOMIC - BIOLEVEL_NERVOUS_SYSTEM) / DIVIDER_BIOLEVEL + 1)


//s
//s select biolevels for traversal
//s

struct BiolevelSelection
{
    //m chained user data

    void *pvUserdata;

    //m mode : exclusive, inclusive

    int iMode;

    //m selected level

    int iLevel;

    //m all levels follow, not used for now

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


//d inclusive biolevel selection

#define SELECTOR_BIOLEVEL_INCLUSIVE	1


//d exclusive biolevel selection

#define SELECTOR_BIOLEVEL_EXCLUSIVE	2


//v map a symbol type to a biological level, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.

#ifndef SWIG
extern int piSymbolType2Biolevel[];
#endif


//v map a biological level to its group, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.

#ifndef SWIG
extern int piBiolevel2Biolevelgroup[];
#endif


//v give biolevels a human readable form

#ifndef SWIG
extern char *ppcBiolevel[];
#endif


//v map a biological group to its lowest biological level, where I am currently
//v unsure, you will get -1 for failure.  No compromises allowed for the
//v moment.

#ifndef SWIG
extern int piBiolevelgroup2Biolevel[];
#endif


//v give biological groups a human readable form

#ifndef SWIG
extern char *ppcBiolevelgroup[];
#endif


//d
//d biological level groups
//d

#define BIOLEVELGROUP_NERVOUS_SYSTEM		100000
#define BIOLEVELGROUP_BRAIN_STRUCTURE		200000
#define BIOLEVELGROUP_NETWORK			300000
#define BIOLEVELGROUP_CELL			400000
#define BIOLEVELGROUP_SEGMENT			500000
#define BIOLEVELGROUP_MECHANISM			600000

#define DIVIDER_BIOLEVELGROUP	BIOLEVELGROUP_NERVOUS_SYSTEM


//d highest index used in an array of types
//d equals total number of different types (excluding empty type),
//d types must first be divided by DIVIDER_BIOLEVEL

#define COUNT_BIOLEVELGROUP			((BIOLEVELGROUP_MECHANISM - BIOLEVELGROUP_NERVOUS_SYSTEM) / DIVIDER_BIOLEVELGROUP + 1)



/// **************************************************************************
///
/// SHORT: Biolevel2Biolevelgroup()
///
/// ARGS.:
///
///	iLevel.: biological level to get biogroup for.
///
/// RTN..: int : biogroup of bio level, -1 for failure.
///
/// DESCR: Get biogroup of bio level.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: Biolevel()
///
/// ARGS.:
///
///	pcLevel.: biolevel to get internal code for.
///
/// RTN..: int : biolevel, -1 for failure.
///
/// DESCR: Get internal code for biolevel.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: Biolevelgroup()
///
/// ARGS.:
///
///	pcGroup.: biogroup to get internal code for.
///
/// RTN..: int : biogroup, -1 for failure.
///
/// DESCR: Get internal code for biogroup.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: Biolevelgroup2Biolevel()
///
/// ARGS.:
///
///	iGroup.: biogroup to get biological level for.
///
/// RTN..: int : bio level of biogroup, -1 for failure.
///
/// DESCR: Get bio level of biogroup.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: SymbolType2Biolevel()
///
/// ARGS.:
///
///	iType.: symbol type to get biological level for.
///
/// RTN..: int : biolevel of symbol, -1 for failure.
///
/// DESCR: Get biolevel of symbol.
///
/// **************************************************************************

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


