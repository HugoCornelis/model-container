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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#ifndef CACHEDCONNECTION_H
#define CACHEDCONNECTION_H


/* #include "neurospaces/algorithminstance.h" */
/* #include "neurospaces/components/algorithmsymbol.h" */
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/axonhillock.h"
/* #include "neurospaces/components/biocomp.h" */
/* #include "neurospaces/biolevel.h" */
#include "neurospaces/components/cell.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/concentrationgatekinetic.h"
/* #include "neurospaces/components/connection.h" */
#include "neurospaces/components/connectionsymbol.h"
#include "neurospaces/components/contourpoint.h"
#include "neurospaces/components/emcontour.h"
/* #include "neurospaces/dependencyfile.h" */
/* #include "neurospaces/components/equationexponential.h" */
#include "neurospaces/components/fiber.h"
/* #include "neurospaces/function.h" */
#include "neurospaces/components/gatekinetic.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/hhgate.h"
/* #include "neurospaces/idin.h" */
/* #include "neurospaces/importedfile.h" */
/* #include "neurospaces/inputoutput.h" */
/* #include "neurospaces/iocontainer.h" */
#include "neurospaces/components/network.h"
/* #include "neurospaces/neurospaces.h" */
/* #include "neurospaces/parameters.h" */
/* #include "neurospaces/parsersupport.h" */
#include "neurospaces/pidinstack.h"
#include "neurospaces/components/pool.h"
#include "neurospaces/components/population.h"
/* #include "neurospaces/positionD3.h" */
#include "neurospaces/components/projection.h"
#include "neurospaces/components/randomvalue.h"
#include "neurospaces/components/root.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
/* /* #include "neurospaces/solverinfo.h" * */
/* #include "neurospaces/symbols.h" */
/* #include "neurospaces/symboltable.h" */
#include "neurospaces/traversablealgorithm.h"
/* #include "neurospaces/traversalinfo.h" */
/* #include "neurospaces/treespacetraversal.h" */
/* #include "neurospaces/components/vector.h" */
#include "neurospaces/components/vectorconnection.h"
#include "neurospaces/components/vectorconnectionsymbol.h"
#include "neurospaces/components/vectorcontour.h"
#include "neurospaces/components/vectorsegment.h"
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


/// \def declarations

struct CachedConnection;
struct ProjectionQuery;
struct symtab_Connection;
struct symtab_HSolveListElement;



int
CachedConnectionPrint
(struct CachedConnection *pcconn, int bAll, int iIndent, FILE *pfile);



#ifndef SWIG
static inline
#endif
void CachedConnectionFree(struct CachedConnection *pcconn);

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* struct symtab_HSolveListElement * */
/* CachedConnectionGetConnection(struct CachedConnection *pcconn); */

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* int */
/* CachedConnectionGetCursor(struct CachedConnection *pcconn); */

#ifndef SWIG
static inline
#endif
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

#ifndef SWIG
static inline
#endif
double
CachedConnectionGetCachedDelay(struct CachedConnection *pcconn);

#ifndef SWIG
static inline
#endif
int
CachedConnectionGetCachedPost(struct CachedConnection *pcconn);

#ifndef SWIG
static inline
#endif
int
CachedConnectionGetCachedPre(struct CachedConnection *pcconn);

#ifndef SWIG
static inline
#endif
double
CachedConnectionGetCachedWeight(struct CachedConnection *pcconn);


#include "components/connection.h"


struct CachedConnection
{
    int iPre;

    int iPost;

    double dDelay;

    double dWeight;

/*     /// cursor for projection query */

/*     int iProjection; */

/*     /// alien type for the symbol below */

/*     int iType; */

/*     /// referred connection */

/*     struct symtab_HSolveListElement *phsle; */
};



#include "projectionquery.h"



/// 
/// free cached connection.
/// 

#ifndef SWIG
static inline
#endif
void CachedConnectionFree(struct CachedConnection *pcconn)
{
/*     pcconn->iProjection = -1; */
/*     pcconn->phsle = NULL; */
    free(pcconn);
}


/* /// */
/* /// get cursor. */
/* /// */

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* int */
/* CachedConnectionGetCachedCursor(struct CachedConnection *pcconn) */
/* { */
/*     return(pcconn->iProjection); */
/* } */


/* /// */
/* /// get connection. */
/* /// */

/* #ifndef SWIG */
/* static inline */
/* #endif */
/* struct symtab_HSolveListElement * */
/* CachedConnectionGetCachedConnection(struct CachedConnection *pcconn) */
/* { */
/*     return(pcconn->phsle); */
/* } */


/// 
/// init cached connection.
/// 

#ifndef SWIG
static inline
#endif
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

#ifndef SWIG
static inline
#endif
double
CachedConnectionGetCachedDelay(struct CachedConnection *pcconn)
{
    return(pcconn->dDelay);
}


/// 
/// get postsynaptic serial from cached connection.
/// 

#ifndef SWIG
static inline
#endif
int
CachedConnectionGetCachedPost(struct CachedConnection *pcconn)
{
    return(pcconn->iPost);

/*     //- if the connection is stored in absolute mode */

/*     /// \note e.g after loading from a cache file */

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

/*     /// \todo alien call to SymbolGetPostPrincipalSerial(), using pcconn->iType */

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

#ifndef SWIG
static inline
#endif
int
CachedConnectionGetCachedPre(struct CachedConnection *pcconn)
{
    return(pcconn->iPre);

/*     //- if the connection is stored in absolute mode */

/*     /// \note e.g after loading from a cache file */

/*     if (pcconn->iProjection == -1) */
/*     { */
/* 	//- return absolute serial */

/* 	/// \todo alien call to SymbolGetPrePrincipalSerial() ? */

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

/*     /// \todo alien call to SymbolGetPrePrincipalSerial(), using pcconn->iType */

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

#ifndef SWIG
static inline
#endif
double
CachedConnectionGetCachedWeight(struct CachedConnection *pcconn)
{
    return(pcconn->dWeight);
}


#endif


