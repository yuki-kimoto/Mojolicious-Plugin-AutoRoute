use Mojo::Base -strict;

use Test::More 'no_plan';

use Mojolicious::Lite;
use Test::Mojo;
use FindBin;

push @{app->renderer->paths}, app->home->rel_file('templates2');

get '/normal' => sub { shift->render(text => 'normal') };
get '/aa..bb' => sub { shift->render(text => 'aa..bb') };

plugin 'AutoRoute';

my $t = Test::Mojo->new;

# User created route
$t->get_ok('/normal')->content_like(qr/normal/);
$t->get_ok('/aa..bb')->content_like(qr/aa\.\.bb/);

# Get
$t->get_ok('/')->content_like(qr#\Qindex.html.ep#);
$t->get_ok('/foo')->content_like(qr#\Qfoo.html.ep#);
$t->get_ok('/foo/bar')->content_like(qr#\Qfoo/bar.html.ep#);
$t->get_ok('/foo/bar/baz')->content_like(qr#\Qfoo/bar/baz.html.ep#);
$t->get_ok('/foo2')->content_like(qr#\Qfoo2.html.ep#);

# Post
$t->post_ok('/')->content_like(qr#\Qindex.html.ep#);
$t->post_ok('/foo')->content_like(qr#\Qfoo.html.ep#);
$t->post_ok('/foo/bar')->content_like(qr#\Qfoo/bar.html.ep#);
$t->post_ok('/foo/bar/baz')->content_like(qr#\Qfoo/bar/baz.html.ep#);
$t->post_ok('/foo2')->content_like(qr#\Qfoo2.html.ep#);

# Not found
$t->get_ok('/foo3')->status_is('404');

# Forbidden(protect from directory traversal);
$t->get_ok('/foo/../foo')->status_is('500');
