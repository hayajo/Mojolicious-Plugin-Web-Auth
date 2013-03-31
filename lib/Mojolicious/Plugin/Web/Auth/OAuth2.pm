package Mojolicious::Plugin::Web::Auth::OAuth2;

use Mojo::Base -base;
use Mojo::JSON;
use Mojo::Parameters;
use Mojo::UserAgent;

has 'key';
has 'secret';
has 'scope';
has 'user_info';
has 'authorize_url';
has 'access_token_url';
has 'user_info_url';
has 'response_type';
has moniker => sub { die 'override me' };

sub _ua {
    my $self = shift;
    $self->{_ua} = Mojo::UserAgent->new( name => "Mojolicious::Plugin::Web::Auth/$Mojolicious::Plugin::Web::Auth::VERSION")
        unless ($self->{_ua});
    return $self->{_ua};
}

sub auth_uri {
    my ($self, $c, $callback_uri) = @_;
    $callback_uri or die "Missing mandatory parameter: callback_uri";

    my $url = Mojo::URL->new( $self->authorize_url );
    $url->query->param( client_id    => $self->key );
    $url->query->param( redirect_uri => $callback_uri );
    $url->query->param( scope        => $self->scope ) if ( defined $self->scope );
    $url->query->param( response_type => $self->response_type ) if ( defined $self->response_type );

    return $url->to_string;
}

sub callback {
    my ($self, $c, $callback) = @_;
    if (my $error_description = $c->req->param('error_description')) {
        return $callback->{on_error}->($error_description);
    }
    my $code = $c->param('code') or die "Cannot get a 'code' parameter";

    my $params = +{
        code          => $code,
        client_id     => $self->key,
        client_secret => $self->secret,
        redirect_uri  => $c->url_for->path( $c->req->url->path )->to_abs->to_string,
        grant_type    => 'authorization_code',
    };

    my $tx = ( $Mojolicious::VERSION < 3.85)
        ? $self->_ua->post_form( $self->access_token_url => $params ) # Mojo::UserAgent::post_form is deprecated from version 3.85
        : $self->_ua->post( $self->access_token_url => form => $params );

    (my $res = $tx->success ) or do {
        return $callback->{on_error}->( $tx->res->body );
    };

    my $dat = $self->_response_to_hash($res);
    if ( my $err = $dat->{error} ) {
        return $callback->{on_error}->($err);
    }
    my $access_token = $dat->{access_token} or die "Cannot get a access_token";
    my @args = ($access_token);

    if ( $self->user_info ) {
        my $url = Mojo::URL->new( $self->user_info_url );
        $url->query->param( access_token => $access_token );
        my $tx = $self->_ua->get( $url->to_abs );
        ( my $res = $tx->success )
            or return $callback->{on_error}->( sprintf( '%d %s', $tx->res->code, $tx->res->default_message ) );
        push @args, $res->json;
    }

    return $callback->{on_finished}->(@args);
}

sub _response_to_hash {
    my ( $self, $res ) = @_;
    return ( $res->headers->content_type eq 'application/json' )
        ? $res->json
        : Mojo::Parameters->new( $res->body )->to_hash;
}

1;

__END__
