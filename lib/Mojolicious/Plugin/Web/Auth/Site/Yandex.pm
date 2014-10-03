package Mojolicious::Plugin::Web::Auth::Site::Yandex;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has authorize_url    => 'https://oauth.yandex.ru/authorize';
has response_type    => 'code';
has access_token_url => 'https://oauth.yandex.ru/token';
has user_info_url    => 'https://login.yandex.ru/info?format=json';
has authorize_header => 'OAuth';

sub moniker {'yandex'};

1;
