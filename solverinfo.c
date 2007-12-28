//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: solverinfo.c 1.28 Sat, 25 Aug 2007 09:58:44 -0500 hugo $
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



#include <stdlib.h>
#include <string.h>

#include "neurospaces/pidinstack.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "neurospaces/attachment.h"


//f local functions

static int SolverInfoRegistrationAddEntries(void);


//v all solver registrations

static struct SolverInfo **ppsiRegistrations = NULL;

static int iRegistrations = 0;

static int iRegistrationMax = 0;


/// **************************************************************************
///
/// SHORT: SolverInfoCalloc()
///
/// ARGS.:
///
/// RTN..: struct SolverInfo * 
///
///	Newly allocated solver info, NULL for failure
///
/// DESCR: Allocate a new solver info
///
/// **************************************************************************

struct SolverInfo * SolverInfoCalloc()
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- allocate

    psiResult = (struct SolverInfo *)calloc(1,sizeof(struct SolverInfo));

    //- return result

    return(psiResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoCountIncomingConnections()
///
/// ARGS.:
///
///	psi......: solver info
///	ppq......: projection query
///
/// RTN..: int : number of incoming connections, -1 for failure
///
/// DESCR: Count incoming connections in projection query for given solver
///
/// **************************************************************************

struct SolverInfoIncomingConnectionData
{
    //m projection query

    struct ProjectionQuery *ppq;

    //m number of connections

    int iConnections;

    //m more data
};


static int 
SolverInfoIncomingConnectionCounter
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //! We know this will only be called on connections
    //! associated with a registered spike receiver

    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to original population data

    struct SolverInfoIncomingConnectionData *picd
	= (struct SolverInfoIncomingConnectionData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    //! sanity check

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	//- increment connection count

	picd->iConnections++;
    }
    else
    {
	fprintf(stdout,"Encountering non-connections for spike receiver\n");
    }

    //- return result : remember will not go any deeper

    return(iResult);
}

static int 
SolverInfoSpikeReceiver2ConnectionProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //! We know this will only be called on spike receivers

    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to original population data

    struct SolverInfoIncomingConnectionData *picd
	= (struct SolverInfoIncomingConnectionData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike receiver

    //! sanity check

    if (instanceof_attachment(phsle)
	&& AttachmentPointIsIncoming((struct symtab_Attachment *)phsle))
    {
	//- traverse connections onto this spike receiver

	int iTraverse
	    = ProjectionQueryTraverseConnectionsForSpikeReceiver
	      (picd->ppq,
	       ptstr->ppist,
	       SolverInfoIncomingConnectionCounter,
	       NULL,
	       (void *)picd);

	//- if no success

	if (iTraverse != 1)
	{
	    //- abort traversal

	    iResult = TSTR_PROCESSOR_ABORT;
	}
    }
    else
    {
	fprintf(stdout,"Encountering non-attachments for spike receiver\n");
    }

    //- return result : remember will not go any deeper

    return(iResult);
}

int SolverInfoCountIncomingConnections
(struct SolverInfo *psi,struct ProjectionQuery *ppq)
{
    //- set default result : none

    int iResult = 0;

    struct SolverInfoIncomingConnectionData icd =
    {
	//m projection query

	ppq,

	//m number of connections

	0,

	//m more data
    };

    //v traversal result

    int iTraverse;

    //- top of solved symbol tree

    struct PidinStack *ppist = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi,ppist);

    if (!phsleSolved)
    {
	return(-1);
    }

    //- count incoming connections for symbol

    iTraverse
	= SymbolTraverseSpikeReceivers
	  (phsleSolved,
	   ppist,
	   SolverInfoSpikeReceiver2ConnectionProcessor,
	   NULL,
	   (void *)&icd);

    PidinStackFree(ppist);

    //- if traversal unsuccessfull

    if (iTraverse != 1)
    {
	//- set failure

	iResult = -1;
    }

    //- else

    else
    {
	//- set result from traversal

	iResult = icd.iConnections;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoFree()
///
/// ARGS.:
///
///	psi......: solver info to free
///
/// RTN..: void
///
/// DESCR: Free solver info
///
/// **************************************************************************

void SolverInfoFree(struct SolverInfo * psi)
{
    //- free path

    if (psi->pcSolver)
    {
	free(psi->pcSolver);
    }

    //- free solver info

    free(psi->pcSolver);
}


/// **************************************************************************
///
/// SHORT: SolverInfoGetSolver()
///
/// ARGS.:
///
///	psi......: solver info to get info on
///
/// RTN..: char * : solver identification
///
/// DESCR: Get solver path from solver info
///
/// **************************************************************************

char * SolverInfoGetSolver(struct SolverInfo *psi)
{
    //- return result

    return(psi->pcSolver);
}


/// **************************************************************************
///
/// SHORT: SolverInfoInit()
///
/// ARGS.:
///
///	psi......: solver info to init
///	ppist....: context stack of solved symbol
///	pcSolver.: init string, path specification
///
/// RTN..: void
///
/// DESCR: Init solver info
///
/// NOTE.: 
///
///	Current assumption is that all subsymbols will be solved by the 
///	same solver, "**" is appended to indicate (== wildcard).
///
/// **************************************************************************

void SolverInfoInit
(struct SolverInfo * psi,struct PidinStack *ppist,char *pcSolver)
{
    //- wildcard to add if necessary

    struct symtab_IdentifierIndex *pidin = IdinCalloc();

    IdinSetName(pidin,"**");

    //- allocate & copy string

    psi->pcSolver = (char *)calloc(1 + strlen(pcSolver),1);

    strcpy(psi->pcSolver,pcSolver);

    //- copy context of solved symbol

    psi->ppist = PidinStackDuplicate(ppist);

    //- push wildcard

    PidinStackPush(psi->ppist,pidin);
}


/// **************************************************************************
///
/// SHORT: SolverInfoLookupContextFromPrincipalSerial()
///
/// ARGS.:
///
///	psi........: solver info
///	iPrincipal.: principal serial ID for symbol solved by psi
///
/// RTN..: struct PidinStack *
///
///	solved symbol, NULL for failure
///
/// DESCR: Convert solver serial ID to symbol info.
///
/// NOTE.:
///
///	Still relys on the fact that solvers solve all subsymbols of one 
///	common symbol. This makes the implementation of this procedure 
///	straightforward using the principal serial space.
///
/// **************************************************************************

/* struct SolverInfoPrincipal2ContextData */
/* { */
/*     //m result of operation */

/*     struct PidinStack *ppistResult; */

/*     //m number of skipped successors */

/*     int iSkippedSuccessors; */

/*     //m relative principal ID */

/*     int iPrincipal; */
/* }; */


/* static int  */
/* SolverInfoPrincipal2SymbolSelector */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : siblings */

/*     int iResult = SYMBOL_SELECTOR_PROCESS_SIBLING; */

/*     //- get pointer to conversion data */

/*     struct SolverInfoPrincipal2ContextData *psip2c */
/* 	= (struct SolverInfoPrincipal2ContextData *)pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- get number of successors */

/*     int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle); */

/*     //- get principal serial relative to parent */

/*     int iSerial = SymbolGetPrincipalSerialToParent(phsle); */

/*     //- if #SU + this symbol >= relative principal ID,  */
/*     //- or this is the symbol we are looking for */

/*     if (psip2c->iSkippedSuccessors + iSuccessors + 1 >= psip2c->iPrincipal */
/* 	|| iSerial == psip2c->iPrincipal) */
/*     { */
/* 	//- subtract principal serials */

/* 	psip2c->iPrincipal -= iSerial; */

/* 	//- register number of skipped successors : zero */

/* 	psip2c->iSkippedSuccessors = 0; */

/* 	//- set result : process children */

/* 	iResult = SYMBOL_SELECTOR_PROCESS_CHILDREN; */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- register that all successors and current symbol are skipped */

/* 	psip2c->iSkippedSuccessors += iSuccessors + 1; */

/* 	//- set result : process siblings */

/* 	iResult = SYMBOL_SELECTOR_PROCESS_SIBLING; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* static int  */
/* SolverInfoPrincipal2SymbolConvertor */
/* (struct TreespaceTraversal *ptstr,void *pvUserdata) */
/* { */
/*     //- set default result : siblings */

/*     int iResult = SYMBOL_PROCESSOR_SUCCESS; */

/*     //- get pointer to conversion data */

/*     struct SolverInfoPrincipal2ContextData *psip2c */
/* 	= (struct SolverInfoPrincipal2ContextData *)pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = TstrGetActual(ptstr); */

/*     //- get number of successors */

/*     int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle); */

/*     //- if match */

/*     if (0 == psip2c->iPrincipal) */
/*     { */
/* 	//- set result : current symbol */

/* 	psip2c->ppistResult = PidinStackDuplicate(ptstr->ppist); */

/* 	//- abort traversal */

/* 	return(SYMBOL_PROCESSOR_ABORT); */
/*     } */

/*     //- if #SU < relative principal ID or negative serial */

/*     if (iSuccessors < psip2c->iPrincipal || psip2c->iPrincipal < 0) */
/*     { */
/* 	printf */
/* 	    ("SolverInfoLookupContextFromPrincipalSerial() :" */
/* 	     " internal error\n"); */

/* 	//- we have an internal error : abort */

/* 	iResult = SYMBOL_PROCESSOR_ABORT; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


struct PidinStack *
SolverInfoLookupContextFromPrincipalSerial
(struct SolverInfo *psi,int iPrincipal)
{
    //- set default result : not found

    struct PidinStack *ppistResult = NULL;

/*     //v treespace traversal to go over successors */

/*     struct TreespaceTraversal *ptstr = NULL; */

/*     int iTraversal = 0; */

/*     //v number of successors for top of solved symbol tree */

/*     int iSuccessors = 0; */

/*     //v traversal user data */

/*     struct SolverInfoPrincipal2ContextData sip2c = */
/*     { */
/* 	//m result of operation */

/* 	NULL, */

/* 	//m number of skipped successors */

/* 	0, */

/* 	//m relative principal ID */

/* 	iPrincipal, */
/*     }; */

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi,ppistSolved);

    if (!phsleSolved)
    {
	return(NULL);
    }

/*     //- get #SU for symbol */

/*     iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsleSolved); */

/*     //- if serial greater than #SU */

/*     if (iPrincipal > iSuccessors) */
/*     { */
/* 	//- free allocated memory */

/* 	PidinStackFree(ppistSolved); */

/* 	//- serial ID unknown, return failure */

/* 	return(NULL); */
/*     } */

/*     //- allocate treespace traversal */

/*     ptstr */
/* 	= TstrNew */
/* 	  (ppistSolved, */
/* 	   SolverInfoPrincipal2SymbolSelector, */
/* 	   (void *)&sip2c, */
/* 	   SolverInfoPrincipal2SymbolConvertor, */
/* 	   (void *)&sip2c, */
/* 	   NULL, */
/* 	   NULL); */

/*     //- traverse symbols, looking for serial */

/*     iTraversal = TstrTraverse(ptstr,phsleSolved); */

/*     //- delete treespace traversal */

/*     TstrDelete(ptstr); */

    //- get result from single symbol

    ppistResult
	= SymbolPrincipalSerial2Context(phsleSolved,ppistSolved,iPrincipal);

    //- free allocated memory

    PidinStackFree(ppistSolved);

/*     //- set result from traversal data */

/*     ppistResult = sip2c.ppistResult; */

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoLookupPrincipalSerial()
///
/// ARGS.:
///
///	psi..: solver info
///	ppist: context to lookup
///
/// RTN..: int : serial ID relative to solver info, -1 for failure
///
/// DESCR: Get a solver serial ID.
///
/// NOTE.:
///
///	Still relys on the fact that solvers solve all subsymbols of one 
///	common symbol. This makes the implementation of this procedure 
///	straightforward using the principal serial space.
///
/// **************************************************************************

int SolverInfoLookupPrincipalSerial
(struct SolverInfo *psi,struct PidinStack *ppistSearched)
{
    //- set default result : not found

    int iResult = -1;

    //- start serial at zero (relative root)

    int iSerialID = 0;

    //v intermediate symbols

    struct PidinStack *ppistInter = PidinStackDuplicate(ppistSearched);

    struct symtab_HSolveListElement *phsleInter
	= PidinStackLookupTopSymbol(ppistInter);

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi,ppistSolved);

    if (!phsleSolved)
    {
	return(-1);
    }

    //- loop over all intermediate symbols in given context

    while (phsleInter && phsleInter != phsleSolved)
    {
	//- add serial ID from intermediate symbol

	iSerialID += SymbolGetPrincipalSerialToParent(phsleInter);

	//- get next symbol

	(void)PidinStackPop(ppistInter);

	phsleInter = PidinStackLookupTopSymbol(ppistInter);
    }

    //- free allocated memory

    PidinStackFree(ppistInter);
    PidinStackFree(ppistSolved);

    //- if found

    if (phsleInter == phsleSolved)
    {
	//- set result

	iResult = iSerialID;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoLookupRelativeSerial()
///
/// ARGS.:
///
///	psi.....: solver info
///	iSerial.: rooted symbol serial
///
/// RTN..: int : serial relative to given solver info, -1 for failure
///
/// DESCR: Recalculate rooted serial to serial relative to solver info.
///
///	This function will fail if the serial is not in the solved set.
///	In that case -1 is returned.
///
/// **************************************************************************

int SolverInfoLookupRelativeSerial(struct SolverInfo *psi,int iSerial)
{
    //- set default result : failure

    int iResult = -1;

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi,ppistSolved);

    //- get serial and successors of solved set

    int iSolvedSerial = PidinStackToSerial(ppistSolved);

    int iSolvedSuccessors = SymbolGetPrincipalNumOfSuccessors(phsleSolved);

    //- calculate relative serial

    int iRelative = iSerial - iSolvedSerial;

    //- relative serial is in solved set ?

    if (iRelative <= iSolvedSuccessors
	&& iRelative > 0)
    {
	//- ok, set result

	iResult = iRelative;
    }

    //- free allocated memory

    PidinStackFree(ppistSolved);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoLookupTopSymbol()
///
/// ARGS.:
///
///	psi..: solver info
///	ppist: receives context of topmost symbol
///
/// RTN..: struct symtab_HSolveListElement * : top symbol that is solved
///
///	ppist: receives context of topmost symbol
///
/// DESCR: Lookup solved top symbol
///
/// **************************************************************************

struct symtab_HSolveListElement *
SolverInfoLookupTopSymbol(struct SolverInfo *psi,struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    struct symtab_IdentifierIndex *pidinWildcard = NULL;

    //- get solved context

    struct PidinStack *ppistSolved = SolverInfoPidinStack(psi);

    //- duplicate 

    *ppist = *ppistSolved;

    //- pop wildcard idin

    pidinWildcard = PidinStackPop(ppist);

    //- if no wildcard

    if (!IdinIsWildCard(pidinWildcard,"**"))
    {
	//- return failure

	return(NULL);
    }

    //- lookup top symbol

    phsleResult = PidinStackLookupTopSymbol(ppist);

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoPidinStack()
///
/// ARGS.:
///
///	psi..: solver info
///
/// RTN..: struct PidinStack * : context associated by psi
///
/// DESCR: Get context associated with psi
///
/// **************************************************************************

struct PidinStack * SolverInfoPidinStack(struct SolverInfo * psi)
{
    //- set result : from info

    struct PidinStack *ppistResult = psi->ppist;

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoPrincipalSerial2SegmentSerial()
///
/// ARGS.:
///
///	psi........: solver info
///	iPrincipal.: serial ID in principal space to convert
///
/// RTN..: int : serial ID in segment space, -1 for failure
///
/// DESCR: Convert a principal serial to segment serial.
///
/// **************************************************************************

#ifdef TREESPACES_SUBSET_SEGMENT
int 
SolverInfoPrincipalSerial2SegmentSerial
(struct SolverInfo *psi,int iPrincipal)
{
    //- set default result : not found

    int iResult = -1;

    //v segment space serial

    int iSegment = -1;

    //v solved symbol tree

    struct PidinStack *ppistSolved = NULL;

    struct symtab_HSolveListElement *phsleSolved = NULL;

    //v intermediate symbols

    struct symtab_HSolveListElement *phsleInter = NULL;

    //- convert principal to context

    struct PidinStack *ppistInter
	= SolverInfoLookupContextFromPrincipalSerial(psi,iPrincipal);

    if (!ppistInter)
    {
	return(-1);
    }

    phsleInter = PidinStackLookupTopSymbol(ppistInter);

    //- get top of solved symbol tree

    ppistSolved = PidinStackCalloc();

    phsleSolved = SolverInfoLookupTopSymbol(psi,ppistSolved);

    if (!phsleSolved)
    {
	if (ppistSolved)
	{
	    PidinStackFree(ppistSolved);
	}

	return(-1);
    }

    //- lookup all intermediate symbols

    while (phsleInter && phsleInter != phsleSolved)
    {
	//- get serial ID from intermediate symbol

	iSegment += SymbolGetSegmentSerialToParent(phsleInter);

	//- get next symbol

	(void)PidinStackPop(ppistInter);

	phsleInter = PidinStackLookupTopSymbol(ppistInter);
    }

    //- free allocated memory

    PidinStackFree(ppistInter);
    PidinStackFree(ppistSolved);

    //- if found

    if (phsleInter == phsleSolved)
    {
	//- set result

	iResult = iSegment;
    }

    //- return result

    return(iResult);
}
#endif


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationAdd()
///
/// ARGS.:
///
///	pv...: must be NULL
///	psi..: solver info to register
///
/// RTN..: int : success of operation
///
/// DESCR: Register that a solver has been registered for a symbol
///
/// **************************************************************************

int SolverInfoRegistrationAdd(void *pv,struct SolverInfo *psi)
{
    //- set default result : ok

    int iResult = TRUE;

    //- add more registration entries if needed

    if (iRegistrations == iRegistrationMax)
    {
	if (SolverInfoRegistrationAddEntries() == 0)
	{
	    return(FALSE);
	}
    }

    //- register solver info

    ppsiRegistrations[iRegistrations] = psi;

    //- increment number of registrations

    iRegistrations++;

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationAddEntries()
///
/// ARGS.:
///
/// RTN..: int : success of operation
///
/// DESCR: Add registration entries
///
/// **************************************************************************

static int SolverInfoRegistrationAddEntries(void)
{
    //- set default result : ok

    int iResult = TRUE;

#define NEW_ENTRIES 10

    //- reallocate for some extra entries

    struct SolverInfo **ppsiOld = ppsiRegistrations;

    int iSize
	= sizeof(struct SolverInfo *) * (iRegistrationMax + NEW_ENTRIES);

    ppsiRegistrations = (struct SolverInfo **)realloc(ppsiRegistrations,iSize);

    if (!ppsiRegistrations)
    {
	ppsiRegistrations = ppsiOld;

	return(FALSE);
    }

    //- zero out new memory

    iSize = sizeof(struct SolverInfo *) * (NEW_ENTRIES);

    memset(&ppsiRegistrations[iRegistrationMax],0,iSize);

    iRegistrationMax += NEW_ENTRIES;

#undef NEW_ENTRIES

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationAddFromContext()
///
/// ARGS.:
///
///	pv........: must be NULL
///	ppist.....: wildcard for solved symbols
///	pcSolver..: name of solver (identification path)
///
/// RTN..: struct SolverInfo * : allocated solver info, NULL for failure
///
/// DESCR: Initialize solver info and register in global table.
///
/// **************************************************************************

struct SolverInfo *SolverInfoRegistrationAddFromContext
(void *pv,struct PidinStack *ppist,char *pcSolver)
{
    //- set result : allocate and init new solver info

    struct SolverInfo *psiResult = SolverInfoCalloc();

    SolverInfoInit(psiResult,ppist,pcSolver);

    //- register in global table

    SolverInfoRegistrationAdd(NULL,psiResult);

    //- return result

    return(psiResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationEnumerate()
///
/// ARGS.:
///
/// RTN..: int : success of operation
///
/// DESCR: Give some info about all solver info registrations
///
/// **************************************************************************

int SolverInfoRegistrationEnumerate(void)
{
    //- set default result : ok

    int iResult = TRUE;

    int i;

    //- loop over registrations

    for (i = 0 ; i < iRegistrations ; i++)
    {
	fprintf(stdout,"Solver registration %i :\n",i);
	PidinStackPrint(ppsiRegistrations[i]->ppist,stdout);
	fprintf(stdout,"\n");
	fprintf
	    (stdout,"\t\tSolved by (%s)\n\n",ppsiRegistrations[i]->pcSolver);
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationGet()
///
/// ARGS.:
///
///	pv....: must be NULL
///	ppist.: symbol context
///
/// RTN..: struct SolverInfo * : solver info, NULL for failure
///
/// DESCR: Try to find solver info for given symbol with context
///
///	if returned solver info does not match solver info in symbol, you 
///	have consistency problems.
///
///	If '/Cell' is solved by S_Cable, '/Cell/soma/Ca' is also solved by 
///	S_Cable unless an explicit entry saying '/Cell/soma/Ca' is not 
///	solved by S_Cable is present (e.g. an entry saying that it is 
///	solved by S_MC).
///
///	This system needs a lot of expansion at the moment.
///
/// BUGS:
///
///	This function does not find registrations for subsymbols, multiple
///	registrations for the same symbol neither (is this possible ?).
///
/// **************************************************************************

struct SolverInfo * 
SolverInfoRegistrationGet(void *pv,struct PidinStack *ppist)
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- loop over all solver registrations

    int i;

    for (i = 0 ; i < iRegistrations ; i++)
    {
	//- get solved context

	struct PidinStack *ppistSolved
	    = SolverInfoPidinStack(ppsiRegistrations[i]);

	//- if matches given context

	if (PidinStackMatch(ppist,ppistSolved))
	{
	    //- set result

	    psiResult = ppsiRegistrations[i];

	    //- break loop

	    break;
	}
    }

    //- return result

    return(psiResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoRegistrationGetForAbsoluteSerial()
///
/// ARGS.:
///
///	pv......: must be NULL.
///	iSerial.: rooted symbol serial.
///
/// RTN..: struct SolverInfo * : solver info, NULL for failure
///
/// DESCR: Try to find solver info for given serial.
///
/// NOTE.:
///
///	See SolverInfoRegistrationGet()
///
/// **************************************************************************

struct SolverInfo *
SolverInfoRegistrationGetForAbsoluteSerial(void *pv,int iSerial)
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- loop over all solver registrations

    int i;

    for (i = 0 ; i < iRegistrations ; i++)
    {
	//- if given serial in solved set

	if (SolverInfoSerialInSolvedSet(ppsiRegistrations[i],iSerial))
	{
	    //- set result

	    psiResult = ppsiRegistrations[i];

	    //- break loop

	    break;
	}
    }

    //- return result

    return(psiResult);
}


/// **************************************************************************
///
/// SHORT: SolverInfoSerialInSolvedSet()
///
/// ARGS.:
///
///	psi.....: solver info.
///	iSerial.: rooted symbol serial.
///
/// RTN..: int : TRUE if serial in solved set.
///
/// DESCR: Check if serial in solved set.
///
/// **************************************************************************

int SolverInfoSerialInSolvedSet(struct SolverInfo *psi,int iSerial)
{
    //- set default result : no

    int bResult = FALSE;

    //- do lookup on relative serial

    int iRelative = SolverInfoLookupRelativeSerial(psi,iSerial);

    //- set result

    bResult = iRelative != -1;

    //- return result

    return(bResult);
}


