package Net::Jenkins::Job::Build;
use Moose;
use methods;
use DateTime;


# {
# 'number' => 2,
# 'url' => 'http://localhost:8080/job/Phifty/2/'
# },

has number => ( is => 'rw' , isa => 'Int' );

has url => ( is => 'rw', isa => 'Str' );

has job => ( is => 'rw', isa => 'Net::Jenkins::Job' );

has _api => ( is => 'rw' , isa => 'Net::Jenkins' );

method details {  
    return $self->_api->get_build_details( $self->job->name, $self->number );
}

method result {
    return $self->details->{result};
}

method building {
    return $self->details->{building};
}

method id {
    return $self->details->{id};
}

method name {
    return $self->details->{fullDisplayName};
}

method created_at {
    return DateTime->from_epoch( epoch => $self->details->{timestamp} );
}

method console {
    return $self->_api->get_build_console( $self->job->name, $self->number );
}

method console_handle {
    return $self->_api->get_build_console_handle( $self->job->name , $self->number );
}

1;
