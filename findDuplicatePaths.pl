use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of paths
my $pathList = "";
my $pathPaths = "";
my $pathTotal = 0;
my $pathCalls = "";
my $currentCount = 0;

#START TIME
my $start_time = time();

#YOU CAN DEFINE YOUR THINGS HERE 
my $portal_home = "L:/public/master-portal";
my $duplicatePathsFileName = "duplicatePaths.txt";


#GET PATHS USED into PATHSLIST, PATHS CALLED into pathCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");
find(\&getPaths,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");

#split pathList and call countPathUsage
my @splitPathList = split(' ', $pathList);
my @splitPathPaths = split('\n', $pathPaths);
open(my $fileTemp, '>', $duplicatePathsFileName) or die;

#for array
my %seen;
my $index = -1;
foreach my $temp (@splitPathPaths) {
    ++$index;
    next unless $seen{$temp}++;
    print $fileTemp "'$temp' is duplicated --- $splitPathList[$index]\n";
}
close($fileTemp);

#RESULTS POST
print STDOUT ("\nDone!\n");
my $end_time = time();
my $run_time = $end_time - $start_time;
print STDOUT "Job took $run_time seconds.\n";
exit;

###
#DEF: Open file specified, and add its path names to $pathList
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

    #GET PATHS
    while ($fileContent =~ m/<tr>(\s*?)<td>\K(.+?)(?=<\/td>)/g) {
        #my $temp = $&;
        #$temp =~ s/(?<=<td>)(.*?)(?=\s)/TEST/g;
        my $pathName = join '#', $_, $&;
        $pathList .= $pathName . "\n";
        $pathTotal++;
    }
    close $currentFile;
}

###
#DEF: Open file specified, and add its paths to $pathList
###
sub getPaths {
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

    #GET PATHS
    while ($fileContent =~ m/<tr>(\s*?)<td>(.+?)<\/td>(\s*?)<td>\K(.+?)(?=<\/td>)/g) {
        $pathPaths .= $& . "\n";
    }
    close $currentFile;
}

