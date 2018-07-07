use strict;
use warnings;

#backup file
$^I = '.bak';
#record seperator
$/ = "";

#test.properties location
my $testProp ="L:/public/master-portal/test.properties";

#TODO -> FIX THIS
open(PROPREAD,"+>","$testProp") or die("Could not open $testProp");

#don't touch properties unless if needed
my $firstPropStart = qr"test.batch.dist.app.servers=";
my $firstPropEnd = "wildfly";
my $firstPropResult = "test.batch.dist.app.servers=tomcat";

my $secondPropStart = qr"test.batch.names=";
my $secondPropEnd = "wsdd-builder-jdk8";
my $secondPropResult = "test.batch.names=functional-tomcat90-mysql57-jdk8";

#replace kyle-miho with what you need
my $thirdPropSolo = qr"test\.batch\.run\.property\.query\[functional\-tomcat90\-mysql57\-jdk8\]=\(portal\.acceptance == true\)";
my $thirdPropResult = "test.batch.run.property.query[functional-tomcat90-mysql57-jdk8]=(portal.acceptance == kyle-miho) AND (app.server.types == null OR app.server.types ~ tomcat) AND (database.types == null OR database.types ~ mysql)";

#first argument should be text file you want to replace
while (<PROPREAD>) {
    #first replace
    s/$firstPropStart.*?$firstPropEnd/$firstPropResult/sm;
    #second replace
    s/$secondPropStart.*?$secondPropEnd/$secondPropResult/sm;
    #third replace
    s/$thirdPropSolo/$thirdPropResult/sm;
    print;
}
