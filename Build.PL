use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::Role::ConstructorRoleApplication',
    license             => 'perl',
    dist_author         => q{Fraser Tweedale <frasert@jumbolotteries.com>},
    dist_version_from   => 'lib/MooseX/Role/ConstructorRoleApplication.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Moose' => 0,
    },
    add_to_cleanup      => [ 'MooseX-Role-ConstructorRoleApplication-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
