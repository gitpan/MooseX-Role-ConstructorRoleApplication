package My::Foo;
use Moose;
with 'MooseX::Role::ConstructorRoleApplication';
sub BUILD { }
sub foo { }

package My::Role::Bar;
use Moose::Role;
sub bar { }


package main;
use Test::More;
use Test::Exception;
use Test::Moose;

plan tests => 19;

# make a Foo that doesn't Bar
my $foo = new_ok 'My::Foo' or die 'constructor failed';
does_ok $foo, 'MooseX::Role::ConstructorRoleApplication';
can_ok $foo, 'foo';
ok !$foo->does('My::Role::Bar'), '$foo does not Bar';
ok !$foo->can('bar'), '$foo can not bar()';
dies_ok { $foo->bar } '$foo dies when it tries to bar()';

# make a Foo that does Bar
my $foobar = new_ok 'My::Foo', [ apply => [ 'My::Role::Bar' ] ];
does_ok $foobar, 'MooseX::Role::ConstructorRoleApplication';
can_ok $foobar, 'foo';
does_ok $foobar, 'My::Role::Bar';
can_ok $foobar, 'bar';
lives_ok { $foobar->bar } '$foobar lives when it tries to bar()';

# make sure that the role hasn't been applied to Foo (the class)
$foo = new_ok 'My::Foo' or die 'constructor failed';
does_ok $foo, 'MooseX::Role::ConstructorRoleApplication';
can_ok $foo, 'foo';
ok !$foo->does('My::Role::Bar'), '$foo does not Bar';
ok !$foo->can('bar'), '$foo can not bar()';
dies_ok { $foo->bar } '$foo dies when it tries to bar()';

# try to apply a nonexistant role
dies_ok { my $foobaz = My::Foo->new(apply => [ 'My::Role::Baz' ]) }
	'construction with application of nonexistant role dies';;
