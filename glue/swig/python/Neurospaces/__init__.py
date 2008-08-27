#!/usr/bin/python

import SwiggableNeurospaces


SegmentCalloc = SwiggableNeurospaces.SegmentCalloc


class Segment:
    "Segment class"
    def __init__(self):
        self.backend = SegmentCalloc()
        
    
    
def new():
    "Construct a model container"
    self.backend = SwiggableNeurospaces.NeurospacesNew()
    return self


