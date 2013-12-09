use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::AutoRoute',
  VERSION_FROM => 'lib/Mojolicious/Plugin/AutoRoute.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '2.98'},
  META_MERGE   => {
    'meta-spec' => { version => 2 },
    resources => {
      repository => {
        type => 'git',
        url  => 'https://github.com/yuki-kimoto/Mojolicious-Plugin-AutoRoute.git',
        web  => 'https://github.com/yuki-kimoto/Mojolicious-Plugin-AutoRoute',
      },
    },
  },
  clean        => { FILES => 'Mojolicious-Plugin-AutoRoute-*' },
  test         => {TESTS => 't/*.t'}
);
