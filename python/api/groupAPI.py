import constants
import requestHandler
from jsonUtil import jsonParser, jsonBuilder
import json

def addGroup(name):

    nameMap = jsonBuilder.buildNameMap(name)
    print(nameMap)

    params = {
        'parentGroupId' : 0,
        'liveGroupId' : 0,
        'nameMap' : nameMap,
        'descriptionMap' : '{}',
        'type' : 1,
        'manualMembership' : 'true',
        'membershipRestriction' : 0,
        'friendlyURL' : '',
        'site' : 'true',
        'inheritContent' : 'false',
        'active' : 'true'}

    result = requestHandler.request(params, '/group/add-group')

    return result['groupId']

def deleteGroup(groupId):
    params = {
        'groupId' : groupId}

    result = requestHandler.request(params, '/group/delete-group')   

    return result

def getGroupId(companyId, name):
    params = {
        'companyId' : companyId,
        'parentGroupId' : 0,
        'site' : 'true'}

    result = requestHandler.request(params, '/group/get-groups')

    groupId = jsonParser.findValueInJSON(result, 'nameCurrentValue', name, 'groupId')

    if (groupId == 0):
        print('Cannot find group with name: ' + name + '. Returning groupId = 0.')

    return groupId