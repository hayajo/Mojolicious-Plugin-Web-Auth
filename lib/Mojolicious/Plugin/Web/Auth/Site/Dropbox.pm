package Mojolicious::Plugin::Web::Auth::Site::Dropbox;

use Mojo::Base qw/Mojolicious::Plugin::Web::Auth::OAuth/;

has user_info         => 1;
has request_token_url => 'https://api.dropbox.com/1/oauth/request_token';
has authorize_url     => 'https://api.dropbox.com/1/oauth/authorize';
has access_token_url  => 'https://api.dropbox.com/1/oauth/access_token';
has user_info_url     => 'https://api.dropbox.com/1/account/info';

sub moniker {'dropbox'};

=pod

#login on OAuth1 and then transitioning from OAuth 1 to OAuth 2 token

$auth->tokenV2fromV1($c, $t, $s);
$auth->tokenV1disable($c, $t, $s);
$auth->tokenV2disable($c, $t2);

=cut
has token_from_oauth1_url => 'https://api.dropbox.com/1/oauth2/token_from_oauth1';
has disable_access_token_url => 'https://api.dropboxapi.com/1/disable_access_token';
has authorize_header => 'Bearer';

sub tokenV2fromV1 {
    my ($self, $c, $tokenV1, $tokenV1_secret) = @_;
    my $tx =$c->ua->post($self->token_from_oauth1_url,
      form=>{
      "oauth_consumer_key" => $self->key,
      "oauth_nonce" => $$.$0.time,
      "oauth_signature" => join('&', $self->secret, $tokenV1_secret),
      "oauth_signature_method" => "PLAINTEXT",
      "oauth_timestamp" => time,
      "oauth_token" => $tokenV1,
      "oauth_version" => "1.0",
      },
    );
    ( my $res = $tx->success )
      or $c->app->log->error(join( ' ', 'POST', $self->token_from_oauth1_url, $tx->res->code, $tx->res->default_message ))
      and return undef;
    $res->json;
}

sub tokenV1disable {
  my ($self, $c, $tokenV1, $tokenV1_secret) = @_;
  my $tx =$c->ua->post($self->disable_access_token_url,
      form=>{
      "oauth_consumer_key" => $self->key,
      "oauth_nonce" => $$.$0.time,
      "oauth_signature" => join('&', $self->secret, $tokenV1_secret),
      "oauth_signature_method" => "PLAINTEXT",
      "oauth_timestamp" => time,
      "oauth_token" => $tokenV1,
      "oauth_version" => "1.0",
      },
    );
    ( my $res = $tx->success )
      or $c->app->log->error(join( ' ', 'POST', $self->disable_access_token_url, $tx->res->code, $tx->res->default_message ))
      and return undef;
    $res->json;#An empty JSON dictionary, which indicates success.
}

sub tokenV2disable {
  my ($self, $c, $tokenV2,) = @_;
  my $tx =$c->ua->post($self->disable_access_token_url, {'Authorization' => $self->authorize_header.' '. $tokenV2});
  ( my $res = $tx->success )
    or $c->app->log->error(join( ' ', 'POST', $self->disable_access_token_url, $tx->res->code, $tx->res->default_message ))
      and return undef;
  $res->json;#An empty JSON dictionary, which indicates success.
}

1;
