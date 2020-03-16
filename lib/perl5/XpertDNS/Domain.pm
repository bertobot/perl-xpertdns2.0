package XpertDNS::Domain;

use strict;
use Request;
use XpertDNS::Record;
use Mojo::DOM;
use Class::MethodMaker [
    scalar  => [ qw(req baseurl domain slave status owner group_owner records domain_id) ],
    new     => [ qw(-init new) ],
];

sub init {
    my ($self, $args) = @_;

    $self->req($args->{req} || new Request());
    $self->baseurl($args->{baseurl} || 'https://www.xpertdns.com/admin/index.php');

    $self->domain($args->{domain});
    $self->slave($args->{slave});
    $self->status($args->{status});
    $self->owner($args->{owner});
    $self->group_owner($args->{group_owner});
    $self->domain_id($args->{domain_id});

    $self->__parse_records();
}

sub __parse_records {
    my ($self) = @_;

    my @records = ();

    my $data = {
        'state'         => 'logged_in',
        'mode'          => 'records',
        'domain'        => $self->domain,
    };

    my $r = $self->req->get($self->baseurl, { data => $data });

    if ($r->ok) {
        my $dom = new Mojo::DOM($r->body);
        for my $tr ($dom->find('tr')->each) {
            my @tds = $tr->children('td')->each();
            next if @tds != 11;

            push @records, new XpertDNS::Record({
                req         => $self->req,
                baseurl     => $self->baseurl,
        
                name        => $tds[0]->children('a')->first->text,
                type        => $tds[1]->text,
                address     => $tds[2]->text,
                distance    => $tds[3]->text,
                weight      => $tds[4]->text,
                port        => $tds[5]->text,
                caa_flag    => $tds[6]->text,
                caa_tag     => $tds[7]->text,
                ttl         => $tds[8]->text,
                dyndns      => $tds[9]->text,

                record_id   => $tds[10]->children('input')->first->attr('value'),
            });
        }
    }

    $self->records(\@records);
}

sub activate {
    my ($self) = @_;
    my $data = {
        'state'         => 'logged_in',
        'mode'          => 'domains',
        'domain_mode'   => 'activate_domain',
        'domain'        => $self->domain,
        'domain_id'     => $self->id,
    };

    return $self->req->get($self->baseurl, { data => $data })->ok;
}

sub deactivate {
    my ($self) = @_;
    my $data = {
        'state'         => 'logged_in',
        'mode'          => 'domains',
        'domain_mode'   => 'deactivate_domain',
        'domain'        => $self->domain,
        'domain_id'     => $self->id,
    };

    return $self->req->get($self->baseurl, { data => $data })->ok;
}

sub delete {
    my ($self) = @_;
    my $data = {
        'state'         => 'logged_in',
        'mode'          => 'domains',
        'domain_mode'   => 'delete',
        'domain'        => $self->domain,
        'domain_id'     => $self->id,
    };

    return $self->req->get($self->baseurl, { data => $data })->ok;
}

sub add_record {
    my ($self, $record) = @_;
    my $d = {
        'state'         => 'logged_in',
        'mode'          => 'records',
        'record_mode'   => 'add_record_now',
        'domain'        => $self->domain(),
    };
    my %data = (%$d, %{ $record->hash() } );

    $self->req->post($self->baseurl, { data => \%data })->ok;
}

sub update_record {
    my ($self, $record) = @_;
    my %data = (%{
        'state'         => 'logged_in',
        'mode'          => 'records',
        'record_mode'   => 'edit_record_now',
        'domain'        => $self->domain,
    }, %{$record->hash});

    $self->req->post($self->baseurl, { data => \%data })->ok;
}

sub delete_records {
    my ($self, $records) = @_;
    my $data = {
        'state'         => 'logged_in',
        'mode'          => 'records',
        'record_mode'   => 'delete_recs_now',
        'domain'        => $self->domain,
        'del_id'        => join(',', map { $_->record_id } @$records),
    };

    $self->req->post($self->baseurl, { data => $data })->ok;
}

sub hash {
    my ($self, $args) = @_;
    return {
        domain      => $self->domain,
        slave       => $self->slave,
        status      => $self->status,
        owner       => $self->owner,
        group_owner => $self->group_owner,
        records     => [ map { $_->hash } @{$self->records} ],
    };
}

1;

