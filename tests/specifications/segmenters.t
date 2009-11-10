#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      '-R',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => 'neurospaces ',
						   timeout => 150,
						   write => undef,
						  },
						  {
						   description => "Can we linearize segments of a network ?",
						   read => 'Number of segments: 33548
Number of segments without parents: 6266
Number of segment tips: 15104
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a heterogeneous population ?",
						   read => 'Number of segments: 27288
Number of segments without parents: 6
Number of segment tips: 8844
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we linearize segments of a homogeneous population ?",
						   read => 'Number of segments: 6240
Number of segments without parents: 6240
Number of segment tips: 6240
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a big neuron ?",
						   read => 'Number of segments: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a part of a big neuron ?",
						   disabled => 'See developer TODOs: instrumentation related',
						   read => 'Number of segments: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "Can we linearize segments of a one segment neuron ?",
						   read => 'Number of segments: 1
Number of segments without parents: 1
Number of segment tips: 1
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules/0",
						  },
						  {
						   description => "Can we linearize segments of a network (2) ?",
						   read => 'Number of segments: 33548
Number of segments without parents: 6266
Number of segment tips: 15104
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a heterogeneous population (2) ?",
						   read => 'Number of segments: 27288
Number of segments without parents: 6
Number of segment tips: 8844
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we linearize segments of a homogeneous population (2) ?",
						   read => 'Number of segments: 6240
Number of segments without parents: 6240
Number of segment tips: 6240
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a big neuron (2) ?",
						   read => 'Number of segments: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a part of a big neuron (2) ?",
						   disabled => 'See developer TODOs: instrumentation related',
						   timeout => 25,
						   read => 'Number of segments: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "Can we linearize segments of a one segment neuron (2) ?",
						   timeout => 25,
						   read => 'Number of segments: 1
Number of segments without parents: 1
Number of segment tips: 1',
						   write => "segmenterlinearize /CerebellarCortex/Granules/0",
						  },
						 ],
				description => "mixin of linearization of segments of cells, populations and networks",
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-A',
					      '-R',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => 'neurospaces ',
						   write => undef,
						  },
						  {
						   description => "Can we get information on all the dendritic tips of the purkinje cell ?",
						   read => 'tips:
  name: Purkinje
  names:
    - /Purkinje/segments/b0s01[6]
    - /Purkinje/segments/b0s01[8]
    - /Purkinje/segments/b0s01[10]
    - /Purkinje/segments/b0s01[13]
    - /Purkinje/segments/b0s01[16]
    - /Purkinje/segments/b0s01[19]
    - /Purkinje/segments/b0s01[22]
    - /Purkinje/segments/b0s01[27]
    - /Purkinje/segments/b0s01[30]
    - /Purkinje/segments/b0s01[33]
    - /Purkinje/segments/b0s01[38]
    - /Purkinje/segments/b0s01[44]
    - /Purkinje/segments/b0s02[7]
    - /Purkinje/segments/b0s02[10]
    - /Purkinje/segments/b0s02[14]
    - /Purkinje/segments/b0s02[18]
    - /Purkinje/segments/b0s02[25]
    - /Purkinje/segments/b0s02[27]
    - /Purkinje/segments/b0s02[29]
    - /Purkinje/segments/b0s02[39]
    - /Purkinje/segments/b0s02[44]
    - /Purkinje/segments/b0s02[47]
    - /Purkinje/segments/b0s02[48]
    - /Purkinje/segments/b0s02[51]
    - /Purkinje/segments/b0s02[54]
    - /Purkinje/segments/b0s02[56]
    - /Purkinje/segments/b0s02[57]
    - /Purkinje/segments/b0s02[63]
    - /Purkinje/segments/b0s02[64]
    - /Purkinje/segments/b0s02[72]
    - /Purkinje/segments/b0s02[74]
    - /Purkinje/segments/b0s02[76]
    - /Purkinje/segments/b0s02[78]
    - /Purkinje/segments/b0s02[80]
    - /Purkinje/segments/b0s02[81]
    - /Purkinje/segments/b0s02[84]
    - /Purkinje/segments/b0s02[88]
    - /Purkinje/segments/b0s02[96]
    - /Purkinje/segments/b0s02[97]
    - /Purkinje/segments/b0s02[100]
    - /Purkinje/segments/b0s02[102]
    - /Purkinje/segments/b0s02[105]
    - /Purkinje/segments/b0s02[108]
    - /Purkinje/segments/b0s02[110]
    - /Purkinje/segments/b0s02[114]
    - /Purkinje/segments/b0s02[116]
    - /Purkinje/segments/b0s02[117]
    - /Purkinje/segments/b0s02[127]
    - /Purkinje/segments/b0s02[132]
    - /Purkinje/segments/b0s02[134]
    - /Purkinje/segments/b0s02[136]
    - /Purkinje/segments/b0s02[144]
    - /Purkinje/segments/b0s02[147]
    - /Purkinje/segments/b0s02[148]
    - /Purkinje/segments/b0s02[152]
    - /Purkinje/segments/b0s02[155]
    - /Purkinje/segments/b0s02[158]
    - /Purkinje/segments/b0s02[159]
    - /Purkinje/segments/b0s02[164]
    - /Purkinje/segments/b0s02[166]
    - /Purkinje/segments/b0s02[170]
    - /Purkinje/segments/b0s02[172]
    - /Purkinje/segments/b0s02[177]
    - /Purkinje/segments/b0s02[182]
    - /Purkinje/segments/b0s02[183]
    - /Purkinje/segments/b0s02[185]
    - /Purkinje/segments/b0s03[3]
    - /Purkinje/segments/b0s03[6]
    - /Purkinje/segments/b0s03[15]
    - /Purkinje/segments/b0s03[18]
    - /Purkinje/segments/b0s03[22]
    - /Purkinje/segments/b0s03[26]
    - /Purkinje/segments/b0s03[28]
    - /Purkinje/segments/b0s03[30]
    - /Purkinje/segments/b0s03[32]
    - /Purkinje/segments/b0s03[34]
    - /Purkinje/segments/b0s03[36]
    - /Purkinje/segments/b0s03[37]
    - /Purkinje/segments/b0s03[42]
    - /Purkinje/segments/b0s03[48]
    - /Purkinje/segments/b0s03[49]
    - /Purkinje/segments/b0s03[51]
    - /Purkinje/segments/b0s03[53]
    - /Purkinje/segments/b0s03[60]
    - /Purkinje/segments/b0s03[62]
    - /Purkinje/segments/b0s03[63]
    - /Purkinje/segments/b0s03[64]
    - /Purkinje/segments/b0s03[67]
    - /Purkinje/segments/b0s03[69]
    - /Purkinje/segments/b0s04[5]
    - /Purkinje/segments/b0s04[6]
    - /Purkinje/segments/b0s04[9]
    - /Purkinje/segments/b0s04[11]
    - /Purkinje/segments/b0s04[12]
    - /Purkinje/segments/b0s04[16]
    - /Purkinje/segments/b0s04[19]
    - /Purkinje/segments/b0s04[20]
    - /Purkinje/segments/b0s04[24]
    - /Purkinje/segments/b0s04[28]
    - /Purkinje/segments/b0s04[29]
    - /Purkinje/segments/b0s04[38]
    - /Purkinje/segments/b0s04[40]
    - /Purkinje/segments/b0s04[42]
    - /Purkinje/segments/b0s04[50]
    - /Purkinje/segments/b0s04[52]
    - /Purkinje/segments/b0s04[54]
    - /Purkinje/segments/b0s04[55]
    - /Purkinje/segments/b0s04[56]
    - /Purkinje/segments/b0s04[57]
    - /Purkinje/segments/b0s04[60]
    - /Purkinje/segments/b0s04[62]
    - /Purkinje/segments/b0s04[64]
    - /Purkinje/segments/b0s04[68]
    - /Purkinje/segments/b0s04[70]
    - /Purkinje/segments/b0s04[73]
    - /Purkinje/segments/b0s04[76]
    - /Purkinje/segments/b0s04[77]
    - /Purkinje/segments/b0s04[81]
    - /Purkinje/segments/b0s04[82]
    - /Purkinje/segments/b0s04[88]
    - /Purkinje/segments/b0s04[98]
    - /Purkinje/segments/b0s04[99]
    - /Purkinje/segments/b0s04[102]
    - /Purkinje/segments/b0s04[107]
    - /Purkinje/segments/b0s04[108]
    - /Purkinje/segments/b0s04[112]
    - /Purkinje/segments/b0s04[115]
    - /Purkinje/segments/b0s04[118]
    - /Purkinje/segments/b0s04[119]
    - /Purkinje/segments/b0s04[123]
    - /Purkinje/segments/b0s04[124]
    - /Purkinje/segments/b0s04[134]
    - /Purkinje/segments/b0s04[136]
    - /Purkinje/segments/b0s04[139]
    - /Purkinje/segments/b0s04[142]
    - /Purkinje/segments/b0s04[144]
    - /Purkinje/segments/b0s04[148]
    - /Purkinje/segments/b0s04[154]
    - /Purkinje/segments/b0s04[155]
    - /Purkinje/segments/b1s05[3]
    - /Purkinje/segments/b1s05[5]
    - /Purkinje/segments/b1s05[6]
    - /Purkinje/segments/b1s06[8]
    - /Purkinje/segments/b1s06[14]
    - /Purkinje/segments/b1s06[16]
    - /Purkinje/segments/b1s06[24]
    - /Purkinje/segments/b1s06[25]
    - /Purkinje/segments/b1s06[30]
    - /Purkinje/segments/b1s06[33]
    - /Purkinje/segments/b1s06[35]
    - /Purkinje/segments/b1s06[37]
    - /Purkinje/segments/b1s06[38]
    - /Purkinje/segments/b1s06[41]
    - /Purkinje/segments/b1s06[43]
    - /Purkinje/segments/b1s06[47]
    - /Purkinje/segments/b1s06[48]
    - /Purkinje/segments/b1s06[52]
    - /Purkinje/segments/b1s06[54]
    - /Purkinje/segments/b1s06[63]
    - /Purkinje/segments/b1s06[70]
    - /Purkinje/segments/b1s06[71]
    - /Purkinje/segments/b1s06[74]
    - /Purkinje/segments/b1s06[79]
    - /Purkinje/segments/b1s06[81]
    - /Purkinje/segments/b1s06[82]
    - /Purkinje/segments/b1s06[85]
    - /Purkinje/segments/b1s06[91]
    - /Purkinje/segments/b1s06[95]
    - /Purkinje/segments/b1s06[98]
    - /Purkinje/segments/b1s06[101]
    - /Purkinje/segments/b1s06[104]
    - /Purkinje/segments/b1s06[105]
    - /Purkinje/segments/b1s06[106]
    - /Purkinje/segments/b1s06[112]
    - /Purkinje/segments/b1s06[115]
    - /Purkinje/segments/b1s06[117]
    - /Purkinje/segments/b1s06[120]
    - /Purkinje/segments/b1s06[121]
    - /Purkinje/segments/b1s06[128]
    - /Purkinje/segments/b1s06[133]
    - /Purkinje/segments/b1s06[134]
    - /Purkinje/segments/b1s06[136]
    - /Purkinje/segments/b1s06[141]
    - /Purkinje/segments/b1s06[144]
    - /Purkinje/segments/b1s06[145]
    - /Purkinje/segments/b1s06[153]
    - /Purkinje/segments/b1s06[159]
    - /Purkinje/segments/b1s06[162]
    - /Purkinje/segments/b1s06[164]
    - /Purkinje/segments/b1s06[167]
    - /Purkinje/segments/b1s06[174]
    - /Purkinje/segments/b1s06[175]
    - /Purkinje/segments/b1s06[178]
    - /Purkinje/segments/b1s06[180]
    - /Purkinje/segments/b1s06[182]
    - /Purkinje/segments/b1s07[5]
    - /Purkinje/segments/b1s08[4]
    - /Purkinje/segments/b1s08[11]
    - /Purkinje/segments/b1s08[12]
    - /Purkinje/segments/b1s08[14]
    - /Purkinje/segments/b1s08[15]
    - /Purkinje/segments/b1s08[19]
    - /Purkinje/segments/b1s08[20]
    - /Purkinje/segments/b1s08[21]
    - /Purkinje/segments/b1s08[24]
    - /Purkinje/segments/b1s09[4]
    - /Purkinje/segments/b1s09[6]
    - /Purkinje/segments/b1s09[8]
    - /Purkinje/segments/b1s09[9]
    - /Purkinje/segments/b1s09[18]
    - /Purkinje/segments/b1s09[23]
    - /Purkinje/segments/b1s09[24]
    - /Purkinje/segments/b1s09[27]
    - /Purkinje/segments/b1s09[28]
    - /Purkinje/segments/b1s09[30]
    - /Purkinje/segments/b1s09[33]
    - /Purkinje/segments/b1s09[36]
    - /Purkinje/segments/b1s09[39]
    - /Purkinje/segments/b1s10[6]
    - /Purkinje/segments/b1s10[9]
    - /Purkinje/segments/b1s10[13]
    - /Purkinje/segments/b1s10[15]
    - /Purkinje/segments/b1s10[17]
    - /Purkinje/segments/b1s10[19]
    - /Purkinje/segments/b1s10[20]
    - /Purkinje/segments/b1s10[22]
    - /Purkinje/segments/b1s10[27]
    - /Purkinje/segments/b1s10[28]
    - /Purkinje/segments/b1s10[36]
    - /Purkinje/segments/b1s10[42]
    - /Purkinje/segments/b1s10[43]
    - /Purkinje/segments/b1s10[45]
    - /Purkinje/segments/b1s10[48]
    - /Purkinje/segments/b1s10[53]
    - /Purkinje/segments/b1s10[56]
    - /Purkinje/segments/b1s10[60]
    - /Purkinje/segments/b1s10[62]
    - /Purkinje/segments/b1s10[64]
    - /Purkinje/segments/b1s10[66]
    - /Purkinje/segments/b1s10[70]
    - /Purkinje/segments/b1s10[71]
    - /Purkinje/segments/b1s10[77]
    - /Purkinje/segments/b1s10[81]
    - /Purkinje/segments/b1s10[82]
    - /Purkinje/segments/b1s10[84]
    - /Purkinje/segments/b1s10[85]
    - /Purkinje/segments/b1s11[3]
    - /Purkinje/segments/b1s11[7]
    - /Purkinje/segments/b1s11[10]
    - /Purkinje/segments/b1s12[3]
    - /Purkinje/segments/b1s12[11]
    - /Purkinje/segments/b1s12[12]
    - /Purkinje/segments/b1s12[16]
    - /Purkinje/segments/b1s12[27]
    - /Purkinje/segments/b1s12[29]
    - /Purkinje/segments/b1s12[31]
    - /Purkinje/segments/b1s12[33]
    - /Purkinje/segments/b1s12[36]
    - /Purkinje/segments/b1s12[38]
    - /Purkinje/segments/b1s12[42]
    - /Purkinje/segments/b1s12[45]
    - /Purkinje/segments/b1s12[49]
    - /Purkinje/segments/b1s12[52]
    - /Purkinje/segments/b1s12[53]
    - /Purkinje/segments/b1s13[3]
    - /Purkinje/segments/b1s13[8]
    - /Purkinje/segments/b1s14[12]
    - /Purkinje/segments/b1s14[15]
    - /Purkinje/segments/b1s14[16]
    - /Purkinje/segments/b1s14[23]
    - /Purkinje/segments/b1s14[31]
    - /Purkinje/segments/b1s14[33]
    - /Purkinje/segments/b1s14[35]
    - /Purkinje/segments/b1s14[39]
    - /Purkinje/segments/b1s14[42]
    - /Purkinje/segments/b1s15[1]
    - /Purkinje/segments/b1s15[4]
    - /Purkinje/segments/b1s15[6]
    - /Purkinje/segments/b1s15[7]
    - /Purkinje/segments/b1s16[2]
    - /Purkinje/segments/b1s17[1]
    - /Purkinje/segments/b1s18[0]
    - /Purkinje/segments/b1s19[2]
    - /Purkinje/segments/b1s19[12]
    - /Purkinje/segments/b1s19[14]
    - /Purkinje/segments/b1s19[16]
    - /Purkinje/segments/b1s19[20]
    - /Purkinje/segments/b1s19[22]
    - /Purkinje/segments/b1s19[24]
    - /Purkinje/segments/b1s19[29]
    - /Purkinje/segments/b1s19[37]
    - /Purkinje/segments/b1s19[39]
    - /Purkinje/segments/b1s19[42]
    - /Purkinje/segments/b1s20[6]
    - /Purkinje/segments/b1s20[9]
    - /Purkinje/segments/b1s20[10]
    - /Purkinje/segments/b1s20[12]
    - /Purkinje/segments/b1s20[14]
    - /Purkinje/segments/b1s20[18]
    - /Purkinje/segments/b1s20[20]
    - /Purkinje/segments/b1s20[21]
    - /Purkinje/segments/b2s21[4]
    - /Purkinje/segments/b2s21[5]
    - /Purkinje/segments/b2s21[9]
    - /Purkinje/segments/b2s21[15]
    - /Purkinje/segments/b2s21[17]
    - /Purkinje/segments/b2s21[20]
    - /Purkinje/segments/b2s21[22]
    - /Purkinje/segments/b2s21[24]
    - /Purkinje/segments/b2s22[4]
    - /Purkinje/segments/b2s22[7]
    - /Purkinje/segments/b2s22[8]
    - /Purkinje/segments/b2s22[11]
    - /Purkinje/segments/b2s22[12]
    - /Purkinje/segments/b2s23[4]
    - /Purkinje/segments/b2s23[8]
    - /Purkinje/segments/b2s23[13]
    - /Purkinje/segments/b2s23[15]
    - /Purkinje/segments/b2s23[16]
    - /Purkinje/segments/b2s23[20]
    - /Purkinje/segments/b2s23[25]
    - /Purkinje/segments/b2s23[27]
    - /Purkinje/segments/b2s24[4]
    - /Purkinje/segments/b2s24[6]
    - /Purkinje/segments/b2s25[4]
    - /Purkinje/segments/b2s25[8]
    - /Purkinje/segments/b2s25[10]
    - /Purkinje/segments/b2s25[14]
    - /Purkinje/segments/b2s25[16]
    - /Purkinje/segments/b2s25[18]
    - /Purkinje/segments/b2s25[22]
    - /Purkinje/segments/b2s25[25]
    - /Purkinje/segments/b2s25[27]
    - /Purkinje/segments/b2s25[28]
    - /Purkinje/segments/b2s25[31]
    - /Purkinje/segments/b2s25[33]
    - /Purkinje/segments/b2s25[34]
    - /Purkinje/segments/b2s26[3]
    - /Purkinje/segments/b2s26[6]
    - /Purkinje/segments/b2s26[10]
    - /Purkinje/segments/b2s26[11]
    - /Purkinje/segments/b2s26[15]
    - /Purkinje/segments/b2s26[19]
    - /Purkinje/segments/b2s26[20]
    - /Purkinje/segments/b2s26[23]
    - /Purkinje/segments/b2s26[24]
    - /Purkinje/segments/b2s26[27]
    - /Purkinje/segments/b2s26[29]
    - /Purkinje/segments/b2s26[30]
    - /Purkinje/segments/b2s26[33]
    - /Purkinje/segments/b2s26[34]
    - /Purkinje/segments/b2s26[35]
    - /Purkinje/segments/b2s27[4]
    - /Purkinje/segments/b2s27[6]
    - /Purkinje/segments/b2s27[7]
    - /Purkinje/segments/b2s27[10]
    - /Purkinje/segments/b2s27[14]
    - /Purkinje/segments/b2s27[16]
    - /Purkinje/segments/b2s27[22]
    - /Purkinje/segments/b2s27[24]
    - /Purkinje/segments/b2s27[26]
    - /Purkinje/segments/b2s27[33]
    - /Purkinje/segments/b2s27[34]
    - /Purkinje/segments/b2s27[39]
    - /Purkinje/segments/b2s27[41]
    - /Purkinje/segments/b2s27[45]
    - /Purkinje/segments/b2s27[47]
    - /Purkinje/segments/b2s28[4]
    - /Purkinje/segments/b2s28[7]
    - /Purkinje/segments/b2s28[14]
    - /Purkinje/segments/b2s28[15]
    - /Purkinje/segments/b2s28[17]
    - /Purkinje/segments/b2s28[20]
    - /Purkinje/segments/b2s29[5]
    - /Purkinje/segments/b2s29[9]
    - /Purkinje/segments/b2s29[13]
    - /Purkinje/segments/b2s29[17]
    - /Purkinje/segments/b2s29[18]
    - /Purkinje/segments/b2s29[20]
    - /Purkinje/segments/b2s29[24]
    - /Purkinje/segments/b2s29[28]
    - /Purkinje/segments/b2s29[29]
    - /Purkinje/segments/b2s29[33]
    - /Purkinje/segments/b2s29[34]
    - /Purkinje/segments/b2s29[38]
    - /Purkinje/segments/b2s29[41]
    - /Purkinje/segments/b2s30[6]
    - /Purkinje/segments/b2s30[7]
    - /Purkinje/segments/b2s30[9]
    - /Purkinje/segments/b2s30[13]
    - /Purkinje/segments/b2s30[15]
    - /Purkinje/segments/b2s30[18]
    - /Purkinje/segments/b2s30[21]
    - /Purkinje/segments/b2s30[22]
    - /Purkinje/segments/b2s30[23]
    - /Purkinje/segments/b2s31[2]
    - /Purkinje/segments/b2s31[3]
    - /Purkinje/segments/b2s32[1]
    - /Purkinje/segments/b2s33[3]
    - /Purkinje/segments/b2s33[6]
    - /Purkinje/segments/b2s34[5]
    - /Purkinje/segments/b2s34[8]
    - /Purkinje/segments/b2s34[9]
    - /Purkinje/segments/b3s35[3]
    - /Purkinje/segments/b3s35[10]
    - /Purkinje/segments/b3s35[13]
    - /Purkinje/segments/b3s35[17]
    - /Purkinje/segments/b3s35[20]
    - /Purkinje/segments/b3s36[4]
    - /Purkinje/segments/b3s36[8]
    - /Purkinje/segments/b3s36[9]
    - /Purkinje/segments/b3s37[5]
    - /Purkinje/segments/b3s37[10]
    - /Purkinje/segments/b3s37[11]
    - /Purkinje/segments/b3s37[13]
    - /Purkinje/segments/b3s37[14]
    - /Purkinje/segments/b3s37[16]
    - /Purkinje/segments/b3s37[17]
    - /Purkinje/segments/b3s37[23]
    - /Purkinje/segments/b3s37[25]
    - /Purkinje/segments/b3s37[28]
    - /Purkinje/segments/b3s37[32]
    - /Purkinje/segments/b3s37[33]
    - /Purkinje/segments/b3s37[35]
    - /Purkinje/segments/b3s37[39]
    - /Purkinje/segments/b3s37[41]
    - /Purkinje/segments/b3s38[4]
    - /Purkinje/segments/b3s39[5]
    - /Purkinje/segments/b3s39[10]
    - /Purkinje/segments/b3s39[13]
    - /Purkinje/segments/b3s40[3]
    - /Purkinje/segments/b3s40[6]
    - /Purkinje/segments/b3s40[7]
    - /Purkinje/segments/b3s41[3]
    - /Purkinje/segments/b3s41[7]
    - /Purkinje/segments/b3s41[8]
    - /Purkinje/segments/b3s41[9]
    - /Purkinje/segments/b3s42[3]
    - /Purkinje/segments/b3s43[3]
    - /Purkinje/segments/b3s43[4]
    - /Purkinje/segments/b3s43[5]
    - /Purkinje/segments/b3s44[4]
    - /Purkinje/segments/b3s44[8]
    - /Purkinje/segments/b3s44[9]
    - /Purkinje/segments/b3s44[13]
    - /Purkinje/segments/b3s44[15]
    - /Purkinje/segments/b3s44[20]
    - /Purkinje/segments/b3s44[23]
    - /Purkinje/segments/b3s44[25]
    - /Purkinje/segments/b3s44[29]
    - /Purkinje/segments/b3s44[35]
    - /Purkinje/segments/b3s44[36]
    - /Purkinje/segments/b3s44[37]
    - /Purkinje/segments/b3s44[42]
    - /Purkinje/segments/b3s44[48]
    - /Purkinje/segments/b3s44[49]
    - /Purkinje/segments/b3s45[3]
    - /Purkinje/segments/b3s45[9]
    - /Purkinje/segments/b3s45[11]
    - /Purkinje/segments/b3s45[18]
    - /Purkinje/segments/b3s45[19]
    - /Purkinje/segments/b3s45[23]
    - /Purkinje/segments/b3s45[28]
    - /Purkinje/segments/b3s45[31]
    - /Purkinje/segments/b3s45[32]
    - /Purkinje/segments/b3s45[35]
    - /Purkinje/segments/b3s45[39]
    - /Purkinje/segments/b3s45[40]
    - /Purkinje/segments/b3s45[41]
    - /Purkinje/segments/b3s46[4]
    - /Purkinje/segments/b3s46[6]
    - /Purkinje/segments/b3s46[12]
    - /Purkinje/segments/b3s46[15]
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology",
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => 'neurospaces ',
						   write => undef,
						  },
						  {
						   description => 'Can we delete the soma ?',
						   read => 'neurospaces ',
						   write => 'delete /Purkinje/segments/soma',
						  },
						  {
						   description => "Can we get information on all the dendritic tips of the purkinje cell, soma deleted ?",
						   read => 'warning: cannot find parent segment /Purkinje/segments/soma for segment /Purkinje/segments/main[0]
---
tips:
  name: Purkinje
  names:
    - /Purkinje/segments/b0s01[6]
    - /Purkinje/segments/b0s01[8]
    - /Purkinje/segments/b0s01[10]
    - /Purkinje/segments/b0s01[13]
    - /Purkinje/segments/b0s01[16]
    - /Purkinje/segments/b0s01[19]
    - /Purkinje/segments/b0s01[22]
    - /Purkinje/segments/b0s01[27]
    - /Purkinje/segments/b0s01[30]
    - /Purkinje/segments/b0s01[33]
    - /Purkinje/segments/b0s01[38]
    - /Purkinje/segments/b0s01[44]
    - /Purkinje/segments/b0s02[7]
    - /Purkinje/segments/b0s02[10]
    - /Purkinje/segments/b0s02[14]
    - /Purkinje/segments/b0s02[18]
    - /Purkinje/segments/b0s02[25]
    - /Purkinje/segments/b0s02[27]
    - /Purkinje/segments/b0s02[29]
    - /Purkinje/segments/b0s02[39]
    - /Purkinje/segments/b0s02[44]
    - /Purkinje/segments/b0s02[47]
    - /Purkinje/segments/b0s02[48]
    - /Purkinje/segments/b0s02[51]
    - /Purkinje/segments/b0s02[54]
    - /Purkinje/segments/b0s02[56]
    - /Purkinje/segments/b0s02[57]
    - /Purkinje/segments/b0s02[63]
    - /Purkinje/segments/b0s02[64]
    - /Purkinje/segments/b0s02[72]
    - /Purkinje/segments/b0s02[74]
    - /Purkinje/segments/b0s02[76]
    - /Purkinje/segments/b0s02[78]
    - /Purkinje/segments/b0s02[80]
    - /Purkinje/segments/b0s02[81]
    - /Purkinje/segments/b0s02[84]
    - /Purkinje/segments/b0s02[88]
    - /Purkinje/segments/b0s02[96]
    - /Purkinje/segments/b0s02[97]
    - /Purkinje/segments/b0s02[100]
    - /Purkinje/segments/b0s02[102]
    - /Purkinje/segments/b0s02[105]
    - /Purkinje/segments/b0s02[108]
    - /Purkinje/segments/b0s02[110]
    - /Purkinje/segments/b0s02[114]
    - /Purkinje/segments/b0s02[116]
    - /Purkinje/segments/b0s02[117]
    - /Purkinje/segments/b0s02[127]
    - /Purkinje/segments/b0s02[132]
    - /Purkinje/segments/b0s02[134]
    - /Purkinje/segments/b0s02[136]
    - /Purkinje/segments/b0s02[144]
    - /Purkinje/segments/b0s02[147]
    - /Purkinje/segments/b0s02[148]
    - /Purkinje/segments/b0s02[152]
    - /Purkinje/segments/b0s02[155]
    - /Purkinje/segments/b0s02[158]
    - /Purkinje/segments/b0s02[159]
    - /Purkinje/segments/b0s02[164]
    - /Purkinje/segments/b0s02[166]
    - /Purkinje/segments/b0s02[170]
    - /Purkinje/segments/b0s02[172]
    - /Purkinje/segments/b0s02[177]
    - /Purkinje/segments/b0s02[182]
    - /Purkinje/segments/b0s02[183]
    - /Purkinje/segments/b0s02[185]
    - /Purkinje/segments/b0s03[3]
    - /Purkinje/segments/b0s03[6]
    - /Purkinje/segments/b0s03[15]
    - /Purkinje/segments/b0s03[18]
    - /Purkinje/segments/b0s03[22]
    - /Purkinje/segments/b0s03[26]
    - /Purkinje/segments/b0s03[28]
    - /Purkinje/segments/b0s03[30]
    - /Purkinje/segments/b0s03[32]
    - /Purkinje/segments/b0s03[34]
    - /Purkinje/segments/b0s03[36]
    - /Purkinje/segments/b0s03[37]
    - /Purkinje/segments/b0s03[42]
    - /Purkinje/segments/b0s03[48]
    - /Purkinje/segments/b0s03[49]
    - /Purkinje/segments/b0s03[51]
    - /Purkinje/segments/b0s03[53]
    - /Purkinje/segments/b0s03[60]
    - /Purkinje/segments/b0s03[62]
    - /Purkinje/segments/b0s03[63]
    - /Purkinje/segments/b0s03[64]
    - /Purkinje/segments/b0s03[67]
    - /Purkinje/segments/b0s03[69]
    - /Purkinje/segments/b0s04[5]
    - /Purkinje/segments/b0s04[6]
    - /Purkinje/segments/b0s04[9]
    - /Purkinje/segments/b0s04[11]
    - /Purkinje/segments/b0s04[12]
    - /Purkinje/segments/b0s04[16]
    - /Purkinje/segments/b0s04[19]
    - /Purkinje/segments/b0s04[20]
    - /Purkinje/segments/b0s04[24]
    - /Purkinje/segments/b0s04[28]
    - /Purkinje/segments/b0s04[29]
    - /Purkinje/segments/b0s04[38]
    - /Purkinje/segments/b0s04[40]
    - /Purkinje/segments/b0s04[42]
    - /Purkinje/segments/b0s04[50]
    - /Purkinje/segments/b0s04[52]
    - /Purkinje/segments/b0s04[54]
    - /Purkinje/segments/b0s04[55]
    - /Purkinje/segments/b0s04[56]
    - /Purkinje/segments/b0s04[57]
    - /Purkinje/segments/b0s04[60]
    - /Purkinje/segments/b0s04[62]
    - /Purkinje/segments/b0s04[64]
    - /Purkinje/segments/b0s04[68]
    - /Purkinje/segments/b0s04[70]
    - /Purkinje/segments/b0s04[73]
    - /Purkinje/segments/b0s04[76]
    - /Purkinje/segments/b0s04[77]
    - /Purkinje/segments/b0s04[81]
    - /Purkinje/segments/b0s04[82]
    - /Purkinje/segments/b0s04[88]
    - /Purkinje/segments/b0s04[98]
    - /Purkinje/segments/b0s04[99]
    - /Purkinje/segments/b0s04[102]
    - /Purkinje/segments/b0s04[107]
    - /Purkinje/segments/b0s04[108]
    - /Purkinje/segments/b0s04[112]
    - /Purkinje/segments/b0s04[115]
    - /Purkinje/segments/b0s04[118]
    - /Purkinje/segments/b0s04[119]
    - /Purkinje/segments/b0s04[123]
    - /Purkinje/segments/b0s04[124]
    - /Purkinje/segments/b0s04[134]
    - /Purkinje/segments/b0s04[136]
    - /Purkinje/segments/b0s04[139]
    - /Purkinje/segments/b0s04[142]
    - /Purkinje/segments/b0s04[144]
    - /Purkinje/segments/b0s04[148]
    - /Purkinje/segments/b0s04[154]
    - /Purkinje/segments/b0s04[155]
    - /Purkinje/segments/b1s05[3]
    - /Purkinje/segments/b1s05[5]
    - /Purkinje/segments/b1s05[6]
    - /Purkinje/segments/b1s06[8]
    - /Purkinje/segments/b1s06[14]
    - /Purkinje/segments/b1s06[16]
    - /Purkinje/segments/b1s06[24]
    - /Purkinje/segments/b1s06[25]
    - /Purkinje/segments/b1s06[30]
    - /Purkinje/segments/b1s06[33]
    - /Purkinje/segments/b1s06[35]
    - /Purkinje/segments/b1s06[37]
    - /Purkinje/segments/b1s06[38]
    - /Purkinje/segments/b1s06[41]
    - /Purkinje/segments/b1s06[43]
    - /Purkinje/segments/b1s06[47]
    - /Purkinje/segments/b1s06[48]
    - /Purkinje/segments/b1s06[52]
    - /Purkinje/segments/b1s06[54]
    - /Purkinje/segments/b1s06[63]
    - /Purkinje/segments/b1s06[70]
    - /Purkinje/segments/b1s06[71]
    - /Purkinje/segments/b1s06[74]
    - /Purkinje/segments/b1s06[79]
    - /Purkinje/segments/b1s06[81]
    - /Purkinje/segments/b1s06[82]
    - /Purkinje/segments/b1s06[85]
    - /Purkinje/segments/b1s06[91]
    - /Purkinje/segments/b1s06[95]
    - /Purkinje/segments/b1s06[98]
    - /Purkinje/segments/b1s06[101]
    - /Purkinje/segments/b1s06[104]
    - /Purkinje/segments/b1s06[105]
    - /Purkinje/segments/b1s06[106]
    - /Purkinje/segments/b1s06[112]
    - /Purkinje/segments/b1s06[115]
    - /Purkinje/segments/b1s06[117]
    - /Purkinje/segments/b1s06[120]
    - /Purkinje/segments/b1s06[121]
    - /Purkinje/segments/b1s06[128]
    - /Purkinje/segments/b1s06[133]
    - /Purkinje/segments/b1s06[134]
    - /Purkinje/segments/b1s06[136]
    - /Purkinje/segments/b1s06[141]
    - /Purkinje/segments/b1s06[144]
    - /Purkinje/segments/b1s06[145]
    - /Purkinje/segments/b1s06[153]
    - /Purkinje/segments/b1s06[159]
    - /Purkinje/segments/b1s06[162]
    - /Purkinje/segments/b1s06[164]
    - /Purkinje/segments/b1s06[167]
    - /Purkinje/segments/b1s06[174]
    - /Purkinje/segments/b1s06[175]
    - /Purkinje/segments/b1s06[178]
    - /Purkinje/segments/b1s06[180]
    - /Purkinje/segments/b1s06[182]
    - /Purkinje/segments/b1s07[5]
    - /Purkinje/segments/b1s08[4]
    - /Purkinje/segments/b1s08[11]
    - /Purkinje/segments/b1s08[12]
    - /Purkinje/segments/b1s08[14]
    - /Purkinje/segments/b1s08[15]
    - /Purkinje/segments/b1s08[19]
    - /Purkinje/segments/b1s08[20]
    - /Purkinje/segments/b1s08[21]
    - /Purkinje/segments/b1s08[24]
    - /Purkinje/segments/b1s09[4]
    - /Purkinje/segments/b1s09[6]
    - /Purkinje/segments/b1s09[8]
    - /Purkinje/segments/b1s09[9]
    - /Purkinje/segments/b1s09[18]
    - /Purkinje/segments/b1s09[23]
    - /Purkinje/segments/b1s09[24]
    - /Purkinje/segments/b1s09[27]
    - /Purkinje/segments/b1s09[28]
    - /Purkinje/segments/b1s09[30]
    - /Purkinje/segments/b1s09[33]
    - /Purkinje/segments/b1s09[36]
    - /Purkinje/segments/b1s09[39]
    - /Purkinje/segments/b1s10[6]
    - /Purkinje/segments/b1s10[9]
    - /Purkinje/segments/b1s10[13]
    - /Purkinje/segments/b1s10[15]
    - /Purkinje/segments/b1s10[17]
    - /Purkinje/segments/b1s10[19]
    - /Purkinje/segments/b1s10[20]
    - /Purkinje/segments/b1s10[22]
    - /Purkinje/segments/b1s10[27]
    - /Purkinje/segments/b1s10[28]
    - /Purkinje/segments/b1s10[36]
    - /Purkinje/segments/b1s10[42]
    - /Purkinje/segments/b1s10[43]
    - /Purkinje/segments/b1s10[45]
    - /Purkinje/segments/b1s10[48]
    - /Purkinje/segments/b1s10[53]
    - /Purkinje/segments/b1s10[56]
    - /Purkinje/segments/b1s10[60]
    - /Purkinje/segments/b1s10[62]
    - /Purkinje/segments/b1s10[64]
    - /Purkinje/segments/b1s10[66]
    - /Purkinje/segments/b1s10[70]
    - /Purkinje/segments/b1s10[71]
    - /Purkinje/segments/b1s10[77]
    - /Purkinje/segments/b1s10[81]
    - /Purkinje/segments/b1s10[82]
    - /Purkinje/segments/b1s10[84]
    - /Purkinje/segments/b1s10[85]
    - /Purkinje/segments/b1s11[3]
    - /Purkinje/segments/b1s11[7]
    - /Purkinje/segments/b1s11[10]
    - /Purkinje/segments/b1s12[3]
    - /Purkinje/segments/b1s12[11]
    - /Purkinje/segments/b1s12[12]
    - /Purkinje/segments/b1s12[16]
    - /Purkinje/segments/b1s12[27]
    - /Purkinje/segments/b1s12[29]
    - /Purkinje/segments/b1s12[31]
    - /Purkinje/segments/b1s12[33]
    - /Purkinje/segments/b1s12[36]
    - /Purkinje/segments/b1s12[38]
    - /Purkinje/segments/b1s12[42]
    - /Purkinje/segments/b1s12[45]
    - /Purkinje/segments/b1s12[49]
    - /Purkinje/segments/b1s12[52]
    - /Purkinje/segments/b1s12[53]
    - /Purkinje/segments/b1s13[3]
    - /Purkinje/segments/b1s13[8]
    - /Purkinje/segments/b1s14[12]
    - /Purkinje/segments/b1s14[15]
    - /Purkinje/segments/b1s14[16]
    - /Purkinje/segments/b1s14[23]
    - /Purkinje/segments/b1s14[31]
    - /Purkinje/segments/b1s14[33]
    - /Purkinje/segments/b1s14[35]
    - /Purkinje/segments/b1s14[39]
    - /Purkinje/segments/b1s14[42]
    - /Purkinje/segments/b1s15[1]
    - /Purkinje/segments/b1s15[4]
    - /Purkinje/segments/b1s15[6]
    - /Purkinje/segments/b1s15[7]
    - /Purkinje/segments/b1s16[2]
    - /Purkinje/segments/b1s17[1]
    - /Purkinje/segments/b1s18[0]
    - /Purkinje/segments/b1s19[2]
    - /Purkinje/segments/b1s19[12]
    - /Purkinje/segments/b1s19[14]
    - /Purkinje/segments/b1s19[16]
    - /Purkinje/segments/b1s19[20]
    - /Purkinje/segments/b1s19[22]
    - /Purkinje/segments/b1s19[24]
    - /Purkinje/segments/b1s19[29]
    - /Purkinje/segments/b1s19[37]
    - /Purkinje/segments/b1s19[39]
    - /Purkinje/segments/b1s19[42]
    - /Purkinje/segments/b1s20[6]
    - /Purkinje/segments/b1s20[9]
    - /Purkinje/segments/b1s20[10]
    - /Purkinje/segments/b1s20[12]
    - /Purkinje/segments/b1s20[14]
    - /Purkinje/segments/b1s20[18]
    - /Purkinje/segments/b1s20[20]
    - /Purkinje/segments/b1s20[21]
    - /Purkinje/segments/b2s21[4]
    - /Purkinje/segments/b2s21[5]
    - /Purkinje/segments/b2s21[9]
    - /Purkinje/segments/b2s21[15]
    - /Purkinje/segments/b2s21[17]
    - /Purkinje/segments/b2s21[20]
    - /Purkinje/segments/b2s21[22]
    - /Purkinje/segments/b2s21[24]
    - /Purkinje/segments/b2s22[4]
    - /Purkinje/segments/b2s22[7]
    - /Purkinje/segments/b2s22[8]
    - /Purkinje/segments/b2s22[11]
    - /Purkinje/segments/b2s22[12]
    - /Purkinje/segments/b2s23[4]
    - /Purkinje/segments/b2s23[8]
    - /Purkinje/segments/b2s23[13]
    - /Purkinje/segments/b2s23[15]
    - /Purkinje/segments/b2s23[16]
    - /Purkinje/segments/b2s23[20]
    - /Purkinje/segments/b2s23[25]
    - /Purkinje/segments/b2s23[27]
    - /Purkinje/segments/b2s24[4]
    - /Purkinje/segments/b2s24[6]
    - /Purkinje/segments/b2s25[4]
    - /Purkinje/segments/b2s25[8]
    - /Purkinje/segments/b2s25[10]
    - /Purkinje/segments/b2s25[14]
    - /Purkinje/segments/b2s25[16]
    - /Purkinje/segments/b2s25[18]
    - /Purkinje/segments/b2s25[22]
    - /Purkinje/segments/b2s25[25]
    - /Purkinje/segments/b2s25[27]
    - /Purkinje/segments/b2s25[28]
    - /Purkinje/segments/b2s25[31]
    - /Purkinje/segments/b2s25[33]
    - /Purkinje/segments/b2s25[34]
    - /Purkinje/segments/b2s26[3]
    - /Purkinje/segments/b2s26[6]
    - /Purkinje/segments/b2s26[10]
    - /Purkinje/segments/b2s26[11]
    - /Purkinje/segments/b2s26[15]
    - /Purkinje/segments/b2s26[19]
    - /Purkinje/segments/b2s26[20]
    - /Purkinje/segments/b2s26[23]
    - /Purkinje/segments/b2s26[24]
    - /Purkinje/segments/b2s26[27]
    - /Purkinje/segments/b2s26[29]
    - /Purkinje/segments/b2s26[30]
    - /Purkinje/segments/b2s26[33]
    - /Purkinje/segments/b2s26[34]
    - /Purkinje/segments/b2s26[35]
    - /Purkinje/segments/b2s27[4]
    - /Purkinje/segments/b2s27[6]
    - /Purkinje/segments/b2s27[7]
    - /Purkinje/segments/b2s27[10]
    - /Purkinje/segments/b2s27[14]
    - /Purkinje/segments/b2s27[16]
    - /Purkinje/segments/b2s27[22]
    - /Purkinje/segments/b2s27[24]
    - /Purkinje/segments/b2s27[26]
    - /Purkinje/segments/b2s27[33]
    - /Purkinje/segments/b2s27[34]
    - /Purkinje/segments/b2s27[39]
    - /Purkinje/segments/b2s27[41]
    - /Purkinje/segments/b2s27[45]
    - /Purkinje/segments/b2s27[47]
    - /Purkinje/segments/b2s28[4]
    - /Purkinje/segments/b2s28[7]
    - /Purkinje/segments/b2s28[14]
    - /Purkinje/segments/b2s28[15]
    - /Purkinje/segments/b2s28[17]
    - /Purkinje/segments/b2s28[20]
    - /Purkinje/segments/b2s29[5]
    - /Purkinje/segments/b2s29[9]
    - /Purkinje/segments/b2s29[13]
    - /Purkinje/segments/b2s29[17]
    - /Purkinje/segments/b2s29[18]
    - /Purkinje/segments/b2s29[20]
    - /Purkinje/segments/b2s29[24]
    - /Purkinje/segments/b2s29[28]
    - /Purkinje/segments/b2s29[29]
    - /Purkinje/segments/b2s29[33]
    - /Purkinje/segments/b2s29[34]
    - /Purkinje/segments/b2s29[38]
    - /Purkinje/segments/b2s29[41]
    - /Purkinje/segments/b2s30[6]
    - /Purkinje/segments/b2s30[7]
    - /Purkinje/segments/b2s30[9]
    - /Purkinje/segments/b2s30[13]
    - /Purkinje/segments/b2s30[15]
    - /Purkinje/segments/b2s30[18]
    - /Purkinje/segments/b2s30[21]
    - /Purkinje/segments/b2s30[22]
    - /Purkinje/segments/b2s30[23]
    - /Purkinje/segments/b2s31[2]
    - /Purkinje/segments/b2s31[3]
    - /Purkinje/segments/b2s32[1]
    - /Purkinje/segments/b2s33[3]
    - /Purkinje/segments/b2s33[6]
    - /Purkinje/segments/b2s34[5]
    - /Purkinje/segments/b2s34[8]
    - /Purkinje/segments/b2s34[9]
    - /Purkinje/segments/b3s35[3]
    - /Purkinje/segments/b3s35[10]
    - /Purkinje/segments/b3s35[13]
    - /Purkinje/segments/b3s35[17]
    - /Purkinje/segments/b3s35[20]
    - /Purkinje/segments/b3s36[4]
    - /Purkinje/segments/b3s36[8]
    - /Purkinje/segments/b3s36[9]
    - /Purkinje/segments/b3s37[5]
    - /Purkinje/segments/b3s37[10]
    - /Purkinje/segments/b3s37[11]
    - /Purkinje/segments/b3s37[13]
    - /Purkinje/segments/b3s37[14]
    - /Purkinje/segments/b3s37[16]
    - /Purkinje/segments/b3s37[17]
    - /Purkinje/segments/b3s37[23]
    - /Purkinje/segments/b3s37[25]
    - /Purkinje/segments/b3s37[28]
    - /Purkinje/segments/b3s37[32]
    - /Purkinje/segments/b3s37[33]
    - /Purkinje/segments/b3s37[35]
    - /Purkinje/segments/b3s37[39]
    - /Purkinje/segments/b3s37[41]
    - /Purkinje/segments/b3s38[4]
    - /Purkinje/segments/b3s39[5]
    - /Purkinje/segments/b3s39[10]
    - /Purkinje/segments/b3s39[13]
    - /Purkinje/segments/b3s40[3]
    - /Purkinje/segments/b3s40[6]
    - /Purkinje/segments/b3s40[7]
    - /Purkinje/segments/b3s41[3]
    - /Purkinje/segments/b3s41[7]
    - /Purkinje/segments/b3s41[8]
    - /Purkinje/segments/b3s41[9]
    - /Purkinje/segments/b3s42[3]
    - /Purkinje/segments/b3s43[3]
    - /Purkinje/segments/b3s43[4]
    - /Purkinje/segments/b3s43[5]
    - /Purkinje/segments/b3s44[4]
    - /Purkinje/segments/b3s44[8]
    - /Purkinje/segments/b3s44[9]
    - /Purkinje/segments/b3s44[13]
    - /Purkinje/segments/b3s44[15]
    - /Purkinje/segments/b3s44[20]
    - /Purkinje/segments/b3s44[23]
    - /Purkinje/segments/b3s44[25]
    - /Purkinje/segments/b3s44[29]
    - /Purkinje/segments/b3s44[35]
    - /Purkinje/segments/b3s44[36]
    - /Purkinje/segments/b3s44[37]
    - /Purkinje/segments/b3s44[42]
    - /Purkinje/segments/b3s44[48]
    - /Purkinje/segments/b3s44[49]
    - /Purkinje/segments/b3s45[3]
    - /Purkinje/segments/b3s45[9]
    - /Purkinje/segments/b3s45[11]
    - /Purkinje/segments/b3s45[18]
    - /Purkinje/segments/b3s45[19]
    - /Purkinje/segments/b3s45[23]
    - /Purkinje/segments/b3s45[28]
    - /Purkinje/segments/b3s45[31]
    - /Purkinje/segments/b3s45[32]
    - /Purkinje/segments/b3s45[35]
    - /Purkinje/segments/b3s45[39]
    - /Purkinje/segments/b3s45[40]
    - /Purkinje/segments/b3s45[41]
    - /Purkinje/segments/b3s46[4]
    - /Purkinje/segments/b3s46[6]
    - /Purkinje/segments/b3s46[12]
    - /Purkinje/segments/b3s46[15]
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology without spines, after modifying the dendritic tree",
				disabled => (`cat $::config->{core_directory}/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'neurospaces was not configured to include the delete operation'),
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-A',
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
						   description => "Can we get information on all the dendritic tips of the purkinje cell ?",
						   read => 'tips:
  name: Purkinje
  names:
    - /Purkinje/segments/b0s01[6]
    - /Purkinje/segments/b0s01[8]
    - /Purkinje/segments/b0s01[10]
    - /Purkinje/segments/b0s01[13]
    - /Purkinje/segments/b0s01[16]
    - /Purkinje/segments/b0s01[19]
    - /Purkinje/segments/b0s01[22]
    - /Purkinje/segments/b0s01[27]
    - /Purkinje/segments/b0s01[30]
    - /Purkinje/segments/b0s01[33]
    - /Purkinje/segments/b0s01[38]
    - /Purkinje/segments/b0s01[44]
    - /Purkinje/segments/b0s02[7]
    - /Purkinje/segments/b0s02[10]
    - /Purkinje/segments/b0s02[14]
    - /Purkinje/segments/b0s02[18]
    - /Purkinje/segments/b0s02[25]
    - /Purkinje/segments/b0s02[27]
    - /Purkinje/segments/b0s02[29]
    - /Purkinje/segments/b0s02[39]
    - /Purkinje/segments/b0s02[44]
    - /Purkinje/segments/b0s02[47]
    - /Purkinje/segments/b0s02[48]
    - /Purkinje/segments/b0s02[51]
    - /Purkinje/segments/b0s02[54]
    - /Purkinje/segments/b0s02[56]
    - /Purkinje/segments/b0s02[57]
    - /Purkinje/segments/b0s02[63]
    - /Purkinje/segments/b0s02[64]
    - /Purkinje/segments/b0s02[72]
    - /Purkinje/segments/b0s02[74]
    - /Purkinje/segments/b0s02[76]
    - /Purkinje/segments/b0s02[78]
    - /Purkinje/segments/b0s02[80]
    - /Purkinje/segments/b0s02[81]
    - /Purkinje/segments/b0s02[84]
    - /Purkinje/segments/b0s02[88]
    - /Purkinje/segments/b0s02[96]
    - /Purkinje/segments/b0s02[97]
    - /Purkinje/segments/b0s02[100]
    - /Purkinje/segments/b0s02[102]
    - /Purkinje/segments/b0s02[105]
    - /Purkinje/segments/b0s02[108]
    - /Purkinje/segments/b0s02[110]
    - /Purkinje/segments/b0s02[114]
    - /Purkinje/segments/b0s02[116]
    - /Purkinje/segments/b0s02[117]
    - /Purkinje/segments/b0s02[127]
    - /Purkinje/segments/b0s02[132]
    - /Purkinje/segments/b0s02[134]
    - /Purkinje/segments/b0s02[136]
    - /Purkinje/segments/b0s02[144]
    - /Purkinje/segments/b0s02[147]
    - /Purkinje/segments/b0s02[148]
    - /Purkinje/segments/b0s02[152]
    - /Purkinje/segments/b0s02[155]
    - /Purkinje/segments/b0s02[158]
    - /Purkinje/segments/b0s02[159]
    - /Purkinje/segments/b0s02[164]
    - /Purkinje/segments/b0s02[166]
    - /Purkinje/segments/b0s02[170]
    - /Purkinje/segments/b0s02[172]
    - /Purkinje/segments/b0s02[177]
    - /Purkinje/segments/b0s02[182]
    - /Purkinje/segments/b0s02[183]
    - /Purkinje/segments/b0s02[185]
    - /Purkinje/segments/b0s03[3]
    - /Purkinje/segments/b0s03[6]
    - /Purkinje/segments/b0s03[15]
    - /Purkinje/segments/b0s03[18]
    - /Purkinje/segments/b0s03[22]
    - /Purkinje/segments/b0s03[26]
    - /Purkinje/segments/b0s03[28]
    - /Purkinje/segments/b0s03[30]
    - /Purkinje/segments/b0s03[32]
    - /Purkinje/segments/b0s03[34]
    - /Purkinje/segments/b0s03[36]
    - /Purkinje/segments/b0s03[37]
    - /Purkinje/segments/b0s03[42]
    - /Purkinje/segments/b0s03[48]
    - /Purkinje/segments/b0s03[49]
    - /Purkinje/segments/b0s03[51]
    - /Purkinje/segments/b0s03[53]
    - /Purkinje/segments/b0s03[60]
    - /Purkinje/segments/b0s03[62]
    - /Purkinje/segments/b0s03[63]
    - /Purkinje/segments/b0s03[64]
    - /Purkinje/segments/b0s03[67]
    - /Purkinje/segments/b0s03[69]
    - /Purkinje/segments/b0s04[5]
    - /Purkinje/segments/b0s04[6]
    - /Purkinje/segments/b0s04[9]
    - /Purkinje/segments/b0s04[11]
    - /Purkinje/segments/b0s04[12]
    - /Purkinje/segments/b0s04[16]
    - /Purkinje/segments/b0s04[19]
    - /Purkinje/segments/b0s04[20]
    - /Purkinje/segments/b0s04[24]
    - /Purkinje/segments/b0s04[28]
    - /Purkinje/segments/b0s04[29]
    - /Purkinje/segments/b0s04[38]
    - /Purkinje/segments/b0s04[40]
    - /Purkinje/segments/b0s04[42]
    - /Purkinje/segments/b0s04[50]
    - /Purkinje/segments/b0s04[52]
    - /Purkinje/segments/b0s04[54]
    - /Purkinje/segments/b0s04[55]
    - /Purkinje/segments/b0s04[56]
    - /Purkinje/segments/b0s04[57]
    - /Purkinje/segments/b0s04[60]
    - /Purkinje/segments/b0s04[62]
    - /Purkinje/segments/b0s04[64]
    - /Purkinje/segments/b0s04[68]
    - /Purkinje/segments/b0s04[70]
    - /Purkinje/segments/b0s04[73]
    - /Purkinje/segments/b0s04[76]
    - /Purkinje/segments/b0s04[77]
    - /Purkinje/segments/b0s04[81]
    - /Purkinje/segments/b0s04[82]
    - /Purkinje/segments/b0s04[88]
    - /Purkinje/segments/b0s04[98]
    - /Purkinje/segments/b0s04[99]
    - /Purkinje/segments/b0s04[102]
    - /Purkinje/segments/b0s04[107]
    - /Purkinje/segments/b0s04[108]
    - /Purkinje/segments/b0s04[112]
    - /Purkinje/segments/b0s04[115]
    - /Purkinje/segments/b0s04[118]
    - /Purkinje/segments/b0s04[119]
    - /Purkinje/segments/b0s04[123]
    - /Purkinje/segments/b0s04[124]
    - /Purkinje/segments/b0s04[134]
    - /Purkinje/segments/b0s04[136]
    - /Purkinje/segments/b0s04[139]
    - /Purkinje/segments/b0s04[142]
    - /Purkinje/segments/b0s04[144]
    - /Purkinje/segments/b0s04[148]
    - /Purkinje/segments/b0s04[154]
    - /Purkinje/segments/b0s04[155]
    - /Purkinje/segments/b1s05[3]
    - /Purkinje/segments/b1s05[5]
    - /Purkinje/segments/b1s05[6]
    - /Purkinje/segments/b1s06[8]
    - /Purkinje/segments/b1s06[14]
    - /Purkinje/segments/b1s06[16]
    - /Purkinje/segments/b1s06[24]
    - /Purkinje/segments/b1s06[25]
    - /Purkinje/segments/b1s06[30]
    - /Purkinje/segments/b1s06[33]
    - /Purkinje/segments/b1s06[35]
    - /Purkinje/segments/b1s06[37]
    - /Purkinje/segments/b1s06[38]
    - /Purkinje/segments/b1s06[41]
    - /Purkinje/segments/b1s06[43]
    - /Purkinje/segments/b1s06[47]
    - /Purkinje/segments/b1s06[48]
    - /Purkinje/segments/b1s06[52]
    - /Purkinje/segments/b1s06[54]
    - /Purkinje/segments/b1s06[63]
    - /Purkinje/segments/b1s06[70]
    - /Purkinje/segments/b1s06[71]
    - /Purkinje/segments/b1s06[74]
    - /Purkinje/segments/b1s06[79]
    - /Purkinje/segments/b1s06[81]
    - /Purkinje/segments/b1s06[82]
    - /Purkinje/segments/b1s06[85]
    - /Purkinje/segments/b1s06[91]
    - /Purkinje/segments/b1s06[95]
    - /Purkinje/segments/b1s06[98]
    - /Purkinje/segments/b1s06[101]
    - /Purkinje/segments/b1s06[104]
    - /Purkinje/segments/b1s06[105]
    - /Purkinje/segments/b1s06[106]
    - /Purkinje/segments/b1s06[112]
    - /Purkinje/segments/b1s06[115]
    - /Purkinje/segments/b1s06[117]
    - /Purkinje/segments/b1s06[120]
    - /Purkinje/segments/b1s06[121]
    - /Purkinje/segments/b1s06[128]
    - /Purkinje/segments/b1s06[133]
    - /Purkinje/segments/b1s06[134]
    - /Purkinje/segments/b1s06[136]
    - /Purkinje/segments/b1s06[141]
    - /Purkinje/segments/b1s06[144]
    - /Purkinje/segments/b1s06[145]
    - /Purkinje/segments/b1s06[153]
    - /Purkinje/segments/b1s06[159]
    - /Purkinje/segments/b1s06[162]
    - /Purkinje/segments/b1s06[164]
    - /Purkinje/segments/b1s06[167]
    - /Purkinje/segments/b1s06[174]
    - /Purkinje/segments/b1s06[175]
    - /Purkinje/segments/b1s06[178]
    - /Purkinje/segments/b1s06[180]
    - /Purkinje/segments/b1s06[182]
    - /Purkinje/segments/b1s07[5]
    - /Purkinje/segments/b1s08[4]
    - /Purkinje/segments/b1s08[11]
    - /Purkinje/segments/b1s08[12]
    - /Purkinje/segments/b1s08[14]
    - /Purkinje/segments/b1s08[15]
    - /Purkinje/segments/b1s08[19]
    - /Purkinje/segments/b1s08[20]
    - /Purkinje/segments/b1s08[21]
    - /Purkinje/segments/b1s08[24]
    - /Purkinje/segments/b1s09[4]
    - /Purkinje/segments/b1s09[6]
    - /Purkinje/segments/b1s09[8]
    - /Purkinje/segments/b1s09[9]
    - /Purkinje/segments/b1s09[18]
    - /Purkinje/segments/b1s09[23]
    - /Purkinje/segments/b1s09[24]
    - /Purkinje/segments/b1s09[27]
    - /Purkinje/segments/b1s09[28]
    - /Purkinje/segments/b1s09[30]
    - /Purkinje/segments/b1s09[33]
    - /Purkinje/segments/b1s09[36]
    - /Purkinje/segments/b1s09[39]
    - /Purkinje/segments/b1s10[6]
    - /Purkinje/segments/b1s10[9]
    - /Purkinje/segments/b1s10[13]
    - /Purkinje/segments/b1s10[15]
    - /Purkinje/segments/b1s10[17]
    - /Purkinje/segments/b1s10[19]
    - /Purkinje/segments/b1s10[20]
    - /Purkinje/segments/b1s10[22]
    - /Purkinje/segments/b1s10[27]
    - /Purkinje/segments/b1s10[28]
    - /Purkinje/segments/b1s10[36]
    - /Purkinje/segments/b1s10[42]
    - /Purkinje/segments/b1s10[43]
    - /Purkinje/segments/b1s10[45]
    - /Purkinje/segments/b1s10[48]
    - /Purkinje/segments/b1s10[53]
    - /Purkinje/segments/b1s10[56]
    - /Purkinje/segments/b1s10[60]
    - /Purkinje/segments/b1s10[62]
    - /Purkinje/segments/b1s10[64]
    - /Purkinje/segments/b1s10[66]
    - /Purkinje/segments/b1s10[70]
    - /Purkinje/segments/b1s10[71]
    - /Purkinje/segments/b1s10[77]
    - /Purkinje/segments/b1s10[81]
    - /Purkinje/segments/b1s10[82]
    - /Purkinje/segments/b1s10[84]
    - /Purkinje/segments/b1s10[85]
    - /Purkinje/segments/b1s11[3]
    - /Purkinje/segments/b1s11[7]
    - /Purkinje/segments/b1s11[10]
    - /Purkinje/segments/b1s12[3]
    - /Purkinje/segments/b1s12[11]
    - /Purkinje/segments/b1s12[12]
    - /Purkinje/segments/b1s12[16]
    - /Purkinje/segments/b1s12[27]
    - /Purkinje/segments/b1s12[29]
    - /Purkinje/segments/b1s12[31]
    - /Purkinje/segments/b1s12[33]
    - /Purkinje/segments/b1s12[36]
    - /Purkinje/segments/b1s12[38]
    - /Purkinje/segments/b1s12[42]
    - /Purkinje/segments/b1s12[45]
    - /Purkinje/segments/b1s12[49]
    - /Purkinje/segments/b1s12[52]
    - /Purkinje/segments/b1s12[53]
    - /Purkinje/segments/b1s13[3]
    - /Purkinje/segments/b1s13[8]
    - /Purkinje/segments/b1s14[12]
    - /Purkinje/segments/b1s14[15]
    - /Purkinje/segments/b1s14[16]
    - /Purkinje/segments/b1s14[23]
    - /Purkinje/segments/b1s14[31]
    - /Purkinje/segments/b1s14[33]
    - /Purkinje/segments/b1s14[35]
    - /Purkinje/segments/b1s14[39]
    - /Purkinje/segments/b1s14[42]
    - /Purkinje/segments/b1s15[1]
    - /Purkinje/segments/b1s15[4]
    - /Purkinje/segments/b1s15[6]
    - /Purkinje/segments/b1s15[7]
    - /Purkinje/segments/b1s16[2]
    - /Purkinje/segments/b1s17[1]
    - /Purkinje/segments/b1s18[0]
    - /Purkinje/segments/b1s19[2]
    - /Purkinje/segments/b1s19[12]
    - /Purkinje/segments/b1s19[14]
    - /Purkinje/segments/b1s19[16]
    - /Purkinje/segments/b1s19[20]
    - /Purkinje/segments/b1s19[22]
    - /Purkinje/segments/b1s19[24]
    - /Purkinje/segments/b1s19[29]
    - /Purkinje/segments/b1s19[37]
    - /Purkinje/segments/b1s19[39]
    - /Purkinje/segments/b1s19[42]
    - /Purkinje/segments/b1s20[6]
    - /Purkinje/segments/b1s20[9]
    - /Purkinje/segments/b1s20[10]
    - /Purkinje/segments/b1s20[12]
    - /Purkinje/segments/b1s20[14]
    - /Purkinje/segments/b1s20[18]
    - /Purkinje/segments/b1s20[20]
    - /Purkinje/segments/b1s20[21]
    - /Purkinje/segments/b2s21[4]
    - /Purkinje/segments/b2s21[5]
    - /Purkinje/segments/b2s21[9]
    - /Purkinje/segments/b2s21[15]
    - /Purkinje/segments/b2s21[17]
    - /Purkinje/segments/b2s21[20]
    - /Purkinje/segments/b2s21[22]
    - /Purkinje/segments/b2s21[24]
    - /Purkinje/segments/b2s22[4]
    - /Purkinje/segments/b2s22[7]
    - /Purkinje/segments/b2s22[8]
    - /Purkinje/segments/b2s22[11]
    - /Purkinje/segments/b2s22[12]
    - /Purkinje/segments/b2s23[4]
    - /Purkinje/segments/b2s23[8]
    - /Purkinje/segments/b2s23[13]
    - /Purkinje/segments/b2s23[15]
    - /Purkinje/segments/b2s23[16]
    - /Purkinje/segments/b2s23[20]
    - /Purkinje/segments/b2s23[25]
    - /Purkinje/segments/b2s23[27]
    - /Purkinje/segments/b2s24[4]
    - /Purkinje/segments/b2s24[6]
    - /Purkinje/segments/b2s25[4]
    - /Purkinje/segments/b2s25[8]
    - /Purkinje/segments/b2s25[10]
    - /Purkinje/segments/b2s25[14]
    - /Purkinje/segments/b2s25[16]
    - /Purkinje/segments/b2s25[18]
    - /Purkinje/segments/b2s25[22]
    - /Purkinje/segments/b2s25[25]
    - /Purkinje/segments/b2s25[27]
    - /Purkinje/segments/b2s25[28]
    - /Purkinje/segments/b2s25[31]
    - /Purkinje/segments/b2s25[33]
    - /Purkinje/segments/b2s25[34]
    - /Purkinje/segments/b2s26[3]
    - /Purkinje/segments/b2s26[6]
    - /Purkinje/segments/b2s26[10]
    - /Purkinje/segments/b2s26[11]
    - /Purkinje/segments/b2s26[15]
    - /Purkinje/segments/b2s26[19]
    - /Purkinje/segments/b2s26[20]
    - /Purkinje/segments/b2s26[23]
    - /Purkinje/segments/b2s26[24]
    - /Purkinje/segments/b2s26[27]
    - /Purkinje/segments/b2s26[29]
    - /Purkinje/segments/b2s26[30]
    - /Purkinje/segments/b2s26[33]
    - /Purkinje/segments/b2s26[34]
    - /Purkinje/segments/b2s26[35]
    - /Purkinje/segments/b2s27[4]
    - /Purkinje/segments/b2s27[6]
    - /Purkinje/segments/b2s27[7]
    - /Purkinje/segments/b2s27[10]
    - /Purkinje/segments/b2s27[14]
    - /Purkinje/segments/b2s27[16]
    - /Purkinje/segments/b2s27[22]
    - /Purkinje/segments/b2s27[24]
    - /Purkinje/segments/b2s27[26]
    - /Purkinje/segments/b2s27[33]
    - /Purkinje/segments/b2s27[34]
    - /Purkinje/segments/b2s27[39]
    - /Purkinje/segments/b2s27[41]
    - /Purkinje/segments/b2s27[45]
    - /Purkinje/segments/b2s27[47]
    - /Purkinje/segments/b2s28[4]
    - /Purkinje/segments/b2s28[7]
    - /Purkinje/segments/b2s28[14]
    - /Purkinje/segments/b2s28[15]
    - /Purkinje/segments/b2s28[17]
    - /Purkinje/segments/b2s28[20]
    - /Purkinje/segments/b2s29[5]
    - /Purkinje/segments/b2s29[9]
    - /Purkinje/segments/b2s29[13]
    - /Purkinje/segments/b2s29[17]
    - /Purkinje/segments/b2s29[18]
    - /Purkinje/segments/b2s29[20]
    - /Purkinje/segments/b2s29[24]
    - /Purkinje/segments/b2s29[28]
    - /Purkinje/segments/b2s29[29]
    - /Purkinje/segments/b2s29[33]
    - /Purkinje/segments/b2s29[34]
    - /Purkinje/segments/b2s29[38]
    - /Purkinje/segments/b2s29[41]
    - /Purkinje/segments/b2s30[6]
    - /Purkinje/segments/b2s30[7]
    - /Purkinje/segments/b2s30[9]
    - /Purkinje/segments/b2s30[13]
    - /Purkinje/segments/b2s30[15]
    - /Purkinje/segments/b2s30[18]
    - /Purkinje/segments/b2s30[21]
    - /Purkinje/segments/b2s30[22]
    - /Purkinje/segments/b2s30[23]
    - /Purkinje/segments/b2s31[2]
    - /Purkinje/segments/b2s31[3]
    - /Purkinje/segments/b2s32[1]
    - /Purkinje/segments/b2s33[3]
    - /Purkinje/segments/b2s33[6]
    - /Purkinje/segments/b2s34[5]
    - /Purkinje/segments/b2s34[8]
    - /Purkinje/segments/b2s34[9]
    - /Purkinje/segments/b3s35[3]
    - /Purkinje/segments/b3s35[10]
    - /Purkinje/segments/b3s35[13]
    - /Purkinje/segments/b3s35[17]
    - /Purkinje/segments/b3s35[20]
    - /Purkinje/segments/b3s36[4]
    - /Purkinje/segments/b3s36[8]
    - /Purkinje/segments/b3s36[9]
    - /Purkinje/segments/b3s37[5]
    - /Purkinje/segments/b3s37[10]
    - /Purkinje/segments/b3s37[11]
    - /Purkinje/segments/b3s37[13]
    - /Purkinje/segments/b3s37[14]
    - /Purkinje/segments/b3s37[16]
    - /Purkinje/segments/b3s37[17]
    - /Purkinje/segments/b3s37[23]
    - /Purkinje/segments/b3s37[25]
    - /Purkinje/segments/b3s37[28]
    - /Purkinje/segments/b3s37[32]
    - /Purkinje/segments/b3s37[33]
    - /Purkinje/segments/b3s37[35]
    - /Purkinje/segments/b3s37[39]
    - /Purkinje/segments/b3s37[41]
    - /Purkinje/segments/b3s38[4]
    - /Purkinje/segments/b3s39[5]
    - /Purkinje/segments/b3s39[10]
    - /Purkinje/segments/b3s39[13]
    - /Purkinje/segments/b3s40[3]
    - /Purkinje/segments/b3s40[6]
    - /Purkinje/segments/b3s40[7]
    - /Purkinje/segments/b3s41[3]
    - /Purkinje/segments/b3s41[7]
    - /Purkinje/segments/b3s41[8]
    - /Purkinje/segments/b3s41[9]
    - /Purkinje/segments/b3s42[3]
    - /Purkinje/segments/b3s43[3]
    - /Purkinje/segments/b3s43[4]
    - /Purkinje/segments/b3s43[5]
    - /Purkinje/segments/b3s44[4]
    - /Purkinje/segments/b3s44[8]
    - /Purkinje/segments/b3s44[9]
    - /Purkinje/segments/b3s44[13]
    - /Purkinje/segments/b3s44[15]
    - /Purkinje/segments/b3s44[20]
    - /Purkinje/segments/b3s44[23]
    - /Purkinje/segments/b3s44[25]
    - /Purkinje/segments/b3s44[29]
    - /Purkinje/segments/b3s44[35]
    - /Purkinje/segments/b3s44[36]
    - /Purkinje/segments/b3s44[37]
    - /Purkinje/segments/b3s44[42]
    - /Purkinje/segments/b3s44[48]
    - /Purkinje/segments/b3s44[49]
    - /Purkinje/segments/b3s45[3]
    - /Purkinje/segments/b3s45[9]
    - /Purkinje/segments/b3s45[11]
    - /Purkinje/segments/b3s45[18]
    - /Purkinje/segments/b3s45[19]
    - /Purkinje/segments/b3s45[23]
    - /Purkinje/segments/b3s45[28]
    - /Purkinje/segments/b3s45[31]
    - /Purkinje/segments/b3s45[32]
    - /Purkinje/segments/b3s45[35]
    - /Purkinje/segments/b3s45[39]
    - /Purkinje/segments/b3s45[40]
    - /Purkinje/segments/b3s45[41]
    - /Purkinje/segments/b3s46[4]
    - /Purkinje/segments/b3s46[6]
    - /Purkinje/segments/b3s46[12]
    - /Purkinje/segments/b3s46[15]
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
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
						   description => 'Can we delete the soma ?',
						   read => 'neurospaces ',
						   write => 'delete /Purkinje/segments/soma',
						  },
						  {
						   description => "Can we get information on all the dendritic tips of the purkinje cell, soma deleted ?",
						   read => 'warning: cannot find parent segment /Purkinje/segments/soma for segment /Purkinje/segments/main[0]
---
tips:
  name: Purkinje
  names:
    - /Purkinje/segments/b0s01[6]
    - /Purkinje/segments/b0s01[8]
    - /Purkinje/segments/b0s01[10]
    - /Purkinje/segments/b0s01[13]
    - /Purkinje/segments/b0s01[16]
    - /Purkinje/segments/b0s01[19]
    - /Purkinje/segments/b0s01[22]
    - /Purkinje/segments/b0s01[27]
    - /Purkinje/segments/b0s01[30]
    - /Purkinje/segments/b0s01[33]
    - /Purkinje/segments/b0s01[38]
    - /Purkinje/segments/b0s01[44]
    - /Purkinje/segments/b0s02[7]
    - /Purkinje/segments/b0s02[10]
    - /Purkinje/segments/b0s02[14]
    - /Purkinje/segments/b0s02[18]
    - /Purkinje/segments/b0s02[25]
    - /Purkinje/segments/b0s02[27]
    - /Purkinje/segments/b0s02[29]
    - /Purkinje/segments/b0s02[39]
    - /Purkinje/segments/b0s02[44]
    - /Purkinje/segments/b0s02[47]
    - /Purkinje/segments/b0s02[48]
    - /Purkinje/segments/b0s02[51]
    - /Purkinje/segments/b0s02[54]
    - /Purkinje/segments/b0s02[56]
    - /Purkinje/segments/b0s02[57]
    - /Purkinje/segments/b0s02[63]
    - /Purkinje/segments/b0s02[64]
    - /Purkinje/segments/b0s02[72]
    - /Purkinje/segments/b0s02[74]
    - /Purkinje/segments/b0s02[76]
    - /Purkinje/segments/b0s02[78]
    - /Purkinje/segments/b0s02[80]
    - /Purkinje/segments/b0s02[81]
    - /Purkinje/segments/b0s02[84]
    - /Purkinje/segments/b0s02[88]
    - /Purkinje/segments/b0s02[96]
    - /Purkinje/segments/b0s02[97]
    - /Purkinje/segments/b0s02[100]
    - /Purkinje/segments/b0s02[102]
    - /Purkinje/segments/b0s02[105]
    - /Purkinje/segments/b0s02[108]
    - /Purkinje/segments/b0s02[110]
    - /Purkinje/segments/b0s02[114]
    - /Purkinje/segments/b0s02[116]
    - /Purkinje/segments/b0s02[117]
    - /Purkinje/segments/b0s02[127]
    - /Purkinje/segments/b0s02[132]
    - /Purkinje/segments/b0s02[134]
    - /Purkinje/segments/b0s02[136]
    - /Purkinje/segments/b0s02[144]
    - /Purkinje/segments/b0s02[147]
    - /Purkinje/segments/b0s02[148]
    - /Purkinje/segments/b0s02[152]
    - /Purkinje/segments/b0s02[155]
    - /Purkinje/segments/b0s02[158]
    - /Purkinje/segments/b0s02[159]
    - /Purkinje/segments/b0s02[164]
    - /Purkinje/segments/b0s02[166]
    - /Purkinje/segments/b0s02[170]
    - /Purkinje/segments/b0s02[172]
    - /Purkinje/segments/b0s02[177]
    - /Purkinje/segments/b0s02[182]
    - /Purkinje/segments/b0s02[183]
    - /Purkinje/segments/b0s02[185]
    - /Purkinje/segments/b0s03[3]
    - /Purkinje/segments/b0s03[6]
    - /Purkinje/segments/b0s03[15]
    - /Purkinje/segments/b0s03[18]
    - /Purkinje/segments/b0s03[22]
    - /Purkinje/segments/b0s03[26]
    - /Purkinje/segments/b0s03[28]
    - /Purkinje/segments/b0s03[30]
    - /Purkinje/segments/b0s03[32]
    - /Purkinje/segments/b0s03[34]
    - /Purkinje/segments/b0s03[36]
    - /Purkinje/segments/b0s03[37]
    - /Purkinje/segments/b0s03[42]
    - /Purkinje/segments/b0s03[48]
    - /Purkinje/segments/b0s03[49]
    - /Purkinje/segments/b0s03[51]
    - /Purkinje/segments/b0s03[53]
    - /Purkinje/segments/b0s03[60]
    - /Purkinje/segments/b0s03[62]
    - /Purkinje/segments/b0s03[63]
    - /Purkinje/segments/b0s03[64]
    - /Purkinje/segments/b0s03[67]
    - /Purkinje/segments/b0s03[69]
    - /Purkinje/segments/b0s04[5]
    - /Purkinje/segments/b0s04[6]
    - /Purkinje/segments/b0s04[9]
    - /Purkinje/segments/b0s04[11]
    - /Purkinje/segments/b0s04[12]
    - /Purkinje/segments/b0s04[16]
    - /Purkinje/segments/b0s04[19]
    - /Purkinje/segments/b0s04[20]
    - /Purkinje/segments/b0s04[24]
    - /Purkinje/segments/b0s04[28]
    - /Purkinje/segments/b0s04[29]
    - /Purkinje/segments/b0s04[38]
    - /Purkinje/segments/b0s04[40]
    - /Purkinje/segments/b0s04[42]
    - /Purkinje/segments/b0s04[50]
    - /Purkinje/segments/b0s04[52]
    - /Purkinje/segments/b0s04[54]
    - /Purkinje/segments/b0s04[55]
    - /Purkinje/segments/b0s04[56]
    - /Purkinje/segments/b0s04[57]
    - /Purkinje/segments/b0s04[60]
    - /Purkinje/segments/b0s04[62]
    - /Purkinje/segments/b0s04[64]
    - /Purkinje/segments/b0s04[68]
    - /Purkinje/segments/b0s04[70]
    - /Purkinje/segments/b0s04[73]
    - /Purkinje/segments/b0s04[76]
    - /Purkinje/segments/b0s04[77]
    - /Purkinje/segments/b0s04[81]
    - /Purkinje/segments/b0s04[82]
    - /Purkinje/segments/b0s04[88]
    - /Purkinje/segments/b0s04[98]
    - /Purkinje/segments/b0s04[99]
    - /Purkinje/segments/b0s04[102]
    - /Purkinje/segments/b0s04[107]
    - /Purkinje/segments/b0s04[108]
    - /Purkinje/segments/b0s04[112]
    - /Purkinje/segments/b0s04[115]
    - /Purkinje/segments/b0s04[118]
    - /Purkinje/segments/b0s04[119]
    - /Purkinje/segments/b0s04[123]
    - /Purkinje/segments/b0s04[124]
    - /Purkinje/segments/b0s04[134]
    - /Purkinje/segments/b0s04[136]
    - /Purkinje/segments/b0s04[139]
    - /Purkinje/segments/b0s04[142]
    - /Purkinje/segments/b0s04[144]
    - /Purkinje/segments/b0s04[148]
    - /Purkinje/segments/b0s04[154]
    - /Purkinje/segments/b0s04[155]
    - /Purkinje/segments/b1s05[3]
    - /Purkinje/segments/b1s05[5]
    - /Purkinje/segments/b1s05[6]
    - /Purkinje/segments/b1s06[8]
    - /Purkinje/segments/b1s06[14]
    - /Purkinje/segments/b1s06[16]
    - /Purkinje/segments/b1s06[24]
    - /Purkinje/segments/b1s06[25]
    - /Purkinje/segments/b1s06[30]
    - /Purkinje/segments/b1s06[33]
    - /Purkinje/segments/b1s06[35]
    - /Purkinje/segments/b1s06[37]
    - /Purkinje/segments/b1s06[38]
    - /Purkinje/segments/b1s06[41]
    - /Purkinje/segments/b1s06[43]
    - /Purkinje/segments/b1s06[47]
    - /Purkinje/segments/b1s06[48]
    - /Purkinje/segments/b1s06[52]
    - /Purkinje/segments/b1s06[54]
    - /Purkinje/segments/b1s06[63]
    - /Purkinje/segments/b1s06[70]
    - /Purkinje/segments/b1s06[71]
    - /Purkinje/segments/b1s06[74]
    - /Purkinje/segments/b1s06[79]
    - /Purkinje/segments/b1s06[81]
    - /Purkinje/segments/b1s06[82]
    - /Purkinje/segments/b1s06[85]
    - /Purkinje/segments/b1s06[91]
    - /Purkinje/segments/b1s06[95]
    - /Purkinje/segments/b1s06[98]
    - /Purkinje/segments/b1s06[101]
    - /Purkinje/segments/b1s06[104]
    - /Purkinje/segments/b1s06[105]
    - /Purkinje/segments/b1s06[106]
    - /Purkinje/segments/b1s06[112]
    - /Purkinje/segments/b1s06[115]
    - /Purkinje/segments/b1s06[117]
    - /Purkinje/segments/b1s06[120]
    - /Purkinje/segments/b1s06[121]
    - /Purkinje/segments/b1s06[128]
    - /Purkinje/segments/b1s06[133]
    - /Purkinje/segments/b1s06[134]
    - /Purkinje/segments/b1s06[136]
    - /Purkinje/segments/b1s06[141]
    - /Purkinje/segments/b1s06[144]
    - /Purkinje/segments/b1s06[145]
    - /Purkinje/segments/b1s06[153]
    - /Purkinje/segments/b1s06[159]
    - /Purkinje/segments/b1s06[162]
    - /Purkinje/segments/b1s06[164]
    - /Purkinje/segments/b1s06[167]
    - /Purkinje/segments/b1s06[174]
    - /Purkinje/segments/b1s06[175]
    - /Purkinje/segments/b1s06[178]
    - /Purkinje/segments/b1s06[180]
    - /Purkinje/segments/b1s06[182]
    - /Purkinje/segments/b1s07[5]
    - /Purkinje/segments/b1s08[4]
    - /Purkinje/segments/b1s08[11]
    - /Purkinje/segments/b1s08[12]
    - /Purkinje/segments/b1s08[14]
    - /Purkinje/segments/b1s08[15]
    - /Purkinje/segments/b1s08[19]
    - /Purkinje/segments/b1s08[20]
    - /Purkinje/segments/b1s08[21]
    - /Purkinje/segments/b1s08[24]
    - /Purkinje/segments/b1s09[4]
    - /Purkinje/segments/b1s09[6]
    - /Purkinje/segments/b1s09[8]
    - /Purkinje/segments/b1s09[9]
    - /Purkinje/segments/b1s09[18]
    - /Purkinje/segments/b1s09[23]
    - /Purkinje/segments/b1s09[24]
    - /Purkinje/segments/b1s09[27]
    - /Purkinje/segments/b1s09[28]
    - /Purkinje/segments/b1s09[30]
    - /Purkinje/segments/b1s09[33]
    - /Purkinje/segments/b1s09[36]
    - /Purkinje/segments/b1s09[39]
    - /Purkinje/segments/b1s10[6]
    - /Purkinje/segments/b1s10[9]
    - /Purkinje/segments/b1s10[13]
    - /Purkinje/segments/b1s10[15]
    - /Purkinje/segments/b1s10[17]
    - /Purkinje/segments/b1s10[19]
    - /Purkinje/segments/b1s10[20]
    - /Purkinje/segments/b1s10[22]
    - /Purkinje/segments/b1s10[27]
    - /Purkinje/segments/b1s10[28]
    - /Purkinje/segments/b1s10[36]
    - /Purkinje/segments/b1s10[42]
    - /Purkinje/segments/b1s10[43]
    - /Purkinje/segments/b1s10[45]
    - /Purkinje/segments/b1s10[48]
    - /Purkinje/segments/b1s10[53]
    - /Purkinje/segments/b1s10[56]
    - /Purkinje/segments/b1s10[60]
    - /Purkinje/segments/b1s10[62]
    - /Purkinje/segments/b1s10[64]
    - /Purkinje/segments/b1s10[66]
    - /Purkinje/segments/b1s10[70]
    - /Purkinje/segments/b1s10[71]
    - /Purkinje/segments/b1s10[77]
    - /Purkinje/segments/b1s10[81]
    - /Purkinje/segments/b1s10[82]
    - /Purkinje/segments/b1s10[84]
    - /Purkinje/segments/b1s10[85]
    - /Purkinje/segments/b1s11[3]
    - /Purkinje/segments/b1s11[7]
    - /Purkinje/segments/b1s11[10]
    - /Purkinje/segments/b1s12[3]
    - /Purkinje/segments/b1s12[11]
    - /Purkinje/segments/b1s12[12]
    - /Purkinje/segments/b1s12[16]
    - /Purkinje/segments/b1s12[27]
    - /Purkinje/segments/b1s12[29]
    - /Purkinje/segments/b1s12[31]
    - /Purkinje/segments/b1s12[33]
    - /Purkinje/segments/b1s12[36]
    - /Purkinje/segments/b1s12[38]
    - /Purkinje/segments/b1s12[42]
    - /Purkinje/segments/b1s12[45]
    - /Purkinje/segments/b1s12[49]
    - /Purkinje/segments/b1s12[52]
    - /Purkinje/segments/b1s12[53]
    - /Purkinje/segments/b1s13[3]
    - /Purkinje/segments/b1s13[8]
    - /Purkinje/segments/b1s14[12]
    - /Purkinje/segments/b1s14[15]
    - /Purkinje/segments/b1s14[16]
    - /Purkinje/segments/b1s14[23]
    - /Purkinje/segments/b1s14[31]
    - /Purkinje/segments/b1s14[33]
    - /Purkinje/segments/b1s14[35]
    - /Purkinje/segments/b1s14[39]
    - /Purkinje/segments/b1s14[42]
    - /Purkinje/segments/b1s15[1]
    - /Purkinje/segments/b1s15[4]
    - /Purkinje/segments/b1s15[6]
    - /Purkinje/segments/b1s15[7]
    - /Purkinje/segments/b1s16[2]
    - /Purkinje/segments/b1s17[1]
    - /Purkinje/segments/b1s18[0]
    - /Purkinje/segments/b1s19[2]
    - /Purkinje/segments/b1s19[12]
    - /Purkinje/segments/b1s19[14]
    - /Purkinje/segments/b1s19[16]
    - /Purkinje/segments/b1s19[20]
    - /Purkinje/segments/b1s19[22]
    - /Purkinje/segments/b1s19[24]
    - /Purkinje/segments/b1s19[29]
    - /Purkinje/segments/b1s19[37]
    - /Purkinje/segments/b1s19[39]
    - /Purkinje/segments/b1s19[42]
    - /Purkinje/segments/b1s20[6]
    - /Purkinje/segments/b1s20[9]
    - /Purkinje/segments/b1s20[10]
    - /Purkinje/segments/b1s20[12]
    - /Purkinje/segments/b1s20[14]
    - /Purkinje/segments/b1s20[18]
    - /Purkinje/segments/b1s20[20]
    - /Purkinje/segments/b1s20[21]
    - /Purkinje/segments/b2s21[4]
    - /Purkinje/segments/b2s21[5]
    - /Purkinje/segments/b2s21[9]
    - /Purkinje/segments/b2s21[15]
    - /Purkinje/segments/b2s21[17]
    - /Purkinje/segments/b2s21[20]
    - /Purkinje/segments/b2s21[22]
    - /Purkinje/segments/b2s21[24]
    - /Purkinje/segments/b2s22[4]
    - /Purkinje/segments/b2s22[7]
    - /Purkinje/segments/b2s22[8]
    - /Purkinje/segments/b2s22[11]
    - /Purkinje/segments/b2s22[12]
    - /Purkinje/segments/b2s23[4]
    - /Purkinje/segments/b2s23[8]
    - /Purkinje/segments/b2s23[13]
    - /Purkinje/segments/b2s23[15]
    - /Purkinje/segments/b2s23[16]
    - /Purkinje/segments/b2s23[20]
    - /Purkinje/segments/b2s23[25]
    - /Purkinje/segments/b2s23[27]
    - /Purkinje/segments/b2s24[4]
    - /Purkinje/segments/b2s24[6]
    - /Purkinje/segments/b2s25[4]
    - /Purkinje/segments/b2s25[8]
    - /Purkinje/segments/b2s25[10]
    - /Purkinje/segments/b2s25[14]
    - /Purkinje/segments/b2s25[16]
    - /Purkinje/segments/b2s25[18]
    - /Purkinje/segments/b2s25[22]
    - /Purkinje/segments/b2s25[25]
    - /Purkinje/segments/b2s25[27]
    - /Purkinje/segments/b2s25[28]
    - /Purkinje/segments/b2s25[31]
    - /Purkinje/segments/b2s25[33]
    - /Purkinje/segments/b2s25[34]
    - /Purkinje/segments/b2s26[3]
    - /Purkinje/segments/b2s26[6]
    - /Purkinje/segments/b2s26[10]
    - /Purkinje/segments/b2s26[11]
    - /Purkinje/segments/b2s26[15]
    - /Purkinje/segments/b2s26[19]
    - /Purkinje/segments/b2s26[20]
    - /Purkinje/segments/b2s26[23]
    - /Purkinje/segments/b2s26[24]
    - /Purkinje/segments/b2s26[27]
    - /Purkinje/segments/b2s26[29]
    - /Purkinje/segments/b2s26[30]
    - /Purkinje/segments/b2s26[33]
    - /Purkinje/segments/b2s26[34]
    - /Purkinje/segments/b2s26[35]
    - /Purkinje/segments/b2s27[4]
    - /Purkinje/segments/b2s27[6]
    - /Purkinje/segments/b2s27[7]
    - /Purkinje/segments/b2s27[10]
    - /Purkinje/segments/b2s27[14]
    - /Purkinje/segments/b2s27[16]
    - /Purkinje/segments/b2s27[22]
    - /Purkinje/segments/b2s27[24]
    - /Purkinje/segments/b2s27[26]
    - /Purkinje/segments/b2s27[33]
    - /Purkinje/segments/b2s27[34]
    - /Purkinje/segments/b2s27[39]
    - /Purkinje/segments/b2s27[41]
    - /Purkinje/segments/b2s27[45]
    - /Purkinje/segments/b2s27[47]
    - /Purkinje/segments/b2s28[4]
    - /Purkinje/segments/b2s28[7]
    - /Purkinje/segments/b2s28[14]
    - /Purkinje/segments/b2s28[15]
    - /Purkinje/segments/b2s28[17]
    - /Purkinje/segments/b2s28[20]
    - /Purkinje/segments/b2s29[5]
    - /Purkinje/segments/b2s29[9]
    - /Purkinje/segments/b2s29[13]
    - /Purkinje/segments/b2s29[17]
    - /Purkinje/segments/b2s29[18]
    - /Purkinje/segments/b2s29[20]
    - /Purkinje/segments/b2s29[24]
    - /Purkinje/segments/b2s29[28]
    - /Purkinje/segments/b2s29[29]
    - /Purkinje/segments/b2s29[33]
    - /Purkinje/segments/b2s29[34]
    - /Purkinje/segments/b2s29[38]
    - /Purkinje/segments/b2s29[41]
    - /Purkinje/segments/b2s30[6]
    - /Purkinje/segments/b2s30[7]
    - /Purkinje/segments/b2s30[9]
    - /Purkinje/segments/b2s30[13]
    - /Purkinje/segments/b2s30[15]
    - /Purkinje/segments/b2s30[18]
    - /Purkinje/segments/b2s30[21]
    - /Purkinje/segments/b2s30[22]
    - /Purkinje/segments/b2s30[23]
    - /Purkinje/segments/b2s31[2]
    - /Purkinje/segments/b2s31[3]
    - /Purkinje/segments/b2s32[1]
    - /Purkinje/segments/b2s33[3]
    - /Purkinje/segments/b2s33[6]
    - /Purkinje/segments/b2s34[5]
    - /Purkinje/segments/b2s34[8]
    - /Purkinje/segments/b2s34[9]
    - /Purkinje/segments/b3s35[3]
    - /Purkinje/segments/b3s35[10]
    - /Purkinje/segments/b3s35[13]
    - /Purkinje/segments/b3s35[17]
    - /Purkinje/segments/b3s35[20]
    - /Purkinje/segments/b3s36[4]
    - /Purkinje/segments/b3s36[8]
    - /Purkinje/segments/b3s36[9]
    - /Purkinje/segments/b3s37[5]
    - /Purkinje/segments/b3s37[10]
    - /Purkinje/segments/b3s37[11]
    - /Purkinje/segments/b3s37[13]
    - /Purkinje/segments/b3s37[14]
    - /Purkinje/segments/b3s37[16]
    - /Purkinje/segments/b3s37[17]
    - /Purkinje/segments/b3s37[23]
    - /Purkinje/segments/b3s37[25]
    - /Purkinje/segments/b3s37[28]
    - /Purkinje/segments/b3s37[32]
    - /Purkinje/segments/b3s37[33]
    - /Purkinje/segments/b3s37[35]
    - /Purkinje/segments/b3s37[39]
    - /Purkinje/segments/b3s37[41]
    - /Purkinje/segments/b3s38[4]
    - /Purkinje/segments/b3s39[5]
    - /Purkinje/segments/b3s39[10]
    - /Purkinje/segments/b3s39[13]
    - /Purkinje/segments/b3s40[3]
    - /Purkinje/segments/b3s40[6]
    - /Purkinje/segments/b3s40[7]
    - /Purkinje/segments/b3s41[3]
    - /Purkinje/segments/b3s41[7]
    - /Purkinje/segments/b3s41[8]
    - /Purkinje/segments/b3s41[9]
    - /Purkinje/segments/b3s42[3]
    - /Purkinje/segments/b3s43[3]
    - /Purkinje/segments/b3s43[4]
    - /Purkinje/segments/b3s43[5]
    - /Purkinje/segments/b3s44[4]
    - /Purkinje/segments/b3s44[8]
    - /Purkinje/segments/b3s44[9]
    - /Purkinje/segments/b3s44[13]
    - /Purkinje/segments/b3s44[15]
    - /Purkinje/segments/b3s44[20]
    - /Purkinje/segments/b3s44[23]
    - /Purkinje/segments/b3s44[25]
    - /Purkinje/segments/b3s44[29]
    - /Purkinje/segments/b3s44[35]
    - /Purkinje/segments/b3s44[36]
    - /Purkinje/segments/b3s44[37]
    - /Purkinje/segments/b3s44[42]
    - /Purkinje/segments/b3s44[48]
    - /Purkinje/segments/b3s44[49]
    - /Purkinje/segments/b3s45[3]
    - /Purkinje/segments/b3s45[9]
    - /Purkinje/segments/b3s45[11]
    - /Purkinje/segments/b3s45[18]
    - /Purkinje/segments/b3s45[19]
    - /Purkinje/segments/b3s45[23]
    - /Purkinje/segments/b3s45[28]
    - /Purkinje/segments/b3s45[31]
    - /Purkinje/segments/b3s45[32]
    - /Purkinje/segments/b3s45[35]
    - /Purkinje/segments/b3s45[39]
    - /Purkinje/segments/b3s45[40]
    - /Purkinje/segments/b3s45[41]
    - /Purkinje/segments/b3s46[4]
    - /Purkinje/segments/b3s46[6]
    - /Purkinje/segments/b3s46[12]
    - /Purkinje/segments/b3s46[15]
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology without spines, after modifying the dendritic tree",
				disabled => (`cat $::config->{core_directory}/neurospaces/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'neurospaces was not configured to include the delete operation'),
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  (
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "Can we set the segmentation base ?",
						    read => 'neurospaces ',
						    write => 'segmentersetbase /Purkinje',
						   },
						  ),
						  (
						   {
						    description => "Can we get information on the dendritic branchpoints (soma) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/soma BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (soma) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/soma SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[0]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[0] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[0]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[0] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[1]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[1] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[1]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[1] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[2]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[2] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[2]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[2] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[3]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[3] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[3]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[3] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[4]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[4] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[4]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[4] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[5]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[5] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[5]) ?",
						    read => 'value = 3
',
						    write => "printparameter /Purkinje/segments/main[5] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[6]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[6] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[6]) ?",
						    read => 'value = 4
',
						    write => "printparameter /Purkinje/segments/main[6] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[7]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[7] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[7]) ?",
						    read => 'value = 4
',
						    write => "printparameter /Purkinje/segments/main[7] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[8]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[8] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[8]) ?",
						    read => 'value = 5
',
						    write => "printparameter /Purkinje/segments/main[8] SOMATOPETAL_BRANCHPOINTS",
						   },
						  ),
						  (
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s01[6]) ?",
						    read => 'value = 5
',
						    write => "printparameter /Purkinje/segments/b0s01[6] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s02[172]) ?",
						    read => 'value = 13
',
						    write => "printparameter /Purkinje/segments/b0s02[172] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s04[102]) ?",
						    read => 'value = 17
',
						    write => "printparameter /Purkinje/segments/b0s04[102] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b1s06[144]) ?",
						    read => 'value = 15
',
						    write => "printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b1s10[84]) ?",
						    read => 'value = 19
',
						    write => "printparameter /Purkinje/segments/b1s10[84] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b2s21[17]) ?",
						    read => 'value = 11
',
						    write => "printparameter /Purkinje/segments/b2s21[17] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b2s27[47]) ?",
						    read => 'value = 16
',
						    write => "printparameter /Purkinje/segments/b2s27[47] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b3s39[5]) ?",
						    read => 'value = 18
',
						    write => "printparameter /Purkinje/segments/b3s39[5] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b3s46[15]) ?",
						    read => 'value = 24
',
						    write => "printparameter /Purkinje/segments/b3s46[15] SOMATOPETAL_BRANCHPOINTS",
						   },
						  ),
# 						  (
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s01[6]) ?",
# 						    read => 'value = 6
# ',
# 						    write => "printparameter /Purkinje/segments/b0s01[6] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s02[172]) ?",
# 						    read => 'value = 25
# ',
# 						    write => "printparameter /Purkinje/segments/b0s02[172] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s04[102]) ?",
# 						    read => 'value = 23
# ',
# 						    write => "printparameter /Purkinje/segments/b0s04[102] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b1s06[144]) ?",
# 						    read => 'value = 18
# ',
# 						    write => "printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b1s10[84]) ?",
# 						    read => 'value = 21
# ',
# 						    write => "printparameter /Purkinje/segments/b1s10[84] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b2s21[17]) ?",
# 						    read => 'value = 14
# ',
# 						    write => "printparameter /Purkinje/segments/b2s21[17] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b2s27[47]) ?",
# 						    read => 'value = 17
# ',
# 						    write => "printparameter /Purkinje/segments/b2s27[47] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b3s39[5]) ?",
# 						    read => 'value = 20
# ',
# 						    write => "printparameter /Purkinje/segments/b3s39[5] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b3s46[15]) ?",
# 						    read => 'value = 26
# ',
# 						    write => "printparameter /Purkinje/segments/b3s46[15] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						  ),
						 ],
				description => "examination of branchpoints of the purkinje cell without spines",
				side_effects => 'segmentersetbase',
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  (
						   {
						    description => "Is neurospaces startup successful ?",
						    read => 'neurospaces ',
						    write => undef,
						   },
						   {
						    description => "Can we set the segmentation base ?",
						    read => 'neurospaces ',
						    write => 'segmentersetbase /Purkinje',
						   },
						  ),
						  (
						   {
						    description => "Can we get information on the dendritic branchpoints (soma) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/soma BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (soma) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/soma SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[0]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[0] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[0]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[0] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[1]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[1] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[1]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[1] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[2]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[2] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[2]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[2] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[3]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[3] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[3]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[3] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[4]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[4] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[4]) ?",
						    read => 'value = 2
',
						    write => "printparameter /Purkinje/segments/main[4] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[5]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[5] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[5]) ?",
						    read => 'value = 3
',
						    write => "printparameter /Purkinje/segments/main[5] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[6]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[6] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[6]) ?",
						    read => 'value = 4
',
						    write => "printparameter /Purkinje/segments/main[6] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[7]) ?",
						    read => 'value = 0
',
						    write => "printparameter /Purkinje/segments/main[7] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[7]) ?",
						    read => 'value = 4
',
						    write => "printparameter /Purkinje/segments/main[7] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the dendritic branchpoints (main[8]) ?",
						    read => 'value = 1
',
						    write => "printparameter /Purkinje/segments/main[8] BRANCHPOINT",
						   },
						   {
						    description => "Can we get information on the branch order (main[8]) ?",
						    read => 'value = 5
',
						    write => "printparameter /Purkinje/segments/main[8] SOMATOPETAL_BRANCHPOINTS",
						   },
						  ),
						  (
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s01[6]) ?",
						    read => 'value = 5
',
						    write => "printparameter /Purkinje/segments/b0s01[6] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s02[172]) ?",
						    read => 'value = 13
',
						    write => "printparameter /Purkinje/segments/b0s02[172] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b0s04[102]) ?",
						    read => 'value = 17
',
						    write => "printparameter /Purkinje/segments/b0s04[102] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b1s06[144]) ?",
						    read => 'value = 15
',
						    write => "printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b1s10[84]) ?",
						    read => 'value = 19
',
						    write => "printparameter /Purkinje/segments/b1s10[84] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b2s21[17]) ?",
						    read => 'value = 11
',
						    write => "printparameter /Purkinje/segments/b2s21[17] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b2s27[47]) ?",
						    read => 'value = 16
',
						    write => "printparameter /Purkinje/segments/b2s27[47] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b3s39[5]) ?",
						    read => 'value = 18
',
						    write => "printparameter /Purkinje/segments/b3s39[5] SOMATOPETAL_BRANCHPOINTS",
						   },
						   {
						    description => "Can we get information on the branch order of dendritic terminals (b3s46[15]) ?",
						    read => 'value = 24
',
						    write => "printparameter /Purkinje/segments/b3s46[15] SOMATOPETAL_BRANCHPOINTS",
						   },
						  ),
# 						  (
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s01[6]) ?",
# 						    read => 'value = 6
# ',
# 						    write => "printparameter /Purkinje/segments/b0s01[6] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s02[172]) ?",
# 						    read => 'value = 25
# ',
# 						    write => "printparameter /Purkinje/segments/b0s02[172] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b0s04[102]) ?",
# 						    read => 'value = 23
# ',
# 						    write => "printparameter /Purkinje/segments/b0s04[102] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b1s06[144]) ?",
# 						    read => 'value = 18
# ',
# 						    write => "printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b1s10[84]) ?",
# 						    read => 'value = 21
# ',
# 						    write => "printparameter /Purkinje/segments/b1s10[84] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b2s21[17]) ?",
# 						    read => 'value = 14
# ',
# 						    write => "printparameter /Purkinje/segments/b2s21[17] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b2s27[47]) ?",
# 						    read => 'value = 17
# ',
# 						    write => "printparameter /Purkinje/segments/b2s27[47] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b3s39[5]) ?",
# 						    read => 'value = 20
# ',
# 						    write => "printparameter /Purkinje/segments/b3s39[5] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						   {
# 						    description => "Can we get information on the branch order of dendritic terminals (b3s46[15]) ?",
# 						    read => 'value = 26
# ',
# 						    write => "printparameter /Purkinje/segments/b3s46[15] SOMATOPETAL_BRANCHPOINTS",
# 						   },
# 						  ),
						 ],
				description => "examination of branchpoints of the purkinje cell without spines",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				side_effects => 'segmentersetbase',
			       },
			      ],
       description => "segment linearization, morphology branchpoints, indexing and structure analysis",
       name => 'segmenters.t',
       side_effects => 'segment linearization and morphology branchpoints',
      };


return $test;


