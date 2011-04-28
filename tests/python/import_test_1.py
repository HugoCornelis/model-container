#! /usr/bin/env python
"""
This test checks for the for the nmc modules 
to be present and importable.
"""
import os
import sys
import pdb

python_path = "/usr/local/glue/swig/python/"

sys.path.append(python_path)


print "Importing model_container_base"
import neurospaces.model_container.model_container_base

print "Importing nmc"
import neurospaces.model_container

print "Done!"
