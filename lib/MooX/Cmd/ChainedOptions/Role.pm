package MooX::Cmd::ChainedOptions::Role;

# ABSTRACT: generate per-command roles to handle chained options

use strict;
use warnings;

our $VERSION = '0.03_02';

use Package::Variant
  importing => ['Moo::Role'],
  subs      => [ 'has', 'with' ];

use namespace::clean -except => [ 'build_variant' ];

=pod

=for pod-coverage

=head2 make_variant

=head2 build_variant

=cut
sub make_variant {

    my ( $class, $target, $parent, $role ) = @_;

    with $role;

    has '+_parent' => (
        is      => 'lazy',
        handles => [ keys %{ { $parent->_options_data } } ],
    );

}

1;

# COPYRIGHT

__END__

=head1 DESCRIPTION

This role factory builds upon L<MooX::Cmd::ChainedOptions::Base>.  It
creates a role for each command which augments the C<_parent>
attribute from the similar role for the next higher command in the
command chain to handle the options from that next higher command.
