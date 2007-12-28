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

				    my $definitions_header = `cat "$directory/hierarchy/output/symbols/type_defines.h"`;

				    if (!$definitions_header)
				    {
					$definitions_header = `cat "$directory/_build/hierarchy/output/symbols/type_defines.h"`;
				    }

				    #! note: commented out types are also counted

				    my $types = [ grep { /#define HIERARCHY_TYPE_symbols_/ } split '\n', $definitions_header, ];

				    print "Found $#$types + 1 symbol types\n";

				    my $type_count = [ grep { /^#define COUNT_HIERARCHY_TYPE_symbols/ } split '\n', $definitions_header, ];

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

				    my $definitions_impl = `cat "$directory/hierarchy/output/symbols/long_descriptions.c"`;

				    if (!$definitions_impl)
				    {
					$definitions_impl = `cat "$directory/_build/hierarchy/output/symbols/long_descriptions.c"`;
				    }

				    $definitions_impl =~ /char \*ppc_symbols_long_descriptions\[COUNT_HIERARCHY_TYPE_symbols \+ 2\] =.*?\{(.*?)\}/s;

				    my $descriptions_long = $1;

				    $descriptions_long = [ split ',', $descriptions_long, ];

				    # -1 for terminator, -1 for first entry

				    my $descriptions_long_count = (scalar @$descriptions_long) - 1 - 1;

				    print "Found $descriptions_long_count long descriptions\n";

				    if ($descriptions_long_count != $type_count)
				    {
					return "Mismatch of count for long symbol type descriptions ($descriptions_long_count vs $type_count)";
				    }

# 				    my $definitions_impl_short = `cat $directory/symboltable.c`;

				    my $definitions_impl_short = `cat "$directory/hierarchy/output/symbols/short_descriptions.c"`;

				    if (!$definitions_impl_short)
				    {
					$definitions_impl_short = `cat "$directory/_build/hierarchy/output/symbols/short_descriptions.c"`;
				    }

				    $definitions_impl =~ /char \*ppc_symbols_short_descriptions\[COUNT_HIERARCHY_TYPE_symbols \+ 2\] =.*?\{(.*?)\}/s;

				    my $descriptions_short = $1;

				    $descriptions_short = [ split ',', $descriptions_short, ];

				    # -1 for terminator, -1 for first entry

				    my $descriptions_short_count = (scalar @$descriptions_short) - 1 - 1;

				    print "Found $descriptions_short_count short descriptions\n";

				    if ($descriptions_short_count != $type_count)
				    {
					return "Mismatch of count for short symbol type descriptions ($descriptions_short_count vs $type_count)";
				    }

				    return undef;
				},
				command_tests => [
						  {
						   description => "count match for symbol types",
						  },
						 ],
				description => "consistency of symbol type definitions",
			       },
			      ],
       description => "C code symbol types",
       name => 'symboltypes.t',
      };


return $test;


