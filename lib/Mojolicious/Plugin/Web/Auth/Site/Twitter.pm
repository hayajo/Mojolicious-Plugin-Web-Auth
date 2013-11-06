package Mojolicious::Plugin::Web::Auth::Site::Twitter;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth/;

has is_v1a            => 1;
has user_info         => 1;
has request_token_url => 'https://api.twitter.com/oauth/request_token';
has authorize_url     => 'https://api.twitter.com/oauth/authorize';
has access_token_url  => 'https://api.twitter.com/oauth/access_token';
has user_info_url     => 'https://api.twitter.com/1.1/account/verify_credentials.json';

sub moniker { 'twitter' }

1;
