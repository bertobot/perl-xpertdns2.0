package XpertDNS;

use strict;
use XpertDNS::Domain;
use Mojo::DOM;
use Request;
use Class::MethodMaker [
    scalar  => [ qw(req baseurl error domains) ],
    new     => [ qw(-init new) ],
];

sub init {
    my ($self, $args) = @_;

    $self->req(new Request());
    $self->baseurl($args->{baseurl} || 'https://www.xpertdns.com/admin/index.php');
    if ($self->__login($args)) {
        $self->__parse_domains();
    }
}

sub __login {
    my ($self, $args) = @_;

    my $data = {
        'state'     => 'login',
        email       => $args->{email} || $args->{username},
        password    => $args->{password},
    };

    my $r = $self->req->post($self->baseurl, { data => $data });

    if (! $r->ok) {
        $self->error($r->res->decoded_content);
        return 0;
    }
    return 1;
}

sub __parse_domains {
    my ($self, $args) = @_;

    my @domains = ();

    my $data = {
        'state' => 'logged_in',
        'mode'  => 'domains',
    };

    my $r = $self->req->get($self->baseurl, { data => $data });

    if ($r->ok) {
        my $dom = new Mojo::DOM($r->body);
        for my $tr ($dom->find('tr')->each) {
            my @tds = $tr->children('td')->each();
            next if @tds != 8;

            my $domain_id = $tds[7]->children('a')->first->attr('href') =~ /domain_id=(\d+)/ ? $1 : 0;

            push @domains, new XpertDNS::Domain({
                req     => $self->req,
                baseurl => $self->baseurl,

                domain  => $tds[0]->children('a')->first->text,
                slave   => ($tds[1]->text eq 'No') ? 0 : 1,
                status  => $tds[2]->text,
                owner   => $tds[4]->children('a')->first->text,
                group_owner => $tds[5]->children('a')->first->text,

                domain_id   => $domain_id,
            });
        }

        $self->domains(\@domains);
    }
}

sub names {
    my ($self) = @_;
    return [ map { $_->domain } @{$self->domains} ];
}

sub get {
    my ($self, $name) = @_;
    my $target = [ grep { $_->domain eq $name } @{ $self->domains } ];
    return $target->[0] if @$target > 0;
}

sub hash {
    my ($self) = @_;
    return [ map { $_->hash } @{$self->domains} ];
}

1;

