package Mojolicious::Plugin::Web::Auth::Site::Spotify;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://accounts.spotify.com/authorize';
has access_token_url => 'https://accounts.spotify.com/api/token';
has user_info_url    => 'https://api.spotify.com/v1/me';
has response_type    => 'code';

sub moniker {'spotify'}

1;
