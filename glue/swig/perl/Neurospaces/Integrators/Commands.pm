#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Integrators::Commands;


use strict;


use Neurospaces;


our $g3_commands
    = [
       'morphology_list_spine_heads',
       'morphology_list_spine_heads_help',
       'morphology_summarize',
       'morphology_summarize_help',
       'ndf_load',
       'ndf_load_help',
       'ndf_load_library',
       'ndf_load_library_help',
       'ndf_save',
       'ndf_save_help',
       'xml_load',
       'xml_load_help',
       'xml_save',
       'xml_save_help',
      ];


sub createmap
{
    my $prototype = shift;

    my $target = shift;

    my $positionX = shift;

    my $positionY = shift;

    my $deltaX = shift;

    my $deltaY = shift;

    GENESIS3::Commands::querymachine("algorithminstantiate Grid3D createmap_$target $prototype $positionX $positionY 0 $deltaX $deltaY 0");

    return "*** Ok: createmap";
}


sub createmap_help
{
    print "description: instantiate a prototype model many time in a two dimensional array with the given dimensions.\n";

    print "synopsis: createmap <prototype> <target> <positionX> <positionY> <deltaX> <deltaY>\n";

    return "*** Ok: createmap_help";
}


sub morphology_list_spine_heads
{
    my $modelname = shift;

    GENESIS3::Commands::querymachine("segmentertips $modelname");

    return "*** Ok: morphology_list_spine_heads";
}


sub morphology_list_spine_heads_help
{
    print "description: list all the terminal tips in a morphology.\n";

    print "synopsis: morphology_list_spine_heads <modelname>\n";

    return "*** Ok: morphology_list_spine_heads_help";
}


sub morphology_summarize
{
    my $modelname = shift;

    GENESIS3::Commands::querymachine("segmentersetbase $modelname");

    GENESIS3::Commands::querymachine("segmenterlinearize $modelname");

    return "*** Ok: morphology_summarize";
}


sub morphology_summarize_help
{
    print "description: build internal indexes before analyzing a morphology.\n";

    print "synopsis: morphology_summarize <modelname>\n";

    return "*** Ok: morphology_summarize_help";
}


sub ndf_load_library
{
    my $namespace = shift;

    my $filename = shift;

    my $success = $GENESIS3::model_container->import_qualified_filename($filename, $namespace);

    if ($success)
    {
	return "*** Ok: ndf_load_library $namespace $filename";
    }
    else
    {
	return "*** Error: ndf_load_library $namespace $filename";
    }
}


sub ndf_load_library_help
{
    print "description: load an ndf file into a namespace and reconstruct the model it describes within that namespace.\n";

    print "synopsis: ndf_load_library <filename.ndf>\n";

    return "*** Ok";
}


sub ndf_load
{
    my $filename = shift;

    if ($GENESIS3::model_container->read(undef, [ 'genesis-g3', $filename, ], ))
    {
	return "*** Ok: ndf_load $filename";
    }
    else
    {
	return "*** Error: ndf_load $filename";
    }
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

    if (!defined $modelname)
    {
	return "*** Error: no modelname given";
    }

    if (!defined $filename)
    {
	return "*** Error: no filename given";
    }

#     $GENESIS3::model_container->write(undef, $modelname, 'ndf', $filename, );

    GENESIS3::Commands::querymachine("export library ndf $filename $modelname");

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

#     $GENESIS3::model_container->write(undef, $modelname, 'xml', $filename, );

    GENESIS3::Commands::querymachine("export library xml $filename $modelname");

    return "*** Ok: xml_save $filename";
}


sub xml_save_help
{
    print "description: save a model to an xml file.\n";

    print "synopsis: xml_save <element_name> <filename>\n";

    return "*** Ok";
}


