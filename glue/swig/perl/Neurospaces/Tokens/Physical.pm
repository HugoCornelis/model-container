#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Tokens::Physical;


use strict;


use Neurospaces;


sub create
{
    my $type = shift;

    my $model_container = shift;

    my $target_name = shift;

    # figure out context and name

    $target_name =~ m((.*)/(.*));

    my $path = $1;

    my $name = $2;

    # calloc the type

    my $allocator = ucfirst($type) . "Calloc";

    my $backend = eval "SwiggableNeurospaces::$allocator()";

    # assign name

    #t bug: $name not newly allocated in C space, gets overwritten

    my $pidin = SwiggableNeurospaces::IdinNewFromChars($name);

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


