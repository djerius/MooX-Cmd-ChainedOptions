#!perl

on runtime => sub {
    requires 'Import::Into';
    requires 'Moo' => '1.001'; # non-sub defaults
    requires 'Moo::Role';
    requires 'MooX::Cmd' => '0.009';
    requires 'MooX::Options';
    requires 'Package::Variant';
    requires 'Scalar::Util';
};

on test => sub {

    requires 'Test::More';
    requires 'Test::Fatal';
    requires 'MooX::Cmd::Tester';

};

on develop => sub {

    requires 'Module::Install';
    requires 'Module::Install::AuthorRequires';
    requires 'Module::Install::AuthorTests';
    requires 'Module::Install::AutoLicense';
    requires 'Module::Install::CPANfile';

    requires 'Test::CPAN::Changes';
    requires 'Test::NoBreakpoints';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Test::Perl::Critic';
};
