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

				    my $symbol_hierarchy = do "$directory/hierarchy/symbols";

# 				    my $neurospaces_perl_modules = $directory;

# 				    # find the Neurospaces perl modules directory

# 				    $neurospaces_perl_modules .= "/perl";

# 				    # add to include path

# 				    unshift @INC, $neurospaces_perl_modules;

				    require Data::Transformator;

				    my $transformator
					= Data::Transformator->new
					    (
					     apply_identity_transformation => 0,
					     name => 'symbol-alias-selector',
					     contents => $symbol_hierarchy,
					     separator => '/',
					     hash_filter =>
					     sub
					     {
						 my ($context, $component) = @_;

# 						 # never filter for the first two component in the path

# 						 my $depth = $context->{array};

# 						 $depth = $#$depth;

# 						 if ($depth < 4)
# 						 {
# 						     return 1;
# 						 }

						 # extract the data

						 if ($context->{path} =~ m|^[^/]*/class_hierarchy/([^/]*)/allows/create_alias$|)
						 {
						     my $symbol = $1;

						     my $type = Data::Transformator::_context_get_current_content($context);

						     # push it onto the result

						     my $result = Data::Transformator::_context_get_main_result($context);

						     if (!$result->{content})
						     {
							 $result->{content} = [];
						     }

						     push @{$result->{content}}, [ $symbol, $type, ];
						 }

						 # never filter

						 1;
					     },
					    );

				    # select data of interest

				    my $create_alias_selection
					= $transformator->transform();

# 				    use Data::Dumper;

# 				    print Dumper($create_alias_selection);

				    # count number of symbols that can create aliasses

				    my $symbols_with_aliasses = $#$create_alias_selection + 1;

				    # check how many calls there are in the code

				    my $code_calls_grep = [ `cd $directory ; grep -n SymbolIncrementAliases *.c`, ];

				    my $code_calls = $#$code_calls_grep + 1;

				    # check if count is the same

				    if ($symbols_with_aliasses eq $code_calls)
				    {
					print "Found $symbols_with_aliasses create_alias declarations (in $directory)\n";
					print "Found $code_calls incrementors in the code (in $directory)\n";

					# return success

					return undef;
				    }
				    else
				    {
					print "Found $symbols_with_aliasses create_alias declarations (in $directory)\n";
					print "Found $code_calls incrementors in the code (in $directory)\n";

					# return failure

					return "Mismatch of count of create_alias declarations and create_alias incrementors";
				    }
				},
				command_tests => [
						  {
						   description => "alias creation count consistency checker",
						  },
						 ],
				description => "alias creation count consistency checker",
			       },
			      ],
       description => "symbol allocations and alias creation",
       name => 'allocations.t',
      };


return $test;


