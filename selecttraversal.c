//*********************************************************
/*!
 * \file selecttraversal.c
 */
//*********************************************************

#include "neurospaces/components/root.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/traversalinfo.h"
#include "neurospaces/treespacetraversal.h"

#include "hierarchy/output/symbols/all_callees_headers.h"

//----------------------- static prototypes ------------------------------------
static struct traversal_info * TraversalInfoCalloc();

//-------------------- end static prototypes -----------------------------------


static struct traversal_info * TraversalInfoCalloc()
{

  struct traversal_info *pti = (struct traversal_info *)calloc(1,sizeof(struct traversal_info));
  
  if( !pti )
  {
    return NULL;
  }

  // Here we initlaize the traveral info struct
  pti->iFlagsInfo = 0;
  pti->iFlagsTraversal = 0;
  pti->iTraversalResult = 0;
  pti->iChildren = 0;
  pti->ppistRoot = NULL;
  pti->piSerials = NULL;
  pti->piTypes = NULL;
  pti->ppcContexts = NULL;
  pti->ppcNames = NULL;
  pti->ppcTypes = NULL;
  pti->ppD3CoordsLocal = NULL;
  pti->ppD3CoordsAbsolute = NULL;
  pti->ppD3CoordsAbsoluteParent = NULL;
  pti->pdDia = NULL;
  pti->piWorkloadIndividual = NULL;
  pti->piWorkloadCumulative = 0;
  pti->iStackTop = -1;
  pti->piCurrentSymbol = NULL;
  pti->iAllocated = 0;

  return pti;

}



/*!
* \returns A traversal info struct with traversal data, null on error or no operation
*
* \param pcPath The path to the element to start traversal at. 
* \param iSelect The traversal mode
* \param iMode The mode to use for biolevel traversals.
* \param iLevel The depth of level to traverse in biolevel traversals.
* \param pneuro A neurospaces object
*
* Performs a traversal starting from the given path. If a wildcard traversal is selected
* then the path must contain a wildcard. If it is a null pointer then "/**" is used.
* 
* Note:Should probably have this return some sort of error code or set an error string 
* since it makes it difficult to return a specific exception to Python so that problems can be diagnosed.
*/
struct traversal_info * SelectTraversal(char *pcPath, int iSelect, int iMode, int iLevel, struct Neurospaces *pneuro)
{
  int iSuccess = 0;
  struct traversal_info *pti = NULL;
  struct BiolevelSelection bls;
  struct PidinStack *ppist = NULL;
  struct PidinStack *ppistRoot = NULL;
  struct PidinStack *ppistTraversal = NULL; 
  struct symtab_HSolveListElement *phsle = NULL;
  struct symtab_HSolveListElement *phsleTraversal = NULL;
  struct symtab_HSolveListElement *phsleRoot = NULL;
  struct symtab_IdentifierIndex *pidin = NULL;
  struct symtab_IdentifierIndex *pidinTraversal = NULL;
  struct symtab_IdentifierIndex *pidinRoot = NULL;
  struct TreespaceTraversal *ptstr = NULL;
  struct ImportedFile *pif = NULL;
  struct symtab_RootSymbol *prootNamespace = NULL;
  int iTraversalFlags = 0;


  pti = TraversalInfoCalloc();

  if( !pti )
  {
    PidinStackFree(ppist);

    return NULL;
  }

  //----------------------------------------------------------------------------
  // This section just sets our traversal flags.
  // Can probably merge this with the other operations but 
  // this will be seperate for clarity now
  //----------------------------------------------------------------------------
  if( iSelect & TRAVERSAL_SELECT_CHILDREN )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_NAMES | TRAVERSAL_INFO_TYPES
      | TRAVERSAL_INFO_COORDS_LOCAL | TRAVERSAL_INFO_COORDS_ABSOLUTE;


    ppist = PidinStackParse(pcPath);

    if( !ppist )
    {
      return NULL;
    }

    phsle = PidinStackLookupTopSymbol(ppist);

    if( !phsle )
    {
      return NULL;
    }

  }
  else if( iSelect & TRAVERSAL_SELECT_COORDINATES )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_NAMES | TRAVERSAL_INFO_TYPES
      | TRAVERSAL_INFO_COORDS_LOCAL | TRAVERSAL_INFO_COORDS_ABSOLUTE
      | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT;

    pti->iFlagsTraversal = (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? CHILDREN_TRAVERSAL_FIXED_RETURN : 0;
    pti->iTraversalResult = (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? TSTR_PROCESSOR_SUCCESS : 0;


    ppist = PidinStackParse(pcPath);

    if( !ppist )
    {
      return NULL;
    }

    phsle = PidinStackLookupTopSymbol(ppist);

    if( !phsle )
    {
      return NULL;
    }

  }
  else if( iSelect & TRAVERSAL_SELECT_GENERATORS )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_CONTEXTS;


    ppist = PidinStackParse(pcPath);

    if( !ppist )
    {
      return NULL;
    }

    phsle = PidinStackLookupTopSymbol(ppist);

    if( !phsle )
    {
      return NULL;
    }

  }
  else if( iSelect & TRAVERSAL_SELECT_PROJECTIONS )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_CONTEXTS | TRAVERSAL_INFO_TYPES;
    pti->iFlagsTraversal = CHILDREN_TRAVERSAL_FIXED_RETURN;
    pti->iTraversalResult = TSTR_PROCESSOR_SUCCESS;


    ppist = PidinStackParse(pcPath);

    if( !ppist )
    {
      return NULL;
    }

    phsle = PidinStackLookupTopSymbol(ppist);

    if( !phsle )
    {
      return NULL;
    }

  }
  else if( iSelect & TRAVERSAL_SELECT_RECIEVERS )
  {

    pti->iFlagsInfo |= TRAVERSAL_INFO_CONTEXTS;


    ppist = PidinStackParse(pcPath);

    if( !ppist )
    {
      return NULL;
    }

    phsle = PidinStackLookupTopSymbol(ppist);

    if( !phsle )
    {
      return NULL;
    }

  }
  else if( iSelect & TRAVERSAL_SELECT_WILDCARD )
  {
    // Wildcard will just grab it all by default
    pti->iFlagsInfo = TRAVERSAL_INFO_NAMES | TRAVERSAL_INFO_TYPES
      | TRAVERSAL_INFO_COORDS_LOCAL | TRAVERSAL_INFO_COORDS_ABSOLUTE
      | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT | TRAVERSAL_INFO_CONTEXTS;
  }
  //----------------------------------------------------------------------------
  // End setting traversal flags
  //----------------------------------------------------------------------------
  


  //----------------------------------------------------------------------------
  // This section is for setting the treespace traversal.
  // Different functions are used for different types.
  //----------------------------------------------------------------------------
  if( iSelect & TRAVERSAL_SELECT_CHILDREN )
  {

    ptstr = TstrNew(ppist,
		   NULL,
		   NULL,
		   TraversalInfoCollectorPostProcessor,
		   (void *)pti,
		   NULL,
		   NULL);

    iSuccess = TstrGo(ptstr,phsle);

    TstrDelete(ptstr);

  }
  else if( iSelect & TRAVERSAL_SELECT_COORDINATES )
  {
    // Need to set a bolevelselection struct
    bls.pvUserdata = NULL;
    bls.iMode = iMode;
    bls.iLevel = iLevel;

    iSuccess = SymbolTraverseBioLevels(phsle,
				       ppist,
				       &bls,
				       TraversalInfoCollectorPostProcessor,
				       NULL,
				       (void *)pti);    


  }
  else if( iSelect & TRAVERSAL_SELECT_GENERATORS )
  {

    SymbolTraverseSpikeGenerators(phsle,
				  ppist,
				  TraversalInfoCollectorPostProcessor,
				  NULL,
				  (void *)pti);

  }
  else if( iSelect & TRAVERSAL_SELECT_PROJECTIONS )
  {


    ptstr = TstrNew(ppist,
		    SymbolProjectionSelector,
		    NULL,
		    TraversalInfoCollectorPostProcessor,
		    (void *)pti,
		    NULL,
		    NULL);


    iSuccess = TstrGo(ptstr,phsle);

  }
  else if( iSelect & TRAVERSAL_SELECT_RECIEVERS )
  {

    iSelect = SymbolTraverseSpikeReceivers(phsle,
					   ppist,
					   TraversalInfoCollectorPostProcessor,
					   NULL,
					   (void *)pti);

  }
  else if( iSelect & TRAVERSAL_SELECT_WILDCARD )
  {

    phsle = NULL;

    ppist = PidinStackParse(pcPath);

    pidin = PidinStackElementPidin(ppist, 0);

    if (!pidin)
    {

      return NULL;

    }

    //- Condition if the wildcard is namespaced
    if (PidinStackIsNamespaced(ppist))
    {

      pif = SymbolsLookupNameSpace(pneuro->psym, ppist);

      if (!pif)
      {

	return NULL;

      }

      prootNamespace = ImportedFileGetRootSymbol(pif);

      //- set variables for traversal

      phsleTraversal = &prootNamespace->hsle;
      ppistTraversal = PidinStackDuplicate(ppist);

      //- convert full context to one with only namespaces

      if (PidinStackNumberOfEntries(ppistTraversal))
      {
	struct symtab_IdentifierIndex *pidinTraversal
	  = PidinStackTop(ppistTraversal);

	//- pop all elements that are part of the wildcard

	while (pidinTraversal && !IdinIsNamespaced(pidinTraversal))
	{
	  PidinStackPop(ppistTraversal);

	  pidinTraversal
	    = PidinStackTop(ppistTraversal);
	}
      }


    } //- End namespace parse
    else
    {

      ppistRoot = PidinStackCalloc();

      if (!ppistRoot)
      {

	PidinStackFree(ppist);

	return NULL;
      }

      PidinStackSetRooted(ppistRoot);

      phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

      if( !phsleRoot )
      {

	PidinStackFree(ppist);

	PidinStackFree(ppistRoot);

	return NULL;

      }

      phsleTraversal = phsleRoot;
      ppistTraversal = ppistRoot;

    }

    if( phsleTraversal )
    {

      iSuccess = SymbolTraverseWildcard(phsleRoot,
					ppistRoot,
					ppist,
					TraversalInfoCollectorPostProcessor,
					NULL,
					(void*)pti);
      
      PidinStackFree(ppistTraversal);


      if( iSuccess != 1 )
      {
	return NULL;
      }

    }
    else
    {
      // No model loaded
      return NULL;
      
    }

    

  }
  //----------------------------------------------------------------------------
  // End Treespace traversal 
  //----------------------------------------------------------------------------

  PidinStackFree(ppist);

  return pti;

}




