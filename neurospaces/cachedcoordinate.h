//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cachedcoordinate.h 1.1 Wed, 06 Jun 2007 23:12:27 -0500 hugo $
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



#ifndef CACHEDCOORDINATE_H
#define CACHEDCOORDINATE_H



//d declarations

struct CachedCoordinate;
struct D3Position;


//f exported inlines

static inline 
void CachedCoordinateFree(struct CachedCoordinate *pccrd);

static inline
struct D3Position *
CachedCoordinateGetCoordinate(struct CachedCoordinate *pccrd);

static inline
int
CachedCoordinateGetSerial(struct CachedCoordinate *pccrd);

static inline
void
CachedCoordinateInit
(struct CachedCoordinate *pccrd,
 int iSerial,
 struct D3Position *pD3);


#include "positionD3.h"


struct CachedCoordinate
{
    //m serial of symbol

    int iSerial;

    //m referred coordinate

    struct D3Position D3;
};



//f exported inlines

///
/// free cached coordinate.
///

static inline 
void CachedCoordinateFree(struct CachedCoordinate *pccrd)
{
    pccrd->iSerial = -1;
    free(pccrd);
}


///
/// get serial.
///

static inline
int
CachedCoordinateGetSerial(struct CachedCoordinate *pccrd)
{
    return(pccrd->iSerial);
}


///
/// get coordinate.
///

static inline
struct D3Position *
CachedCoordinateGetCoordinate(struct CachedCoordinate *pccrd)
{
    return(&pccrd->D3);
}


///
/// init cached coordinate.
///

static inline
void
CachedCoordinateInit
(struct CachedCoordinate *pccrd,
 int iSerial,
 struct D3Position *pD3)
{
    pccrd->iSerial = iSerial;
    pccrd->D3 = *pD3;
}


#endif


