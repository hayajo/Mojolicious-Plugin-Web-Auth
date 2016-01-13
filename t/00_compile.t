use strict;
use Test::More tests => 10;

BEGIN {
    use_ok $_ for qw/
        Mojolicious::Plugin::Web::Auth
        Mojolicious::Plugin::Web::Auth::OAuth
        Mojolicious::Plugin::Web::Auth::OAuth2
        Mojolicious::Plugin::Web::Auth::Site::Twitter
        Mojolicious::Plugin::Web::Auth::Site::Facebook
        Mojolicious::Plugin::Web::Auth::Site::Dropbox
        Mojolicious::Plugin::Web::Auth::Site::Github
        Mojolicious::Plugin::Web::Auth::Site::Google
        Mojolicious::Plugin::Web::Auth::Site::Instagram
        Mojolicious::Plugin::Web::Auth::Site::Gitlab
    /;
}
