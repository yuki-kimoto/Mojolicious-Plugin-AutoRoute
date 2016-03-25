package Mojolicious::Plugin::AutoRoute;
use Mojo::Base 'Mojolicious::Plugin';

use File::Find 'find';

our $VERSION = '0.19';

sub register {
  my ($self, $app, $conf) = @_;
  
  # Parent route
  my $r = $conf->{route} || $app->routes;
  
  # Template Base
  my $template_base_dirs = $app->renderer->paths;
  
  # Top directory
  my $top_dir = $conf->{top_dir} || 'auto';
  $top_dir =~ s#^/##;
  $top_dir =~ s#/$##;
  
  # Search templates
  my @templates;
  for my $template_base_dir (@$template_base_dirs) {
    $template_base_dir =~ s#/$##;
    my $template_dir = "$template_base_dir/$top_dir";
    
    if (-d $template_dir) {
      # Find templates
      find(sub {
        my $template_abs = $File::Find::name;
        my $template = $template_abs;
        $template =~ s/\Q$template_dir\///;
        
        if ($template =~ s/\.html\.ep$//) {
          push @templates, $template;
        }
      }, $template_dir);
    }
  }
  
  my $not_found = $Mojolicious::VERSION >= 5.73
    ? sub { shift->reply->exception }
    : sub { shift->render_not_found };
  
  # Register routes
  for my $template (@templates) {
    my $route_path = $template eq 'index' ? '/' : $template;
    
    # Route
    $r->route("/$route_path")
      ->to(cb => sub {
        my $c = shift;
        
        $c->render("/$top_dir/$template", 'mojo.maybe' => 1);
        $c->stash('mojo.finished') ? undef : $not_found->($c);
      });
  }
}

1;

=head1 NAME

Mojolicious::Plugin::AutoRoute - Mojolicious Plugin to create routes automatically

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('AutoRoute');

  # Mojolicious::Lite
  plugin 'AutoRoute';

  # With option
  plugin 'AutoRoute', route => $r;

=head1 DESCRIPTION

L<Mojolicious::Plugin::AutoRoute> is a L<Mojolicious> plugin
to create routes automatically.

Routes corresponding to URL is created .

  TEMPLATES                           ROUTES
  templates/auto/index.html.ep        # /
                /foo.html.ep          # /foo
                /foo/bar.html.ep      # /foo/bar
                /foo/bar/baz.html.ep  # /foo/bar/baz

If you like C<PHP>, this plugin is very good.
You only put file into C<auto> directory.

=head1 EXAMPLE

  use Mojolicious::Lite;
  use Mojolicious::Plugin::AutoRoute::Util 'template';
  
  # AutoRoute
  plugin 'AutoRoute';
  
  # Custom routes
  get '/create/:id' => template '/create';
  
  @@ auto/index.html.ep
  /
  
  @@ auto/foo.html.ep
  /foo
  
  @@ auto/bar.html.ep
  /bar
  
  @@ auto/foo/bar/baz.html.ep
  /foo/bar/baz
  
  @@ auto/json.html.ep
  <%
    $self->render(json => {foo => 1});
    return;
  %>
  
  @@ create.html.ep
  /create/<%= $id %>

=head1 OPTIONS

=head2 route

  route => $route;

You can set parent route if you need.
This is L<Mojolicious::Routes> object.
Default is C<$app->routes>.

=head2 top_dir

  top_dir => 'myauto'

Top directory. default is C<auto>.

=head1 FUNCTIONS

=head2 template(Mojolicious::Plugin::AutoRoute::Util)

If you want to create custom route, use C<template> function.

  use Mojolicious::Plugin::AutoRoute::Util 'template';
  
  # Mojolicious Lite
  any '/foo' => template '/foo';

  # Mojolicious
  $r->any('/foo' => template '/foo');

C<template> is return callback to call C<render_maybe>.

=head1 METHOD

=head2 register

  $plugin->register($app);

Register plugin in L<Mojolicious> application.

=head1 CAUTION

This plugin depend on Mojolicious internal structure.
I try to keep this module work well and  backword compatible,
but I don't guarantee it.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
