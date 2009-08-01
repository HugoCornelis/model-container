/* -*- c -*- */

/* swig -perl5 -makedefault -module Neurospaces neurospaces.i */
/* gcc -c neurospaces_wrap.c `perl -MExtUtils::Embed -e ccopts`  */
/* gcc -shared neurospaces_wrap.o -L. -lneurospaces -o neurospaces.so */

%module SwiggableNeurospaces

%typemap(in) void * {

    $1 = $input;
};

%{

struct symtab_Invisible;

#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithmset.h"
#include "neurospaces/components/algorithmsymbol.h"
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/axonhillock.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/connection.h"
#include "neurospaces/components/contourpoint.h"
#include "neurospaces/components/emcontour.h"
#include "neurospaces/components/equationexponential.h"
#include "neurospaces/components/fiber.h"
#include "neurospaces/components/gatekinetic.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/groupedparameters.h"
#include "neurospaces/components/hhgate.h"
#include "neurospaces/components/iohier.h"
#include "neurospaces/components/iol.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/pool.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/randomvalue.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/components/vectorconnectionsymbol.h"
#include "neurospaces/components/vectorcontour.h"
#include "neurospaces/components/vectorsegment.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/iocontainer.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/positionD3.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/treespacetraversal.h"

#include "neurospaces/symbolvirtual_protos.h"

#include "hierarchy/output/symbols/all_callees_headers.h"
#include "hierarchy/output/symbols/runtime_casters.h"
#include "hierarchy/output/symbols/runtime_casters.c"

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

void * NeurospacesGetObject(struct Neurospaces *pneuro)
{
    return((void *)pneuro);
}


struct Neurospaces * NeurospacesSetObject(void *pv)
{
    return((struct Neurospaces *)pv);
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
%include "neurospaces/components/algorithmsymbol.h"
%include "neurospaces/components/attachment.h"
%include "neurospaces/components/axonhillock.h"
%include "neurospaces/components/biocomp.h"
%include "neurospaces/components/cell.h"
%include "neurospaces/components/channel.h"
%include "neurospaces/components/connection.h"
%include "neurospaces/components/contourpoint.h"
%include "neurospaces/dependencyfile.h"
%include "neurospaces/components/emcontour.h"
%include "neurospaces/components/equationexponential.h"
%include "neurospaces/components/fiber.h"
%include "neurospaces/function.h"
%include "neurospaces/components/gatekinetic.h"
%include "neurospaces/components/group.h"
%include "neurospaces/components/groupedparameters.h"
%include "neurospaces/components/hhgate.h"
%include "neurospaces/idin.h"
%include "neurospaces/importedfile.h"
%include "neurospaces/inputoutput.h"
%include "neurospaces/iocontainer.h"
%include "neurospaces/components/iohier.h"
%include "neurospaces/components/iol.h"
%include "neurospaces/components/network.h"
%include "neurospaces/neurospaces.h"
%include "neurospaces/parameters.h"
%include "neurospaces/parsersupport.h"
%include "neurospaces/pidinstack.h"
%include "neurospaces/components/pool.h"
%include "neurospaces/components/population.h"
%include "neurospaces/positionD3.h"
%include "neurospaces/components/projection.h"
%include "neurospaces/querymachine.h"
%include "neurospaces/components/randomvalue.h"
%include "neurospaces/components/segment.h"
%include "neurospaces/components/segmenter.h"
%include "neurospaces/solverinfo.h"
%include "neurospaces/symbols.h"
%include "neurospaces/symboltable.h"
%include "neurospaces/treespacetraversal.h"
%include "neurospaces/components/vector.h"
%include "neurospaces/components/vectorconnectionsymbol.h"
%include "neurospaces/components/vectorcontour.h"
%include "neurospaces/components/vectorsegment.h"

%include "neurospaces/symbolvirtual_protos.h"

%include "hierarchy/output/symbols/all_callees_headers.i"

