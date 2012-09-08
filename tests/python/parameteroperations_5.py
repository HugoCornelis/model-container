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

print "Value of CM at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'CM')

print "Setting the value of CM to 0"

my_model_container.SetParameter('/Purkinje/segments/soma', 'CM', 0)

print "Value of CM at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'CM')

print "Setting the value of CM to 5000"

my_model_container.SetParameter('/Purkinje/segments/soma', 'CM', 5000)

print "Value of CM at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'CM')

print "Done!"
