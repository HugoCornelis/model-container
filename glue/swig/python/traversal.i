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

int SerialToString(char *pcName, struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iSerial);

static PyObject * CoordinateTuple(double dX, double dY, double dZ);

PyObject * ChildSymbolsToDictList(char *pcPath);

PyObject * ChildSymbolsToList(char *pcPath);

PyObject * ChildTypedSymbolsToList(char *pcPath);

//PyObject * GetVisibleCoordinates(char *pcPath, int iLevel, int iMode);

PyObject * CoordinatesToList(char *pcPath, struct Neurospaces *pneuro);

PyObject * AllChildSymbolsToList(struct Neurospaces *pneuro);
//------------------------------------------ End Prototypes ---------------------------



//------------------------------------------------------------------------------
/*
 * Sets a string in pcName with the full pathname of a serial
 */
int SerialToString(char *pcName, struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iSerial)
{
  struct PidinStack *ppistSerial = NULL;

  if( !phsle || !ppist || iSerial < 0 )
  {

    return 0;

  }

  ppistSerial = SymbolPrincipalSerial2Context(phsle, ppist, iSerial);

  if( !ppistSerial )
  {
    
    return 0;

  }


  PidinStackString(ppistSerial, pcName, 1024);

  PidinStackFree(ppistSerial);

  return 1;

}
//------------------------------------------------------------------------------



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
  char pcName[1024];
  struct PidinStack *ppistRoot = NULL;
  struct symtab_HSolveListElement *phsleRoot = NULL;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  struct traversal_info * pti;
  double dX, dY, dZ;

  //- Get the root context information for serial to name resolution
  ppistRoot = PidinStackCalloc();

  if (!ppistRoot)
  {

    return NULL;
  }

  PidinStackSetRooted(ppistRoot);

  phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

  if( !phsleRoot )
  {

    PidinStackFree(ppistRoot);

    return NULL;

  }


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
			0, 0, NULL);

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
PyObject * AllChildSymbolsToList(struct Neurospaces *pneuro)
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
  pti = SelectTraversal("/**", 
			TRAVERSAL_SELECT_WILDCARD, 
			0, 0, pneuro);

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





//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * CoordinatesToList(char *pcPath, struct Neurospaces *pneuro)
{

  int i;

  char pcName[1024];
  struct PidinStack *ppistRoot = NULL;
  struct symtab_HSolveListElement *phsleRoot = NULL;
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


  //- Get the root context information for serial to name resolution
  ppistRoot = PidinStackCalloc();

  if (!ppistRoot)
  {

    return NULL;
  }

  PidinStackSetRooted(ppistRoot);

  phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

  if( !phsleRoot )
  {

    PidinStackFree(ppistRoot);

    return NULL;

  }

  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate coordinate dict list");
    return NULL;
  }


  // Perform a child traversal along the given path
  pti = SelectTraversal(pcPath, 
			TRAVERSAL_SELECT_WILDCARD, 
			2, 1,
			pneuro);

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
	
	SerialToString(pcName, phsleRoot, ppistRoot, pti->piSerials[i]);

	ppoTmpName = PyString_FromString(pcName);
	//	ppoTmpName = PyString_FromString(pti->ppcNames[i]);

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
   
	if (!PyInt_Check(ppoTmpSerial))
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

  PidinStackFree(ppistRoot);

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
			0, 0, NULL);

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
			0, 0, NULL);

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





