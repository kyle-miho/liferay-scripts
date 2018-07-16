use strict;
use warnings;

$^I = '.bak';
$/ = "";

#####################################################################
#MODIFY THESE
#TEST PROPERTY LOCATION
my $testProp ="L:/public/master-portal/test.properties";
#ACCEPTANCE NAME
my $name = "kyle-miho";
#####################################################################

#don't touch properties unless if needed
my $firstPropStart = qr"test.batch.dist.app.servers=\\";
my $firstPropEnd = "wildfly";
my $firstPropResult = "test.batch.dist.app.servers=tomcat";

my $secondPropStart = qr"test.batch.names=\\";
my $secondPropEnd = "wsdd-builder-jdk8";
my $secondPropResult = "test.batch.names=functional-tomcat90-mysql57-jdk8";

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

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all
}

sub write_file {
    my ($filename, $content) = @_;
 
    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;
 
    return;   
}