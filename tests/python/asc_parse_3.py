#! /usr/bin/env python
import os
import pdb
import sys

from test_library import add_package_path

add_package_path('model-container')

from model_container.loader.asc import ASCParser

asc = ASCParser(verbose=True, file=os.path.join('tests','python','asc_files','finchL1_slow.ASC'))


try:

    asc.parse()
    
except Exception, e:

    print "Error occured: %s" % e


print "\n*********************************"
print "File finchL1_slow.ASC has %d tokens" % (asc.get_token_count())
print "With %d lines" % (asc.get_line_number())

print "Done!"
