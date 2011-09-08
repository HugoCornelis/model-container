#! /usr/bin/env python
"""
This test checks for the for the nmc modules 
to be present and importable.
"""
import os
import sys
import pdb


print "Importing model_container_base"
import model_container.model_container_base

print "Importing nmc"
import model_container

print "Done!"
