#! /usr/bin/env python
"""

"""
import os
import pdb
import pprint
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


my_model_container.Read("cells/RScell-nolib2.ndf")

nx= 2 # number of cells nx*ny
ny=2

sep_x= 0.002 # 2mm
sep_y=0.002
sep_z=1.0e-6 # give it a tiny z range in case of round off errors

syn_weight=10
cond_vel=0.5
prop_delay=sep_x / cond_vel

my_model_container.CreateNetwork('/RSNet')

my_model_container.CreateMap('::rscell::/cell', '/RSNet/population', nx, ny, sep_x, sep_y)



config = {'root' : '/RSNet',
          'projection' : { 'name' : '/RSNet/projection',
                           'source': '../population',
                           'target' : '../population',
                           },
          'source' : { 'context' : '/RSNet/population',
                       { 'include' : { 'type' : 'box',
                                       'coordinates' : [-1e10, -1e10, -1e10, 1e10, 1e10, 1e10],
                                       
                                       },
                         
                         
                       },

          'target' : { 'context' : '/RSNet/population',
                       'include' : { 'type' : 'ellipse',
                                     'coordinates' : [0, 0, 0, sep_x *1.2, sep_y * 1.2, sep_z * 0.5]
                                     }
                       'exclude' : 'destination_hole',
                                   { 'type' : 'box',
                                     'coordinates' : [sep_x * 0.5, sep_y * 0.5, sep_z * 0.5, sep_x * 0.5, sep_y * 0.5, sep_z * 05],
                                     },
                       
                       
                           
                       },

          'synapse' : { 'pre' : 'spike',
                        'post' : 'Ex_channel',
                        'weight' : { 'weight_indicator' : 'weight',
                                     'weight' : syn_weight,
                                     },
                        'delay' : { 'delay_indicator' : 'delay',
                                    'delay_type' : 'fixed',
                                    'value' : prop_delay
                                    }
                        
                        }
            'probability' : 1.0,
            'random_seed' : 1212.0
          
          }



# use keyword expansion to pass dict as arguments
my_model_container.CreateMap(configuration=config)

print "Done!"
