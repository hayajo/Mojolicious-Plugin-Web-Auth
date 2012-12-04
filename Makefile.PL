use inc::Module::Install;
use Module::Install::Repository;
use Module::Install::ReadmePodFromPod;
name 'Mojolicious-Plugin-Web-Auth';
all_from 'lib/Mojolicious/Plugin/Web/Auth.pm';
readme_pod_from 'lib/Mojolicious/Plugin/Web/Auth.pm';

requires 'Mojolicious';

# for Twitter
requires 'Net::Twitter::Lite';
# for Dropbox
requires 'WebService::Dropbox';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

WriteAll;
