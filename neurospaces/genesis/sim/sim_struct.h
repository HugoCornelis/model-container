/*
** $Id: sim_struct.h 1.2 Tue, 20 Mar 2001 03:53:48 -0600 hugo $
**
** copied and modified from genesis -r modelreader
**
*/


#ifndef GENESIS_SIM_STRUCT_H
#define GENESIS_SIM_STRUCT_H


#define NEUROSPACES_INTERPOLX_TYPE \
    double  xmin;   \
    double  xmax;   \
    int     xdivs;  \
    double  dx;     \
    double  invdx;  \
    double  sx,sy;  \
    double  ox,oy;  \
    short   allocated; \
    short   calc_mode;	/* This can be one of : NO_INTERP, LIN_INTERP, FIXED */

struct neurospaces_interpol_struct {
    NEUROSPACES_INTERPOLX_TYPE
    double  *table;
};

struct neurospaces_interpol2d_struct {
    NEUROSPACES_INTERPOLX_TYPE
    double  **table;
    double  *xgrid;
    short   xgrid_allocated;

    double  ymin;
    double  ymax;
    int     ydivs;
    double  dy;
    double  invdy;
    double  *ygrid;
    short   ygrid_allocated;

    double  sz;
    double  oz;

};


#endif


