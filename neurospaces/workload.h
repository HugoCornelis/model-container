//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: workload.h 1.8 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/*
** workload computations
*/

#ifndef WORKLOAD_H
#define WORKLOAD_H


#include "treespacetraversal.h"
#include "symboltable.h"
#include "traversalinfo.h"


struct workload_symbol_config
{
    /// attachment workload

    int iAttachment;

    /// axon hillock workload

    int iAxonHillock;

    /// cell workload

    int iCell;

    /// connection workload

    int iConnection;

    /// mechanism workload

    struct workload_mechanism_config
    {
	/// channel workload

	int iChannel;

	/// pool workload

	int iPool;

    }
	mechanisms;

    /// network workload

    int iNetwork;

    /// population workload

    int iPopulation;

    /// projection workload

    int iProjection;

    /// randomvalue workload

    int iRandomvalue;

    /// segment workload

    int iSegment;

};


extern struct workload_symbol_config wsc;


struct workload_info
{
    /// original traversal info

    struct traversal_info *pti;

    /// number of partitions

    int iPartitions;

    /// total workload

    int iWorkloadTotal;

    /// load for each partition

    double dWorkloadPartition;

    /// partitions

    int *piPartitions;

    /// workload of each partition

    int *piWorkloads;
};


int WorkloadFree(struct workload_info *pwi);

struct workload_info *
WorkloadNew
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iFlags);

int WorkloadPartition(struct workload_info *pwi, int iPartitions);

int WorkloadPrint(struct workload_info *pwi, FILE *pfile);


#endif


