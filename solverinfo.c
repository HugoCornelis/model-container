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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/attachment.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/symbolvirtual_protos.h"



static int SolverInfoRegistrationAddEntries(void);


/// all solver registrations

struct SolverInfo **ppsiRegistrations = NULL;

int iRegistrations = 0;

int iRegistrationMax = 0;


/// 
/// \return struct SolverInfo * 
/// 
///	Newly allocated solver info, NULL for failure
/// 
/// \brief Allocate a new solver info
/// 

struct SolverInfo * SolverInfoCalloc()
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- allocate

    psiResult = (struct SolverInfo *)calloc(1, sizeof(struct SolverInfo));

    //- return result

    return(psiResult);
}


/// 
/// \arg psi solver info
/// \arg ppq projection query
/// 
/// \return int : number of incoming connections, -1 for failure
/// 
/// \brief Count incoming connections in projection query for given solver
/// 

struct SolverInfoIncomingConnectionData
{
    /// projection query

    struct ProjectionQuery *ppq;

    /// number of connections

    int iConnections;

    /// more data
};


static int 
SolverInfoIncomingConnectionCounter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    /// \note We know this will only be called on connections
    /// \note associated with a registered spike receiver

    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to original population data

    struct SolverInfoIncomingConnectionData *picd
	= (struct SolverInfoIncomingConnectionData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if connection

    /// \note sanity check

    int iType = TstrGetActualType(ptstr);

    if (subsetof_connection(iType))
    {
	//- increment connection count

	picd->iConnections++;
    }
    else
    {
	fprintf(stdout, "Encountering non-connections for spike receiver\n");
    }

    //- return result : remember will not go any deeper

    return(iResult);
}

static int 
SolverInfoSpikeReceiver2ConnectionProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    /// \note We know this will only be called on spike receivers

    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to original population data

    struct SolverInfoIncomingConnectionData *picd
	= (struct SolverInfoIncomingConnectionData *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- if spike receiver

    int iType = TstrGetActualType(ptstr);

    /// \note sanity check

    if (subsetof_attachment(iType)
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
	fprintf(stdout, "Encountering non-attachments for spike receiver\n");
    }

    //- return result : remember will not go any deeper

    return(iResult);
}

int SolverInfoCountIncomingConnections
(struct SolverInfo *psi, struct ProjectionQuery *ppq)
{
    //- set default result : none

    int iResult = 0;

    struct SolverInfoIncomingConnectionData icd =
    {
	/// projection query

	ppq,

	/// number of connections

	0,

	/// more data
    };

    /// traversal result

    int iTraverse;

    //- top of solved symbol tree

    struct PidinStack *ppist = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi, ppist);

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


/// 
/// \arg psi solver info to free
/// 
/// \return void
/// 
/// \brief Free solver info
/// 

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


/// 
/// \arg psi solver info to get info on
/// 
/// \return char * : solver identification
/// 
/// \brief Get solver path from solver info
/// 

char * SolverInfoGetSolverString(struct SolverInfo *psi)
{
    //- return result

    return(psi->pcSolver);
}


/// 
/// \arg psi solver info to init
/// \arg ppist context stack of solved symbol
///	pcSolver.: init string, path specification
/// 
/// \return void
/// 
/// \brief Init solver info
/// 
/// \note  
/// 
///	Current assumption is that all subsymbols will be solved by the 
///	same solver, "**" is appended to indicate (== wildcard).
/// 

int
SolverInfoInit
(struct SolverInfo * psi, void *pvSolver, struct PidinStack *ppist, char *pcSolver)
{
    //- wildcard to add if necessary

    struct symtab_IdentifierIndex *pidin = IdinCalloc();

    IdinSetName(pidin, "**");

    //- allocate & copy string

    psi->pcSolver = strdup(pcSolver);

    //- copy context of solved symbol

    psi->ppist = PidinStackDuplicate(ppist);

    //- push wildcard

    PidinStackPush(psi->ppist, pidin);

    //- register internal solver ID, note: can be a proxy

    psi->pvSolver = pvSolver;
}


/// 
/// \arg psi solver info
/// \arg iPrincipal principal serial ID for symbol solved by psi
/// 
/// \return struct PidinStack *
/// 
///	solved symbol, NULL for failure
/// 
/// \brief Convert solver serial ID to symbol info.
/// 
/// \note 
/// 
///	Still relys on the fact that solvers solve all subsymbols of one 
///	common symbol. This makes the implementation of this procedure 
///	straightforward using the principal serial space.
/// 

/* struct SolverInfoPrincipal2ContextData */
/* { */
/*     /// result of operation */

/*     struct PidinStack *ppistResult; */

/*     /// number of skipped successors */

/*     int iSkippedSuccessors; */

/*     /// relative principal ID */

/*     int iPrincipal; */
/* }; */


/* static int  */
/* SolverInfoPrincipal2SymbolSelector */
/* (struct TreespaceTraversal *ptstr, void *pvUserdata) */
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
/* (struct TreespaceTraversal *ptstr, void *pvUserdata) */
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
(struct SolverInfo *psi, int iPrincipal)
{
    //- set default result : not found

    struct PidinStack *ppistResult = NULL;

/*     /// treespace traversal to go over successors */

/*     struct TreespaceTraversal *ptstr = NULL; */

/*     int iTraversal = 0; */

/*     /// number of successors for top of solved symbol tree */

/*     int iSuccessors = 0; */

/*     /// traversal user data */

/*     struct SolverInfoPrincipal2ContextData sip2c = */
/*     { */
/* 	/// result of operation */

/* 	NULL, */

/* 	/// number of skipped successors */

/* 	0, */

/* 	/// relative principal ID */

/* 	iPrincipal, */
/*     }; */

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi, ppistSolved);

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

/*     iTraversal = TstrTraverse(ptstr, phsleSolved); */

/*     //- delete treespace traversal */

/*     TstrDelete(ptstr); */

    //- get result from single symbol

    ppistResult
	= SymbolPrincipalSerial2Context(phsleSolved, ppistSolved, iPrincipal);

    //- free allocated memory

    PidinStackFree(ppistSolved);

/*     //- set result from traversal data */

/*     ppistResult = sip2c.ppistResult; */

    //- return result

    return(ppistResult);
}


/// 
/// \arg psi solver info
/// \arg ppist: context to lookup
/// 
/// \return int  serial ID relative to solver info, -1 for failure
/// 
/// \brief Get a solver serial ID.
/// 
/// \note 
/// 
///	Still relys on the fact that solvers solve all subsymbols of one 
///	common symbol. This makes the implementation of this procedure 
///	straightforward using the principal serial space.
/// 

int SolverInfoLookupPrincipalSerial
(struct SolverInfo *psi, struct PidinStack *ppistSearched)
{
    //- set default result : not found

    int iResult = -1;

    //- start serial at zero (relative root)

    int iSerialID = 0;

    /// intermediate symbols

    struct PidinStack *ppistInter = PidinStackDuplicate(ppistSearched);

    struct symtab_HSolveListElement *phsleInter
	= PidinStackLookupTopSymbol(ppistInter);

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi, ppistSolved);

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


/// 
/// \arg psi solver info
/// \arg iSerial rooted symbol serial
/// 
/// \return int : serial relative to given solver info, -1 for failure
/// 
/// \brief Recalculate rooted serial to serial relative to solver info.
/// 
/// \details 
/// 
///	This function will fail if the serial is not in the solved set.
///	In that case -1 is returned.
/// 

int SolverInfoLookupRelativeSerial(struct SolverInfo *psi, int iSerial)
{
    //- set default result : failure

    int iResult = -1;

    //- get top of solved symbol tree

    struct PidinStack *ppistSolved = PidinStackCalloc();

    struct symtab_HSolveListElement *phsleSolved
	= SolverInfoLookupTopSymbol(psi, ppistSolved);

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


/// 
/// \arg psi solver info
/// \arg ppist: receives context of topmost symbol
/// 
/// \return struct symtab_HSolveListElement * : top symbol that is solved
/// 
///	ppist: receives context of topmost symbol
/// 
/// \brief Lookup solved top symbol
/// 

struct symtab_HSolveListElement *
SolverInfoLookupTopSymbol(struct SolverInfo *psi, struct PidinStack *ppist)
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

    if (!IdinIsWildCard(pidinWildcard, "**"))
    {
	//- return failure

	return(NULL);
    }

    //- lookup top symbol

    phsleResult = PidinStackLookupTopSymbol(ppist);

    //- return result

    return(phsleResult);
}


/// 
/// \arg psi solver info
/// 
/// \return struct PidinStack * : context associated by psi
/// 
/// \brief Get context associated with psi
/// 

struct PidinStack * SolverInfoPidinStack(struct SolverInfo * psi)
{
    //- set result : from info

    struct PidinStack *ppistResult = psi->ppist;

    //- return result

    return(ppistResult);
}


/// 
/// \arg psi solver info
/// \arg iPrincipal serial ID in principal space to convert
/// 
/// \return int : serial ID in segment space, -1 for failure
/// 
/// \brief Convert a principal serial to segment serial.
/// 

#ifdef TREESPACES_SUBSET_SEGMENT
int 
SolverInfoPrincipalSerial2SegmentSerial
(struct SolverInfo *psi, int iPrincipal)
{
    //- set default result : not found

    int iResult = -1;

    /// segment space serial

    int iSegment = -1;

    /// solved symbol tree

    struct PidinStack *ppistSolved = NULL;

    struct symtab_HSolveListElement *phsleSolved = NULL;

    /// intermediate symbols

    struct symtab_HSolveListElement *phsleInter = NULL;

    //- convert principal to context

    struct PidinStack *ppistInter
	= SolverInfoLookupContextFromPrincipalSerial(psi, iPrincipal);

    if (!ppistInter)
    {
	return(-1);
    }

    phsleInter = PidinStackLookupTopSymbol(ppistInter);

    //- get top of solved symbol tree

    ppistSolved = PidinStackCalloc();

    phsleSolved = SolverInfoLookupTopSymbol(psi, ppistSolved);

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


/// 
/// \arg pv must be NULL
/// \arg psi solver info to register
/// 
/// \return int : success of operation
/// 
/// \brief Register that a solver has been registered for a symbol
/// 

int SolverInfoRegistrationAdd(void *pv, struct SolverInfo *psi)
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


/// 
/// \return int : success of operation
/// 
/// \brief Add registration entries
/// 

static int SolverInfoRegistrationAddEntries(void)
{
    //- set default result : ok

    int iResult = TRUE;

#define NEW_ENTRIES 10

    //- reallocate for some extra entries

    struct SolverInfo **ppsiOld = ppsiRegistrations;

    int iSize
	= sizeof(struct SolverInfo *) * (iRegistrationMax + NEW_ENTRIES);

    ppsiRegistrations = (struct SolverInfo **)realloc(ppsiRegistrations, iSize);

    if (!ppsiRegistrations)
    {
	ppsiRegistrations = ppsiOld;

	return(FALSE);
    }

    //- zero out new memory

    iSize = sizeof(struct SolverInfo *) * (NEW_ENTRIES);

    memset(&ppsiRegistrations[iRegistrationMax], 0, iSize);

    iRegistrationMax += NEW_ENTRIES;

#undef NEW_ENTRIES

    //- return result

    return(iResult);
}


/// 
/// \arg pvSolver solver or proxy pointer.
/// \arg ppist wildcard for solved symbols.
/// \arg pcSolver name of solver (identification path).
/// 
/// \return struct SolverInfo * : allocated solver info, NULL for failure
/// 
/// \brief Initialize solver info and register in global table.
/// 

struct SolverInfo *
SolverInfoRegistrationAddFromContext
(void *pvSolver, struct PidinStack *ppist, char *pcSolver)
{
    //- set result : allocate and init new solver info

    struct SolverInfo *psiResult = SolverInfoCalloc();

    SolverInfoInit(psiResult, pvSolver, ppist, pcSolver);

    //- register in global table

    SolverInfoRegistrationAdd(NULL, psiResult);

    //- return result

    return(psiResult);
}


/// 
/// \return int : success of operation
/// 
/// \brief Give some info about all solver info registrations
/// 

int SolverInfoRegistrationEnumerate(void)
{
    //- set default result : ok

    int iResult = TRUE;

    fprintf(stdout, "\n---\n");

    //- loop over registrations

    int i;

    for (i = 0 ; i < iRegistrations ; i++)
    {
	//- print info

	fprintf(stdout, "  - name: %s\n", ppsiRegistrations[i]->pcSolver);

	fprintf(stdout, "    solver: %s\n", (ppsiRegistrations[i]->pvSolver == NULL) ? "not registered" : "registered");

	fprintf(stdout, "    context: ");

	struct PidinStack *ppistSolved = SolverInfoPidinStack(ppsiRegistrations[i]);

	PidinStackPrint(ppistSolved, stdout);

	fprintf(stdout, "\n");
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pv must be NULL
/// \arg ppist symbol context
/// 
/// \return struct SolverInfo * : solver info, NULL for failure
/// 
/// \brief Try to find solver info for given symbol with context
/// 
/// \details 
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

struct SolverInfo * 
SolverInfoRegistrationGet(void *pv, struct PidinStack *ppist)
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- loop over all solver registrations

    int i;

    for (i = 0 ; i < iRegistrations ; i++)
    {
	//- get solved context

	struct PidinStack *ppistSolved = SolverInfoPidinStack(ppsiRegistrations[i]);

	//- if matches given context

	if (PidinStackMatch(ppist, ppistSolved))
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


/// 
/// \arg pv must be NULL.
/// \arg iSerial rooted symbol serial.
/// 
/// \return struct SolverInfo * : solver info, NULL for failure
/// 
/// \brief Try to find solver info for given serial.
/// 
/// \note 
/// 
///	See SolverInfoRegistrationGet()
/// 

struct SolverInfo *
SolverInfoRegistrationGetForAbsoluteSerial(void *pv, int iSerial)
{
    //- set default result : failure

    struct SolverInfo * psiResult = NULL;

    //- loop over all solver registrations

    int i;

    for (i = 0 ; i < iRegistrations ; i++)
    {
	//- if given serial in solved set

	if (SolverInfoSerialInSolvedSet(ppsiRegistrations[i], iSerial))
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


/// 
/// \arg psi solver info.
/// \arg iSerial rooted symbol serial.
/// 
/// \return int : TRUE if serial in solved set.
/// 
/// \brief Check if serial in solved set.
/// 

int SolverInfoSerialInSolvedSet(struct SolverInfo *psi,int iSerial)
{
    //- set default result : no

    int bResult = FALSE;

    //- do lookup on relative serial

    int iRelative = SolverInfoLookupRelativeSerial(psi, iSerial);

    //- set result

    bResult = iRelative != -1;

    //- return result

    return(bResult);
}


