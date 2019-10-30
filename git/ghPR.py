#!/usr/bin/env python3

import subprocess, time, sys, os, re

### GLOBALS ###

branchToTicket = {
    "lrqa" : "LRQA",
    "qa" : "LRQA",
    "lps" : "LPS",
}

githubUserName = 'kyle-miho'

reviewersDict = {
    'brianchandotcom':'brian.chan',
    'vicnate5':'victor.ware'
}

### CLASSES ###

class TicketLink:
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

        if self.__validTokens(tokens):
            return tokens

        return self.__getNewTokens()

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

        print('Passed! Tokens: ' + str(tokens))
        return True

    def __init__(self,branch):
        tokens = self.__tokenize(branch)

        self.project = tokens[0]
        self.ticketNumber = tokens[1]

    def __str__(self):
        return self.project + "-" + self.ticketNumber

### FUNCTIONS ###

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

def goToPortalDirectory():
    subprocess.call("cd " + portalDirectory,shell=True)

def submitPR(reviewer, branch, ticketLink):
    repo = getRepo(branch)

    output = "gh pr -s " + reviewer + " -r " + repo + " -b " + branch + " --description \"https://issues.liferay.com/browse/" + str(ticketLink) + "\" --title \"" + str(ticketLink) + " | " + branch + "\""
    if subprocess.call(output,shell=True) != 0:
        print("An error has occured, please use Node GH normally to check for the error")

### MAIN ###

if len(sys.argv) != 3:
    print("Arguments: ${Reviewer_Name} ${Branch_To_Submit_To}")
    exit()

reviewer=sys.argv[1]
branch=sys.argv[2]

gitBranch = getCurrentBranch()
ticketLink = TicketLink(gitBranch)

submitPR(reviewer,branch,ticketLink)

exit(0)

#call gh jira if applicable
if reviewer not in reviewers:
    print("No Jira account associated with github account in reviewers dictionary, not updating ticket")
    exit()

jiraName = reviewersDict[reviewer]

subprocess.call("gh jira " + str(ticketLink) + " --assignee " + jiraName + " --transition",shell=True)

if ticketLink.project == 'LRQA':
    subprocess.call("gh jira " + " --transition \"Submit for Review\"",shell=True)
elif ticketLink.project == 'LPS':
    subprocess.call("gh jira " + " --transition \"Code Review Request\"",shell=True)