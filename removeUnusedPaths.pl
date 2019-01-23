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
my $portal_home = "L:/private/7.1.x-portal";
my $unusedPathsFileName = "unusedPaths.txt";
my $usedPathsFileName = "usedPaths.txt";

#GET PATHS USED into PATHSLIST, PATHS CALLED into pathCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");
find(\&getPathCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");
find(\&getPathCallsList,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests");
#execute only for commerce
find(\&getPathCallsList,"L:/private/7.1.x-commerce/commerce-product-test/src/testFunctional/macros");
find(\&getPathCallsList,"L:/private/7.1.x-commerce/commerce-product-test/src/testFunctional/tests");
#split pathList and call countPathUsage
my @splitPathList = split(' ', $pathList);
my @splitPathCalls = split(' ', $pathCalls);

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

    #GET PATHS NORMAL
    while ($fileContent =~ m/(?<=locator[0-9]=\")(.*?)(?=\")/g) {
        if (index($&,'#') != -1) {
            my $pathName = $&;
            $pathCalls .= $pathName . "\n";
        }
    }

    #GET PATHS CALLED BY selenium#function
    while ($fileContent =~ m/selenium#.*?\(\'\K(.*?)(?=\')/g) {
        if (index($&,'#') != -1) {
            my $pathName = $&;
            $pathCalls .= $pathName . "\n";
        }
        
    }

    close $currentFile;
}

###
#DEF: Given a Path, return how many times it is used
###

sub countPathUsages {
    my ($pathReal, @pathCalls) = @_;
    my ($filenameReal,$pathnameReal) = split(/#/,$pathReal,2);
    my $tempCount = 0;
    #check if a path is used
    foreach my $tempPathCall (@pathCalls) {
        #split filename and path, do hard compare on filename, hard compare on path if there is no variable
        my ($filenameCall,$pathnameCall) = split(/#/,$tempPathCall,2);
        if ("$filenameReal" eq "$filenameCall") {
            #check if variable, then do substring compare, else another hard compare
            if (index($pathnameCall,'$') != -1) {
                $pathnameCall =~ s/\$\{.*?\}/\.\*\?/g;
                if ($pathnameReal =~ /$pathnameCall/) {
                $tempCount++;
                }

            } else {
                if ("$pathnameReal" eq "$pathnameCall") {
                    $tempCount++;
                }
            }
        }
    }
    return $tempCount;
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
    }
    print $currentFile $fileContent;
    close $currentFile;
}
