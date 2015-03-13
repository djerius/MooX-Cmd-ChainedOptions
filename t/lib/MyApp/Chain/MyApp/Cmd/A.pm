package MyApp::Chain::MyApp::Cmd::A;

use Moo::Role;
use MyApp::Chain;

with Chain( __PACKAGE__, 'MyApp' );

1;

