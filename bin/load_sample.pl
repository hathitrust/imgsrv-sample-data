#!/usr/bin/env perl

use strict;

use lib "$ENV{SDRROOT}/mdp-lib";
use Context;
use Database;
use Utils;
use CGI;

use FindBin;

my $C = new Context;
my $cgi = new CGI;
$C->set_object('CGI', $cgi);
my $config = new MdpConfig("$ENV{SDRROOT}/mdp-lib/Config/uber.conf");
$C->set_object('MdpConfig', $config);

my $db = new Database('root', 'TIMTOWTDIBSCINABTE', 'ht', 'mariadb');
my $dbh = $db->get_DBH();

my $check = $dbh->selectrow_hashref(qq{SELECT * FROM rights_current WHERE namespace = ? AND id = ?}, undef, 'loc', 'ark:/13960/t5v69h717');
if ( ref($check) && $$check{id} ) {
    exit;
}

open my $fh, '<', "$FindBin::Bin/../sample_data.sql" or die "Cannot open file $!";
while ( my $sql = <$fh> ) {
    chomp $sql;
    next unless ( $sql );
    $dbh->do($sql) or warn DBI->errstr;
}
