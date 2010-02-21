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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#ifndef TREESPACETRAVERSAL_H
#define TREESPACETRAVERSAL_H


struct TreespaceTraversal;

typedef 
int TreespaceTraversalProcessor
    (struct TreespaceTraversal *ptstr,
     void *pvUserdata);


/// \def processor failure : continue with siblings, no postprocessing

//\todo after inspecting the code iohier.c, there was suspicion that
//TSTR_PROCESSOR_FAILURE does not work.  It was confirmed with ndf
//export that it indeed does not work and the postprocessing phase is
//done as usual.

#define TSTR_PROCESSOR_FAILURE			1

/// \def processor success : continue with children, then post processing

#define TSTR_PROCESSOR_SUCCESS			2

/// \def processor success : continue with children, no post processing

#define TSTR_PROCESSOR_SUCCESS_NO_FINALIZE	3

/// \def processor success : abort, no siblings, no children, no post processing

#define TSTR_PROCESSOR_ABORT			4

/// \def processor failure : continue with siblings, with postprocessing

#define TSTR_PROCESSOR_SIBLINGS			5


typedef TreespaceTraversalProcessor TreespaceTraversalSelector;


/// \def selector failure

#define TSTR_SELECTOR_FAILURE			TSTR_PROCESSOR_FAILURE

/// \def selector success

//#define TSTR_SELECTOR_SUCCESS			SYMBOL_PROCESSOR_SUCCESS

/// \def selector abort

//#define TSTR_SELECTOR_ABORT			SYMBOL_PROCESSOR_ABORT

/// \def selector : continue with next sibling

#define TSTR_SELECTOR_PROCESS_SIBLING		16

/// \def selector : process and descend into children

#define TSTR_SELECTOR_PROCESS_CHILDREN		17

/// \def selector : descend into children, but do not process current

#define TSTR_SELECTOR_PROCESS_ONLY_CHILDREN	18

/// \def selector : go to parent

//#define TSTR_SELECTOR_PROCESS_PARENT		19


/// \struct
/// \struct structure needed to run through part of the symbol table
/// \struct

struct TreespaceTraversal
{
    /// actual status, return status
    /// for now initialized to zero externally, afterwards read only

    int iStatus;

    /// number of entries in context stack at initialization

    int iFirstEntry;

    /// actual processed element

    struct CoreRoot *pcrActual;

    int iType;

    /// symbol path

    struct PidinStack *ppist;

    struct PSymbolStack *psymst;

    /// principal serial ID of actual

    int iSerialPrincipal;

    /// serial ID in segment subspace

    int iSerialSegment;

    /// serial ID in mechanism subspace

    int iSerialMechanism;

    /// pre selector (prepares)

    TreespaceTraversalSelector *pfPreSelector;

    /// actual symbol processor

    TreespaceTraversalProcessor *pfProcessor;

    /// post selector (finishes)

    TreespaceTraversalProcessor *pfFinalizer;

    /// user defined data for above procedures

    void *pvPreSelector;
    void *pvProcessor;
    void *pvFinalizer;
};


/// \def treespace traversal status : 

#define TSTR_STATUS_NEW				1
#define TSTR_STATUS_INITIALIZED			2
#define TSTR_STATUS_DONE			3


int SymbolCellCounter(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolCellSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolConnectionCounter(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolConnectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolProjectionSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolGateKineticSelector(struct TreespaceTraversal *ptstr,void *pvUserdata);

int SymbolTableValueCollector(struct TreespaceTraversal *ptstr,void *pvUserdata);


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



#ifndef SWIG
static inline
#endif
int TstrGetPrincipalSerial(struct TreespaceTraversal *ptstr);



/// 
/// \arg ptstr initialized treespace traversal
/// 
/// \return int : principal serial, INT_MAX for failure.
/// 
/// \brief Get the actual principal serial.
/// 

#ifndef SWIG
static inline
#endif
int TstrGetPrincipalSerial(struct TreespaceTraversal *ptstr)
{
    return(ptstr->iSerialPrincipal);
}


#endif


