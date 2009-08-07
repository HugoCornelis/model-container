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

				    my $definitions_header = `cat "$directory/neurospaces/parameters.h"`;

				    #! note: commented out types are also counted

				    my $types = [ grep { /#define TYPE_PARA_/ } split '\n', $definitions_header, ];

				    print "Found $#$types parameter types\n";

# 				    my $type_count = [ grep { /^#define COUNT_HIERARCHY_TYPE/ } split '\n', $definitions_header, ];

# 				    if ($#$type_count != 0)
# 				    {
# 					return "Found more than one symbol type count";
# 				    }

# 				    $type_count->[0] =~ /([0-9]+)/;

# 				    #! -1 for offset in perl

# 				    $type_count = $1 - 1;

# 				    my $missing_types = 5;

# 				    print "Assuming 5 missing symbol types\n";

# 				    $type_count -= $missing_types;

# 				    print "Found count of $type_count symbol types\n";

# 				    if ($#$types != $type_count)
# 				    {
# 					return "Mismatch of type count ($#$types vs $type_count)";
# 				    }

				    my $definitions_impl = `cat "$directory/parameters.c"`;

				    $definitions_impl =~ /char \*ppcParameterStruct\[\] =.*?\{(.*?)\}/s;

				    my $descriptions_long = $1;

				    $descriptions_long = [ split ',', $descriptions_long, ];

				    print "Found $#$descriptions_long long parameter descriptions\n";

				    if ($#$descriptions_long - 1 != $#$types + 1)
				    {
					return "Mismatch of count for long parameter type descriptions ($#$descriptions_long - 1 vs $#$types + 1)";
				    }

# 				    my $definitions_impl_short = `cat $directory/symboltable.c`;

				    my $definitions_impl_short = `cat "$directory/parameters.c"`;

				    $definitions_impl =~ /char \*ppcParameterStructShort\[\] =.*?\{(.*?)\}/s;

				    my $descriptions_short = $1;

				    $descriptions_short = [ split ',', $descriptions_short, ];

				    print "Found $#$descriptions_short short descriptions\n";

				    if ($#$descriptions_short - 1 != $#$types + 1)
				    {
					return "Mismatch of count for short parameter type descriptions ($#$descriptions_short - 1 vs $#$types + 1)";
				    }

				    return undef;
				},
				command_tests => [
						  {
						   description => "count match for parameter types",
						  },
						 ],
				description => "consistency of parameter type definitions",
			       },
			      ],
       description => "C code parameter types",
       name => 'code/parametertypes.t',
      };


return $test;


