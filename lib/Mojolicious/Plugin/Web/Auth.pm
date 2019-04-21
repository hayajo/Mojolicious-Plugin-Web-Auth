package Mojolicious::Plugin::Web::Auth;

use strict;
use warnings;

our $VERSION = '0.17';

use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $args ) = @_;
    my $module = delete $args->{module} or die "Missing mandatory parameter: module";
    my $klass  = join '::', __PACKAGE__, 'Site', $module;
    if ($Mojolicious::VERSION >= 5.81) {
        Mojo::Loader::load_class($klass);
    } else {
        Mojo::Loader->load($klass);
    }

    my $moniker           = $klass->moniker();
    my $authenticate_path = delete $args->{authenticate_path} || "/auth/${moniker}/authenticate";
    my $callback_path     = delete $args->{callback_path}     || "/auth/${moniker}/callback";

    # handlers
    my $on_finished = delete $args->{on_finished} or die "Missing mandatory parameter: on_finished";
    my $on_error    = delete $args->{on_error} || sub {
        my ( $c, $err ) = @_;
        die "Authentication error in $module: $err";
    };

    # auth object
    my $auth = $klass->new(%$args);

    $app->hook( before_dispatch => sub {
        my $c    = shift;
        my $path = $c->req->url->path;
        if ( $path->contains($authenticate_path) ) {
            my $forwarded_proto = $c->req->headers->header('x-forwarded-proto');
            $c->req->url->base->scheme('https') if (defined $forwarded_proto && $forwarded_proto eq 'https');
            my $callback = $c->req->url->path($callback_path)->to_abs;
            return $c->redirect_to( $auth->auth_uri( $c, $callback ) );
        }
        elsif ( $path->contains($callback_path) ) {
            return $auth->callback( $c, +{
                on_finished => sub {
                    $on_finished->($c, @_);
                },
                on_error => sub {
                    $on_error->($c, @_);
                },
            } );
        }
    } );

    return $self;
}

1;

__END__

=head1 NAME

Mojolicious::Plugin::Web::Auth - Authentication plugin for Mojolicious

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Web::Auth',
      module      => 'Twitter',
      key         => 'Twitter consumer key',
      secret      => 'Twitter consumer secret',
      on_finished => sub {
          my ( $c, $access_token, $access_secret ) = @_;
          ...
      },
  );

  # Mojolicious::Lite
  plugin 'Web::Auth',
      module      => 'Twitter',
      key         => 'Twitter consumer key',
      secret      => 'Twitter consumer secret',
      on_finished => sub {
          my ( $c, $access_token, $access_secret ) = @_;
          ...
      };


  ### default authentication endpoint: /auth/{moniker}/authenticate
  # e.g.)
  # /auth/twitter/authenticate
  # /auth/facebook/authenticate
  ### default callback endpoint: /auth/{moniker}/callback
  # e.g.)
  # /auth/twitter/callback
  # /auth/facebook/callback

  # If, for example, your Instagram app needs more permissions than the
  # defaults allow:

  # Mojolicious
  $self->plugin('Web::Auth',
      module      => 'Instagram',
      key         => 'Instagram consumer key',
      secret      => 'Instagram consumer secret',
      on_finished => sub {
          my ( $c, $access_token, $access_secret ) = @_;
          ...
      },
      authorize_url => 'https://api.instagram.com/oauth/authorize?scope=public_content',
  );

=head1 DESCRIPTION

L<Mojolicious::Plugin::Web::Auth> is an authentication plugin for L<Mojolicious>.

=head1 METHODS

L<Mojolicious::Plugin::Web::Auth> inherits all methods from L<Mojolicious::Plugin>.

=head1 OPTIONS

L<Mojolicious::Plugin::Web::Auth> supports the following options.

=head2 C<module>

This is a module name for authentication plugins.

Dropbox, Facebook, Github, Google, Instagram, Twitter.

=head2 C<key>

Consumer key.

=head2 C<secret>

Consumer secret.

=head2 C<scope>

Optional: OAuth 2.0 only.

  # Facebook
  plugin 'Web::Auth',
      module      => 'Facebook',
      key         => 'Facebook App ID',
      secret      => 'Facebook App Secret',
      scope       => 'email,user_birthday',
      on_finished => sub {
          my ( $c, $access_token, $user_info ) = @_;
          ...
      };

=head2 C<validate_state>

Optional: OAuth 2.0 only. Default value is 1, see L<http://tools.ietf.org/html/rfc6819#section-5.3.5>.


=head2 C<on_finished>

  # Mojolicious::Lite
  plugin 'Web::Auth',
      module      => 'Twitter',
      key         => 'Twitter consumer key',
      secret      => 'Twitter consumer secret',
      on_finished => sub {
          my ( $c, $access_token, $access_secret, $user_ino ) = @_;
          ...
      };

This callback is run when authentication was finished.

=head3 arguments

=over 4

=item * OAuth 1.0(A)

Dropbox, Twitter, etc.

=over 4

=item Mojolicious::Controller

=item access_token

=item access_secret

=item user_info ( enabled 'user_info' )

=back

=item * OAuth 2.0

Facebook, Github, Google, Instagram, etc.

=over 4

=item Mojolicious::Controller

=item access_token

=item user_info ( enabled 'user_info' )

=item rest of the response data (HASHREF)

id_token, expires, refresh_token, etc.

=back

=back

=head2 C<on_error>

This is a callback is run on authentication errors.

=head1 AUTHOR

hayajo E<lt>hayajo@cpan.orgE<gt>

=head1 CONTRIBUTORS

Many thanks to the contributors for their work.

=over 4

=item FAYLAND

=item uzulla@github

=item sachinjsk@github

=item mala@github

=item shohey1226@github

=item levonet@github

=item oalders@github

=item ccakes@github

=back

=head1 COPYRIGHT

Copyright 2013- hayajo

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mojolicious>, L<Amon2::Auth>

=cut
