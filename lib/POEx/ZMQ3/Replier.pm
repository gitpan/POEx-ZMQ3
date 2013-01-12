package POEx::ZMQ3::Replier;

use Carp;
use Moo;
use POE;

use namespace::clean;

sub ZALIAS () { 'rep' }

with 'POEx::ZMQ3::Role::Emitter';

has listen => (
  is => 'ro',
  default => sub { [] },
);

sub build_defined_states {
  my ($self) = @_;
  [
    $self => [ qw/
      emitter_started
      zmqsock_recv
    /],
  ],
}

sub start {
  my ($self, @endpoints) = @_;

  push @{ $self->listen }, @endpoints;
  $self->zmq->start;
  $self->zmq->create( ZALIAS, 'REP' );

  $self->_start_emitter;
}

sub emitter_started {
  my ($kernel, $self) = @_[KERNEL, OBJECT];

  $poe_kernel->call( $self->zmq->session_id, subscribe => 'recv' );

  while (my $target = shift @{ $self->listen }) {
    $self->add_bind( ZALIAS, $target )
  }
}

after add_bind => sub {
  my ($self, $alias, $endpoint) = @_;
  $self->emit( 'replying_on', $endpoint )
};

sub stop {
  my ($self) = @_;
  $self->zmq->stop;
  $self->_shutdown_emitter
}

sub reply {
  my ($self, $data) = @_;
  $self->zmq->write( ZALIAS, $data )
}

sub zmqsock_recv {
  my ($kernel, $self) = @_[KERNEL, OBJECT];
  my ($alias, $data) = @_[ARG0, ARG1];
  $self->emit( 'got_request', $data );
}

1;

=pod

=head1 NAME

POEx::ZMQ3::Replier - A REP-type ZeroMQ socket

=head1 SYNOPSIS

  use POE;

  my $zrep = POEx::ZMQ3::Replier->new;

  POE::Session->create(
    inline_states => {

      _start => sub {
        ## Wait for requests on an endpoint:
        $zrep->start( 'tcp://127.0.0.1:5665' );
        ## Subscribe to all emitted events:
        $_[KERNEL]->post( $zrep->session_id,
          'subscribe',
          'all',
        );
      },

      zeromq_replying_on => sub {
        my $endpoint = $_[ARG0];
        print "Waiting for requests on $endpoint\n";
      },

      zeromq_got_request => sub {
        my $data = $_[ARG0];
        ## Got a request we can reply to.
        $zrep->reply("pong!")
      },

    }
  );

  $poe_kernel->run;

=head1 DESCRIPTION

A ZeroMQ REP-type socket using L<POEx::ZMQ3::Role::Emitter>.

A REP-type socket waits for a request (see L<POEx::ZMQ3::Requestor>) and
issues a reply accordingly.

=head2 Methods

=head3 start

  $zrep->start( $endpoint );

Start the Replier and listen on a specified endpoint.

=head3 stop

  $zrep->stop;

Stop the Replier, closing out the socket and stopping the event emitter.

=head3 reply

  $zrep->reply( $data );

Issue a reply to a request.

Should be called out of a L</zeromq_got_request> handler.

=head2 Events

=head3 zeromq_replying_on

Emitted when we add a bound endpoint; $_[ARG0] is the endpoint we are waiting for
requests on.

=head3 zeromq_got_request

Emitted when a request arrives; $_[ARG0] is the raw data.

=head1 SEE ALSO

L<POEx::ZMQ3>

L<POEx::ZMQ3::Requestor>

L<ZMQ::LibZMQ3>

L<http://www.zeromq.org>


=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut