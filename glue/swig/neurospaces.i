/* -*- c -*- */

/* swig -perl5 -makedefault -module Neurospaces neurospaces.i */
/* gcc -c neurospaces_wrap.c `perl -MExtUtils::Embed -e ccopts`  */
/* gcc -shared neurospaces_wrap.o -L. -lneurospaces -o neurospaces.so */

%module SwiggableNeurospaces

%typemap(in) void * {

    $1 = $input;
};

%{


#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithmset.h"
#include "neurospaces/algorithmsymbol.h"
#include "neurospaces/attachment.h"
#include "neurospaces/axonhillock.h"
#include "neurospaces/biocomp.h"
#include "neurospaces/cell.h"
#include "neurospaces/channel.h"
#include "neurospaces/connection.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/emcontour.h"
#include "neurospaces/equation.h"
#include "neurospaces/fiber.h"
#include "neurospaces/function.h"
#include "neurospaces/gatekinetic.h"
#include "neurospaces/group.h"
#include "neurospaces/hhgate.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/iocontainer.h"
#include "neurospaces/iohier.h"
#include "neurospaces/iol.h"
#include "neurospaces/network.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/pool.h"
#include "neurospaces/population.h"
#include "neurospaces/positionD3.h"
#include "neurospaces/projection.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/randomvalue.h"
#include "neurospaces/segment.h"
#include "neurospaces/segmenter.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/vector.h"
#include "neurospaces/vectorconnectionsymbol.h"
#include "neurospaces/vectorsegment.h"

#include "neurospaces/symbolvirtual_protos.h"

#include "hierarchy/output/symbols/all_callees_headers.h"

%}

%inline %{

/* void piC2m_set(struct Intermediary *pim, int *piC2m) */
/* { */
/*     pim->piC2m = piC2m; */
/* } */

int *int_array(int size)
{
   return (int *) malloc(sizeof(int)*size);
}
void int_destroy(int *a)
{
   free(a);
}
void int_set(int *a, int i, int val)
{
   a[i] = val;
}
int int_get(int *a, int i)
{
   return a[i];
}

int treespace_traversal_go(struct traversal *pt)
{
    int iResult = 0;

    struct symtab_HSolveListElement *phsle
	= PidinStackLookupTopSymbol(pt->ptstr->ppist);

    if (phsle)
    {
	iResult = TstrGo(pt->ptstr, phsle);
    }

    TstrDelete(pt->ptstr);

    free(pt);

    return(iResult);
}


struct traversal *
treespace_traversal_new
(struct PidinStack *ppist,
 void *pvPerlTraversal,
 void *pvSelector,
 void *pvProcessor,
 void *pvFinalizer)
{
    struct traversal *pt = calloc(1, sizeof(struct traversal));

    pt->pvPerlTraversal = pvPerlTraversal;
    pt->pvSelector = pvSelector;
    pt->pvProcessor = pvProcessor;
    pt->pvFinalizer = pvFinalizer;
    
    pt->ptstr = TstrNew(ppist, treespace_traversal_selector, pt, treespace_traversal_processor, pt, treespace_traversal_finalizer, pt);

    return(pt);
}


%}


%include "neurospaces/algorithminstance.h"
%include "neurospaces/algorithmset.h"
%include "neurospaces/algorithmsymbol.h"
%include "neurospaces/attachment.h"
%include "neurospaces/axonhillock.h"
%include "neurospaces/biocomp.h"
%include "neurospaces/cell.h"
%include "neurospaces/channel.h"
%include "neurospaces/connection.h"
%include "neurospaces/dependencyfile.h"
%include "neurospaces/emcontour.h"
%include "neurospaces/equation.h"
%include "neurospaces/fiber.h"
%include "neurospaces/function.h"
%include "neurospaces/gatekinetic.h"
%include "neurospaces/group.h"
%include "neurospaces/hhgate.h"
%include "neurospaces/idin.h"
%include "neurospaces/importedfile.h"
%include "neurospaces/inputoutput.h"
%include "neurospaces/iocontainer.h"
%include "neurospaces/iohier.h"
%include "neurospaces/iol.h"
%include "neurospaces/network.h"
%include "neurospaces/neurospaces.h"
%include "neurospaces/parameters.h"
%include "neurospaces/parsersupport.h"
%include "neurospaces/pidinstack.h"
%include "neurospaces/pool.h"
%include "neurospaces/population.h"
%include "neurospaces/positionD3.h"
%include "neurospaces/projection.h"
%include "neurospaces/querymachine.h"
%include "neurospaces/randomvalue.h"
%include "neurospaces/segment.h"
%include "neurospaces/segmenter.h"
%include "neurospaces/solverinfo.h"
%include "neurospaces/symbols.h"
%include "neurospaces/symboltable.h"
%include "neurospaces/treespacetraversal.h"
%include "neurospaces/vector.h"
%include "neurospaces/vectorconnectionsymbol.h"
%include "neurospaces/vectorsegment.h"

%include "neurospaces/symbolvirtual_protos.h"

%include "hierarchy/output/symbols/all_callees_headers.i"

