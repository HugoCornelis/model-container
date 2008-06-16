#!/usr/bin/perl -w
#

use strict;


my $previous_library;

my $previous_library_custom;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we unset the model library directory in the environment ?",
						   read => [ 'Could not find file (number 0, 0), path name (channels/golgi_gabaa.ndf)
Set one of the environment variables NEUROSPACES_NMC_USER_MODELS,
NEUROSPACES_NMC_PROJECT_MODELS, NEUROSPACES_NMC_SYSTEM_MODELS or NEUROSPACES_NMC_MODELS
to point to a library where the required model is located,
or use the -m switch to configure where neurospaces looks for models.
', ],
						   write => undef,
						  },
						 ],
				description => "unsetting of the library directory in the environment",
				preparation => {
						description => "Removing the environment entry to point to a model library",
						preparer =>
						sub
						{
						    $previous_library = $ENV{NEUROSPACES_NMC_MODELS};

						    if (defined $ENV{NEUROSPACES_NMC_MODELS})
						    {
							undef $ENV{NEUROSPACES_NMC_MODELS};
						    }
						},
					       },
				reparation => {
					       description => "Restoring the environment entry to point to the model library",
					       reparer =>
					       sub
					       {
						   $ENV{NEUROSPACES_NMC_MODELS} = $previous_library;

						   return undef;
					       },
					      },
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we use the environment variable NEUROSPACES_NMC_USER_MODELS to point to a model library ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_gabaa.ndf.', ],
						   write => undef,
						  },
						 ],
				description => "environment variable NEUROSPACES_NMC_USER_MODELS",
				preparation => {
						description => "Removing the environment entry to point to a model library",
						preparer =>
						sub
						{
						    $previous_library = $ENV{NEUROSPACES_NMC_MODELS};

						    if (defined $ENV{NEUROSPACES_NMC_MODELS})
						    {
							undef $ENV{NEUROSPACES_NMC_MODELS};
						    }

						    $previous_library_custom = $ENV{NEUROSPACES_NMC_USER_MODELS};

						    $ENV{NEUROSPACES_NMC_USER_MODELS} = $previous_library;
						},
					       },
				reparation => {
					       description => "Restoring the previous environment variables",
					       reparer =>
					       sub
					       {
						   $ENV{NEUROSPACES_NMC_MODELS} = $previous_library;

						   $ENV{NEUROSPACES_NMC_USER_MODELS} = $previous_library_custom;

						   return undef;
					       },
					      },
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we use the environment variable NEUROSPACES_NMC_PROJECT_MODELS to point to a model library ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_gabaa.ndf.', ],
						   write => undef,
						  },
						 ],
				description => "environment variable NEUROSPACES_NMC_PROJECT_MODELS",
				preparation => {
						description => "Removing the environment entry to point to a model library",
						preparer =>
						sub
						{
						    $previous_library = $ENV{NEUROSPACES_NMC_MODELS};

						    if (defined $ENV{NEUROSPACES_NMC_MODELS})
						    {
							undef $ENV{NEUROSPACES_NMC_MODELS};
						    }

						    $previous_library_custom = $ENV{NEUROSPACES_NMC_PROJECT_MODELS};

						    $ENV{NEUROSPACES_NMC_PROJECT_MODELS} = $previous_library;
						},
					       },
				reparation => {
					       description => "Restoring the previous environment variables",
					       reparer =>
					       sub
					       {
						   $ENV{NEUROSPACES_NMC_MODELS} = $previous_library;

						   $ENV{NEUROSPACES_NMC_PROJECT_MODELS} = $previous_library_custom;

						   return undef;
					       },
					      },
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we use the environment variable NEUROSPACES_NMC_SYSTEM_MODELS to point to a model library ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_gabaa.ndf.', ],
						   write => undef,
						  },
						 ],
				description => "environment variable NEUROSPACES_NMC_SYSTEM_MODELS",
				preparation => {
						description => "Removing the environment entry to point to a model library",
						preparer =>
						sub
						{
						    $previous_library = $ENV{NEUROSPACES_NMC_MODELS};

						    if (defined $ENV{NEUROSPACES_NMC_MODELS})
						    {
							undef $ENV{NEUROSPACES_NMC_MODELS};
						    }

						    $previous_library_custom = $ENV{NEUROSPACES_NMC_SYSTEM_MODELS};

						    $ENV{NEUROSPACES_NMC_SYSTEM_MODELS} = $previous_library;
						},
					       },
				reparation => {
					       description => "Restoring the previous environment variables",
					       reparer =>
					       sub
					       {
						   $ENV{NEUROSPACES_NMC_MODELS} = $previous_library;

						   $ENV{NEUROSPACES_NMC_SYSTEM_MODELS} = $previous_library_custom;

						   return undef;
					       },
					      },
			       },
			      ],
       description => "environment variables",
       name => 'environment.t',
      };


return $test;


