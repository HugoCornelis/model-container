#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys
import pdb

from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")

element = '/Purkinje/segments/soma'

parameters = my_model_container.GetAllParameters(element)

print "Parameters for '%s' are:" % element
for k in parameters.keys():
    
    print "\t%s: %s" % (k, parameters[k])

print "Done!"
