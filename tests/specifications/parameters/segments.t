#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'tests/segments/soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/soma.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Does the soma have an unscaled capacitance ?",
						   read => '= 0.0164
',
						   write => "printparameter /soma CM",
						  },
						  {
						   description => "Does the soma have a scaled capacitance (should not) ?",
						   read => '= 1.79769e+308
',
						   write => "printparameterscaled /soma CM",
						  },
						  {
						   description => "Does the soma have an unscaled membrane resistance ?",
						   read => '= 1
',
						   write => "printparameter /soma RM",
						  },
						  {
						   description => "Does the soma have a scaled membrane resistance (should not) ?",
						   read => '= 1.79769e+308
',
						   write => "printparameterscaled /soma RM",
						  },
						  {
						   description => "Does the soma have an unscaled axial resistance ?",
						   read => '= 2.5
',
						   write => "printparameter /soma RA",
						  },
						  {
						   description => "Does the soma have a scaled axial resistance (should not) ?",
						   read => '= 1.79769e+308
',
						   write => "printparameterscaled /soma RA",
						  },
						 ],
				description => "parameter calculations on dendrites of the standard Purkinje cell model",
			       },
			      ],
       description => "segment parameter calculations and error signaling",
       name => 'parameters/segments.t',
      };


return $test;


