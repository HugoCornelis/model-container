
import Neurospaces

import SwiggableNeurospaces

nmc = SwiggableNeurospaces.NeurospacesNew()

SwiggableNeurospaces.NeurospacesRead(nmc, 2, [ "python", "utilities/empty_model.ndf" ] )

print "SwiggableNeurospaces.NeurospacesRead() executed"

class Segment:
    "SingleModelContainer.Segment class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        segment = Neurospaces.Segment(name.pcIdentifier)
        SwiggableNeurospaces.SymbolAddChild(top_symbol, segment.backend.segr.bio.ioh.iol.hsle)
        self.backend = segment
        
    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.backend.segr.bio.ioh.iol.hsle, name, value)
        
class Cell:
    "SingleModelContainer.Cell class"
    def __init__(self, path):
        [ name, top_symbol ] = prepare(path)
        print "cell name is " + name.pcIdentifier
        cell = Neurospaces.Cell(name.pcIdentifier)
        print "cell name is " + name.pcIdentifier
        SwiggableNeurospaces.SymbolAddChild(top_symbol, cell.backend.segr.bio.ioh.iol.hsle)
        self.backend = cell

def prepare(path):
    context = SwiggableNeurospaces.PidinStackParse(path)
    name = SwiggableNeurospaces.PidinStackTop(context)
    SwiggableNeurospaces.PidinStackPop(context)
    top_symbol = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    return [ name, top_symbol ]

def querymachine(command):
    Neurospaces.querymachine(nmc, command)
    
