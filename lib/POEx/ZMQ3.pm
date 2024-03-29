package POEx::ZMQ3;
$POEx::ZMQ3::VERSION = '0.071';
use strictures 1;
use Carp;

sub import {
  my ($self, @modules) = @_;
  my $pkg = caller;

  my @failed;
  for my $mod (@modules) {
    my $c = "package $pkg; use POEx::ZMQ3::$mod;";
    eval $c;
    if ($@) { carp $@; push @failed, $mod }
  }
  
  confess "Failed to import ".join ' ', @failed if @failed;
  
  1
}

=pod

=for Pod::Coverage new

=cut

sub new {
  my $class = shift;
  require POEx::ZMQ3::Sockets;
  POEx::ZMQ3::Sockets->new
}

1;


=pod

=head1 NAME

POEx::ZMQ3 - **DEPRECATED** See POEx::ZMQ instead

=head1 SYNOPSIS

  use POEx::ZMQ3;
  # A POEx::ZMQ3::Sockets instance:
  my $zmq = POEx::ZMQ3->new;
  # See POEx::ZMQ3::Sockets for a complete example.

=head1 DESCRIPTION

B<< This distribution is deprecated and known broken with ZMQ4+! >>
It will likely be deleted in the future.

B<< See L<POEx::ZMQ> instead >>. As of this writing, developer releases are
available on CPAN, and you can help by contributing issues and/or fixes for
same at L<http://www.github.com/avenj/poex-zmq>.

A set of roles and classes providing a L<POE>-enabled asynchronous interface
to B<ZeroMQ> (version 3) via L<ZMQ::LibZMQ3>.

ZeroMQ is a powerful high-performance messaging library aimed at
concurrent/distributed applications. If you're just getting started with
ZeroMQ, it is strongly advised you read the B<zguide>
(L<http://zguide.zeromq.org>) before jumping in.

You will need B<zeromq-3.2.2> or newer: L<http://www.zeromq.org>

This is early development software; see L</BUGS>.

=head2 Classes

L<POEx::ZMQ3::Sockets> is the backend ZMQ component. It can be used directly
to add flexible ZeroMQ functionality to your POE applications.

There are some higher-level components providing simple access to single
sockets belonging to basic types:

L<POEx::ZMQ3::Publisher> and L<POEx::ZMQ3::Subscriber> implement PUB and SUB
type ZeroMQ sockets.

L<POEx::ZMQ3::Requestor> and L<POEx::ZMQ3::Replier> implement REQ and REP type
sockets.

These are very simple base implementations. They can be subclassed or combined
in varied ways to do more powerful things. 
As of this writing, more advanced socket types are lacking component classes,
but these can be easily implemented with L<POEx::ZMQ3::Sockets>.

=head2 Roles

L<MooX::Role::POE::Emitter> provides L<POE> event emitter functionality and
some endpoint management methods.

=head1 CAVEATS

=head2 Forking

If your application forks, the global context object needs to be reset by 
calling C<< POEx::ZMQ3::Context->reset >> before creating sockets. 
See L<POEx::ZMQ3::Context>.

=head1 BUGS

Probably many undiscovered; this software is fairly early in development.

See L<http://github.com/avenj/poex-zmq3> and feel free to report bugs via
either B<RT> or B<GitHub>.

=head1 SEE ALSO

The C<examples/> directory in the distribution and perhaps the tests in C<t/>.

L<ZMQ::LibZMQ3>

L<http://www.zeromq.org>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
