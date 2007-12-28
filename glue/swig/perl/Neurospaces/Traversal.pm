#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package Neurospaces::Traversal;


use strict;


use SwiggableNeurospaces;


sub go
{
    my $self = shift;

    my $neurospaces = $self->{neurospaces};

    my $worker = $self->{worker};

    $worker->{context} = SwiggableNeurospaces::PidinStackParse($self->{context});

    $worker->{traversal}
	= SwiggableNeurospaces::treespace_traversal_new
	    (
	     $worker->{context},
	     $self,
	     $self->{selector},
	     $self->{processor},
	     $self->{finalizer},
	    );

#     print "Traversal is: \n";

#     use Data::Dumper;

#     print Dumper($worker->{traversal});

    SwiggableNeurospaces::treespace_traversal_go($worker->{traversal});
}


sub new
{
    my $package = shift;

    my $options = shift || {};

    my $self
	= {
	   %$options,
	  };

    $self->{worker} = {};

    bless $self, $package;

    return $self;
}


1;


