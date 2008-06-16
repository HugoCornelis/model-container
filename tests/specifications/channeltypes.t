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
					      '-R',
					      'channels/purkinje/cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/cat.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the cat channel ?",
						   read => 'value = "ChannelActInact"',
						   write => 'printparameter /cat CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/cat.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/nap.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the nap channel ?",
						   read => 'value = "ChannelAct"',
						   write => 'printparameter /nap CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/nap.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/kh.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kh.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kh.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the kh channel ?",
						   read => 'value = "ChannelPersistentSteadyStateDualTau"',
						   write => 'printparameter /kh CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/kh.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/naf.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/naf.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the naf channel ?",
						   read => 'value = "ChannelActInact"',
						   write => 'printparameter /naf CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/naf.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/k2.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the k2 channel ?",
						   read => 'value = "ChannelActConc"',
						   write => 'printparameter /k2 CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/k2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kc.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the kc channel ?",
						   read => 'value = "ChannelActConc"',
						   write => 'printparameter /kc CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/kc.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/km.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the km channel ?",
						   read => 'value = "ChannelPersistentSteadyStateTau"',
						   write => 'printparameter /km CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/km.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kdr.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the kdr channel ?",
						   read => 'value = "ChannelSteadyStateSteppedTau"',
						   write => 'printparameter /kdr CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/kdr.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/ka.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the ka channel ?",
						   read => 'value = "ChannelActInact"',
						   write => 'printparameter /ka CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/ka.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'channels/purkinje/cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/cap.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "What is the type of the cap channel ?",
						   read => 'value = "ChannelActInact"',
						   write => 'printparameter /cap CHANNEL_TYPE',
						  },
						 ],
				description => "CHANNEL_TYPE of channels/purkinje/cap.ndf",
			       },
		      ],
       description => "automatically inferred and hardcoded channel type parameters",
       name => 'channeltypes.t',
      };


return $test;


