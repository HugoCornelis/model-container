#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#

use strict;


use Neurospaces;


package Neurospaces::Components;


my $neurospaces_mapping
    = {
       cell => {
		constructor_settings => {
# 					 iTable => -1,
					},
		internal_factory => 'CellCalloc',
		internal_name => 'symtab_Cell',
		translators => {
				parameters => {
					       source => 'activator_parameters',
					       target => 'parameters',
					      },
			       },
	       },
       segment => {
		   internal_factory => 'SegmentCalloc',
		   internal_name => 'symtab_Segment',
		  },
      };


sub new
{
    my $package = shift;

    my $subpackage = shift;

    my $type = shift;

    my $settings = shift;

    if (!exists $neurospaces_mapping->{$type})
    {
	return "$type is not a Neurospaces::Component";
    }

    # create the neurospaces internal object

    my $self;

    my $internal_factory = $neurospaces_mapping->{$type}->{internal_factory};

    if ($internal_factory)
    {
	my $factory_package = "SwiggableNeurospaces::$internal_factory";

	no strict "refs";

	$self
	    = {
	       $type => &$factory_package(),
	      };
    }
    else
    {
	my $internal_name = $neurospaces_mapping->{$type}->{internal_name};

	my $factory_package = "SwiggableNeurospaces::$internal_name";

	$self
	    = {
	       $type => $factory_package->new(),
	      };
    }

    # never forget to set the neurospaces type

    my $type_number = $neurospaces_mapping->{$type}->{type_number};

    if ($type_number)
    {
	my $mc = $self->{$type}->swig_mc_get();

	$mc->swig_iType_set($type_number);
    }

    # base initialization done

    #! implicit assumption that this is a Neurospaces::Component, but can be overriden

    bless $self, $package;

    # apply constructor settings

    $self->settings($type, $neurospaces_mapping->{$type}->{constructor_settings});

    # apply user settings

    $self->settings($type, $settings);

    # return result

    return $self;
}


sub settings
{
    my $self = shift;

    my $type = shift;

    my $settings = shift;

    # just apply all the settings, the missing ones are under
    # default control of the C code

    foreach my $setting (keys %$settings)
    {
	# get target name in neurospaces internal

	my $target = $setting;

	my $value = $settings->{$setting};

# 	if (ref $value eq 'HASH')
# 	{
# 	    no strict "refs";

# 	    my $Component = identifier_perl_to_xml($target);

# 	    my $constructor = "Neurospaces::${Component}::new";

# 	    $value = &$constructor($Component, $value);
# 	}

	# if there is a translator for this setting

	my $translator = $neurospaces_mapping->{$type}->{translators}->{$setting};

	if ($translator)
	{
	    # translate the target

	    $target = $translator->{target};

	    # translate the value

	    # for a custom value convertor

	    if ($translator->{convertor})
	    {
		# call custom value convertor

		my $convertor = $translator->{convertor};

		$value = &$convertor($target, $value);;
	    }

	    # for a simple source to target translator

	    #! so the constructor_settings entry applies this hook too,
	    #! and perhaps already created the object

	    elsif ($translator->{source})
	    {
		# if still needs translation

		if (!exists $value->{$translator->{source}})
		{
		    # get the factory method for the target object

		    my $source = $translator->{source};

		    my $factory_source = "Neurospaces::" . identifier_perl_to_xml($source);

		    # translate the source structure to a target object

		    $value = $factory_source->new($value);

		    # fetch the target object

		    $value = $value->{$source};
		}

		# else the constructor_settings has already constructed the target object

		else
		{
		    # fetch the target object

		    $value = $value->{$setting};
		}
	    }

	    # else

	    else
	    {
		# default is dereference via the setting name, which
		# presumably gives the neurospaces internal structure

		$value = $value->{$setting};
	    }
	}

	# if there was a target

	if (defined $target)
	{
	    # set the neurospaces internal target

	    my $subname = "swig_${target}_set";

	    $self->{$type}->$subname($value);
	}

	# else

	else
	{
	    # the convertor has done the necessary setting, or a void

	    #! see e.g. configuration, module_name and service_name for the neurospaces entry

	    # but it is useful to keep the original

	    #! allows to set runtime configuration options

	    $self->{$setting} = $settings->{$setting};
	}
    }

    return $self;
}


sub identifier_xml_to_perl
{
    my $identifier = shift;

    my $result = $identifier;

    $result =~ s/([A-Z]{2,})([A-Z])/_\L$1\E$2/g;

    $result =~ s/([A-Z])(?![A-Z])/_\l$1/g;

    return $result;
}


sub identifier_perl_to_xml
{
    my $identifier = shift;

    my $result = $identifier;

    $result =~ s/^([a-z])/\u$1/;

    $result =~ s/_([a-z0-9])/\u$1/g;

    return $result;
}


# construct factory method for each Neurospaces component

foreach my $component (keys %$neurospaces_mapping)
{
    my $Component = identifier_perl_to_xml($component);

    print "For $component -> $Component\n";

    my $code = "
package Neurospaces::Components::$Component;

sub new
{
    my \$package = shift;

    my \$result = Neurospaces::Components->new(\$package, '$component', \@_, );

    if (ref \$result)
    {
# 	print YAML::Dump('var1:', \$result, 'var2:', \$package);

	return bless \$result, \$package;
    }
    else
    {
	return \$result;
    }
}


sub neurospaces_object
{
    my \$self = shift;

    my \$result = \$self->{$component};

    return \$result;
}


sub backend
{
    my \$self = shift;

    my \$result = \$self->{$component};

    return \$result;
}


sub backend_hsle
{
    my \$self = shift;

    my \$backend = \$self->backend();

    my \$subname = 'SwiggableNeurospaces::swig_' . lcfirst('$component') . '_get_object';

    no strict 'refs';

    my \$result = &\$subname(\$backend);

    return \$result;
}


sub set_name
{
    my \$self = shift;

    my \$name = shift;

    my \$backend = \$self->backend_hsle();

#     use Data::Dumper;

#     print Dumper(\$backend);

    my \$pidin = SwiggableNeurospaces::IdinCallocUnique(\$name);

    SwiggableNeurospaces::SymbolSetName(\$backend, \$pidin);
}


";

    my $result = eval $code;

    if ($@)
    {
	die "$0: In Neurospaces/Components.pm: error constructing $component factory methods: $@";
    }
}


1;


