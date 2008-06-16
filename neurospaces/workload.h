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
    //m attachment workload

    int iAttachment;

    //m axon hillock workload

    int iAxonHillock;

    //m cell workload

    int iCell;

    //m connection workload

    int iConnection;

    //m mechanism workload

    struct workload_mechanism_config
    {
	//m channel workload

	int iChannel;

	//m pool workload

	int iPool;

    }
	mechanisms;

    //m network workload

    int iNetwork;

    //m population workload

    int iPopulation;

    //m projection workload

    int iProjection;

    //m randomvalue workload

    int iRandomvalue;

    //m segment workload

    int iSegment;

};


extern struct workload_symbol_config wsc;


struct workload_info
{
    //m original traversal info

    struct traversal_info *pti;

    //m number of partitions

    int iPartitions;

    //m total workload

    int iWorkloadTotal;

    //m load for each partition

    double dWorkloadPartition;

    //m partitions

    int *piPartitions;

    //m workload of each partition

    int *piWorkloads;
};


int WorkloadFree(struct workload_info *pwi);

struct workload_info *
WorkloadNew
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iFlags);

int WorkloadPartition(struct workload_info *pwi, int iPartitions);

int WorkloadPrint(struct workload_info *pwi, FILE *pfile);


#endif


