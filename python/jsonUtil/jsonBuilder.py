import json

def buildNameMap(name):
    nameMap = {}
    
    nameMap['en_US'] = name
    
    return json.dumps(nameMap)