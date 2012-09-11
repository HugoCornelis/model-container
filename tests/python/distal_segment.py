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

my_nmc = nmc.ModelContainer(None)


my_nmc.Read("cells/purkinje/edsjb1994.ndf")

my_nmc.Query("segmentertips /Purkinje")

print "Done!"

