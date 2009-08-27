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
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networksmall.ndf.', ],
						   timeout => 10,
						   write => undef,
						  },
						  {
						   description => "small network, single partition",
						   read => "total workload : 564
 # partitions  : 1
work  per part : 564.000000
    serial  part  0 : 0
    work for part 0 : 564
workload ok
",
						   write => "partition / 1 1",
						  },
						  {
						   description => "small network, two partitions",
						   read => "total workload : 564
 # partitions  : 2
work  per part : 282.000000
    serial  part  0 : 0
    work for part 0 : 304
    serial  part  1 : 88
    work for part 1 : 260
workload ok
",
						   write => "partition / 2 1",
						  },
						  {
						   description => "small network, three partitions",
						   read => "total workload : 564
 # partitions  : 3
work  per part : 188.000000
    serial  part  0 : 0
    work for part 0 : 232
    serial  part  1 : 66
    work for part 1 : 216
    serial  part  2 : 132
    work for part 2 : 116
workload ok
",
						   write => "partition / 3 1",
						  },
						  {
						   description => "small network, four partitions",
						   read => "total workload : 564
 # partitions  : 4
work  per part : 141.000000
    serial  part  0 : 0
    work for part 0 : 160
    serial  part  1 : 44
    work for part 1 : 144
    serial  part  2 : 88
    work for part 2 : 144
    serial  part  3 : 132
    work for part 3 : 116
workload ok
",
						   write => "partition / 4 1",
						  },
						 ],
				description => "various partitionings for a small network",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/network-test.ndf.', ],
						   timeout => 100,
						   write => undef,
						  },
						  {
						   description => "large network, single partition",
						   read => "total workload : 1015580
 # partitions  : 1
work  per part : 1015580.000000
    serial  part  0 : 0
    work for part 0 : 1015580
workload ok
",
						   write => "partition / 1 1",
						  },
						  {
						   description => "large network, two partitions",
						   read => "total workload : 1015580
 # partitions  : 2
work  per part : 507790.000000
    serial  part  0 : 0
    work for part 0 : 544730
    serial  part  1 : 137711
    work for part 1 : 470850
workload ok
",
						   write => "partition / 2 1",
						  },
						  {
						   description => "large network, three partitions",
						   read => "total workload : 1015580
 # partitions  : 3
work  per part : 338526.666667
    serial  part  0 : 0
    work for part 0 : 338592
    serial  part  1 : 103505
    work for part 1 : 394478
    serial  part  2 : 188763
    work for part 2 : 282510
workload ok
",
						   write => "partition / 3 1",
						  },
						  {
						   description => "large network, four partitions",
						   read => "total workload : 1015580
 # partitions  : 4
work  per part : 253895.000000
    serial  part  0 : 0
    work for part 0 : 253920
    serial  part  1 : 77633
    work for part 1 : 290810
    serial  part  2 : 137711
    work for part 2 : 282510
    serial  part  3 : 214289
    work for part 3 : 188340
workload ok
",
						   write => "partition / 4 1",
						  },
						  {
						   description => "large network, ten partitions",
						   read => "total workload : 1015580
 # partitions  : 10
work  per part : 101558.000000
    serial  part  0 : 0
    work for part 0 : 101568
    serial  part  1 : 31081
    work for part 1 : 101592
    serial  part  2 : 62123
    work for part 2 : 101592
    serial  part  3 : 93165
    work for part 3 : 101592
    serial  part  4 : 124207
    work for part 4 : 138386
    serial  part  5 : 137711
    work for part 5 : 188340
    serial  part  6 : 188763
    work for part 6 : 188340
    serial  part  7 : 239815
    work for part 7 : 94170
    serial  part  8 : 0
    work for part 8 : 0
    serial  part  9 : 0
    work for part 9 : 0
workload ok
",
						   write => "partition / 10 1",
						  },
						 ],
				description => "various partitionings for a large network",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'legacy/populations/granulelarge.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granulelarge.ndf.', ],
						   timeout => 10,
						   write => undef,
						  },
						  {
						   description => "large population, single partition",
						   read => "total workload : 2160000
 # partitions  : 1
work  per part : 2160000.000000
    serial  part  0 : 0
    work for part 0 : 2160000
workload ok
",
						   timeout => 3,
						   write => "partition / 1 1",
						  },
						  {
						   description => "large population, two partitions",
						   read => "total workload : 2160000
 # partitions  : 2
work  per part : 1080000.000000
    serial  part  0 : 0
    work for part 0 : 1080000
    serial  part  1 : 329981
    work for part 1 : 1080000
workload ok
",
						   timeout => 13,
						   write => "partition / 2 1",
						  },
						  {
						   description => "large population, three partitions",
						   read => "total workload : 2160000
 # partitions  : 3
work  per part : 720000.000000
    serial  part  0 : 0
    work for part 0 : 720000
    serial  part  1 : 219981
    work for part 1 : 720000
    serial  part  2 : 439981
    work for part 2 : 720000
workload ok
",
						   timeout => 13,
						   write => "partition / 3 1",
						  },
						  {
						   description => "large population, four partitions",
						   read => "total workload : 2160000
 # partitions  : 4
work  per part : 540000.000000
    serial  part  0 : 0
    work for part 0 : 540000
    serial  part  1 : 164981
    work for part 1 : 540000
    serial  part  2 : 329981
    work for part 2 : 540000
    serial  part  3 : 494981
    work for part 3 : 540000
workload ok
",
						   timeout => 13,
						   write => "partition / 4 1",
						  },
						  {
						   description => "large population, five partitions",
						   read => "total workload : 2160000
 # partitions  : 5
work  per part : 432000.000000
    serial  part  0 : 0
    work for part 0 : 432000
    serial  part  1 : 131981
    work for part 1 : 432000
    serial  part  2 : 263981
    work for part 2 : 432000
    serial  part  3 : 395981
    work for part 3 : 432000
    serial  part  4 : 527981
    work for part 4 : 432000
workload ok
",
						   timeout => 13,
						   write => "partition / 5 1",
						  },
						  {
						   description => "large population, ten partitions",
						   read => "total workload : 2160000
 # partitions  : 10
work  per part : 216000.000000
    serial  part  0 : 0
    work for part 0 : 216000
    serial  part  1 : 65981
    work for part 1 : 216000
    serial  part  2 : 131981
    work for part 2 : 216000
    serial  part  3 : 197981
    work for part 3 : 216000
    serial  part  4 : 263981
    work for part 4 : 216000
    serial  part  5 : 329981
    work for part 5 : 216000
    serial  part  6 : 395981
    work for part 6 : 216000
    serial  part  7 : 461981
    work for part 7 : 216000
    serial  part  8 : 527981
    work for part 8 : 216000
    serial  part  9 : 593981
    work for part 9 : 216000
workload ok
",
						   timeout => 13,
						   write => "partition / 10 1",
						  },
						  {
						   description => "large population, 100 partitions",
						   read => "total workload : 2160000
 # partitions  : 100
work  per part : 21600.000000
    serial  part  0 : 0
    work for part 0 : 21600
    serial  part  1 : 6581
    work for part 1 : 21600
    serial  part  2 : 13181
    work for part 2 : 21600
    serial  part  3 : 19781
    work for part 3 : 21600
    serial  part  4 : 26381
    work for part 4 : 21600
    serial  part  5 : 32981
    work for part 5 : 21600
    serial  part  6 : 39581
    work for part 6 : 21600
    serial  part  7 : 46181
    work for part 7 : 21600
    serial  part  8 : 52781
    work for part 8 : 21600
    serial  part  9 : 59381
    work for part 9 : 21600
    serial  part  10 : 65981
    work for part 10 : 21600
    serial  part  11 : 72581
    work for part 11 : 21600
    serial  part  12 : 79181
    work for part 12 : 21600
    serial  part  13 : 85781
    work for part 13 : 21600
    serial  part  14 : 92381
    work for part 14 : 21600
    serial  part  15 : 98981
    work for part 15 : 21600
    serial  part  16 : 105581
    work for part 16 : 21600
    serial  part  17 : 112181
    work for part 17 : 21600
    serial  part  18 : 118781
    work for part 18 : 21600
    serial  part  19 : 125381
    work for part 19 : 21600
    serial  part  20 : 131981
    work for part 20 : 21600
    serial  part  21 : 138581
    work for part 21 : 21600
    serial  part  22 : 145181
    work for part 22 : 21600
    serial  part  23 : 151781
    work for part 23 : 21600
    serial  part  24 : 158381
    work for part 24 : 21600
    serial  part  25 : 164981
    work for part 25 : 21600
    serial  part  26 : 171581
    work for part 26 : 21600
    serial  part  27 : 178181
    work for part 27 : 21600
    serial  part  28 : 184781
    work for part 28 : 21600
    serial  part  29 : 191381
    work for part 29 : 21600
    serial  part  30 : 197981
    work for part 30 : 21600
    serial  part  31 : 204581
    work for part 31 : 21600
    serial  part  32 : 211181
    work for part 32 : 21600
    serial  part  33 : 217781
    work for part 33 : 21600
    serial  part  34 : 224381
    work for part 34 : 21600
    serial  part  35 : 230981
    work for part 35 : 21600
    serial  part  36 : 237581
    work for part 36 : 21600
    serial  part  37 : 244181
    work for part 37 : 21600
    serial  part  38 : 250781
    work for part 38 : 21600
    serial  part  39 : 257381
    work for part 39 : 21600
    serial  part  40 : 263981
    work for part 40 : 21600
    serial  part  41 : 270581
    work for part 41 : 21600
    serial  part  42 : 277181
    work for part 42 : 21600
    serial  part  43 : 283781
    work for part 43 : 21600
    serial  part  44 : 290381
    work for part 44 : 21600
    serial  part  45 : 296981
    work for part 45 : 21600
    serial  part  46 : 303581
    work for part 46 : 21600
    serial  part  47 : 310181
    work for part 47 : 21600
    serial  part  48 : 316781
    work for part 48 : 21600
    serial  part  49 : 323381
    work for part 49 : 21600
    serial  part  50 : 329981
    work for part 50 : 21600
    serial  part  51 : 336581
    work for part 51 : 21600
    serial  part  52 : 343181
    work for part 52 : 21600
    serial  part  53 : 349781
    work for part 53 : 21600
    serial  part  54 : 356381
    work for part 54 : 21600
    serial  part  55 : 362981
    work for part 55 : 21600
    serial  part  56 : 369581
    work for part 56 : 21600
    serial  part  57 : 376181
    work for part 57 : 21600
    serial  part  58 : 382781
    work for part 58 : 21600
    serial  part  59 : 389381
    work for part 59 : 21600
    serial  part  60 : 395981
    work for part 60 : 21600
    serial  part  61 : 402581
    work for part 61 : 21600
    serial  part  62 : 409181
    work for part 62 : 21600
    serial  part  63 : 415781
    work for part 63 : 21600
    serial  part  64 : 422381
    work for part 64 : 21600
    serial  part  65 : 428981
    work for part 65 : 21600
    serial  part  66 : 435581
    work for part 66 : 21600
    serial  part  67 : 442181
    work for part 67 : 21600
    serial  part  68 : 448781
    work for part 68 : 21600
    serial  part  69 : 455381
    work for part 69 : 21600
    serial  part  70 : 461981
    work for part 70 : 21600
    serial  part  71 : 468581
    work for part 71 : 21600
    serial  part  72 : 475181
    work for part 72 : 21600
    serial  part  73 : 481781
    work for part 73 : 21600
    serial  part  74 : 488381
    work for part 74 : 21600
    serial  part  75 : 494981
    work for part 75 : 21600
    serial  part  76 : 501581
    work for part 76 : 21600
    serial  part  77 : 508181
    work for part 77 : 21600
    serial  part  78 : 514781
    work for part 78 : 21600
    serial  part  79 : 521381
    work for part 79 : 21600
    serial  part  80 : 527981
    work for part 80 : 21600
    serial  part  81 : 534581
    work for part 81 : 21600
    serial  part  82 : 541181
    work for part 82 : 21600
    serial  part  83 : 547781
    work for part 83 : 21600
    serial  part  84 : 554381
    work for part 84 : 21600
    serial  part  85 : 560981
    work for part 85 : 21600
    serial  part  86 : 567581
    work for part 86 : 21600
    serial  part  87 : 574181
    work for part 87 : 21600
    serial  part  88 : 580781
    work for part 88 : 21600
    serial  part  89 : 587381
    work for part 89 : 21600
    serial  part  90 : 593981
    work for part 90 : 21600
    serial  part  91 : 600581
    work for part 91 : 21600
    serial  part  92 : 607181
    work for part 92 : 21600
    serial  part  93 : 613781
    work for part 93 : 21600
    serial  part  94 : 620381
    work for part 94 : 21600
    serial  part  95 : 626981
    work for part 95 : 21600
    serial  part  96 : 633581
    work for part 96 : 21600
    serial  part  97 : 640181
    work for part 97 : 21600
    serial  part  98 : 646781
    work for part 98 : 21600
    serial  part  99 : 653381
    work for part 99 : 21600
workload ok
",
						   timeout => 18,
						   write => "partition / 100 1",
						  },
						 ],
				description => "various partitionings for a very large population",
			       },
			      ],
       description => "partitioning",
       name => 'workload.t',
      };


return $test;


