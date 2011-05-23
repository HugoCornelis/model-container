//*********************************************************
/*!
 * \file selecttraversal.c
 */
//*********************************************************

#include "neurospaces/traversalinfo.h"
#include "neurospaces/treespacetraversal.h"

#include "hierarchy/output/symbols/all_callees_headers.h"

//----------------------- static prototypes ------------------------------------
static struct traversal_info * TraversalInfoCalloc();

//-------------------- end static prototypes -----------------------------------





/*!
* \returns A traversal info struct with traversal data, null on error or no operation
*
* \param pcPath The path to the element to start traversal at. 
* \param iSelect The traversal mode
* \param iMode The mode to use for biolevel traversals.
* \param iLevel The depth of level to traverse in biolevel traversals.
*
* Performs a traversal starting from the given path. If a wildcard traversal is selected
* then the path must contain a wildcard. If it is a null pointer then "/**" is used.
*/
struct traversal_info * SelectTraversal(char *pcPath, int iSelect, int iMode, int iLevel)
{
  int iSuccess = 0;
  struct traversal_info *pti = NULL;
  struct BiolevelSelection bls;
  struct PidinStack *ppist = NULL;
  struct PidinStack *ppistRoot = NULL; 
  struct symtab_HSolveListElement *phsle = NULL;
  struct symtab_HSolveListElement *phsleRoot = NULL;
 struct TreespaceTraversal *ptstr;
  int iTraversalFlags = 0;


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

  }
  else if( iSelect & TRAVERSAL_SELECT_COORDINATES )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_NAMES | TRAVERSAL_INFO_TYPES
      | TRAVERSAL_INFO_COORDS_LOCAL | TRAVERSAL_INFO_COORDS_ABSOLUTE
      | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT;

    pti->iFlagsTraversal = (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? CHILDREN_TRAVERSAL_FIXED_RETURN : 0;
    pti->iTraversalResult = (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? TSTR_PROCESSOR_SUCCESS : 0;


  }
  else if( iSelect & TRAVERSAL_SELECT_GENERATORS )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_CONTEXTS;

  }
  else if( iSelect & TRAVERSAL_SELECT_PROJECTIONS )
  {

    pti->iFlagsInfo = TRAVERSAL_INFO_CONTEXTS | TRAVERSAL_INFO_TYPES;
    pti->iFlagsTraversal = CHILDREN_TRAVERSAL_FIXED_RETURN;
    pti->iTraversalResult = TSTR_PROCESSOR_SUCCESS;

  }
  else if( iSelect & TRAVERSAL_SELECT_RECIEVERS )
  {

    pti->iFlagsInfo |= TRAVERSAL_INFO_CONTEXTS;

  }
  else if( iSelect & TRAVERSAL_SELECT_WILDCARD )
  {
    // Wildcard will just grab it all by default
    pti->iFlagsInfo = TRAVERSAL_INFO_NAMES | TRAVERSAL_INFO_TYPES
      | TRAVERSAL_INFO_COORDS_LOCAL | TRAVERSAL_INFO_COORDS_ABSOLUTE
      | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT;
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
		   TraversalInfoCollectorProcessor,
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
				       TraversalInfoCollectorProcessor,
				       NULL,
				       (void *)pti);    


  }
  else if( iSelect & TRAVERSAL_SELECT_GENERATORS )
  {

    SymbolTraverseSpikeGenerators(phsle,
				  ppist,
				  TraversalInfoCollectorProcessor,
				  NULL,
				  (void *)pti);

  }
  else if( iSelect & TRAVERSAL_SELECT_PROJECTIONS )
  {


    ptstr = TstrNew(ppist,
		    SymbolProjectionSelector,
		    NULL,
		    TraversalInfoCollectorProcessor,
		    (void *)pti,
		    NULL,
		    NULL);


    iSuccess = TstrGo(ptstr,phsle);

  }
  else if( iSelect & TRAVERSAL_SELECT_RECIEVERS )
  {

    iSelect = SymbolTraverseSpikeReceivers(phsle,
					   ppist,
					   TraversalInfoCollectorProcessor,
					   NULL,
					   (void *)pti);

  }
  else if( iSelect & TRAVERSAL_SELECT_WILDCARD )
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

    ptstr = TstrNew(ppistRoot, 
		    WildcardSelector,
		    (void *)ppist, //- This should be our wildcard
		    TraversalInfoCollectorProcessor,
		    (void*)pti,
		    NULL,
		    NULL);


    iSuccess = TstrGo(ptstr,phsle);

    PidinStackFree(ppist);

    PidinStackFree(ppistRoot);

    TstrDelete(ptstr);

  }
  //----------------------------------------------------------------------------
  // End Treespace traversal 
  //----------------------------------------------------------------------------

  PidinStackFree(ppist);

  return pti;

}





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
