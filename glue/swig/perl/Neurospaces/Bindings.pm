#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#

use strict;


use Neurospaces;


package Neurospaces::Bindings;


sub io_2_list
{
    my $inputs = shift;

    my $result;

    # loop over the given inputs

    foreach my $input (@$inputs)
    {
	my $field = $input->{field};

	my $type = $input->{type};

	# create and initialize the binding

	my $binding = SwiggableNeurospaces::InputOutputNewForType(SwiggableNeurospaces::INPUT_TYPE_INPUT);

	$binding->swig_pcType_set($type);

	my $pidin = IdinNewFromChars($field);

	$pidin->IdinSetFlags(SwiggableNeurospaces::FLAG_IDENTINDEX_INPUTROOT);

	$binding->swig_pidinField_set($pidin);

	# add the binding to the list

	if (!$result)
	{
	    $result = $binding;
	}
	else
	{
	    $binding->swig_pioFirst_set($result->swig_pioFirst_get());

	    $binding->swig_pioNext_set($result);

	    $result = $binding;
	}
    }

    # return result

    return($result);
}


sub assign_inputs
{
    my $component = shift;

    my $inputs = shift;

    # create an io list from the given inputs

    my $bindings = io_2_list($inputs);

    # add it to the component

    my $context = SwiggableNeurospaces::PidinStackParse($component);

    my $symbol = $context->PidinStackLookupTopSymbol();

    $symbol->SymbolAssignInputs($bindings);

####### equivalent C code

# 		    //- allocate I/O relation

# 		    struct symtab_InputOutput
# 			*pio = InputOutputNewForType(INPUT_TYPE_INPUT);

# 		    //- remove ending '"'

# 		    $3->pcString[$3->iLength - 1] = '\0';

# 		    //! allocates one to much

# 		    char *pc = calloc(sizeof(char), $3->iLength);

# 		    strcpy(pc, &$3->pcString[1]);

# 		    //- store type

# 		    pio->pcType = pc;

# 		    //- store idin

# 		    pio->pidinField = $5;

# 		    //- set TOKEN_INPUT flag for root idin $5

# 		    IdinSetFlags($5, FLAG_IDENTINDEX_INPUTROOT);

}


sub assign_bindable_IO
{
    my $component = shift;

    my $ios = shift;

    # create an io list from the given inputs

    my $bindings = io_2_list($ios);

    # convert the io list to a bindables container

    my $bindables = SwiggableNeurospaces::IOContainerNewFromIO($bindings);

    # add the container to the component

    my $context = SwiggableNeurospaces::PidinStackParse($component);

    my $symbol = $context->PidinStackLookupTopSymbol();

    $symbol->SymbolAssignBindableIO($bindables);
}


1;



