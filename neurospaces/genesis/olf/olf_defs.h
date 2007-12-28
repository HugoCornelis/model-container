/*
** $Id: olf_defs.h 1.1 Wed, 13 Sep 2000 13:24:29 -0500 hugo $
**
** copied and modified from genesis -r modelreader
**
*/


#ifndef GENESIS_OLF_DEFS_H
#define GENESIS_OLF_DEFS_H


#ifdef lkjasdfklj

#define ERR -1
#define exp10(x) exp(2.302585093 * (x))
#define ZERO_CELSIUS	273.15			/* deg */
#define GAS_CONSTANT	8.314			/* (V * C)/(deg K * mol) */
#define FARADAY		9.6487e4		/* C / mol */

#define TABCREATE 200
#define TABFILL 201
#define TAB2FIELDS 207
#define TABOP 208

#define SING_TINY 1e-6 /* MCV addition: small number for detecting singularities in tables */
#define NO_INTERP 0
#define LIN_INTERP 1
#define FIXED 2

#define B_SPLINE_FILL 0
#define C_SPLINE_FILL 1
#define LINEAR_FILL 2

#define TAB_IO 0
#define TAB_LOOP 1
#define TAB_ONCE 2
#define TAB_BUF 3
#define TAB_SPIKE 4
#define TAB_FIELDS 5

#define VOLT_INDEX 0
#define C1_INDEX 1
#define C2_INDEX 2
#define DOMAIN_INDEX 3
#define VOLT_C1_INDEX -1
#define VOLT_C2_INDEX -2
#define VOLT_DOMAIN_INDEX -3
#define C1_C2_INDEX -4
#define DOMAIN_C2_INDEX -5

#define INSTANTX 1
#define INSTANTY 2
#define INSTANTZ 4

#define DEFAULT_XDIVS 3000
#define DEFAULT_2DIVS 300
#define DEFAULT_XMIN -0.1
#define DEFAULT_XMAX 0.05
#define DEFAULT_YMIN 0.0
#define DEFAULT_YMAX 0.01
#define SETUP_ALPHA 0
#define SETUP_TAU 1

#define TAB_IO 0
#define TAB_LOOP 1
#define TAB_ONCE 2

#define TABCHAN_T 20
#define TAB2CHAN_T 21
#define TABCURR_T 26

#define TABFLUX_T 27

#define VOLTAGE     0
#define CONCEN1     1
#define CONCEN2     2
#define DOMAINCONC  3
#define EK          4
#define ADD_GBAR  5


#endif

// for the genesis style table files, these are semantic copies of 
//
// TABCHAN_T 20
// TAB2CHAN_T 21
// TABCURR_T 26
//
// they are read from disk, so they must retain their values.
//

#define CHANNEL_TYPE_SINGLE_TABLE 20
#define CHANNEL_TYPE_DOUBLE_TABLE 21
#define CHANNEL_TYPE_CURRENT 26


#endif


