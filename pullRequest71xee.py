import subprocess, time, sys, os

if len(sys.argv) != 3:
    print("Arguments: ${Reviewer_Name} ${Branch_To_Submit_To}")
    exit()

#
reviewer=sys.argv[1]
submitToBranch=sys.argv[2]
#

portalDirectory = "L:/private/7.1.x-portal"
gitBranch = subprocess.check_output("cd " + portalDirectory + " && git rev-parse --abbrev-ref HEAD",shell=True)

wordNum=0
portalVersion=""
ticketType=""
ticketNumber=""
for i in range(0,len(gitBranch)):
    if gitBranch[i] == '-':
        wordNum += 1
    else:
        if wordNum == 0:
            portalVersion += gitBranch[i]
        if wordNum == 1:
            ticketType += gitBranch[i]
        if wordNum == 2:
            ticketNumber += gitBranch[i]

if ticketType=='qa':
    ticketType='LRQA'
elif ticketType=='lps':
    ticketType='LPS'

output = "cd " + portalDirectory + " && gh pr -s " + reviewer + " -r liferay-portal-ee -b " + submitToBranch + " --description \"https://issues.liferay.com/browse/" + ticketType + "-" + ticketNumber + "\" --title \"" + ticketType + "-" + ticketNumber + " | " + submitToBranch +"\""
output = output.replace('\n','')
if subprocess.call(output,shell=True) != 0:
    print("An error has occured, please use Node GH normally to check for the error")
