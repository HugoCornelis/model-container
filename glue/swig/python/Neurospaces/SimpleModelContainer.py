
import SimpleHeccer

import Neurospaces

import SwiggableNeurospaces

nmc = SwiggableNeurospaces.NeurospacesNew()

output = None

SwiggableNeurospaces.NeurospacesRead(nmc, 2, [ "python", "utilities/empty_model.ndf" ] )

print "SwiggableNeurospaces.NeurospacesRead() executed"

class Cell:
    "SimpleModelContainer.Cell class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        cell = Neurospaces.Cell(name.pcIdentifier)
        SwiggableNeurospaces.SymbolAddChild(top_symbol, cell.backend.segr.bio.ioh.iol.hsle)
        self.backend = cell

# class Output:
#     "SimpleModelContainer.Output class"
#     def __init__(self, filename, component, field):
#         global output
#         if output == None:
#             output = SimpleHeccer.Output(filename)
#             context = SwiggableNeurospaces.PidinStackParse("/cell")
#             SwiggableNeurospaces.SolverInfoRegistrationAddFromContext(nmc, context, "SimpleHeccer")
#         output.AddOutput(nmc, component, field)
#         self.backend = output

class Segment:
    "SimpleModelContainer.Segment class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        segment = Neurospaces.Segment(name.pcIdentifier)
        SwiggableNeurospaces.SymbolAddChild(top_symbol, segment.backend.segr.bio.ioh.iol.hsle)
        self.backend = segment
        
    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.backend.segr.bio.ioh.iol.hsle, name, value)
        
def compile(filename):
    Neurospaces.SimpleHeccer.new(nmc, filename)
    Neurospaces.SimpleHeccer.compile()

def output(component, field):
    context = SwiggableNeurospaces.PidinStackParse(component)
    SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    serial = SwiggableNeurospaces.PidinStackToSerial(context)
    Neurospaces.SimpleHeccer.output(serial, field)

def prepare(path):
    context = SwiggableNeurospaces.PidinStackParse(path)
    name = SwiggableNeurospaces.PidinStackTop(context)
    SwiggableNeurospaces.PidinStackPop(context)
    top_symbol = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    return [ name, top_symbol ]

def querymachine(command):
    Neurospaces.querymachine(nmc, command)
    
def run(time):
    Neurospaces.SimpleHeccer.run(time)
