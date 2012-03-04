#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Integrators::Commands;


use strict;


use Neurospaces;
use Neurospaces::Components;


our $g3_commands
    = [
       'createmap',
       'createmap_help',
       'insert_alias',
       'insert_alias_help',
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
       'volumeconnect',
       'volumeconnect_help',
      ];


sub createmap
{
    my $prototype = shift;

    my $target = shift;

    my $countX = shift;

    my $countY = shift;

    my $deltaX = shift;

    my $deltaY = shift;

    if ($prototype =~ /(.*)::(.*)/)
    {
	my $namespaces = $1;

	my $component_name = $2;

	my $backend = $GENESIS3::model_container->backend();

	my $sym = $backend->swig_psym_get();

	my $context_prototype = SwiggableNeurospaces::PidinStackParse($prototype);

	my $symbol_prototype = $sym->SymbolsLookupHierarchical($context_prototype);

# 	bless $symbol_prototype, 'Neurospaces::Components::Network';

	if ($component_name =~ m(^/))
	{
	    $component_name =~ s(^/)();
	}

	my $pidin = SwiggableNeurospaces::IdinCallocUnique($component_name);

	my $alias = $symbol_prototype->SymbolCreateAlias($namespaces, $pidin);

	my $root_context = SwiggableNeurospaces::PidinStackParse("::/");

	my $root_symbol = $root_context->PidinStackLookupTopSymbol();

	if (!$root_symbol)
	{
	    return "*** Error: Cannot get a private root context (has a model been loaded ?)";
	}

	my $success = $root_symbol->SymbolAddChild($alias);

	# 	my $private_model = $symbol_prototype->alias($namespaces, $component_name, "network", "Neurospaces::Components::Network");

# 	$GENESIS3::model_container->insert_private($alias);

	$prototype = $component_name;
    }

    my $instance_name = "createmap_$target";

    $instance_name =~ s(/)(_)g;

    GENESIS3::Commands::querymachine("algorithminstantiate Grid3D $instance_name $target $prototype $countX $countY 1 $deltaX $deltaY 0");

    print "created a new private component with name $target\n";

    return "*** Ok: createmap";
}


sub createmap_help
{
    print "description: instantiate a prototype model many time in a two dimensional array with the given dimensions.\n";

    print "synopsis: createmap <prototype> <target> <positionX> <positionY> <deltaX> <deltaY>\n";

    return "*** Ok: createmap_help";
}


sub insert_alias
{
    my $source = shift;

    my $target = shift;

    GENESIS3::Commands::querymachine("insert $source $target");

    return "*** Ok: insert_alias";
}


sub insert_alias_help
{
    print "description: insert a new public model component based on an existing private one.\n";

    print "synopsis: insert_alias <source> <target>\n";

    return "*** Ok: insert_alias_help";
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


sub volumeconnect
{
    my $projection = shift;

    my $source = shift;

    my $target = shift;

    my $pre = shift;

    my $post = shift;

    my $source_type = shift;

    my $source_x1 = shift;

    my $source_y1 = shift;

    my $source_z1 = shift;

    my $source_x2 = shift;

    my $source_y2 = shift;

    my $source_z2 = shift;

    my $destination_type = shift;

    my $destination_x1 = shift;

    my $destination_y1 = shift;

    my $destination_z1 = shift;

    my $destination_x2 = shift;

    my $destination_y2 = shift;

    my $destination_z2 = shift;

    my $probability = shift;

    my $instance_name = "projectionvolume_$projection";

    $instance_name =~ s(/)(_)g;

    GENESIS3::Commands::querymachine("algorithminstantiate ProjectionVolume $instance_name $projection $source $target $pre $post $source_type $source_x1 $source_y1 $source_z1 $source_x2 $source_y2 $source_z2 $destination_type $destination_x1 $destination_y1 $destination_z1 $destination_x2 $destination_y2 $destination_z2 $probability");

    print "created a new projection with name $projection\n";

    return "*** Ok: volumeconnect";
}


sub volumeconnect_help
{
    print "description: instantiate a projection, see the G-2 volumeconnect for more information about this command.\n";

    print "synopsis: volumeconnect <projection> <source population> <target population> <pre> <post> <source_type> <source_x1> <source_y1> <source_z1> <source_x2> <source_y2> <source_z2> <destination_type> <destination_x1> <destination_y1> <destination_z1> <destination_x2> <destination_y2> <destination_z2> <probability>\n";

    return "*** Ok: volumeconnect_help";
}


1;


