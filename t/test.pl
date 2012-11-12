use Mojolicious::Lite;

use FindBin;
use File::Spec::Functions 'catdir';
use File::Basename 'dirname';

use lib catdir(dirname(__FILE__), '../lib');
use lib catdir(dirname(__FILE__), '/lib');

plugin 'AutoRoute';

app->start;

