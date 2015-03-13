# --8<--8<--8<--8<--
#
# Copyright (C) 2015 Smithsonian Astrophysical Observatory
#
# This file is part of MooX-Cmd-ChainedOptions
#
# MooX-Cmd-ChainedOptions is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -->8-->8-->8-->8--

package MooX::Cmd::ChainedOptions;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp;

use Import::Into;
use Moo::Role     ();
use MooX::Options ();

use MooX::Cmd::ChainedOptions::Role ();

use Module::Runtime qw/ use_package_optimistically /;

my %ROLE;

my %optdef = ( -base => 0, -parent => 1 );

sub import {

    my $class  = shift;
    my $target = caller;

    my %opt;
    while ( @_ ) {
        my $opt = shift;
        croak( "unknown import option: $opt\n" )
          unless exists $optdef{$opt};
        $opt{$opt} = $optdef{$opt} ? shift : 1;
    }

    MooX::Options->import::into( $target );

    # if neither base nor parent specified , lets try and guess

    $opt{-base} ||= ! $opt{-parent} && $target !~ /::Cmd::/;


    if ( $opt{-base} ) {

	croak( "$target isn't a MooX::Cmd\n" )
	  unless Moo::Role::does_role( $target, 'MooX::Cmd::Role' );

        $ROLE{$target} = __PACKAGE__ . '::Base';


    }

    else {

        # find parent command
        if ( !$opt{-parent} ) {

            ( my $command_base = $target ) =~ s/::(?:[^:]+)$//;

            # check if the standard naming scheme is used
            if ( $command_base =~ /::Cmd/ ) {

                ( my $parent = $command_base ) =~ s/::(?:[^:]+)$//;

                $opt{-parent} = eval {
                    use_package_optimistically( $parent )->_build_command_base eq
                      $command_base && $parent
                };

                croak(
                    "cannot determine parent command automatically; please use the parent import option\n"
		    ) if !$opt{-parent};
            }

        }

	use_package( $opt{-parent} ) unless exists $ROLE{$opt{-parent}};
	croak( "$opt{-parent} didn't use ", __PACKAGE__, "\n" )
	    unless exists $ROLE{$opt{-parent}};

	$ROLE{$target}
              = MooX::Cmd::ChainedOptions::Role->build_variant( $opt{-parent},
								$ROLE{$opt{-parent} } );

    }

    Moo::Role->apply_roles_to_package( $target, $ROLE{$target} );
}

1;
