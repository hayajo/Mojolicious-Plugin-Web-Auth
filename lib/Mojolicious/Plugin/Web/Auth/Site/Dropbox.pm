package Mojolicious::Plugin::Web::Auth::Site::Dropbox;

use Mojo::Base -base;
use WebService::Dropbox;

has 'key';
has 'secret';
has 'user_info' => 1;

sub moniker { 'dropbox' }

sub _wd {
    my ($self) = @_;
    my $wd = WebService::Dropbox->new({
        key    => $self->key,
        secret => $self->secret,
    });
    return $wd;
}

sub auth_uri {
    my ($self, $c, $callback_uri) = @_;
    $callback_uri or die "Missing mandatory parameter: callback_uri";

    my $wd           = $self->_wd();
    my $redirect_uri = $wd->login($callback_uri);
    $c->session( auth_dropbox => [ $wd->request_token, $wd->request_secret ] );

    return $redirect_uri;
}

sub callback {
    my ($self, $c, $callback) = @_;

    my $cookie = $c->session('auth_dropbox')
        or return $callback->{on_error}->("Session error");

    my $wd = $self->_wd();
    $wd->request_token( $cookie->[0] );
    $wd->request_secret( $cookie->[1] );

    $wd->auth
        or return $callback->{on_error}->( $wd->error );

    my @args = ($wd->access_token, $wd->access_secret);
    push @args, $wd->account_info if ( $self->user_info );

    return $callback->{on_finished}->(@args);
}

1;

__END__
