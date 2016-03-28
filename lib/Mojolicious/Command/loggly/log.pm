package Mojolicious::Command::loggly::log;
use Mojo::Base 'Mojolicious::Command';

use Mojo::JSON 'j';
use Mojo::Loggly;

use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev no_ignore_case);

has description => 'loggly log';
has usage => sub { shift->extract_usage };

has loggly => sub { Mojo::Loggly->new };

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args,
    't|tags=s' => \my @tags,
    'j|json'   => \my $json;

  my $log = join ' ', @args;
  die $self->usage unless $log;

  $log = j($log) if $json;

  say j($self->loggly->log($log, @tags)->res->json);
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Command::loggly::log - Log to Loggly
mail endpoint.

=head1 SYNOPSIS

  Usage: APPLICATION loggly log [OPTIONS]

    export LOGGLY_TOKEN='your loggly token'
    mojo loggly log -t tag1 -t tag2 whatever
    mojo loggly log -t tag1 -t tag2 -j '{"whatever":"123"}'

  Options:
    -h, --help      Show this summary of available options
    -t, --tags      Email address of the recipient
    -j, --json      Recognize the message as JSON

=head1 DESCRIPTION

L<Mojolicious::Command::loggly::log> sends a log message to Loggly.
Prints the json response to STDOUT.

=head1 ATTRIBUTES

L<Mojolicious::Command::loggly::log> inherits all attributes from
L<Mojolicious::Command> and implements the following new ones.

=head2 description

  my $description = $app->description;
  $app            = $app->description('Foo');

Short description of this command, used for the command list.

=head2 usage

  my $usage = $app->usage;
  $app      = $app->usage('Foo');

Usage information for this command, used for the help screen.

=head1 METHODS

L<Mojolicious::Command::loggly::log> inherits all methods from
L<Mojolicious::Command> and implements the following new ones.

=head2 run

  $app->run(@ARGV);

Run this command.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut