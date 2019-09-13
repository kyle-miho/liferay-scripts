import constants
import requestHandler
from jsonUtil import jsonParser, jsonBuilder
import json

def getCompanyId():
    params = {
        'virtualHost' : constants.VIRTUAL_HOST}

    result = requestHandler.request(params, '/company/get-company-by-virtual-host')

    return result['companyId']