package Net::Jenkins::Utils;
use warnings;
use strict;
use URI;
use Net::Jenkins;
use Net::Jenkins::Job;
use Net::Jenkins::Job::Build;
use parent 'Exporter';

our @EXPORT = qw(build_job_object);


sub build_job_object {
    my $job_url = shift;
    my $uri = URI->new($job_url);

    my $scheme = $uri->scheme;
    my $opaque = $uri->opaque;
    my $host = $uri->host;
    my $port = $uri->port;

    my $path = $uri->path;
    my $frag = $uri->fragment;

    my ($job_name) = ($job_url =~ m{job/([^/]+)});

    # create API object
    my $api = Net::Jenkins->new( host => $host, port => $port , scheme => $scheme );
    my $job = Net::Jenkins::Job->new( 
        name => $job_name,
        url => $job_url,
        _api => $api
    );
    return $job;
}


1;
__END__

=head2 build_job_object (Str $job_url)

@return Net::Jenkins::Job

=cut


