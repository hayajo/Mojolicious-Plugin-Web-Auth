package Mojolicious::Plugin::Web::Auth::Site::Dropbox;

use Mojo::Base -base;
use Net::OAuth::Client;
use JSON;

has 'key';
has 'secret';
has 'user_info' => 1;

sub moniker {'dropbox'}

sub client {
    my ( $self, $c, $callback_uri ) = @_;
    $self->{oauth_client} ||= Net::OAuth::Client->new(
        $self->key,
        $self->secret,
        site                => 'https://api.dropbox.com/',
        request_token_path  => '/1/oauth/request_token',
        authorize_path      => '/1/oauth/authorize',
        access_token_path   => '/1/oauth/access_token',
        access_token_method => 'POST',
        callback            => $callback_uri,
        session             => sub { $c->session(@_) },
    );
}

sub auth_uri {
    my ( $self, $c, $callback_uri ) = @_;
    $callback_uri or die "Missing mandatory parameter: callback_uri";
    return $self->client( $c, $callback_uri )->authorize_url;
}

sub callback {
    my ( $self, $c, $callback ) = @_;

    my $request_token = $c->req->param('oauth_token')
        or return $callback->{on_error}->("Session error");

    my $access_token = $self->client->get_access_token($request_token);

    my $token  = $access_token->token;
    my $secret = $access_token->token_secret;
    my @args   = ( $token, $secret );

    if ( $self->user_info ) {
        my $res = $access_token->get('/1/account/info');
        return $callback->{on_error}->( $res->decoded_content )
            unless ( $res->is_success );
        push @args, decode_json( $res->decoded_content );
    }

    return $callback->{on_finished}->(@args);
}

1;

__END__
