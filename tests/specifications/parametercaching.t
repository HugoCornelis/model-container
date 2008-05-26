#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networksmall.ndf.', ],
						   timeout => 10,
						   write => undef,
						  },
						  {
						   description => "What is the original x coordinate of the third granule cell ?",
						   read => "value = 0",
						   write => "printparameter /CerebellarCortex/Granules/3 X",
						  },
						  {
						   description => "Setting the X coordinate of the third granule cell to something extraordinary.",
						   read => undef,
						   write => "setparameter /CerebellarCortex/Granules 3 X number 4",
						  },
						  {
						   description => "Has the x coordinate of the third granule cell been changed to the extraordinary value ?",
						   read => "value = 4",
						   write => "printparameter /CerebellarCortex/Granules/3 X",
						  },
						  {
						   description => "Setting the X coordinate of the third granule cell to something more reasonable.",
						   read => undef,
						   write => "setparameter /CerebellarCortex Granules/3 X number 5e-5",
						  },
						  {
						   description => "Has the x coordinate of the third granule cell been changed to the more reasonable value ?",
						   read => "value = 5e-05",
						   write => "printparameter /CerebellarCortex/Granules/3 X",
						  },
						  {
						   description => "Changing the x coordinate of the Granule cell population to something extraordinary.",
						   read => "value = 0",
						   write => "printparameter /CerebellarCortex/Granules X",
						  },
						  {
						   description => "Changing the x coordinate of the Granule cell population to something extraordinary.",
						   read => undef,
						   write => "setparameter /CerebellarCortex Granules X number 10",
						  },
						  {
						   description => "Has the x coordinate of the granule cell population been changed to the extraordinary value ?",
						   read => "value = 10",
						   write => "printparameter /CerebellarCortex/Granules X",
						  },
						  {
						   description => "Has the x coordinate of the third granule cell been changed ?",
						   read => "value = 5e-05",
						   write => "printparameter /CerebellarCortex/Granules/3 X",
						  },
# 						  {
# 						   description => "Resetting the X coordinate of the third granule cell to its original value.",
# 						   read => undef,
# 						   write => "setparameter /CerebellarCortex Granules/3 X number 0",
# 						  },
# 						  {
# 						   description => "Resetting the X coordinate of the granule cell population to its original value.",
# 						   read => undef,
# 						   write => "setparameter /CerebellarCortex Granules X number 0",
# 						  },
						 ],
				description => "simple parameter caches",
				side_effects => 1,
			       },
# 			       {
# 				arguments => [
# 					      '-q',
# 					      'legacy/networks/networksmall.ndf',
# 					     ],
# 				command => './neurospacesparse',
# 				description => "coordinate parameter caches : erasing caches",
# 			       },
			       {
				arguments => [
					      '-q',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networksmall.ndf.', ],
						   timeout => 10,
						   write => undef,
						  },
						  {
						   description => "What is the original coordinate of the granule cell population ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 0.0001
coordinate x = 0
coordinate y = 0
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules",
						  },
						  {
						   description => "What is the original coordinate of the second granule cell ?",
						   numerical_compare => 1,
						   read => {
							    alternatives => [
									     "transformed x = 1e-04
transformed y = 0
transformed z = 0.0001
coordinate x = 1e-04
coordinate y = 0
coordinate z = 0.0001
",
									     "transformed x = 0.0001
transformed y = 0
transformed z = 0.0001
coordinate x = 0.0001
coordinate y = 0
coordinate z = 0.0001
",

									    ],
							   },
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/2",
						  },
						  {
						   description => "What is the original coordinate of the third granule cell ?",
						   read => "transformed x = 0
transformed y = 3.75e-05
transformed z = 0.0001
coordinate x = 0
coordinate y = 3.75e-05
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Moving the third granule cell in the population.",
						   read => undef,
						   write => "setparameter /CerebellarCortex/Granules 3 X number 2e-3",
						  },
						  {
						   description => "Is the granule cell population still at its original location ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 0.0001
coordinate x = 0
coordinate y = 0
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules",
						  },
						  {
						   description => "Has the third granule cell moved in the population ?",
						   read => "transformed x = 0.002
transformed y = 3.75e-05
transformed z = 0
coordinate x = 0.002
coordinate y = 3.75e-05
coordinate z = 0
",
						   write => "printcoordinates n /CerebellarCortex/Granules /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Has the third granule cell moved in the network ?",
						   read => "transformed x = 0.002
transformed y = 3.75e-05
transformed z = 0.0001
coordinate x = 0.002
coordinate y = 3.75e-05
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Is the second granule cell still at its original location ?",
						   numerical_compare => 1,
						   read => {
							    alternatives => [
									     "transformed x = 1e-04
transformed y = 0
transformed z = 0.0001
coordinate x = 1e-04
coordinate y = 0
coordinate z = 0.0001
",
									     "transformed x = 0.0001
transformed y = 0
transformed z = 0.0001
coordinate x = 0.0001
coordinate y = 0
coordinate z = 0.0001
",
									    ],
							   },
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/2",
						  },
						  {
						   description => "Moving the third granule cell in the network.",
						   read => undef,
						   write => "setparameter /CerebellarCortex Granules/3 X number 3e-3",
						  },
						  {
						   description => "Is the granule cell population still at its original location ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 0.0001
coordinate x = 0
coordinate y = 0
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules",
						  },
						  {
						   description => "Has the third granule cell moved in the population ?",
						   read => "transformed x = 0.003
transformed y = 3.75e-05
transformed z = 0
coordinate x = 0.003
coordinate y = 3.75e-05
coordinate z = 0
",
						   write => "printcoordinates n /CerebellarCortex/Granules /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Has the third granule cell moved in the network ?",
						   read => "transformed x = 0.003
transformed y = 3.75e-05
transformed z = 0.0001
coordinate x = 0.003
coordinate y = 3.75e-05
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Is the second granule cell still at its original location ?",
						   numerical_compare => 1,
						   read => {
							    alternatives => [
									     "transformed x = 1e-04
transformed y = 0
transformed z = 0.0001
coordinate x = 1e-04
coordinate y = 0
coordinate z = 0.0001
",
									     "transformed x = 0.0001
transformed y = 0
transformed z = 0.0001
coordinate x = 0.0001
coordinate y = 0
coordinate z = 0.0001
",
									    ],
							   },
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/2",
						  },
						  {
						   description => "Rotating the granule cell population in the network.",
						   read => undef,
						   write => "setparameter /CerebellarCortex Granules ROTATE_ANGLE number 3.1416",
						  },
						  {
						   description => "Rotating the granule cell population in the network.",
						   read => undef,
						   write => "setparameter /CerebellarCortex Granules ROTATE_AXIS_Z number 1",
						  },
						  {
						   description => "Is the granule cell population still at its original location ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 0.0001
coordinate x = 0
coordinate y = 0
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules",
						  },
						  {
						   description => "Has the third granule cell been rotated in the population ?",
						   read => "transformed x = 0.003
transformed y = 3.75e-05
transformed z = 0
coordinate x = 0.003
coordinate y = 3.75e-05
coordinate z = 0
",
						   write => "printcoordinates n /CerebellarCortex/Granules /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Has the third granule cell been rotated in the network ?",
						   read => "transformed x = -0.003
transformed y = -3.7522e-05
transformed z = 0.0001
coordinate x = -0.003
coordinate y = -3.7522e-05
coordinate z = 0.0001
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/3",
						  },
						  {
						   description => "Has the second granule cell been rotated in the network ?",
						   numerical_compare => 1,
						   read => {
							    alternatives => [
									     "transformed x = -1e-04
transformed y = -7.34641e-10
transformed z = 0.0001
coordinate x = -1e-04
coordinate y = -7.34641e-10
coordinate z = 0.0001
",
									     "transformed x = -0.0001
transformed y = -7.34641e-10
transformed z = 0.0001
coordinate x = -0.0001
coordinate y = -7.34641e-10
coordinate z = 0.0001
",
									    ],
							   },
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Granules/2",
						  },
						 ],
				description => "coordinate parameter caches",
				side_effects => 1,
			       },
# 			       {
# 				arguments => [
# 					      '-q',
# 					      'networks/networksmall.ndf',
# 					     ],
# 				command => './neurospacesparse',
# 				description => "coordinate parameter caches : erasing caches",
# 			       },
			      ],
       description => "parameter caches",
       name => 'parametercaching.t',
      };


return $test;


