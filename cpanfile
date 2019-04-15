requires 'perl', '5.010001';

# requires 'Some::Module', 'VERSION';
requires 'Mojolicious',     '>= 7.13';
requires 'Net::OAuth',      '>= 0.28';
requires 'IO::Socket::SSL', '>= 1.77';

on test => sub {
    requires 'Test::More', '0.88';
};

# vi: set ft=perl :
