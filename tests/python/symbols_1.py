#! /usr/bin/env python
"""
This test checks symbol allocation
"""
import os
import sys
import pdb


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc
import model_container.symbols as symbols


my_model_container = nmc.ModelContainer(None)

seg = symbols.Segment(path="/test", model=my_model_container.GetCore())

seg.SetParameter("TEST", 100.0)

value = seg.GetParameter("TEST")

print "Value is %f" % value

print "Done!"
