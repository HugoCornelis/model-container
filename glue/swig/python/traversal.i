/* -*- c -*- */

/**********************************************************
python list methods from http://www.swig.org/Doc1.3/Python.html


PyObject *PyList_New(int size);
int       PyList_Size(PyObject *list);
PyObject *PyList_GetItem(PyObject *list, int i);
int       PyList_SetItem(PyObject *list, int i, PyObject *item);
int       PyList_Insert(PyObject *list, int i, PyObject *item);
int       PyList_Append(PyObject *list, PyObject *item);
PyObject *PyList_GetSlice(PyObject *list, int i, int j);
int       PyList_SetSlice(PyObject *list, int i, int , PyObject *list2);
int       PyList_Sort(PyObject *list);
int       PyList_Reverse(PyObject *list);
PyObject *PyList_AsTuple(PyObject *list);
int       PyList_Check(PyObject *);

Link to the PyString API functions: http://docs.python.org/c-api/string.html
***********************************************************/

%{
//------------------------- Start Neurospaces includes -------------------------
#include "neurospaces/traversalinfo.h"
//------------------------- End Neurospaces includes ---------------------------


#include <Python.h>
%}


%inline %{

//------------------------------------------ Prototypes -------------------------------
PyObject * ChildSymbolsToDictList(char *pcPath);

static PyObject * CoordinateTuple(double dX, double dY, double dZ);

PyObject * ChildSymbolsToList(char *pcPath);

PyObject * ChildTypedSymbolsToList(char *pcPath);

//PyObject * GetVisibleCoordinates(char *pcPath, int iLevel, int iMode);

PyObject * CoordinatesToDictList(char *pcPath, int iLevel, int iMode);

PyObject * AllChildSymbolsToList();
//------------------------------------------ End Prototypes ---------------------------


//------------------------------------------------------------------------------
/*
 * Returns a dict of coodinates in the form ['key'](x, y z)
 * Attempts cleanup of objects in the event of an error.
 */
static PyObject * CoordinateDict(char *pcKey, double dX, double dY, double dZ)
{

  PyObject * ppoDict = NULL;
  PyObject * ppoTuple = NULL;

  if(!pcKey)
  {
    return NULL;
  }

  ppoDict = PyDict_New();


  if( !ppoDict )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate coordinate dict");
    return NULL;
  } 
  
  ppoTuple = CoordinateTuple(dX, dY, dZ);

  if( !ppoTuple )
  {
    PyDict_Clear(ppoDict);
    return NULL;
  }
  
  PyDict_SetItemString(ppoDict, pcKey, ppoTuple);

  if( !PyDict_Check(ppoDict) )
  {
    PyDict_Clear(ppoDict);

    return NULL;
  }

}

//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
/*
 * Returns a tuple of coodinates in the form (x, y z)
 * Attempts cleanup of objects in the event of an error.
 */
static PyObject * CoordinateTuple(double dX, double dY, double dZ)
{

  PyObject * ppoTuple = PyTuple_New(3);
  
  if( !ppoTuple )
  {
    return NULL;
  }

  PyObject * ppoX = NULL;
  PyObject * ppoY = NULL;
  PyObject * ppoZ = NULL;

  ppoX = PyFloat_FromDouble(dX);

  if( !PyFloat_Check(ppoX) )
  {
    free(ppoX);
    return NULL;
  }

  ppoY = PyFloat_FromDouble(dY);

  if( !PyFloat_Check(ppoY) )
  {
    free(ppoX);
    free(ppoY);
    return NULL;
  }

  ppoZ = PyFloat_FromDouble(dZ);
  
  if( !PyFloat_Check(ppoZ) )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  ppoTuple = PyTuple_New(3);

  if( !ppoTuple )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  PyTuple_SetItem(ppoTuple, 0, ppoX);
  PyTuple_SetItem(ppoTuple, 1, ppoY);
  PyTuple_SetItem(ppoTuple, 2, ppoZ);

  if( !PyTuple_Check(ppoTuple) )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  return ppoTuple;

}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * ChildSymbolsToDictList(char *pcPath)
{

  int i;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  struct traversal_info * pti;
  double dX, dY, dZ;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate dict list");
    return NULL;
  }

  // Perform a child traversal along the given path
  pti = SelectTraversal(pcPath, 
			TRAVERSAL_SELECT_CHILDREN, 
			0, 0);

  if( !pti )
  {
    PyErr_SetString(PyExc_Exception,"traversal can't be performed");
    return NULL;
  }

  // Loop through all found children and append them to the list

  if (pti->iChildren)
  {

    for (i = 0; i < pti->iChildren; i++)
    {
      
      ppoTmpDict = PyDict_New();

      if( !ppoTmpDict )
      {
	PyErr_SetString(PyExc_MemoryError,"can't allocate dict for child");
	return NULL;
      }
      
      // First we set the name to the dict
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(pti->ppcNames[i]);

      if (!PyString_Check(ppoTmpName))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoList);
	return NULL;

      }

      PyDict_SetItemString(ppoTmpDict, "name", ppoTmpName);


      ppoTmpType = PyString_FromString(pti->ppcTypes[i]);

      PyDict_SetItemString(ppoTmpDict, "type", ppoTmpType);

      
      // Add the different levels of coordinates here
      // Should be set as:
      //               ['coordinate']['local']
      //               ['coordinate']['absolute']
      //               ['coordinate']['absolute_parent']	
      ppoTmpSubDict = PyDict_New();
	  
      if(!ppoTmpSubDict)
      {
	PyErr_SetString(PyExc_MemoryError,
			"can't allocate dict object for coordinates");
	return NULL;
      }

      // Short circuiting to make sure it doesn't crash
      if( pti->ppD3CoordsLocal && 
	  pti->ppD3CoordsLocal[i] && pti->ppD3CoordsLocal[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsLocal[i]->dx,
				      pti->ppD3CoordsLocal[i]->dy,
				      pti->ppD3CoordsLocal[i]->dz);
	  
	PyDict_SetItemString(ppoTmpSubDict, "local", ppoTmpCoord);

	ppoTmpCoord = NULL;

      }

      if( pti->ppD3CoordsAbsolute && 
	  pti->ppD3CoordsAbsolute[i] && pti->ppD3CoordsAbsolute[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsolute[i]->dx,
				      pti->ppD3CoordsAbsolute[i]->dy,
				      pti->ppD3CoordsAbsolute[i]->dz);

	PyDict_SetItemString(ppoTmpSubDict, "absolute", ppoTmpCoord);
	  
	ppoTmpCoord = NULL;

      }

      if( pti->ppD3CoordsAbsoluteParent && 
	  pti->ppD3CoordsAbsoluteParent[i] && 
	  pti->ppD3CoordsAbsoluteParent[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsoluteParent[i]->dx,
				      pti->ppD3CoordsAbsoluteParent[i]->dy,
				      pti->ppD3CoordsAbsoluteParent[i]->dz);

	PyDict_SetItemString(ppoTmpSubDict, "parent", ppoTmpCoord);

	ppoTmpCoord = NULL;
      }

      // Place all coordinates from the dict into the top level dict

      PyDict_SetItemString(ppoTmpDict, "coordinate", ppoTmpSubDict);

    }

    // After converting the string to a python string we append 
    PyList_Append(ppoList, ppoTmpDict);

  }

  //- free allocated memory

  TraversalInfoFree(pti);

  free(pti);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid dict list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}
//------------------------------------------------------------------------------







//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * AllChildSymbolsToList()
{

  int i;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  struct traversal_info * pti;
  double dX, dY, dZ;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate dict list");
    return NULL;
  }

  // Perform a child traversal along the given path
  pti = SelectTraversal("**", 
			TRAVERSAL_SELECT_WILDCARD, 
			0, 0);

  if( !pti )
  {
    PyErr_SetString(PyExc_Exception,"wildcard traversal can't be performed");
    return NULL;
  }

  // Loop through all found children and append them to the list

  if (pti->iChildren)
  {

    for (i = 0; i < pti->iChildren; i++)
    {
      
      ppoTmpDict = PyDict_New();

      if( !ppoTmpDict )
      {
	PyErr_SetString(PyExc_MemoryError,"can't allocate dict for child");
	return NULL;
      }
      
      // First we set the name to the dict
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(pti->ppcNames[i]);

      if (!PyString_Check(ppoTmpName))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoList);
	return NULL;

      }

      PyDict_SetItemString(ppoTmpDict, "name", ppoTmpName);


      ppoTmpType = PyString_FromString(pti->ppcTypes[i]);

      PyDict_SetItemString(ppoTmpDict, "type", ppoTmpType);

      
      // Add the different levels of coordinates here
      // Should be set as:
      //               ['coordinate']['local']
      //               ['coordinate']['absolute']
      //               ['coordinate']['absolute_parent']	
      ppoTmpSubDict = PyDict_New();
	  
      if(!ppoTmpSubDict)
      {
	PyErr_SetString(PyExc_MemoryError,
			"can't allocate dict object for coordinates");
	return NULL;
      }

      // Short circuiting to make sure it doesn't crash
      if( pti->ppD3CoordsLocal && 
	  pti->ppD3CoordsLocal[i] && pti->ppD3CoordsLocal[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsLocal[i]->dx,
				      pti->ppD3CoordsLocal[i]->dy,
				      pti->ppD3CoordsLocal[i]->dz);
	  
	PyDict_SetItemString(ppoTmpSubDict, "local", ppoTmpCoord);

	ppoTmpCoord = NULL;

      }

      if( pti->ppD3CoordsAbsolute && 
	  pti->ppD3CoordsAbsolute[i] && pti->ppD3CoordsAbsolute[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsolute[i]->dx,
				      pti->ppD3CoordsAbsolute[i]->dy,
				      pti->ppD3CoordsAbsolute[i]->dz);

	PyDict_SetItemString(ppoTmpSubDict, "absolute", ppoTmpCoord);
	  
	ppoTmpCoord = NULL;

      }

      if( pti->ppD3CoordsAbsoluteParent && 
	  pti->ppD3CoordsAbsoluteParent[i] && 
	  pti->ppD3CoordsAbsoluteParent[i]->dx != DBL_MAX )
      {

	ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsoluteParent[i]->dx,
				      pti->ppD3CoordsAbsoluteParent[i]->dy,
				      pti->ppD3CoordsAbsoluteParent[i]->dz);

	PyDict_SetItemString(ppoTmpSubDict, "parent", ppoTmpCoord);

	ppoTmpCoord = NULL;
      }

      // Place all coordinates from the dict into the top level dict

      PyDict_SetItemString(ppoTmpDict, "coordinate", ppoTmpSubDict);

    }

    // After converting the string to a python string we append 
    PyList_Append(ppoList, ppoTmpDict);

  }

  //- free allocated memory

  TraversalInfoFree(pti);

  free(pti);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid dict list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}
//------------------------------------------------------------------------------



/* PyObject * GetVisibleCoordinates(char *pcPath, int iLevel, int iMode) */
/* { */

/*   int iContext; */
/*   struct PidinStack * ppist; */
/*   PyObject * ppoList = NULL; */

/*   struct PidinStack *ppistRoot = PidinStackParse("/"); */

/*   struct symtab_HSolveListElement *phsleRoot = PidinStackLookupTopSymbol(ppistRoot); */

/*   if (!phsleRoot) */
/*   { */
/*     return(NULL); */
/*   } */

/*   //- get context */

/*   ppist = PidinStackParse(pcPath); */

/*   iContext = PidinStackToSerial(ppist); */

/*   struct PidinStack *ppistContext */
/*     = SymbolPrincipalSerial2Context(phsleRoot,ppistRoot,iContext); */
  
/*   if(!ppistContext) */
/*   { */

/*     PyErr_SetString(PyExc_TypeError, "Can't get principal context"); */

/*     return NULL; */

/*   } */

/*   //- get symbol under consideration */

/*   struct symtab_HSolveListElement *phsleContext = PidinStackLookupTopSymbol(ppistContext); */

/*   if (!phsleContext) */
/*   { */
/*     PidinStackFree(ppistRoot); */

/*     PidinStackFree(ppist); */
    
/*     ppistRoot = NULL; */

/*     PidinStackFree(ppistContext); */

/*     ppistContext = NULL; */

/*     printf("Unable to find this symbol, lookup failed (internal error).\n"); */

/*     return NULL; */
/*   } */

/*   char pcContext[1000]; */

/*   PidinStackString(ppistContext,pcContext,1000); */

/*   printf("Getting children from %s\n", pcContext); */

/*   ppoList = CoordinatesToDictList(phsleContext, ppistContext, iLevel, iMode); */

/*   //- free allocated memory */

/*   PidinStackFree(ppistRoot); */

/*   PidinStackFree(ppistContext); */

/*   PidinStackFree(ppist); */
  
/*   return ppoList; */

/* } */


//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * CoordinatesToDictList(char *pcPath, int iLevel, int iMode)
{

  int i;
  struct traversal_info * pti = NULL;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDia = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpSerial = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  double dX, dY, dZ;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate coordinate dict list");
    return NULL;
  }


  // Perform a child traversal along the given path
  pti = SelectTraversal(pcPath, 
			TRAVERSAL_SELECT_COORDINATES, 
			iLevel, iMode);

  if( !pti )
  {
    PyErr_SetString(PyExc_Exception,"traversal can't be performed");
    return NULL;
  }

  // Loop through all found children and append them to the list

  if (pti->iChildren)
  {

    for (i = 0; i < pti->iChildren; i++)
    {
      

      if (strcmp(pti->ppcTypes[i], "segmen") == 0
	  || strcmp(pti->ppcTypes[i], "cell  ") == 0
	  || strcmp(pti->ppcTypes[i], "contou") == 0
	  || strcmp(pti->ppcTypes[i], "e_m_co") == 0
	  || strcmp(pti->ppcTypes[i], "fiber ") == 0
	  || strcmp(pti->ppcTypes[i], "popula") == 0
	  || strcmp(pti->ppcTypes[i], "networ") == 0
	  || strcmp(pti->ppcTypes[i], "random") == 0)
      {

	ppoTmpDict = PyDict_New();

	if( !ppoTmpDict )
	{
	  PyErr_SetString(PyExc_MemoryError,"can't allocate dict for child");
	  return NULL;
	}
      
      
	// Sets the name string ------------------------------------------------
	ppoTmpName = PyString_FromString(pti->ppcNames[i]);

	if (!PyString_Check(ppoTmpName))
	{

	  PyErr_SetString(PyExc_TypeError,"\"name\" dict key must contain strings");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "name", ppoTmpName);
	//- End name set --------------------------------------------------------


	// Sets the serial value -----------------------------------------------
	ppoTmpSerial = PyInt_FromLong(pti->piSerials[i]);

	if (!PyString_Check(ppoTmpSerial))
	{

	  PyErr_SetString(PyExc_TypeError,"\"serial\" dict key must contain an integer");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "serial", ppoTmpSerial);
	//- End setting the serial value ---------------------------------------

	
	// Sets the Dia value --------------------------------------------------
	ppoTmpDia = PyFloat_FromDouble(pti->pdDia[i]);

	if (!PyFloat_Check(ppoTmpDia))
	{

	  PyErr_SetString(PyExc_TypeError,"\"dia\" dict key must contain a double");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "dia", ppoTmpDia);
	//- End setting dia value ----------------------------------------------


	// Add the type string here --------------------------------------------
	ppoTmpType = PyString_FromString(pti->ppcTypes[i]);
	
	PyDict_SetItemString(ppoTmpDict, "type", ppoTmpType);
	//- End setting type value ---------------------------------------------


	// Add the different levels of coordinates here
	// Should be set as:
	//               ['coordinate']['local']
	//               ['coordinate']['absolute']
	//               ['coordinate']['absolute_parent']
	
	ppoTmpSubDict = PyDict_New();
	  
	if(!ppoTmpSubDict)
	{
	  PyErr_SetString(PyExc_MemoryError,
			  "can't allocate dict object for coordinates");
	  return NULL;
	}

	// Short circuiting to make sure it doesn't crash
	if( pti->ppD3CoordsLocal && pti->ppD3CoordsLocal[i] && 
	    pti->ppD3CoordsLocal[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsLocal[i]->dx,
					pti->ppD3CoordsLocal[i]->dy,
					pti->ppD3CoordsLocal[i]->dz);
	  
	  PyDict_SetItemString(ppoTmpSubDict, "local", ppoTmpCoord);

	  ppoTmpCoord = NULL;

	}

	if( pti->ppD3CoordsAbsolute && pti->ppD3CoordsAbsolute[i] && 
	    pti->ppD3CoordsAbsolute[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsolute[i]->dx,
					pti->ppD3CoordsAbsolute[i]->dy,
					pti->ppD3CoordsAbsolute[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "absolute", ppoTmpCoord);
	    
	  ppoTmpCoord = NULL;

	}

	if( pti->ppD3CoordsAbsoluteParent && pti->ppD3CoordsAbsoluteParent[i] && 
	    pti->ppD3CoordsAbsoluteParent[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(pti->ppD3CoordsAbsoluteParent[i]->dx,
					pti->ppD3CoordsAbsoluteParent[i]->dy,
					pti->ppD3CoordsAbsoluteParent[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "parent", ppoTmpCoord);
	    
	  ppoTmpCoord = NULL;
	}

	// Place all coordinates from the dict into the top level dict

	PyDict_SetItemString(ppoTmpDict, "coordinate", ppoTmpSubDict);
	//- End the coordinate setting -----------------------------------------


	// After constructing the dict we append 
	PyList_Append(ppoList, ppoTmpDict);


      } // End visible if check

    } // End child loop

  }

  //- free allocated memory

  TraversalInfoFree(pti);

  free(pti);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid dict list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}
//------------------------------------------------------------------------------



//-----------------------------------------------------------------------------
/*
 * \fun PyObject * ChildSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
 * \param phsle A pointer to an hsolve list element  
 * \param ppist A pointer to an identifier context
 * \returns A pointer to a python list object of type string.
 *
 * Performs a traversal and returns a list of all symbols that are children to the given
 * symbol+context. 
 */
PyObject * ChildSymbolsToList(char *pcPath)
{

  int i;
  struct traversal_info * pti = NULL;
  PyObject * ppoSymbolList = NULL;
  PyObject * ppoTmpName = NULL;


  //- Start out with an empty list

  ppoSymbolList = PyList_New(0);

  if( !ppoSymbolList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate symbol list");
    return NULL;
  }



  // Perform a child traversal along the given path
  pti = SelectTraversal(pcPath, 
			TRAVERSAL_SELECT_CHILDREN, 
			0, 0);

  if( !pti )
  {
    PyErr_SetString(PyExc_Exception,"traversal can't be performed");
    return NULL;
  }

  // Loop through all found children and append them to the list

  if (pti->iChildren)
  {

    for (i = 0; i < pti->iChildren; i++)
    {
      
      if ( !pti->ppcNames[i] )
	continue;
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(pti->ppcNames[i]);

      if (!PyString_Check(ppoTmpName))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoSymbolList);
	return NULL;

      }

      // After converting the string to a python string we append 
      PyList_Append(ppoSymbolList, ppoTmpName);

    }
  }

  //- free allocated memory

  TraversalInfoFree(pti);

  free(pti);

  if( !PyList_Check(ppoSymbolList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid list was generated from the model container");

  }

  return ppoSymbolList;
}

//-----------------------------------------------------------------------------





//-----------------------------------------------------------------------------
/*
 * \fun PyObject * ChildTypedSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
 * \param phsle A pointer to an hsolve list element  
 * \param ppist A pointer to an identifier context
 * \returns A pointer to a python list object containing python tuples (name, type)
 *
 * Performs a traversal and returns a list of all symbols that are children to the given
 * symbol+context with the approrpiate type.
 */
PyObject * ChildTypedSymbolsToList(char *pcPath)
{

  int i;
  struct traversal_info * pti = NULL;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpType = NULL;
  PyObject * ppoTmpTuple = NULL;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate symbol list");
    return NULL;
  }


  // Perform a child traversal along the given path
  pti = SelectTraversal(pcPath, 
			TRAVERSAL_SELECT_CHILDREN, 
			0, 0);

  if( !pti )
  {
    PyErr_SetString(PyExc_Exception,"traversal can't be performed");
    return NULL;
  }

  // Loop through all found children and append them to the list

  if (pti->iChildren)
  {

    for (i = 0; i < pti->iChildren; i++)
    {
      
      if ( !pti->ppcNames[i] || !pti->ppcTypes[i] )
	continue; // This might not be a good idea, no error reporting
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(pti->ppcNames[i]);
      ppoTmpType = PyString_FromString(pti->ppcTypes[i]);
      

      if (!PyString_Check(ppoTmpName) || !PyString_Check(ppoTmpType))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoList);
	return NULL;

      }


      //
      // Creates a tuple in the form (Name, Type)
      //
      ppoTmpTuple = PyTuple_New(2);

      if( !ppoTmpTuple )
      {
	PyErr_SetString(PyExc_MemoryError,"can't allocate a new Python tuple");
	return NULL;
      }

      PyTuple_SetItem(ppoTmpTuple, 0, ppoTmpName);
      PyTuple_SetItem(ppoTmpTuple, 1, ppoTmpType);

      if( !PyTuple_Check(ppoTmpTuple) )
      {

	PyErr_SetString(PyExc_TypeError,"error creating PyTuple (Name, Type)");
	free(ppoList);

	return NULL;
      }

      // After converting the string to a python string we append 
      PyList_Append(ppoList, ppoTmpTuple);

    }
  }

  //- free allocated memory

  TraversalInfoFree(pti);

  free(pti);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}

//-----------------------------------------------------------------------------


%}





