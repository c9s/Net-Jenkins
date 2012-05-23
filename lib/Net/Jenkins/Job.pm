package Net::Jenkins::Job;
use methods;
use Moose;
use Net::Jenkins::Job::Build;
use Net::Jenkins::Job::QueueItem;

has name => ( is => 'rw' , isa => 'Str' );

# 'color' => 'grey',
has color => ( is => 'rw' );

# 'url' => 'http://localhost:8080/job/Phifty/',
has url => ( is => 'rw' , isa => 'Str' );

has _api => ( is => 'rw' , isa => 'Net::Jenkins' );

method delete {
    return $self->_api->delete_job( $self->name );
}

method update ($xml) {
    return $self->_api->update_job( $self->name, $xml );
}

method copy ($new_job_name) {
    return $self->_api->copy_job( $new_job_name , $self->name );
}


method enable {
    return $self->_api->enable_job($self->name);
}

method disable {
    return $self->_api->disable_job($self->name);
}


# trigger a build
method build {
    return $self->_api->build_job($self->name);
}


# get job configuration
method config {
    return $self->_api->get_job_config( $self->name );
}

method description {
    return $self->config->{description};
}

method desc {
    return $self->description;
}

method in_queue {
    return $self->config->{inQueue};
}

method queue_item {
    return Net::Jenkins::Job::QueueItem->new( %{ $self->config->{queueItem} } , _api => $self->_api , job => $self );
}

# get builds
method builds {
    return map { Net::Jenkins::Job::Build->new( %$_ , _api => $self->_api, job => $self ) } 
            $self->_api->get_builds( $self->name );
}

method last_build {
    my $b = $self->config->{lastBuild};
    return Net::Jenkins::Job::Build->new( %$b , _api => $self->_api , job => $self ) if $b && %$b;
}

method first_build {
    my $b = $self->config->{firstBuild};
    return Net::Jenkins::Job::Build->new( %$b , _api => $self->_api , job => $self ) if $b && %$b;
}

1;
