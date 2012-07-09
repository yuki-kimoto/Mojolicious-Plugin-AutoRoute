package RouteTest::Foo;
use Mojo::Base 'Mojolicious::Controller';

sub bar { shift->render(p => 'Foo::bar') }

1;
