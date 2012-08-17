#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Tokens::Physical;


use strict;


use Neurospaces;


sub identifier_perl_to_xml
{
    my $identifier = shift;

    my $result = $identifier;

    $result =~ s/^([a-z])/\u$1/;

    $result =~ s/_([a-z0-9])/\u$1/g;

    return $result;
}


sub create
{
    my $type = shift;

    my $model_container = shift;

    my $target_name = shift;
print "--- type is $type, mc is $model_container, target name is $target_name\n";
    # figure out context and name

    $target_name =~ m((.*)/(.*));

    my $path = $1;

    my $name = $2;
print "path is '$1', name is '$2'!!!\n\n";
    # calloc the type

    my $ctype = identifier_perl_to_xml($type);

#     print STDERR "Mapped $type to $ctype for symbol allocation\n";

    my $allocator = $ctype . "Calloc";

#     my $allocator = ucfirst($type) . "Calloc";

    my $backend = eval "SwiggableNeurospaces::$allocator()";

    # if it does not have its own allocator we fall back on the group
    # type, this is a hack to get access to the chemesis3 tokens.

    if (not $backend)
    {
	$type = 'group';

	$allocator = ucfirst($type) . "Calloc";

	$backend = eval "SwiggableNeurospaces::$allocator()";
    }

    # assign name

    #t bug: $name not newly allocated in C space, gets overwritten
print "name is '$name'!!!!";
    my $pidin = SwiggableNeurospaces::IdinCallocUnique($name);

#     no strict "refs";

#     print Data::Dumper::Dumper(\%{"SwiggableNeurospaces::"});

    my $caster = "SwiggableNeurospaces::cast_${type}_2_symbol";

    my $s = $backend->$caster();

    $s->SymbolSetName($pidin);

    my $self
	= {
	   backend => $backend,
	  };

    #t $model_container->create($parent, $target_name);
print "******* Making a context out of path '$path'\n";
    my $context = SwiggableNeurospaces::PidinStackParse($path);

    if (!defined $context)
    {
	die "$0: Cannot create context $path (does it exist ?)";
    }

    my $model_container_backend = $model_container->backend();

    my $sym = $model_container_backend->swig_psym_get();

    my $parent = $sym->SymbolsLookupHierarchical($context);

    if (!defined $parent)
    {
	die "$0: Cannot find context symbol $path (does it exist ?)";
    }

    my $success = $parent->SymbolAddChild($backend->$caster());

    if (!$success)
    {
	die "$0: Backend SymbolAddChild() child failed";
    }

    $success = SwiggableNeurospaces::SymbolRecalcAllSerials(undef, undef);

    if (!$success)
    {
	die "$0: Backend recalculating serials failed";
    }

    return $self;
}


1;


