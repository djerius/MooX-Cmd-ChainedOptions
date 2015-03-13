package MyApp::Cmd::A;

use 5.10.0;
use Moo;
use MooX::Cmd;
use MooX::Cmd::ChainedOptions;

option a_opt => ( is => 'ro',
		  format => 's',
		  default => 'a_opt_v',
 );

sub execute {

    my $self = shift;

    say __PACKAGE__;

    say "$_ ", $self->$_ for qw/ base_opt a_opt  /;

}

1;

