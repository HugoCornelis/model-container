#! /usr/bin/env python
"""
This test checks symbol allocation
"""
import os
import sys
import pdb

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

nmc_path = root_path + "/glue/swig/python/"

sys.path.append(nmc_path)


import neurospaces.model_container as nmc
import neurospaces.model_container.symbols as symbols


my_model_container = nmc.ModelContainer(None)

seg = symbols.Segment("/test")

seg.SetParameter("TEST", 100.0)

value = seg.GetParameter("TEST")

print "Value is %f" % value

print "Done!"
