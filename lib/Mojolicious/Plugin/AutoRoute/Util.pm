package Mojolicious::Plugin::AutoRoute::Util;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = ('template');

sub template {
  my $template = shift;

  my $not_found = $Mojolicious::VERSION >= 5.73
    ? sub { shift->reply->exception }
    : sub { shift->render_not_found };

  return sub {
    my $c = shift;
    $c->render($template, 'mojo.maybe' => 1);
    $c->stash('mojo.finished') ? undef : $not_found->($c);
  };
}

1;
