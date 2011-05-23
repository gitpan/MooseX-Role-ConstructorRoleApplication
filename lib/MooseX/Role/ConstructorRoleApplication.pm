package MooseX::Role::ConstructorRoleApplication;

use warnings;
use strict;

=head1 NAME

MooseX::Role::ConstructorRoleApplication - apply roles during construction

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

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


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Benon Technologies Pty Ltd

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MooseX::Role::ConstructorRoleApplication
