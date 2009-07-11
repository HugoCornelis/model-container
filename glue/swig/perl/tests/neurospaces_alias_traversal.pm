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

    my $args = [ "$0", "-P", "-A", "legacy/cells/purk2m9s.ndf" ];

    my $success = $neurospaces->read(undef, $args);

    $neurospaces->querymachine("echo 1");

    $neurospaces->querymachine("expand /Purkinje/segments/soma/**");

    $neurospaces->querymachine("echo 2");

    $neurospaces->add_component("spine::/Purk_spine/head/par", "/Purkinje/segments/soma/synchan");

    $neurospaces->querymachine("expand /Purkinje/segments/soma/**");

    $neurospaces->querymachine("echo 3");
}


main();


