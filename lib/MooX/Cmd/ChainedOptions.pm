package MooX::Cmd::ChainedOptions;

# ABSTRACT: easily access options from higher up the command chain

use strict;
use warnings;

our $VERSION = '0.03_02';

use Import::Into;
use Moo::Role     ();
use MooX::Options ();

use MooX::Cmd::ChainedOptions::Role ();
use List::Util qw/ first /;

use namespace::clean;

my %ROLE;

sub import {

    shift;
    my $target = caller;

    unless ( $target->DOES( 'MooX::Cmd::Role' ) ) {
        require Carp;
        Carp::croak( "$target must use MooX::Cmd prior to using ",
            __PACKAGE__, "\n" );
    }

    # don't do this twice
    return if $ROLE{$target};

    # load MooX::Options into target class.
    MooX::Options->import::into( $target );

    # guess if an app or a command

    # if $target is a cmd, a parent class (app or cmd) must have
    # been loaded.  $target must be a direct descendant of a
    # parent class' command_base.  use the _build_command_base method
    # as it can be used as a class method; command_base is an object method

    my ( $base ) = $target =~ /^(.*)?::([^:]+)$/;
    $base ||= '';
    my $parent = first { $base eq $_->_build_command_base } keys %ROLE;

    $ROLE{$target}
      = $parent
      ? MooX::Cmd::ChainedOptions::Role->build_variant( $parent,
        $ROLE{$parent} )
      : __PACKAGE__ . '::Base';

    # need only apply role to commands & subcommands
    Moo::Role->apply_roles_to_package( $target, $ROLE{$target} )
      if $parent;

    return;
}

1;

# COPYRIGHT

__END__

=pod

=head1 SYNOPSIS

  # MyApp.pm : App Base Class
  use Moo;
  use MooX::Cmd;
  use MooX::Cmd::ChainedOptions;

  option app_opt => ( is => 'ro', format => 's', default => 'BASE' );

  sub execute {
      print $_[0]->app_opt, "\n";
  }

  # MyApp/Cmd/cmd.pm : Command Class
  package MyApp::Cmd::cmd;
  use Moo;
  use MooX::Cmd;
  use MooX::Cmd::ChainedOptions;

  option cmd_opt => ( is => 'ro', format => 's', default => 'A' );

  sub execute {
      print $_[0]->app_opt, "\n";
      print $_[0]->cmd_opt, "\n";
  }

  # MyApp/Cmd/cmd/Cmd/subcmd.pm : Sub-Command Class
  package MyApp::Cmd::cmd::Cmd::subcmd;
  use Moo;
  use MooX::Cmd;
  use MooX::Cmd::ChainedOptions;

  option subcmd_opt => ( is => 'ro', format => 's', default => 'B' );

  sub execute {
      print $_[0]->app_opt, "\n";
      print $_[0]->cmd_opt, "\n";
      print $_[0]->subcmd_opt, "\n";
  }

=head1 DESCRIPTION

For applications using L<MooX::Cmd> and L<MooX::Options>,
B<MooX::Cmd::ChainedOptions> transparently provides access to command
line options from further up the command chain.

For example, if an application provides options at each level of the
command structure:

  app --app-opt cmd --cmd-opt subcmd --subcmd-opt

The B<subcmd> object will have direct access to the C<app_option> and
C<cmd_option> options via object attributes:

  sub execute {
      print $self->app_opt, "\n";
      print $self->cmd_opt, "\n";
      print $self->subcmd_opt, "\n";
  }


=head1 USAGE

Simply

  use MooX::Cmd::ChainedOptions;

instead of

  use MooX::Options;

Every layer in the application hierarchy (application class, command
class, sub-command class) must use B<MooX::Cmd::ChainedOptions>.  See
the L</SYNOPSIS> for an example.

=head1 SEE ALSO

