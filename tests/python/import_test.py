#! /usr/bin/env python
"""
This test checks for the for the nmc modules 
to be present and importable.
"""
import os
import sys
import pdb


from test_library import add_package_path

add_package_path('model-container')

print "Importing model_container_base"
import neurospaces.model_container.model_container_base

print "Importing model container"
import neurospaces.model_container

print "Done!"
