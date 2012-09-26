#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys
import pdb
import yaml

from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")

element = '/Purkinje/segments/main[0]'

parameters = my_model_container.GetAllParameters(element)

import pprint

pp = pprint.PrettyPrinter(indent=2)

print "Parameters for '%s' are:" % element

pp.pprint(parameters)

print "Done!"
