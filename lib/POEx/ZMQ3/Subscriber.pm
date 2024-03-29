package POEx::ZMQ3::Subscriber;
$POEx::ZMQ3::Subscriber::VERSION = '0.071';
use Carp;
use POE;

## FIXME
##  Easier subscription management wrt. multipart_recv

use Moo;
with 'POEx::ZMQ3::Role::Emitter';


has targets => (
  is => 'rw',
  default => sub { [] },
);


=pod

=for Pod::Coverage build_defined_states emitter_started zmqsock.+

=cut

sub build_defined_states {
  my ($self) = @_;
  [
    $self => [ qw/
      emitter_started
      zmqsock_recv
      zmqsock_multipart_recv
    / ],
  ]
}

sub start {
  my ($self, @targets) = @_;
  push @{ $self->targets }, @targets;
  $self->zmq->start;

  $self->zmq->create( $self->alias, 'SUB' );

  $self->_start_emitter;
}

sub emitter_started {
  my ($kernel, $self) = @_[KERNEL, OBJECT];

  $kernel->call( $self->zmq => subscribe => 'all' );
  $self->zmq->set_zmq_subscribe( $self->alias );
  $self->add_connect( $self->alias, $_ ) for @{ $self->targets };
  $self->targets([]);

  $self
}

after add_connect => sub {
  my ($self, $alias, $target) = @_;
  $self->emit( 'subscribed_to', $target )
};

sub stop {
  my ($self) = @_;
  $self->zmq->stop;
  $self->_stop_emitter;
}

sub zmqsock_recv {
  my ($kernel, $self) = @_[KERNEL, OBJECT];
  my ($alias, $data) = @_[ARG0, ARG1];
  $self->emit( 'received', $data )
}

sub zmqsock_multipart_recv {
  my ($kernel, $self) = @_[KERNEL, OBJECT];
  my ($alias, $parts) = @_[ARG0, ARG1];
  $self->emit( 'received', @$parts )
}

1;



=pod

=head1 NAME

POEx::ZMQ3::Subscriber

=head1 SYNOPSIS

  use POE;

  my $zsub = POEx::ZMQ3::Subscriber->new();
  
  POE::Session->create(
    inline_states => {

      _start => sub {
        ## Connect to a ZeroMQ publisher:
        $zsub->start( 'tcp://127.0.0.1:5665' );

        ## Our session wants all emitted events:
        $_[KERNEL]->post( $zsub->session_id,
          'subscribe',
          'all'
        );
      },

      zeromq_subscribed_to => sub {
        my $target = $_[ARG0];
        print "Subscribed to $target\n";
      },

      zeromq_received => sub {
        my $data = $_[ARG0];
        print "Received $data from publisher\n";

        if (++$_[HEAP]->{count} == 1000) {
          warn "I don't want any more messages :(";
          $zsub->stop;
        }
      },

    },
  );

  $poe_kernel->run;


=head1 DESCRIPTION

A lightweight ZeroMQ subscriber-type socket using
L<POEx::ZMQ3::Role::Emitter>.

This is a simple subscriber; by default it indiscriminately receives all published
messages without filtering.

=head2 Methods

=head3 start

  $zsub->start( $subscribe_to );

Start the Subscriber and connect to a specified target.

=head3 stop

  $zsub->stop;

Stop the Subscriber, closing out the socket and stopping the event emitter.

=head2 Events

=head3 zeromq_subscribed_to

Emitted when we are initialized; $_[ARG0] is the target publisher's address.

=head3 zeromq_received

Emitted when we receive data from the publisher we are subscribed to

If this is a single-part message, $_[ARG0] is the (raw) data received. 

If this is a multi-part message, slurp the argument array to receive all
parts:

  sub zeromq_received {
    my @parts    = @_[ARG0 .. $#_];
    my $envelope = shift @parts;
    . . .
  }

=head2 Attributes

=head3 targets

An ARRAY containing the list of publishing endpoints the Subscriber was
configured for; see L</start>.

=head1 SEE ALSO

L<POEx::ZMQ3>

L<POEx::ZMQ3::Publisher>

L<ZMQ::LibZMQ3>

L<http://www.zeromq.org>


=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>


=cut
