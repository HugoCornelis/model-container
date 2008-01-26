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
						   read => 'Number of segments linearized: 33548
Number of segments without parents: 6266
Number of segment tips: 15104
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a heterogeneous population ?",
						   read => 'Number of segments linearized: 27288
Number of segments without parents: 6
Number of segment tips: 8844
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we linearize segments of a homogeneous population ?",
						   read => 'Number of segments linearized: 6240
Number of segments without parents: 6240
Number of segment tips: 6240
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a big neuron ?",
						   read => 'Number of segments linearized: 4548
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
						   read => 'Number of segments linearized: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "Can we linearize segments of a one segment neuron ?",
						   read => 'Number of segments linearized: 1
Number of segments without parents: 1
Number of segment tips: 1
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules/0",
						  },
						  {
						   description => "Can we linearize segments of a network (2) ?",
						   read => 'Number of segments linearized: 33548
Number of segments without parents: 6266
Number of segment tips: 15104
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a heterogeneous population (2) ?",
						   read => 'Number of segments linearized: 27288
Number of segments without parents: 6
Number of segment tips: 8844
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we linearize segments of a homogeneous population (2) ?",
						   read => 'Number of segments linearized: 6240
Number of segments without parents: 6240
Number of segment tips: 6240
',
						   timeout => 25,
						   write => "segmenterlinearize /CerebellarCortex/Granules",
						  },
						  {
						   comment => 'note that the number of tips is the number of spine heads (nothing more, nothing less)',
						   description => "Can we linearize segments of a big neuron (2) ?",
						   read => 'Number of segments linearized: 4548
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
						   read => 'Number of segments linearized: 4548
Number of segments without parents: 1
Number of segment tips: 1474
',
						   write => "segmenterlinearize /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "Can we linearize segments of a one segment neuron (2) ?",
						   timeout => 25,
						   read => 'Number of segments linearized: 1
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
  serials:
    - 1177
    - 1197
    - 1217
    - 1247
    - 1277
    - 1307
    - 1337
    - 1387
    - 1417
    - 1447
    - 1497
    - 1557
    - 1643
    - 1673
    - 1713
    - 1753
    - 1823
    - 1843
    - 1863
    - 1963
    - 2013
    - 2043
    - 2053
    - 2083
    - 2113
    - 2133
    - 2143
    - 2203
    - 2213
    - 2293
    - 2313
    - 2333
    - 2353
    - 2373
    - 2383
    - 2413
    - 2453
    - 2533
    - 2543
    - 2573
    - 2593
    - 2623
    - 2653
    - 2673
    - 2713
    - 2733
    - 2743
    - 2843
    - 2893
    - 2913
    - 2933
    - 3013
    - 3043
    - 3053
    - 3093
    - 3123
    - 3153
    - 3163
    - 3213
    - 3233
    - 3273
    - 3293
    - 3343
    - 3393
    - 3403
    - 3423
    - 3481
    - 3511
    - 3601
    - 3631
    - 3671
    - 3711
    - 3731
    - 3751
    - 3771
    - 3791
    - 3811
    - 3821
    - 3871
    - 3931
    - 3941
    - 3961
    - 3981
    - 4051
    - 4071
    - 4081
    - 4091
    - 4121
    - 4141
    - 4207
    - 4217
    - 4247
    - 4267
    - 4277
    - 4317
    - 4347
    - 4357
    - 4397
    - 4437
    - 4447
    - 4537
    - 4557
    - 4577
    - 4657
    - 4677
    - 4697
    - 4707
    - 4717
    - 4727
    - 4757
    - 4777
    - 4797
    - 4837
    - 4857
    - 4887
    - 4917
    - 4927
    - 4967
    - 4977
    - 5037
    - 5137
    - 5147
    - 5177
    - 5227
    - 5237
    - 5277
    - 5307
    - 5337
    - 5347
    - 5387
    - 5397
    - 5497
    - 5517
    - 5547
    - 5577
    - 5597
    - 5637
    - 5697
    - 5707
    - 5753
    - 5773
    - 5783
    - 5891
    - 5951
    - 5971
    - 6051
    - 6061
    - 6111
    - 6141
    - 6161
    - 6181
    - 6191
    - 6221
    - 6241
    - 6281
    - 6291
    - 6331
    - 6351
    - 6441
    - 6511
    - 6521
    - 6551
    - 6601
    - 6621
    - 6631
    - 6661
    - 6721
    - 6761
    - 6791
    - 6821
    - 6851
    - 6861
    - 6871
    - 6931
    - 6961
    - 6981
    - 7011
    - 7021
    - 7091
    - 7141
    - 7151
    - 7171
    - 7221
    - 7251
    - 7261
    - 7341
    - 7401
    - 7431
    - 7451
    - 7481
    - 7551
    - 7561
    - 7591
    - 7611
    - 7631
    - 7691
    - 7747
    - 7817
    - 7827
    - 7847
    - 7857
    - 7897
    - 7907
    - 7917
    - 7947
    - 8003
    - 8023
    - 8043
    - 8053
    - 8143
    - 8193
    - 8203
    - 8233
    - 8243
    - 8263
    - 8293
    - 8323
    - 8353
    - 8435
    - 8465
    - 8505
    - 8525
    - 8545
    - 8565
    - 8575
    - 8595
    - 8645
    - 8655
    - 8735
    - 8795
    - 8805
    - 8825
    - 8855
    - 8905
    - 8935
    - 8975
    - 8995
    - 9015
    - 9035
    - 9075
    - 9085
    - 9145
    - 9185
    - 9195
    - 9215
    - 9225
    - 9271
    - 9311
    - 9341
    - 9387
    - 9467
    - 9477
    - 9517
    - 9627
    - 9647
    - 9667
    - 9687
    - 9717
    - 9737
    - 9777
    - 9807
    - 9847
    - 9877
    - 9887
    - 9933
    - 9983
    - 10119
    - 10149
    - 10159
    - 10229
    - 10309
    - 10329
    - 10349
    - 10389
    - 10419
    - 10439
    - 10469
    - 10489
    - 10499
    - 10535
    - 10555
    - 10565
    - 10595
    - 10695
    - 10715
    - 10735
    - 10775
    - 10795
    - 10815
    - 10865
    - 10945
    - 10965
    - 10995
    - 11065
    - 11095
    - 11105
    - 11125
    - 11145
    - 11185
    - 11205
    - 11215
    - 11271
    - 11281
    - 11321
    - 11381
    - 11401
    - 11431
    - 11451
    - 11471
    - 11527
    - 11557
    - 11567
    - 11597
    - 11607
    - 11663
    - 11703
    - 11753
    - 11773
    - 11783
    - 11823
    - 11873
    - 11893
    - 11949
    - 11969
    - 12031
    - 12071
    - 12091
    - 12131
    - 12151
    - 12171
    - 12211
    - 12241
    - 12261
    - 12271
    - 12301
    - 12321
    - 12331
    - 12377
    - 12407
    - 12447
    - 12457
    - 12497
    - 12537
    - 12547
    - 12577
    - 12587
    - 12617
    - 12637
    - 12647
    - 12677
    - 12687
    - 12697
    - 12753
    - 12773
    - 12783
    - 12813
    - 12853
    - 12873
    - 12933
    - 12953
    - 12973
    - 13043
    - 13053
    - 13103
    - 13123
    - 13163
    - 13183
    - 13239
    - 13269
    - 13339
    - 13349
    - 13369
    - 13399
    - 13465
    - 13505
    - 13545
    - 13585
    - 13595
    - 13615
    - 13655
    - 13695
    - 13705
    - 13745
    - 13755
    - 13795
    - 13825
    - 13901
    - 13911
    - 13931
    - 13971
    - 13991
    - 14021
    - 14051
    - 14061
    - 14071
    - 14107
    - 14117
    - 14137
    - 14183
    - 14213
    - 14273
    - 14303
    - 14313
    - 14359
    - 14429
    - 14459
    - 14499
    - 14529
    - 14585
    - 14625
    - 14635
    - 14707
    - 14757
    - 14767
    - 14787
    - 14797
    - 14817
    - 14827
    - 14887
    - 14907
    - 14937
    - 14977
    - 14987
    - 15007
    - 15047
    - 15067
    - 15123
    - 15189
    - 15239
    - 15269
    - 15315
    - 15345
    - 15355
    - 15401
    - 15441
    - 15451
    - 15461
    - 15507
    - 15547
    - 15557
    - 15567
    - 15629
    - 15669
    - 15679
    - 15719
    - 15739
    - 15789
    - 15819
    - 15839
    - 15879
    - 15939
    - 15949
    - 15959
    - 16009
    - 16069
    - 16079
    - 16125
    - 16185
    - 16205
    - 16275
    - 16285
    - 16325
    - 16375
    - 16405
    - 16415
    - 16445
    - 16485
    - 16495
    - 16505
    - 16561
    - 16581
    - 16641
    - 16671
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
  serials:
    - 1163
    - 1183
    - 1203
    - 1233
    - 1263
    - 1293
    - 1323
    - 1373
    - 1403
    - 1433
    - 1483
    - 1543
    - 1629
    - 1659
    - 1699
    - 1739
    - 1809
    - 1829
    - 1849
    - 1949
    - 1999
    - 2029
    - 2039
    - 2069
    - 2099
    - 2119
    - 2129
    - 2189
    - 2199
    - 2279
    - 2299
    - 2319
    - 2339
    - 2359
    - 2369
    - 2399
    - 2439
    - 2519
    - 2529
    - 2559
    - 2579
    - 2609
    - 2639
    - 2659
    - 2699
    - 2719
    - 2729
    - 2829
    - 2879
    - 2899
    - 2919
    - 2999
    - 3029
    - 3039
    - 3079
    - 3109
    - 3139
    - 3149
    - 3199
    - 3219
    - 3259
    - 3279
    - 3329
    - 3379
    - 3389
    - 3409
    - 3467
    - 3497
    - 3587
    - 3617
    - 3657
    - 3697
    - 3717
    - 3737
    - 3757
    - 3777
    - 3797
    - 3807
    - 3857
    - 3917
    - 3927
    - 3947
    - 3967
    - 4037
    - 4057
    - 4067
    - 4077
    - 4107
    - 4127
    - 4193
    - 4203
    - 4233
    - 4253
    - 4263
    - 4303
    - 4333
    - 4343
    - 4383
    - 4423
    - 4433
    - 4523
    - 4543
    - 4563
    - 4643
    - 4663
    - 4683
    - 4693
    - 4703
    - 4713
    - 4743
    - 4763
    - 4783
    - 4823
    - 4843
    - 4873
    - 4903
    - 4913
    - 4953
    - 4963
    - 5023
    - 5123
    - 5133
    - 5163
    - 5213
    - 5223
    - 5263
    - 5293
    - 5323
    - 5333
    - 5373
    - 5383
    - 5483
    - 5503
    - 5533
    - 5563
    - 5583
    - 5623
    - 5683
    - 5693
    - 5739
    - 5759
    - 5769
    - 5877
    - 5937
    - 5957
    - 6037
    - 6047
    - 6097
    - 6127
    - 6147
    - 6167
    - 6177
    - 6207
    - 6227
    - 6267
    - 6277
    - 6317
    - 6337
    - 6427
    - 6497
    - 6507
    - 6537
    - 6587
    - 6607
    - 6617
    - 6647
    - 6707
    - 6747
    - 6777
    - 6807
    - 6837
    - 6847
    - 6857
    - 6917
    - 6947
    - 6967
    - 6997
    - 7007
    - 7077
    - 7127
    - 7137
    - 7157
    - 7207
    - 7237
    - 7247
    - 7327
    - 7387
    - 7417
    - 7437
    - 7467
    - 7537
    - 7547
    - 7577
    - 7597
    - 7617
    - 7677
    - 7733
    - 7803
    - 7813
    - 7833
    - 7843
    - 7883
    - 7893
    - 7903
    - 7933
    - 7989
    - 8009
    - 8029
    - 8039
    - 8129
    - 8179
    - 8189
    - 8219
    - 8229
    - 8249
    - 8279
    - 8309
    - 8339
    - 8421
    - 8451
    - 8491
    - 8511
    - 8531
    - 8551
    - 8561
    - 8581
    - 8631
    - 8641
    - 8721
    - 8781
    - 8791
    - 8811
    - 8841
    - 8891
    - 8921
    - 8961
    - 8981
    - 9001
    - 9021
    - 9061
    - 9071
    - 9131
    - 9171
    - 9181
    - 9201
    - 9211
    - 9257
    - 9297
    - 9327
    - 9373
    - 9453
    - 9463
    - 9503
    - 9613
    - 9633
    - 9653
    - 9673
    - 9703
    - 9723
    - 9763
    - 9793
    - 9833
    - 9863
    - 9873
    - 9919
    - 9969
    - 10105
    - 10135
    - 10145
    - 10215
    - 10295
    - 10315
    - 10335
    - 10375
    - 10405
    - 10425
    - 10455
    - 10475
    - 10485
    - 10521
    - 10541
    - 10551
    - 10581
    - 10681
    - 10701
    - 10721
    - 10761
    - 10781
    - 10801
    - 10851
    - 10931
    - 10951
    - 10981
    - 11051
    - 11081
    - 11091
    - 11111
    - 11131
    - 11171
    - 11191
    - 11201
    - 11257
    - 11267
    - 11307
    - 11367
    - 11387
    - 11417
    - 11437
    - 11457
    - 11513
    - 11543
    - 11553
    - 11583
    - 11593
    - 11649
    - 11689
    - 11739
    - 11759
    - 11769
    - 11809
    - 11859
    - 11879
    - 11935
    - 11955
    - 12017
    - 12057
    - 12077
    - 12117
    - 12137
    - 12157
    - 12197
    - 12227
    - 12247
    - 12257
    - 12287
    - 12307
    - 12317
    - 12363
    - 12393
    - 12433
    - 12443
    - 12483
    - 12523
    - 12533
    - 12563
    - 12573
    - 12603
    - 12623
    - 12633
    - 12663
    - 12673
    - 12683
    - 12739
    - 12759
    - 12769
    - 12799
    - 12839
    - 12859
    - 12919
    - 12939
    - 12959
    - 13029
    - 13039
    - 13089
    - 13109
    - 13149
    - 13169
    - 13225
    - 13255
    - 13325
    - 13335
    - 13355
    - 13385
    - 13451
    - 13491
    - 13531
    - 13571
    - 13581
    - 13601
    - 13641
    - 13681
    - 13691
    - 13731
    - 13741
    - 13781
    - 13811
    - 13887
    - 13897
    - 13917
    - 13957
    - 13977
    - 14007
    - 14037
    - 14047
    - 14057
    - 14093
    - 14103
    - 14123
    - 14169
    - 14199
    - 14259
    - 14289
    - 14299
    - 14345
    - 14415
    - 14445
    - 14485
    - 14515
    - 14571
    - 14611
    - 14621
    - 14693
    - 14743
    - 14753
    - 14773
    - 14783
    - 14803
    - 14813
    - 14873
    - 14893
    - 14923
    - 14963
    - 14973
    - 14993
    - 15033
    - 15053
    - 15109
    - 15175
    - 15225
    - 15255
    - 15301
    - 15331
    - 15341
    - 15387
    - 15427
    - 15437
    - 15447
    - 15493
    - 15533
    - 15543
    - 15553
    - 15615
    - 15655
    - 15665
    - 15705
    - 15725
    - 15775
    - 15805
    - 15825
    - 15865
    - 15925
    - 15935
    - 15945
    - 15995
    - 16055
    - 16065
    - 16111
    - 16171
    - 16191
    - 16261
    - 16271
    - 16311
    - 16361
    - 16391
    - 16401
    - 16431
    - 16471
    - 16481
    - 16491
    - 16547
    - 16567
    - 16627
    - 16657
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology without spines, after modifying the dendritic tree",
				disabled => (`cat $::config->{core_directory}/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'neurospaces was not configured to include the delete operation'),
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-A',
					      '-R',
					      'tests/cells/purkinje/edsjb1994.ndf',
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
  serials:
    - 3174
    - 3244
    - 3314
    - 3419
    - 3524
    - 3629
    - 3734
    - 3909
    - 4014
    - 4119
    - 4294
    - 4504
    - 4790
    - 4895
    - 5035
    - 5175
    - 5420
    - 5490
    - 5560
    - 5910
    - 6085
    - 6190
    - 6225
    - 6330
    - 6435
    - 6505
    - 6540
    - 6750
    - 6785
    - 7065
    - 7135
    - 7205
    - 7275
    - 7345
    - 7380
    - 7485
    - 7625
    - 7905
    - 7940
    - 8045
    - 8115
    - 8220
    - 8325
    - 8395
    - 8535
    - 8605
    - 8640
    - 8990
    - 9165
    - 9235
    - 9305
    - 9585
    - 9690
    - 9725
    - 9865
    - 9970
    - 10075
    - 10110
    - 10285
    - 10355
    - 10495
    - 10565
    - 10740
    - 10915
    - 10950
    - 11020
    - 11178
    - 11283
    - 11598
    - 11703
    - 11843
    - 11983
    - 12053
    - 12123
    - 12193
    - 12263
    - 12333
    - 12368
    - 12543
    - 12753
    - 12788
    - 12858
    - 12928
    - 13173
    - 13243
    - 13278
    - 13313
    - 13418
    - 13488
    - 13704
    - 13739
    - 13844
    - 13914
    - 13949
    - 14089
    - 14194
    - 14229
    - 14369
    - 14509
    - 14544
    - 14859
    - 14929
    - 14999
    - 15279
    - 15349
    - 15419
    - 15454
    - 15489
    - 15524
    - 15629
    - 15699
    - 15769
    - 15909
    - 15979
    - 16084
    - 16189
    - 16224
    - 16364
    - 16399
    - 16609
    - 16959
    - 16994
    - 17099
    - 17274
    - 17309
    - 17449
    - 17554
    - 17659
    - 17694
    - 17834
    - 17869
    - 18219
    - 18289
    - 18394
    - 18499
    - 18569
    - 18709
    - 18919
    - 18954
    - 19100
    - 19170
    - 19205
    - 19538
    - 19748
    - 19818
    - 20098
    - 20133
    - 20308
    - 20413
    - 20483
    - 20553
    - 20588
    - 20693
    - 20763
    - 20903
    - 20938
    - 21078
    - 21148
    - 21463
    - 21708
    - 21743
    - 21848
    - 22023
    - 22093
    - 22128
    - 22233
    - 22443
    - 22583
    - 22688
    - 22793
    - 22898
    - 22933
    - 22968
    - 23178
    - 23283
    - 23353
    - 23458
    - 23493
    - 23738
    - 23913
    - 23948
    - 24018
    - 24193
    - 24298
    - 24333
    - 24613
    - 24823
    - 24928
    - 24998
    - 25103
    - 25348
    - 25383
    - 25488
    - 25558
    - 25628
    - 25838
    - 26019
    - 26264
    - 26299
    - 26369
    - 26404
    - 26544
    - 26579
    - 26614
    - 26719
    - 26900
    - 26970
    - 27040
    - 27075
    - 27390
    - 27565
    - 27600
    - 27705
    - 27740
    - 27810
    - 27915
    - 28020
    - 28125
    - 28382
    - 28487
    - 28627
    - 28697
    - 28767
    - 28837
    - 28872
    - 28942
    - 29117
    - 29152
    - 29432
    - 29642
    - 29677
    - 29747
    - 29852
    - 30027
    - 30132
    - 30272
    - 30342
    - 30412
    - 30482
    - 30622
    - 30657
    - 30867
    - 31007
    - 31042
    - 31112
    - 31147
    - 31293
    - 31433
    - 31538
    - 31684
    - 31964
    - 31999
    - 32139
    - 32524
    - 32594
    - 32664
    - 32734
    - 32839
    - 32909
    - 33049
    - 33154
    - 33294
    - 33399
    - 33434
    - 33580
    - 33755
    - 34216
    - 34321
    - 34356
    - 34601
    - 34881
    - 34951
    - 35021
    - 35161
    - 35266
    - 35336
    - 35441
    - 35511
    - 35546
    - 35657
    - 35727
    - 35762
    - 35867
    - 36217
    - 36287
    - 36357
    - 36497
    - 36567
    - 36637
    - 36812
    - 37092
    - 37162
    - 37267
    - 37512
    - 37617
    - 37652
    - 37722
    - 37792
    - 37932
    - 38002
    - 38037
    - 38218
    - 38253
    - 38393
    - 38603
    - 38673
    - 38778
    - 38848
    - 38918
    - 39099
    - 39204
    - 39239
    - 39344
    - 39379
    - 39560
    - 39700
    - 39875
    - 39945
    - 39980
    - 40120
    - 40295
    - 40365
    - 40546
    - 40616
    - 40803
    - 40943
    - 41013
    - 41153
    - 41223
    - 41293
    - 41433
    - 41538
    - 41608
    - 41643
    - 41748
    - 41818
    - 41853
    - 41999
    - 42104
    - 42244
    - 42279
    - 42419
    - 42559
    - 42594
    - 42699
    - 42734
    - 42839
    - 42909
    - 42944
    - 43049
    - 43084
    - 43119
    - 43300
    - 43370
    - 43405
    - 43510
    - 43650
    - 43720
    - 43930
    - 44000
    - 44070
    - 44315
    - 44350
    - 44525
    - 44595
    - 44735
    - 44805
    - 44986
    - 45091
    - 45336
    - 45371
    - 45441
    - 45546
    - 45762
    - 45902
    - 46042
    - 46182
    - 46217
    - 46287
    - 46427
    - 46567
    - 46602
    - 46742
    - 46777
    - 46917
    - 47022
    - 47273
    - 47308
    - 47378
    - 47518
    - 47588
    - 47693
    - 47798
    - 47833
    - 47868
    - 47979
    - 48014
    - 48084
    - 48230
    - 48335
    - 48545
    - 48650
    - 48685
    - 48831
    - 49076
    - 49181
    - 49321
    - 49426
    - 49607
    - 49747
    - 49782
    - 50004
    - 50179
    - 50214
    - 50284
    - 50319
    - 50389
    - 50424
    - 50634
    - 50704
    - 50809
    - 50949
    - 50984
    - 51054
    - 51194
    - 51264
    - 51445
    - 51661
    - 51836
    - 51941
    - 52087
    - 52192
    - 52227
    - 52373
    - 52513
    - 52548
    - 52583
    - 52729
    - 52869
    - 52904
    - 52939
    - 53126
    - 53266
    - 53301
    - 53441
    - 53511
    - 53686
    - 53791
    - 53861
    - 54001
    - 54211
    - 54246
    - 54281
    - 54456
    - 54666
    - 54701
    - 54847
    - 55057
    - 55127
    - 55372
    - 55407
    - 55547
    - 55722
    - 55827
    - 55862
    - 55967
    - 56107
    - 56142
    - 56177
    - 56358
    - 56428
    - 56638
    - 56743
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				side_effects => 'segment linearization',
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'tests/cells/purkinje/edsjb1994.ndf',
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
  serials:
    - 3128
    - 3198
    - 3268
    - 3373
    - 3478
    - 3583
    - 3688
    - 3863
    - 3968
    - 4073
    - 4248
    - 4458
    - 4744
    - 4849
    - 4989
    - 5129
    - 5374
    - 5444
    - 5514
    - 5864
    - 6039
    - 6144
    - 6179
    - 6284
    - 6389
    - 6459
    - 6494
    - 6704
    - 6739
    - 7019
    - 7089
    - 7159
    - 7229
    - 7299
    - 7334
    - 7439
    - 7579
    - 7859
    - 7894
    - 7999
    - 8069
    - 8174
    - 8279
    - 8349
    - 8489
    - 8559
    - 8594
    - 8944
    - 9119
    - 9189
    - 9259
    - 9539
    - 9644
    - 9679
    - 9819
    - 9924
    - 10029
    - 10064
    - 10239
    - 10309
    - 10449
    - 10519
    - 10694
    - 10869
    - 10904
    - 10974
    - 11132
    - 11237
    - 11552
    - 11657
    - 11797
    - 11937
    - 12007
    - 12077
    - 12147
    - 12217
    - 12287
    - 12322
    - 12497
    - 12707
    - 12742
    - 12812
    - 12882
    - 13127
    - 13197
    - 13232
    - 13267
    - 13372
    - 13442
    - 13658
    - 13693
    - 13798
    - 13868
    - 13903
    - 14043
    - 14148
    - 14183
    - 14323
    - 14463
    - 14498
    - 14813
    - 14883
    - 14953
    - 15233
    - 15303
    - 15373
    - 15408
    - 15443
    - 15478
    - 15583
    - 15653
    - 15723
    - 15863
    - 15933
    - 16038
    - 16143
    - 16178
    - 16318
    - 16353
    - 16563
    - 16913
    - 16948
    - 17053
    - 17228
    - 17263
    - 17403
    - 17508
    - 17613
    - 17648
    - 17788
    - 17823
    - 18173
    - 18243
    - 18348
    - 18453
    - 18523
    - 18663
    - 18873
    - 18908
    - 19054
    - 19124
    - 19159
    - 19492
    - 19702
    - 19772
    - 20052
    - 20087
    - 20262
    - 20367
    - 20437
    - 20507
    - 20542
    - 20647
    - 20717
    - 20857
    - 20892
    - 21032
    - 21102
    - 21417
    - 21662
    - 21697
    - 21802
    - 21977
    - 22047
    - 22082
    - 22187
    - 22397
    - 22537
    - 22642
    - 22747
    - 22852
    - 22887
    - 22922
    - 23132
    - 23237
    - 23307
    - 23412
    - 23447
    - 23692
    - 23867
    - 23902
    - 23972
    - 24147
    - 24252
    - 24287
    - 24567
    - 24777
    - 24882
    - 24952
    - 25057
    - 25302
    - 25337
    - 25442
    - 25512
    - 25582
    - 25792
    - 25973
    - 26218
    - 26253
    - 26323
    - 26358
    - 26498
    - 26533
    - 26568
    - 26673
    - 26854
    - 26924
    - 26994
    - 27029
    - 27344
    - 27519
    - 27554
    - 27659
    - 27694
    - 27764
    - 27869
    - 27974
    - 28079
    - 28336
    - 28441
    - 28581
    - 28651
    - 28721
    - 28791
    - 28826
    - 28896
    - 29071
    - 29106
    - 29386
    - 29596
    - 29631
    - 29701
    - 29806
    - 29981
    - 30086
    - 30226
    - 30296
    - 30366
    - 30436
    - 30576
    - 30611
    - 30821
    - 30961
    - 30996
    - 31066
    - 31101
    - 31247
    - 31387
    - 31492
    - 31638
    - 31918
    - 31953
    - 32093
    - 32478
    - 32548
    - 32618
    - 32688
    - 32793
    - 32863
    - 33003
    - 33108
    - 33248
    - 33353
    - 33388
    - 33534
    - 33709
    - 34170
    - 34275
    - 34310
    - 34555
    - 34835
    - 34905
    - 34975
    - 35115
    - 35220
    - 35290
    - 35395
    - 35465
    - 35500
    - 35611
    - 35681
    - 35716
    - 35821
    - 36171
    - 36241
    - 36311
    - 36451
    - 36521
    - 36591
    - 36766
    - 37046
    - 37116
    - 37221
    - 37466
    - 37571
    - 37606
    - 37676
    - 37746
    - 37886
    - 37956
    - 37991
    - 38172
    - 38207
    - 38347
    - 38557
    - 38627
    - 38732
    - 38802
    - 38872
    - 39053
    - 39158
    - 39193
    - 39298
    - 39333
    - 39514
    - 39654
    - 39829
    - 39899
    - 39934
    - 40074
    - 40249
    - 40319
    - 40500
    - 40570
    - 40757
    - 40897
    - 40967
    - 41107
    - 41177
    - 41247
    - 41387
    - 41492
    - 41562
    - 41597
    - 41702
    - 41772
    - 41807
    - 41953
    - 42058
    - 42198
    - 42233
    - 42373
    - 42513
    - 42548
    - 42653
    - 42688
    - 42793
    - 42863
    - 42898
    - 43003
    - 43038
    - 43073
    - 43254
    - 43324
    - 43359
    - 43464
    - 43604
    - 43674
    - 43884
    - 43954
    - 44024
    - 44269
    - 44304
    - 44479
    - 44549
    - 44689
    - 44759
    - 44940
    - 45045
    - 45290
    - 45325
    - 45395
    - 45500
    - 45716
    - 45856
    - 45996
    - 46136
    - 46171
    - 46241
    - 46381
    - 46521
    - 46556
    - 46696
    - 46731
    - 46871
    - 46976
    - 47227
    - 47262
    - 47332
    - 47472
    - 47542
    - 47647
    - 47752
    - 47787
    - 47822
    - 47933
    - 47968
    - 48038
    - 48184
    - 48289
    - 48499
    - 48604
    - 48639
    - 48785
    - 49030
    - 49135
    - 49275
    - 49380
    - 49561
    - 49701
    - 49736
    - 49958
    - 50133
    - 50168
    - 50238
    - 50273
    - 50343
    - 50378
    - 50588
    - 50658
    - 50763
    - 50903
    - 50938
    - 51008
    - 51148
    - 51218
    - 51399
    - 51615
    - 51790
    - 51895
    - 52041
    - 52146
    - 52181
    - 52327
    - 52467
    - 52502
    - 52537
    - 52683
    - 52823
    - 52858
    - 52893
    - 53080
    - 53220
    - 53255
    - 53395
    - 53465
    - 53640
    - 53745
    - 53815
    - 53955
    - 54165
    - 54200
    - 54235
    - 54410
    - 54620
    - 54655
    - 54801
    - 55011
    - 55081
    - 55326
    - 55361
    - 55501
    - 55676
    - 55781
    - 55816
    - 55921
    - 56061
    - 56096
    - 56131
    - 56312
    - 56382
    - 56592
    - 56697
',
						   timeout => 25,
						   write => "segmentertips /Purkinje",
						  },
						 ],
				description => "examination of the purkinje cell morphology without spines, after modifying the dendritic tree",
				disabled => ((!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : "")
					     || (`cat $::config->{core_directory}/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'neurospaces was not configured to include the delete operation')),
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
					      'tests/cells/purkinje/edsjb1994.ndf',
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
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				side_effects => 'segmentersetbase',
			       },
			      ],
       description => "segment linearization, morphology branchpoints, indexing and structure analysis",
       name => 'segmenters.t',
       side_effects => 'segment linearization and morphology branchpoints',
      };


return $test;


