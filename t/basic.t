use Mojo::Base -strict;

use Test::More 'no_plan';

use Mojolicious::Lite;
use Test::Mojo;
use FindBin;

plugin 'AutoRoute';

my $t = Test::Mojo->new;

# Get
$t->get_ok('/')->content_like(qr#\Qindex.html.ep#);
$t->get_ok('/foo')->content_like(qr#\Qfoo.html.ep#);
$t->get_ok('/foo/bar')->content_like(qr#\Qfoo/bar.html.ep#);
$t->get_ok('/foo/bar/baz')->content_like(qr#\Qfoo/bar/baz.html.ep#);

# Post
$t->post_ok('/')->content_like(qr#\Qindex.html.ep#);
$t->post_ok('/foo')->content_like(qr#\Qfoo.html.ep#);
$t->post_ok('/foo/bar')->content_like(qr#\Qfoo/bar.html.ep#);
$t->post_ok('/foo/bar/baz')->content_like(qr#\Qfoo/bar/baz.html.ep#);

# Not found
$t->get_ok('/foo/none')->status_is('404');

# Not found(top page)
$t->app->renderer->paths(["$FindBin::Bin/templates2"]);
$t->get_ok('/')->status_is(404);
