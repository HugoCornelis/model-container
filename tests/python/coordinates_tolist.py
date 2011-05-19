#! /usr/bin/env python
"""
Basic test showing how to return a list of the model
containers children symbols.
"""
import os
import pdb
import pprint
import sys

my_path = os.path.join(os.environ['HOME'], 'neurospaces_project', 'model-container', 'source',
                       'snapshots', '0', 'glue', 'swig', 'python')

sys.path.append(my_path)

import neurospaces.model_container as nmc

my_model_container = nmc.ModelContainer(None)


try:
    
    children = my_model_container.CoordinatesToList('/', 1, 1)
    
except Exception, e:

    print "%s" % e

my_model_container.Read("cells/purkinje/edsjb1994.ndf")


children = my_model_container.CoordinatesToList('/', 1, 1)

#pdb.set_trace()
pp = pprint.PrettyPrinter()
print "List is: ",

pp.pprint(children)

print "Done!"

