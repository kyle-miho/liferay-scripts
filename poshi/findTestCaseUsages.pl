use strict;	
use warnings;	

 $^I = '.bak';	
$/ = "";	

 print STDOUT ("Starting...");	

my $argumentCount = $#ARGV + 1;

if ($argumentCount != 1) {
    print "Error! Usage = ./findTestCaseUsages.pl \${macroFileName.macroName}";
    exit;
}

 #YOU CAN DEFINE YOUR THINGS HERE   
my $portal_home = "L:/public/master-portal";    

#Globals
my $macroFound = 0;

#List of macros	
my @macroList = ("$ARGV[0]");
my @macroListTemp = ();
my @testCaseList = ();

 #START TIME	
my $start_time = time();	

 #GET MACROS USED into MACROLIST, MACROS CALLED into macroCalls	
use File::Find;	

#Check if macro exists
find(\&findMacro,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");

if ($macroFound == 1) {
    print "We found the macro\n";
} else {
    print "We did not find the macro\n";
    exit;
}

#We have to go call this to get the initial list of macro calls, and then call it until the macrolist is empty

do {
    find(\&getMacroListTest,"$portal_home/portal-web/test/functional/com/liferay/portalweb/tests");
    find(\&getMacroListMacros,"$portal_home/portal-web/test/functional/com/liferay/portalweb/macros");

    #print("-------------------\n");

    #print ("testCaseList:\n");
    foreach(@testCaseList) {
        #print "$_\n";
    }

    #print ("macroList:\n");
    foreach(@macroList) {
        #print "$_\n";
    }

    #print ("macroListTemp:\n");
    foreach(@macroListTemp) {
        #print "$_\n";
    }

    #print("-------------------\n\n");

    @macroList = @macroListTemp;
    @macroListTemp = ();
    
} while (@macroList);

foreach(@testCaseList) {
    print "$_\n";
}

exit;

###
#DEF: SETS MacroFound = 1 if found
###	
sub findMacro {	
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
    while ($fileContent =~ m/(?<=macro )(.*?)(?=\s?{)/g) {	
        my $macroName = join '.', $_, $&;

        if ($macroName eq $ARGV[0]) {
            #print "$macroName found!";
            $macroFound = 1;
        }
    }
    close $currentFile;	
}	

 ###	
#DEF: Open file specified, and add all of its usages into macroList or testCaseList, depending where its called from
###	
sub getMacroListMacros {	
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
    foreach my $macro (@macroList) {
       # print "Searching for $macro inside of $_\n";
        #ideally replace \t with backreference
        while ($fileContent =~ m/(\t+)macro\s(.*?)\s\{\n((\1[^\}].*?)?\n)*(.*?$macro.*?\n)(?:.*?\n)*?\1\}/g) {	
            my $macroName = join '.', $_, $2;
            #print "$macroName found!\n";
            push(@macroListTemp,$macroName);
        }
    }
    close $currentFile
        or die "Couldnt close file";	
}	

 ###    
#DEF: Open file specified, and add all of its usages into macroList or testCaseList, depending where its called from
### 
sub getMacroListTest {  
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
    foreach my $macro (@macroList) {
       # print "Searching for $macro inside of $_\n";
        #ideally replace \t with backreference
        while ($fileContent =~ m/(\t+)test\s(.*?)\s\{\n((\1[^\}].*?)?\n)*(.*?$macro.*?\n)(?:.*?\n)*?\1\}/g) {   
            my $macroName = join '.', $_, $2;
            #print "$macroName found!\n";
            push(@testCaseList,$macroName);
        }
    }
    close $currentFile
        or die "Couldnt close file";    
}   

 ###	
#DEF: Given a Macro, return how many times it is used	
###	
sub countMacroUsages {	
    my ($macroName, @macroCalls) = @_;	
    return grep(/$macroName/,@macroCalls);	
}