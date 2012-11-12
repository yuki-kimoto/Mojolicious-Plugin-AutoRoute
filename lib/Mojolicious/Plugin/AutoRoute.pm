package Mojolicious::Plugin::AutoRoute;
use Mojo::Base 'Mojolicious::Plugin';
use File::Spec::Functions 'splitdir';

our $VERSION = '0.02';

sub register {
  my ($self, $app, $conf) = @_;
  
  # Parent route
  my $r = $conf->{route} || $app->routes;
  
  # Max depth
  my $max_depth = $conf->{max_depth} || 15;
  
  # Route(root)
  $r->route('/')->name('index');
  
  # Routes
  my $path_long = '';
  for (my $depth = 0; $depth < $max_depth; $depth++) {
    my $path = $path_long . "/:path$depth";
    my $current_depth = $depth;
    $r->route("$path")->to(cb => sub {
      my $c = shift;
      my $tmpl_path = '';
      for(my $k = 0; $k < $current_depth + 1; $k++) {
        $tmpl_path .= '/' . $c->stash("path$k");
      }
      $c->render($tmpl_path);
    });
    $path_long = $path;
  }
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::AutoRoute - Mojolicious Plugin to create routes from templates

=head1 CAUTION

B<This is beta release. implementation will be changed without warnings>. 

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('AutoRoute');

  # Mojolicious::Lite
  plugin 'AutoRoute';

  # Your route
  $self->puglin('AutoRoute', {route => $self->routes});
  
=head1 DESCRIPTION

L<Mojolicious::Plugin::AutoRoute> is a L<Mojolicious> plugin
to create routes automatically.

Routes corresponding to URL is created .

  TEMPLATES                      ROUTES
  templates/index.html.ep        # /
           /foo.html.ep          # /foo
           /foo/bar.html.ep      # /foo/bar
           /foo/bar/baz.html.ep  # /foo/bar/baz

If you like C<PHP>, this plugin is very good.

=head1 OPTIONS

=head2 C<route>

  route => $route;

You can set parent route if you need.
This is L<Mojolicious::Routes> object.
Default is C<$app->routes>.

=head2 C<max_depth>

  max_depth => 40;

Template directory max depth. Default is C<15>.

=head1 METHODS

L<Mojolicious::Plugin::AutoRoute> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register($app);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
