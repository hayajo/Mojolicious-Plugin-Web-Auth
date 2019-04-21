package Mojolicious::Plugin::Web::Auth::OAuth2;

use Mojo::Base 'Mojolicious::Plugin::Web::Auth::Base';
use Mojo::URL;
use Mojo::Parameters;
use Mojolicious::Types qw();
use Digest::SHA;

has 'scope';
has 'response_type';
has 'validate_state' => 1;
has 'state_generator';
has 'authorize_header';

sub auth_uri {
    my ( $self, $c, $callback_uri ) = @_;

    $callback_uri or die "Missing mandatory parameter: callback_uri";

    my $url = Mojo::URL->new( $self->authorize_url );
    $url->query->param( client_id     => $self->key );
    $url->query->param( redirect_uri  => $callback_uri );
    $url->query->param( scope         => $self->scope ) if ( defined $self->scope );
    $url->query->param( response_type => $self->response_type ) if ( defined $self->response_type );

    if ( $self->validate_state ) {
        my $state = $self->state_generator ? $self->state_generator->() : _state_generator();
        $c->session->{oauth2_state} = $state;
        $url->query->param( state => $state );
    }

    return $url->to_string;
}

sub callback {
    my ($self, $c, $callback) = @_;

    if ( my $error = $c->req->param('error') ) {
        my $error_description = $c->req->param('error_description');
        return $callback->{on_error}->( $error, $error_description );
    }
    my $code = $c->param('code') or die "Cannot get a 'code' parameter";
    my $forwarded_proto = $c->req->headers->header('x-forwarded-proto');
    $c->req->url->base->scheme('https') if (defined $forwarded_proto && $forwarded_proto eq 'https');

    if ( $self->validate_state ) {
        my $state = delete $c->session->{oauth2_state};
        if ( $state ne $c->param('state') ) {
            return $callback->{on_error}->('state validation failed.');
        }
    }

    my $params = +{
        code          => $code,
        client_id     => $self->key,
        client_secret => $self->secret,
        redirect_uri  => $c->url_for->path( $c->req->url->path )->to_abs->to_string,
        grant_type    => 'authorization_code',
    };

    my $tx = ( $Mojolicious::VERSION >= 3.85)
        ? $self->_ua->post( $self->access_token_url => form => $params )
        : $self->_ua->post_form( $self->access_token_url => $params ); # Mojo::UserAgent::post_form is deprecated from version 3.85

    my $res = $tx->res;
    return $callback->{on_error}->( $res->body ) if $tx->error;

    my $dat = $self->_response_to_hash($res);
    if ( my $err = delete $dat->{error} ) {
        return $callback->{on_error}->($err);
    }

    my $access_token = delete $dat->{access_token}
        or die "Cannot get an access_token";
    my @args = ($access_token);

    if ( $self->user_info ) {
        my $url = Mojo::URL->new( $self->user_info_url );
        $url->query->param( access_token => $access_token ) unless ( defined $self->authorize_header );
        my $headers = defined $self->authorize_header
            ? { 'Authorization' => $self->authorize_header.' '.$access_token }
            : { };
        my $tx = $self->_ua->get( $url->to_abs => $headers );
        my $res = $tx->res;
        return $callback->{on_error}->( sprintf( '%d %s', $res->code, $res->default_message ) )
            if $tx->error;
        push @args, $res->json;
    } else {
        push @args, undef;
    }

    push @args, { %$dat }; # append rest of the response data as hashref

    return $callback->{on_finished}->(@args);
}

sub _ua {
    my $self = shift;

    unless ( $self->{_ua} ) {
        $self->{_ua} = Mojo::UserAgent->new();

        my $user_agent = "Mojolicious::Plugin::Web::Auth/$Mojolicious::Plugin::Web::Auth::VERSION";
        if ($Mojolicious::VERSION >= 4.50) {
            $self->{_ua}->transactor->name($user_agent);
            $self->{_ua}->proxy->detect; # supports ENV proxies
        } else {
            # Mojo::UserAgent#name is deprecated from version 4.50
            $self->{_ua}->name($user_agent);
            # Mojo::UserAgent#detect_proxy is deprecated from version 4.50
            $self->{_ua}->detect_proxy();
        }
    }

    return $self->{_ua};
}

sub _response_to_hash {
    my ( $self, $res ) = @_;
    my $types = Mojolicious::Types->new;
    $types->type(json => ['application/json', 'text/javascript']);
    my $exts = $types->detect( $res->headers->content_type );
    return ( scalar(@$exts) && $exts->[0] eq 'json' )
        ? $res->json
        : Mojo::Parameters->new( $res->body )->to_hash;
}

# default state param generator copy from Plack::Session::State
sub _state_generator {
    Digest::SHA::sha1_hex(rand() . $$ . {} . time) 
}

1;
