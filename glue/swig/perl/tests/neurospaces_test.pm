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

# $ENV{NEUROSPACES_MODELS} = '/local_home/local_home/hugo/neurospaces_project/model_container/source/c/snapshots/0/library';


require Neurospaces;

require Neurospaces::Traversal;


# print "hello there\n";


use Data::Dumper;


# {
#     no strict "refs";

#     print Dumper(\%{"main::"});

#     print "Found these methods for Neurospaces::\n";

#     print Dumper(\%{"Neurospaces::"});

#     print "Found these methods for Neurospaces::Traversal::\n";

#     print Dumper(\%{"Neurospaces::Traversal::"});

#     print "Found these methods for SwiggableNeurospaces::\n";

#     print Dumper(\%{"SwiggableNeurospaces::"});

#     print "Found these methods for SwiggableNeurospaces::PidinStack::\n";

#     print Dumper(\%{"SwiggableNeurospaces::PidinStack::"});

#     print "Found these methods for SwiggableNeurospaces::descr_Segment::\n";

#     print Dumper(\%{"SwiggableNeurospaces::descr_Segment::"});

#     print "Found these methods for SwiggableNeurospaces::symtab_Segment::\n";

#     print Dumper(\%{"SwiggableNeurospaces::symtab_Segment::"});

#     print "Found these methods for SwiggableNeurospaces::descr_Segmenter::\n";

#     print Dumper(\%{"SwiggableNeurospaces::descr_Segmenter::"});

#     print "Found these methods for SwiggableNeurospaces::symtab_Segmenter::\n";

#     print Dumper(\%{"SwiggableNeurospaces::symtab_Segmenter::"});

#     print "Found these methods for SwiggableNeurospaces::symtab_BioComponent::\n";

#     print Dumper(\%{"SwiggableNeurospaces::symtab_BioComponent::"});

#     print "Found these methods for SwiggableNeurospaces::Symbols::\n";

#     print Dumper(\%{"SwiggableNeurospaces::Symbols::"});

# }


sub main
{
    my $neurospaces = Neurospaces->new();

    # my $args = [ "$0", "-P", "-q", "legacy/cells/golgi.ndf" ];

    my $args = [ "$0", "-P", "legacy/cells/purk2m9s.ndf" ];

    my $success = $neurospaces->read($args);
}


main();


