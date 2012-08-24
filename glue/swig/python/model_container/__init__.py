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

    import model_container_base as nmc_base

except ImportError, e:
    sys.exit("Could not import compiled SWIG model container base library: %s" % e)



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

    def __init__(self, model=None):
        """!
        @brief ModelContainer constructor

        @param model An existing ModelContainer or Neurospaces object.
        """

        self.library_path = None

        self._empty_model_loaded = False
        
        if not self.CheckEnvironment():

            raise errors.LibraryPathError()

        
        # this is the "low level" model container object.
        self._nmc_core = None

        if model == None:

            # Here we construct a new root model container 
            self._nmc_core = nmc_base.NeurospacesNew()

            # We need to load a an empty model to prevent it from
            # giving an error when looking up the root
            self.Read("utilities/empty_model.ndf")
                
        else:

            # isinstance typing should be ok here since
            # we're testing for a C class struct and a class.
            # - duck type?
            if isinstance(model, ModelContainer):

                self._nmc_core = model.GetRootModelContainer()

            elif isinstance(model, nmc_base.Neurospaces):
                
                # Recycling an existing ModelContainer for the python interface
                self._nmc_core = model

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

                self.library_path = library_path
                
                library_exists = True 


        return library_exists

            


#---------------------------------------------------------------------------

    def GetCore(self):
        """!
        @brief Returns the neurospaces core data struct.
        """
        return self._nmc_core

#---------------------------------------------------------------------------

    def GetLibraryPath(self):
        """!
        @brief Returns the model containers default library path
        """
        return self.library_path

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

        nmc_base.PidinStackFree(ppist)

        return value

#---------------------------------------------------------------------------

    def _IsNumber(self, s):
        """!
        @brief helper method, detects if a string is a number

        int, long and float
        """
        try:
            
            float(s) 
            
        except ValueError:

            return False

        return True

#---------------------------------------------------------------------------

    def SetParameter(self, path, parameter, value):
        """!
        @brief Sets a parameter value to a symbol in the model container.

        Not complete, only sets doubles at the moment.
        """
        
        ppist = nmc_base.PidinStackParse(path)

        phsle = nmc_base.PidinStackLookupTopSymbol(ppist)

        nmc_base.PidinStackFree(ppist)

        if phsle is None:

            raise Exception("Can't set parameter, symbol %s doesn't exist" % path)

        if isinstance(value, (int, long, float, complex)):
            
            nmc_base.SymbolSetParameterDouble(phsle, parameter, value)

        elif isinstance(value, str):

            # If this is a string we treat it differently depending
            # on the type of string. Should be no reason to have a
            # numberical string.
            if self._IsNumber(value):

                nmc_base.SymbolSetParameterDouble(phsle, parameter, float(value))
            

        else:

            raise Exception("Invalid parameter type")

#---------------------------------------------------------------------------

    def ChildrenToDictList(self, path):
        """!
        @brief Returns all child symbols of the given path as a list
        @param path A path to an element in the model container

        Returns the immediate children to the symbol found at the given path
        """
        
        ppist = nmc_base.PidinStackParse(path)

        phsle = nmc_base.PidinStackLookupTopSymbol(ppist)

        if phsle is None:

            nmc_base.PidinStackFree(ppist)

            raise Exception("No symbol found at '%s'" % path)

        symbol_list = []
    
        symbol_list = nmc_base.ChildSymbolsToDictList(path)

        nmc_base.PidinStackFree(ppist)

        return symbol_list

#---------------------------------------------------------------------------


    def AllChildrenToDictList(self):
        """!
        @brief Returns all child symbols of the given path recursively as a list
        @param path A path to an element in the model container
        """
        
    
        symbol_list = nmc_base.AllChildSymbolsToList(self._nmc_core)

        if not symbol_list:

            return []

        else:
            
            return symbol_list
    
#---------------------------------------------------------------------------

    def ChildrenToList(self, path, typed=False):
        """!
        @brief Returns all child symbols of the given path as a list
        @param path A path to an element in the model container
        @param typed If true return the name with the type

        Returns the immediate children to the symbol found at the given path
        """
        
        ppist = nmc_base.PidinStackParse(path)

        phsle = nmc_base.PidinStackLookupTopSymbol(ppist)

        if phsle is None:

            nmc_base.PidinStackFree(ppist)

            raise Exception("No symbol found at '%s'" % path)

        symbol_list = []

        symbol_list = nmc_base.ChildSymbolsToList(path)

        nmc_base.PidinStackFree(ppist)

        return symbol_list



#---------------------------------------------------------------------------

    def CoordinatesToList(self, path=None):
        """!
        @brief Returns a list of visible coordinates
        @param path A path to an element in the model container
        @param level Integer for the level to descend into the model container
        @param mode The mode to use, biolevel inclusive or children traversal.
        @returns A list of dict objects containing coordinates.
        """
        if path is None:

            raise Exception("No path given")
        

        symbol_list = []

        symbol_list = nmc_base.CoordinatesToList(path, self._nmc_core)

        return symbol_list

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
    
    def Read(self, filename=None, namespace=None):
        """!
        @brief read an NDF model file

        Due to the need for the C swig code to read string literals
        unicode strings are converted to ascii.
        """

        if not namespace is None:

            self.NDFLoadLibrary(filename, namespace)

        else:

            ndf_filename = filename

            if isinstance(filename, unicode):

                try:

                    ndf_filename = str(filename)
                
                except UnicodeEncodeError:

                    print "Can't read in '%s', error processing unicode" % filename
                
                    raise
                
            # The "python" string is there just to keep the config parser happy since it expects
            # the executable at arg[0]
            result = nmc_base.NeurospacesRead(self._nmc_core, 2, [ "python", ndf_filename ] )

            if result == 0:

                raise Exception("Error reading NDF file '%s'" % filename)
            
#---------------------------------------------------------------------------

    def NDFLoadLibrary(self, filename=None, namespace=None):

        qualified = nmc_base.ParserContextQualifyFilename(None, filename)

        if not qualified is None:

        

            result = nmc_base.ParserImport(self._nmc_core.pacRootContext,
                                           qualified,
                                           filename,
                                           namespace)

            if result == 0:

                raise Exception("Can't perform NDF load library on '%s' with namespace '%s'" % (filename, namespace))
            
        else:

            raise Exception("Can't find qualified filename for '%s' with namespace '%s'" % (filename, namespace))

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

    def Create(self, path, typ='segment'):
        """

        More open ended create method. Probably need to use an
        eval method somewhere here to make it even more open ended. 
        """
        
        result = None
        
        if typ == 'segment':

            result = self.CreateSegment(path)

        elif typ == 'compartment':

            result = self.CreateCompartment(path)

        elif typ == 'cell':

            result = self.CreateCell(path)

        elif typ == 'network':

            result = self.CreateNetwork(path)

        else:

            raise Exception("Invalid type: %s" % typ)

        return result

#---------------------------------------------------------------------------

    def CreateSegment(self, path):
        """
        
        """
        seg = symbols.Segment(path=path, model=self._nmc_core)

        # exception check?

        return seg

#---------------------------------------------------------------------------

    def CreateCompartment(self, path):
        """

        """
        return CreateSegment(path=path, model=self._nmc_core)


#---------------------------------------------------------------------------

    def CreateCell(self, path):

        cell = symbols.Cell(path=path, model=self._nmc_core)

        # exception check?

        return cell

#---------------------------------------------------------------------------

    def CreateNetwork(self, path):

        network = symbols.Network(path=path, model=self._nmc_core)

        return network
#---------------------------------------------------------------------------

    def CreateMap(self, prototype=None, target=None,
                  countx=None, county=None,
                  deltax=None, deltay=None):

        """!
        @brief Imports a child into the current symbol from the given path
        """
        
        if self._nmc_core is None:

            raise Exception("No model container defined for symbol '%s', can't perform child import for '%s'" % (self._path, path))

        import re

        p = re.split("::", prototype)

        if len(p) > 3 or len(p) < 2:

            raise Exception("The prototype '%s' is in invalid format" % prototype)

        if p[0] == '':

            namespaces = "::%s" % p[1]
            component = p[2]

        else:
            # probably not necessary
            namespaces = "::%s" % p[0]
            component = p[1]

        component_name = re.split('/', component)[1]

        details = ""
#        prototype = component_name


        try:

            result = nmc_base.PyBCreateMap(self._nmc_core, prototype, namespaces, component_name)

            details = "low level createmap failed with prototype '%s', namespace '%s' and component '%s'" % (prototype, namespaces,component_name)

        except Exception, e:

            
            raise Exception("%s, %s" % (e, details))

        if result == 0:

            raise Exception("%s" % details)

        # now we run the query machine command
        
        instance_name = "createmap_%s" % target

        command = "algorithminstantiate Grid3D %s %s %s %s %s 1 %s %s 0" % (instance_name.replace('/','_'),
                                                                            target,
                                                                            component_name, #prototype,
                                                                            countx,
                                                                            county,
                                                                            deltax,
                                                                            deltay)

        pdb.set_trace()
        nmc_base.QueryMachineHandle(self._nmc_core, command)





#     def CreateMap(self, prototype=None, target=None,
#                   countx=None, county=None,
#                   deltax=None, deltay=None):

#         """!
#         @brief Imports a child into the current symbol from the given path
#         """
        
#         if self._nmc_core is None:

#             raise Exception("No model container defined for symbol '%s', can't perform child import for '%s'" % (self._path, path))

#         import re

#         p = re.split("::", prototype)

#         if len(p) > 3 or len(p) < 2:

#             raise Exception("The prototype '%s' is in invalid format" % prototype)

#         if p[0] == '':

#             namespaces = "::%s" % p[1]
#             component = p[2]

#         else:
#             # probably not necessary
#             namespaces = "::%s" % p[0]
#             component = p[1]


#         prototype_context = None
        
#         prototype_context = nmc_base.PidinStackParse(prototype)

#         prototype_symbol = None
        
#         prototype_symbol = nmc_base.SymbolsLookupHierarchical(self._nmc_core.psym, prototype_context)

#         component_name = re.split('/', component)[1]

#         # Create an alias to the symbol
        
#         pidin = nmc_base.IdinCallocUnique(component_name)

#         alias = nmc_base.SymbolCreateAlias(prototype_symbol, namespaces, pidin)

#         root_context = nmc_base.PidinStackParse("::/")

#         root_symbol = nmc_base.PidinStackLookupTopSymbol(root_symbol)

#         if root_context is None:

#             raise Exception("Cannot get a private root context in 'CreateMap' method. (has model been loaded?)")

#         success = nmc_base.SymbolAddChild(root_symbol, alias)

#         prototype = component_name


#         # now we run the query machine command
        
#         instance_name = "createmap_%s" % target


#         command = "algorithminstantiate Grid3D %s %s %s %s %s 1 %s %s 0" % (instance_name.replace('/','_'),
#                                                                             target,
#                                                                             prototype,
#                                                                             countx,
#                                                                             county,
#                                                                             deltax,
#                                                                             deltay)

#         nmc_base.QueryHandler(command)

        
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

    def GetSerial(self, path):
        """
        @brief A simple method for retrieving a serial
        """
        context = nmc_base.PidinStackParse(path)

        nmc_base.PidinStackLookupTopSymbol(context)

        serial = nmc_base.PidinStackToSerial(context)

        nmc_base.PidinStackFree(context)

        return serial

#---------------------------------------------------------------------------

    def ReadPython(self, filename):
        """!
        @brief read an NPY model file

        Probably useless
        """
        
        if not os.path.isfile(filename):

            # Make my own exception? check for the ndf suffix?
            raise Exception("%s is not a valid file or does not exist" % (filename))
        
        execfile("/usr/local/neurospaces/models/library/" + filename)


#---------------------------------------------------------------------------

    def SetOutputFile(self,filename):

        self._output_file = filename

#---------------------------------------------------------------------------

    def CreateProjection(self, configuration=None):

        """!

        Creates a projection in the model container. If configuration is present it
        will parse it and use the data from it. If not it will take it from arguments.

        """

        if not configuration is None:

            arguments = dict(network='',
                             projection='',
                             projection_source='',
                             projection_target='',
                             source='',
                             target='',
                             pre='',
                             post='',
                             source_type='',
                             source_x1='',
                             source_y1='',
                             source_z1='',
                             source_x2='',
                             source_y2='',
                             source_z2='',
                             destination_type='',
                             destination_x1='',
                             destination_y1='',
                             destination_z1='',
                             destination_x2='',
                             destination_y2='',
                             destination_z2='',
                             weight_indicator='',
                             weight='',
                             delay_indicator='',
                             delay_type='',
                             delay='',
                             velocity_indicator='',
                             velocity='',
                             destination_hole_flag='',
                             destination_hole_type='',
                             destination_hole_x1='',
                             destination_hole_y1='',
                             destination_hole_z1='',
                             destination_hole_x2='',
                             destination_hole_y2='',
                             destination_hole_z2='',
                             probability='',
                             random_seed='')

            if configuration.has_key('root'): 

                arguments['network'] = configuration['root']

            elif configuration.has_key('network'):

                arguments['network'] = configuration['network']


            if configuration.has_key('probability'):

                arguments['probability'] = configuration['probability']

            if configuration.has_key('random_seed'):

                arguments['random_seed'] = configuration['random_seed']


            if configuration.has_key('projection'):

                if configuration['projection'].has_key('source'):

                    arguments['projection_source'] = configuration['projection']['source']

                if configuration['projection'].has_key('target'):

                    arguments['projection_target'] = configuration['projection']['target']


            if configuration.has_key('source'):

                source = configuration['source']
                
                if source.has_key('context'):

                    arguments['projection_source'] = source['context']


                if source.has_key('include'):

                    include = source['include']

                    if include.has_key('type'):

                        arguments['source_type'] = include['type']

                    if include.has_key('coordinates'):

                        coords = include['coordinates']
                        
                        arguments['source_x1'] = coords[0]
                        arguments['source_y1'] = coords[1]
                        arguments['source_z1'] = coords[2]
                        arguments['source_x2'] = coords[3]
                        arguments['source_y2'] = coords[4]
                        arguments['source_z2'] = coords[5]
                    
            if configuration.has_key('target'):

                target = configuration['target']

                if target.has_key('context'):

                    arguments['projection_target'] = target['context']


                if target.has_key('include'):

                    include = target['include']

                    if include.has_key('type'):

                        arguments['destination_type'] = include['type']

                    if include.has_key('coordinates'):

                        coords = include['coordinates']
                        
                        arguments['destination_x1'] = coords[0]
                        arguments['destination_y1'] = coords[1]
                        arguments['destination_z1'] = coords[2]
                        arguments['destination_x2'] = coords[3]
                        arguments['destination_y2'] = coords[4]
                        arguments['destination_z2'] = coords[5]


                if configuration.has_key('exclude'):

                    exclude = configuration['exclude']

                    arguments['destination_hole_flag'] = 'destination_hole'

                    if exclude.has_key('type'):

                        arguments['destination_hole_type'] = exclude['type']

                    if exclude.has_key('coordinates'):

                        coords = exclude['coordinates']
                        
                        arguments['destination_hole_x1'] = coords[0]
                        arguments['destination_hole_y1'] = coords[1]
                        arguments['destination_hole_z1'] = coords[2]
                        arguments['destination_hole_x2'] = coords[3]
                        arguments['destination_hole_y2'] = coords[4]
                        arguments['destination_hole_z2'] = coords[5]
            

            if configuration.has_key('synapse'):

                synapse = configuration['synapse']

                if synapse.has_key('delay'):

                    delay = synapse['delay']
                    
                    arguments['delay_indicator'] = 'delay'

                    if delay.has_key('type'):
                        
                        arguments['delay_type'] = delay['type']

                    else:

                        arguments['delay_type'] = 'fixed'

                    if delay.has_key('value'):
                        
                        arguments['delay'] = delay['value']

                    
                    if delay.has_key('velocity'):

                        arguments['velocity_indicator'] = 'velocity' 

                        arguments['velocity'] = delay['velocity']


                if synapse.has_key('weight'):

                    weight = synapse['weight']

                    if weight.has_key('value'):

                        arguments['weight_indicator'] = 'weight'

                        arguments['weight'] = weight['value']


                if synapse.has_key('pre'):

                    arguments['pre'] = synapse['pre']

                if synapse.has_key('post'):

                    arguments['post'] = synapse['post']

            self.VolumeConnect(**arguments)


        else:
            

            pass
            
#---------------------------------------------------------------------------

    def VolumeConnect(self, network=None,
                      projection=None, projection_target=None, projection_source=None,
                      source=None, target=None,
                      pre=None, post=None,
                      source_type=None,
                      source_x1=None, source_y1=None, source_z1=None,
                      source_x2=None, source_y2=None, source_z2=None,
                      destination_type=None,
                      destination_x1=None, destination_y1=None, destination_z1=None,
                      destination_x2=None, destination_y2=None, destination_z2=None,
                      weight_indicator=None, weight=None,
                      delay_indicator=None, delay_type=None, delay=None,
                      velocity_indicator=None, velocity=None,
                      destination_hole_flag=None, destination_hole_type=None,
                      destination_hole_x1=None, destination_hole_y1=None, destination_hole_z1=None,
                      destination_hole_x2=None, destination_hole_y2=None, destination_hole_z2=None,
                      probability=None, random_seed=None):
        """!

        Performs a volume connect on a network and projections.
        """

        instance_name = "projectionvolume_%s_%s" % (network.replace('/', '_'),
                                                    projection.replace('/', '_'))

        command = "algorithminstantiate ProjectionVolume %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s" % (instance_name, network, projection,
                                                                                                                                                                                     projection_source, projection_target,
                                                                                                                                                                                     source, target, pre, post, source_type,
                                                                                                                                                                                     source_x1, source_y1, source_z1,
                                                                                                                                                                                     source_x2, source_y2, source_z2,
                                                                                                                                                                                     destination_type, destination_x1, destination_y1, destination_z1,
                                                                                                                                                                                     destination_x2, destination_y2, destination_z2,
                                                                                                                                                                                     weight_indicator, weight, delay_indicator, delay_type, delay,
                                                                                                                                                                                     velocity_indicator, velocity,
                                                                                                                                                                                     destination_hole_flag, destination_hole_type,
                                                                                                                                                                                     destination_hole_x1, destination_hole_y1, destination_hole_z1,
                                                                                                                                                                                     destination_hole_x2, destination_hole_y2, destination_hole_z2,
                                                                                                                                                                                     probability, random_seed)


# valid line: algorithminstantiate Grid3D createmap__RSNet_population /RSNet/population cell 2 2 1 0.002 0.002 0
        command = "algorithminstantiate Grid3D createmap__RSNet_population /RSNet/population cell 2 2 1 0.002 0.002 0"
 
        result = nmc_base.QueryMachineHandle(self._nmc_core, command)

        return result

#*************************** End ModelContainer **************************









        

