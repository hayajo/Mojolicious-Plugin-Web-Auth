requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';
requires 'Mojolicious',     '>= 3.02';
requires 'Net::OAuth',      '>= 0.28';
requires 'IO::Socket::SSL', '>= 1.77';

on test => sub {
    requires 'Test::More', '0.88';
};

# vi: set ft=perl :
