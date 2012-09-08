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

print "Value of G_MAX at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'G_MAX')

print "Setting the value of G_MAX to 0"

my_model_container.SetParameter('/Purkinje/segments/soma', 'G_MAX', 0)

print "Value of G_MAX at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'G_MAX')

print "Setting the value of G_MAX to 5000"

my_model_container.SetParameter('/Purkinje/segments/soma', 'G_MAX', 5000)

print "Value of G_MAX at the soma is %s" % my_model_container.GetParameter('/Purkinje/segments/soma', 'G_MAX')

print "Done!"
