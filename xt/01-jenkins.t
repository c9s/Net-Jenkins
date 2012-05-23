#!/usr/bin/env perl
use lib 'lib';
use Net::Jenkins;
use File::Read;
use Test::More;

my $jenkins = Net::Jenkins->new;
my $summary = $jenkins->summary;
my @views = $jenkins->views;
my $mode = $jenkins->mode;

ok $summary;

my $xml = read_file 'xt/config.xml'; 

ok $jenkins->create_job( 'Phifty', $xml ) , "job created";
ok $jenkins->copy_job( 'test2' , 'Phifty' );

my @jobs = $jenkins->jobs;
ok @jobs;

for my $job ( $jenkins->jobs ) {

    ok $job->build;

    my $config = $job->config;

    ok $config;
    ok $job->name;

    $job->last_build->console;

    for my $build ( $job->builds ) {
        my $d = $build->details;
        ok $d;
        ok $d->{duration};
        ok $build->name;
        ok $build->id;
        ok $build->created_at;
    }

    # ok $job->delete;
}

# ok $jenkins->restart;  # returns true if success

done_testing;
