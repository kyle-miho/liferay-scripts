use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of functions
my $functionList = "";
my $functionTotal = 0;
my $functionCalls = "";
my $currentCount = 1;

#START TIME
my $start_time = time();

#YOU CAN DEFINE YOUR THINGS HERE 
my $portal_home = "L:/public/master-portal";
my $unusedFunctionsFileName = "unusedFunctions.txt";
my $usedFunctionsFileName = "usedFunctions.txt";

#GET FUNCTIONS USED into FUNCTIONLIST, FUNCTIONS CALLED into functionCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/functions");
find(\&getFunctionCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");
find(\&getFunctionCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests");
find(\&getFunctionCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/util");

#split functionList and call countFunctionUsage
my @splitFunctionList = split(' ', $functionList);
my @splitFunctionCalls = split(' ', $functionCalls);

open(my $fileTemp, '>', $unusedFunctionsFileName) or die;
open(my $fileTemp2, '>', $usedFunctionsFileName) or die;
foreach my $function (@splitFunctionList) {
    my $temp = countFunctionUsages($function,@splitFunctionCalls);
    if ($temp == 0)
    {
        print $fileTemp "$function - Usages: 0\n";
    } else {
        print $fileTemp2 "$function - Usages: $temp\n";
    }
    print("\r");
    my $currentCountString = "$currentCount";
    my $functionTotalString = "$functionTotal";
    print STDOUT ("Current Progress: " . $currentCountString . "/" . $functionTotalString);
    $currentCount++;
    select()->flush();
}
#CLOSE FILES
close($fileTemp);
close($fileTemp2);

#RESULTS POST
print STDOUT ("\nDone!\n");
my $end_time = time();
my $run_time = $end_time - $start_time;
print STDOUT "Job took $run_time seconds.\n";
exit;

###
#DEF: Open file specified, and add its functions to $functionList
###
sub openFile {
    #if not file, don't try to open it
    if(!(-f $_)){
        return;
    }
    #OPEN FILE
    open(my $currentFile, "<", $_)
        or die "Can't open for reading $_";

    #GET FILE CONTENT
    local $/ = undef;
    my $fileContent = <$currentFile>;

    #remove extension, we don't need anymore
    $_ =~ s{\.[^.]+$}{};

    #get default file definition
    my $defaultDefinition = "";
    while ($fileContent =~ m/(?<=<definition default=\")(.*?)(?=\"(.*?)>)/g) {
        $defaultDefinition .= $&;
    }
    print($defaultDefinition);

    #GET FUNCTIONS
    while ($fileContent =~ m/(?<=<command name=\")(.*?)(?=\"(.*?)>)/g) {
        my $functionName;
        if ("$defaultDefinition" ne "$&") {
            $functionName = join '#', $_, $&;
        } else {
            $functionName = $_;
        }
        
        $functionList .= $functionName . "\n";
        $functionTotal++;
    }
    close $currentFile;
}

###
#DEF: Open file specified, and add its function calls to $functionCalls
###
sub getFunctionCallsList {
    #if not file, don't try to open it
    if(!(-f $_)){
        return;
    }
    #OPEN FILE
    open(my $currentFile, "<", $_)
        or die "Can't open for reading $_";

    #GET FILE CONTENT
    local $/ = undef;
    my $fileContent = <$currentFile>;

    #remove extension, we don't need anymore
    $_ =~ s{\.[^.]+$}{};

    #GET FUNCTIONS
    while ($fileContent =~ m/(?<=function=)(\".*?\")(?=(.*?)>)/g) {
        my $functionName = join '#', $_, $&;
        $functionCalls .= $functionName . "\n";
    }
    close $currentFile;
}

###
#DEF: Given a Function, return how many times it is used
###
sub countFunctionUsages {
    my ($functionName, @functionCalls) = @_;
    return grep(/(?<=\")$functionName(?=\")/,@functionCalls);
}
