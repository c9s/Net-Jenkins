package Net::Jenkins;
use strict;
use warnings;
our $VERSION = '0.01';
use Moose;
use methods;

has protocol => ( is => 'rw', isa => 'Str', default => 'http' );

has host => ( is => 'rw', isa => 'Str' , default => 'localhost' ) ;

has port => ( is => 'rw', isa => 'Int' , default => 8080 ) ;


sub get_base_url {

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
