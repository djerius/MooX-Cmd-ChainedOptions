package MyApp::Chain;

use 5.10.0;

my $PACKAGE = __PACKAGE__;

use Package::Variant
  importing => ['Moo::Role'],
  subs      => [ 'has', 'with', 'after' ];

my %OPTIONS;

use Scalar::Util qw[ blessed ];


sub make_variant {

    my ( $class, $target, $base, $parent ) = @_;

    $base =~ s/${PACKAGE}:://;

    if ( $parent ) {

        $parent =~ s/${PACKAGE}:://;

        my $chained_parent = join( '::', __PACKAGE__, $parent );

        with $chained_parent;

	$OPTIONS{$parent}{options} ||= [ keys %{ { $parent->_options_data } } ];
        $OPTIONS{$base} = { parent => $parent };

        has '+_parent' => (
            is      => 'lazy',
            handles => $OPTIONS{$parent}{options},
        );
    }

    else {

        install BUILD => sub { };
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

        $OPTIONS{$base} = {
            parent  => undef,
        };

    }
}


1;

