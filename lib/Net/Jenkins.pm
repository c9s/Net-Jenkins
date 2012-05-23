package Net::Jenkins;
use strict;
use warnings;
our $VERSION = '0.01';
use Net::Jenkins::Job;
use LWP::UserAgent;
use Moose;
use methods;
use URI;
use JSON;

has protocol => ( is => 'rw', isa => 'Str', default => 'http' );

has host => ( is => 'rw', isa => 'Str' , default => 'localhost' ) ;

has port => ( is => 'rw', isa => 'Int' , default => 8080 ) ;

has user_agent => ( is => 'rw' , default => sub { 
    return LWP::UserAgent->new;
});

method get_base_url {
    return $self->protocol 
                . '://' . $self->host 
                . ':' . $self->port;
}


method post_url ($uri,%args) {
    return $self->user_agent->post( $uri , \%args );
}

method get_url ($uri) {
    return $self->user_agent->get($uri);
}

method get_json ( $uri ) {
    my $response = $self->user_agent->get($uri);
    return decode_json $response->decoded_content if $response->is_success;
}

method get_info {
    my $uri = $self->get_base_url . '/api/json';
    return $self->get_json( $uri );
}

method mode {
    return $self->get_info->{mode};
}

method jobs {
    return map { Net::Jenkins::Job->new( %$_ , _api => $self ) } @{ $self->get_info->{jobs} };
}

method use_security {
    return $self->get_info->{useSecurity};
}

method use_crumbs {
    return $self->get_info->{useCrumbs};
}

method views {
    return @{ $self->get_info->{views} };
}

method restart {
    my $uri = $self->get_base_url . '/restart';
    return $self->get_url( $uri )->is_success;
}


=head3 create_job

mode:

    hudson.model.FreeStyleProject (default)
    hudson.maven.MavenModuleSet
    hudson.matrix.MatrixProject
    hudson.model.ExternalJob
    copy

=cut

method create_job ($job_name,$xml) {
    my $uri = URI->new( $self->get_base_url . '/createItem' );
    $uri->query_form( name => $job_name );
    my $response = $self->user_agent->post( $uri , "Content-Type" => "application/xml" , Content => $xml );
    return $response->code == 200;
}

method update_job ($job_name,$xml) {
    my $uri = URI->new( $self->job_url($job_name) . '/config.xml' );
    my $response = $self->user_agent->post( $uri , "Content-Type" => "application/xml" , Content => $xml );
    return $response->code == 200;
}

method copy_job ($job_name, $from_job_name) {
    my $uri = URI->new( $self->get_base_url . '/createItem' );

    # name=NEWJOBNAME&mode=copy&from=FROMJOBNAME
    $uri->query_form( name => $job_name , from => $from_job_name , mode => 'copy' );
    my $response = $self->user_agent->post( $uri );
    return $response->code == 302 ? 1 : 0;
}

method delete_job ($job_name) {
    my $uri = $self->job_url($job_name) . '/doDelete';
    return $self->post_url( $uri )->code == 302 ? 1 : 0;
}

method get_job_config ($job_name) {
    my $uri = $self->job_url($job_name) . '/api/json';
    my $config = $self->get_json($uri);
    return $config;
}


# ================================
# URL methods
# ================================
method job_url ($job_name) {
    return $self->get_base_url . '/job/' . $job_name;
}

1;
__END__

=head1 NAME

Net::Jenkins -

=head1 SYNOPSIS

  use Net::Jenkins;

=head1 DESCRIPTION

Net::Jenkins is

=head1 AUTHOR

Yo-An Lin E<lt>cornelius.howl {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
