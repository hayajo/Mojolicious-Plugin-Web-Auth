package Mojolicious::Plugin::Web::Auth::Site::WordPress;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth/;

# OAuth 1.0 using WordPress plugin:
# https://github.com/WP-API/OAuth1

has 'wordpress_base_url';
has is_v1a            => 1;
has user_info         => 0;
has request_token_url => sub { $_[0]->url(path => '/oauth1/request' ) };
has authorize_url     => sub { $_[0]->url(path => '/oauth1/authorize' ) };
has access_token_url  => sub { $_[0]->url(path => '/oauth1/access' ) };

sub moniker { 'wordpress' }

sub url {
    my $klass   = shift;
    my %a       = (
        base_url    => $klass->wordpress_base_url,
        path        => undef,
        @_
    );
    my $base_url    = $a{base_url};
    $base_url       =~ s#/$##;
    "$base_url$a{path}";
};

1;
