use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of macros
my $testcaseList = "";
my $totalTestcases = 0;
my @testcaseName;
my @testcaseCount;

#YOU CAN DEFINE YOUR THINGS HERE 
my $portal_home = "L:/public/master-portal";
my $testOutput = "testCases.txt";

#GET MACROS USED into MACROLIST, MACROS CALLED into macroCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests/enduser/wcm");

open(my $fileTemp, '>', $testOutput) or die;
#print $fileTemp "$testcaseList";

#REORDER testcaseName along with testcaseCount manually
foreach my $i (0 .. $#testcaseCount-1) {
    foreach my $j (0 .. $#testcaseCount-1) {
        if ($testcaseCount[$j] < $testcaseCount[$j+1]) {
            swapIndex($j,$j+1);
        }
    }
}
#PRINT OUT
print $fileTemp "Total Testcases: $totalTestcases\n";
foreach my $i (0 .. $#testcaseName) {
    print $fileTemp "$testcaseName[$i]: $testcaseCount[$i]\n";
}
close $fileTemp;

#RESULTS POST
print STDOUT ("Done!\n");

###
#DEF: Open file specified, and add its testcases to $macroList
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

    #GET MACROS
    my $tempCount = 0;
     
    while ($fileContent =~ m/(?<=<command name=\")(.*?)(?=\"(.*?)>)/g) {
        $tempCount++;
        $totalTestcases++;
    }
    #$testcaseList .= $_ . ": " . $tempCount . "\n";
    #test below
    #------------
    push @testcaseName, $_;
    push @testcaseCount, $tempCount;
    #------------
    close $currentFile;
}

###
#SWAP INDEX $index1 and $index2 for BOTH @testcaseName and testcaseCou nt
###
sub swapIndex {
    my ($index1, $index2) = @_;

    #swap testcaseName
    my $temp = $testcaseName[$index1];
    $testcaseName[$index1] = $testcaseName[$index2];
    $testcaseName[$index2] = $temp;

    #swap testcaseName
    my $temp2 = $testcaseCount[$index1];
    $testcaseCount[$index1] = $testcaseCount[$index2];
    $testcaseCount[$index2] = $temp2;
}