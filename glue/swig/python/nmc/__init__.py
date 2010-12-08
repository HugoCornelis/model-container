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


try:

    import nmc_base

except ImportError:
    sys.exit("Could not import compiled SWIG nmc_base library: %s")


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
        
        # this is the "low level" model container object.
        self._nmc_root = None
        
        if nmc == None:

            # Here we construct a new root model container 
            self._nmc_root = nmc_base.NeurospacesNew()
            
        else:

            if isinstance(nmc,ModelContainer):

                self._nmc_root = nmc.GetRootModelContainer()

            elif isinstance(nmc,nmc_base.Neurospaces):
                
                # Recycling an existing ModelContainer for the python interface
                self._nmc_root = nmc

            else:

                errormsg = "Arg is of type %s, expected class type \
                ModelContainer or Neurospaces." % (nmc.__class__)
                
                raise TypeError(errormsg)
            
            pif = self._nmc_root.pifRootImport
            
            nmc_base.ImportedFileSetRootImport(pif)

#---------------------------------------------------------------------------

    def GetRootModelContainer(self):
        """!
        @brief Returns the base level object.

        Returns the \"Neurospaces\" core data object
        """
        return self._nmc_root

#---------------------------------------------------------------------------
    
    def Read(self, filename):
        """!
        @brief read an NDF model file
        """

        if not os.path.isfile(filename):

            # Make my own exception? check for the ndf suffix?
            raise Exception("%s is not a valid file or does not exist" % (filename))
        
        nmc_base.NeurospacesRead(self._nmc_root, 2, [ "python", filename ] )


#---------------------------------------------------------------------------
    
    def ImportFile(self, filename):
        pass

#---------------------------------------------------------------------------
    
    def insert(self, path, symbol):
        context = SwiggableNeurospaces.PidinStackParse(path)
        top = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
        SwiggableNeurospaces.SymbolAddChild(top, symbol.backend_object())

#---------------------------------------------------------------------------

    def Lookup(self, name):
        pass

#---------------------------------------------------------------------------

    def Query(self, command):
        """!
        @brief submit querymachine commands to the model container
        """
        nmc_base.QueryMachineHandle(self._nmc_root, command)


#---------------------------------------------------------------------------

    def read_python(self, filename):
        "read an NPY model file"
        execfile("/usr/local/neurospaces/models/library/" + filename)
#         execfile("/home/hugo/neurospaces_project/model-container/source/snapshots/0/library/" + filename)

#*************************** End ModelContainer **************************
