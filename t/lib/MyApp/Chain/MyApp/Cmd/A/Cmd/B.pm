package MyApp::Chain::MyApp::Cmd::A::Cmd::B;

use Moo::Role;
use MyApp::Chain;

with Chain( __PACKAGE__, 'MyApp::Cmd::A' );

1;

