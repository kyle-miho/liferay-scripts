import subprocess, time, sys, os

portalDirectory = "L:/private/7.1.x-private"
gitBranch = subprocess.check_output("cd " + portalDirectory + " && git rev-parse --abbrev-ref HEAD",shell=True)

wordNum=0
portalVersion=""
for i in range(0,len(gitBranch)):
    if gitBranch[i] == '-':
        wordNum += 1
    else:
        if wordNum == 0:
            portalVersion += gitBranch[i]
       
output = "cd " + portalDirectory + " && git checkout " + portalVersion + " && git pull upstream && git push origin && git rebase " + portalVersion + " " + gitBranch
print(subprocess.check_output(output,shell=True))
#if subprocess.call(output,shell=True) != 0:
#    print("An error has occured")
