package Mojolicious::Plugin::Web::Auth::Site::Facebook;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://www.facebook.com/dialog/oauth';
has access_token_url => 'https://graph.facebook.com/oauth/access_token';
has user_info_url    => 'https://graph.facebook.com/me';

sub moniker {'facebook'};

1;
