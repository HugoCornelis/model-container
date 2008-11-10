#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces;


use strict;


use SwiggableNeurospaces;


sub add_component
{
    my $self = shift;

    my $source = shift;

    my $target = shift;

    my $result;

    # split target in existing and new components

    $target =~ m(^(.*)/(.*)$);

    my $target_exists = $1;

    my $target_new = $2;

    # get contexts

    my $context_source = SwiggableNeurospaces::PidinStackParse($source);

    my $context_target = SwiggableNeurospaces::PidinStackParse($target_exists);

    # lookup the symbols

    my $backend = $self->backend();

    my $sym = $backend->swig_psym_get();

    my $symbol_source = $sym->SymbolsLookupHierarchical($context_source);

    my $symbol_target = $sym->SymbolsLookupHierarchical($context_target);

    if (!defined $symbol_source)
    {
	die "$0: Cannot find context $source (does it exist ?)";
    }

    if (!defined $symbol_target)
    {
	die "$0: Cannot find context $target_exists (does it exist ?)";
    }

    # create an alias of the source

    my $pidin = SwiggableNeurospaces::IdinNewFromChars($target_new);

    my $symbol_alias = $symbol_source->SymbolCreateAlias($pidin);

    # link the alias into the symbol table

    my $success = $symbol_target->SymbolAddChild($symbol_alias);

    if (!$success)
    {
	die "$0: Backend SymbolAddChild() child failed";
    }

    $success = SwiggableNeurospaces::SymbolRecalcAllSerials(undef, undef);

    if (!$success)
    {
	die "$0: Backend recalculating serials failed";
    }

    return 1;
}


sub algorithm_instance_report
{
    my $self = shift;

    my $instance_name = shift;

    my $file = shift;

    my $backend = $self->backend();

    my $sym = $backend->swig_psym_get();

    my $pas = $sym->swig_pas_get();

    SwiggableNeurospaces::AlgorithmSetInstancePrint($pas, $instance_name, $file);
}


sub apply_conceptual_parameters
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $backend = $self->backend();

    my $result;

    my $sym = $backend->swig_psym_get();

    # loop over all settings

    foreach my $model_concept (@$options)
    {
	# get a context for this component

	my $component_name = $model_concept->{component_name};

	my $context = SwiggableNeurospaces::PidinStackParse($component_name);

	# lookup the symbol

	my $symbol = $sym->SymbolsLookupHierarchical($context);

	if (!defined $symbol)
	{
	    return "cannot find context for $component_name (does it exist)";
	}

	# get field and value

	my $field = $model_concept->{field};

	my $value = $model_concept->{value};

	#t do fancy things for symbolic parameters
	#t backend needs explicit support for this

	#t also the value can possibly be structured, e.g. a function.

	# set the parameter

	if ($value =~ /^[+-]?[0-9]*\.?[0-9]*(e[+-]?[0-9]+)?$/
	    && $value =~ /./)
	{
	    my $parameter = $symbol->SymbolSetParameterDouble($field, $value);

	    if (!$parameter)
	    {
		return "cannot set concept $component_name -> $field";
	    }
	}
	else
	{
	    my $parameter = $symbol->SymbolSetParameterString($field, $value);

	    if (!$parameter)
	    {
		return "cannot set concept $component_name -> $field";
	    }
	}
    }

    # return result: undef is success

    return $result;
}


sub apply_granular_parameters
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $backend = $self->backend();

    my $result;

#     SwiggableNeurospaces::ImportedFilePrintRootImport();

    # the parameter context base is always the root for now

    my $root_context = SwiggableNeurospaces::PidinStackParse("/");

    my $root_symbol = $root_context->PidinStackLookupTopSymbol();

    if (!$root_symbol)
    {
	return "Cannot get a root context (has a model been loaded ?)";
    }

    #! I think that roots and parameter caches are mutually
    #! incompatible right now, so I cache at the first symbol instead of
    #! at the root.

    my $firstcontext = $root_symbol->SymbolPrincipalSerial2Context($root_context, 1);

    if (!defined $firstcontext)
    {
	return "Cannot find first symbol context (has a model been loaded ?)";
    }

    my $firstsymbol = $firstcontext->PidinStackLookupTopSymbol();

    if (!defined $firstsymbol)
    {
	return "Cannot find first symbol (internal error)";
    }

    # loop over all settings

    foreach my $model_parameter (@$options)
    {
	# get a context for this component

	my $component_name = $model_parameter->{component_name};

	my $context = SwiggableNeurospaces::PidinStackParse($component_name);

	$context->PidinStackLookupTopSymbol();

	my $serial = $context->PidinStackToSerial();

	if ($serial eq $SwiggableNeurospaces::iINT_MAX)
	{
	    return "invalid context for $component_name (does this component exist ?)";
	}

	# get field and value

	my $field = $model_parameter->{field};

	my $value = $model_parameter->{value};

	#t do fancy things for symbolic parameters
	#t backend needs explicit support for this

	# set the parameter

	if ($value =~ /^[+-]?[0-9]*\.?[0-9]*(e[+-]?[0-9]+)?$/
	    && $value =~ /./)
	{
	    my $parameter = $firstsymbol->SymbolCacheParameterDouble($serial - 1, $field, $value);

	    if (!$parameter)
	    {
		return "cannot set parameter $component_name -> $field";
	    }
	}
	else
	{
	    my $parameter = $firstsymbol->SymbolCacheParameterString($serial - 1, $field, $value);

	    if (!$parameter)
	    {
		return "cannot set parameter $component_name -> $field";
	    }
	}
    }

    # return result: undef is success

    return $result;
}


sub backend
{
    my $self = shift;

    return $self->{neurospaces};
}


sub component_2_serial
{
    my $self = shift;

    my $component_name = shift;

    # get context with caches

    my $context = SwiggableNeurospaces::PidinStackParse($component_name);

    $context->PidinStackLookupTopSymbol();

    # convert to serial

    my $result = $context->PidinStackToSerial();

    $context->PidinStackFree();

    if ($result eq $SwiggableNeurospaces::iINT_MAX)
    {
	return undef;
    }

    # return result

    return $result;
}


sub delete_component
{
    my $self = shift;

    my $component = shift;

    my $result;

    # split component in parent and child

    $component =~ m(^(.*)/(.*)$);

    my $parent = $1;

    my $child = $2;

    # create contexts

    my $context_parent = SwiggableNeurospaces::PidinStackParse($parent);

    my $context_child = SwiggableNeurospaces::PidinStackParse($component);

    # lookup the symbols

    my $backend = $self->backend();

    my $sym = $backend->swig_psym_get();

    my $symbol_parent = $sym->SymbolsLookupHierarchical($context_parent);

    my $symbol_child = $sym->SymbolsLookupHierarchical($context_child);

    if (!defined $symbol_parent)
    {
	die "$0: Cannot find context $parent (does it exist ?)";
    }

    if (!defined $symbol_child)
    {
	die "$0: cannot find context $child (does it exist ?)";
    }

    # delete the child from the parent

    #! if this one is not found

    my $success;

    eval
    {
	$success = $symbol_parent->SymbolDeleteChild($symbol_child);
    };

    if ($@)
    {
	die "$0: Backend deleting child failed (did you 'configure --with-delete-operation' ?)";
    }

    if (!$success)
    {
	die "$0: Backend deleting child failed";
    }

    $success = SwiggableNeurospaces::SymbolRecalcAllSerials(undef, undef);

    if (!$success)
    {
	die "$0: Backend recalculating serials failed";
    }

    return 1;
}


sub import_qualified_filename
{
    my $self = shift;

    my $filename = shift;

    my $namespace = shift;

    # get root parser context

    my $backend = $self->backend();

    my $pac = $backend->swig_pacRootContext_get();

    # import the file

    my $result = SwiggableNeurospaces::ParserImport($pac, $filename, $namespace);

    # return: success of operation

    return $result;
}


sub input_2_solverinfo
{
    my $self = shift;

    $self->output_2_solverinfo(@_);
}


sub list_elements
{
    my $path = shift;

    print "not implemented yet\n";

    return [];
}


sub load
{
    my $self = shift;

    my $scheduler = shift;

    my $options = shift;

    my $argv = shift;

    if (!@$argv)
    {
	#! perhaps should use $self or so

	$argv = [ 'executable missing', ];
    }

    my $filename;

    # if loading from a URL

    #! e.g. "http://neuromorpho.org/neuroMorpho/dableFiles/dendritica/CNG%20version/v_e_purk3.CNG.swc"

    if ($options->{filename} =~ /^http:/)
    {
	# load the morphology into memory

	use LWP::Simple;

	my $content = get($options->{filename});

	# keep suffix

	$options->{filename} =~ /.*(\.[^\.\/]*)$/;

	my $suffix = $1;

	# create a temporary file

	use File::Temp qw/ tempfile /;

	my $fh;

	($fh, $filename) = tempfile('/tmp/morphologyXXXXXX', defined $suffix ? (SUFFIX => $suffix) : ());

	# save to file

	print $fh $content;
    }

    # if loading a neurospaces .ndf file

    $filename = defined $filename ? $filename : $options->{filename};

    my $ndf;

    if ($filename =~ m(\.ndf$))
    {
	$ndf = $filename;
    }

    # for other morphologies

    else
    {
	# convert the file to a temporary file

	use File::Temp qw/ :POSIX /;

# 	$ndf = tmpnam();

	(undef, $ndf) = tempfile('/tmp/morphologyXXXXXX', OPEN => 0, SUFFIX => '.ndf');

	#t for configuration purposes this needs to be replaced with a module.

	my $command_options = "";

	if ($options->{'force-library'})
	{
	    $command_options .= " --force-library";
	}

	if ($options->{'configuration'})
	{
	    $command_options .= " --configuration \"$options->{'configuration'}\"";
	}

	if ($options->{'no-use-library'})
	{
	    $command_options .= " --no-use-library";
	}

	#! legacy, do not use this one, use the one below instead

	if ($options->{spine_prototype})
	{
	    $command_options .= " --spine-prototypes $options->{spine_prototype}";
	}

	if ($options->{'spine-prototypes'})
	{
	    my $spine_prototypes = $options->{'spine-prototypes'};

	    foreach my $spine_prototype (@$spine_prototypes)
	    {
		$command_options .= " --spine-prototypes $spine_prototype";
	    }
	}

	if ($options->{shrinkage})
	{
	    $command_options .= " --shrinkage $options->{shrinkage}";
	}

	if ($options->{soma_offset})
	{
	    $command_options .= " --soma-offset";
	}

	#t the filename qualification module needs to be lifted out,
	#t must be put in a separate ssp service.

	if (!-e $filename
	    && -e $ENV{NEUROSPACES_NMC_MODELS} . "/$filename")
	{
	    $filename = $ENV{NEUROSPACES_NMC_MODELS} . "/$filename";
	}

	my $executable = $options->{executable} || "morphology2ndf";

	my $command = "$executable $command_options \"$filename\" >\"$ndf\"";

	print "calling $command\n";

	system $command;

	if ($?)
	{
	    die "$0: the command ($command) failed";
	}
    }

    # add backend read options

    if ($options->{backend_options})
    {
	push @$argv, @{$options->{backend_options}};
    }

    # add query machine processing commands to the command line

    if ($options->{commands})
    {
	push
	    @$argv,
		map
		{
		    ( '-Q', $_, );
		}
		    @{$options->{commands}};
    }

    push @$argv, $ndf;

    my $result = $self->read($scheduler, $argv, @_);

    return $result;
}


sub new
{
    my $package = shift;

    my $options = shift || {};

    my $neurospaces = SwiggableNeurospaces::NeurospacesNew();

    my $self
	= {
	   %$options,
	   neurospaces => $neurospaces,
	  };

    bless $self, $package;

    return $self;
}


sub output_2_solverinfo
{
    my $self = shift;

    my $output_info = shift;

    my $component_name = $output_info->{component_name};

    my $field = $output_info->{field};

    #! two error cases:
    #!
    #! 1. the model symbol does not exist, results in
    #!    PidinStackToSerial() returning INT_MAX
    #!
    #! 2. there is no solver for this part of the model.

    my $serial = $self->component_2_serial($component_name);

    if (!defined $serial)
    {
	return "Output $component_name cannot be found";
    }

    # lookup the solver info backend data for the output

    #t component_2_serial() also constructs a context, should recycle

    my $context = SwiggableNeurospaces::PidinStackParse($component_name);

    $context->PidinStackLookupTopSymbol();

    my $solverinfo = SwiggableNeurospaces::SolverInfoRegistrationGet(undef, $context);

    $context->PidinStackFree();

    if (!defined $solverinfo)
    {
	return "No solver info found for $component_name";
    }

    my $solver = $solverinfo->SolverInfoGetSolver();

    if (!defined $solver)
    {
	return "No solver found for $component_name";
    }

    # construct compound result

    my $result
	= {
	   serial => $serial,
	   solver => $solver,
	   type => $field,
	  };

    return $result;
}


sub querymachine
{
    my $self = shift;

    my $query = shift;

    my $backend = $self->backend();

    my $result = $backend->QueryMachineHandle($query);

    return $result;
}


sub read
{
    my $self = shift;

    my $scheduler = shift;

    my $argv = shift;

    if (defined $self->{model_library})
    {
	push @$argv, '-m', $self->{model_library};
    }

    my $result = $self->{neurospaces}->NeurospacesRead($#$argv + 1, $argv, @_);

    return $result;
}


sub register_engine
{
    my $self = shift;

    my $engine = shift;

    my $modelname = shift;

    # set default result : failure

    my $result = 0;

    # convert the modelname to a context

    my $context = SwiggableNeurospaces::PidinStackParse($modelname);

    if (defined $context)
    {
	# get engine name

	my $engine_name = $engine->name();

	if (defined $engine_name)
	{
	    # register the engine name for the this model

	    my $solver_info = SwiggableNeurospaces::SolverInfoRegistrationAddFromContext(undef, $context, $engine_name);

	    if (defined $solver_info)
	    {
		# set result

		$result = 1;
	    }
	}
    }

    # return result

    return $result;
}


sub version
{
    # $Format: "    my $version=\"${package}-${label}\";"$
    my $version="model-container-python-2";

    return $version;
}


1;


