# NAME

Mojolicious::Plugin::Web::Auth - Authentication plugin for Mojolicious

# SYNOPSIS

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

# DESCRIPTION

[Mojolicious::Plugin::Web::Auth](https://metacpan.org/pod/Mojolicious::Plugin::Web::Auth) is an authentication plugin for [Mojolicious](https://metacpan.org/pod/Mojolicious).

# METHODS

[Mojolicious::Plugin::Web::Auth](https://metacpan.org/pod/Mojolicious::Plugin::Web::Auth) inherits all methods from [Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin).

# OPTIONS

[Mojolicious::Plugin::Web::Auth](https://metacpan.org/pod/Mojolicious::Plugin::Web::Auth) supports the following options.

## `module`

This is a module name for authentication plugins.

Dropbox, Facebook, Github, Google, Instagram, Twitter.

## `key`

Consumer key.

## `secret`

Consumer secret.

## `scope`

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

## `validate_state`

Optional: OAuth 2.0 only. Default value is 1, see [http://tools.ietf.org/html/rfc6819#section-5.3.5](http://tools.ietf.org/html/rfc6819#section-5.3.5).

## `on_finished`

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

### arguments

- OAuth 1.0(A)

    Dropbox, Twitter, etc.

    - Mojolicious::Controller
    - access\_token
    - access\_secret
    - user\_info ( enabled 'user\_info' )

- OAuth 2.0

    Facebook, Github, Google, Instagram, etc.

    - Mojolicious::Controller
    - access\_token
    - user\_info ( enabled 'user\_info' )
    - rest of the response data (HASHREF)

        id\_token, expires, refresh\_token, etc.

## `on_error`

This is a callback is run on authentication errors.

# AUTHOR

hayajo <hayajo@cpan.org>

# CONTRIBUTORS

Many thanks to the contributors for their work.

- FAYLAND
- uzulla@github
- sachinjsk@github
- mala@github
- shohey1226@github
- levonet@github
- oalders@github
- ccakes@github

# COPYRIGHT

Copyright 2013- hayajo

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Amon2::Auth](https://metacpan.org/pod/Amon2::Auth)
