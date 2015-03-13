package MyApp;

use 5.10.0;

use Moo;
use MooX::Cmd;
use MooX::Cmd::ChainedOptions;

option base_opt => ( is => 'ro',
		     format => 's',
		     default => 'base_opt_v',
 );

sub execute {

    my $self = shift;

    say __PACKAGE__;

    say "$_ ", $self->$_ for qw/ base_opt  /;

};


1;
