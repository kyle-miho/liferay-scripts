import constants
import LayoutTypeSettings
from api import layoutAPI

def getNextColumn(current, max):
    if current == max:
        return 1
    return current + 1

def createWidgetPages(groupId):
    for layoutTemplate in constants.layoutTemplates:
        #create widget page
        layoutId = layoutAPI.addWidgetPage(groupId, layoutTemplate.id)

        #populate typeSettings
        typeSettings = LayoutTypeSettings.TypeSettings(layoutTemplate)

        column = 1
        for widget in constants.widgets:
            typeSettings.addWidget(column,widget)
            column = getNextColumn(column,layoutTemplate.columns)

        #update widget page
        layoutAPI.updateTypeSettings(groupId, layoutId, typeSettings)