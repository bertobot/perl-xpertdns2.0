# XpertDNS Perl API
This is a perl interface into XpertDNS's web admin interface.  You can use this api to add, update, delete domains and records.

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
The *domains* property is an array of XpertDNS::Domain objects that are associated with your account.
#### method: names()
The *names()* method will give you an array ref of domain names associated with your account.
#### method: get(name)
The *get()* method returns an XpertDNS::Domain object of the domain name associated with your account.  Returns *undef* otherwise.
#### method: hash()
The *hash()* method returns a pure perl hash ref of the domains and their associated records that are associated with your account.

### XpertDNS::Domain
#### property: domain
The *domain* property is the name of the domain.
#### property: slave
The *slave* property is a boolean if the domain is a slave or not.
#### property: status
The *status* property denotes whether the domain/zone is active or not.
#### property: owner
The *owner* property denotes the user that owns the domain.
#### property: group_owner
The *group_owner* property denotes the group that owns the domain.
#### property: domain_id
The *domain_id* is the unique id for this domain according to XpertDNS.
#### property: records
The *records* property is an array of XpertDNS::Record objects that denotes that records for _this_ domain.

#### method: activate()
The *activate()* method activates _this_ domain.  Only works if the domain is deactivated.
#### method: deactivate()
The *deactivate()* method deactivates _this_ domain.  Only works if the domain is activated.
#### method: delete()
The *delete()* method deletes _this_ domain/zone.
#### method: add_record(record)
The *add_record()* method adds an XpertDNS::Record to the domain/zone.
#### method: update_record(record)
The *update_record()* method updates a record via an XpertDNS::Record object.
#### method: delete_record(record)
The *delete_record()* method deletes a record from the domain/zone.
#### method: hash()
The *hash()* method returns a pure hash representation of this domain and its associated records.

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

