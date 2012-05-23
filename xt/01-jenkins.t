#!/usr/bin/env perl
use lib 'lib';
use Net::Jenkins;
use File::Read;
use Test::More;

my $host = $ENV{JENKINS_HOST} || 'localhost';
my $port = $ENV{JENKINS_PORT} || 8080;

my $jenkins = Net::Jenkins->new( host => $host , port => $port );
my $info = $jenkins->get_info;
my @views = $jenkins->views;
my $mode = $jenkins->mode;

ok $info;

my $xml = read_file 'xt/config.xml'; 

ok $jenkins->create_job( 'Phifty', $xml ) , "job created";
ok $jenkins->copy_job( 'test2' , 'Phifty' );

my @jobs = $jenkins->jobs;
ok @jobs;

for my $job ( $jenkins->jobs ) {
    ok $job->name;
    ok $jenkins->delete_job( $job->name ) , "Delete job";
}

# ok $jenkins->restart;  # returns true if success

done_testing;
