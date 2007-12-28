#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'mappers/spikereceiver.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (mappers/spikereceiver.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/mappers/spikereceiver.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of mappers/spikereceiver.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'mappers/spikegenerator.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (mappers/spikegenerator.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/mappers/spikegenerator.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of mappers/spikegenerator.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/naf_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/naf_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/naf_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/naf_activation.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/naf_inactivation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/naf_inactivation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/naf_inactivation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/naf_inactivation.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/kc_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/kc_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/kc_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/kc_activation.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/kc_concentration.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/kc_concentration.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/kc_concentration.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/kc_concentration.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/k2_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/k2_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/k2_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/k2_activation.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/k2_concentration.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/k2_concentration.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/k2_concentration.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/k2_concentration.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/ka_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/ka_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/ka_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/ka_activation.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/ka_inactivation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/ka_inactivation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/ka_inactivation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/ka_inactivation.ndf",
# 				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf"),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/cap_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/cap_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/cap_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/cap_activation.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/cap_inactivation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/cap_inactivation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/cap_inactivation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/cap_inactivation.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/nap_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/nap_activation.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/nap_activation.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/nap_activation.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/kdr_steadystate.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/kdr_steadystate.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?gates/kdr_steadystate.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/kdr_steadystate.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/kdr_tau.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/kdr_tau.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?gates/kdr_tau.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/kdr_tau.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/kh.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/kh.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?gates/kh.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/kh.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'gates/km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (gates/km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?gates/km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of gates/km.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'cells/purkinjesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/purkinjesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinjesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/purkinjesmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'cells/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/granule.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/granule.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/golgi.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/golgi.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/golgi.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/purk2m9s.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purk2m9s.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/purk2m9s.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'cells/cell1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/cell1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/cell1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/cell1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/granular-layer.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/granular-layer.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/granular-layer.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/granular-layer.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/networklarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/networklarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networklarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/networklarge.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/networksmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networksmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/networksmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/network-test.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/network-test.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax test of networks/network-test.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/supernetwork.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/supernetwork.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/supernetwork.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/supernetwork.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/input.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/input.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/input.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/input.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/network.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/network.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/network.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/network.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'networks/supernetworksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (networks/supernetworksmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/supernetworksmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of networks/supernetworksmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/golgismall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/golgismall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/golgismall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/golgismall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/granulesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/granulesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granulesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/granulesmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/purkinjesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/purkinjesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/purkinjesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/purkinjesmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/golgilarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/golgilarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/golgilarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/golgilarge.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/granulelarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/granulelarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granulelarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/granulelarge.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/purkinje.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/purkinje.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/purkinje.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/purkinje.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/granule.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/granule.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'populations/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (populations/golgi.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/golgi.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of populations/golgi.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'fibers/mossyfiber.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (fibers/mossyfiber.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/fibers/mossyfiber.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of fibers/mossyfiber.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'fibers/mossyfibersmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (fibers/mossyfibersmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/fibers/mossyfibersmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of fibers/mossyfibersmall.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'fibers/mossyfiberlarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (fibers/mossyfiberlarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/fibers/mossyfiberlarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of fibers/mossyfiberlarge.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_gabaa.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_gabaa.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_gabaa.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_gabab.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_gabab.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_gabab.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_gabab.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_h.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_h.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_h.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_h.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_climb.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_climb.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_climb.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_climb.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_km.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_k2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_k2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_nap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_nap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_cat.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_cat.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/gaba.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/gaba.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/gaba.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/gaba.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_basket.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_basket.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_basket.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_basket.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_cahva.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_cahva.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_cahva.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_cahva.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_naf.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_naf.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_naf.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_inna.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_inna.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_inna.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_inna.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_ampa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_ampa.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_ampa.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_ampa.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_ampa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_ampa.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_ampa.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_ampa.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_h1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_h1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_h1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_h1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_ka.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/non_nmda.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/non_nmda.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/non_nmda.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/non_nmda.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_cahva.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_cahva.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_cahva.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_cahva.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_gabab.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_gabab.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_gabab.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_gabab.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_inna.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_inna.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_inna.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_inna.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_ka.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_kc.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_kdr.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_kc.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/nmda.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/nmda.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/nmda.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/nmda.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_cap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_cap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_kdr.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_gabaa.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_gabaa.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_gabaa.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_kc.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_ka.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje_h2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje_h2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje_h2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje_h2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/golgi_nmda.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/golgi_nmda.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/golgi_nmda.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/golgi_nmda.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_kdr.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_nmda.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_nmda.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_nmda.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_nmda.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'channels/granule_h.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/granule_h.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/granule_h.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/granule_h.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_maind.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_maind.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_maind.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_maind_small.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_maind_small.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_maind_small.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_maind_small.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/spines/purkinje.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/spines/purkinje.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/spines/purkinje.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/spines/purkinje.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_spinyd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_spinyd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_spinyd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_spinyd.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_soma2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_soma2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_soma2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_soma2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_soma.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_soma_small.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_soma_small.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_soma_small.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_soma_small.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje_thickd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje_thickd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_thickd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje_thickd.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'pools/golgi_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (pools/golgi_ca.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pools/golgi_ca.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of pools/golgi_ca.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'pools/purkinje_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (pools/purkinje_ca.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pools/purkinje_ca.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of pools/purkinje_ca.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'pools/granule_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (pools/granule_ca.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pools/granule_ca.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of pools/granule_ca.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/spines/stubby.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/spines/stubby.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/spines/stubby.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/spines/stubby.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/spines/mushroom.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/spines/mushroom.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/spines/mushroom.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/spines/mushroom.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/spines/thin.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/spines/thin.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/spines/thin.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/spines/thin.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/maind.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/maind.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/maind.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/soma.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/c1c2p1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/c1c2p1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/c1c2p1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/c1c2p1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/c1c2p2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/c1c2p2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/c1c2p2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/c1c2p2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/doublep.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/doublep.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/doublep.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/doublep.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/fork3p.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/fork3p.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/fork3p.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/fork3p.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/fork4p1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/fork4p1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/fork4p1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/fork4p1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/fork4p2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/fork4p2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/fork4p2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/fork4p2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/fork4p3.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/fork4p3.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/fork4p3.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/fork4p3.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/singlep.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/singlep.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/singlep.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/singlep.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/tensizesp.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/tensizesp.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/tensizesp.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/tensizesp.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/triplep.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/triplep.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/triplep.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/triplep.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/pool1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/pool1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/pool2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/pool2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/pool1_feedback1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool1_feedback1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1_feedback1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/pool1_feedback1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/pool1_feedback2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool1_feedback2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1_feedback2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/pool1_feedback2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/purk_test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/purk_test.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purk_test.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/purk_test.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/cat.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/cat.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/soma.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/maind.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/maind.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/maind.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/nap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/nap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/kh.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/kh.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/kh.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/kh.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/naf.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/naf.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/naf.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/k2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/k2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/kc.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/km.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/kdr.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/ka.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/channels/cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/channels/cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/cap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/channels/cap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/thickd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/thickd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/thickd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/thickd.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/spinyd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/spinyd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/spinyd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/spinyd.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/purkinje/edsjb1994.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purkinje/edsjb1994.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/purkinje/edsjb1994.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_kh.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_kh.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_kh.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_kh.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_nap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_nap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_kdr.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_kc.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_ka.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_k2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_k2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_cat.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_cat.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_cap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_cap.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/table_km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/table_km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/table_km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/table_km.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/channel1_nernst1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/channel1_nernst1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/channel1_nernst1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/channel1_nernst1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/purk_test_soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/purk_test_soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purk_test_soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/purk_test_soma.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/axon.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/axon.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/axon.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/axon.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/purk_test_axon.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/purk_test_axon.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purk_test_axon.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/purk_test_axon.ndf",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/pool1_contributors2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool1_contributors2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1_contributors2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/pool1_contributors2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/channel2_nernst2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/channel2_nernst2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/channel2_nernst2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/channel2_nernst2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/springmass3.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/springmass3.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/springmass3.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/springmass3.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/springmass4.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/springmass4.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/springmass4.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/springmass4.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'contours/section1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (contours/section1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/contours/section1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of contours/section1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'segments/micron2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/micron2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/micron2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/micron2.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'tests/networks/spiker3.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/networks/spiker3.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/networks/spiker3.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/networks/spiker3.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-q',
					      '-R',
					      'utilities/some_segments.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (utilities/some_segments.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/utilities/some_segments.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of utilities/some_segments.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-R',
					      'tests/cells/hh1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/hh1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hh1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/hh1.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-R',
					      'channels/hodgkin-huxley/potassium.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/hodgkin-huxley/potassium.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/hodgkin-huxley/potassium.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/hodgkin-huxley/potassium.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-R',
					      'channels/hodgkin-huxley/sodium.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/hodgkin-huxley/sodium.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/hodgkin-huxley/sodium.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/hodgkin-huxley/sodium.ndf",
			       },
			       {
				arguments => [
					      '-p',
					      '-R',
					      'segments/hodgkin_huxley.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/hodgkin_huxley.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/hodgkin_huxley.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/hodgkin_huxley.ndf",
			       },
		      ],
       description => "general syntax of library files",
       name => 'parsing.t',
      };


return $test;


