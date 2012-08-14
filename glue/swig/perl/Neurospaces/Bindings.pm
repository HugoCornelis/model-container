#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#

use strict;


use Neurospaces;


package Neurospaces::Bindings;


sub input_add
{
    my $component = shift;

    my $field = shift;

    my $type = shift;

    my $context = SwiggableNeurospaces::PidinStackParse($component);

    my $symbol = $context->PidinStackLookupTopSymbol();

    my $binding = SwiggableNeurospaces::InputOutputNewForType(SwiggableNeurospaces::INPUT_TYPE_INPUT);

    $binding->swig_pcType_set($type);

    $binding->swig_pidinField_set($field);

    $field->IdinSetFlags(SwiggableNeurospaces::FLAG_IDENTINDEX_INPUTROOT);

    #t still need to do something with $component

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


1;



