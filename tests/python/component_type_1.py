#! /usr/bin/env python
"""
Basic test showing how to return a list of the model
containers children symbols.
"""
import os
import pdb
import pprint
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


my_model_container.Read("cells/purkinje/edsjb1994.ndf")


component_type = my_model_container.GetComponentType("/Purkinje/segments/soma")

print "The component type for /Purkinje/segments/soma is '%s'" % component_type

print "Done!"

