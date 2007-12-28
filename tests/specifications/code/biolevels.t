#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command =>
				sub
				{
				    my $self = shift;

				    my $config = shift;

				    my $directory = $config->{c_code}->{directory};

				    my $symboltypes_header = `cat "$directory/hierarchy/output/symbols/type_defines.h"`;

				    if (!$symboltypes_header)
				    {
					$symboltypes_header = `cat "$directory/_build/hierarchy/output/symbols/type_defines.h"`;
				    }

				    #! note: commented out types are also counted

				    my $types = [ grep { /#define HIERARCHY_TYPE_/ } split '\n', $symboltypes_header, ];

				    print "Found $#$types + 1 symbol types\n";

				    my $type_count = [ grep { /^#define COUNT_HIERARCHY_TYPE/ } split '\n', $symboltypes_header, ];

				    if ($#$type_count != 0)
				    {
					return "Found more than one symbol type count";
				    }

				    $type_count->[0] =~ /([0-9]+)/;

				    $type_count = $1;

				    print "Found count of $type_count symbol types\n";

				    if ($#$types + 1 != $type_count)
				    {
					return "Mismatch of type count ($#$types + 1 vs $type_count)";
				    }

				    my $definitions_impl = `cat $directory/hierarchy/output/symbols/annotations/piSymbolType2Biolevel`;

				    if (!$definitions_impl)
				    {
					$definitions_impl = `cat "$directory/_build/hierarchy/output/symbols/annotations/piSymbolType2Biolevel"`;
				    }

# 				    $definitions_impl =~ /int piSymbolType2Biolevel\[COUNT_HIERARCHY_TYPE \+ 2\] =.*?\{(.*?)\}/s;

				    my $biolevelmapping = $definitions_impl; # $1;

				    $biolevelmapping = [ split ', //', $biolevelmapping, ];

				    # -1 for terminator, -1 for first entry

				    my $biolevelmapping_count = (scalar @$biolevelmapping) - 1 - 1;

				    print "Found $biolevelmapping_count entries in the biolevelmapping.\n";

				    if ($biolevelmapping_count != $type_count)
				    {
					return "Mismatch of count for symbol types and their biolevel mapping ($biolevelmapping_count vs $type_count)";
				    }

				    return undef;
				},
				command_tests => [
						  {
						   description => "count match for symbol types",
						  },
						 ],
				description => "consistency of symbol types and biolevels and biogroups",
			       },
			      ],
       description => "C code biolevels and biogroups",
       name => 'biolevels.t',
      };


return $test;


