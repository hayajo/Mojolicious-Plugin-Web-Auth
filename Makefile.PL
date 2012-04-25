use inc::Module::Install;
name 'Mojolicious-Plugin-Web-Auth';
all_from 'lib/Mojolicious/Plugin/Web/Auth.pm';

requires 'Mojolicious';

# for Twitter
requires 'Net::Twitter::Lite';
# for Dropbox
requires 'WebService::Dropbox';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

WriteAll;
