package Mojo::Loggly;
use Mojo::Base 'Mojo::EventEmitter';

our $VERSION = '0.01';

has config => sub { {} };
has token => sub { $ENV{LOGGLY_TOKEN} || shift->config->{token} or die "config token missing" };
has apiurl => sub { $ENV{LOGGLY_APIURL} || shift->config->{apiurl} || 'http://logs-01.loggly.com/inputs/%k/%t' };

use Mojo::UserAgent;

has 'ua' => sub { Mojo::UserAgent->new };

sub log {
  my ($self, $log, @tags) = @_;

  die unless $log;

  $self->ua->post(
    $self->_apiurl(@tags) =>
    {'Content-Type' => ref $log ? 'application/x-www-form-urlencoded' : 'text/plain'} =>
    ref $log ? (json => $log) : ($log) =>
    # If there are any subscribers to the event issue the request non-blocking and emit event
    # Otherwise issue the request blocking
    $self->has_subscribers('log') ? sub {$self->emit(log => @_)} : ()
  );
}

sub _apiurl {
  my ($self, @tags) = @_;

  my $token = $self->token;
  my $apiurl = $self->apiurl;
  my $tags = @tags ? 'tag/'.join(',', @tags).'/' : '';

  $apiurl =~ s/%k/$token/g;
  $apiurl =~ s/%t/$tags/g;

  return $apiurl;
}

1;

=encoding utf8

=head1 NAME

Mojo::Loggly - Loggly API implementation for the Mojolicious framework

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Mojo::Loggly;

  my $loggly = Mojo::Loggly->new(
                 config => {
                   token => 'get your token from loggly.com',
                   #apiurl => 'you do not need to set this',
                 },
               );

  $loggly->on(log => sub {
    my ($loggly, $ua, $tx) = @_;
    say $tx->res->body;
  });

  say $loggly->log(
    {whatever => 123},
    qw(tags)
  );

  Mojo::IOLoop->start;

=head1 DESCRIPTION

L<Mojo::Loggly> is an implementation of the Loggly API and is non-blocking
thanks to L<Mojo::IOLoop> from the wonderful L<Mojolicious> framework.

It currently sends a log event to Loggly.

This class inherits from L<Mojo::EventEmitter>.

=head1 EVENTS

Mojo::Loggly inherits all events from Mojo::EventEmitter and can emit the following new ones.

=head2 log

Log

=head1 ATTRIBUTES

=head2 config

Holds the configuration hash.

=head2 token

Accesses the token element of L</config>.
Can be overridden by the environment variable LOGGLY_TOKEN.
This attribute is required to have a value.

=head2 apiurl

Accesses the apiurl element of L</config>.
Can be overridden by the environment variable LOGGLY_APIURL.

=head1 METHODS

=head2 log

  $self = $self->log($log, qw(tags));

$log is either a HASH or ARRAY ref and converted to JSON, or a scalar and sent
as plaintext.

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Stefan Adams - C<sadams@cpan.org>

=cut