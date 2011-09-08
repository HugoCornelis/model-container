#! /usr/bin/env python
"""
Basic test showing how to return a list of the model
containers children symbols.
"""
import os
import pdb
import pprint
import yaml
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


my_model_container.Read("cells/purkinje/edsjb1994.ndf")


#my_model_container.Query("expand /*")

children = my_model_container.CoordinatesToList('/**')

#pdb.set_trace()
#pp = pprint.PrettyPrinter()
#print "List is: ",

import yaml

output = yaml.dump(children)

print output


