package Mojolicious::Command::loggly;
use Mojo::Base 'Mojolicious::Commands';

has description => 'Loggly API';
has hint        => <<EOF;

See 'APPLICATION loggly help ENDPOINT' for more information on a specific
endpoint.
EOF
has message    => sub { shift->extract_usage . "\nAPI:\n" };
has namespaces => sub { ['Mojolicious::Command::loggly'] };

sub help { shift->run(@_) }

1;

=encoding utf8

=head1 NAME

Mojolicious::Command::loggly - Command interface to the Loggly API

=head1 SYNOPSIS

  Usage: APPLICATION loggly ENDPOINT [OPTIONS]

    export LOGGLY_TOKEN='your loggly token'
    mojo loggly log 'whatever'

=head1 DESCRIPTION

L<Mojolicious::Command::loggly> lists available Loggly endpoints.

=head1 ATTRIBUTES

L<Mojolicious::Command::loggly> inherits all attributes from
L<Mojolicious::Commands> and implements the following new ones.

=head2 description

  my $description = $loggly->description;
  $loggly       = $loggly->description('Foo');

Short description of this command, used for the command list.

=head2 hint

  my $hint   = $loggly->hint;
  $loggly  = $loggly->hint('Foo');

Short hint shown after listing available loggly commands.

=head2 message

  my $msg    = $loggly->message;
  $loggly  = $loggly->message('Bar');

Short usage message shown before listing available loggly commands.

=head2 namespaces

  my $namespaces = $loggly->namespaces;
  $loggly      = $loggly->namespaces(['MyApp::Command::loggly']);

Namespaces to search for available loggly commands, defaults to
L<Mojolicious::Command::loggly>.

=head1 METHODS

L<Mojolicious::Command::loggly> inherits all methods from
L<Mojolicious::Commands> and implements the following new ones.

=head2 help

  $loggly->help('app');

Print usage information for loggly command.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut