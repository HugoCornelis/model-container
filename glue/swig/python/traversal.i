
%{

char * NeurospacesGetObject(struct Neurospaces *pneuro)
{
    static char pcResult[100];

    sprintf(pcResult, "pneuro (%p), root import (%p)\n", pneuro, pneuro->pifRootImport);

/*     fprintf(stdout, "NeurospacesGetObject(): %s", pcResult); */

    return(pcResult);
}


struct Neurospaces * NeurospacesSetObject(char *pcNeurospaces)
{
    void *pv;

    struct Neurospaces *pneuroResult = NULL;

    sscanf(pcNeurospaces, "pneuro (%p), root import (%p)", &pneuroResult, &pv);

/*     fprintf(stdout, "NeurospacesSetObject(): pneuro (%p), root import (%p)\n", pneuroResult, pneuroResult->pifRootImport); */

    return(pneuroResult);
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


%inline %{

%}





