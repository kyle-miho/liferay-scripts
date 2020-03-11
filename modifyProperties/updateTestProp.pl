#!/usr/bin/perl

use strict;
use warnings;

$^I = '.bak';
$/ = "";

#####################################################################
#MODIFY THESE
#TEST PROPERTY LOCATION
my $testProp ="/home/kyle/Liferay/public/master-portal/test.properties";
#ACCEPTANCE NAME
my $name = "kyle";
#####################################################################

#don't touch properties unless if needed
my $firstPropStart = qr"test.batch.dist.app.servers=\\";
my $firstPropEnd = "wildfly";
my $firstPropResult = "test.batch.dist.app.servers=tomcat";

my $secondPropStart = qr"test.batch.names\[acceptance-dxp\]=\\";
my $secondPropEnd = "\n\n";
my $secondPropResult = "test.batch.names[acceptance-dxp]=functional-tomcat90-mysql57-jdk8\n\n";

#replace kyle-miho with what you need
my $thirdPropSolo = qr"test\.batch\.run\.property\.query\[functional\-tomcat90\-mysql57\-jdk8\]=\(portal\.acceptance == true\)";
my $thirdPropResult = "test.batch.run.property.query[functional-tomcat90-mysql57-jdk8]=(portal.acceptance == $name)";

#ACTUAL CONTENT
my $data = read_file($testProp);
$data =~ s/$firstPropStart.*?$firstPropEnd/$firstPropResult/sm;
$data =~ s/$secondPropStart.*?$secondPropEnd/$secondPropResult/sm;
$data =~ s/$thirdPropSolo/$thirdPropResult/sm;
write_file($testProp,$data);

#FUNCTIONS

sub read_file {
    my ($filename) = @_;
 
    if (-e $filename) {
        print "The file exists\n";
    } else {
        print "The file does not exist\n";
    }

    open(my $in, '<:encoding(UTF-8)', $filename) or die "Could not open '$filename' for reading \n$!\n";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all
}

sub write_file {
    my ($filename, $content) = @_;
 
    open(my $out, '>:encoding(UTF-8)', $filename) or die "Could not open '$filename' for writing $!";
    print $out $content;
    close $out;
 
    return;   
}