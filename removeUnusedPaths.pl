use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...");
#List of paths
my $pathList = "";
my $pathTotal = 0;
my $pathCalls = "";
my $currentCount = 0;
my $unusedPaths = "";
my $unusedPathCount = 0;

#START TIME
my $start_time = time();

#YOU CAN DEFINE YOUR THINGS HERE 
my $portal_home = "L:/public/master-portal";
my $unusedPathsFileName = "unusedPaths.txt";
my $usedPathsFileName = "usedPaths.txt";

#GET PATHS USED into PATHSLIST, PATHS CALLED into pathCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");
find(\&getPathCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");
find(\&getPathCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests");

#split pathList and call countPathUsage
my @splitPathList = split(' ', $pathList);
my @splitPathCalls = split(' ', $pathCalls);

#open(my $fileTemp, '>', $unusedPathsFileName) or die;
#open(my $fileTemp2, '>', $usedPathsFileName) or die;

foreach my $path (@splitPathList) {
    my $temp = countPathUsages($path,@splitPathCalls);
    if ($temp == 0)
    {
        $unusedPaths .= $path . "\n";
    }
    print("\r");
    $currentCount++;
    $unusedPathCount++;
    my $currentCountString = "$currentCount";
    my $pathTotalString = "$pathTotal";
    print STDOUT ("Counting Usages: " . $currentCountString . "/" . $pathTotalString);
    
    select()->flush();
}
#CLOSE FILES
#close($fileTemp);
#close($fileTemp2);

#remove paths
find(\&removePath,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");



#RESULTS POST
print STDOUT ("\nDone!\n");
my $end_time = time();
my $run_time = $end_time - $start_time;
print STDOUT "Job took $run_time seconds.\n";
exit;

###
#DEF: Open file specified, and add its paths to $pathList
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
#DEF: Open file specified, and add its path calls to $pathCalls
###
sub getPathCallsList {
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
    while ($fileContent =~ m/(?<=locator1=\")(.*?)(?=\")/g) {
        my $pathName = join '#', $_, $&;
        $pathCalls .= $pathName . "\n";
    }
    close $currentFile;
}

###
#DEF: Given a Path, return how many times it is used
###
sub countPathUsages {
    my ($pathName, @pathCalls) = @_;
    return grep(/$pathName/,@pathCalls);
}


###
#DEF: Given Filename#Path, Open Filename, remove Path, then close Filename
###
sub removePath {
    #if not file, don't try to open it
    if(!(-f $_)){
        return;
    }
    #OPEN FILE
    open(my $currentFileRead, "<", $_)
        or die "Can't open for reading $_";

    #GET FILE CONTENT
    local $/ = undef;
    my $fileContent = <$currentFileRead>;

    #OPEN FOR WRITING
    open(my $currentFile, ">", $_)
        or die "Can't open for writing $_";

    #remove extension, we don't need anymore
    $_ =~ s{\.[^.]+$}{};

    print("\r");
    print("Working on file " . $_ . "\n");

    #split Filename#Path into a filename and path variable
    

    my @splitUnusedPaths = split(' ', "$unusedPaths");
    my $replacements = 0;

    foreach my $path (@splitUnusedPaths) {
        my ($filename,$pathname) = split(/#/,$path,2);
        
        if ("$filename" eq "$_") {
            print("removing unused path: " . $pathname . "\n");
            my $find='<tr>\s*<td>' . $pathname . '<\/td>\s*<td>.*?<\/td>\s*<td>.*?<\/td>\s*<\/tr>\s*';
            $fileContent =~ s/$find//;
            $replacements++;
        }
    #select()->flush();
    }
    print $currentFile $fileContent;
    close $currentFile;

    if ($replacements > 0) {
        #git add file, then git commit
        #my $temp1 = "git add " . $_ . ".path";
        #my $temp2 = "git commit -m" . "\"LRQA-42406 Remove unused paths in " . $_ . ".path\"";
        #system("$temp1");
        #system("$temp2");
    }     
}
