use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of macros
my $macroList = "";
my $macroTotal = 0;
my $currentCount = 0;
#OPEN MACROS DIRECTORY
use File::Find;
find(\&openFile,"L:/public/master-portal/portal-web/test/functional/com/liferay/portalweb/macros");

#split macroList and call countMacroUsage
my @splitMacroList = split(' ', $macroList);
foreach my $macro (@splitMacroList) {
    my $temp = countMacroUsages($macro);
    if (countMacroUsages($macro) == 0)
    {
        open(my $fileTemp, '+>>', 'unusedMacros.txt') or die;
        print $fileTemp $macro . " - Usages: " . $temp . "\n";
        close($fileTemp);
    } else {
        open(my $fileTemp2, '+>>', 'usedMacros.txt') or die;
        print $fileTemp2 $macro . " - Usages: " . $temp . "\n";
        close($fileTemp2);
    }
    $currentCount++;
    print("\r");
    my $currentCountString = "$currentCount";
    my $macroTotalString = "$macroTotal";
    print STDOUT ("Current Progress: " . $currentCountString . "/" . $macroTotalString);
    select()->flush();
}
print STDOUT ("Done!");

###
#DEF: Open file specified, and add its macros to $macroList
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
    while ($fileContent =~ m/(?<=<command name=\")(.*?)(?=\"(.*?)>)/g) {
        my $macroName = join '#', $_, $&;
        $macroList .= $macroName . "\n";
        $macroTotal++;
    }
    close $currentFile;
}

###
#DEF: Given a Macro, return how many times it is used
###
my $macroCount = 0;
my $macroNameGlobal = "";

sub countMacroUsages {
    my ($macroName) = @_;

    $macroCount = 0;
    #iterate through each file in /macros and count how many times they are used
    use File::Find;
    $macroNameGlobal = $macroName;
    find(\&_countMacroUsage,"L:/public/master-portal/portal-web/test/functional/com/liferay/portalweb/macros");
    find(\&_countMacroUsage,"L:/public/master-portal/portal-web/test/functional/com/liferay/portalweb/tests");
    my $temp2 = $macroCount;
    return $temp2;
}

sub _countMacroUsage {
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

    while ($fileContent =~ m/(?<=<execute macro=\")$macroNameGlobal(?=\"(.*?)>)/g) {
        $macroCount++;
    } 
    close $currentFile;
    return;
}