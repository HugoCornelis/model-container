#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Integrators::Commands;


use strict;


use Neurospaces;


our $g3_commands
    = [
       'morphology_list_spine_heads',
       'morphology_summarize',
       'ndf_load',
       'ndf_load_help',
       'ndf_save',
       'ndf_save_help',
       'xml_load',
       'xml_load_help',
       'xml_save',
       'xml_save_help',
      ];


sub morphology_list_spine_heads
{
    my $modelname = shift;

    GENESIS3::Commands::querymachine("segmentertips $modelname");

    return "*** Ok: morphology_list_spine_heads";
}


sub morphology_summarize
{
    my $modelname = shift;

    GENESIS3::Commands::querymachine("segmenterlinearize $modelname");

    return "*** Ok: morphology_summarize";
}


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


sub xml_load
{
    my $filename = shift;

    $GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], );

    return "*** Ok: xml_load $filename";
}


sub xml_load_help
{
    print "description: load an xml file and reconstruct the model it describes.\n";

    print "synopsis: xml_load <filename.xml>\n";

    return "*** Ok";
}


sub xml_save
{
    my $modelname = shift;

    my $filename = shift;

    $GENESIS3::model_container->write(undef, $modelname, 'xml', $filename, );

    return "*** Ok: xml_save $filename";
}


sub xml_save_help
{
    print "description: save a model to an xml file.\n";

    print "synopsis: xml_save <element_name> <filename>\n";

    return "*** Ok";
}


