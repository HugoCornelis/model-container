//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: treespacetraversal.h 1.37 Thu, 15 Nov 2007 13:04:36 -0600 hugo $
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


#ifndef TREESPACETRAVERSAL_H
#define TREESPACETRAVERSAL_H


//f
//f function that processes symbols
//f

struct TreespaceTraversal;

typedef 
int TreespaceTraversalProcessor
    (struct TreespaceTraversal *ptstr,
     void *pvUserdata);


//d processor failure : continue with siblings, no postprocessing

#define TSTR_PROCESSOR_FAILURE			1

//d processor success : continue with children, then post processing

#define TSTR_PROCESSOR_SUCCESS			2

//d processor success : continue with children, no post processing

#define TSTR_PROCESSOR_SUCCESS_NO_FINALIZE	3

//d processor success : abort, no siblings, no children, no post processing

#define TSTR_PROCESSOR_ABORT			4


//f
//f function that selects symbols
//f

typedef TreespaceTraversalProcessor TreespaceTraversalSelector;


//d selector failure

#define TSTR_SELECTOR_FAILURE			TSTR_PROCESSOR_FAILURE

//d selector success

//#define TSTR_SELECTOR_SUCCESS			SYMBOL_PROCESSOR_SUCCESS

//d selector abort

//#define TSTR_SELECTOR_ABORT			SYMBOL_PROCESSOR_ABORT

//d selector : continue with next sibling

#define TSTR_SELECTOR_PROCESS_SIBLING		16

//d selector : process and descend into children

#define TSTR_SELECTOR_PROCESS_CHILDREN		17

//d selector : descend into children, but do not process current

#define TSTR_SELECTOR_PROCESS_ONLY_CHILDREN	18

//d selector : go to parent

//#define TSTR_SELECTOR_PROCESS_PARENT		19


//s
//s structure needed to run through part of the symbol table
//s

struct TreespaceTraversal
{
    //m actual status, return status
    //m for now initialized to zero externally, afterwards read only

    int iStatus;

    //m number of entries in context stack at initialization

    int iFirstEntry;

    //m actual processed element

    struct CoreRoot *pcrActual;

    int iType;

    //m symbol path

    struct PidinStack *ppist;

    struct PSymbolStack *psymst;

    //m principal serial ID of actual

    int iSerialPrincipal;

    //m serial ID in segment subspace

    int iSerialSegment;

    //m serial ID in mechanism subspace

    int iSerialMechanism;

    //m pre selector (prepares)

    TreespaceTraversalSelector *pfPreSelector;

    //m actual symbol processor

    TreespaceTraversalProcessor *pfProcessor;

    //m post selector (finishes)

    TreespaceTraversalProcessor *pfFinalizer;

    //m user defined data for above procedures

    void *pvPreSelector;
    void *pvProcessor;
    void *pvFinalizer;
};


//d treespace traversal status : 

#define TSTR_STATUS_NEW				1
#define TSTR_STATUS_INITIALIZED			2
#define TSTR_STATUS_DONE			3


int SymbolCellCounter(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolCellSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolConnectionCounter(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolConnectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolProjectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);


struct TreespaceTraversal * TstrCalloc(void);

void TstrDelete(struct TreespaceTraversal *ptstr);

struct CoreRoot * TstrGetActual(struct TreespaceTraversal *ptstr);

int TstrGetActualType(struct TreespaceTraversal *ptstr);

struct symtab_HSolveListElement * 
TstrGetActualParent(struct TreespaceTraversal *ptstr);

/* struct PidinStack * TstrGetOriginalContext(struct TreespaceTraversal *ptstr); */

int TstrGo
(struct TreespaceTraversal *ptstr,
 struct symtab_HSolveListElement *phsle);

struct TreespaceTraversal *
TstrNew
(struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfPreSelector,
 void *pvPreSelector,
 TreespaceTraversalProcessor *pfProcesor,
 void *pvProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvFinalizer);

int TstrPrepare
(struct TreespaceTraversal *ptstr,struct symtab_HSolveListElement *phsle);

int 
TstrPrepareForSerial
(struct TreespaceTraversal *ptstr,
 int iSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSuccessorsSegment
#endif
    );

int TstrRepair(struct TreespaceTraversal *ptstr);

int
TstrRepairForSerial
(struct TreespaceTraversal *ptstr,
 int iSuccessorsPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iSuccessorsMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSuccessorsSegment
#endif
    );

int TstrSetActual(struct TreespaceTraversal *ptstr, struct CoreRoot *pcr);

int TstrSetActualType(struct TreespaceTraversal *ptstr, int iType);


//f inline prototypes

#ifndef SWIG
static inline
#endif
int TstrGetPrincipalSerial(struct TreespaceTraversal *ptstr);


//f inlines

/// **************************************************************************
///
/// SHORT: TstrGetPrincipalSerial()
///
/// ARGS.:
///
///	ptstr..: initialized treespace traversal
///
/// RTN..: int : principal serial, INT_MAX for failure.
///
/// DESCR: Get the actual principal serial.
///
/// **************************************************************************

#ifndef SWIG
static inline
#endif
int TstrGetPrincipalSerial(struct TreespaceTraversal *ptstr)
{
    return(ptstr->iSerialPrincipal);
}


#endif


