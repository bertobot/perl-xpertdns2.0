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

# json-ify your xpertdns estate

my @list = ();

foreach my $name (@{ $x->names }) {
    push @list, { name => $name, detail => $x->get($name)->hash() };
}

printf("%s\n", encode_json(\@list));

