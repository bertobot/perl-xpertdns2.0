# XpertDNS Perl API
This is a

## Synopsis
```perl
#!/usr/bin/perl
use strict;
use XpertDNS;
use Data::Dumper;
use JSON;
use Getopt::Long;

$Data::Dumper::Indent = 1;

my $opt_email;
my $opt_password;

GetOptions(
    "email=s"       => \$opt_email,
    "password=s"    => \$opt_password,
);

if (! $opt_email) {
    die "missing --email <email address>\n";
}

if (! $opt_password) {
    die "missing --password <password>\n";
}

my $x = new XpertDNS({
    email       => $opt_email,
    password    => $opt_password,
});

my $domain_to_modify = $x->get($x->names()->[0]);

my $r = $x->get($domain_to_modify->domain)->add_record(new XpertDNS::Record({
    name    => sprintf("test001.%s", $domain_to_modify->domain),
    type    => 'A',
    ttl     => 3600,
    address => '10.0.1.1',
}));

printf("%s\n", $r);
```

## Installation
    # installs at /usr/local/lib/site_perl
    sudo make install

## Documentation
### XpertDNS
#### property: domains
#### method: names()
#### method: get()
#### method: hash()

### XpertDNS::Domain
#### property: domain
#### property: slave
#### property: status
#### property: owner
#### property: group_owner
#### property: domain_id
#### property: records

#### method: activate()
#### method: deactivate()
#### method: delete()
#### method: add_record(record)
#### method: update_record(record)
#### method: delete_record(record)
#### method: hash()

### XpertDNS::Record
#### property: name
#### property: type
#### property: address
#### property: weight
#### property: port
#### property: caa_flag
#### property: caa_tag
#### property: ttl
#### property: dyndns
#### property: record_id
#### method: hash()

