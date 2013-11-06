package Mojolicious::Plugin::Web::Auth::Site::Dropbox;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth/;

has user_info         => 1;
has request_token_url => 'https://api.dropbox.com/1/oauth/request_token';
has authorize_url     => 'https://api.dropbox.com/1/oauth/authorize';
has access_token_url  => 'https://api.dropbox.com/1/oauth/access_token';
has user_info_url     => 'https://api.dropbox.com/1/account/info';

sub moniker {'dropbox'};

1;
