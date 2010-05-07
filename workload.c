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
    /// attachment workload

    1,

    /// axon hillock workload

    0,

    /// cell workload

    0,

    /// connection workload

    0,

    /// mechanism workload

    {
	/// channel workload

	6,

	/// pool workload

	3,
    },

    /// network workload

    0,

    /// population workload

    0,

    /// projection workload

    0,

    /// randomvalue workload

    3,

    /// segment workload

    4,

};


/// 
/// \arg pwi workload to free.
/// 
/// \return int : success of operation.
/// 
/// \details 
/// 
///	Free workload.
/// 

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


/// 
/// \arg phsle symbol.
/// \arg ppist context.
/// \arg iLevel level of detail needed.
///	iFlags..: additional TRAVERSAL_INFO_* flags.
/// 
/// \return struct traversal_info : children info with cumulative
/// workload, NULL for failure.
/// 
/// \details 
/// 
///	Constructs a cumulative workload report for the given symbol.
/// 

struct workload_info *
WorkloadNew
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iFlags)
{
    //- set default result : failure

    struct workload_info *pwiResult = NULL;

    //- construct children info

    static struct traversal_info ti =
	{
	    /// information request flags

	    (TRAVERSAL_INFO_TYPES
	     | TRAVERSAL_INFO_WORKLOAD_INDIVIDUAL
	     | TRAVERSAL_INFO_WORKLOAD_CUMULATIVE),

	    /// traversal method flags

	    CHILDREN_TRAVERSAL_FIXED_RETURN,

	    /// traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

	    TSTR_PROCESSOR_SUCCESS,

	    /// current child index

	    0,

	    /// pidinstack pointing to root

	    NULL,

	    /// serials of symbols

	    NULL,

	    /// types of symbols

	    NULL,

	    /// chars with complete contexts

	    NULL,

	    /// chars with symbol names

	    NULL,

	    /// chars with symbol types

	    NULL,

	    /// local coordinates of symbols

	    NULL,

	    /// absolute coordinates of symbols

	    NULL,

	    /// absolute coordinates of parent segments

	    NULL,

	    NULL,

	    /// non-cumulative workload for symbols

	    NULL,

	    /// cumulative workload for symbols

	    NULL,

	    /// current cumulative workload

	    0,

	    /// stack top

	    -1,

	    /// stack used for accumulation

	    NULL,

	    /// stack used to track the traversal index of visited symbols

	    NULL,

	    /// allocation count

	    0,
	};

    ti.iFlagsInfo |= iFlags;

    struct BiolevelSelection bls =
    {
	/// chained user data

	NULL,

	/// mode : exclusive, inclusive

	SELECTOR_BIOLEVEL_INCLUSIVE,

	/// selected level

	iLevel,

	/// all levels follow, not used for now
    };

    int iSuccess
	= SymbolTraverseBioLevels
	  (phsle,
	   ppist,
	   &bls,
	   TraversalInfoCollectorProcessor,
	   TraversalInfoCumulativeInfoCollectorProcessor,
	   (void *)&ti);

    /// \todo extract workload info to disambiguate things

    //- return result

    if (iSuccess != 1)
    {
	return(NULL);
    }
    else
    {
	pwiResult = calloc(1, sizeof(*pwiResult));

	/// \todo passing through a static struct

	pwiResult->pti = &ti;

	return(pwiResult);
    }
}


/// 
/// \arg ptiWorkload cumulative workload report.
/// \arg iPartitions number of needed partitions.
/// 
/// \return int : success of operation.
/// 
/// \details 
/// 
///	Construct a partitioning for the given workload report.
/// 

int WorkloadPartition(struct workload_info *pwi, int iPartitions)
{
    //- set default result : failure

    int iResult = FALSE;

    struct traversal_info *pti = pwi->pti;

    //- register total cumulative workload

    /// \note always comes in first element, or we have an internal error

    int iWorkloadTotal = pti->piWorkloadCumulative[0];

    pwi->iWorkloadTotal = iWorkloadTotal;

    //- register number of partitions

    pwi->iPartitions = iPartitions;

    //- determine the load for each partition

    double dWorkloadPartition = (double)iWorkloadTotal / (double)iPartitions;

    pwi->dWorkloadPartition = dWorkloadPartition;

    //- allocation partition info

    /// \note add one because we will register one more serial and one more workload

    pwi->piPartitions = (int *)calloc(iPartitions + 1, sizeof(*pwi->piPartitions));

    if (!pwi->piPartitions)
    {
	return(FALSE);
    }

    /// \note add one because we will register one more serial and one more workload

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


/// 
/// \arg pwi cumulative workload report.
/// \arg pfile file to print workload report to.
/// 
/// \return int : success of operation.
/// 
/// \details 
/// 
///	Print workload report to the given file.
/// 

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


