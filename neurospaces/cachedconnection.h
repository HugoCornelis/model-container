//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cachedconnection.h 1.15 Tue, 11 Sep 2007 18:50:57 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#ifndef CACHEDCONNECTION_H
#define CACHEDCONNECTION_H


/* #include "neurospaces/algorithminstance.h" */
/* #include "neurospaces/algorithmsymbol.h" */
#include "neurospaces/attachment.h"
#include "neurospaces/axonhillock.h"
/* #include "neurospaces/biocomp.h" */
/* #include "neurospaces/biolevel.h" */
#include "neurospaces/cell.h"
#include "neurospaces/channel.h"
#include "neurospaces/concentrationgatekinetic.h"
/* #include "neurospaces/connection.h" */
#include "neurospaces/connectionsymbol.h"
#include "neurospaces/contourpoint.h"
#include "neurospaces/emcontour.h"
/* #include "neurospaces/dependencyfile.h" */
/* #include "neurospaces/equation.h" */
#include "neurospaces/fiber.h"
/* #include "neurospaces/function.h" */
#include "neurospaces/gatekinetic.h"
#include "neurospaces/group.h"
#include "neurospaces/hhgate.h"
/* #include "neurospaces/idin.h" */
/* #include "neurospaces/importedfile.h" */
/* #include "neurospaces/inputoutput.h" */
/* #include "neurospaces/iocontainer.h" */
#include "neurospaces/network.h"
/* #include "neurospaces/neurospaces.h" */
/* #include "neurospaces/parameters.h" */
/* #include "neurospaces/parsersupport.h" */
#include "neurospaces/pidinstack.h"
#include "neurospaces/pool.h"
#include "neurospaces/population.h"
/* #include "neurospaces/positionD3.h" */
#include "neurospaces/projection.h"
#include "neurospaces/randomvalue.h"
#include "neurospaces/root.h"
#include "neurospaces/segment.h"
#include "neurospaces/segmenter.h"
/* /* #include "neurospaces/solverinfo.h" * */
/* #include "neurospaces/symbols.h" */
/* #include "neurospaces/symboltable.h" */
#include "neurospaces/traversablealgorithm.h"
/* #include "neurospaces/traversalinfo.h" */
/* #include "neurospaces/treespacetraversal.h" */
/* #include "neurospaces/vector.h" */
#include "neurospaces/vectorconnection.h"
#include "neurospaces/vectorconnectionsymbol.h"
#include "neurospaces/vectorcontour.h"
#include "neurospaces/vectorsegment.h"
/* #include "neurospaces/workload.h" */

#include "neurospaces/symbolvirtual_protos.h"

#include "hierarchy/output/symbols/all_callees_headers.h"


/* #include "neurospaces/vtable.h" */


/* #include "neurospaces/connectionsymbol.h" */
/* #include "neurospaces/hines_list.h" */
/* #include "neurospaces/idin.h" */
/* #include "neurospaces/parameters.h" */
/* #include "neurospaces/symbols.h" */
/* #include "neurospaces/symbolvirtual_protos.h" */


//d declarations

struct CachedConnection;
struct ProjectionQuery;
struct symtab_Connection;
struct symtab_HSolveListElement;


//f regular functions

int
CachedConnectionPrint
(struct CachedConnection *pcconn, int bAll, int iIndent, FILE *pfile);


//f exported inlines

static inline 
void CachedConnectionFree(struct CachedConnection *pcconn);

/* static inline */
/* struct symtab_HSolveListElement * */
/* CachedConnectionGetConnection(struct CachedConnection *pcconn); */

/* static inline */
/* int */
/* CachedConnectionGetCursor(struct CachedConnection *pcconn); */

static inline
void
CachedConnectionInit
(struct CachedConnection *pcconn,
/*  int iProjection, */
/*  int iType, */
/*  struct symtab_HSolveListElement *phsle); */
 int iPre,
 int iPost,
 double dDelay,
 double dWeight);

static inline
double
CachedConnectionGetCachedDelay(struct CachedConnection *pcconn);

static inline
int
CachedConnectionGetCachedPost(struct CachedConnection *pcconn);

static inline
int
CachedConnectionGetCachedPre(struct CachedConnection *pcconn);

static inline
double
CachedConnectionGetCachedWeight(struct CachedConnection *pcconn);


#include "connection.h"


struct CachedConnection
{
    int iPre;

    int iPost;

    double dDelay;

    double dWeight;

/*     //m cursor for projection query */

/*     int iProjection; */

/*     //m alien type for the symbol below */

/*     int iType; */

/*     //m referred connection */

/*     struct symtab_HSolveListElement *phsle; */
};



#include "projectionquery.h"


//f exported inlines

///
/// free cached connection.
///

static inline 
void CachedConnectionFree(struct CachedConnection *pcconn)
{
/*     pcconn->iProjection = -1; */
/*     pcconn->phsle = NULL; */
    free(pcconn);
}


/* /// */
/* /// get cursor. */
/* /// */

/* static inline */
/* int */
/* CachedConnectionGetCachedCursor(struct CachedConnection *pcconn) */
/* { */
/*     return(pcconn->iProjection); */
/* } */


/* /// */
/* /// get connection. */
/* /// */

/* static inline */
/* struct symtab_HSolveListElement * */
/* CachedConnectionGetCachedConnection(struct CachedConnection *pcconn) */
/* { */
/*     return(pcconn->phsle); */
/* } */


///
/// init cached connection.
///

static inline
void
CachedConnectionInit
(struct CachedConnection *pcconn,
/*  int iProjection, */
/*  int iType, */
/*  struct symtab_HSolveListElement *phsle) */
 int iPre,
 int iPost,
 double dDelay,
 double dWeight)
{
    pcconn->iPre = iPre;
    pcconn->iPost = iPost;
    pcconn->dDelay = dDelay;
    pcconn->dWeight = dWeight;

/*     pcconn->iProjection = iProjection; */
/*     pcconn->iType = iType; */
/*     pcconn->phsle = phsle; */
}


///
/// get postsynaptic serial from cached connection.
///

static inline
double
CachedConnectionGetCachedDelay(struct CachedConnection *pcconn)
{
    return(pcconn->dDelay);
}


///
/// get postsynaptic serial from cached connection.
///

static inline
int
CachedConnectionGetCachedPost(struct CachedConnection *pcconn)
{
    return(pcconn->iPost);

/*     //- if the connection is stored in absolute mode */

/*     //! e.g after loading from a cache file */

/*     if (pcconn->iProjection == -1) */
/*     { */
/* 	//- return absolute serial */

/* 	return ConnectionGetPostPrincipalSerial((struct symtab_Connection *)pcconn->phsle, ppist); */
/*     } */

/*     //- if this is a projection without a target */

/*     int iTarget = ProjectionQueryGetTargetSerial(ppq, pcconn->iProjection); */

/*     if (iTarget == -1) */
/*     { */
/* 	//- return failure */

/* 	return(-1); */
/*     } */

/*     //- return post serial */

/*     //t alien call to SymbolGetPostPrincipalSerial(), using pcconn->iType */

/* #include "hierarchy/output/symbols/all_vtables.c" */

/*     int iPost = SymbolGetPostPrincipalSerial_alien(pcconn->phsle, ppist, _vtable_all[pcconn->iType - 1]); */

/*     if (iPost == -1) */
/*     { */
/* 	return(-1); */
/*     } */

/* /*     ConnectionGetPostPrincipalSerial((struct symtab_Connection *)pcconn->phsle, NULL) * */

/*     return(iTarget + iPost); */

}


///
/// get presynaptic serial from cached connection.
///

static inline
int
CachedConnectionGetCachedPre(struct CachedConnection *pcconn)
{
    return(pcconn->iPre);

/*     //- if the connection is stored in absolute mode */

/*     //! e.g after loading from a cache file */

/*     if (pcconn->iProjection == -1) */
/*     { */
/* 	//- return absolute serial */

/* 	//t alien call to SymbolGetPrePrincipalSerial() ? */

/* 	return ConnectionGetPrePrincipalSerial((struct symtab_Connection *)pcconn->phsle, ppist); */
/*     } */

/*     //- if this is a projection without a source */

/*     int iSource = ProjectionQueryGetSourceSerial(ppq, pcconn->iProjection); */

/*     if (iSource == -1) */
/*     { */
/* 	//- return failure */

/* 	return(-1); */
/*     } */

/*     //- return pre serial */

/*     //t alien call to SymbolGetPrePrincipalSerial(), using pcconn->iType */

/* #include "hierarchy/output/symbols/all_vtables.c" */

/*     int iPre = SymbolGetPrePrincipalSerial_alien(pcconn->phsle, ppist, _vtable_all[pcconn->iType - 1]); */

/*     if (iPre == -1) */
/*     { */
/* 	return(-1); */
/*     } */

/* /*     ConnectionGetPrePrincipalSerial((struct symtab_Connection *)pcconn->phsle, NULL) * */

/*     return(iSource + iPre); */
}


///
/// get postsynaptic serial from cached connection.
///

static inline
double
CachedConnectionGetCachedWeight(struct CachedConnection *pcconn)
{
    return(pcconn->dWeight);
}


#endif


