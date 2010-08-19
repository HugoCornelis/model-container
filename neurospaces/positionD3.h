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


/// \struct
/// \struct 3D position
/// \struct

struct D3Position
{
    /// x,y,z coordinates

    double dx;
    double dy;
    double dz;
};


/// \def
/// \def test type(pD3) == struct D3Position * at compile time
/// \def

#define CompileTimeTestD3Type(pD3)					\
do {									\
    struct D3Position D3Type;						\
    (pD3) == &D3Type;							\
} while (0)


/// \def
/// \def set X coordinate of pD3
/// \def

#define D3SetX(pD3,dX)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dx = (dX);							\
} while (0)


/// \def
/// \def set Y coordinate of pD3
/// \def

#define D3SetY(pD3,dY)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dy = (dY);							\
} while (0)


/// \def
/// \def set Z coordinate of pD3
/// \def

#define D3SetZ(pD3,dZ)							\
do {									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dz = (dZ);							\
} while (0)


/// \def
/// \def set coordinates of pD3 to dX,dY,dZ
/// \def

#define D3Set(pD3,dX,dY,dZ)						\
do {									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dx = (dX);							\
    (pD3)->dy = (dY);							\
    (pD3)->dz = (dZ);							\
} while (0)


/// \note following only works with GNU cc

/// \def
/// \def get X
/// \def

#define D3GetX(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dx;								\
})


/// \def
/// \def get Y
/// \def

#define D3GetY(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dy;								\
})


/// \def
/// \def get Z
/// \def

#define D3GetZ(pD3)							\
({									\
    CompileTimeTestD3Type(pD3);						\
    (pD3)->dz;								\
})



void D3PositionInit(struct D3Position *pD3);


#endif


