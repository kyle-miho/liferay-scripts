use strict;
use warnings;

$^I = '.bak';
$/ = "";

print STDOUT ("Starting...\n");
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

#GET PATHS USED into PATHSLIST, PATHS CALLED into pathCalls
use File::Find;
find(\&openFile,"$portal_home/portal-web/test/functional/com/liferay/portalweb/paths");

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

    use Cwd;
    my $dir = getcwd;
    use Cwd 'abs_path';
    my $abs_path = abs_path($_);

    #GET PATHS
    if ($fileContent =~ m/<tbody>\s*<\/tbody>/g) {
        print("Removing: " . "$abs_path" . "\n");
        close $currentFile;
        system("del " . $abs_path) or warn;
        return;
    }
    close $currentFile;
}

