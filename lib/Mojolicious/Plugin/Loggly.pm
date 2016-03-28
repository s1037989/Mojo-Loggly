package Mojolicious::Plugin::Loggly;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Loggly;

sub register {
  my ($self, $app, $conf) = @_;

  push @{$app->commands->namespaces}, 'Mojo::Loggly::Command';

  my $loggly = Mojo::Loggly->new(each %$conf);
  $app->helper(loggly => sub {$loggly});
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Loggly - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Loggly');

  # Mojolicious::Lite
  plugin 'Loggly';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Loggly> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Loggly> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
