#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-h',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Has a help message been given ?",
						   read => [
							    '-re',
							    '.*?convertors/morphology2ndf <options> <genesis .p file | .swc file>

.*?convertors/morphology2ndf: convert morphology files to neurospaces morphology files.

options :
    force-library      force the use of library values, ignoring command line options.
    help               print usage information.
    input-format-list  list all input formats and exit.
    output-format      output format, default is \'ndf\'.
    output-format-list list all output formats and exit.
    prototypes         prototype configuration \(filename or code\).
    show-configuration show the configuration after applying morphology logic and exit.
    show-library       show the library with specific settings for each morphology.
    shrinkage          shrinkage correction factor \(1 is default\)
    soma-offset        apply soma offset to all compartments \(puts the soma at the origin\)
    spine-prototypes   add spines with this prototype.
    no-use-library     do not use the library with specific settings for each morphology.
    verbose            set verbosity level.
    yaml               yaml output instead of ndf.
',
							   ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "help message",
			       },
			       {
				arguments => [
					      '/tmp/neurospaces/test/models/morphologies/Purk2M9s.p',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   comment => ('When using regexes, gives a SEGV, aha.  Presumably related to Expect and regexes.  Solution: check manually from time to time, or replace the regexes with something else.  '
							       . "When using regexes, regex backtracking makes this test run really slow.  "
							       . "Right now, the test only checks for a part of the output, without using regexes."
							       . "Question: does this test use the morphology2ndf.yml library installed on my laptop, seems so, but shouldn't."),
						   description => "Can the Purkinje cell morphology file, taken from the Genesis Purkinje cell tutorial, be converted and activated ?",
						   read => 'NEUROSPACES NDF

IMPORT

	FILE a "segments/spines/purkinje.ndf"
	FILE b "segments/purkinje/maind.ndf"
	FILE c "segments/purkinje/soma.ndf"
	FILE d "segments/purkinje/spinyd.ndf"
	FILE e "segments/purkinje/thickd.ndf"

END IMPORT


PRIVATE_MODELS

	ALIAS a::/Purk_spine Purk_spine END ALIAS
	ALIAS b::/maind maind END ALIAS
	ALIAS c::/soma soma END ALIAS
	ALIAS d::/spinyd spinyd END ALIAS
	ALIAS e::/thickd thickd END ALIAS

END PRIVATE_MODELS


PUBLIC_MODELS

	CELL Purk2M9s
	
		ALGORITHM Spines
			Spines__0__Purk_spine
			PARAMETERS
				PARAMETER ( PROTOTYPE = "Purk_spine" ),
				PARAMETER ( DIA_MIN = 0.00 ),
				PARAMETER ( DIA_MAX = 3.18 ),
				PARAMETER ( SPINE_DENSITY = 13.0 ),
				PARAMETER ( SPINE_FREQUENCY = 1.0 ),
			END PARAMETERS
		END ALGORITHM

		SEGMENT_GROUP segments

			CHILD soma soma
				PARAMETERS
			
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 29.80e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/soma ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 9.447e-6 ),
					PARAMETER ( rel_Z = 9.447e-6 ),
					PARAMETER ( DIA = 7.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[0] ),
					PARAMETER ( rel_X = 8.426e-6 ),
					PARAMETER ( rel_Y = 1.124e-6 ),
					PARAMETER ( rel_Z = 21.909e-6 ),
					PARAMETER ( DIA = 8.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.666e-6 ),
					PARAMETER ( DIA = 8.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 9.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[3] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 6.109e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 8.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[4] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 8.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[5] ),
					PARAMETER ( rel_X = -1.749e-6 ),
					PARAMETER ( rel_Y = 0.583e-6 ),
					PARAMETER ( rel_Z = 3.498e-6 ),
					PARAMETER ( DIA = 8.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[6] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 3.334e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 7.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[7] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 9.441e-6 ),
					PARAMETER ( DIA = 8.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind br1[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[8] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 7.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[0] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[1] ),
					PARAMETER ( rel_X = -13.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 5.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[2] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 4.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[3] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 3.335e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[4] ),
					PARAMETER ( rel_X = -8.330e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[5] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[6] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 5.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[7] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 6.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[8] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 3.888e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[9] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 1.665e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[10] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.336e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[11] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.334e-6 ),
					PARAMETER ( DIA = 5.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[12] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 3.338e-6 ),
					PARAMETER ( DIA = 5.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[13] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[14] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 13.888e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[15] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.329e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[16] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 8.890e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[17] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 7.219e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[18] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[19] ),
					PARAMETER ( rel_X = -6.111e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind br2[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[8] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 7.776e-6 ),
					PARAMETER ( rel_Z = 8.887e-6 ),
					PARAMETER ( DIA = 8.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[0] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[1] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[3] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[4] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[5] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 11.114e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[6] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[7] ),
					PARAMETER ( rel_X = 6.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 11.668e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[8] ),
					PARAMETER ( rel_X = 13.330e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 9.442e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[9] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[10] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[11] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[12] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[13] ),
					PARAMETER ( rel_X = 6.666e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[14] ),
					PARAMETER ( rel_X = 7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.556e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[15] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[16] ),
					PARAMETER ( rel_X = -5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.887e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[17] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.222e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[18] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[19] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[20] ),
					PARAMETER ( rel_X = -2.868e-6 ),
					PARAMETER ( rel_Y = -0.319e-6 ),
					PARAMETER ( rel_Z = 0.956e-6 ),
					PARAMETER ( DIA = 4.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[6] ),
					PARAMETER ( rel_X = -7.223e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[0] ),
					PARAMETER ( rel_X = -7.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[1] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 4.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[2] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 6.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[4] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[5] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 3.333e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[6] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 4.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 4.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[8] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.669e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 5.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[10] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = 9.998e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[11] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 9.440e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[12] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[13] ),
					PARAMETER ( rel_X = 10.094e-6 ),
					PARAMETER ( rel_Y = -0.561e-6 ),
					PARAMETER ( rel_Z = 11.776e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[14] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 5.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[15] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 2.779e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 6.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s01[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[1] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[0] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[1] ),
					PARAMETER ( rel_X = 3.892e-6 ),
					PARAMETER ( rel_Y = -1.668e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[2] ),
					PARAMETER ( rel_X = 1.151e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.356e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[3] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[4] ),
					PARAMETER ( rel_X = -2.432e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.824e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[5] ),
					PARAMETER ( rel_X = -9.438e-6 ),
					PARAMETER ( rel_Y = 1.180e-6 ),
					PARAMETER ( rel_Z = 0.590e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[5] ),
					PARAMETER ( rel_X = 0.907e-6 ),
					PARAMETER ( rel_Y = 0.907e-6 ),
					PARAMETER ( rel_Z = -3.630e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[7] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.050e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[9] ),
					PARAMETER ( rel_X = -16.009e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.606e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.109e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[11] ),
					PARAMETER ( rel_X = -2.226e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.113e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[12] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[12] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[14] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[15] ),
					PARAMETER ( rel_X = -8.055e-6 ),
					PARAMETER ( rel_Y = -1.151e-6 ),
					PARAMETER ( rel_Z = -8.055e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[15] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[17] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[18] ),
					PARAMETER ( rel_X = 0.680e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.762e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[11] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[20] ),
					PARAMETER ( rel_X = 1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[21] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[4] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[23] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[24] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[25] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[26] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[25] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[28] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[29] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[3] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[31] ),
					PARAMETER ( rel_X = 6.271e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.841e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[32] ),
					PARAMETER ( rel_X = -6.155e-6 ),
					PARAMETER ( rel_Y = -0.560e-6 ),
					PARAMETER ( rel_Z = -22.382e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[32] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[34] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[35] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[36] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[37] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[31] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[39] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[40] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[41] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[42] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[43] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s02[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[2] ),
					PARAMETER ( rel_X = 9.998e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[0] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[1] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[3] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[4] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[5] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[6] ),
					PARAMETER ( rel_X = 1.125e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.189e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[5] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[8] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[9] ),
					PARAMETER ( rel_X = 4.711e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.478e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[4] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[11] ),
					PARAMETER ( rel_X = 12.475e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.701e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[12] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[13] ),
					PARAMETER ( rel_X = 11.113e-6 ),
					PARAMETER ( rel_Y = 1.235e-6 ),
					PARAMETER ( rel_Z = -12.965e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[1] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[15] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 2.221e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[16] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[17] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[15] ),
					PARAMETER ( rel_X = 0.554e-6 ),
					PARAMETER ( rel_Y = 0.554e-6 ),
					PARAMETER ( rel_Z = 0.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[19] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[20] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[21] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[22] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[23] ),
					PARAMETER ( rel_X = -2.246e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.666e-6 ),
					PARAMETER ( DIA = 1.30e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[24] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[24] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[26] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[22] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[28] ),
					PARAMETER ( rel_X = 12.680e-6 ),
					PARAMETER ( rel_Y = -0.576e-6 ),
					PARAMETER ( rel_Z = -5.763e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[19] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[30] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[31] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[32] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[33] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[34] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[35] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[36] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[37] ),
					PARAMETER ( rel_X = 6.225e-6 ),
					PARAMETER ( rel_Y = 1.245e-6 ),
					PARAMETER ( rel_Z = 3.112e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[38] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[38] ),
					PARAMETER ( rel_X = 1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[40] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[41] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[42] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[43] ),
					PARAMETER ( rel_X = 8.353e-6 ),
					PARAMETER ( rel_Y = 1.671e-6 ),
					PARAMETER ( rel_Z = 3.341e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[43] ),
					PARAMETER ( rel_X = 27.278e-6 ),
					PARAMETER ( rel_Y = 2.098e-6 ),
					PARAMETER ( rel_Z = -9.093e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[45] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[46] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[46] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[42] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[49] ),
					PARAMETER ( rel_X = 2.332e-6 ),
					PARAMETER ( rel_Y = 1.166e-6 ),
					PARAMETER ( rel_Z = -11.077e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[50] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[50] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -4.444e-6 ),
					PARAMETER ( rel_Z = -7.222e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[52] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[53] ),
					PARAMETER ( rel_X = 13.991e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.276e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[53] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[55] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[41] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[37] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[58] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[59] ),
					PARAMETER ( rel_X = 9.003e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.688e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[60] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[61] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[62] ),
					PARAMETER ( rel_X = 19.199e-6 ),
					PARAMETER ( rel_Y = 1.694e-6 ),
					PARAMETER ( rel_Z = -6.776e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[62] ),
					PARAMETER ( rel_X = 29.097e-6 ),
					PARAMETER ( rel_Y = 0.606e-6 ),
					PARAMETER ( rel_Z = -5.456e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[58] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[65] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[66] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[67] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[68] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[69] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[70] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[71] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[70] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[73] ),
					PARAMETER ( rel_X = -5.839e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.595e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[68] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[75] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[75] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[77] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = -6.114e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[77] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[79] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[79] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[67] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = -3.335e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[82] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[83] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[82] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[85] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[86] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[87] ),
					PARAMETER ( rel_X = 9.180e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[66] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[89] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.442e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[90] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[91] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[92] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[93] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[94] ),
					PARAMETER ( rel_X = -4.715e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.072e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[95] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[95] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.776e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[93] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[98] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[99] ),
					PARAMETER ( rel_X = 3.331e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[90] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[101] ),
					PARAMETER ( rel_X = 9.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[36] ),
					PARAMETER ( rel_X = 0.540e-6 ),
					PARAMETER ( rel_Y = -0.540e-6 ),
					PARAMETER ( rel_Z = 2.159e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[103] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[104] ),
					PARAMETER ( rel_X = 11.148e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.279e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[104] ),
					PARAMETER ( rel_X = 7.776e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[106] ),
					PARAMETER ( rel_X = 24.430e-6 ),
					PARAMETER ( rel_Y = 1.163e-6 ),
					PARAMETER ( rel_Z = -2.908e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[107] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[107] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[109] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[106] ),
					PARAMETER ( rel_X = 5.553e-6 ),
					PARAMETER ( rel_Y = 2.221e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[111] ),
					PARAMETER ( rel_X = 10.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[112] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[113] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[112] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[115] ),
					PARAMETER ( rel_X = 5.200e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.900e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[111] ),
					PARAMETER ( rel_X = 5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[33] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[118] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[119] ),
					PARAMETER ( rel_X = 8.533e-6 ),
					PARAMETER ( rel_Y = -0.569e-6 ),
					PARAMETER ( rel_Z = 2.276e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[120] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[121] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[122] ),
					PARAMETER ( rel_X = 7.218e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[123] ),
					PARAMETER ( rel_X = 9.129e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.282e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[124] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[125] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[126] ),
					PARAMETER ( rel_X = 2.879e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.485e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[124] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[128] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[129] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[130] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[131] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[131] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[133] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[133] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[135] ),
					PARAMETER ( rel_X = 12.372e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.302e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[128] ),
					PARAMETER ( rel_X = 6.113e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[137] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[138] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.335e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[139] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[140] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[141] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 3.892e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[142] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[143] ),
					PARAMETER ( rel_X = 3.089e-6 ),
					PARAMETER ( rel_Y = 0.618e-6 ),
					PARAMETER ( rel_Z = -5.560e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[140] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[145] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[146] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[146] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[138] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[149] ),
					PARAMETER ( rel_X = 11.242e-6 ),
					PARAMETER ( rel_Y = 0.562e-6 ),
					PARAMETER ( rel_Z = 0.562e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[150] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[151] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[151] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[153] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[154] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[156]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[150] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[157]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[156] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[158]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[157] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[159]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[157] ),
					PARAMETER ( rel_X = 6.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[160]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[137] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[161]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[160] ),
					PARAMETER ( rel_X = 2.781e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.118e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[162]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[161] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[163]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[162] ),
					PARAMETER ( rel_X = -7.830e-6 ),
					PARAMETER ( rel_Y = 1.119e-6 ),
					PARAMETER ( rel_Z = -6.152e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[164]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[163] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[165]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[163] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[166]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[165] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[167]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[162] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[168]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[167] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[169]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[168] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[170]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[169] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[171]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[169] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[172]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[171] ),
					PARAMETER ( rel_X = 7.392e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.848e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[173]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[161] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[174]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[173] ),
					PARAMETER ( rel_X = 8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[175]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[174] ),
					PARAMETER ( rel_X = 4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[176]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[175] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[177]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[176] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[178]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[174] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[179]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[178] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[180]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[179] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[181]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[180] ),
					PARAMETER ( rel_X = -3.892e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[182]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[181] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[183]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[181] ),
					PARAMETER ( rel_X = 1.849e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -22.183e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[184]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[180] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[185]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[184] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.557e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[5] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 5.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[0] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[2] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[2] ),
					PARAMETER ( rel_X = -0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[4] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[5] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[4] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[7] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[8] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -6.663e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[9] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[10] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[11] ),
					PARAMETER ( rel_X = -17.021e-6 ),
					PARAMETER ( rel_Y = 0.567e-6 ),
					PARAMETER ( rel_Z = -16.453e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[12] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[13] ),
					PARAMETER ( rel_X = -1.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[14] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[13] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[16] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[17] ),
					PARAMETER ( rel_X = -8.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[10] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[19] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[20] ),
					PARAMETER ( rel_X = 18.003e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 4.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[21] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[21] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[23] ),
					PARAMETER ( rel_X = 7.249e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.558e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[24] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[25] ),
					PARAMETER ( rel_X = -1.203e-6 ),
					PARAMETER ( rel_Y = 0.602e-6 ),
					PARAMETER ( rel_Z = -5.415e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[23] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[27] ),
					PARAMETER ( rel_X = 7.800e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.557e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[20] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[29] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[29] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[31] ),
					PARAMETER ( rel_X = -6.731e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.116e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[31] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[33] ),
					PARAMETER ( rel_X = -4.412e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.042e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[33] ),
					PARAMETER ( rel_X = -11.185e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.915e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[35] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[35] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[8] ),
					PARAMETER ( rel_X = -7.219e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[38] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[39] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[40] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[41] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[39] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[43] ),
					PARAMETER ( rel_X = -11.739e-6 ),
					PARAMETER ( rel_Y = -1.174e-6 ),
					PARAMETER ( rel_Z = -24.652e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[44] ),
					PARAMETER ( rel_X = 2.950e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.080e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[45] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[46] ),
					PARAMETER ( rel_X = 0.678e-6 ),
					PARAMETER ( rel_Y = -4.749e-6 ),
					PARAMETER ( rel_Z = -4.749e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[47] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[47] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[44] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[50] ),
					PARAMETER ( rel_X = -12.934e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.937e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[50] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[52] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[1] ),
					PARAMETER ( rel_X = -5.002e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[54] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[55] ),
					PARAMETER ( rel_X = -17.217e-6 ),
					PARAMETER ( rel_Y = 1.722e-6 ),
					PARAMETER ( rel_Z = -5.739e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[56] ),
					PARAMETER ( rel_X = -0.574e-6 ),
					PARAMETER ( rel_Y = -1.722e-6 ),
					PARAMETER ( rel_Z = -11.477e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[57] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[58] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[59] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[59] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[61] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[61] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.893e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[57] ),
					PARAMETER ( rel_X = 0.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[56] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[65] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[66] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[65] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[68] ),
					PARAMETER ( rel_X = -18.501e-6 ),
					PARAMETER ( rel_Y = -0.578e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s04[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[6] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[0] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 7.221e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[1] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[2] ),
					PARAMETER ( rel_X = 2.226e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[3] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[4] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[4] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[2] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[7] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[8] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[8] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[10] ),
					PARAMETER ( rel_X = -6.720e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 6.720e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[10] ),
					PARAMETER ( rel_X = 10.136e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.702e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[7] ),
					PARAMETER ( rel_X = -15.599e-6 ),
					PARAMETER ( rel_Y = 1.733e-6 ),
					PARAMETER ( rel_Z = -1.733e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[13] ),
					PARAMETER ( rel_X = -8.522e-6 ),
					PARAMETER ( rel_Y = 0.609e-6 ),
					PARAMETER ( rel_Z = -1.217e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[14] ),
					PARAMETER ( rel_X = -16.190e-6 ),
					PARAMETER ( rel_Y = -0.558e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[15] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[14] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[17] ),
					PARAMETER ( rel_X = -7.842e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 5.042e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[18] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[18] ),
					PARAMETER ( rel_X = -1.183e-6 ),
					PARAMETER ( rel_Y = -1.775e-6 ),
					PARAMETER ( rel_Z = 10.648e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[13] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[21] ),
					PARAMETER ( rel_X = 7.805e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 13.380e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[22] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[23] ),
					PARAMETER ( rel_X = -10.687e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.695e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[22] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[25] ),
					PARAMETER ( rel_X = -1.676e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.146e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[26] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[27] ),
					PARAMETER ( rel_X = -10.006e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 19.345e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[26] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[0] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[30] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[31] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[32] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[33] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[34] ),
					PARAMETER ( rel_X = -1.858e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.527e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[35] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[36] ),
					PARAMETER ( rel_X = -3.872e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.518e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[37] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[36] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[39] ),
					PARAMETER ( rel_X = 2.283e-6 ),
					PARAMETER ( rel_Y = 0.571e-6 ),
					PARAMETER ( rel_Z = 13.699e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[34] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[41] ),
					PARAMETER ( rel_X = 6.667e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[31] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[43] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[44] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[45] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[46] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[47] ),
					PARAMETER ( rel_X = -1.275e-6 ),
					PARAMETER ( rel_Y = -0.637e-6 ),
					PARAMETER ( rel_Z = -21.673e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[48] ),
					PARAMETER ( rel_X = -1.701e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.940e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[49] ),
					PARAMETER ( rel_X = -2.404e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.410e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[49] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[51] ),
					PARAMETER ( rel_X = 7.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.380e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[48] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[53] ),
					PARAMETER ( rel_X = 17.363e-6 ),
					PARAMETER ( rel_Y = -3.858e-6 ),
					PARAMETER ( rel_Z = 3.858e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[53] ),
					PARAMETER ( rel_X = 17.421e-6 ),
					PARAMETER ( rel_Y = -2.323e-6 ),
					PARAMETER ( rel_Z = -5.807e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[47] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[46] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[43] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[58] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 2.224e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[59] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.003e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[59] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[61] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.560e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[58] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[63] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[63] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 3.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[65] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[66] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[67] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[67] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[69] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[69] ),
					PARAMETER ( rel_X = 5.559e-6 ),
					PARAMETER ( rel_Y = 2.224e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[71] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[72] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[71] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[74] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[75] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[75] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[65] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 3.334e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 3.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[78] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[79] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[80] ),
					PARAMETER ( rel_X = 15.919e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.948e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[80] ),
					PARAMETER ( rel_X = 18.408e-6 ),
					PARAMETER ( rel_Y = 1.227e-6 ),
					PARAMETER ( rel_Z = 1.841e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[78] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[83] ),
					PARAMETER ( rel_X = 11.480e-6 ),
					PARAMETER ( rel_Y = 2.870e-6 ),
					PARAMETER ( rel_Z = 7.462e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[84] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[85] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[86] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.480e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[87] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[85] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[89] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[90] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[91] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[92] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[93] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[94] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.560e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[95] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[96] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[97] ),
					PARAMETER ( rel_X = -1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[97] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[94] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[100] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[101] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[101] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[103] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[104] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[105] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[106] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[106] ),
					PARAMETER ( rel_X = -13.673e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.406e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[91] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[109] ),
					PARAMETER ( rel_X = 18.315e-6 ),
					PARAMETER ( rel_Y = 0.572e-6 ),
					PARAMETER ( rel_Z = -1.145e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[110] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -2.775e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[111] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[111] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[113] ),
					PARAMETER ( rel_X = 26.429e-6 ),
					PARAMETER ( rel_Y = 2.349e-6 ),
					PARAMETER ( rel_Z = 0.587e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[114] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[109] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[116] ),
					PARAMETER ( rel_X = 8.374e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.675e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[117] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.557e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[117] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[90] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[120] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[121] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[122] ),
					PARAMETER ( rel_X = -0.575e-6 ),
					PARAMETER ( rel_Y = 1.150e-6 ),
					PARAMETER ( rel_Z = 18.405e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[122] ),
					PARAMETER ( rel_X = 5.603e-6 ),
					PARAMETER ( rel_Y = 1.121e-6 ),
					PARAMETER ( rel_Z = 15.127e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[121] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[125] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[126] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[127] ),
					PARAMETER ( rel_X = 7.782e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.226e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[128] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[129] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[130] ),
					PARAMETER ( rel_X = 13.278e-6 ),
					PARAMETER ( rel_Y = 0.577e-6 ),
					PARAMETER ( rel_Z = 2.886e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[131] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[132] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[133] ),
					PARAMETER ( rel_X = 15.197e-6 ),
					PARAMETER ( rel_Y = 0.563e-6 ),
					PARAMETER ( rel_Z = 6.754e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[129] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[135] ),
					PARAMETER ( rel_X = -7.224e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[135] ),
					PARAMETER ( rel_X = -0.627e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.409e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[137] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[138] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[126] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[140] ),
					PARAMETER ( rel_X = 12.236e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.899e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[141] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[141] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[143] ),
					PARAMETER ( rel_X = 21.421e-6 ),
					PARAMETER ( rel_Y = 4.632e-6 ),
					PARAMETER ( rel_Z = 3.474e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[140] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = 3.890e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[145] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.666e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[146] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[147] ),
					PARAMETER ( rel_X = 14.259e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.753e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[145] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[149] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[150] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[151] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[152] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[153] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[153] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s05[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[0] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[0] ),
					PARAMETER ( rel_X = -11.749e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.951e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[1] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[2] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[1] ),
					PARAMETER ( rel_X = -7.774e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[4] ),
					PARAMETER ( rel_X = -7.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[4] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s06[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[2] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[0] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[1] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[2] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[4] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[5] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[6] ),
					PARAMETER ( rel_X = 4.752e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.752e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[7] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[2] ),
					PARAMETER ( rel_X = -3.338e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = -1.113e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[9] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[10] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[11] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[12] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[13] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[13] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[15] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[11] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 1.109e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[17] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[18] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[19] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.120e-6 ),
					PARAMETER ( rel_Z = -5.599e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[20] ),
					PARAMETER ( rel_X = -3.633e-6 ),
					PARAMETER ( rel_Y = 1.211e-6 ),
					PARAMETER ( rel_Z = -12.716e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[21] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[22] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[23] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[23] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[21] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[26] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.109e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[27] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[28] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[29] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[27] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[31] ),
					PARAMETER ( rel_X = -2.257e-6 ),
					PARAMETER ( rel_Y = -0.564e-6 ),
					PARAMETER ( rel_Z = -6.771e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[32] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[32] ),
					PARAMETER ( rel_X = -1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[34] ),
					PARAMETER ( rel_X = -17.342e-6 ),
					PARAMETER ( rel_Y = -1.196e-6 ),
					PARAMETER ( rel_Z = -13.156e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[34] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = -7.781e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[36] ),
					PARAMETER ( rel_X = 9.460e-6 ),
					PARAMETER ( rel_Y = -1.183e-6 ),
					PARAMETER ( rel_Z = -11.825e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[36] ),
					PARAMETER ( rel_X = -7.458e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.031e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[20] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[39] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[40] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[40] ),
					PARAMETER ( rel_X = -2.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.562e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[42] ),
					PARAMETER ( rel_X = -17.535e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.485e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[42] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[44] ),
					PARAMETER ( rel_X = -6.762e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.016e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[45] ),
					PARAMETER ( rel_X = -8.893e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[46] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[46] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[45] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[49] ),
					PARAMETER ( rel_X = -7.840e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.480e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[50] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[51] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[50] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[53] ),
					PARAMETER ( rel_X = -12.887e-6 ),
					PARAMETER ( rel_Y = -0.586e-6 ),
					PARAMETER ( rel_Z = -7.615e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[18] ),
					PARAMETER ( rel_X = -5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[55] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[56] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[57] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[58] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[59] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[60] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[61] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[62] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[58] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[64] ),
					PARAMETER ( rel_X = -12.284e-6 ),
					PARAMETER ( rel_Y = -1.117e-6 ),
					PARAMETER ( rel_Z = -8.376e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[65] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[66] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[67] ),
					PARAMETER ( rel_X = -2.954e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.089e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[68] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[69] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[69] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[65] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[72] ),
					PARAMETER ( rel_X = 2.617e-6 ),
					PARAMETER ( rel_Y = 0.654e-6 ),
					PARAMETER ( rel_Z = -3.271e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[73] ),
					PARAMETER ( rel_X = 5.028e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = -2.234e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[73] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[75] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[76] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[77] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[78] ),
					PARAMETER ( rel_X = -1.158e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.213e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[76] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[80] ),
					PARAMETER ( rel_X = -2.833e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.500e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[72] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[56] ),
					PARAMETER ( rel_X = -6.666e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[83] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[84] ),
					PARAMETER ( rel_X = -11.896e-6 ),
					PARAMETER ( rel_Y = -0.595e-6 ),
					PARAMETER ( rel_Z = -12.491e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[84] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[86] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[87] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[88] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[89] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[90] ),
					PARAMETER ( rel_X = 17.277e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.942e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[89] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[92] ),
					PARAMETER ( rel_X = -7.419e-6 ),
					PARAMETER ( rel_Y = -1.141e-6 ),
					PARAMETER ( rel_Z = -5.707e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[93] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[94] ),
					PARAMETER ( rel_X = -0.603e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -21.101e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[88] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[96] ),
					PARAMETER ( rel_X = -8.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[97] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[97] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[99] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[100] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[99] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[102] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[103] ),
					PARAMETER ( rel_X = -19.763e-6 ),
					PARAMETER ( rel_Y = -2.044e-6 ),
					PARAMETER ( rel_Z = 9.541e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[103] ),
					PARAMETER ( rel_X = 1.199e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.595e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[102] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[17] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[107] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[108] ),
					PARAMETER ( rel_X = -6.115e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[109] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[110] ),
					PARAMETER ( rel_X = -11.840e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.947e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[111] ),
					PARAMETER ( rel_X = 6.325e-6 ),
					PARAMETER ( rel_Y = 0.632e-6 ),
					PARAMETER ( rel_Z = 7.590e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[111] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[113] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[114] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[114] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[116] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[109] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[118] ),
					PARAMETER ( rel_X = -14.662e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.511e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[119] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[119] ),
					PARAMETER ( rel_X = -8.623e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.990e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[1] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[122] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[123] ),
					PARAMETER ( rel_X = -10.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[124] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.886e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[125] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[126] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[127] ),
					PARAMETER ( rel_X = -7.547e-6 ),
					PARAMETER ( rel_Y = 0.629e-6 ),
					PARAMETER ( rel_Z = 3.145e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[124] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[129] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[130] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[131] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[132] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[131] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = -1.113e-6 ),
					PARAMETER ( rel_Z = -2.226e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[129] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[135] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[135] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[137] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[138] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[139] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[140] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[139] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[142] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[143] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[143] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[137] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[146] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[147] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[148] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[149] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[150] ),
					PARAMETER ( rel_X = -5.745e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.319e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[151] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[152] ),
					PARAMETER ( rel_X = 12.437e-6 ),
					PARAMETER ( rel_Y = -0.592e-6 ),
					PARAMETER ( rel_Z = -21.321e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[151] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[154] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[156]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[155] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[157]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[156] ),
					PARAMETER ( rel_X = -7.387e-6 ),
					PARAMETER ( rel_Y = -0.568e-6 ),
					PARAMETER ( rel_Z = -2.273e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[158]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[157] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[159]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[158] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -6.107e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[160]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[158] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[161]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[160] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[162]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[161] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[163]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[149] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[164]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[163] ),
					PARAMETER ( rel_X = -1.113e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.226e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[165]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[163] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[166]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[165] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[167]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[166] ),
					PARAMETER ( rel_X = -11.971e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.420e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[168]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[166] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[169]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[168] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[170]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[169] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[171]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[170] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[172]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[171] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[173]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[172] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[174]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[173] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[175]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[173] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[176]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[170] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[177]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[176] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[178]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[177] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[179]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[177] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[180]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[179] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[181]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[168] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[182]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[181] ),
					PARAMETER ( rel_X = -0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[4] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 4.446e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[0] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[2] ),
					PARAMETER ( rel_X = -5.480e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.568e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[3] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[4] ),
					PARAMETER ( rel_X = -1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s08[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[5] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[0] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[2] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[3] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[3] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[5] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[6] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[7] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[8] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[10] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.229e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[10] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[8] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[13] ),
					PARAMETER ( rel_X = -10.621e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.118e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[6] ),
					PARAMETER ( rel_X = -10.553e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[2] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[16] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[17] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[18] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[18] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[17] ),
					PARAMETER ( rel_X = -3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[16] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[22] ),
					PARAMETER ( rel_X = -16.160e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 7.801e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[23] ),
					PARAMETER ( rel_X = -16.712e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.013e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s09[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[7] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 5.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[0] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[1] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[2] ),
					PARAMETER ( rel_X = -10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[3] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[3] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[5] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[5] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[7] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[7] ),
					PARAMETER ( rel_X = -9.137e-6 ),
					PARAMETER ( rel_Y = -0.571e-6 ),
					PARAMETER ( rel_Z = -2.855e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[0] ),
					PARAMETER ( rel_X = -8.894e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[10] ),
					PARAMETER ( rel_X = -11.669e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[11] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[12] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[13] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[14] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[15] ),
					PARAMETER ( rel_X = -3.364e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.652e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[16] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[17] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[16] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[19] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[20] ),
					PARAMETER ( rel_X = -1.188e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.754e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[21] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[22] ),
					PARAMETER ( rel_X = -7.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[22] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[20] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[25] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[26] ),
					PARAMETER ( rel_X = -15.012e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.896e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[26] ),
					PARAMETER ( rel_X = -22.344e-6 ),
					PARAMETER ( rel_Y = -0.621e-6 ),
					PARAMETER ( rel_Z = 5.586e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[12] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -4.441e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[29] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[11] ),
					PARAMETER ( rel_X = -10.002e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.446e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[31] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.219e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[32] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[31] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[34] ),
					PARAMETER ( rel_X = -16.830e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.161e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[35] ),
					PARAMETER ( rel_X = -16.163e-6 ),
					PARAMETER ( rel_Y = 0.703e-6 ),
					PARAMETER ( rel_Z = -9.136e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[35] ),
					PARAMETER ( rel_X = -7.379e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.270e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[37] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[38] ),
					PARAMETER ( rel_X = -11.672e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s10[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[8] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 5.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s10[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[0] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 3.333e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[2] ),
					PARAMETER ( rel_X = -7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[3] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[4] ),
					PARAMETER ( rel_X = -7.465e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.297e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[5] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[5] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[7] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[8] ),
					PARAMETER ( rel_X = -1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[7] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[10] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[11] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[12] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[12] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[14] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[10] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[16] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[16] ),
					PARAMETER ( rel_X = -8.333e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[18] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.557e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[18] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[3] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[21] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s10[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[0] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 3.331e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[23] ),
					PARAMETER ( rel_X = -8.955e-6 ),
					PARAMETER ( rel_Y = -0.560e-6 ),
					PARAMETER ( rel_Z = 3.358e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[24] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[25] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[26] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[26] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[24] ),
					PARAMETER ( rel_X = -8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[29] ),
					PARAMETER ( rel_X = -7.774e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[30] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[31] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[32] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[33] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[34] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[35] ),
					PARAMETER ( rel_X = 10.574e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.009e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[34] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[37] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[38] ),
					PARAMETER ( rel_X = -10.578e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.227e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[39] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.892e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[40] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[41] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.774e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[41] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[39] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[44] ),
					PARAMETER ( rel_X = -15.951e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.847e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[37] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[46] ),
					PARAMETER ( rel_X = -13.433e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.592e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[47] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[46] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[49] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[50] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[51] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[52] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[52] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[54] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[55] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[49] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[57] ),
					PARAMETER ( rel_X = -16.086e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.596e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[58] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[59] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[33] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[61] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[61] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[63] ),
					PARAMETER ( rel_X = 2.673e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.356e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[31] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[65] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[29] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.218e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[67] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[68] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.664e-6 ),
					PARAMETER ( rel_Z = 2.774e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[69] ),
					PARAMETER ( rel_X = -23.421e-6 ),
					PARAMETER ( rel_Y = 0.601e-6 ),
					PARAMETER ( rel_Z = 3.003e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[69] ),
					PARAMETER ( rel_X = -21.798e-6 ),
					PARAMETER ( rel_Y = 0.703e-6 ),
					PARAMETER ( rel_Z = 11.954e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[68] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[72] ),
					PARAMETER ( rel_X = -25.146e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.796e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[73] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[74] ),
					PARAMETER ( rel_X = -12.857e-6 ),
					PARAMETER ( rel_Y = 1.677e-6 ),
					PARAMETER ( rel_Z = -12.298e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[75] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.108e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[76] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[73] ),
					PARAMETER ( rel_X = -7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[78] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[79] ),
					PARAMETER ( rel_X = -9.219e-6 ),
					PARAMETER ( rel_Y = -1.152e-6 ),
					PARAMETER ( rel_Z = -1.729e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[80] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[80] ),
					PARAMETER ( rel_X = -18.402e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.968e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[79] ),
					PARAMETER ( rel_X = -9.061e-6 ),
					PARAMETER ( rel_Y = -0.566e-6 ),
					PARAMETER ( rel_Z = 6.229e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[83] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[83] ),
					PARAMETER ( rel_X = -6.355e-6 ),
					PARAMETER ( rel_Y = -1.271e-6 ),
					PARAMETER ( rel_Z = 13.981e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s11[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[0] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[1] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[2] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[1] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[4] ),
					PARAMETER ( rel_X = -6.764e-6 ),
					PARAMETER ( rel_Y = -0.564e-6 ),
					PARAMETER ( rel_Z = 16.347e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[5] ),
					PARAMETER ( rel_X = 2.226e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[6] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[5] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[8] ),
					PARAMETER ( rel_X = -4.078e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.980e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[9] ),
					PARAMETER ( rel_X = 5.822e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.136e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s12[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[12] ),
					PARAMETER ( rel_X = -12.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[0] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[1] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.329e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[2] ),
					PARAMETER ( rel_X = 2.306e-6 ),
					PARAMETER ( rel_Y = 1.153e-6 ),
					PARAMETER ( rel_Z = 21.335e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[1] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[4] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[5] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[6] ),
					PARAMETER ( rel_X = -4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[7] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[8] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[9] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.554e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[10] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[10] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[8] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[13] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[14] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[15] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[5] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[17] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[18] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 4.446e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[19] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[20] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[21] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[22] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[23] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[24] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[25] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[26] ),
					PARAMETER ( rel_X = -6.761e-6 ),
					PARAMETER ( rel_Y = 0.563e-6 ),
					PARAMETER ( rel_Z = 3.381e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[25] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[28] ),
					PARAMETER ( rel_X = -7.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[23] ),
					PARAMETER ( rel_X = -6.108e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[30] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[30] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[32] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[20] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[34] ),
					PARAMETER ( rel_X = -11.510e-6 ),
					PARAMETER ( rel_Y = -0.575e-6 ),
					PARAMETER ( rel_Z = 4.604e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[35] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.996e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[35] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[37] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[19] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[39] ),
					PARAMETER ( rel_X = -2.954e-6 ),
					PARAMETER ( rel_Y = 1.181e-6 ),
					PARAMETER ( rel_Z = 18.903e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[40] ),
					PARAMETER ( rel_X = -6.512e-6 ),
					PARAMETER ( rel_Y = 0.592e-6 ),
					PARAMETER ( rel_Z = 19.536e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[41] ),
					PARAMETER ( rel_X = -7.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[17] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 6.663e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[43] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[44] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[44] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[46] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[47] ),
					PARAMETER ( rel_X = 6.707e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.501e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[48] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[47] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[50] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[51] ),
					PARAMETER ( rel_X = -6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[51] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s13[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[13] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[0] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.889e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[2] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[0] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[4] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[5] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[6] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[7] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s14[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[14] ),
					PARAMETER ( rel_X = 3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[1] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[2] ),
					PARAMETER ( rel_X = 8.511e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.702e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[3] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[4] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[5] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[6] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[7] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[8] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[9] ),
					PARAMETER ( rel_X = 5.028e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.291e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[10] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[11] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[10] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[13] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[14] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[7] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[17] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[18] ),
					PARAMETER ( rel_X = 8.394e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 16.788e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[19] ),
					PARAMETER ( rel_X = 3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[20] ),
					PARAMETER ( rel_X = 5.041e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.931e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[21] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 7.218e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[22] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -1.665e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[19] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[24] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[25] ),
					PARAMETER ( rel_X = -4.447e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 4.447e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[26] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.891e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[27] ),
					PARAMETER ( rel_X = -9.477e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.690e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[28] ),
					PARAMETER ( rel_X = 2.234e-6 ),
					PARAMETER ( rel_Y = -1.117e-6 ),
					PARAMETER ( rel_Z = 10.054e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[29] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.998e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[30] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[30] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.001e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[32] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[29] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[34] ),
					PARAMETER ( rel_X = 1.146e-6 ),
					PARAMETER ( rel_Y = 0.573e-6 ),
					PARAMETER ( rel_Z = 15.477e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[28] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[36] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[37] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 10.001e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[38] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 8.885e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[27] ),
					PARAMETER ( rel_X = 2.781e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[40] ),
					PARAMETER ( rel_X = 6.244e-6 ),
					PARAMETER ( rel_Y = 0.568e-6 ),
					PARAMETER ( rel_Z = 15.327e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[41] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[16] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[0] ),
					PARAMETER ( rel_X = -10.034e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.592e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[0] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[2] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[3] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[2] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[5] ),
					PARAMETER ( rel_X = -9.267e-6 ),
					PARAMETER ( rel_Y = -0.579e-6 ),
					PARAMETER ( rel_Z = 2.317e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[5] ),
					PARAMETER ( rel_X = -10.014e-6 ),
					PARAMETER ( rel_Y = 0.626e-6 ),
					PARAMETER ( rel_Z = -3.129e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s16[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[17] ),
					PARAMETER ( rel_X = -6.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s16[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s16[0] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s16[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s16[1] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s17[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[18] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s17[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s17[0] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s18[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[19] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[20] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[0] ),
					PARAMETER ( rel_X = -4.446e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[3] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[4] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[5] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[6] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[7] ),
					PARAMETER ( rel_X = -3.892e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[8] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[9] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 1.109e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[10] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[11] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.220e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[10] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[13] ),
					PARAMETER ( rel_X = -2.084e-6 ),
					PARAMETER ( rel_Y = 0.695e-6 ),
					PARAMETER ( rel_Z = -7.641e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[13] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[15] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[15] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[17] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[18] ),
					PARAMETER ( rel_X = -10.050e-6 ),
					PARAMETER ( rel_Y = 0.558e-6 ),
					PARAMETER ( rel_Z = -5.583e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[19] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[19] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[21] ),
					PARAMETER ( rel_X = -6.115e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[18] ),
					PARAMETER ( rel_X = -10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[23] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.781e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[7] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[25] ),
					PARAMETER ( rel_X = -5.002e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 5.002e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[26] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[27] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[28] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.892e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[3] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[30] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[31] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[32] ),
					PARAMETER ( rel_X = -11.316e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.263e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[33] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[34] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[35] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[36] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[36] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 10.551e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[38] ),
					PARAMETER ( rel_X = -15.568e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.896e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[38] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[40] ),
					PARAMETER ( rel_X = -6.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[41] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[20] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[0] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[1] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[3] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[4] ),
					PARAMETER ( rel_X = -8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[5] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.218e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[4] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[7] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[8] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[8] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.224e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[11] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[11] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.336e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[13] ),
					PARAMETER ( rel_X = 1.494e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.215e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[0] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[15] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[16] ),
					PARAMETER ( rel_X = -8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[17] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.001e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[15] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[19] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.218e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[19] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s21[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[1] ),
					PARAMETER ( rel_X = 7.219e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[0] ),
					PARAMETER ( rel_X = 8.794e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.676e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[2] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[3] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[3] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[1] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[6] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[7] ),
					PARAMETER ( rel_X = 4.646e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -17.421e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[8] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.329e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[7] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[10] ),
					PARAMETER ( rel_X = 5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[11] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[12] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[13] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[14] ),
					PARAMETER ( rel_X = -7.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.026e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[13] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.109e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[16] ),
					PARAMETER ( rel_X = -5.859e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.445e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[11] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[18] ),
					PARAMETER ( rel_X = 4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[19] ),
					PARAMETER ( rel_X = 3.441e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.322e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[19] ),
					PARAMETER ( rel_X = 1.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[21] ),
					PARAMETER ( rel_X = 9.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[21] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[23] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.335e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s22[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[2] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[0] ),
					PARAMETER ( rel_X = -20.534e-6 ),
					PARAMETER ( rel_Y = -0.587e-6 ),
					PARAMETER ( rel_Z = 15.840e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[1] ),
					PARAMETER ( rel_X = -15.097e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = -1.677e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[2] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[3] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[1] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[5] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[6] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[6] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[5] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[9] ),
					PARAMETER ( rel_X = -16.250e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[10] ),
					PARAMETER ( rel_X = -4.360e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.966e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[9] ),
					PARAMETER ( rel_X = -14.731e-6 ),
					PARAMETER ( rel_Y = 1.281e-6 ),
					PARAMETER ( rel_Z = 16.653e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s23[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[3] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[0] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[1] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[2] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[2] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[5] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[6] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[7] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[9] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[10] ),
					PARAMETER ( rel_X = 5.611e-6 ),
					PARAMETER ( rel_Y = 0.561e-6 ),
					PARAMETER ( rel_Z = 6.172e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[11] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[12] ),
					PARAMETER ( rel_X = 9.402e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.655e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[11] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[14] ),
					PARAMETER ( rel_X = 18.018e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[14] ),
					PARAMETER ( rel_X = 3.915e-6 ),
					PARAMETER ( rel_Y = 1.119e-6 ),
					PARAMETER ( rel_Z = 10.068e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[9] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[17] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[18] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[19] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[1] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[21] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[22] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[23] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[24] ),
					PARAMETER ( rel_X = 7.243e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.601e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[21] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[26] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s24[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[4] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[0] ),
					PARAMETER ( rel_X = -8.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[1] ),
					PARAMETER ( rel_X = -6.034e-6 ),
					PARAMETER ( rel_Y = -0.603e-6 ),
					PARAMETER ( rel_Z = 9.654e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[3] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.222e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[2] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[5] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 10.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s25[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[8] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s25[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[1] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 8.336e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[2] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[3] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[2] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 14.444e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[5] ),
					PARAMETER ( rel_X = 10.642e-6 ),
					PARAMETER ( rel_Y = -2.504e-6 ),
					PARAMETER ( rel_Z = 18.780e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[6] ),
					PARAMETER ( rel_X = 5.400e-6 ),
					PARAMETER ( rel_Y = 3.000e-6 ),
					PARAMETER ( rel_Z = 19.200e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[7] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[5] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[9] ),
					PARAMETER ( rel_X = 5.284e-6 ),
					PARAMETER ( rel_Y = -1.761e-6 ),
					PARAMETER ( rel_Z = 9.393e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[0] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[11] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[12] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[13] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[13] ),
					PARAMETER ( rel_X = 7.777e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[15] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.113e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[15] ),
					PARAMETER ( rel_X = 7.700e-6 ),
					PARAMETER ( rel_Y = 2.200e-6 ),
					PARAMETER ( rel_Z = 15.400e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[17] ),
					PARAMETER ( rel_X = 4.694e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.081e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[12] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.335e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[19] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[20] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[21] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = 5.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[19] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[23] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[24] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[24] ),
					PARAMETER ( rel_X = 7.264e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.881e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[26] ),
					PARAMETER ( rel_X = 4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.886e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[26] ),
					PARAMETER ( rel_X = 5.949e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 16.064e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[23] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.330e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[29] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[30] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 19.445e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[30] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[32] ),
					PARAMETER ( rel_X = -9.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[32] ),
					PARAMETER ( rel_X = 9.446e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.446e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s26[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[10] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.558e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[0] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[1] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[2] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[1] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[4] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[5] ),
					PARAMETER ( rel_X = 18.880e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.005e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[4] ),
					PARAMETER ( rel_X = 11.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[7] ),
					PARAMETER ( rel_X = 10.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[8] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[9] ),
					PARAMETER ( rel_X = 9.855e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.447e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[9] ),
					PARAMETER ( rel_X = 12.217e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[0] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[12] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[13] ),
					PARAMETER ( rel_X = 8.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[14] ),
					PARAMETER ( rel_X = 10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[13] ),
					PARAMETER ( rel_X = 8.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[16] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -11.114e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[17] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.560e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[18] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[18] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[16] ),
					PARAMETER ( rel_X = 7.219e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[21] ),
					PARAMETER ( rel_X = 17.495e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.997e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[22] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[22] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.779e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[12] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.329e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[25] ),
					PARAMETER ( rel_X = -12.096e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.456e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[26] ),
					PARAMETER ( rel_X = -7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[26] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[28] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[28] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[25] ),
					PARAMETER ( rel_X = 0.559e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.559e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[31] ),
					PARAMETER ( rel_X = -1.145e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -13.170e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[32] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[32] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[31] ),
					PARAMETER ( rel_X = 7.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.780e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s27[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[12] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[0] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[1] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[3] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[3] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[5] ),
					PARAMETER ( rel_X = 14.054e-6 ),
					PARAMETER ( rel_Y = -0.740e-6 ),
					PARAMETER ( rel_Z = -15.533e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[5] ),
					PARAMETER ( rel_X = 24.188e-6 ),
					PARAMETER ( rel_Y = -0.563e-6 ),
					PARAMETER ( rel_Z = -10.688e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[2] ),
					PARAMETER ( rel_X = 8.338e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[8] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.777e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[9] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[8] ),
					PARAMETER ( rel_X = 9.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[11] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[12] ),
					PARAMETER ( rel_X = 13.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.112e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[13] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[12] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[15] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[1] ),
					PARAMETER ( rel_X = 16.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 12.777e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[17] ),
					PARAMETER ( rel_X = 15.555e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[18] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -10.003e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[19] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[20] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.221e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[21] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[19] ),
					PARAMETER ( rel_X = 7.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[23] ),
					PARAMETER ( rel_X = 16.755e-6 ),
					PARAMETER ( rel_Y = 0.762e-6 ),
					PARAMETER ( rel_Z = -7.616e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[18] ),
					PARAMETER ( rel_X = 20.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[25] ),
					PARAMETER ( rel_X = 6.113e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[0] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[27] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.221e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[28] ),
					PARAMETER ( rel_X = 8.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[29] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[30] ),
					PARAMETER ( rel_X = 13.893e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 11.114e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[31] ),
					PARAMETER ( rel_X = 15.014e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[32] ),
					PARAMETER ( rel_X = 10.553e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[31] ),
					PARAMETER ( rel_X = 10.003e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[29] ),
					PARAMETER ( rel_X = 12.779e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[35] ),
					PARAMETER ( rel_X = 9.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[36] ),
					PARAMETER ( rel_X = 14.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[37] ),
					PARAMETER ( rel_X = 9.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 9.446e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[38] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.554e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[38] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 14.996e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[40] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[36] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[42] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.227e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[43] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[44] ),
					PARAMETER ( rel_X = 7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.113e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[28] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 19.444e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[46] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 11.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s28[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[15] ),
					PARAMETER ( rel_X = 10.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[0] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = -2.221e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[1] ),
					PARAMETER ( rel_X = 17.227e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.780e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[2] ),
					PARAMETER ( rel_X = 8.334e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.112e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[3] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[2] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 13.890e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[5] ),
					PARAMETER ( rel_X = 14.442e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 8.332e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[6] ),
					PARAMETER ( rel_X = 12.221e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[1] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.218e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[8] ),
					PARAMETER ( rel_X = 8.336e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[9] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 12.219e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[11] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.333e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[12] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[13] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[13] ),
					PARAMETER ( rel_X = 9.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[10] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 20.554e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[16] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.328e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[8] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 17.220e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[18] ),
					PARAMETER ( rel_X = 9.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 14.996e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[19] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s29[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[16] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 10.004e-6 ),
					PARAMETER ( DIA = 4.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 3.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[1] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[2] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -3.333e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[4] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 15.552e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[1] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[6] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[7] ),
					PARAMETER ( rel_X = 11.711e-6 ),
					PARAMETER ( rel_Y = 0.558e-6 ),
					PARAMETER ( rel_Z = 22.307e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[8] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 19.442e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[10] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[11] ),
					PARAMETER ( rel_X = -8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[12] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[11] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[14] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[15] ),
					PARAMETER ( rel_X = 7.290e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.337e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[16] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[16] ),
					PARAMETER ( rel_X = 4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[14] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[19] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 11.112e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[21] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[22] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[23] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[21] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[25] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[26] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[27] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[27] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[25] ),
					PARAMETER ( rel_X = 18.887e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.666e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[30] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[31] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[32] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[31] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 13.331e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[0] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[35] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[36] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[37] ),
					PARAMETER ( rel_X = 24.673e-6 ),
					PARAMETER ( rel_Y = 2.056e-6 ),
					PARAMETER ( rel_Z = 6.854e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[35] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 15.001e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[39] ),
					PARAMETER ( rel_X = 8.334e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 13.890e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[40] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.888e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s30[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[18] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.780e-6 ),
					PARAMETER ( DIA = 4.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[0] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[1] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 17.221e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[2] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.329e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[3] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 9.997e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[4] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[5] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[4] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[3] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.112e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[8] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.449e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s30[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[0] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 11.108e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[10] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[11] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 8.885e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[12] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.440e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[12] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[14] ),
					PARAMETER ( rel_X = 7.778e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[10] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[16] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.227e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[17] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[16] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[19] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.115e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[20] ),
					PARAMETER ( rel_X = -5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[20] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 8.888e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[19] ),
					PARAMETER ( rel_X = 17.778e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 19.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s31[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[19] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.997e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[0] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -9.997e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[1] ),
					PARAMETER ( rel_X = -14.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s32[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[20] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s32[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s32[0] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s33[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[21] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.557e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[1] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[2] ),
					PARAMETER ( rel_X = -6.663e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[1] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.781e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[4] ),
					PARAMETER ( rel_X = -10.253e-6 ),
					PARAMETER ( rel_Y = 1.206e-6 ),
					PARAMETER ( rel_Z = 10.253e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[5] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 12.225e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[21] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[0] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.555e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[1] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.665e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[2] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 11.669e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[3] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[4] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[2] ),
					PARAMETER ( rel_X = -5.553e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[6] ),
					PARAMETER ( rel_X = -1.124e-6 ),
					PARAMETER ( rel_Y = 0.562e-6 ),
					PARAMETER ( rel_Z = 24.728e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[7] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[7] ),
					PARAMETER ( rel_X = -6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.552e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s35[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[2] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 4.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[0] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[2] ),
					PARAMETER ( rel_X = 18.319e-6 ),
					PARAMETER ( rel_Y = -1.182e-6 ),
					PARAMETER ( rel_Z = -17.728e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[1] ),
					PARAMETER ( rel_X = -5.559e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[4] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[5] ),
					PARAMETER ( rel_X = -4.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.114e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.115e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[8] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[9] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -12.780e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[7] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[11] ),
					PARAMETER ( rel_X = 4.149e-6 ),
					PARAMETER ( rel_Y = 0.593e-6 ),
					PARAMETER ( rel_Z = -13.632e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[12] ),
					PARAMETER ( rel_X = -11.115e-6 ),
					PARAMETER ( rel_Y = -0.585e-6 ),
					PARAMETER ( rel_Z = -18.135e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[5] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[14] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[15] ),
					PARAMETER ( rel_X = -8.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[16] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[14] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[18] ),
					PARAMETER ( rel_X = -8.349e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 8.349e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[19] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s36[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[3] ),
					PARAMETER ( rel_X = -8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[1] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[2] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[3] ),
					PARAMETER ( rel_X = -17.615e-6 ),
					PARAMETER ( rel_Y = 1.761e-6 ),
					PARAMETER ( rel_Z = -1.761e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[0] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[5] ),
					PARAMETER ( rel_X = -17.306e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.791e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[6] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[7] ),
					PARAMETER ( rel_X = -6.108e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[7] ),
					PARAMETER ( rel_X = -12.782e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s37[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[4] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 1.665e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s37[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[0] ),
					PARAMETER ( rel_X = 1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[1] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[2] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[3] ),
					PARAMETER ( rel_X = 15.478e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.745e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[4] ),
					PARAMETER ( rel_X = 8.893e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[1] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[6] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[7] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[8] ),
					PARAMETER ( rel_X = 12.244e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 4.452e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[9] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[9] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[8] ),
					PARAMETER ( rel_X = 10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.889e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[12] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[12] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[7] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[15] ),
					PARAMETER ( rel_X = 21.229e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = 8.380e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[15] ),
					PARAMETER ( rel_X = -4.134e-6 ),
					PARAMETER ( rel_Y = 0.591e-6 ),
					PARAMETER ( rel_Z = 30.707e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s37[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[18] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[19] ),
					PARAMETER ( rel_X = 3.934e-6 ),
					PARAMETER ( rel_Y = -0.562e-6 ),
					PARAMETER ( rel_Z = 20.794e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[20] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[21] ),
					PARAMETER ( rel_X = 8.642e-6 ),
					PARAMETER ( rel_Y = 0.617e-6 ),
					PARAMETER ( rel_Z = 1.852e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[22] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[20] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[24] ),
					PARAMETER ( rel_X = -16.151e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.768e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[18] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[26] ),
					PARAMETER ( rel_X = -3.364e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 21.306e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[27] ),
					PARAMETER ( rel_X = -8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[27] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[29] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.338e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[30] ),
					PARAMETER ( rel_X = 9.610e-6 ),
					PARAMETER ( rel_Y = -0.565e-6 ),
					PARAMETER ( rel_Z = 6.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[31] ),
					PARAMETER ( rel_X = 20.702e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 1.119e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[31] ),
					PARAMETER ( rel_X = 0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 21.733e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[30] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[34] ),
					PARAMETER ( rel_X = -8.894e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[34] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[36] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[37] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[38] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[37] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[40] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s38[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[5] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[0] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 2.328e-6 ),
					PARAMETER ( rel_Z = 11.058e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[3] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s39[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[7] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 4.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[0] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[1] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[2] ),
					PARAMETER ( rel_X = -8.529e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.843e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[3] ),
					PARAMETER ( rel_X = -12.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[4] ),
					PARAMETER ( rel_X = -9.922e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.085e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[1] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[6] ),
					PARAMETER ( rel_X = -6.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[7] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[8] ),
					PARAMETER ( rel_X = -19.680e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.615e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[9] ),
					PARAMETER ( rel_X = -12.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[0] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[11] ),
					PARAMETER ( rel_X = -13.376e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.032e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[12] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s40[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[9] ),
					PARAMETER ( rel_X = -5.559e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 4.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[0] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[1] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[2] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = -6.113e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[0] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[4] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[5] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[4] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s41[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[10] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = 1.665e-6 ),
					PARAMETER ( DIA = 3.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[0] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.333e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[2] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.329e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[1] ),
					PARAMETER ( rel_X = 8.335e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[4] ),
					PARAMETER ( rel_X = 16.167e-6 ),
					PARAMETER ( rel_Y = -0.557e-6 ),
					PARAMETER ( rel_Z = -4.460e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[5] ),
					PARAMETER ( rel_X = 8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[6] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[5] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[4] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.887e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s42[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[12] ),
					PARAMETER ( rel_X = -10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[0] ),
					PARAMETER ( rel_X = -24.695e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.490e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[1] ),
					PARAMETER ( rel_X = -7.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.778e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[2] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[14] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[0] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[1] ),
					PARAMETER ( rel_X = -11.837e-6 ),
					PARAMETER ( rel_Y = 0.564e-6 ),
					PARAMETER ( rel_Z = -10.146e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[2] ),
					PARAMETER ( rel_X = -14.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[1] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s44[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[15] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.116e-6 ),
					PARAMETER ( DIA = 5.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s44[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[0] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[1] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[2] ),
					PARAMETER ( rel_X = 6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[3] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[5] ),
					PARAMETER ( rel_X = 8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[6] ),
					PARAMETER ( rel_X = 9.452e-6 ),
					PARAMETER ( rel_Y = -0.591e-6 ),
					PARAMETER ( rel_Z = 10.634e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[7] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[7] ),
					PARAMETER ( rel_X = 5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[5] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[10] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[11] ),
					PARAMETER ( rel_X = 8.888e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[12] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 16.669e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[11] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[14] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.329e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[10] ),
					PARAMETER ( rel_X = -6.113e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.224e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[16] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[17] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[18] ),
					PARAMETER ( rel_X = 14.400e-6 ),
					PARAMETER ( rel_Y = 3.600e-6 ),
					PARAMETER ( rel_Z = 13.800e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[19] ),
					PARAMETER ( rel_X = 28.282e-6 ),
					PARAMETER ( rel_Y = -3.463e-6 ),
					PARAMETER ( rel_Z = -5.195e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[17] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[21] ),
					PARAMETER ( rel_X = 7.339e-6 ),
					PARAMETER ( rel_Y = 1.129e-6 ),
					PARAMETER ( rel_Z = 28.226e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[22] ),
					PARAMETER ( rel_X = -5.750e-6 ),
					PARAMETER ( rel_Y = -0.575e-6 ),
					PARAMETER ( rel_Z = 9.200e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[16] ),
					PARAMETER ( rel_X = 7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[24] ),
					PARAMETER ( rel_X = 6.108e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s44[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[0] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[26] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[27] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[28] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[26] ),
					PARAMETER ( rel_X = -1.113e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[30] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[31] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[32] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -7.221e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[33] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[34] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[34] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[32] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -7.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[30] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[38] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.330e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[39] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[40] ),
					PARAMETER ( rel_X = -10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.889e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[41] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[38] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[43] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[44] ),
					PARAMETER ( rel_X = -7.225e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[45] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[46] ),
					PARAMETER ( rel_X = -8.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[47] ),
					PARAMETER ( rel_X = -12.222e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[45] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 2.778e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s45[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[16] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 4.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[0] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[1] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.109e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[2] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -2.224e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s45[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -1.668e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[4] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[5] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[6] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[7] ),
					PARAMETER ( rel_X = 5.182e-6 ),
					PARAMETER ( rel_Y = 0.576e-6 ),
					PARAMETER ( rel_Z = -14.395e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[8] ),
					PARAMETER ( rel_X = 12.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[6] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[10] ),
					PARAMETER ( rel_X = 10.003e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s45[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[4] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 0.557e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[12] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[13] ),
					PARAMETER ( rel_X = 6.663e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[14] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[15] ),
					PARAMETER ( rel_X = 3.067e-6 ),
					PARAMETER ( rel_Y = 0.613e-6 ),
					PARAMETER ( rel_Z = -8.588e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[16] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[17] ),
					PARAMETER ( rel_X = 20.101e-6 ),
					PARAMETER ( rel_Y = -2.319e-6 ),
					PARAMETER ( rel_Z = -3.866e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[16] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s45[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[12] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = 8.337e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[20] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[21] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.440e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[22] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[20] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[24] ),
					PARAMETER ( rel_X = 8.885e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[25] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -5.553e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[26] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[27] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[25] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[29] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[30] ),
					PARAMETER ( rel_X = 15.731e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.157e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[30] ),
					PARAMETER ( rel_X = 13.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[24] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[33] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.557e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[34] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[33] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[36] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[37] ),
					PARAMETER ( rel_X = 6.114e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[38] ),
					PARAMETER ( rel_X = 4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[38] ),
					PARAMETER ( rel_X = 21.923e-6 ),
					PARAMETER ( rel_Y = 3.322e-6 ),
					PARAMETER ( rel_Z = 9.965e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[36] ),
					PARAMETER ( rel_X = 10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s46[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[16] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 3.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[0] ),
					PARAMETER ( rel_X = 5.001e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 12.225e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[1] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[3] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 14.442e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[3] ),
					PARAMETER ( rel_X = 8.885e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[5] ),
					PARAMETER ( rel_X = -1.178e-6 ),
					PARAMETER ( rel_Y = 0.589e-6 ),
					PARAMETER ( rel_Z = 18.263e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[1] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 14.444e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[7] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[8] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[9] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[10] ),
					PARAMETER ( rel_X = 4.582e-6 ),
					PARAMETER ( rel_Y = 2.291e-6 ),
					PARAMETER ( rel_Z = 13.747e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[11] ),
					PARAMETER ( rel_X = -16.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 11.110e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[8] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[13] ),
					PARAMETER ( rel_X = -6.600e-6 ),
					PARAMETER ( rel_Y = 0.600e-6 ),
					PARAMETER ( rel_Z = 16.200e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[14] ),
					PARAMETER ( rel_X = -1.900e-6 ),
					PARAMETER ( rel_Y = 4.433e-6 ),
					PARAMETER ( rel_Z = 17.733e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD

		END SEGMENT_GROUP

	END CELL

END PUBLIC_MODELS

',
						   timeout => 113,
						   write => undef,
						  },
						 ],
				description => "conversion and activation of a Purkinje cell morphology file, taken from the Genesis Purkinje cell tutorial",
			       },
			       {
				arguments => [
					      '--config',
					      '/tmp/neurospaces/test/models/conversions/morphology2ndf_edsjb1994.yml',
					      '/tmp/neurospaces/test/models/morphologies/Purk2M9s.p',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   comment => "Due to regex backtracking, this test runs really slow.  The morphology used for this test, has been obtained from <a href=\"http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3\">http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3</a>",
						   description => "Can a SWC morphology file be converted and activated ?",
						   read => 'PUBLIC_MODELS

	CELL Purk2M9s
	
	ALGORITHM Spines
		Spines__3_17__13__1_33__7_54__1_00__Purk_spine
		PARAMETERS
			PARAMETER ( PROTOTYPE = "Purk_spine" ),
			PARAMETER ( DIA_MIN = 0.00 ),
			PARAMETER ( DIA_MAX = 3.17 ),
			PARAMETER ( SPINE_DENSITY = 13 ),
			PARAMETER ( SPINE_FREQUENCY = 1.00 ),
		END PARAMETERS
	END ALGORITHM

		SEGMENT_GROUP segments

			CHILD soma soma
				PARAMETERS
			
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 29.80e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/soma ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 9.447e-6 ),
					PARAMETER ( rel_Z = 9.447e-6 ),
					PARAMETER ( DIA = 7.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[0] ),
					PARAMETER ( rel_X = 8.426e-6 ),
					PARAMETER ( rel_Y = 1.124e-6 ),
					PARAMETER ( rel_Z = 21.909e-6 ),
					PARAMETER ( DIA = 8.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.666e-6 ),
					PARAMETER ( DIA = 8.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 9.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[3] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 6.109e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 8.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[4] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 8.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[5] ),
					PARAMETER ( rel_X = -1.749e-6 ),
					PARAMETER ( rel_Y = 0.583e-6 ),
					PARAMETER ( rel_Z = 3.498e-6 ),
					PARAMETER ( DIA = 8.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[6] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 3.334e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 7.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD maind main[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[7] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 9.441e-6 ),
					PARAMETER ( DIA = 8.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[8] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 7.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[0] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[1] ),
					PARAMETER ( rel_X = -13.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 5.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[2] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 4.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[3] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 3.335e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[4] ),
					PARAMETER ( rel_X = -8.330e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[5] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[6] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 5.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[7] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 6.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[8] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 3.888e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[9] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 1.665e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[10] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.336e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[11] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.334e-6 ),
					PARAMETER ( DIA = 5.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[12] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 3.338e-6 ),
					PARAMETER ( DIA = 5.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[13] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[14] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 13.888e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[15] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.329e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[16] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 8.890e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[17] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 7.219e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[18] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br1[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[19] ),
					PARAMETER ( rel_X = -6.111e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[8] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 7.776e-6 ),
					PARAMETER ( rel_Z = 8.887e-6 ),
					PARAMETER ( DIA = 8.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[0] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[1] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[3] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[4] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[5] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 11.114e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[6] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[7] ),
					PARAMETER ( rel_X = 6.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 11.668e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[8] ),
					PARAMETER ( rel_X = 13.330e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 9.442e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[9] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[10] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[11] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[12] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[13] ),
					PARAMETER ( rel_X = 6.666e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[14] ),
					PARAMETER ( rel_X = 7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.556e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[15] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[16] ),
					PARAMETER ( rel_X = -5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.887e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[17] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.222e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[18] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 5.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[19] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br2[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[20] ),
					PARAMETER ( rel_X = -2.868e-6 ),
					PARAMETER ( rel_Y = -0.319e-6 ),
					PARAMETER ( rel_Z = 0.956e-6 ),
					PARAMETER ( DIA = 4.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[6] ),
					PARAMETER ( rel_X = -7.223e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[0] ),
					PARAMETER ( rel_X = -7.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[1] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 4.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[2] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 6.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[4] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[5] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 3.333e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[6] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 4.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 4.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[8] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 4.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.669e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 5.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[10] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = 9.998e-6 ),
					PARAMETER ( DIA = 4.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[11] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 9.440e-6 ),
					PARAMETER ( DIA = 5.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[12] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 5.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[13] ),
					PARAMETER ( rel_X = 10.094e-6 ),
					PARAMETER ( rel_Y = -0.561e-6 ),
					PARAMETER ( rel_Z = 11.776e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[14] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 5.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd br3[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[15] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 2.779e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 6.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s01[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[1] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[0] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[1] ),
					PARAMETER ( rel_X = 3.892e-6 ),
					PARAMETER ( rel_Y = -1.668e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[2] ),
					PARAMETER ( rel_X = 1.151e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.356e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[3] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[4] ),
					PARAMETER ( rel_X = -2.432e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.824e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[5] ),
					PARAMETER ( rel_X = -9.438e-6 ),
					PARAMETER ( rel_Y = 1.180e-6 ),
					PARAMETER ( rel_Z = 0.590e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[5] ),
					PARAMETER ( rel_X = 0.907e-6 ),
					PARAMETER ( rel_Y = 0.907e-6 ),
					PARAMETER ( rel_Z = -3.630e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[7] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.050e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[9] ),
					PARAMETER ( rel_X = -16.009e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.606e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.109e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[11] ),
					PARAMETER ( rel_X = -2.226e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.113e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[12] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[12] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[14] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[15] ),
					PARAMETER ( rel_X = -8.055e-6 ),
					PARAMETER ( rel_Y = -1.151e-6 ),
					PARAMETER ( rel_Z = -8.055e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[15] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[17] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[18] ),
					PARAMETER ( rel_X = 0.680e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.762e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[11] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[20] ),
					PARAMETER ( rel_X = 1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[21] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[4] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[23] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[24] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[25] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[26] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[25] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[28] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[29] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[3] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[31] ),
					PARAMETER ( rel_X = 6.271e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.841e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[32] ),
					PARAMETER ( rel_X = -6.155e-6 ),
					PARAMETER ( rel_Y = -0.560e-6 ),
					PARAMETER ( rel_Z = -22.382e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[32] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[34] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[35] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[36] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[37] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[31] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[39] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[40] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[41] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[42] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s01[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s01[43] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s02[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[2] ),
					PARAMETER ( rel_X = 9.998e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 6.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[0] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[1] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[3] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[4] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[5] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[6] ),
					PARAMETER ( rel_X = 1.125e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.189e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[5] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[8] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[9] ),
					PARAMETER ( rel_X = 4.711e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.478e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[4] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[11] ),
					PARAMETER ( rel_X = 12.475e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.701e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[12] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[13] ),
					PARAMETER ( rel_X = 11.113e-6 ),
					PARAMETER ( rel_Y = 1.235e-6 ),
					PARAMETER ( rel_Z = -12.965e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[1] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[15] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 2.221e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[16] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[17] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[15] ),
					PARAMETER ( rel_X = 0.554e-6 ),
					PARAMETER ( rel_Y = 0.554e-6 ),
					PARAMETER ( rel_Z = 0.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[19] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[20] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[21] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[22] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[23] ),
					PARAMETER ( rel_X = -2.246e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.666e-6 ),
					PARAMETER ( DIA = 1.30e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[24] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[24] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[26] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[22] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[28] ),
					PARAMETER ( rel_X = 12.680e-6 ),
					PARAMETER ( rel_Y = -0.576e-6 ),
					PARAMETER ( rel_Z = -5.763e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[19] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[30] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[31] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[32] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[33] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[34] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[35] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[36] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[37] ),
					PARAMETER ( rel_X = 6.225e-6 ),
					PARAMETER ( rel_Y = 1.245e-6 ),
					PARAMETER ( rel_Z = 3.112e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[38] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[38] ),
					PARAMETER ( rel_X = 1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[40] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[41] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[42] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[43] ),
					PARAMETER ( rel_X = 8.353e-6 ),
					PARAMETER ( rel_Y = 1.671e-6 ),
					PARAMETER ( rel_Z = 3.341e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[43] ),
					PARAMETER ( rel_X = 27.278e-6 ),
					PARAMETER ( rel_Y = 2.098e-6 ),
					PARAMETER ( rel_Z = -9.093e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[45] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[46] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[46] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[42] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[49] ),
					PARAMETER ( rel_X = 2.332e-6 ),
					PARAMETER ( rel_Y = 1.166e-6 ),
					PARAMETER ( rel_Z = -11.077e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[50] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[50] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -4.444e-6 ),
					PARAMETER ( rel_Z = -7.222e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[52] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[53] ),
					PARAMETER ( rel_X = 13.991e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.276e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[53] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[55] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[41] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[37] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[58] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[59] ),
					PARAMETER ( rel_X = 9.003e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.688e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[60] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[61] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[62] ),
					PARAMETER ( rel_X = 19.199e-6 ),
					PARAMETER ( rel_Y = 1.694e-6 ),
					PARAMETER ( rel_Z = -6.776e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[62] ),
					PARAMETER ( rel_X = 29.097e-6 ),
					PARAMETER ( rel_Y = 0.606e-6 ),
					PARAMETER ( rel_Z = -5.456e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[58] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[65] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[66] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[67] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[68] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[69] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[70] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[71] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[70] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[73] ),
					PARAMETER ( rel_X = -5.839e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.595e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[68] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[75] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[75] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[77] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = -6.114e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[77] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[79] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[79] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[67] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = -3.335e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[82] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[83] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[82] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[85] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[86] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[87] ),
					PARAMETER ( rel_X = 9.180e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[66] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[89] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.442e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[90] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[91] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[92] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[93] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[94] ),
					PARAMETER ( rel_X = -4.715e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.072e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[95] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[95] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.776e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[93] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[98] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[99] ),
					PARAMETER ( rel_X = 3.331e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[90] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[101] ),
					PARAMETER ( rel_X = 9.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[36] ),
					PARAMETER ( rel_X = 0.540e-6 ),
					PARAMETER ( rel_Y = -0.540e-6 ),
					PARAMETER ( rel_Z = 2.159e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[103] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[104] ),
					PARAMETER ( rel_X = 11.148e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.279e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[104] ),
					PARAMETER ( rel_X = 7.776e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[106] ),
					PARAMETER ( rel_X = 24.430e-6 ),
					PARAMETER ( rel_Y = 1.163e-6 ),
					PARAMETER ( rel_Z = -2.908e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[107] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[107] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[109] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[106] ),
					PARAMETER ( rel_X = 5.553e-6 ),
					PARAMETER ( rel_Y = 2.221e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[111] ),
					PARAMETER ( rel_X = 10.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[112] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[113] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[112] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[115] ),
					PARAMETER ( rel_X = 5.200e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.900e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[111] ),
					PARAMETER ( rel_X = 5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[33] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[118] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[119] ),
					PARAMETER ( rel_X = 8.533e-6 ),
					PARAMETER ( rel_Y = -0.569e-6 ),
					PARAMETER ( rel_Z = 2.276e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[120] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[121] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[122] ),
					PARAMETER ( rel_X = 7.218e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[123] ),
					PARAMETER ( rel_X = 9.129e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.282e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[124] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[125] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[126] ),
					PARAMETER ( rel_X = 2.879e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.485e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[124] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[128] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[129] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[130] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[131] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[131] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[133] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[133] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[135] ),
					PARAMETER ( rel_X = 12.372e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.302e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[128] ),
					PARAMETER ( rel_X = 6.113e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[137] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[138] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.335e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[139] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[140] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[141] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 3.892e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[142] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[143] ),
					PARAMETER ( rel_X = 3.089e-6 ),
					PARAMETER ( rel_Y = 0.618e-6 ),
					PARAMETER ( rel_Z = -5.560e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[140] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[145] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[146] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[146] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[138] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[149] ),
					PARAMETER ( rel_X = 11.242e-6 ),
					PARAMETER ( rel_Y = 0.562e-6 ),
					PARAMETER ( rel_Z = 0.562e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[150] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[151] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[151] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[153] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[154] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[156]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[150] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[157]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[156] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[158]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[157] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[159]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[157] ),
					PARAMETER ( rel_X = 6.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[160]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[137] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[161]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[160] ),
					PARAMETER ( rel_X = 2.781e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.118e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[162]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[161] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[163]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[162] ),
					PARAMETER ( rel_X = -7.830e-6 ),
					PARAMETER ( rel_Y = 1.119e-6 ),
					PARAMETER ( rel_Z = -6.152e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[164]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[163] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[165]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[163] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[166]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[165] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[167]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[162] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[168]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[167] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[169]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[168] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[170]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[169] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[171]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[169] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[172]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[171] ),
					PARAMETER ( rel_X = 7.392e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.848e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[173]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[161] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[174]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[173] ),
					PARAMETER ( rel_X = 8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[175]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[174] ),
					PARAMETER ( rel_X = 4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[176]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[175] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[177]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[176] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[178]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[174] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[179]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[178] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[180]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[179] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[181]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[180] ),
					PARAMETER ( rel_X = -3.892e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[182]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[181] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[183]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[181] ),
					PARAMETER ( rel_X = 1.849e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -22.183e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[184]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[180] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s02[185]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s02[184] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.557e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[5] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 5.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[0] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s03[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[2] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[2] ),
					PARAMETER ( rel_X = -0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[4] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[5] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[4] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[7] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[8] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -6.663e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[9] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[10] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[11] ),
					PARAMETER ( rel_X = -17.021e-6 ),
					PARAMETER ( rel_Y = 0.567e-6 ),
					PARAMETER ( rel_Z = -16.453e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[12] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[13] ),
					PARAMETER ( rel_X = -1.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[14] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[13] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[16] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[17] ),
					PARAMETER ( rel_X = -8.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[10] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[19] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[20] ),
					PARAMETER ( rel_X = 18.003e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 4.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[21] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[21] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[23] ),
					PARAMETER ( rel_X = 7.249e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.558e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[24] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[25] ),
					PARAMETER ( rel_X = -1.203e-6 ),
					PARAMETER ( rel_Y = 0.602e-6 ),
					PARAMETER ( rel_Z = -5.415e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[23] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[27] ),
					PARAMETER ( rel_X = 7.800e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.557e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[20] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[29] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[29] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[31] ),
					PARAMETER ( rel_X = -6.731e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.116e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[31] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[33] ),
					PARAMETER ( rel_X = -4.412e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.042e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[33] ),
					PARAMETER ( rel_X = -11.185e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.915e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[35] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[35] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[8] ),
					PARAMETER ( rel_X = -7.219e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[38] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[39] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[40] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[41] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[39] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[43] ),
					PARAMETER ( rel_X = -11.739e-6 ),
					PARAMETER ( rel_Y = -1.174e-6 ),
					PARAMETER ( rel_Z = -24.652e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[44] ),
					PARAMETER ( rel_X = 2.950e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.080e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[45] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[46] ),
					PARAMETER ( rel_X = 0.678e-6 ),
					PARAMETER ( rel_Y = -4.749e-6 ),
					PARAMETER ( rel_Z = -4.749e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[47] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[47] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[44] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[50] ),
					PARAMETER ( rel_X = -12.934e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.937e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[50] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[52] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[1] ),
					PARAMETER ( rel_X = -5.002e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[54] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[55] ),
					PARAMETER ( rel_X = -17.217e-6 ),
					PARAMETER ( rel_Y = 1.722e-6 ),
					PARAMETER ( rel_Z = -5.739e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[56] ),
					PARAMETER ( rel_X = -0.574e-6 ),
					PARAMETER ( rel_Y = -1.722e-6 ),
					PARAMETER ( rel_Z = -11.477e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[57] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[58] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[59] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[59] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[61] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[61] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.893e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[57] ),
					PARAMETER ( rel_X = 0.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[56] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[65] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[66] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[65] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s03[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s03[68] ),
					PARAMETER ( rel_X = -18.501e-6 ),
					PARAMETER ( rel_Y = -0.578e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b0s04[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/main[6] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 5.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[0] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 7.221e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[1] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[2] ),
					PARAMETER ( rel_X = 2.226e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[3] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[4] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[4] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[2] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.664e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[7] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[8] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[8] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[10] ),
					PARAMETER ( rel_X = -6.720e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 6.720e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[10] ),
					PARAMETER ( rel_X = 10.136e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.702e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[7] ),
					PARAMETER ( rel_X = -15.599e-6 ),
					PARAMETER ( rel_Y = 1.733e-6 ),
					PARAMETER ( rel_Z = -1.733e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[13] ),
					PARAMETER ( rel_X = -8.522e-6 ),
					PARAMETER ( rel_Y = 0.609e-6 ),
					PARAMETER ( rel_Z = -1.217e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[14] ),
					PARAMETER ( rel_X = -16.190e-6 ),
					PARAMETER ( rel_Y = -0.558e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[15] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[14] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[17] ),
					PARAMETER ( rel_X = -7.842e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 5.042e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[18] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[18] ),
					PARAMETER ( rel_X = -1.183e-6 ),
					PARAMETER ( rel_Y = -1.775e-6 ),
					PARAMETER ( rel_Z = 10.648e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[13] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[21] ),
					PARAMETER ( rel_X = 7.805e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 13.380e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[22] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[23] ),
					PARAMETER ( rel_X = -10.687e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.695e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[22] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[25] ),
					PARAMETER ( rel_X = -1.676e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.146e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[26] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[27] ),
					PARAMETER ( rel_X = -10.006e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 19.345e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[26] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.337e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[0] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[30] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[31] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[32] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[33] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[34] ),
					PARAMETER ( rel_X = -1.858e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.527e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[35] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[36] ),
					PARAMETER ( rel_X = -3.872e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.518e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[37] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[36] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[39] ),
					PARAMETER ( rel_X = 2.283e-6 ),
					PARAMETER ( rel_Y = 0.571e-6 ),
					PARAMETER ( rel_Z = 13.699e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[34] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[41] ),
					PARAMETER ( rel_X = 6.667e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[31] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[43] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[44] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[45] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[46] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[47] ),
					PARAMETER ( rel_X = -1.275e-6 ),
					PARAMETER ( rel_Y = -0.637e-6 ),
					PARAMETER ( rel_Z = -21.673e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[48] ),
					PARAMETER ( rel_X = -1.701e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.940e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[49] ),
					PARAMETER ( rel_X = -2.404e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.410e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[49] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[51] ),
					PARAMETER ( rel_X = 7.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.380e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[48] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[53] ),
					PARAMETER ( rel_X = 17.363e-6 ),
					PARAMETER ( rel_Y = -3.858e-6 ),
					PARAMETER ( rel_Z = 3.858e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[53] ),
					PARAMETER ( rel_X = 17.421e-6 ),
					PARAMETER ( rel_Y = -2.323e-6 ),
					PARAMETER ( rel_Z = -5.807e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[47] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[46] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[43] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[58] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 2.224e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[59] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.003e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[59] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[61] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.560e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[58] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[63] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[63] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 3.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[65] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[66] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[67] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[67] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[69] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[69] ),
					PARAMETER ( rel_X = 5.559e-6 ),
					PARAMETER ( rel_Y = 2.224e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[71] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[72] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[71] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[74] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[75] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[75] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[65] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 3.334e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 3.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[78] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[79] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[80] ),
					PARAMETER ( rel_X = 15.919e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.948e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[80] ),
					PARAMETER ( rel_X = 18.408e-6 ),
					PARAMETER ( rel_Y = 1.227e-6 ),
					PARAMETER ( rel_Z = 1.841e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[78] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[83] ),
					PARAMETER ( rel_X = 11.480e-6 ),
					PARAMETER ( rel_Y = 2.870e-6 ),
					PARAMETER ( rel_Z = 7.462e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[84] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[85] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[86] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.480e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[87] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[85] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[89] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[90] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[91] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[92] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[93] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[94] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.560e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[95] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[96] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[97] ),
					PARAMETER ( rel_X = -1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[97] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[94] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[100] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[101] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[101] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[103] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[104] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[105] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[106] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[106] ),
					PARAMETER ( rel_X = -13.673e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.406e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[91] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[109] ),
					PARAMETER ( rel_X = 18.315e-6 ),
					PARAMETER ( rel_Y = 0.572e-6 ),
					PARAMETER ( rel_Z = -1.145e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[110] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = -2.775e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[111] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[111] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[113] ),
					PARAMETER ( rel_X = 26.429e-6 ),
					PARAMETER ( rel_Y = 2.349e-6 ),
					PARAMETER ( rel_Z = 0.587e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[114] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[109] ),
					PARAMETER ( rel_X = 2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[116] ),
					PARAMETER ( rel_X = 8.374e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.675e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[117] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.557e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[117] ),
					PARAMETER ( rel_X = 2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[90] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[120] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[121] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[122] ),
					PARAMETER ( rel_X = -0.575e-6 ),
					PARAMETER ( rel_Y = 1.150e-6 ),
					PARAMETER ( rel_Z = 18.405e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[122] ),
					PARAMETER ( rel_X = 5.603e-6 ),
					PARAMETER ( rel_Y = 1.121e-6 ),
					PARAMETER ( rel_Z = 15.127e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[121] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[125] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[126] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[127] ),
					PARAMETER ( rel_X = 7.782e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.226e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[128] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[129] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[130] ),
					PARAMETER ( rel_X = 13.278e-6 ),
					PARAMETER ( rel_Y = 0.577e-6 ),
					PARAMETER ( rel_Z = 2.886e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[131] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[132] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[133] ),
					PARAMETER ( rel_X = 15.197e-6 ),
					PARAMETER ( rel_Y = 0.563e-6 ),
					PARAMETER ( rel_Z = 6.754e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[129] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.109e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[135] ),
					PARAMETER ( rel_X = -7.224e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[135] ),
					PARAMETER ( rel_X = -0.627e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.409e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[137] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[138] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[126] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = -2.777e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[140] ),
					PARAMETER ( rel_X = 12.236e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.899e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[141] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[141] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[143] ),
					PARAMETER ( rel_X = 21.421e-6 ),
					PARAMETER ( rel_Y = 4.632e-6 ),
					PARAMETER ( rel_Z = 3.474e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[140] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = 3.890e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[145] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.666e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[146] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[147] ),
					PARAMETER ( rel_X = 14.259e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.753e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[145] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[149] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[150] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[151] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[152] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[153] ),
					PARAMETER ( rel_X = 1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b0s04[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b0s04[153] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s05[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[0] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[0] ),
					PARAMETER ( rel_X = -11.749e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.951e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[1] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[2] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[1] ),
					PARAMETER ( rel_X = -7.774e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[4] ),
					PARAMETER ( rel_X = -7.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s05[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s05[4] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s06[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[2] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s06[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[0] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s06[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[1] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[2] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[4] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[5] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[6] ),
					PARAMETER ( rel_X = 4.752e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.752e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[7] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[2] ),
					PARAMETER ( rel_X = -3.338e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = -1.113e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[9] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[10] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[11] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[12] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[13] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[13] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[15] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[11] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 1.109e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[17] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[18] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[19] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.120e-6 ),
					PARAMETER ( rel_Z = -5.599e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[20] ),
					PARAMETER ( rel_X = -3.633e-6 ),
					PARAMETER ( rel_Y = 1.211e-6 ),
					PARAMETER ( rel_Z = -12.716e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[21] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[22] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[23] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[23] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[21] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[26] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.109e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[27] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[28] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[29] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[27] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[31] ),
					PARAMETER ( rel_X = -2.257e-6 ),
					PARAMETER ( rel_Y = -0.564e-6 ),
					PARAMETER ( rel_Z = -6.771e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[32] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[32] ),
					PARAMETER ( rel_X = -1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.557e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[34] ),
					PARAMETER ( rel_X = -17.342e-6 ),
					PARAMETER ( rel_Y = -1.196e-6 ),
					PARAMETER ( rel_Z = -13.156e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[34] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = -7.781e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[36] ),
					PARAMETER ( rel_X = 9.460e-6 ),
					PARAMETER ( rel_Y = -1.183e-6 ),
					PARAMETER ( rel_Z = -11.825e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[36] ),
					PARAMETER ( rel_X = -7.458e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.031e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[20] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[39] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[40] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[40] ),
					PARAMETER ( rel_X = -2.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.562e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[42] ),
					PARAMETER ( rel_X = -17.535e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.485e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[42] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[44] ),
					PARAMETER ( rel_X = -6.762e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.016e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[45] ),
					PARAMETER ( rel_X = -8.893e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[46] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[46] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[45] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[49] ),
					PARAMETER ( rel_X = -7.840e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.480e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[50] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[51] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[50] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[53] ),
					PARAMETER ( rel_X = -12.887e-6 ),
					PARAMETER ( rel_Y = -0.586e-6 ),
					PARAMETER ( rel_Z = -7.615e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[18] ),
					PARAMETER ( rel_X = -5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[55] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[56] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[57] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[58] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[59] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[60] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[61] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[62] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[58] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[64] ),
					PARAMETER ( rel_X = -12.284e-6 ),
					PARAMETER ( rel_Y = -1.117e-6 ),
					PARAMETER ( rel_Z = -8.376e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[65] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[66] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[67] ),
					PARAMETER ( rel_X = -2.954e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.089e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[68] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[69] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[69] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[65] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[72] ),
					PARAMETER ( rel_X = 2.617e-6 ),
					PARAMETER ( rel_Y = 0.654e-6 ),
					PARAMETER ( rel_Z = -3.271e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[73] ),
					PARAMETER ( rel_X = 5.028e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = -2.234e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[73] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[75] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[76] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[77] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[78] ),
					PARAMETER ( rel_X = -1.158e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.213e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[76] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[80] ),
					PARAMETER ( rel_X = -2.833e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.500e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[72] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[56] ),
					PARAMETER ( rel_X = -6.666e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[83] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[84] ),
					PARAMETER ( rel_X = -11.896e-6 ),
					PARAMETER ( rel_Y = -0.595e-6 ),
					PARAMETER ( rel_Z = -12.491e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[86]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[84] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[87]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[86] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[88]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[87] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[89]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[88] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[90]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[89] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[91]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[90] ),
					PARAMETER ( rel_X = 17.277e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.942e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[92]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[89] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[93]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[92] ),
					PARAMETER ( rel_X = -7.419e-6 ),
					PARAMETER ( rel_Y = -1.141e-6 ),
					PARAMETER ( rel_Z = -5.707e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[94]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[93] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[95]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[94] ),
					PARAMETER ( rel_X = -0.603e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -21.101e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[96]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[88] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[97]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[96] ),
					PARAMETER ( rel_X = -8.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[98]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[97] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[99]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[97] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[100]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[99] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[101]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[100] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[102]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[99] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[103]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[102] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[104]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[103] ),
					PARAMETER ( rel_X = -19.763e-6 ),
					PARAMETER ( rel_Y = -2.044e-6 ),
					PARAMETER ( rel_Z = 9.541e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[105]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[103] ),
					PARAMETER ( rel_X = 1.199e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.595e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[106]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[102] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[107]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[17] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[108]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[107] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[109]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[108] ),
					PARAMETER ( rel_X = -6.115e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[110]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[109] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[111]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[110] ),
					PARAMETER ( rel_X = -11.840e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.947e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[112]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[111] ),
					PARAMETER ( rel_X = 6.325e-6 ),
					PARAMETER ( rel_Y = 0.632e-6 ),
					PARAMETER ( rel_Z = 7.590e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[113]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[111] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[114]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[113] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[115]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[114] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[116]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[114] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[117]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[116] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[118]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[109] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[119]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[118] ),
					PARAMETER ( rel_X = -14.662e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.511e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[120]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[119] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[121]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[119] ),
					PARAMETER ( rel_X = -8.623e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.990e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[122]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[1] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[123]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[122] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[124]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[123] ),
					PARAMETER ( rel_X = -10.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[125]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[124] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.886e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[126]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[125] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[127]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[126] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[128]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[127] ),
					PARAMETER ( rel_X = -7.547e-6 ),
					PARAMETER ( rel_Y = 0.629e-6 ),
					PARAMETER ( rel_Z = 3.145e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[129]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[124] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[130]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[129] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[131]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[130] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[132]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[131] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[133]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[132] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[134]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[131] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = -1.113e-6 ),
					PARAMETER ( rel_Z = -2.226e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[135]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[129] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[136]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[135] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[137]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[135] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[138]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[137] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[139]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[138] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[140]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[139] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[141]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[140] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[142]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[139] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[143]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[142] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[144]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[143] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[145]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[143] ),
					PARAMETER ( rel_X = -2.781e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[146]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[137] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[147]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[146] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[148]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[147] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[149]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[148] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[150]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[149] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[151]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[150] ),
					PARAMETER ( rel_X = -5.745e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.319e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[152]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[151] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[153]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[152] ),
					PARAMETER ( rel_X = 12.437e-6 ),
					PARAMETER ( rel_Y = -0.592e-6 ),
					PARAMETER ( rel_Z = -21.321e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[154]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[151] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[155]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[154] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[156]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[155] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[157]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[156] ),
					PARAMETER ( rel_X = -7.387e-6 ),
					PARAMETER ( rel_Y = -0.568e-6 ),
					PARAMETER ( rel_Z = -2.273e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[158]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[157] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[159]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[158] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -6.107e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[160]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[158] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[161]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[160] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[162]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[161] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.664e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[163]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[149] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[164]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[163] ),
					PARAMETER ( rel_X = -1.113e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.226e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[165]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[163] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[166]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[165] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[167]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[166] ),
					PARAMETER ( rel_X = -11.971e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.420e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[168]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[166] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[169]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[168] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[170]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[169] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[171]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[170] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[172]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[171] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[173]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[172] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[174]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[173] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[175]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[173] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[176]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[170] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[177]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[176] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[178]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[177] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[179]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[177] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[180]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[179] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[181]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[168] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s06[182]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s06[181] ),
					PARAMETER ( rel_X = -0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.670e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[4] ),
					PARAMETER ( rel_X = 2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 4.446e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[0] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[2] ),
					PARAMETER ( rel_X = -5.480e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.568e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[3] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s07[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s07[4] ),
					PARAMETER ( rel_X = -1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s08[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[5] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[0] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[2] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[3] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[3] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[5] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[6] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[7] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[8] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[9] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[10] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.229e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[10] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[8] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[13] ),
					PARAMETER ( rel_X = -10.621e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.118e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[6] ),
					PARAMETER ( rel_X = -10.553e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[2] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[16] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[17] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[18] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[18] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[17] ),
					PARAMETER ( rel_X = -3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[16] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = -1.112e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[22] ),
					PARAMETER ( rel_X = -16.160e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 7.801e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s08[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s08[23] ),
					PARAMETER ( rel_X = -16.712e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.013e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s09[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[7] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 5.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[0] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[1] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[2] ),
					PARAMETER ( rel_X = -10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[3] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[3] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[5] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[5] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[7] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[7] ),
					PARAMETER ( rel_X = -9.137e-6 ),
					PARAMETER ( rel_Y = -0.571e-6 ),
					PARAMETER ( rel_Z = -2.855e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[0] ),
					PARAMETER ( rel_X = -8.894e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[10] ),
					PARAMETER ( rel_X = -11.669e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[11] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[12] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[13] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[14] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[15] ),
					PARAMETER ( rel_X = -3.364e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.652e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[16] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[17] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[16] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[19] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[20] ),
					PARAMETER ( rel_X = -1.188e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.754e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[21] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[22] ),
					PARAMETER ( rel_X = -7.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[22] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[20] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[25] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[26] ),
					PARAMETER ( rel_X = -15.012e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.896e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[26] ),
					PARAMETER ( rel_X = -22.344e-6 ),
					PARAMETER ( rel_Y = -0.621e-6 ),
					PARAMETER ( rel_Z = 5.586e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[12] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -4.441e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[29] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[11] ),
					PARAMETER ( rel_X = -10.002e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.446e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[31] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.219e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[32] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[31] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[34] ),
					PARAMETER ( rel_X = -16.830e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.161e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[35] ),
					PARAMETER ( rel_X = -16.163e-6 ),
					PARAMETER ( rel_Y = 0.703e-6 ),
					PARAMETER ( rel_Z = -9.136e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[35] ),
					PARAMETER ( rel_X = -7.379e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.270e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[37] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s09[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s09[38] ),
					PARAMETER ( rel_X = -11.672e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s10[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[8] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 5.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s10[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[0] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 3.333e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 3.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[2] ),
					PARAMETER ( rel_X = -7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[3] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[4] ),
					PARAMETER ( rel_X = -7.465e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.297e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[5] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[5] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[7] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[8] ),
					PARAMETER ( rel_X = -1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.669e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[7] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[10] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[11] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.337e-6 ),
					PARAMETER ( DIA = 0.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[12] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[12] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[14] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[10] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[16] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[16] ),
					PARAMETER ( rel_X = -8.333e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[18] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.557e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[18] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[3] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[21] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[0] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 3.331e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[23] ),
					PARAMETER ( rel_X = -8.955e-6 ),
					PARAMETER ( rel_Y = -0.560e-6 ),
					PARAMETER ( rel_Z = 3.358e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[24] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[25] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[26] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[26] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[24] ),
					PARAMETER ( rel_X = -8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[29] ),
					PARAMETER ( rel_X = -7.774e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[30] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[31] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[32] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[33] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[34] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[35] ),
					PARAMETER ( rel_X = 10.574e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.009e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[34] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[37] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[38] ),
					PARAMETER ( rel_X = -10.578e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.227e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[39] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.892e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[40] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[41] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.774e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[41] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[39] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[44] ),
					PARAMETER ( rel_X = -15.951e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.847e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[37] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[46] ),
					PARAMETER ( rel_X = -13.433e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.592e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[47] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[46] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[49] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[50] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[51] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[52] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[54]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[52] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[55]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[54] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[56]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[55] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[57]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[49] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[58]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[57] ),
					PARAMETER ( rel_X = -16.086e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.596e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[59]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[58] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[60]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[59] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[61]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[33] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[62]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[61] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[63]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[61] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[64]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[63] ),
					PARAMETER ( rel_X = 2.673e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.356e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[65]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[31] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[66]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[65] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[67]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[29] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.218e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[68]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[67] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[69]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[68] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.664e-6 ),
					PARAMETER ( rel_Z = 2.774e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[70]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[69] ),
					PARAMETER ( rel_X = -23.421e-6 ),
					PARAMETER ( rel_Y = 0.601e-6 ),
					PARAMETER ( rel_Z = 3.003e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[71]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[69] ),
					PARAMETER ( rel_X = -21.798e-6 ),
					PARAMETER ( rel_Y = 0.703e-6 ),
					PARAMETER ( rel_Z = 11.954e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[72]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[68] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[73]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[72] ),
					PARAMETER ( rel_X = -25.146e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.796e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[74]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[73] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[75]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[74] ),
					PARAMETER ( rel_X = -12.857e-6 ),
					PARAMETER ( rel_Y = 1.677e-6 ),
					PARAMETER ( rel_Z = -12.298e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[76]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[75] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.108e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[77]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[76] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[78]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[73] ),
					PARAMETER ( rel_X = -7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[79]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[78] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[80]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[79] ),
					PARAMETER ( rel_X = -9.219e-6 ),
					PARAMETER ( rel_Y = -1.152e-6 ),
					PARAMETER ( rel_Z = -1.729e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[81]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[80] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[82]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[80] ),
					PARAMETER ( rel_X = -18.402e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.968e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[83]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[79] ),
					PARAMETER ( rel_X = -9.061e-6 ),
					PARAMETER ( rel_Y = -0.566e-6 ),
					PARAMETER ( rel_Z = 6.229e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[84]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[83] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s10[85]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s10[83] ),
					PARAMETER ( rel_X = -6.355e-6 ),
					PARAMETER ( rel_Y = -1.271e-6 ),
					PARAMETER ( rel_Z = 13.981e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s11[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[0] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[1] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[2] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[1] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[4] ),
					PARAMETER ( rel_X = -6.764e-6 ),
					PARAMETER ( rel_Y = -0.564e-6 ),
					PARAMETER ( rel_Z = 16.347e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[5] ),
					PARAMETER ( rel_X = 2.226e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[6] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[5] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[8] ),
					PARAMETER ( rel_X = -4.078e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.980e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s11[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s11[9] ),
					PARAMETER ( rel_X = 5.822e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.136e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s12[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[12] ),
					PARAMETER ( rel_X = -12.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 4.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[0] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[1] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.329e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[2] ),
					PARAMETER ( rel_X = 2.306e-6 ),
					PARAMETER ( rel_Y = 1.153e-6 ),
					PARAMETER ( rel_Z = 21.335e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[1] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[4] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[5] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[6] ),
					PARAMETER ( rel_X = -4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[7] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[8] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[9] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.554e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[10] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[10] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[8] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[13] ),
					PARAMETER ( rel_X = -6.669e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[14] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[15] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[5] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[17] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[18] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 4.446e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[19] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[20] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[21] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[22] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[23] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[24] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[25] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.776e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[26] ),
					PARAMETER ( rel_X = -6.761e-6 ),
					PARAMETER ( rel_Y = 0.563e-6 ),
					PARAMETER ( rel_Z = 3.381e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[25] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[28] ),
					PARAMETER ( rel_X = -7.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[23] ),
					PARAMETER ( rel_X = -6.108e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[30] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[30] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[32] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[20] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[34] ),
					PARAMETER ( rel_X = -11.510e-6 ),
					PARAMETER ( rel_Y = -0.575e-6 ),
					PARAMETER ( rel_Z = 4.604e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[35] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.996e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[35] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[37] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[19] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[39] ),
					PARAMETER ( rel_X = -2.954e-6 ),
					PARAMETER ( rel_Y = 1.181e-6 ),
					PARAMETER ( rel_Z = 18.903e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[40] ),
					PARAMETER ( rel_X = -6.512e-6 ),
					PARAMETER ( rel_Y = 0.592e-6 ),
					PARAMETER ( rel_Z = 19.536e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[41] ),
					PARAMETER ( rel_X = -7.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[17] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 6.663e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[43] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[44] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[44] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[46] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[47] ),
					PARAMETER ( rel_X = 6.707e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.501e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[48] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[50]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[47] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[51]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[50] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[52]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[51] ),
					PARAMETER ( rel_X = -6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s12[53]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s12[51] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s13[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[13] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 4.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[0] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.889e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[1] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[2] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[0] ),
					PARAMETER ( rel_X = -2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[4] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[5] ),
					PARAMETER ( rel_X = -6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[6] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s13[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s13[7] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.445e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s14[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[14] ),
					PARAMETER ( rel_X = 3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[1] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = -1.665e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[2] ),
					PARAMETER ( rel_X = 8.511e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.702e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[3] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[4] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[5] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[6] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[7] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[8] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[9] ),
					PARAMETER ( rel_X = 5.028e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.291e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[10] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[11] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 5.556e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[10] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[13] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[14] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[7] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[17] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[18] ),
					PARAMETER ( rel_X = 8.394e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 16.788e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[19] ),
					PARAMETER ( rel_X = 3.329e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[20] ),
					PARAMETER ( rel_X = 5.041e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.931e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[21] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 7.218e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[22] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = -1.665e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[19] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[24] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[25] ),
					PARAMETER ( rel_X = -4.447e-6 ),
					PARAMETER ( rel_Y = 2.223e-6 ),
					PARAMETER ( rel_Z = 4.447e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[26] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.891e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[27] ),
					PARAMETER ( rel_X = -9.477e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.690e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[28] ),
					PARAMETER ( rel_X = 2.234e-6 ),
					PARAMETER ( rel_Y = -1.117e-6 ),
					PARAMETER ( rel_Z = 10.054e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[29] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.998e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[30] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[30] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.001e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[32] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[29] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[34] ),
					PARAMETER ( rel_X = 1.146e-6 ),
					PARAMETER ( rel_Y = 0.573e-6 ),
					PARAMETER ( rel_Z = 15.477e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[28] ),
					PARAMETER ( rel_X = -5.556e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[36] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[37] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 10.001e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[38] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 8.885e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[27] ),
					PARAMETER ( rel_X = 2.781e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[40] ),
					PARAMETER ( rel_X = 6.244e-6 ),
					PARAMETER ( rel_Y = 0.568e-6 ),
					PARAMETER ( rel_Z = 15.327e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s14[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s14[41] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[16] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[0] ),
					PARAMETER ( rel_X = -10.034e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.592e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[0] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[2] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.777e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[3] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[2] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[5] ),
					PARAMETER ( rel_X = -9.267e-6 ),
					PARAMETER ( rel_Y = -0.579e-6 ),
					PARAMETER ( rel_Z = 2.317e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s15[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s15[5] ),
					PARAMETER ( rel_X = -10.014e-6 ),
					PARAMETER ( rel_Y = 0.626e-6 ),
					PARAMETER ( rel_Z = -3.129e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b1s16[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[17] ),
					PARAMETER ( rel_X = -6.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s16[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s16[0] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s16[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s16[1] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s17[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[18] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s17[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s17[0] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s18[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[19] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[20] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.999e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[0] ),
					PARAMETER ( rel_X = -4.446e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[3] ),
					PARAMETER ( rel_X = -6.107e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[4] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[5] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[6] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[7] ),
					PARAMETER ( rel_X = -3.892e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.448e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[8] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[9] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 1.109e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[10] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[11] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.220e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[10] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[13] ),
					PARAMETER ( rel_X = -2.084e-6 ),
					PARAMETER ( rel_Y = 0.695e-6 ),
					PARAMETER ( rel_Z = -7.641e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[13] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[15] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[15] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[17] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[18] ),
					PARAMETER ( rel_X = -10.050e-6 ),
					PARAMETER ( rel_Y = 0.558e-6 ),
					PARAMETER ( rel_Z = -5.583e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[19] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[19] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.665e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[21] ),
					PARAMETER ( rel_X = -6.115e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[18] ),
					PARAMETER ( rel_X = -10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[23] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.781e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[7] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[25] ),
					PARAMETER ( rel_X = -5.002e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 5.002e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[26] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[27] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[28] ),
					PARAMETER ( rel_X = -4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.892e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[3] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[30] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[31] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[32] ),
					PARAMETER ( rel_X = -11.316e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.263e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[33] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[34] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[35] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[36] ),
					PARAMETER ( rel_X = -9.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[36] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 10.551e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[38] ),
					PARAMETER ( rel_X = -15.568e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.896e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[38] ),
					PARAMETER ( rel_X = -4.443e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[40] ),
					PARAMETER ( rel_X = -6.666e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s19[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s19[41] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br1[20] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[0] ),
					PARAMETER ( rel_X = -4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[1] ),
					PARAMETER ( rel_X = -3.885e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.110e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = -5.003e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[3] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[4] ),
					PARAMETER ( rel_X = -8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[5] ),
					PARAMETER ( rel_X = 1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.218e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[4] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.556e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[7] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[8] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[8] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[2] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.224e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[11] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[11] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.336e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[13] ),
					PARAMETER ( rel_X = 1.494e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.215e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[0] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[15] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[16] ),
					PARAMETER ( rel_X = -8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[17] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.001e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[15] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[19] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.218e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b1s20[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b1s20[19] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s21[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[1] ),
					PARAMETER ( rel_X = 7.219e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[0] ),
					PARAMETER ( rel_X = 8.794e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.676e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[2] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[3] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[3] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[1] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[6] ),
					PARAMETER ( rel_X = 2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[7] ),
					PARAMETER ( rel_X = 4.646e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -17.421e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[8] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.329e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[7] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[10] ),
					PARAMETER ( rel_X = 5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[11] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.000e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[12] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[13] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[14] ),
					PARAMETER ( rel_X = -7.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.026e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[13] ),
					PARAMETER ( rel_X = -2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.109e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[16] ),
					PARAMETER ( rel_X = -5.859e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.445e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[11] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[18] ),
					PARAMETER ( rel_X = 4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[19] ),
					PARAMETER ( rel_X = 3.441e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.322e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[19] ),
					PARAMETER ( rel_X = 1.112e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[21] ),
					PARAMETER ( rel_X = 9.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[21] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s21[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s21[23] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.335e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s22[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[2] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[0] ),
					PARAMETER ( rel_X = -20.534e-6 ),
					PARAMETER ( rel_Y = -0.587e-6 ),
					PARAMETER ( rel_Z = 15.840e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[1] ),
					PARAMETER ( rel_X = -15.097e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = -1.677e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[2] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[3] ),
					PARAMETER ( rel_X = -2.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.779e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[1] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[5] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[6] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[6] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 0.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[5] ),
					PARAMETER ( rel_X = -1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[9] ),
					PARAMETER ( rel_X = -16.250e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[10] ),
					PARAMETER ( rel_X = -4.360e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.966e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s22[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s22[9] ),
					PARAMETER ( rel_X = -14.731e-6 ),
					PARAMETER ( rel_Y = 1.281e-6 ),
					PARAMETER ( rel_Z = 16.653e-6 ),
					PARAMETER ( DIA = 0.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s23[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[3] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 3.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[0] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[1] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[2] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.440e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[2] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[5] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[6] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[7] ),
					PARAMETER ( rel_X = 3.887e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.220e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[9] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[10] ),
					PARAMETER ( rel_X = 5.611e-6 ),
					PARAMETER ( rel_Y = 0.561e-6 ),
					PARAMETER ( rel_Z = 6.172e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[11] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[12] ),
					PARAMETER ( rel_X = 9.402e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.655e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[11] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[14] ),
					PARAMETER ( rel_X = 18.018e-6 ),
					PARAMETER ( rel_Y = 0.667e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[14] ),
					PARAMETER ( rel_X = 3.915e-6 ),
					PARAMETER ( rel_Y = 1.119e-6 ),
					PARAMETER ( rel_Z = 10.068e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[9] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[17] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[18] ),
					PARAMETER ( rel_X = 0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[19] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[1] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[21] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.780e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[22] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.775e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[23] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[24] ),
					PARAMETER ( rel_X = 7.243e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.601e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[21] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s23[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s23[26] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s24[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[4] ),
					PARAMETER ( rel_X = -5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 3.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[0] ),
					PARAMETER ( rel_X = -8.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[1] ),
					PARAMETER ( rel_X = -6.034e-6 ),
					PARAMETER ( rel_Y = -0.603e-6 ),
					PARAMETER ( rel_Z = 9.654e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[3] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.222e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[2] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.111e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s24[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s24[5] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 10.552e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s25[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[8] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 2.777e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 5.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s25[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 3.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[1] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 8.336e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[2] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[3] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[2] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 14.444e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[5] ),
					PARAMETER ( rel_X = 10.642e-6 ),
					PARAMETER ( rel_Y = -2.504e-6 ),
					PARAMETER ( rel_Z = 18.780e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[6] ),
					PARAMETER ( rel_X = 5.400e-6 ),
					PARAMETER ( rel_Y = 3.000e-6 ),
					PARAMETER ( rel_Z = 19.200e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[7] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.440e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[5] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[9] ),
					PARAMETER ( rel_X = 5.284e-6 ),
					PARAMETER ( rel_Y = -1.761e-6 ),
					PARAMETER ( rel_Z = 9.393e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[0] ),
					PARAMETER ( rel_X = -3.331e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.442e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[11] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[12] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[13] ),
					PARAMETER ( rel_X = 6.115e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[13] ),
					PARAMETER ( rel_X = 7.777e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[15] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.113e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[15] ),
					PARAMETER ( rel_X = 7.700e-6 ),
					PARAMETER ( rel_Y = 2.200e-6 ),
					PARAMETER ( rel_Z = 15.400e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[17] ),
					PARAMETER ( rel_X = 4.694e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.081e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[12] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.335e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[19] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[20] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[21] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 1.668e-6 ),
					PARAMETER ( rel_Z = 5.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[19] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[23] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[24] ),
					PARAMETER ( rel_X = 3.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[24] ),
					PARAMETER ( rel_X = 7.264e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.881e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[26] ),
					PARAMETER ( rel_X = 4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.886e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[26] ),
					PARAMETER ( rel_X = 5.949e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 16.064e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[23] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.330e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[29] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[30] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 19.445e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[30] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[32] ),
					PARAMETER ( rel_X = -9.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.112e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s25[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s25[32] ),
					PARAMETER ( rel_X = 9.446e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.446e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s26[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[10] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.558e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[0] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[1] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[2] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[1] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[4] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[5] ),
					PARAMETER ( rel_X = 18.880e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.005e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[4] ),
					PARAMETER ( rel_X = 11.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.333e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[7] ),
					PARAMETER ( rel_X = 10.552e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[8] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[9] ),
					PARAMETER ( rel_X = 9.855e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.447e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[9] ),
					PARAMETER ( rel_X = 12.217e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[0] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[12] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[13] ),
					PARAMETER ( rel_X = 8.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[14] ),
					PARAMETER ( rel_X = 10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[13] ),
					PARAMETER ( rel_X = 8.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[16] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -11.114e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[17] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -10.560e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[18] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[18] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[16] ),
					PARAMETER ( rel_X = 7.219e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[21] ),
					PARAMETER ( rel_X = 17.495e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.997e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[22] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[22] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.779e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[12] ),
					PARAMETER ( rel_X = -2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.329e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[25] ),
					PARAMETER ( rel_X = -12.096e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.456e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[26] ),
					PARAMETER ( rel_X = -7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[26] ),
					PARAMETER ( rel_X = -4.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.552e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[28] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.776e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[28] ),
					PARAMETER ( rel_X = -7.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[25] ),
					PARAMETER ( rel_X = 0.559e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.559e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[31] ),
					PARAMETER ( rel_X = -1.145e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -13.170e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[32] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.998e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[32] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s26[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s26[31] ),
					PARAMETER ( rel_X = 7.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -12.780e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s27[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[12] ),
					PARAMETER ( rel_X = 7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[0] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[1] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[3] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[3] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.887e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[5] ),
					PARAMETER ( rel_X = 14.054e-6 ),
					PARAMETER ( rel_Y = -0.740e-6 ),
					PARAMETER ( rel_Z = -15.533e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[5] ),
					PARAMETER ( rel_X = 24.188e-6 ),
					PARAMETER ( rel_Y = -0.563e-6 ),
					PARAMETER ( rel_Z = -10.688e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[2] ),
					PARAMETER ( rel_X = 8.338e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[8] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.777e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[9] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[8] ),
					PARAMETER ( rel_X = 9.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[11] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[12] ),
					PARAMETER ( rel_X = 13.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.112e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[13] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[12] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[15] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[1] ),
					PARAMETER ( rel_X = 16.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 12.777e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[17] ),
					PARAMETER ( rel_X = 15.555e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.778e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[18] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -10.003e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[19] ),
					PARAMETER ( rel_X = 5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.668e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[20] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.221e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[21] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[19] ),
					PARAMETER ( rel_X = 7.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[23] ),
					PARAMETER ( rel_X = 16.755e-6 ),
					PARAMETER ( rel_Y = 0.762e-6 ),
					PARAMETER ( rel_Z = -7.616e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[18] ),
					PARAMETER ( rel_X = 20.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.223e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[25] ),
					PARAMETER ( rel_X = 6.113e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[0] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[27] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.221e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[28] ),
					PARAMETER ( rel_X = 8.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[29] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[30] ),
					PARAMETER ( rel_X = 13.893e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 11.114e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[31] ),
					PARAMETER ( rel_X = 15.014e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[32] ),
					PARAMETER ( rel_X = 10.553e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[31] ),
					PARAMETER ( rel_X = 10.003e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[29] ),
					PARAMETER ( rel_X = 12.779e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[35] ),
					PARAMETER ( rel_X = 9.997e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[36] ),
					PARAMETER ( rel_X = 14.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[37] ),
					PARAMETER ( rel_X = 9.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 9.446e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[38] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.554e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[38] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 14.996e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[40] ),
					PARAMETER ( rel_X = 4.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.114e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[36] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[42] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.227e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[43] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[44] ),
					PARAMETER ( rel_X = 7.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.113e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[28] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 19.444e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s27[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s27[46] ),
					PARAMETER ( rel_X = 11.109e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 11.664e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s28[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[15] ),
					PARAMETER ( rel_X = 10.557e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[0] ),
					PARAMETER ( rel_X = 5.552e-6 ),
					PARAMETER ( rel_Y = -2.221e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[1] ),
					PARAMETER ( rel_X = 17.227e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.780e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[2] ),
					PARAMETER ( rel_X = 8.334e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.112e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[3] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[2] ),
					PARAMETER ( rel_X = 5.556e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 13.890e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[5] ),
					PARAMETER ( rel_X = 14.442e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 8.332e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[6] ),
					PARAMETER ( rel_X = 12.221e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[1] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.218e-6 ),
					PARAMETER ( DIA = 2.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[8] ),
					PARAMETER ( rel_X = 8.336e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[9] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 12.219e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[11] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.333e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[12] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[13] ),
					PARAMETER ( rel_X = 6.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.333e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[13] ),
					PARAMETER ( rel_X = 9.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[10] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 20.554e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[16] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.328e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[8] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 17.220e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[18] ),
					PARAMETER ( rel_X = 9.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 14.996e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s28[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s28[19] ),
					PARAMETER ( rel_X = 6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s29[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[16] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 1.112e-6 ),
					PARAMETER ( rel_Z = 10.004e-6 ),
					PARAMETER ( DIA = 4.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 3.891e-6 ),
					PARAMETER ( DIA = 3.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[1] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[2] ),
					PARAMETER ( rel_X = -3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[3] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -3.333e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[4] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 15.552e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[1] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[6] ),
					PARAMETER ( rel_X = 3.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[7] ),
					PARAMETER ( rel_X = 11.711e-6 ),
					PARAMETER ( rel_Y = 0.558e-6 ),
					PARAMETER ( rel_Z = 22.307e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[8] ),
					PARAMETER ( rel_X = -0.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 19.442e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[10] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[11] ),
					PARAMETER ( rel_X = -8.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[12] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[11] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[14] ),
					PARAMETER ( rel_X = -3.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[15] ),
					PARAMETER ( rel_X = 7.290e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.337e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[16] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[16] ),
					PARAMETER ( rel_X = 4.442e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.331e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[14] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[19] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 12.775e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[10] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 11.112e-6 ),
					PARAMETER ( DIA = 2.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[21] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[22] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[23] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.667e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[21] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[25] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[26] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.560e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[27] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[27] ),
					PARAMETER ( rel_X = 5.554e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[25] ),
					PARAMETER ( rel_X = 18.887e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.666e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[30] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[31] ),
					PARAMETER ( rel_X = 8.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[32] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 0.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[31] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 13.331e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[0] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[35] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.336e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[36] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.111e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[37] ),
					PARAMETER ( rel_X = 24.673e-6 ),
					PARAMETER ( rel_Y = 2.056e-6 ),
					PARAMETER ( rel_Z = 6.854e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[35] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 15.001e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[39] ),
					PARAMETER ( rel_X = 8.334e-6 ),
					PARAMETER ( rel_Y = -2.222e-6 ),
					PARAMETER ( rel_Z = 13.890e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s29[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s29[40] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.888e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s30[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[18] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.780e-6 ),
					PARAMETER ( DIA = 4.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[0] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[1] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 17.221e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[2] ),
					PARAMETER ( rel_X = -4.442e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.329e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[3] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 9.997e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[4] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[5] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[4] ),
					PARAMETER ( rel_X = -2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[3] ),
					PARAMETER ( rel_X = -8.889e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.112e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[8] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.449e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[0] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 11.108e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[10] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[11] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 8.885e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[12] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 14.440e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[12] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.109e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[14] ),
					PARAMETER ( rel_X = 7.778e-6 ),
					PARAMETER ( rel_Y = 2.222e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[10] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 2.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[16] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 17.227e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[17] ),
					PARAMETER ( rel_X = -4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.999e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[16] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[19] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.115e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[20] ),
					PARAMETER ( rel_X = -5.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[20] ),
					PARAMETER ( rel_X = 5.555e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 8.888e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s30[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s30[19] ),
					PARAMETER ( rel_X = 17.778e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 19.445e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s31[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[19] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.997e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[0] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.330e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -9.997e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s31[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s31[1] ),
					PARAMETER ( rel_X = -14.440e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s32[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[20] ),
					PARAMETER ( rel_X = -2.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s32[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s32[0] ),
					PARAMETER ( rel_X = -5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b2s33[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[21] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.557e-6 ),
					PARAMETER ( DIA = 3.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 8.893e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[1] ),
					PARAMETER ( rel_X = -6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[2] ),
					PARAMETER ( rel_X = -6.663e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.332e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[1] ),
					PARAMETER ( rel_X = -1.112e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.781e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[4] ),
					PARAMETER ( rel_X = -10.253e-6 ),
					PARAMETER ( rel_Y = 1.206e-6 ),
					PARAMETER ( rel_Z = 10.253e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s33[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s33[5] ),
					PARAMETER ( rel_X = 9.447e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 12.225e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br2[21] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 3.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[0] ),
					PARAMETER ( rel_X = -7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 15.555e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[1] ),
					PARAMETER ( rel_X = -5.555e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.665e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[2] ),
					PARAMETER ( rel_X = 3.334e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 11.669e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[3] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.999e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[4] ),
					PARAMETER ( rel_X = -6.668e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.557e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[2] ),
					PARAMETER ( rel_X = -5.553e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[6] ),
					PARAMETER ( rel_X = -1.124e-6 ),
					PARAMETER ( rel_Y = 0.562e-6 ),
					PARAMETER ( rel_Z = 24.728e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[7] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b2s34[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b2s34[7] ),
					PARAMETER ( rel_X = -6.664e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.552e-6 ),
					PARAMETER ( DIA = 0.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s35[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[2] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 4.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[0] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[1] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.888e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[2] ),
					PARAMETER ( rel_X = 18.319e-6 ),
					PARAMETER ( rel_Y = -1.182e-6 ),
					PARAMETER ( rel_Z = -17.728e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[1] ),
					PARAMETER ( rel_X = -5.559e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[4] ),
					PARAMETER ( rel_X = -7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[5] ),
					PARAMETER ( rel_X = -4.446e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.114e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[6] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[7] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -6.115e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[8] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[9] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -12.780e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[7] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -5.001e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[11] ),
					PARAMETER ( rel_X = 4.149e-6 ),
					PARAMETER ( rel_Y = 0.593e-6 ),
					PARAMETER ( rel_Z = -13.632e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[12] ),
					PARAMETER ( rel_X = -11.115e-6 ),
					PARAMETER ( rel_Y = -0.585e-6 ),
					PARAMETER ( rel_Z = -18.135e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[5] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[14] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[15] ),
					PARAMETER ( rel_X = -8.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[16] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[14] ),
					PARAMETER ( rel_X = -1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.885e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[18] ),
					PARAMETER ( rel_X = -8.349e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 8.349e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s35[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s35[19] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s36[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[3] ),
					PARAMETER ( rel_X = -8.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 4.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.670e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[1] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[2] ),
					PARAMETER ( rel_X = -5.003e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[3] ),
					PARAMETER ( rel_X = -17.615e-6 ),
					PARAMETER ( rel_Y = 1.761e-6 ),
					PARAMETER ( rel_Z = -1.761e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[0] ),
					PARAMETER ( rel_X = -4.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[5] ),
					PARAMETER ( rel_X = -17.306e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.791e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[6] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[7] ),
					PARAMETER ( rel_X = -6.108e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.332e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s36[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s36[7] ),
					PARAMETER ( rel_X = -12.782e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s37[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[4] ),
					PARAMETER ( rel_X = 4.440e-6 ),
					PARAMETER ( rel_Y = 1.665e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 5.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s37[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[0] ),
					PARAMETER ( rel_X = 1.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[1] ),
					PARAMETER ( rel_X = 1.110e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.885e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[2] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -4.444e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[3] ),
					PARAMETER ( rel_X = 15.478e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -9.745e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[4] ),
					PARAMETER ( rel_X = 8.893e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.556e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[1] ),
					PARAMETER ( rel_X = 4.998e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[6] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[7] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[8] ),
					PARAMETER ( rel_X = 12.244e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 4.452e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[9] ),
					PARAMETER ( rel_X = 7.225e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[9] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 5.553e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[8] ),
					PARAMETER ( rel_X = 10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.889e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[12] ),
					PARAMETER ( rel_X = 6.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[12] ),
					PARAMETER ( rel_X = 7.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[7] ),
					PARAMETER ( rel_X = 3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.554e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[15] ),
					PARAMETER ( rel_X = 21.229e-6 ),
					PARAMETER ( rel_Y = -0.559e-6 ),
					PARAMETER ( rel_Z = 8.380e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[15] ),
					PARAMETER ( rel_X = -4.134e-6 ),
					PARAMETER ( rel_Y = 0.591e-6 ),
					PARAMETER ( rel_Z = 30.707e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[0] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[18] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[19] ),
					PARAMETER ( rel_X = 3.934e-6 ),
					PARAMETER ( rel_Y = -0.562e-6 ),
					PARAMETER ( rel_Z = 20.794e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[20] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[21] ),
					PARAMETER ( rel_X = 8.642e-6 ),
					PARAMETER ( rel_Y = 0.617e-6 ),
					PARAMETER ( rel_Z = 1.852e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[22] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 1.17e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[20] ),
					PARAMETER ( rel_X = -3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[24] ),
					PARAMETER ( rel_X = -16.151e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -5.768e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[18] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.334e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[26] ),
					PARAMETER ( rel_X = -3.364e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 21.306e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[27] ),
					PARAMETER ( rel_X = -8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[27] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.107e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[29] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.338e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[30] ),
					PARAMETER ( rel_X = 9.610e-6 ),
					PARAMETER ( rel_Y = -0.565e-6 ),
					PARAMETER ( rel_Z = 6.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[31] ),
					PARAMETER ( rel_X = 20.702e-6 ),
					PARAMETER ( rel_Y = 0.560e-6 ),
					PARAMETER ( rel_Z = 1.119e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[31] ),
					PARAMETER ( rel_X = 0.557e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 21.733e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[30] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[34] ),
					PARAMETER ( rel_X = -8.894e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -1.112e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[34] ),
					PARAMETER ( rel_X = 1.666e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[36] ),
					PARAMETER ( rel_X = 1.669e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.669e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[37] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[38] ),
					PARAMETER ( rel_X = 7.775e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 7.775e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[37] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s37[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s37[40] ),
					PARAMETER ( rel_X = -3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.668e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s38[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[5] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 6.115e-6 ),
					PARAMETER ( DIA = 3.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[0] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.559e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 2.328e-6 ),
					PARAMETER ( rel_Z = 11.058e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[2] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s38[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s38[3] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.667e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s39[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[7] ),
					PARAMETER ( rel_X = -7.779e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.222e-6 ),
					PARAMETER ( DIA = 4.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[0] ),
					PARAMETER ( rel_X = -2.218e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.109e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[1] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 2.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[2] ),
					PARAMETER ( rel_X = -8.529e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.843e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[3] ),
					PARAMETER ( rel_X = -12.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[4] ),
					PARAMETER ( rel_X = -9.922e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.085e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[1] ),
					PARAMETER ( rel_X = -6.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[6] ),
					PARAMETER ( rel_X = -6.111e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -1.111e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[7] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[8] ),
					PARAMETER ( rel_X = -19.680e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.615e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[9] ),
					PARAMETER ( rel_X = -12.224e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[0] ),
					PARAMETER ( rel_X = -4.998e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 4.998e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[11] ),
					PARAMETER ( rel_X = -13.376e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.032e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s39[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s39[12] ),
					PARAMETER ( rel_X = -2.220e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.330e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s40[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[9] ),
					PARAMETER ( rel_X = -5.559e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.780e-6 ),
					PARAMETER ( DIA = 4.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[0] ),
					PARAMETER ( rel_X = -1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[1] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[2] ),
					PARAMETER ( rel_X = -3.335e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = -6.113e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[0] ),
					PARAMETER ( rel_X = -5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[4] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.777e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[5] ),
					PARAMETER ( rel_X = -3.330e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -2.775e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s40[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s40[4] ),
					PARAMETER ( rel_X = -6.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 6.110e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s41[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[10] ),
					PARAMETER ( rel_X = 3.885e-6 ),
					PARAMETER ( rel_Y = -1.110e-6 ),
					PARAMETER ( rel_Z = 1.665e-6 ),
					PARAMETER ( DIA = 3.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[0] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.333e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[1] ),
					PARAMETER ( rel_X = -0.556e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.444e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[2] ),
					PARAMETER ( rel_X = 2.776e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.329e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[1] ),
					PARAMETER ( rel_X = 8.335e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.668e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[4] ),
					PARAMETER ( rel_X = 16.167e-6 ),
					PARAMETER ( rel_Y = -0.557e-6 ),
					PARAMETER ( rel_Z = -4.460e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[5] ),
					PARAMETER ( rel_X = 8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -7.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[6] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[5] ),
					PARAMETER ( rel_X = 2.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.667e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s41[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s41[4] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 13.887e-6 ),
					PARAMETER ( DIA = 1.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s42[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[12] ),
					PARAMETER ( rel_X = -10.005e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 4.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[0] ),
					PARAMETER ( rel_X = -24.695e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.490e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[1] ),
					PARAMETER ( rel_X = -7.778e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.778e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s42[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s42[2] ),
					PARAMETER ( rel_X = -9.444e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[14] ),
					PARAMETER ( rel_X = -3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[0] ),
					PARAMETER ( rel_X = -3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[1] ),
					PARAMETER ( rel_X = -11.837e-6 ),
					PARAMETER ( rel_Y = 0.564e-6 ),
					PARAMETER ( rel_Z = -10.146e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[2] ),
					PARAMETER ( rel_X = -14.440e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -8.890e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s43[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s43[1] ),
					PARAMETER ( rel_X = -3.889e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s44[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[15] ),
					PARAMETER ( rel_X = -5.558e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 11.116e-6 ),
					PARAMETER ( DIA = 5.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s44[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[0] ),
					PARAMETER ( rel_X = 2.780e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.224e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[1] ),
					PARAMETER ( rel_X = 6.111e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[2] ),
					PARAMETER ( rel_X = 6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[3] ),
					PARAMETER ( rel_X = 3.886e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.997e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[1] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 9.445e-6 ),
					PARAMETER ( DIA = 2.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[5] ),
					PARAMETER ( rel_X = 8.887e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.888e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[6] ),
					PARAMETER ( rel_X = 9.452e-6 ),
					PARAMETER ( rel_Y = -0.591e-6 ),
					PARAMETER ( rel_Z = 10.634e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[7] ),
					PARAMETER ( rel_X = 3.333e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.776e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[7] ),
					PARAMETER ( rel_X = 5.560e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.112e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[5] ),
					PARAMETER ( rel_X = -1.667e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[10] ),
					PARAMETER ( rel_X = 3.891e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 7.782e-6 ),
					PARAMETER ( DIA = 2.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[11] ),
					PARAMETER ( rel_X = 8.888e-6 ),
					PARAMETER ( rel_Y = 1.667e-6 ),
					PARAMETER ( rel_Z = 2.778e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[12] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 16.669e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[11] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 6.665e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[14] ),
					PARAMETER ( rel_X = 4.443e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.329e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[10] ),
					PARAMETER ( rel_X = -6.113e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 7.224e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[16] ),
					PARAMETER ( rel_X = 5.002e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.448e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[17] ),
					PARAMETER ( rel_X = 10.554e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[18] ),
					PARAMETER ( rel_X = 14.400e-6 ),
					PARAMETER ( rel_Y = 3.600e-6 ),
					PARAMETER ( rel_Z = 13.800e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[19] ),
					PARAMETER ( rel_X = 28.282e-6 ),
					PARAMETER ( rel_Y = -3.463e-6 ),
					PARAMETER ( rel_Z = -5.195e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[17] ),
					PARAMETER ( rel_X = 0.555e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 5.555e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[21] ),
					PARAMETER ( rel_X = 7.339e-6 ),
					PARAMETER ( rel_Y = 1.129e-6 ),
					PARAMETER ( rel_Z = 28.226e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[22] ),
					PARAMETER ( rel_X = -5.750e-6 ),
					PARAMETER ( rel_Y = -0.575e-6 ),
					PARAMETER ( rel_Z = 9.200e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[16] ),
					PARAMETER ( rel_X = 7.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[24] ),
					PARAMETER ( rel_X = 6.108e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[0] ),
					PARAMETER ( rel_X = -4.440e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[26] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.552e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[27] ),
					PARAMETER ( rel_X = -2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 10.559e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[28] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 18.890e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[26] ),
					PARAMETER ( rel_X = -1.113e-6 ),
					PARAMETER ( rel_Y = 0.557e-6 ),
					PARAMETER ( rel_Z = 1.113e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[30] ),
					PARAMETER ( rel_X = -5.001e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.334e-6 ),
					PARAMETER ( DIA = 1.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[31] ),
					PARAMETER ( rel_X = -2.775e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[32] ),
					PARAMETER ( rel_X = 4.999e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -7.221e-6 ),
					PARAMETER ( DIA = 1.39e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[33] ),
					PARAMETER ( rel_X = 2.220e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[34] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.220e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[34] ),
					PARAMETER ( rel_X = 4.445e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.223e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[32] ),
					PARAMETER ( rel_X = -3.333e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -7.778e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[30] ),
					PARAMETER ( rel_X = -1.664e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 0.555e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[38] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.330e-6 ),
					PARAMETER ( DIA = 2.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[39] ),
					PARAMETER ( rel_X = -1.111e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.443e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[40] ),
					PARAMETER ( rel_X = -10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.889e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[42]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[41] ),
					PARAMETER ( rel_X = -8.329e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 2.221e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[43]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[38] ),
					PARAMETER ( rel_X = -3.888e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[44]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[43] ),
					PARAMETER ( rel_X = -6.114e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.003e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[45]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[44] ),
					PARAMETER ( rel_X = -7.225e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 2.83e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[46]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[45] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 3.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[47]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[46] ),
					PARAMETER ( rel_X = -8.330e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[48]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[47] ),
					PARAMETER ( rel_X = -12.222e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 6.111e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s44[49]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s44[45] ),
					PARAMETER ( rel_X = -3.334e-6 ),
					PARAMETER ( rel_Y = 2.778e-6 ),
					PARAMETER ( rel_Z = 1.111e-6 ),
					PARAMETER ( DIA = 2.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s45[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[16] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 4.06e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[0] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = -4.443e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[1] ),
					PARAMETER ( rel_X = -2.221e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -6.109e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[2] ),
					PARAMETER ( rel_X = 0.000e-6 ),
					PARAMETER ( rel_Y = -2.224e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[0] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = -1.668e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 3.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[4] ),
					PARAMETER ( rel_X = 3.337e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.224e-6 ),
					PARAMETER ( DIA = 3.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[5] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.886e-6 ),
					PARAMETER ( DIA = 2.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[6] ),
					PARAMETER ( rel_X = 1.668e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -3.891e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[7] ),
					PARAMETER ( rel_X = 5.182e-6 ),
					PARAMETER ( rel_Y = 0.576e-6 ),
					PARAMETER ( rel_Z = -14.395e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[8] ),
					PARAMETER ( rel_X = 12.780e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = -2.778e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[6] ),
					PARAMETER ( rel_X = 6.665e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.666e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[10] ),
					PARAMETER ( rel_X = 10.003e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = -3.890e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[4] ),
					PARAMETER ( rel_X = 1.113e-6 ),
					PARAMETER ( rel_Y = 1.113e-6 ),
					PARAMETER ( rel_Z = 0.557e-6 ),
					PARAMETER ( DIA = 3.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[12] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 2.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[13] ),
					PARAMETER ( rel_X = 6.663e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 1.666e-6 ),
					PARAMETER ( DIA = 1.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[14] ),
					PARAMETER ( rel_X = 3.336e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -1.668e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[16]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[15] ),
					PARAMETER ( rel_X = 3.067e-6 ),
					PARAMETER ( rel_Y = 0.613e-6 ),
					PARAMETER ( rel_Z = -8.588e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[17]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[16] ),
					PARAMETER ( rel_X = -1.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.218e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[18]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[17] ),
					PARAMETER ( rel_X = 20.101e-6 ),
					PARAMETER ( rel_Y = -2.319e-6 ),
					PARAMETER ( rel_Z = -3.866e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[19]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[16] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = -4.447e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[20]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[12] ),
					PARAMETER ( rel_X = 3.335e-6 ),
					PARAMETER ( rel_Y = -2.223e-6 ),
					PARAMETER ( rel_Z = 8.337e-6 ),
					PARAMETER ( DIA = 3.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[21]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[20] ),
					PARAMETER ( rel_X = -2.222e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[22]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[21] ),
					PARAMETER ( rel_X = 2.777e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 9.440e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[23]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[22] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.448e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[24]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[20] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = 1.666e-6 ),
					PARAMETER ( rel_Z = 2.222e-6 ),
					PARAMETER ( DIA = 2.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[25]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[24] ),
					PARAMETER ( rel_X = 8.885e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -0.555e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[26]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[25] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -5.553e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[27]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[26] ),
					PARAMETER ( rel_X = 6.109e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -2.221e-6 ),
					PARAMETER ( DIA = 1.72e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[28]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[27] ),
					PARAMETER ( rel_X = 5.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 4.445e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[29]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[25] ),
					PARAMETER ( rel_X = 6.670e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 0.000e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[30]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[29] ),
					PARAMETER ( rel_X = 9.444e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -0.556e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[31]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[30] ),
					PARAMETER ( rel_X = 15.731e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -8.157e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[32]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[30] ),
					PARAMETER ( rel_X = 13.334e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 3.889e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[33]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[24] ),
					PARAMETER ( rel_X = 2.222e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 4.444e-6 ),
					PARAMETER ( DIA = 1.67e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[34]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[33] ),
					PARAMETER ( rel_X = 1.111e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 10.557e-6 ),
					PARAMETER ( DIA = 1.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[35]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[34] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = 3.887e-6 ),
					PARAMETER ( DIA = 1.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[36]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[33] ),
					PARAMETER ( rel_X = 2.221e-6 ),
					PARAMETER ( rel_Y = 1.110e-6 ),
					PARAMETER ( rel_Z = 1.110e-6 ),
					PARAMETER ( DIA = 1.50e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[37]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[36] ),
					PARAMETER ( rel_X = 4.448e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = -3.336e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[38]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[37] ),
					PARAMETER ( rel_X = 6.114e-6 ),
					PARAMETER ( rel_Y = -1.667e-6 ),
					PARAMETER ( rel_Z = 2.779e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[39]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[38] ),
					PARAMETER ( rel_X = 4.996e-6 ),
					PARAMETER ( rel_Y = 0.555e-6 ),
					PARAMETER ( rel_Z = -3.331e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[40]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[38] ),
					PARAMETER ( rel_X = 21.923e-6 ),
					PARAMETER ( rel_Y = 3.322e-6 ),
					PARAMETER ( rel_Z = 9.965e-6 ),
					PARAMETER ( DIA = 1.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s45[41]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s45[36] ),
					PARAMETER ( rel_X = 10.000e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.000e-6 ),
					PARAMETER ( DIA = 1.33e-6 ),
				END PARAMETERS
			END CHILD
			CHILD thickd b3s46[0]
				PARAMETERS
					PARAMETER ( PARENT = ^/br3[16] ),
					PARAMETER ( rel_X = 2.223e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.669e-6 ),
					PARAMETER ( DIA = 3.94e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[1]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[0] ),
					PARAMETER ( rel_X = 5.001e-6 ),
					PARAMETER ( rel_Y = 0.556e-6 ),
					PARAMETER ( rel_Z = 12.225e-6 ),
					PARAMETER ( DIA = 2.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[2]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[1] ),
					PARAMETER ( rel_X = 5.558e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 5.558e-6 ),
					PARAMETER ( DIA = 2.28e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[3]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[2] ),
					PARAMETER ( rel_X = 3.890e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 6.668e-6 ),
					PARAMETER ( DIA = 2.00e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[4]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[3] ),
					PARAMETER ( rel_X = 4.444e-6 ),
					PARAMETER ( rel_Y = -0.555e-6 ),
					PARAMETER ( rel_Z = 14.442e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[5]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[3] ),
					PARAMETER ( rel_X = 8.885e-6 ),
					PARAMETER ( rel_Y = -1.666e-6 ),
					PARAMETER ( rel_Z = 6.108e-6 ),
					PARAMETER ( DIA = 1.61e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[6]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[5] ),
					PARAMETER ( rel_X = -1.178e-6 ),
					PARAMETER ( rel_Y = 0.589e-6 ),
					PARAMETER ( rel_Z = 18.263e-6 ),
					PARAMETER ( DIA = 1.22e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[7]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[1] ),
					PARAMETER ( rel_X = 1.667e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 14.444e-6 ),
					PARAMETER ( DIA = 2.11e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[8]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[7] ),
					PARAMETER ( rel_X = 3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 11.663e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[9]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[8] ),
					PARAMETER ( rel_X = 6.668e-6 ),
					PARAMETER ( rel_Y = -0.556e-6 ),
					PARAMETER ( rel_Z = 3.890e-6 ),
					PARAMETER ( DIA = 1.89e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[10]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[9] ),
					PARAMETER ( rel_X = 8.331e-6 ),
					PARAMETER ( rel_Y = 1.111e-6 ),
					PARAMETER ( rel_Z = 7.220e-6 ),
					PARAMETER ( DIA = 1.56e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[11]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[10] ),
					PARAMETER ( rel_X = 4.582e-6 ),
					PARAMETER ( rel_Y = 2.291e-6 ),
					PARAMETER ( rel_Z = 13.747e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[12]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[11] ),
					PARAMETER ( rel_X = -16.665e-6 ),
					PARAMETER ( rel_Y = -1.111e-6 ),
					PARAMETER ( rel_Z = 11.110e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[13]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[8] ),
					PARAMETER ( rel_X = -3.332e-6 ),
					PARAMETER ( rel_Y = 0.000e-6 ),
					PARAMETER ( rel_Z = 8.886e-6 ),
					PARAMETER ( DIA = 1.78e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[14]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[13] ),
					PARAMETER ( rel_X = -6.600e-6 ),
					PARAMETER ( rel_Y = 0.600e-6 ),
					PARAMETER ( rel_Z = 16.200e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD
			CHILD spinyd b3s46[15]
				PARAMETERS
					PARAMETER ( PARENT = ^/b3s46[14] ),
					PARAMETER ( rel_X = -1.900e-6 ),
					PARAMETER ( rel_Y = 4.433e-6 ),
					PARAMETER ( rel_Z = 17.733e-6 ),
					PARAMETER ( DIA = 1.44e-6 ),
				END PARAMETERS
			END CHILD

		END SEGMENT_GROUP

	END CELL

END PUBLIC_MODELS
',
						   timeout => 113,
						   write => undef,
						  },
						 ],
				description => "conversion and activation of a Purkinje cell morphology file, taken from the Genesis Purkinje cell tutorial, with hardcoded prototypes for some segments.",
			       },
			       {
				arguments => [
					      '/tmp/neurospaces/test/models/morphologies/C170897A-P3.CNG.swc',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   comment => "Due to regex backtracking, this test runs really slow.  The morphology used for this test, has been obtained from <a href=\"http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3\">http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3</a>",
						   description => "Can a SWC morphology file be converted and activated ?",
						   read => [
							    '-re',
							    '#!/.*/neurospacesparse
// -\\*- NEUROSPACES -\\*-
// Neurospaces morphology file for a neuron
// converted by .*?/convertors/morphology2ndf, .*?200.
//
// .*?/convertors/morphology2ndf configuration follows:
//
(.|\\n)*?
// variables:
(.|\\n)*?
NEUROSPACES NDF

IMPORT
(.|\\n)*?
END IMPORT


PRIVATE_MODELS
(.|\\n)*?
END PRIVATE_MODELS


PUBLIC_MODELS

	CELL C170897A_P3_CNG

		SEGMENT_GROUP segments

			CHILD soma soma
				PARAMETERS
			
					PARAMETER \\( rel_X = 0\\.000e-6 \\),
					PARAMETER \\( rel_Y = 0\\.000e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 6\\.467e-6 \\),
					PARAMETER \\( TAG = "1" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_2
				PARAMETERS
					PARAMETER \\( PARENT = \\^/soma \\),
					PARAMETER \\( rel_X = -0\\.669000000000003e-6 \\),
					PARAMETER \\( rel_Y = 8\\.359e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_3
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_2 \\),
					PARAMETER \\( rel_X = 1\\.070e-6 \\),
					PARAMETER \\( rel_Y = 5\\.560e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_4
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_3 \\),
					PARAMETER \\( rel_X = 0\\.829999999999997e-6 \\),
					PARAMETER \\( rel_Y = 4\\.250e-6 \\),
					PARAMETER \\( rel_Z = -2\\.400e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_5
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_4 \\),
					PARAMETER \\( rel_X = -0\\.360000000000003e-6 \\),
					PARAMETER \\( rel_Y = 5\\.170e-6 \\),
					PARAMETER \\( rel_Z = 4\\.530e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_6
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_5 \\),
					PARAMETER \\( rel_X = 0\\.900000000000002e-6 \\),
					PARAMETER \\( rel_Y = 4\\.57999999999999e-6 \\),
					PARAMETER \\( rel_Z = 1\\.870e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_7
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_6 \\),
					PARAMETER \\( rel_X = 3\\.240e-6 \\),
					PARAMETER \\( rel_Y = 4\\.470e-6 \\),
					PARAMETER \\( rel_Z = -6\\.140e-6 \\),
					PARAMETER \\( DIA = 0\\.665e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
((\\s|\\n)*?CHILD((?!END CHILD).|\\n)*?END CHILD){1663}(\\s|\\n)*?
		END SEGMENT_GROUP

	END CELL

END PUBLIC_MODELS

',
							   ],
						   timeout => 113,
						   write => undef,
						  },
						 ],
				description => "conversion and activation of a SWC morphology file",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              '/tmp/neurospaces/test/models/conversions/morphology2ndf_soma_dendrite.yml',
					      '/tmp/neurospaces/test/models/morphologies/C170897A-P3.CNG.swc',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   comment => "Due to regex backtracking, this test runs really slow.  The morphology used for this test, has been obtained from <a href=\"http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3\">http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=C170897A-P3</a>",
						   description => "Can a SWC morphology file be converted and activated, based on TAG values ?",
						   read => [
							    '-re',
							    '#!/.*/neurospacesparse
// -\\*- NEUROSPACES -\\*-
// Neurospaces morphology file for a neuron
// converted by .*?/convertors/morphology2ndf, .*?200.
//
// .*?/convertors/morphology2ndf configuration follows:
//
(.|\\n)*?
// variables:
(.|\\n)*?
NEUROSPACES NDF

IMPORT
(.|\\n)*?
END IMPORT


PRIVATE_MODELS
(.|\\n)*?
END PRIVATE_MODELS


PUBLIC_MODELS

	CELL C170897A_P3_CNG

		SEGMENT_GROUP segments

			CHILD soma soma
				PARAMETERS
			
					PARAMETER \\( rel_X = 0\\.000e-6 \\),
					PARAMETER \\( rel_Y = 0\\.000e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 6\\.467e-6 \\),
					PARAMETER \\( TAG = "1" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_2
				PARAMETERS
					PARAMETER \\( PARENT = \\^/soma \\),
					PARAMETER \\( rel_X = -0\\.669000000000003e-6 \\),
					PARAMETER \\( rel_Y = 8\\.359e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_3
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_2 \\),
					PARAMETER \\( rel_X = 1\\.070e-6 \\),
					PARAMETER \\( rel_Y = 5\\.560e-6 \\),
					PARAMETER \\( rel_Z = 0\\.000e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_4
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_3 \\),
					PARAMETER \\( rel_X = 0\\.829999999999997e-6 \\),
					PARAMETER \\( rel_Y = 4\\.250e-6 \\),
					PARAMETER \\( rel_Z = -2\\.400e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_5
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_4 \\),
					PARAMETER \\( rel_X = -0\\.360000000000003e-6 \\),
					PARAMETER \\( rel_Y = 5\\.170e-6 \\),
					PARAMETER \\( rel_Z = 4\\.530e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_6
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_5 \\),
					PARAMETER \\( rel_X = 0\\.900000000000002e-6 \\),
					PARAMETER \\( rel_Y = 4\\.57999999999999e-6 \\),
					PARAMETER \\( rel_Z = 1\\.870e-6 \\),
					PARAMETER \\( DIA = 1\\.00e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
			CHILD spinyd s_7
				PARAMETERS
					PARAMETER \\( PARENT = \\^/s_6 \\),
					PARAMETER \\( rel_X = 3\\.240e-6 \\),
					PARAMETER \\( rel_Y = 4\\.470e-6 \\),
					PARAMETER \\( rel_Z = -6\\.140e-6 \\),
					PARAMETER \\( DIA = 0\\.665e-6 \\),
					PARAMETER \\( TAG = "4" \\),
				END PARAMETERS
			END CHILD
((\\s|\\n)*?CHILD((?!END CHILD).|\\n)*?END CHILD){312}(\\s|\\n)*?((// no prototype defined for s_[-0-9, e\\.()]*)(\\s|\\n)*){1351}(.|\\n)*?
		END SEGMENT_GROUP

	END CELL

END PUBLIC_MODELS

',
							   ],
						   timeout => 113,
						   write => undef,
						  },
						 ],
				description => "conversion and activation of a SWC morphology file, based on TAG values",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              '/tmp/neurospaces/test/models/conversions/morphology2ndf_error_soma_dendrite.yml',
					      '/tmp/neurospaces/test/models/morphologies/C170897A-P3.CNG.swc',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Is invalid usage of dia and tag parameters for prototype assignments reported properly ?",
						   read => 'the prototype_configuration does not use dia and tag in a consistent way (must use exactly one of them)',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "invalid usage of dia and tag parameters for prototype assignments",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              '/tmp/neurospaces/test/models/conversions/morphology2ndf.yml',
                                              '--show-config',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Can an external configuration be loaded ?",
						   read => 'algorithms:
  spines:
    fDendrDiaMax: 3.17
    fDendrDiaMin: 0.00
    fSpineDensity: 13.0
    fSpineFrequency: 1.0
library: {}
options:
  histology:
    shrinkage: 1.1111
  relocation:
    soma_offset: 1
prototypes:
  aliasses:
    - segments/spines/purkinje.ndf::Purk_spine
    - segments/purkinje/soma.ndf::soma
    - segments/purkinje/spinyd.ndf::spinyd
  parameter_2_prototype:
    - dia: 3.18e-06
      prototype: spinyd
    - dia: 1
      prototype: soma
  spine_prototypes: []
variables:
  origin:
    x: 0
    y: 0
    z: 0
',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "loading of an external configuration",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              '/tmp/neurospaces/test/models/conversions/morphology2ndf_error.yml',
                                              '--show-config',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Is an error in an external configuration file reported properly ?",
						   read => 'cannot read configuration file',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "error in an external configuration file",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              '/tmp/neurospaces/test/models/conversions/morphology2ndf_inconsistent_alias.yml',
                                              '--show-config',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Is an error in an inconsistency in the aliasses of a configuration file reported properly ?",
						   read => 'prototype soma used, but not in the aliasses section, there is no file associated with this prototype',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "inconsistency in the aliasses of a configuration file",
			       },
			       {
				arguments => [
					      '--configuration-filename',
                                              'does_not_exist',
                                              '--show-config',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Is a missing external configuration file reported properly ?",
						   read => 'cannot read configuration file',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "missing external configuration file",
			       },
			       {
				arguments => [
					      '--no-use-library',
                                              '--show-config',
					     ],
				command => './convertors/morphology2ndf',
				command_tests => [
						  {
						   description => "Can we avoid using the library ?",
						   read => 'options:
  histology:
    shrinkage: 1
  relocation:
    soma_offset: 1
prototypes:
  aliasses:
    - segments/spines/purkinje.ndf::Purk_spine
    - segments/purkinje/maind.ndf::maind
    - segments/purkinje/soma.ndf::soma
    - segments/purkinje/spinyd.ndf::spinyd
    - segments/purkinje/thickd.ndf::thickd
  parameter_2_prototype:
    - dia: 3.18e-06
      prototype: spinyd
    - dia: 7.71e-06
      prototype: thickd
    - dia: 2.8e-05
      prototype: maind
    - dia: 1
      prototype: soma
  spine_prototypes: []
variables:
  origin:
    x: 0
    y: 0
    z: 0
',
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "force not to use the library",
			       },
			      ],
       comment => "Note: see also <a href=\"http://neuromorpho.org/neuroMorpho/StdSwc1.21.jsp\">information about SWC files</a> and <a href=\"http://www.genesis-sim.org/GENESIS/Hyperdoc/Manual-25.html#ss25.131\">information about Genesis .p files</a>.",
       description => "morphology conversion utilities",
       name => 'morphology2ndf.t',
      };


return $test;


