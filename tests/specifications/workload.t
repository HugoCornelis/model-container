#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
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
    serial  part  1 : 83
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
    serial  part  1 : 61
    work for part 1 : 216
    serial  part  2 : 127
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
    serial  part  1 : 39
    work for part 1 : 144
    serial  part  2 : 83
    work for part 2 : 144
    serial  part  3 : 127
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
    serial  part  1 : 137701
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
    serial  part  1 : 103495
    work for part 1 : 394478
    serial  part  2 : 188753
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
    serial  part  1 : 77623
    work for part 1 : 290810
    serial  part  2 : 137701
    work for part 2 : 282510
    serial  part  3 : 214279
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
    serial  part  1 : 31071
    work for part 1 : 101592
    serial  part  2 : 62113
    work for part 2 : 101592
    serial  part  3 : 93155
    work for part 3 : 101592
    serial  part  4 : 124197
    work for part 4 : 138386
    serial  part  5 : 137701
    work for part 5 : 188340
    serial  part  6 : 188753
    work for part 6 : 188340
    serial  part  7 : 239805
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
    serial  part  1 : 329980
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
    serial  part  1 : 219980
    work for part 1 : 720000
    serial  part  2 : 439980
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
    serial  part  1 : 164980
    work for part 1 : 540000
    serial  part  2 : 329980
    work for part 2 : 540000
    serial  part  3 : 494980
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
    serial  part  1 : 131980
    work for part 1 : 432000
    serial  part  2 : 263980
    work for part 2 : 432000
    serial  part  3 : 395980
    work for part 3 : 432000
    serial  part  4 : 527980
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
    serial  part  1 : 65980
    work for part 1 : 216000
    serial  part  2 : 131980
    work for part 2 : 216000
    serial  part  3 : 197980
    work for part 3 : 216000
    serial  part  4 : 263980
    work for part 4 : 216000
    serial  part  5 : 329980
    work for part 5 : 216000
    serial  part  6 : 395980
    work for part 6 : 216000
    serial  part  7 : 461980
    work for part 7 : 216000
    serial  part  8 : 527980
    work for part 8 : 216000
    serial  part  9 : 593980
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
    serial  part  1 : 6580
    work for part 1 : 21600
    serial  part  2 : 13180
    work for part 2 : 21600
    serial  part  3 : 19780
    work for part 3 : 21600
    serial  part  4 : 26380
    work for part 4 : 21600
    serial  part  5 : 32980
    work for part 5 : 21600
    serial  part  6 : 39580
    work for part 6 : 21600
    serial  part  7 : 46180
    work for part 7 : 21600
    serial  part  8 : 52780
    work for part 8 : 21600
    serial  part  9 : 59380
    work for part 9 : 21600
    serial  part  10 : 65980
    work for part 10 : 21600
    serial  part  11 : 72580
    work for part 11 : 21600
    serial  part  12 : 79180
    work for part 12 : 21600
    serial  part  13 : 85780
    work for part 13 : 21600
    serial  part  14 : 92380
    work for part 14 : 21600
    serial  part  15 : 98980
    work for part 15 : 21600
    serial  part  16 : 105580
    work for part 16 : 21600
    serial  part  17 : 112180
    work for part 17 : 21600
    serial  part  18 : 118780
    work for part 18 : 21600
    serial  part  19 : 125380
    work for part 19 : 21600
    serial  part  20 : 131980
    work for part 20 : 21600
    serial  part  21 : 138580
    work for part 21 : 21600
    serial  part  22 : 145180
    work for part 22 : 21600
    serial  part  23 : 151780
    work for part 23 : 21600
    serial  part  24 : 158380
    work for part 24 : 21600
    serial  part  25 : 164980
    work for part 25 : 21600
    serial  part  26 : 171580
    work for part 26 : 21600
    serial  part  27 : 178180
    work for part 27 : 21600
    serial  part  28 : 184780
    work for part 28 : 21600
    serial  part  29 : 191380
    work for part 29 : 21600
    serial  part  30 : 197980
    work for part 30 : 21600
    serial  part  31 : 204580
    work for part 31 : 21600
    serial  part  32 : 211180
    work for part 32 : 21600
    serial  part  33 : 217780
    work for part 33 : 21600
    serial  part  34 : 224380
    work for part 34 : 21600
    serial  part  35 : 230980
    work for part 35 : 21600
    serial  part  36 : 237580
    work for part 36 : 21600
    serial  part  37 : 244180
    work for part 37 : 21600
    serial  part  38 : 250780
    work for part 38 : 21600
    serial  part  39 : 257380
    work for part 39 : 21600
    serial  part  40 : 263980
    work for part 40 : 21600
    serial  part  41 : 270580
    work for part 41 : 21600
    serial  part  42 : 277180
    work for part 42 : 21600
    serial  part  43 : 283780
    work for part 43 : 21600
    serial  part  44 : 290380
    work for part 44 : 21600
    serial  part  45 : 296980
    work for part 45 : 21600
    serial  part  46 : 303580
    work for part 46 : 21600
    serial  part  47 : 310180
    work for part 47 : 21600
    serial  part  48 : 316780
    work for part 48 : 21600
    serial  part  49 : 323380
    work for part 49 : 21600
    serial  part  50 : 329980
    work for part 50 : 21600
    serial  part  51 : 336580
    work for part 51 : 21600
    serial  part  52 : 343180
    work for part 52 : 21600
    serial  part  53 : 349780
    work for part 53 : 21600
    serial  part  54 : 356380
    work for part 54 : 21600
    serial  part  55 : 362980
    work for part 55 : 21600
    serial  part  56 : 369580
    work for part 56 : 21600
    serial  part  57 : 376180
    work for part 57 : 21600
    serial  part  58 : 382780
    work for part 58 : 21600
    serial  part  59 : 389380
    work for part 59 : 21600
    serial  part  60 : 395980
    work for part 60 : 21600
    serial  part  61 : 402580
    work for part 61 : 21600
    serial  part  62 : 409180
    work for part 62 : 21600
    serial  part  63 : 415780
    work for part 63 : 21600
    serial  part  64 : 422380
    work for part 64 : 21600
    serial  part  65 : 428980
    work for part 65 : 21600
    serial  part  66 : 435580
    work for part 66 : 21600
    serial  part  67 : 442180
    work for part 67 : 21600
    serial  part  68 : 448780
    work for part 68 : 21600
    serial  part  69 : 455380
    work for part 69 : 21600
    serial  part  70 : 461980
    work for part 70 : 21600
    serial  part  71 : 468580
    work for part 71 : 21600
    serial  part  72 : 475180
    work for part 72 : 21600
    serial  part  73 : 481780
    work for part 73 : 21600
    serial  part  74 : 488380
    work for part 74 : 21600
    serial  part  75 : 494980
    work for part 75 : 21600
    serial  part  76 : 501580
    work for part 76 : 21600
    serial  part  77 : 508180
    work for part 77 : 21600
    serial  part  78 : 514780
    work for part 78 : 21600
    serial  part  79 : 521380
    work for part 79 : 21600
    serial  part  80 : 527980
    work for part 80 : 21600
    serial  part  81 : 534580
    work for part 81 : 21600
    serial  part  82 : 541180
    work for part 82 : 21600
    serial  part  83 : 547780
    work for part 83 : 21600
    serial  part  84 : 554380
    work for part 84 : 21600
    serial  part  85 : 560980
    work for part 85 : 21600
    serial  part  86 : 567580
    work for part 86 : 21600
    serial  part  87 : 574180
    work for part 87 : 21600
    serial  part  88 : 580780
    work for part 88 : 21600
    serial  part  89 : 587380
    work for part 89 : 21600
    serial  part  90 : 593980
    work for part 90 : 21600
    serial  part  91 : 600580
    work for part 91 : 21600
    serial  part  92 : 607180
    work for part 92 : 21600
    serial  part  93 : 613780
    work for part 93 : 21600
    serial  part  94 : 620380
    work for part 94 : 21600
    serial  part  95 : 626980
    work for part 95 : 21600
    serial  part  96 : 633580
    work for part 96 : 21600
    serial  part  97 : 640180
    work for part 97 : 21600
    serial  part  98 : 646780
    work for part 98 : 21600
    serial  part  99 : 653380
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


