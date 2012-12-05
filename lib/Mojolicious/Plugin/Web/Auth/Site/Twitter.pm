package Mojolicious::Plugin::Web::Auth::Site::Twitter;

use Mojo::Base -base;
use LWP::Protocol::Net::Curl;
use Net::Twitter::Lite;

has 'key';
has 'secret';
has 'user_info' => 1;

sub moniker { 'twitter' }

sub _nt {
    my ($self) = @_;
    my $nt = Net::Twitter::Lite->new(
        consumer_key    => $self->key,
        consumer_secret => $self->secret,
        legacy_lists_api => 0,
    );
    return $nt;
}

sub auth_uri {
    my ($self, $c, $callback_uri) = @_;
    $callback_uri or die "Missing mandatory parameter: callback_uri";

    my $nt = $self->_nt();
    my $redirect_uri = $nt->get_authorization_url( callback => $callback_uri );
    $c->session( auth_twitter => [ $nt->request_token, $nt->request_token_secret, ] );

    return $redirect_uri;
}

sub callback {
    my ($self, $c, $callback) = @_;

    my $cookie = $c->session('auth_twitter')
        or return $callback->{on_error}->("Session error");

    my $nt = $self->_nt();
    $nt->request_token($cookie->[0]);
    $nt->request_token_secret($cookie->[1]);
    my $verifier = $c->req->param('oauth_verifier');
    my @args = $nt->request_access_token(verifier => $verifier);
    splice @args, 2;
    push @args, $nt->verify_credentials if ($self->user_info );

    return $callback->{on_finished}->(@args);
}

1;

__END__
