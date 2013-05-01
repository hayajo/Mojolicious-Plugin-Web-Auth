package Mojolicious::Plugin::Web::Auth::OAuth;

use Mojo::Base 'Mojolicious::Plugin::Web::Auth::Base';
use Net::OAuth::Client;
use Mojo::JSON;

has 'request_token_url';

sub auth_uri {
    my ( $self, $c, $callback_uri ) = @_;

    $callback_uri or die "Missing mandatory parameter: callback_uri";

    return $self->_client( $c, $callback_uri )->authorize_url;
}

sub callback {
    my ( $self, $c, $callback ) = @_;

    my $request_token = $c->req->param('oauth_token')
        or return $callback->{on_error}->("Session error");
    my $request_verifier = $c->req->param('oauth_verifier');

    my $access_token = $self->_client->get_access_token($request_token, $request_verifier);

    my $token  = $access_token->token;
    my $secret = $access_token->token_secret;
    my @args   = ( $token, $secret );

    if ( $self->user_info ) {
        my $res = $access_token->get( $self->user_info_url );
        return $callback->{on_error}->( $res->decoded_content )
            unless ( $res->is_success );
        push @args, Mojo::JSON::j( $res->decoded_content );
    }

    return $callback->{on_finished}->(@args);
}

sub _client {
    my ( $self, $c, $callback_uri ) = @_;
    $self->{_oauth_client} ||= Net::OAuth::Client->new(
        $self->key,
        $self->secret,
        request_token_path  => $self->request_token_url,
        authorize_path      => $self->authorize_url,
        access_token_path   => $self->access_token_url,
        access_token_method => 'POST',
        callback            => $callback_uri,
        session             => sub { $c->session(@_) },
    );
}

1;
