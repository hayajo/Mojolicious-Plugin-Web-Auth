package Mojolicious::Plugin::Web::Auth::Site::Google;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth2/;

has user_info        => 1;
has scope            => 'email profile';
has authorize_url    => 'https://accounts.google.com/o/oauth2/v2/auth?response_type=code';
has access_token_url => 'https://www.googleapis.com/oauth2/v4/token';
has user_info_url    => 'https://www.googleapis.com/oauth2/v3/userinfo';
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
