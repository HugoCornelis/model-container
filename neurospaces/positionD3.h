//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: positionD3.h 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#ifndef POSITIOND3_H
#define POSITIOND3_H


#include "double.h"


//s
//s 3D position
//s

struct D3Position
{
    //m x,y,z coordinates

    double dx;
    double dy;
    double dz;
};


//d
//d test type(pD3) == struct D3Position * at compile time
//d

#define CompileTimeTestD3Type(pD3)					\
do {									\
    struct D3Position D3Type;						\
    (pD3) == &D3Type;							\
} while (0)


//d
//d set X coordinate of pD3
//d

#define D3SetX(pD3,dX)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    CompileTimeTestDouble(dX);						\
    (pD3)->dx = (dX);							\
} while (0)


//d
//d set Y coordinate of pD3
//d

#define D3SetY(pD3,dY)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    CompileTimeTestDouble(dY);						\
    (pD3)->dy = (dY);							\
} while (0)


//d
//d set Z coordinate of pD3
//d

#define D3SetZ(pD3,dZ)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    CompileTimeTestDouble(dZ);						\
    (pD3)->dz = (dZ);							\
} while (0)


//d
//d set coordinates of pD3 to dX,dY,dZ
//d

#define D3Set(pD3,dX,dY,dZ)						\
do {									\
    CompileTimeTestD3Type(pD3);						\
    CompileTimeTestDouble(dX);						\
    CompileTimeTestDouble(dY);						\
    CompileTimeTestDouble(dZ);						\
    (pD3)->dx = (dX);							\
    (pD3)->dy = (dY);							\
    (pD3)->dz = (dZ);							\
} while (0)


//! following only works with GNU cc

//d
//d get X
//d

#define D3GetX(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dx;								\
})


//d
//d get Y
//d

#define D3GetY(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dy;								\
})


//d
//d get Z
//d

#define D3GetZ(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dz;								\
})



void D3PositionInit(struct D3Position *pD3);


#endif


