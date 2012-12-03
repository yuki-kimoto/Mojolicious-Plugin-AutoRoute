use Mojolicious::Lite;

use FindBin;
use File::Spec::Functions 'catdir';
use File::Basename 'dirname';

use lib catdir(dirname(__FILE__), '../lib');
use lib catdir(dirname(__FILE__), '/lib');

plugin 'AutoRoute';

  use Mojo::Cache;
  app->hook(before_dispatch => sub {
    my $c = shift;
    
    # Clear cache
    $c->app->renderer->cache(Mojo::Cache->new);
  });

app->start;

