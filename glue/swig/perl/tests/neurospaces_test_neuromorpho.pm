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


# print "hello there\n";


use Data::Dumper;


sub main
{
    my $neurospaces = Neurospaces->new();

    my $success
	= $neurospaces->load
	    (
	     undef,
	     {
	      filename => "http://neuromorpho.org/neuroMorpho/dableFiles/dendritica/CNG%20version/v_e_purk3.CNG.swc",
	     },
	    );

    {
	my $traversal
	    = Neurospaces::Traversal->new
		(
		 {
		  context => '/',
		  processor =>
		  sub
		  {
		      my $self = shift;

		      my $descendant = shift;

		      use Data::Dumper;

		      print "processing " . Dumper($descendant);

# 		      print "processing $descendant\n";
		  },
		  neurospaces => $neurospaces,
		 },
		);

	my $success = $traversal->go();
    }
}


main();


