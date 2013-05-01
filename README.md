# NAME

Mojolicious::Plugin::Web::Auth - Authentication plugin for Mojolicious

# SYNOPSIS

    # Mojolicious
    $self->plugin('Web::Auth'
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

# DESCRIPTION

[Mojolicious::Plugin::Web::Auth](http://search.cpan.org/perldoc?Mojolicious::Plugin::Web::Auth) is authentication plugin for [Mojolicious](http://search.cpan.org/perldoc?Mojolicious).

# METHODS

[Mojolicious::Plugin::Directory](http://search.cpan.org/perldoc?Mojolicious::Plugin::Directory) inherits all methods from [Mojolicious::Plugin](http://search.cpan.org/perldoc?Mojolicious::Plugin).

# OPTIONS

[Mojolicious::Plugin::Web::Auth](http://search.cpan.org/perldoc?Mojolicious::Plugin::Web::Auth) supports the following options.

## `module`

This is a module name for authentication plugins.

Dropbox, Facebook, Github, Google, Twitter.

## `key`

consumer key

## `secret`

consumer secret

## `on_finished`

    # Mojolicious::Lite
    plugin 'Web::Auth',
        module      => 'Twitter',
        key         => 'Twitter consumer key',
        secret      => 'Twitter consumer secret',
        on_finished => sub {
            my ( $c, $access_token, $access_secret ) = @_;
            ...
        };

This is a callback when authentication was finished.

## `on_error`

This is a callback when authentication was errored.

# AUTHOR

hayajo <hayajo@cpan.org>

# SEE ALSO

[Mojolicious](http://search.cpan.org/perldoc?Mojolicious), [Amon2::Auth](http://search.cpan.org/perldoc?Amon2::Auth)
