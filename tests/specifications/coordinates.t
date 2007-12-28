#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/network-test.ndf.', ],
						   timeout => 100,
						   write => undef,
						  },
						  {
						   description => "What are the coordinates of the first Golgi cell ?",
						   read => "transformed x = 0.00015
transformed y = 0.0001
transformed z = 5e-05
coordinate x = 0.00015
coordinate y = 0.0001
coordinate z = 5e-05
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Golgis/0",
						  },
						  {
						   description => "What are the coordinates of the second Golgi cell ?",
						   read => "transformed x = 0.00045
transformed y = 0.0001
transformed z = 5e-05
coordinate x = 0.00045
coordinate y = 0.0001
coordinate z = 5e-05
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Golgis/1",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "transformed x = 0.00169055
transformed y = 0.000155557
transformed z = 9.447e-06
coordinate x = 0.00169055
coordinate y = 0.000155557
coordinate z = 9.447e-06
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[0]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "transformed x = 0.00168943
transformed y = 0.000163983
transformed z = 3.1356e-05
coordinate x = 0.00168943
coordinate y = 0.000163983
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[1]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "transformed x = 0.00168832
transformed y = 0.000165649
transformed z = 3.8022e-05
coordinate x = 0.00168832
coordinate y = 0.000165649
coordinate z = 3.8022e-05
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[2]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "transformed x = 0.00168609
transformed y = 0.00016287
transformed z = 3.9689e-05
coordinate x = 0.00168609
coordinate y = 0.00016287
coordinate z = 3.9689e-05
",
						   write => "printcoordinates n /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[3]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the first Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the second Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/1 /CerebellarCortex/Purkinjes/1/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the third Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/2 /CerebellarCortex/Purkinjes/2/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the fourth Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/3 /CerebellarCortex/Purkinjes/3/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the fifth Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/4 /CerebellarCortex/Purkinjes/4/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the sixth Purkinje cell ?",
						   read => "transformed x = 1.3983e-05
transformed y = 1.0571e-05
transformed z = 3.1356e-05
coordinate x = 1.3983e-05
coordinate y = 1.0571e-05
coordinate z = 3.1356e-05
",
						   write => "printcoordinates n /CerebellarCortex/Purkinjes/5 /CerebellarCortex/Purkinjes/5/segments/main[1]",
						  },
						 ],
				description => "transformations and conversions",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'contours/section1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "What are the coordinates of the first point of the first contour ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 0
coordinate x = 0
coordinate y = 0
coordinate z = 0
",
						   write => "printcoordinates n /section1 /section1/e0/e0_0",
						  },
						  {
						   description => "What are the coordinates of the second point of the first contour ?",
						   read => "transformed x = 1e-06
transformed y = 0
transformed z = 0
coordinate x = 1e-06
coordinate y = 0
coordinate z = 0
",
						   write => "printcoordinates n /section1 /section1/e0/e0_1",
						  },
						  {
						   description => "What are the coordinates of the third point of the first contour ?",
						   read => "transformed x = 1e-06
transformed y = 1e-06
transformed z = 0
coordinate x = 1e-06
coordinate y = 1e-06
coordinate z = 0
",
						   write => "printcoordinates n /section1 /section1/e0/e0_2",
						  },
						  {
						   description => "What are the coordinates of the fourth point of the first contour ?",
						   read => "transformed x = 0
transformed y = 1e-06
transformed z = 0
coordinate x = 0
coordinate y = 1e-06
coordinate z = 0
",
						   write => "printcoordinates n /section1 /section1/e0/e0_3",
						  },
						  {
						   description => "What are the coordinates of the first point of the second contour ?",
						   read => "transformed x = 0
transformed y = 0
transformed z = 1e-08
coordinate x = 0
coordinate y = 0
coordinate z = 1e-08
",
						   write => "printcoordinates n /section1 /section1/e1/e1_0",
						  },
						  {
						   description => "What are the coordinates of the second point of the second contour ?",
						   read => "transformed x = 1e-06
transformed y = 0
transformed z = 1e-08
coordinate x = 1e-06
coordinate y = 0
coordinate z = 1e-08
",
						   write => "printcoordinates n /section1 /section1/e1/e1_1",
						  },
						  {
						   description => "What are the coordinates of the third point of the second contour ?",
						   read => "transformed x = 1e-06
transformed y = 1e-06
transformed z = 1e-08
coordinate x = 1e-06
coordinate y = 1e-06
coordinate z = 1e-08
",
						   write => "printcoordinates n /section1 /section1/e1/e1_2",
						  },
						  {
						   description => "What are the coordinates of the fourth point of the second contour ?",
						   read => "transformed x = 0
transformed y = 1e-06
transformed z = 1e-08
coordinate x = 0
coordinate y = 1e-06
coordinate z = 1e-08
",
						   write => "printcoordinates n /section1 /section1/e1/e1_3",
						  },
						 ],
				description => "EM contour coordinates",
			       },
			      ],
       description => "coordinates",
       name => 'coordinates.t',
      };


return $test;


