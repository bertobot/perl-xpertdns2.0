#!/usr/bin/perl
use strict;
use lib 'lib/perl5';
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

