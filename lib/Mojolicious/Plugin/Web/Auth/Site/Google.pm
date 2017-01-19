package Mojolicious::Plugin::Web::Auth::Site::Google;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has scope            => 'https://www.googleapis.com/auth/plus.me'; # use Google+ API Service
has authorize_url    => 'https://accounts.google.com/o/oauth2/auth?response_type=code';
has access_token_url => 'https://accounts.google.com/o/oauth2/token';
has user_info_url    => 'https://www.googleapis.com/plus/v1/people/me';
has access_type      => 'offline';

sub moniker {'google'};

sub auth_uri {
    my ( $self, $c, $callback_uri ) = @_;

    my $auth_uri = $self->SUPER::auth_uri($c, $callback_uri);
    my $url = Mojo::URL->new($auth_uri);
    $url->query->param( access_type => $self->access_type )
        if (defined $self->access_type);

    return $url->to_string;
}

1;
