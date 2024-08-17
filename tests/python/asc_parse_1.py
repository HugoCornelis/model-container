#! /usr/bin/env python3
import os
import pdb
import sys

from test_library import add_package_path

add_package_path('model-container')

from model_container.loader.asc import ASCParser

asc = ASCParser(file=os.path.join('tests','python','asc_files','e1cb4a1.asc'))


token = ""
tokens = -1

while True:


    token = asc.next()


    if token is None:

        break

    else:

        tokens = tokens + 1

print("File e1cb4a1.asc has %d tokens" % (tokens))
print("With %d lines" % (asc.get_line_number()))

print("Done!")
