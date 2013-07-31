
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "POE-enabled asynchronous ZeroMQ components",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {},
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
    "MooX::Role::Pluggable::Constants" => 0,
    "POE" => "1.3",
    "POSIX" => 0,
    "Storable" => 0,
    "ZMQ::Constants" => "1.02",
    "ZMQ::LibZMQ3" => "1.08",
    "namespace::clean" => "0.23",
    "strictures" => 1
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.88"
  },
  "VERSION" => "0.060003",
  "test" => {
    "TESTS" => "t/*.t t/00_utils/*.t t/01_component/*.t t/02_subclass/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

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



