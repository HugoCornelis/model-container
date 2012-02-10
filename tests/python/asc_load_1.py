#! /usr/bin/env python
import os
import pdb
import sys

from test_library import add_package_path

add_package_path('model-container')

from model_container.loader.asc import ACSParser



asc = ASCParser(file=os.path.join('tests','python','asc_files','alxP.asc'))

print "done"
