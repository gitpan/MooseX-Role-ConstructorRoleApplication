package MooseX::Role::ConstructorRoleApplication;

use warnings;
use strict;

=head1 NAME

MooseX::Role::ConstructorRoleApplication - apply roles right after construction

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';


=head1 SYNOPSIS

    package Foo;
    use Moose;
    with 'MooseX::Role::ConstructorRoleApplication';

    # construct a Foo that also does My::Role and My::OtherRole
    my $foo = Foo->new(apply => ['My::Role', 'My::OtherRole']);


=head1 DESCRIPTION

Adds the C<apply> argument to classes into which this role is composed.
The value must be an array reference of names of roles to apply to the
new instance.

It does not apply the roles to the class itself, so other instances
may be constructed I<without> the roles.

This role is similar in purpose to L<MooseX::Traits> but applies roles into
the class instance immediately after construction, rather than creating an
anonymous class before the new object is instantiated.

The advantage of this module over C<MooseX::Traits> module is the role
application is accomplished with a single call to C<new>, the invocant being
the original class rather than an anonymous class.  This allows use with,
e.g., L<Test::More>'s C<new_ok>, and is the only reason to prefer this module
over C<MooseX::Traits> of which the author is aware.

C<MooseX::Traits> does provide a C<new_with_traits> class method if you
wish to accomplish role application and construction in a single call in
your own code.

   # using MooseX::Role::ConstructorRoleApplication
   my $obj = Class->new(apply=>['Role']);

   # using MooseX::Traits
   my $obj = Class->with_traits('Role')->new;

Of course, if using C<MooseX::Role::ConstructorRoleApplication>, you
cannot supply to the constructor values for attributes provided by the
role (or roles) that are yet to be applied.  Such values must be set
after the object is instantiated.  Some mechanism to set role attributes
may exist in a future version.

=cut

use Moose::Role;
use Moose::Meta::Role;

requires 'BUILD';

has 'apply' => ( is => 'ro', isa => 'ArrayRef[Str]', default => sub { [] } );

before 'BUILD' => sub {
	my $self = shift;
	for (@{$self->apply}) {
		my %namespace = eval '%' . $_ . '::';
		unless (grep { !/::$/ } keys %namespace) {
			eval "require $_";
			die $@ if $@;
		}
		Moose::Meta::Role->initialize($_)->apply($self);
	}
};


=head1 AUTHOR

Fraser Tweedale, C<< <frasert at jumbolotteries.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-role-constructorroleapplication at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Role-ConstructorRoleApplication>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Role::ConstructorRoleApplication


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Role-ConstructorRoleApplication>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Role-ConstructorRoleApplication>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Role-ConstructorRoleApplication>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Role-ConstructorRoleApplication/>

=back


=head1 SEE ALSO

L<MooseX::Traits> is a module similar in purpose that performs role
performs role application prior to, rather than after, instantiation.
In most cases, a better choice than this module.


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Benon Technologies Pty Ltd

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MooseX::Role::ConstructorRoleApplication
