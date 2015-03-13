package MyApp::Cmd::A::Cmd::B;

use 5.10.0;

use Moo;
use MooX::Cmd;
use MooX::Cmd::ChainedOptions;

option b_opt => ( is => 'ro',
		  format => 's',
		  default => 'b_opt_v',
 );

sub execute {

    my $self = shift;

    say __PACKAGE__;

    say "$_ ", $self->$_ for qw/ base_opt a_opt b_opt /;

}


1;
