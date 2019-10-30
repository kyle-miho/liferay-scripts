#!/usr/bin/env python3

import constants
from api import companyAPI, groupAPI, layoutAPI
from dataGenerator import WidgetPageCreator



###CONSTANTS
companyId = companyAPI.getCompanyId()


#Create Group
groupId = groupAPI.addGroup('Test Site Name API 2')

#DO STUFF
WidgetPageCreator.createWidgetPages(groupId)

#Cleanup
#groupAPI.deleteGroup(groupId)