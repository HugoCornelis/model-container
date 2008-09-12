
import SimpleHeccer

import Neurospaces

import SwiggableNeurospaces

nmc = Neurospaces.ModelContainer()

output_filename = None

nmc.read("utilities/empty_model.ndf")

class NoOutputFilenameException:
    def __init__(self, cause):
        self.cause = cause

class Symbol:
    def insert_child(self, name):
        Neurospaces.Symbol.insert_child(self, nmc.backend, name)

class Cell(Symbol):
    "SingleCellContainer.Cell class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        cell = Neurospaces.Cell(name.pcIdentifier)
        SwiggableNeurospaces.SymbolAddChild(top_symbol, cell.backend.segr.bio.ioh.iol.hsle)
        self.backend = cell

class Segment(Symbol):
    "SingleCellContainer.Segment class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        segment = Neurospaces.Segment(name.pcIdentifier)
        SwiggableNeurospaces.SymbolAddChild(top_symbol, segment.backend.segr.bio.ioh.iol.hsle)
        self.backend = segment
        
    def parameter(self, name, value):
        self.backend.parameter(name, value)

    def insert_child(self, name):
        Neurospaces.Segment.insert_child(self.backend, nmc.backend, name)

def compile(modelname):
    global output_filename
    if output_filename == None:
        raise NoOutputFilenameException("output_filename must be defined during compile()")
    Neurospaces.SimpleHeccer.new(nmc.backend, modelname, output_filename)
    Neurospaces.SimpleHeccer.compile()

def output(component, field):
    context = SwiggableNeurospaces.PidinStackParse(component)
    SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    serial = SwiggableNeurospaces.PidinStackToSerial(context)
    Neurospaces.SimpleHeccer.output(serial, field)

def set_output_filename(filename):
    global output_filename
    output_filename = filename
    
def prepare(path):
    context = SwiggableNeurospaces.PidinStackParse(path)
    name = SwiggableNeurospaces.PidinStackTop(context)
    SwiggableNeurospaces.PidinStackPop(context)
    top_symbol = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    return [ name, top_symbol ]

def query(command):
    nmc.query(command)
    
def read(filename):
    nmc.read(filename)

def run(time):
    Neurospaces.SimpleHeccer.run(time)
