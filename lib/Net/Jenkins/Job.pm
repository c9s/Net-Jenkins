package Net::Jenkins::Job;
use methods;
use Moose;

has name => ( is => 'rw' , isa => 'Str' );

# 'color' => 'grey',
has color => ( is => 'rw' );

# 'url' => 'http://localhost:8080/job/Phifty/',
has url => ( is => 'rw' , isa => 'Str' );

has _api => ( is => 'rw' );

method delete {
    return $self->_api->delete_job( $self->name );
}

method update ($xml) {
    return $self->_api->update_job( $self->name, $xml );
}

method copy ($new_job_name) {
    return $self->_api->copy_job( $new_job_name , $self->name );
}


method config {
    return $self->_api->get_job_config( $self->name );
}

method builds {
    return @{ $self->config->{builds} };
}

1;
