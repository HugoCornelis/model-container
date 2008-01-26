#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/network-test.ndf.', ],
						   timeout => 150,
						   write => undef,
						  },
						  {
						   description => "What are the coordinates of the first Golgi cell ?",
						   read => "cached coordinate x = 0.00015
cached coordinate y = 0.0001
cached coordinate z = 5e-05
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Golgis/0",
						  },
						  {
						   description => "What are the coordinates of the second Golgi cell ?",
						   read => "cached coordinate x = 0.00045
cached coordinate y = 0.0001
cached coordinate z = 5e-05
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Golgis/1",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "cached coordinate x = 0.00169055
cached coordinate y = 0.000155557
cached coordinate z = 9.447e-06
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[0]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "cached coordinate x = 0.00168943
cached coordinate y = 0.000163983
cached coordinate z = 3.1356e-05
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[1]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "cached coordinate x = 0.00168832
cached coordinate y = 0.000165649
cached coordinate z = 3.8022e-05
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[2]",
						  },
						  {
						   description => "Have Purkinje cell relative coordinates been converted to absolute coordinates ?",
						   read => "cached coordinate x = 0.00168609
cached coordinate y = 0.00016287
cached coordinate z = 3.9689e-05
#coordinates : 439541
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex /CerebellarCortex/Purkinjes/0/segments/main[3]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the first Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the second Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/1 /CerebellarCortex/Purkinjes/1/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the third Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/2 /CerebellarCortex/Purkinjes/2/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the fourth Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/3 /CerebellarCortex/Purkinjes/3/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the fifth Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/4 /CerebellarCortex/Purkinjes/4/segments/main[1]",
						  },
						  {
						   description => "Are rotations not applied when examining local coordinates of the sixth Purkinje cell ?",
						   read => "cached coordinate x = 1.3983e-05
cached coordinate y = 1.0571e-05
cached coordinate z = 3.1356e-05
#coordinates : 25525
",
						   timeout => 20,
						   write => "printcoordinates c /CerebellarCortex/Purkinjes/5 /CerebellarCortex/Purkinjes/5/segments/main[1]",
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
						   read => "cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e0/e0_0",
						  },
						  {
						   description => "What are the coordinates of the second point of the first contour ?",
						   read => "cached coordinate x = 1e-06
cached coordinate y = 0
cached coordinate z = 0
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e0/e0_1",
						  },
						  {
						   description => "What are the coordinates of the third point of the first contour ?",
						   read => "cached coordinate x = 1e-06
cached coordinate y = 1e-06
cached coordinate z = 0
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e0/e0_2",
						  },
						  {
						   description => "What are the coordinates of the fourth point of the first contour ?",
						   read => "cached coordinate x = 0
cached coordinate y = 1e-06
cached coordinate z = 0
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e0/e0_3",
						  },
						  {
						   description => "What are the coordinates of the first point of the second contour ?",
						   read => "cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 1e-08
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e1/e1_0",
						  },
						  {
						   description => "What are the coordinates of the second point of the second contour ?",
						   read => "cached coordinate x = 1e-06
cached coordinate y = 0
cached coordinate z = 1e-08
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e1/e1_1",
						  },
						  {
						   description => "What are the coordinates of the third point of the second contour ?",
						   read => "cached coordinate x = 1e-06
cached coordinate y = 1e-06
cached coordinate z = 1e-08
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e1/e1_2",
						  },
						  {
						   description => "What are the coordinates of the fourth point of the second contour ?",
						   read => "cached coordinate x = 0
cached coordinate y = 1e-06
cached coordinate z = 1e-08
#coordinates : 10
",
						   timeout => 20,
						   write => "printcoordinates c /section1 /section1/e1/e1_3",
						  },
						 ],
				description => "EM contour coordinates",
			       },
			      ],
       description => "coordinate caching",
       name => 'coordinatecaching.t',
      };


return $test;


