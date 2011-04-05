"""!
@package nmc

The nmc python module is a Pythonic abstraction over the
Neurospaces Model Container. It's purpose is to allow
scripting functionality to the Model Container via Python,
while providing a usuable API that does not require knowledge
of each data structure that the Model Container employs.

"""

__author__ = 'Mando Rodriguez'
__credits__ = []
__license__ = "GPL"
__version__ = "0.1"
__status__ = "Development"

import os
import pdb
import sys

try:

    import nmc_base

except ImportError, e:
    sys.exit("Could not import compiled SWIG nmc_base library: %s" % e)



try:

    import symbols

except ImportError, e:
    sys.exit("Could not import the model container symbols module: %s" % e)



#************************* Begin ModelContainer **************************
class ModelContainer:
    """
    @class ModelContainer The Neurospaces Model Container

    The ModelContainer class provides functionality present in
    the model container with low level data structs. The entirety
    of the object centers around nmc_root, the model container
    data structure and it's neccessary functions.
    """

#---------------------------------------------------------------------------

    def __init__(self, nmc=None):
        """!
        @brief ModelContainer constructor

        @param nmc An existing ModelContainer or Neurospaces object.
        """

        if not self.CheckEnvironment():

            raise errors.LibraryPathError()

        
        # this is the "low level" model container object.
        self._nmc_core = None

        if nmc == None:

            # Here we construct a new root model container 
            self._nmc_core = nmc_base.NeurospacesNew()

            # We need to load a an empty model to prevent it from
            # giving an error when looking up the root
            self.Read("utilities/empty_model.ndf")
            
        else:

            # isinstance typing should be ok here since
            # we're testing for a C class struct and a class.
            # - duck type?
            if isinstance(nmc, ModelContainer):

                self._nmc_core = nmc.GetRootModelContainer()

            elif isinstance(nmc, nmc_base.Neurospaces):
                
                # Recycling an existing ModelContainer for the python interface
                self._nmc_core = nmc

            else:

                errormsg = "Arg is of type %s, expected class type \
                ModelContainer or Neurospaces." % (nmc.__class__)
                
                raise TypeError(errormsg)
            
            pif = self._nmc_core.pifRootImport

            nmc_base.ImportedFileSetRootImport(pif)

#---------------------------------------------------------------------------

    def CheckEnvironment(self):

        env = ['NEUROSPACES_NMC_USER_MODELS', 'NEUROSPACES_NMC_PROJECT_MODELS',
               'NEUROSPACES_NMC_SYSTEM_MODELS', 'NEUROSPACES_NMC_MODELS']

        library_path = ""

        library_exists = False
        
        for e in env:

            try:
                
                library_path = os.environ[e]

            except KeyError:

                continue

            if os.path.exists(library_path):
                        
                library_exists = True 


        return library_exists

            


#---------------------------------------------------------------------------

    def GetCore(self):
        """!
        @brief Returns the neurospaces core data struct.
        """
        return self._nmc_core


#---------------------------------------------------------------------------

    def GetRootModelContainer(self):
        """!
        @brief Returns the base level object.

        Returns the \"Neurospaces\" core data object
        """
        return self._nmc_core

#---------------------------------------------------------------------------

    def GetParameter(self, path, parameter):
        """!
        @brief Returns a parameter value from the model container.
        @param path The path to a symbol in the model container
        @param parameter The parameter value to look up
        """
        ppist = nmc_base.PidinStackParse(path)

        phsle = nmc_base.PidinStackLookupTopSymbol(ppist)

        if phsle is None:

            return None

        value = nmc_base.SymbolParameterResolveValue(phsle, ppist, parameter)

        return value

#---------------------------------------------------------------------------

    def SetParameter(self, path, parameter, value):
        """!
        @brief Sets a parameter value to a symbol in the model container.

        Not complete, only sets doubles at the moment.
        """
        
        ppist = nmc_base.PidinStackParse(path)

        phsle = nmc_base.PidinStackLookupTopSymbol(ppist)

        if phsle is None:

            return None

        if isinstance(value, (int, long, float, complex)):
            
            nmc_base.SymbolSetParameterDouble(phsle, parameter, value)

        elif isinstance(value, str):

            pass

        else:

            raise Exception("Invalid parameter type")

#---------------------------------------------------------------------------


    def SetParameterConcept(self, path, parameter, value):
        """!
        @brief Sets parameters to a namespace

        So far only sets numbers. The only examples present set numbers.
        """

        set_command = "setparameterconcept %s %s %s %s" % (path, parameter,
                                                           "number", str(value))
        
        self.Query(set_command)

#---------------------------------------------------------------------------
    
    def Read(self, filename):
        """!
        @brief read an NDF model file
        """

        #if not os.path.isfile(filename):

            # Make my own exception? check for the ndf suffix?
         #   raise Exception("%s is not a valid file or does not exist" % (filename))
        
        result = nmc_base.NeurospacesRead(self._nmc_core, 2, [ "python", filename ] )

        # exception on bad result?


#---------------------------------------------------------------------------
    
    def ImportFile(self, filename):
        pass

#---------------------------------------------------------------------------

    def InsertSymbol(self, path, symbol):
        """!
        @brief Adds a symbol to the model container.
        @param path The path to add the symbol to
        @param symbol Symbol to add to the model container
        
        """
        context = nmc_base.PidinStackParse(path)
        
        top = nmc_base.PidinStackLookupTopSymbol(context)
        
        nmc_base.SymbolAddChild(top, symbol.GetCore())

#---------------------------------------------------------------------------

    def Lookup(self, name):
        pass


#---------------------------------------------------------------------------

    def CreateSegment(self, path):
        """
        
        """
        seg = symbols.Segment(path, self._nmc_core)

        # exception check?

        return seg

#---------------------------------------------------------------------------

    def CreateCompartment(self, path):
        """

        """
        return CreateSegment(path)


#---------------------------------------------------------------------------

    def CreateCell(self, path):

        cell = symbols.Cell(path)

        # exception check?

        return cell

#---------------------------------------------------------------------------

    def PrintParameter(self, path, parameter):
        """!
        @brief Sends print commands to the query handler.

        Will print the parameter at the given path. Accepts
        wildcards in the path.
        """
        command = "printparameter %s %s" % (path,parameter)

        self.Query(command)


#---------------------------------------------------------------------------

    def Query(self, command):
        """!
        @brief submit querymachine commands to the model container
        """
        nmc_base.QueryMachineHandle(self._nmc_core, command)

#---------------------------------------------------------------------------

    def GetSerial(self, path, field):
        """
        @brief A simple method for retrieving a serial
        """
        context = nmc_base.PidinStackParse(path)

        nmc_base.PidinStackLookupTopSymbol(context)

        serial = nmc_base.PidinStackToSerial(context)

        return serial

#---------------------------------------------------------------------------

    def ReadPython(self, filename):
        """!
        @brief read an NPY model file
        """
        
        if not os.path.isfile(filename):

            # Make my own exception? check for the ndf suffix?
            raise Exception("%s is not a valid file or does not exist" % (filename))
        
        execfile("/usr/local/neurospaces/models/library/" + filename)


#---------------------------------------------------------------------------

    def SetOutputFile(self,filename):

        self._output_file = filename

#*************************** End ModelContainer **************************









        

