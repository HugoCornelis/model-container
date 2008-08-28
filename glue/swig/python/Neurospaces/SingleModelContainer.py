
import Neurospaces

import SwiggableNeurospaces

nmc = SwiggableNeurospaces.NeurospacesNew()

class Segment:
    "SingleModelContainer.Segment class"
    def __init__(self, name):
        segment = Neurospaces.Segment(name)
        
class Cell:
    "SingleModelContainer.Cell class"
    def __init__(self, name):
        cell = Neurospaces.Cell(name)
        
