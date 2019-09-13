#!/usr/bin/env python3

import subprocess, time, sys, os

if len(sys.argv) != 3:
    print("Arguments: ${Reviewer_Name} ${Branch_To_Submit_To}")
    exit()

#
reviewer=sys.argv[1]
submitToBranch=sys.argv[2]
#

portalDirectory = "~/Liferay/private/7.2.x-portal"
gitBranch = str(subprocess.check_output("cd " + portalDirectory + " && git rev-parse --abbrev-ref HEAD",shell=True))

wordNum=0
portalVersion=""
ticketType=""
ticketNumber=""
#get commit message and then get ticketType/number
recentCommit = str(subprocess.check_output("git log -1 --pretty=%B",shell=True))
for i in range(0,len(recentCommit)):
    if recentCommit[i] == '-':
       wordNum += 1
    elif recentCommit[i] == ' ':
        wordNum += 1
    elif recentCommit[i] == '\'':
        wordNum += 1
    else:
        if wordNum == 1:
            ticketType += recentCommit[i]
        if wordNum == 2:
            ticketNumber += recentCommit[i]

if ticketType=='qa':
    ticketType='LRQA'
elif ticketType=='lps':
    ticketType='LPS'

output = "cd " + portalDirectory + " && gh pr -s " + reviewer + " -r liferay-portal-ee -b " + submitToBranch + " --description \"https://issues.liferay.com/browse/" + ticketType + "-" + ticketNumber + "\" --title \"" + ticketType + "-" + ticketNumber + " | " + submitToBranch +"\""
output = output.replace('\n','')
if subprocess.call(output,shell=True) != 0:
    print("An error has occured, please use Node GH normally to check for the error")
