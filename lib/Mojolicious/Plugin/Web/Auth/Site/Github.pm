package Mojolicious::Plugin::Web::Auth::Site::Github;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://github.com/login/oauth/authorize';
has access_token_url => 'https://github.com/login/oauth/access_token';
has user_info_url    => 'https://api.github.com/user';

sub moniker {'github'};

1;
