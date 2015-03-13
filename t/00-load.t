#!perl -T

use Test::More tests => 10;

BEGIN {
  use_ok('MooX::Cmd::ChainedOptions');
  use_ok('MooX::Cmd::ChainedOptions::Base');
  use_ok('MooX::Cmd::ChainedOptions::Role');
  use_ok('MyApp');
  use_ok('MyApp::Chain');
  use_ok('MyApp::Chain::MyApp');
  use_ok('MyApp::Chain::MyApp::Cmd::A');
  use_ok('MyApp::Chain::MyApp::Cmd::A::Cmd::B');
  use_ok('MyApp::Cmd::A');
  use_ok('MyApp::Cmd::A::Cmd::B');
}

diag( "Testing MooX::Cmd::ChainedOptions $MooX::Cmd::ChainedOptions::VERSION, Perl $], $^X" );
