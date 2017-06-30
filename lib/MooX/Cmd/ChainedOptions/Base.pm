package MooX::Cmd::ChainedOptions::Base;

# ABSTRACT: anchor role for chained option roles

use Moo::Role;
use Scalar::Util qw[ blessed ];

use namespace::clean;

our $VERSION = '0.05';

has _parent => (
    is       => 'lazy',
    init_arg => undef,
    builder  => sub {

        my $class = blessed $_[0];

        # Find the element in command chain array which directly
        # precedes the element containing the current class.

        # There is a single array used for the command chain, and it
        # is populated by MooX::Cmd as it processes the command line.
        # This builder may be called for a class after MooX::Cmd has
        # added entries for the class' subcommands, so we can't simply
        # assume that the last element in the array is for this class.

        my $last;
        for ( reverse @{ $_[0]->command_chain } ) {
            next unless $last;
            return $_ if blessed $last eq $class;
        }
        continue { $last = $_ }

        require Carp;
        Carp::croak( "unable to determine parent in chain hierarchy\n" );
    },
);

1;

# COPYRIGHT

__END__

=head1 DESCRIPTION

This role provides the basis for the per-command roles generated by
L<MooX::Cmd::ChanedOptions::Role>.  It provides the C<_parent>
attribute which handles options further up the command chain.
