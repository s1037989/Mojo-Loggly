use 5.010;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use Mojo::Loggly;

my $loggly = Mojo::Loggly->new(
  config => {
    #token => 'get your token from loggly.com',
  },
);

$loggly->on(log => sub {
  my ($loggly, $ua, $tx) = @_;
  say $tx->res->body;
});

say $loggly->log({whatever => 123}, qw(tag1 tag2));
say $loggly->log('whatever', qw(tag1 tag2));

Mojo::IOLoop->start;
