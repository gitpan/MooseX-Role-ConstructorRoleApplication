#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'MooseX::Role::ConstructorRoleApplication' ) || print "Bail out!
";
}

diag( "Testing MooseX::Role::ConstructorRoleApplication $MooseX::Role::ConstructorRoleApplication::VERSION, Perl $], $^X" );
