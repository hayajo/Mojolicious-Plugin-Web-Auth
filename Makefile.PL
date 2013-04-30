use inc::Module::Install;
use Module::Install::Repository;
name 'Mojolicious-Plugin-Web-Auth';
all_from 'lib/Mojolicious/Plugin/Web/Auth.pm';

requires 'Mojolicious' => '3.02';
requires 'Net::OAuth'  => '0.28';
requires 'JSON'        => '2.53';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
