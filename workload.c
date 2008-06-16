//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: workload.c 1.14 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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



#include "neurospaces/workload.h"

#include "neurospaces/biolevel.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/traversalinfo.h"


struct workload_symbol_config wsc =
{
    //m attachment workload

    1,

    //m axon hillock workload

    0,

    //m cell workload

    0,

    //m connection workload

    0,

    //m mechanism workload

    {
	//m channel workload

	6,

	//m pool workload

	3,
    },

    //m network workload

    0,

    //m population workload

    0,

    //m projection workload

    0,

    //m randomvalue workload

    3,

    //m segment workload

    4,

};


/// **************************************************************************
///
/// SHORT: WorkloadFree()
///
/// ARGS.:
///
///	pwi.: workload to free.
///
/// RTN..:
///
///	int : success of operation.
///
/// DESCR:
///
///	Free workload.
///
/// **************************************************************************

int WorkloadFree(struct workload_info *pwi)
{
    //- free allocated memory

    if (pwi->piPartitions)
    {
	free(pwi->piPartitions);

	pwi->piPartitions = NULL;
    }

    if (pwi->piWorkloads)
    {
	free(pwi->piWorkloads);

	pwi->piWorkloads = NULL;
    }

    struct traversal_info *pti = pwi->pti;

    if (pti)
    {
	TraversalInfoFree(pti);

	pwi->pti = NULL;
    }

    free(pwi);

    //- return success

    return(TRUE);
}


/// **************************************************************************
///
/// SHORT: WorkloadNew()
///
/// ARGS.:
///
///	phsle...: symbol.
///	ppist...: context.
///	iLevel..: level of detail needed.
///	iFlags..: additional TRAVERSAL_INFO_* flags.
///
/// RTN..:
///
///	struct traversal_info : children info with cumulative workload,
///	NULL for failure.
///
/// DESCR:
///
///	Constructs a cumulative workload report for the given symbol.
///
/// **************************************************************************

struct workload_info *
WorkloadNew
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iFlags)
{
    //- set default result : failure

    struct workload_info *pwiResult = NULL;

    //- construct children info

    static struct traversal_info ti =
	{
	    //m information request flags

	    (TRAVERSAL_INFO_TYPES
	     | TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL
	     | TRAVERSAL_INFO_WORKLOAD_CUMULATIVE),

	    //m traversal method flags

	    CHILDREN_TRAVERSAL_FIXED_RETURN,

	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    TSTR_PROCESSOR_SUCCESS,

	    //m current child index

	    0,

	    //m pidinstack pointing to root

	    NULL,

	    //m serials of symbols

	    NULL,

	    //m types of symbols

	    NULL,

	    //m chars with complete contexts

	    NULL,

	    //m chars with symbol names

	    NULL,

	    //m chars with symbol types

	    NULL,

	    //m local coordinates of symbols

	    NULL,

	    //m absolute coordinates of symbols

	    NULL,

	    //m absolute coordinates of parent segments

	    NULL,

	    NULL,

	    //m non-cumulative workload for symbols

	    NULL,

	    //m cumulative workload for symbols

	    NULL,

	    //m current cumulative workload

	    0,

	    //m stack top

	    -1,

	    //m stack used for accumulation

	    NULL,

	    //m stack used to track the traversal index of visited symbols

	    NULL,

	    //m allocation count

	    0,
	};

    ti.iFlagsInfo |= iFlags;

    struct BiolevelSelection bls =
    {
	//m chained user data

	NULL,

	//m mode : exclusive, inclusive

	SELECTOR_BIOLEVEL_INCLUSIVE,

	//m selected level

	iLevel,

	//m all levels follow, not used for now
    };

    int iSuccess
	= SymbolTraverseBioLevels
	  (phsle,
	   ppist,
	   &bls,
	   TraversalInfoCollectorProcessor,
	   TraversalInfoCumulativeInfoCollectorProcessor,
	   (void *)&ti);

    //t extract workload info to disambiguate things

    //- return result

    if (iSuccess != 1)
    {
	return(NULL);
    }
    else
    {
	pwiResult = calloc(1, sizeof(*pwiResult));

	//t passing through a static struct

	pwiResult->pti = &ti;

	return(pwiResult);
    }
}


/// **************************************************************************
///
/// SHORT: WorkloadPartition()
///
/// ARGS.:
///
///	ptiWorkload.: cumulative workload report.
///	iPartitions.: number of needed partitions.
///
/// RTN..:
///
///	int : success of operation.
///
/// DESCR:
///
///	Construct a partitioning for the given workload report.
///
/// **************************************************************************

int WorkloadPartition(struct workload_info *pwi, int iPartitions)
{
    //- set default result : failure

    int iResult = FALSE;

    struct traversal_info *pti = pwi->pti;

    //- register total cumulative workload

    //! always comes in first element, or we have an internal error

    int iWorkloadTotal = pti->piWorkloadCumulative[0];

    pwi->iWorkloadTotal = iWorkloadTotal;

    //- register number of partitions

    pwi->iPartitions = iPartitions;

    //- determine the load for each partition

    double dWorkloadPartition = (double)iWorkloadTotal / (double)iPartitions;

    pwi->dWorkloadPartition = dWorkloadPartition;

    //- allocation partition info

    //! add one because we will register one more serial and one more workload

    pwi->piPartitions = (int *)calloc(iPartitions + 1, sizeof(*pwi->piPartitions));

    if (!pwi->piPartitions)
    {
	return(FALSE);
    }

    //! add one because we will register one more serial and one more workload

    pwi->piWorkloads = (int *)calloc(iPartitions + 1, sizeof(*pwi->piWorkloads));

    if (!pwi->piWorkloads)
    {
	return(FALSE);
    }

    //- start with the first partition

    int iPartition = 0;

    //- start with a assigned workload of zero

    int iAssigned = 0;

    //- keep track of cumulated assiged workload

    int iAssignedCumulated = 0;

    //- loop over the children found

    int i;

    for (i = 0; i < pti->iChildren; i++)
    {
	//- if this child is a partitioning element

	if (pti->piTypes[i] == HIERARCHY_TYPE_symbols_cell
	    || pti->piTypes[i] == HIERARCHY_TYPE_symbols_fiber)
	{
	    //- get cumulative workload

	    int iWorkload = pti->piWorkloadCumulative[i];

	    //- assign the workload to the current partition

	    iAssigned += iWorkload;

	    iAssignedCumulated += iWorkload;

	    //- if the workload for this partition is filled

	    if (iAssigned >= dWorkloadPartition)
	    {
		//- register the workload of this partition

		pwi->piWorkloads[iPartition] = iAssigned;

		//- next partition

		iPartition++;

		//- register the serial of the partitioner

		pwi->piPartitions[iPartition] = pti->piSerials[i];

		//- no load assigned to this partition

		iAssigned = 0.0;
	    }
	}
    }

    //- register the workload of the last partition

    pwi->piWorkloads[iPartition] = iAssigned;

    if (iWorkloadTotal != iAssignedCumulated)
    {
	fprintf(stderr, "Warning : workload mismatch, iWorkloadTotal (%i) != iAssignedCumulated (%i)\n", iWorkloadTotal, iAssignedCumulated);
    }

    //- return result

    iResult = TRUE;

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: WorkloadPrint()
///
/// ARGS.:
///
///	pwi...: cumulative workload report.
///	pfile.: file to print workload report to.
///
/// RTN..:
///
///	int : success of operation.
///
/// DESCR:
///
///	Print workload report to the given file.
///
/// **************************************************************************

int WorkloadPrint(struct workload_info *pwi, FILE *pfile)
{
    //- set default result : ok

    int iResult = TRUE;

    //- report singulars : total workload, partitions, load per partition

    fprintf(pfile, "total workload : %i\n", pwi->iWorkloadTotal);

    fprintf(pfile, " # partitions  : %i\n", pwi->iPartitions);

    fprintf(pfile, "work  per part : %f\n", pwi->dWorkloadPartition);

    //- loop over the partitions

    int i;

    for (i = 0 ; i < pwi->iPartitions ; i++)
    {
	//- report the partition start serial

	fprintf(pfile, "    serial  part  %i : %i\n", i, pwi->piPartitions[i]);

	//- report the partition workload

	fprintf(pfile, "    work for part %i : %i\n", i, pwi->piWorkloads[i]);
    }

    //- return result

    return(iResult);
}


