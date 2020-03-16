package XpertDNS::Record;

use strict;
use Class::MethodMaker [
    scalar  => [qw(name type address distance weight port caa_flag caa_tag ttl dyndns record_id)],
    new     => [qw(-init new)],
];

sub init {
    my ($self, $args) = @_;

    $self->name($args->{name});
    $self->type($args->{type});
    $self->address($args->{address});
    $self->distance($args->{distance});
    $self->weight($args->{weight});
    $self->port($args->{port});
    $self->caa_flag($args->{caa_flag});
    $self->caa_tag($args->{caa_tag});
    $self->ttl($args->{ttl});
    $self->dyndns($args->{dyndns});
    $self->record_id($args->{record_id});
}

sub hash {
    my ($self) = @_;
    
    return {
        name        => $self->name,
        type        => $self->type,
        address     => $self->address,
        weight      => $self->weight,
        port        => $self->port,
        caa_flag    => $self->caa_flag,
        caa_tag     => $self->caa_tag,
        ttl         => $self->ttl,
        dyndns      => $self->dyndns,
        record_id   => $self->record_id,
    };
}

1;

