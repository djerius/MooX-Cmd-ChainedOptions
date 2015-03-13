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

package MooX::Cmd::ChainedOptions::Base;

use Moo::Role;
use Scalar::Util qw[ blessed ];

sub BUILD { }

after BUILD => sub { $_[0]->_parent };

has _parent => (
    is       => 'lazy',
    init_arg => undef,
    builder  => sub {

        for ( reverse @{ $_[0]->command_chain } ) {

            return $_ if blessed( $_[0] ) ne blessed $_;

        }

        return;
    },
);


1;
