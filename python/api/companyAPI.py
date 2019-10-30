import constants
import requestHandler
from jsonUtil import jsonParser, jsonBuilder
import json

def getCompanyId():
    params = {
        'virtualHost' : constants.VIRTUAL_HOST}

    result = requestHandler.request(params, '/company/get-company-by-virtual-host')

    return result['companyId']

def addCompany(virtualHostName):
    params = {
        'webId' : 'Test',
        'virtualHost' : virtualHostName,
        'mx' : 'liferay.com',
        'system'  : False,
        'maxUsers' : 0,
        'active' : True}

    result = requestHandler.request(params, '/company/add-company')

    return result['companyId']