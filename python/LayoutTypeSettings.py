import constants
import uuid

class TypeSettings:
    def _generateInstanceId():
        return 'asdffadfsadf'

    def __init__(self, layoutTemplateId):
        self.layoutTemplateId = layoutTemplateId.id
        self.columns = layoutTemplateId.columns

        self.widgets = [[] for x in range(self.columns)]
    
    def __str__(self):
        typeSettings = ''

        
        for column in range(len(self.widgets)):
            typeSettings += 'column-' + str(column+1) + '='

            for widget in range(len(self.widgets[column])):
                typeSettings += self.widgets[column][widget] + ','

            typeSettings = typeSettings[:-1]
            typeSettings += '\n'
        
        typeSettings += 'layout-template-id=' + self.layoutTemplateId
        return typeSettings

    def addWidget(self,column,widget):
        portletid = widget.portletId

        if widget.repeatable:
            portletid += '_INSTANCE_' + 'asdadad'

        if column-1 < self.columns:
            self.widgets[column-1].append(portletid)
        else:
            raise Exception('Invalid column specified, was: ' + str(column) + ' must be less than ' + str(self.columns))
