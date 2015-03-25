use strict;
use warnings;
use inc::Module::Install;

name 'MooX-Cmd-ChainedOptions';
license 'gpl3';
auto_license( holder => 'Smithsonian Astrophysical Observatory' );
all_from 'lib/MooX/Cmd/ChainedOptions.pm';

author_tests( 'xt' );

tests_recursive;

repository 'https://bitbucket.org/djerius/moox-cmd-chainedoptions';

cpanfile;

WriteAll;
