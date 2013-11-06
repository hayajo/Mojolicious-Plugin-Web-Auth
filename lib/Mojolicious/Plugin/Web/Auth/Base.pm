package Mojolicious::Plugin::Web::Auth::Base;

use Mojo::Base -base;
use Mojo::UserAgent;

has 'key';
has 'secret';
has 'user_info';
has 'authorize_url';
has 'access_token_url';
has 'user_info_url';

sub moniker { die 'override me' };

sub auth_uri {
    my ($self, $c, $callback_uri) = @_;
    "auth_uri() is not implemented";
}

sub callback {
    my ($self, $c, $callback_uri) = @_;
    "callback() is not implemented";
}

1;
