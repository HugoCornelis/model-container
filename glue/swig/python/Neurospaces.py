#!/usr/bin/python

import SwiggableNeurospaces


SegmentCalloc = SwiggableNeurospaces.SegmentCalloc


class Segment:
    "Segment class"
    def __init__(self):
        self.backend = SegmentCalloc()
        
    
    
