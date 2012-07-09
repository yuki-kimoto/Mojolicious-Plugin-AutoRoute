package Mojolicious::Plugin::AutoRoute;
use Mojo::Base 'Mojolicious::Plugin';
use File::Find 'find';
use File::Spec::Functions 'splitdir';
use Mojo::Util 'camelize';

our $VERSION = '0.01';

sub register {
  my ($self, $app, $conf) = @_;
  
  # Route
  my $r = $conf->{route} || $app->routes;
  
  # Template paths
  my $paths = $app->renderer->paths;
  
  # Ignore directory
  my $ignore = $conf->{ignore};
  
  # Parse directory
  my $exists = {};
  for my $path (@$paths) {
    find(sub {
      my $file_abs = $File::Find::name;
      my $file = $file_abs;
      $file =~ s/^$path//;
      
      return unless $file =~ s/\.html\.ep$//;
      return if $exists->{$file}++;
      
      my @dirs = splitdir $file;
      shift @dirs if @dirs && $dirs[0] eq '';
      my $base = pop @dirs;
      
      return if @dirs && grep { $dirs[0] eq $_ } @$ignore; 
      
      # Index page
      if (!@dirs && $base eq 'index') {
        $r->any('/')->to('index#main', template => '/index');
      }
      # Top directory
      elsif(!@dirs) {
        $r->any("/$base")->to("index#$base", template => "/$base");
      }
      # More depth directry
      else {
        my $controller = join '-', @dirs;
        my $path = '/' . join('/', @dirs) . '/' . $base;
        $r->any($path)->to("$controller#$base", template => $path);
      }
    }, $path);
  }
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::AutoRoute - Mojolicious Plugin to create routes from templates

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('AutoRoute');

  # Mojolicious::Lite
  plugin 'AutoRoute';

  # Your route
  $self->puglin('AutoRoute', {route => $self->routes});
  
=head1 DESCRIPTION

L<Mojolicious::Plugin::AutoRoute> is a L<Mojolicious> plugin
to create routes automatically from templates.

Routes is autocatically create searching C<templates>($app->renderer->paths)
 directory.

For example, if you set template, routes is automatically created.
  
  TEMPLATES                      ROUTES          CONTROLLER/ACTION
  templates/index.html.ep        # /             (Index::main)
           /foo.html.ep          # /foo          (Index::foo)
           /foo/bar.html.ep      # /foo/bar      (Foo::Bar)
           /foo/bar/baz.html.ep  # /foo/bar/baz  (Foo::Bar::baz)

If you like C<PHP>, this plugin is very good.

=head1 OPTIONS

=head2 C<route>

  route => $app->routes->under(sub { ... });

You can set your route, defaults to C<$app->routes>.

=head2 C<ignore>

  ignore => [qw/layouts include/]

Ignored directory.

=head1 METHODS

L<Mojolicious::Plugin::AutoRoute> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register($app);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
