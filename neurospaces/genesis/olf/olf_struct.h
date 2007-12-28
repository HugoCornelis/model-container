/*
** $Id: olf_struct.h 1.2 Tue, 20 Mar 2001 03:53:48 -0600 hugo $
**
** copied and modified from genesis -r modelreader
**
*/


#ifndef GENESIS_OLF_STRUCT_H
#define GENESIS_OLF_STRUCT_H


#include "olf_defs.h"

#include "../sim/sim_struct.h"


#define NEUROSPACES_TABCHAN_TYPE \
/*     float   Gbar; */   \
/*     double  X; */      \
/*     double  Y; */      \
/*     double  Z; */      \
    float   Xpower; \
    float   Ypower; \
    float   Zpower; \
    short   instant; \
    short   X_alloced; \
    short   Y_alloced; \
    short   Z_alloced; \
/*     float   surface; */

struct neurospaces_tab_channel_type {
/*     CHAN_TYPE */
    NEUROSPACES_TABCHAN_TYPE
    struct neurospaces_interpol_struct *X_A;
    struct neurospaces_interpol_struct *X_B;
    struct neurospaces_interpol_struct *Y_A;
    struct neurospaces_interpol_struct *Y_B;
    struct neurospaces_interpol_struct *Z_A;
    struct neurospaces_interpol_struct *Z_B;
};

struct neurospaces_tab2channel_type {
/*     CHAN_TYPE */
    NEUROSPACES_TABCHAN_TYPE
    short   Xindex;
    short   Yindex;
    short   Zindex;
    struct neurospaces_interpol2d_struct *X_A;
    struct neurospaces_interpol2d_struct *X_B;
    struct neurospaces_interpol2d_struct *Y_A;
    struct neurospaces_interpol2d_struct *Y_B;
    struct neurospaces_interpol2d_struct *Z_A;
    struct neurospaces_interpol2d_struct *Z_B;
};

struct neurospaces_tab_current_type {
/*     CHAN_TYPE */
/*     float   Gbar; */
    short   Gindex;
    short   alloced;
/*     float   surface; */
    struct neurospaces_interpol2d_struct *G_tab;
    struct neurospaces_interpol2d_struct *I_tab;
};


#endif


