use inc::Module::Install;
use Module::Install::Repository;
use Module::Install::ReadmePodFromPod;
name 'Mojolicious-Plugin-Web-Auth';
all_from 'lib/Mojolicious/Plugin/Web/Auth.pm';
readme_pod_from 'lib/Mojolicious/Plugin/Web/Auth.pm';

requires 'Mojolicious' => '3.02';

# for Twitter
requires 'Net::Twitter::Lite'       => '0.10004';
requires 'LWP::Protocol::Net::Curl' => '0.005';
# for Dropbox
requires 'WebService::Dropbox' => '1.01';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

WriteAll;
