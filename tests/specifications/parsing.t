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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/cells/purkinjesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/cells/purkinjesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/cells/purkinjesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/cells/purkinjesmall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/cells/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/cells/granule.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/cells/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/cells/granule.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/cells/golgi.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/cells/golgi.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/cells/golgi.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/cells/purk2m9s.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/cells/purk2m9s.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/cells/purk2m9s.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/granular-layer.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/granular-layer.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/granular-layer.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/granular-layer.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/networklarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/networklarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/networklarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/networklarge.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/networksmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/networksmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/networksmall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/network-test.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/network-test.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax test of legacy/networks/network-test.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/supernetwork.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/supernetwork.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/supernetwork.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/supernetwork.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/network.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/network.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/network.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/network.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/networks/supernetworksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/networks/supernetworksmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/supernetworksmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/networks/supernetworksmall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/golgismall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/golgismall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/golgismall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/golgismall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/granulesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/granulesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/granulesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/granulesmall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/purkinjesmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/purkinjesmall.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/purkinjesmall.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/purkinjesmall.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/golgilarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/golgilarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/golgilarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/golgilarge.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/granulelarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/granulelarge.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/granulelarge.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/granulelarge.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/purkinje.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/purkinje.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/purkinje.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/purkinje.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/granule.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/granule.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/populations/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/populations/golgi.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/populations/golgi.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/populations/golgi.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_h.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_h.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_h.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_h.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_km.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_k2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_k2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_nap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_nap.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_cat.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_cat.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_cahva.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_cahva.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_cahva.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_cahva.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_naf.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_naf.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_naf.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_inna.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_inna.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_inna.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_inna.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_h1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_h1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_h1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_h1.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_ka.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_cahva.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_cahva.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_cahva.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_cahva.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_inna.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_inna.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_inna.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_inna.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_ka.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_kc.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_kdr.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_kc.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_cap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_cap.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_kdr.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_kc.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/golgi_ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/golgi_ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/golgi_ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/golgi_ka.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/purkinje_h2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/purkinje_h2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/purkinje_h2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/purkinje_h2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_kdr.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/channels/granule_h.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/channels/granule_h.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/channels/granule_h.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/channels/granule_h.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_maind.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_maind.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_maind.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_maind_small.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_maind_small.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_maind_small.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_maind_small.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_spinyd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_spinyd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_spinyd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_spinyd.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_soma2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_soma2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_soma2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_soma2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_soma.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_soma_small.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_soma_small.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_soma_small.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_soma_small.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'legacy/segments/purkinje_thickd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (legacy/segments/purkinje_thickd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/segments/purkinje_thickd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of legacy/segments/purkinje_thickd.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/cat.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/cat.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/cat.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/cat.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje/soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje/soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje/soma.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje/soma.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje/maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje/maind.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje/maind.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje/maind.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/nap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/nap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/nap.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/kh.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kh.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kh.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/kh.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/naf.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/naf.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/naf.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/k2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/k2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/k2.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/k2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/kc.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kc.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kc.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/kc.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/km.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/km.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/km.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/km.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/kdr.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/kdr.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/kdr.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/kdr.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/ka.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/ka.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/ka.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/ka.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'channels/purkinje/cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (channels/purkinje/cap.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/purkinje/cap.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of channels/purkinje/cap.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje/thickd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje/thickd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje/thickd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje/thickd.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'segments/purkinje/spinyd.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (segments/purkinje/spinyd.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje/spinyd.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of segments/purkinje/spinyd.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/purkinje/edsjb1994.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinje/edsjb1994.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/purkinje/edsjb1994.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994_partitioned.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/purkinje/edsjb1994_partitioned.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinje/edsjb1994_partitioned.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/purkinje/edsjb1994_partitioned.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994_spinesurface.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/purkinje/edsjb1994_spinesurface.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinje/edsjb1994_spinesurface.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/purkinje/edsjb1994_spinesurface.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'tests/segments/purkinje/test_segment.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/segments/purkinje/test_segment.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/segments/purkinje/test_segment.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/segments/purkinje/test_segment.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-q',
					      '-R',
					      'tests/cells/purk_test_segment.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/purk_test_segment.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purk_test_segment.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/purk_test_segment.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
					      '-v',
					      '1',
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
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'cells/stand_alone.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (cells/stand_alone.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/stand_alone.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of cells/stand_alone.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/networks/spiker1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/networks/spiker1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/networks/spiker1.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/networks/spiker1.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'examples/hh_soma.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (examples/hh_soma.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/examples/hh_soma.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of examples/hh_soma.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'examples/hh_neuron.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (examples/hh_neuron.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/examples/hh_neuron.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of examples/hh_neuron.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/cells/singlea_naf2_aggregator.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/singlea_naf2_aggregator.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/singlea_naf2_aggregator.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/singlea_naf2_aggregator.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/cells/doublea_aggregator.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/doublea_aggregator.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/doublea_aggregator.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/doublea_aggregator.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/cells/addressing_aggregator1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/addressing_aggregator1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/addressing_aggregator1.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/addressing_aggregator1.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/cells/hardcoded_tables1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/hardcoded_tables1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hardcoded_tables1.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/hardcoded_tables1.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'tests/cells/hardcoded_tables2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/hardcoded_tables2.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hardcoded_tables2.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of tests/cells/hardcoded_tables2.ndf",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-p',
					      '-R',
					      'utilities/empty_model.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (utilities/empty_model.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/utilities/empty_model.ndf', ],
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "syntax of utilities/empty_model.ndf",
			       },
		      ],
       description => "general syntax of library files",
       name => 'parsing.t',
      };


return $test;


