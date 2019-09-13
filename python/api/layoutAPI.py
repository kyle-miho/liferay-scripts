import constants
import requestHandler
from jsonUtil import jsonParser, jsonBuilder
import json

def _getLayouts(groupId, privateLayout):
    params = {
        'groupId' : groupId,
        'privateLayout' : privateLayout
    }

    result = requestHandler.requestHandler(params, '/layout/get-layouts')

    return result

def addWidgetPage(groupId, name):
    params = {
        'groupId' : groupId,
        'privateLayout' : 'false',
        'parentLayoutId' : 0,
        'name' : name,
        'title' : '',
        'description' : '',
        'type' : 'portlet',
        'hidden' : 'false',
        'friendlyURL' : ''}

    result = requestHandler.request(params, '/layout/add-layout')

    return result['layoutId']

def getTypeSettingsByName(groupId, layoutId):
    layouts = _getLayouts(groupId, 'false')

    typeSettings = jsonParser.findValueInJSON(layouts, 'layoutId', layoutId, 'typeSettings')

    if (typeSettings == 0):
        return 0
    return typeSettings

def updateTypeSettings(groupId, layoutId, typeSettings):
    params = {
        'groupId' : groupId,
        'privateLayout' : 'false',
        'layoutId' : layoutId,
        'typeSettings' : typeSettings}

    result = requestHandler.request(params, '/layout/update-layout')

    return result

