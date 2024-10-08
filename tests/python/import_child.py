#! /usr/bin/env python
"""
Basic test to check the segment data type.
"""
import os
import pdb
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc


my_nmc = nmc.ModelContainer()

my_segment = my_nmc.CreateSegment("/cell/soma")


my_segment.SetInitialVm(-0.0680)
my_segment.SetRm(1.000)
my_segment.SetRa(2.50)
my_segment.SetCm(0.0164)
my_segment.SetEleak(-0.0800)
my_segment.SetInject(1e-9)

print "Current model is"
my_nmc.Query("expand /**")

print "! end ---\n\n"
my_segment.ImportChild("channels/hodgkin-huxley.ndf::/k")
my_segment.ImportChild("channels/hodgkin-huxley.ndf::/na")

print "Model after child imports is"
my_nmc.Query("expand /**")

print "! end ---\n\n"
print "Done!"

