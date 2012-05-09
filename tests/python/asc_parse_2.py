#! /usr/bin/env python
import os
import pdb
import sys

from test_library import add_package_path

add_package_path('model-container')

from model_container.loader.asc import ASCParser

asc = ASCParser(file=os.path.join('tests','python','asc_files','e1cb4a1.asc'))


try:

    asc.parse()
    
except Exception, e:

    print "Error occured: %s" % e


print "File e1cb4a1.asc has %d tokens" % (asc.get_token_count())
print "With %d lines" % (asc.get_line_number())

print "Done!"
