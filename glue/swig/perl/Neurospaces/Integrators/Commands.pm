#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Integrators::Commands;


use strict;


use Neurospaces;


our $g3_commands
    = [
       'ndf_load',
       'ndf_load_help',
       'ndf_save',
       'ndf_save_help',
      ];


sub ndf_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: ndf_load $filename";
}


sub ndf_load_help
{
    print "description: load an ndf file and reconstruct the model it describes.\n";

    print "synopsis: ndf_load <filename.ndf>\n";

    return "*** Ok";
}


sub ndf_save
{
    my $modelname = shift;

    my $filename = shift;

    $GENESIS3::model_container->write(undef, $modelname, 'ndf', $filename, );

    return "*** Ok: ndf_save $filename";
}


sub ndf_save_help
{
    print "description: save a model to an ndf file.\n";

    print "synopsis: ndf_save <element_name> <filename>\n";

    return "*** Ok";
}


