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

    my $args = [ "$0", "-A", "legacy/cells/golgi.ndf" ];

    my $success = $neurospaces->read($args);

    $neurospaces->querymachine("echo 1");

    $neurospaces->querymachine("expand /Golgi/Golgi_soma/**");

    $neurospaces->querymachine("echo 2");

    $neurospaces->delete_component("/Golgi/Golgi_soma/spikegen");

    $neurospaces->querymachine("expand /Golgi/Golgi_soma/**");

    $neurospaces->querymachine("echo 3");
}


main();


