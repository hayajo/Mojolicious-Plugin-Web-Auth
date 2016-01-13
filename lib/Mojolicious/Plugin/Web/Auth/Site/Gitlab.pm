package Mojolicious::Plugin::Web::Auth::Site::Gitlab;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://gitlab.com/oauth/authorize';
has access_token_url => 'https://gitlab.com/oauth/token';
has user_info_url    => 'https://gitlab.com/api/v3/user';
has response_type    => 'code';

sub moniker {'gitlab'};

1;
