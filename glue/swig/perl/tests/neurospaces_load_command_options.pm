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
    my $neurospaces = Neurospaces->new();

    my $success
	= $neurospaces->load
	    (
	     {
	      commands => [
			   'delete /Golgi/Golgi_soma',
			   'echo start',
			   'expand /**',
			   'echo end',
			  ],
	      filename => 'legacy/cells/golgi.ndf',
	     },
	     [ $0, ],
	    );
}


main();


