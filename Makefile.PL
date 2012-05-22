use inc::Module::Install;
name 'Net-Jenkins';
all_from 'lib/Net/Jenkins.pm';

# requires '';

tests 't/*.t';
# author_tests 'xt';
# test_requires 'Test::More';
# auto_set_repository;
auto_include;
WriteAll;
