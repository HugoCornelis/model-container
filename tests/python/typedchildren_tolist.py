#! /usr/bin/env python
"""
Basic test showing how to return a list of the model
containers children symbols.
"""
import os
import pdb
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


try:
    
    children = my_model_container.ChildrenToList('/')
    
except Exception, e:

    print "%s" % e

my_model_container.Read("cells/purkinje/edsjb1994.ndf")


children = my_model_container.ChildrenToList('/', typed=True)

print "Top level child is:",
print children[0]

print "Done!"

