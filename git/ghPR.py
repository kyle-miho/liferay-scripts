#!/usr/bin/env python3

import subprocess, time, sys, os, re

### ADJUST THESE ###
# YOUR GITHUB USERNAME #
githubUserName = 'kyle-miho'


# THE PEOPLE YOU SEND PRS TO #
reviewersDict = {
    'brianchandotcom':'brian.chan',
    'kyle-miho':'kyle.miho',
    'vicnate5':'victor.ware'
}
##################

### GLOBALS ###
branchToTicket = {
    "lrqa" : "LRQA",
    "qa" : "LRQA",
    "lps" : "LPS",
}

### CLASSES ###

class TicketLink:
    def __formatTokens(self,tokens):
        if self.__validTokens(tokens):
            tokens[0] = re.sub('[^\w]','',tokens[0])
            tokens[0] = branchToTicket[tokens[0].lower()]

            tokens[1] = re.sub('[^0-9]','',tokens[1])  
        return tokens

    def __getNewTokens(self):
        offset = 0

        while (True):
            commit = getRecentCommit(offset).split(' ', 1)

            tokens = commit[0].split('-', 1)

            if self.__validTokens(tokens):
                return tokens
            elif offset > 10:
                sys.exit("Failed getting valid tokens")
            offset += 1

    def __tokenize(self,branch):
        tokens = branch.split("-")

        if len(tokens) == 3:
            tokens.pop(0)

        if self.__validTokens(tokens) == False:
            tokens = self.__getNewTokens()

        return __formatTokens(tokens)

    def __validTokens(self,tokens):
        if len(tokens) != 2:
            print('Wrong amount of tokens, expected 2. Tokens: ' + str(tokens))
            return False

        if tokens[0].lower() not in branchToTicket:
            print(tokens[0] + ' is not a valid branch name. Tokens: ' + str(tokens))
            return False

        if re.search("\d+",tokens[1]) == None:
            print(tokens[1] + ' should only contain digits. Tokens: ' + str(tokens))
            return False

        return True

    def __init__(self,branch):
        tokens = self.__tokenize(branch)      

        self.project = tokens[0]
        self.ticketNumber = tokens[1]

    def __str__(self):
        return self.project + "-" + self.ticketNumber

### FUNCTIONS ###

def formatJiraName(name):
    tokens = name.split('.')

    if len(tokens) != 2:
        print("Incorrect username: " + name)
        return name
    return tokens[0].capitalize() + " " + tokens[1].capitalize()

def getCurrentBranch():
    byte = subprocess.check_output("git rev-parse --abbrev-ref HEAD",shell=True)
    return byte.decode('utf8')

def getRepo(branch):
    if branch == 'master':
        return 'liferay-portal'
    return 'liferay-portal-ee'

def getRecentCommit(offset):
    byte = subprocess.check_output("git log --skip=" + str(offset) + " -1 --pretty=%B",shell=True)
    return byte.decode('utf8')

def submitPR(reviewer, branch, ticketLink):
    repo = getRepo(branch)

    byte = subprocess.check_output("gh pr -s " + reviewer + " -r " + repo + " -b " + branch + " --description \"https://issues.liferay.com/browse/" + str(ticketLink) + "\" --title \"" + str(ticketLink) + " | " + branch + "\"",shell=True)
    output = byte.decode('utf8')

    print(output)

    pullRequestLink = re.search(r"https://github\.com/.*?/.*?/pull/\d+",output)

    if pullRequestLink == None:
        print("An error has occured, please use Node GH normally to check for the error")
        exit(1)
    return pullRequestLink.group(0)

### MAIN ###

if len(sys.argv) != 3:
    print("Arguments: ${Reviewer_Name} ${Branch_To_Submit_To}")
    exit()

#Check if Props file exists, if not ask for input for it

reviewer=sys.argv[1]
branch=sys.argv[2]
jiraName = reviewersDict[reviewer]

gitBranch = getCurrentBranch()
ticketLink = TicketLink(gitBranch)

pullRequest = submitPR(reviewer,branch,ticketLink)

subprocess.call("gh jira " + str(ticketLink) + " --comment \"Pushed to " + formatJiraName(jiraName) + ".\n" + branch + ": " +  pullRequest + "\"",shell=True)

if ticketLink.project == 'LRQA':
    if jiraName == "brian.chan":
        subprocess.call("gh jira " + str(ticketLink) + " --assignee " + githubUserName + " --transition \"Close\"",shell=True)
    else:
        subprocess.call("gh jira " + str(ticketLink) + " --assignee " + jiraName + " --transition \"Submit for Review\"",shell=True)
elif ticketLink.project == 'LPS':
    subprocess.call("gh jira " + str(ticketLink) + " --assignee " + jiraName + " --transition \"Code Review Request\"",shell=True)