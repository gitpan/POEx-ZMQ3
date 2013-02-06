
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "POE-enabled asynchronous ZeroMQ components",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "POEx-ZMQ3",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "POEx::ZMQ3",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Moo" => "1.000007",
    "MooX::Role::POE::Emitter" => "0.11",
    "POE" => "1.3",
    "Storable" => 0,
    "ZMQ::Constants" => "1.02",
    "ZMQ::LibZMQ3" => "1.08",
    "namespace::clean" => "0.23",
    "strictures" => 1
  },
  "VERSION" => "0.060001",
  "test" => {
    "TESTS" => "t/*.t t/00_utils/*.t t/01_component/*.t t/02_subclass/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



