#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       # without segment groups

			       (
				{
				 arguments => [
					       '-q',
					       '-R',
					       'utilities/some_segments.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "What are the original two segments (1) ?",
						    read => '    Name, index (two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (soma,-1)
        Type (T_sym_segment)
        segmenName, index (soma,-1)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
        Name, index (main[0],-1)
        Type (T_sym_segment)
        segmenName, index (main[0],-1)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /two_segments",
						   },
						   {
						    description => "Can we mesh a neuron model with two segments ?",
						    read => 'neurospaces ',
						    side_effects => 'resegmentation',
						    write => "mesh /two_segments 1e-5",
						   },
						   {
						    description => "What is the result of meshing the two segments, have they been replaced with new segments with correct aliassing ?",
						    read => '    Name, index (two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (soma,-1)
        Type (T_sym_segment)
        segmenName, index (soma,-1)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (soma,-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_0,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_0,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.778500e-06)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_1,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_1,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-3.320000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.778500e-06)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_0
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /two_segments",
						   },
						  ],
				 description => "meshing of simple segments",
				},
				{
				 arguments => [
					       '-q',
					       '-R',
					       'utilities/some_segments.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "What are the original two segments (2) ?",
						    read => '    Name, index (two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (soma,-1)
        Type (T_sym_segment)
        segmenName, index (soma,-1)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
        Name, index (main[0],-1)
        Type (T_sym_segment)
        segmenName, index (main[0],-1)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /two_segments",
						   },
						   {
						    description => "Can we mesh a neuron model with two segments ?",
						    read => 'neurospaces ',
						    side_effects => 'resegmentation',
						    write => "mesh /two_segments 1e-6",
						   },
						   {
						    description => "What is the result of meshing the two segments, have new segments been inserted with correct aliassing ?",
						    read => '    Name, index (two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (soma,-1)
        Type (T_sym_segment)
        segmenName, index (soma,-1)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (soma,-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_0,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_0,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_1,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_1,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.248000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_0
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_2,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_2,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.776000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_1
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_3,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_3,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.304000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_2
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_4,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_4,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(1.832000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_3
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_5,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_5,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.600000e-07)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_4
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_6,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_6,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-1.112000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_5
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_7,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_7,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-2.584000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_6
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_8,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_8,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-4.056000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_7
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_9,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_9,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-5.528000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_8
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_10,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_10,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-7.000000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_9
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_11,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_11,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-8.472000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_10
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_12,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_12,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-9.944000e-06)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_11
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_13,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_13,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-1.141600e-05)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_12
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        Name, index (main[0]_14,-1)
        Type (T_sym_segment)
        segmenName, index (main[0]_14,-1)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(-1.288800e-05)
            PARA  Name (rel_Z)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_Y)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
            PARA  Name (rel_X)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_13
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (main[0],-1)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /two_segments",
						   },
						  ],
				 description => "meshing of simple segments",
				},
			       ),

			       # with segment groups

			       (
				{
				 arguments => [
					       '-q',
					       '-R',
					       'utilities/some_segments.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "What are the original two segments (3) ?",
						    read => '    Name, index (grouped_two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (grouped_two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (segments,-1)
        Type (T_sym_v_segment)
        v_segmName, index (segments,-1)
        v_segm{-- begin HIER sections ---
            Name, index (soma,-1)
            Type (T_sym_segment)
            segmenName, index (soma,-1)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
            Name, index (main[0],-1)
            Type (T_sym_segment)
            segmenName, index (main[0],-1)
                PARA  Name (Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        v_segm}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /grouped_two_segments",
						   },
						   {
						    description => "Can we mesh a neuron model with two segments ?",
						    read => 'neurospaces ',
						    side_effects => 'resegmentation',
						    write => "mesh /grouped_two_segments 1e-5",
						   },
						   {
						    description => "What is the result of meshing the two grouped segments, have they been replaced with new segments with correct aliassing ?",
						    read => '    Name, index (grouped_two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (grouped_two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (segments,-1)
        Type (T_sym_v_segment)
        v_segmName, index (segments,-1)
        v_segm{-- begin HIER sections ---
            Name, index (soma,-1)
            Type (T_sym_segment)
            segmenName, index (soma,-1)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (soma,-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_0,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_0,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.778500e-06)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_1,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_1,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-3.320000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(4.723500e-06)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.778500e-06)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_0
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
        v_segm}--  end  HIER sections ---
            v_segmName, index (segments,-1)
            v_segm{-- begin HIER sections ---
            v_segm}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /grouped_two_segments",
						   },
						  ],
				 description => "meshing of simple segments",
				},
				{
				 arguments => [
					       '-q',
					       '-R',
					       'utilities/some_segments.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "What are the original two segments (4) ?",
						    read => '    Name, index (grouped_two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (grouped_two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (segments,-1)
        Type (T_sym_v_segment)
        v_segmName, index (segments,-1)
        v_segm{-- begin HIER sections ---
            Name, index (soma,-1)
            Type (T_sym_segment)
            segmenName, index (soma,-1)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
            Name, index (main[0],-1)
            Type (T_sym_segment)
            segmenName, index (main[0],-1)
                PARA  Name (Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
        v_segm}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /grouped_two_segments",
						   },
						   {
						    description => "Can we mesh a neuron model with two segments ?",
						    read => 'neurospaces ',
						    side_effects => 'resegmentation',
						    write => "mesh /grouped_two_segments 1e-6",
						   },
						   {
						    description => "What is the result of meshing the two grouped segments, have new segments been inserted with correct aliassing ?",
						    read => '    Name, index (grouped_two_segments,-1)
    Type (T_sym_cell)
    cell  Name, index (grouped_two_segments,-1)
    cell  {-- begin HIER sections ---
        Name, index (segments,-1)
        Type (T_sym_v_segment)
        v_segmName, index (segments,-1)
        v_segm{-- begin HIER sections ---
            Name, index (soma,-1)
            Type (T_sym_segment)
            segmenName, index (soma,-1)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (soma,-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.980000e-05)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_0,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_0,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_1,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_1,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.248000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_0
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_2,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_2,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(4.776000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_1
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_3,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_3,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.304000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_2
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_4,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_4,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.832000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_3
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_5,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_5,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.600000e-07)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_4
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_6,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_6,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-1.112000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_5
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_7,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_7,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-2.584000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_6
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_8,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_8,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-4.056000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_7
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_9,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_9,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-5.528000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_8
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_10,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_10,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-7.000000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_9
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_11,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_11,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-8.472000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_10
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_12,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_12,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-9.944000e-06)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_11
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_13,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_13,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-1.141600e-05)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_12
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
            Name, index (main[0]_14,-1)
            Type (T_sym_segment)
            segmenName, index (main[0]_14,-1)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(-1.288800e-05)
                PARA  Name (rel_Z)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_Y)
                PARA  Type (TYPE_PARA_NUMBER), Value(6.298000e-07)
                PARA  Name (rel_X)
                PARA  Type (TYPE_PARA_NUMBER), Value(3.704667e-07)
                PARA  Name (PARENT)
                PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../main[0]_13
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
                segmenName, index (main[0],-1)
                    PARA  Name (LENGTH)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.446969e-05)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../soma
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.557000e-06)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.447000e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.720000e-06)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
        v_segm}--  end  HIER sections ---
            v_segmName, index (segments,-1)
            v_segm{-- begin HIER sections ---
            v_segm}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
',
						    write => "printinfo /grouped_two_segments",
						   },
						  ],
				 description => "meshing of simple segments",
				},
			       ),

			       # purkinje cell

			       (
				{
				 arguments => [
					       '-q',
					       '-R',
					       'cells/purkinje/edsjb1994.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    comment => 'this command currently uses some algorithm meta info underway, harmless but should be fixed nevertheless, sometime.',
						    description => "Can we remesh the purkinje cell morphology ?",
						    read => 'neurospaces',
						    side_effects => 'resegmentation',
						    write => "mesh /Purkinje 1e-6",
						   },
						   {
						    description => "How many segments are in the result ?",
						    disabled => 'this result needs a thorough check',
						    read => 'Number of segments : 15789',
						    write => "segmentcount /Purkinje",
						   },
						  ],
				 description => "meshing of the purkinje cell morphology",
				 disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				},
			       ),
			      ],
       description => "meshing algorithms",
       disabled => 'meshing is partially broken, works for unpartioned cells only',
       name => 'meshing.t',
      };


return $test;


