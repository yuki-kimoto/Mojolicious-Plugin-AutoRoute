package RouteTest::Foo::Bar;
use Mojo::Base 'Mojolicious::Controller';

sub baz { shift->render(p => 'Foo::Bar::baz') }

1;
