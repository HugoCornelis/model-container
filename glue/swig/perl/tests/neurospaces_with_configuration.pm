#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#


use strict;


$| = 1;


BEGIN
{
    push @INC, '../glue/swig/perl';

    push @INC, 'glue/swig/perl';

    push @INC, '/usr/local/glue/swig/perl';
}


$SIG{__DIE__}
    = sub {
	use Carp;

	confess @_;
    };


require Neurospaces;

require Neurospaces::Traversal;


sub main
{
    my $configuration
	= '---
options:
  histology:
    shrinkage: 1
  relocation:
    soma_offset: 1
prototypes:
  aliasses:
    - segments/purkinje/soma.ndf::soma
    - segments/purkinje/spinyd.ndf::spinyd
  parameter_2_prototype:
    - dia: 3.18e-06
      prototype: spinyd
    - dia: 1
      prototype: soma
variables:
  origin:
    x: 0
    y: 0
    z: 0
';

    use IO::File;

    my $file = IO::File->new('>/tmp/morphology2ndf.yml');

    print $file $configuration;

    $file->close();

    my $neurospaces = Neurospaces->new();

    my $success
	= $neurospaces->load
	    (
	     undef,
	     {
	      commands => [
			   'expand /C170897A_P3_CNG/segments/soma/**',
			   'expand /C170897A_P3_CNG/segments/s_2/**',
			   'expand /C170897A_P3_CNG/segments/s_1666/**',
			  ],
	      configuration => '/tmp/morphology2ndf.yml',

	      #t this will probably need a prefix during distcheck, not sure yet.

	      executable => (defined $ENV{srcdir} ? $ENV{srcdir} . '/' : './') . 'convertors/morphology2ndf',
	      filename => 'morphologies/C170897A-P3.CNG.swc',
	     },
	     [ $0, ],
	    );
}


main();


