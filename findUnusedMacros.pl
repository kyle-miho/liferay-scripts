use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of macros
my $macroList = "";
my $macroTotal = 0;
my $macroCalls = "";
my $currentCount = 0;

#START TIME
my $start_time = time();

#PORTAL-HOME 
my $portal_home = "L:/public/master-portal";

#GET MACROS USED into MACROLIST, MACROS CALLED into macroCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");
find(\&getMacroCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");
find(\&getMacroCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests");

#split macroList and call countMacroUsage
my @splitMacroList = split(' ', $macroList);
my @splitMacroCalls = split(' ', $macroCalls);

open(my $fileTemp, '>', 'unusedMacros.txt') or die;
open(my $fileTemp2, '>', 'usedMacros.txt') or die;
foreach my $macro (@splitMacroList) {
    my $temp = countMacroUsages($macro,@splitMacroCalls);
    if ($temp == 0)
    {
        print $fileTemp $macro . " - Usages: " . $temp . "\n";
    } else {
        print $fileTemp2 $macro . " - Usages: " . $temp . "\n";
    }
    print("\r");
    my $currentCountString = "$currentCount";
    my $macroTotalString = "$macroTotal";
    print STDOUT ("Current Progress: " . $currentCountString . "/" . $macroTotalString);
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
#DEF: Open file specified, and add its macro calls to $macroCalls
###
sub getMacroCallsList {
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
    while ($fileContent =~ m/(?<=<execute macro=\")(.*?)(?=\"(.*?)>)/g) {
        my $macroName = join '#', $_, $&;
        $macroCalls .= $macroName . "\n";
    }
    close $currentFile;
}

###
#DEF: Given a Macro, return how many times it is used
###
sub countMacroUsages {
    my ($macroName, @macroCalls) = @_;
    return grep(/$macroName/,@macroCalls);
}
