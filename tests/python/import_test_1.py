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


print "Importing nmc_base"
import g3.nmc.nmc_base

print "Importing nmc"
import g3.nmc

print "Done!"
