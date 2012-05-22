package Net::Jenkins;
use strict;
use warnings;
our $VERSION = '0.01';
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

method get_json( $uri ) {
    my $response = $self->user_agent->get($uri);
    return decode_json $response->decoded_content if $response->is_success;
}

method get_jenkins_info {
    my $uri = $self->get_base_url . '/api/json';
    my $json = $self->get_json( $uri );
    return $json;
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
