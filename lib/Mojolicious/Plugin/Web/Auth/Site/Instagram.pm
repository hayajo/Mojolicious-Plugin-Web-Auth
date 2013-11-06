package Mojolicious::Plugin::Web::Auth::Site::Instagram;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://api.instagram.com/oauth/authorize';
has access_token_url => 'https://api.instagram.com/oauth/access_token';
has user_info_url    => 'https://api.instagram.com/v1/users/self';
has response_type    => 'code';

sub moniker {'instagram'};

1;
