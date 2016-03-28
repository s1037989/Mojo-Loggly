use Test::More;
use Test::Mojo;
use Mojolicious::Lite;
use Mojo::Loggly;

$ENV{LOGGLY_APIURL} = '/dummy';

my $t = Test::Mojo->new;
my $loggly = Mojo::Loggly->new(config => {token => 'kjwhef'});
my $res;

post '/dummy' => sub {shift->render(json => {response => 'ok'}) };

$loggly->once(log => sub {
  my ($loggly, $ua, $tx) = @_;
  $res = $tx->res->json;
  Mojo::IOLoop->stop;
});

$loggly->log(
  {whatever => 123},
  qw(tag1 tag2)
);

Mojo::IOLoop->start;

isa_ok $loggly, 'Mojo::Loggly';
is_deeply $res, {response => 'ok'}, 'correct response, nb';

is_deeply
  $loggly->log(
    {whatever => 123},
    qw(tag1 tag2)
  )->res->json,
  {response => 'ok'},
  'correct response, b';

my $e = eval { $loggly->log->res->json };
ok $@, 'exception expected';

done_testing;
