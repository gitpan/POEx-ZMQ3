
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.08

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/POEx/ZMQ3.pm',
    'lib/POEx/ZMQ3/Context.pm',
    'lib/POEx/ZMQ3/Publisher.pm',
    'lib/POEx/ZMQ3/Replier.pm',
    'lib/POEx/ZMQ3/Requestor.pm',
    'lib/POEx/ZMQ3/Role/Emitter.pm',
    'lib/POEx/ZMQ3/Sockets.pm',
    'lib/POEx/ZMQ3/Sockets/ZMQSocket.pm',
    'lib/POEx/ZMQ3/Subscriber.pm',
    't/00-report-prereqs.t',
    't/00_utils/context.t',
    't/00_utils/loader.t',
    't/01_component/pub_sub.t',
    't/01_component/pub_sub_multi.t',
    't/01_component/rep_req.t',
    't/02_subclass/publisher_subscriber.t',
    't/02_subclass/requestor_replier.t',
    't/release-cpan-changes.t',
    't/release-dist-manifest.t',
    't/release-no-tabs.t',
    't/release-pod-coverage.t',
    't/release-pod-linkcheck.t',
    't/release-pod-syntax.t',
    't/release-synopsis.t'
);

notabs_ok($_) foreach @files;
done_testing;
