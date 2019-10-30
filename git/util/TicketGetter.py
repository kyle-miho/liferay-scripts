import subprocess, re

#Parses ticket of form master-lps-xxxxx or LRQA-xxxxx etc
def __parseTicket(ticket):
    ticketParsed = re.search("-", ticket)


    qa, xxxxx
    lps, xxxxx


class Ticket:
    def __init__(self,project,ticketNum):
        if project.lower() == "qa":
            self.project = "LRQA"
        elif project.lower() == "lps":
            self.project = "LPS"
        
        self.ticketNum = ticketNum

def getBranch():
    return str(subprocess.check_output("git rev-parse --abbrev-ref HEAD",shell=True))

def getRecentTicket():
    return str(subprocess.check_output("git log -1 --pretty=%B",shell=True))

def getJiraTicket ():
    #If branch has ticket #get from that
    ticket = getBranch()

    #if starts with pr, then use recent commit instead
    if re.search("^pr-",ticket) == None:
        ticket = getRecentTicket()
        
        #cleanup ticket
        ticket = re.search("^.*",ticket)
        ticket = "master-" + ticket.string

    #parse ticket
    ticketSplit = re.split("-",ticket)

    return Ticket(ticketSplit[1],ticketSplit[2])

    
