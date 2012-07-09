package RouteTest::Index;
use Mojo::Base 'Mojolicious::Controller';

sub main { shift->render(p => 'Index::main') }

sub foo { shift->render(p => 'Index::foo') }

1;
