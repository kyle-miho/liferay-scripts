import constants
import json
import requests

#CONSTANTS
baseURL = 'http://' + constants.VIRTUAL_HOST + ':' + constants.port

def buildRequestURL(apiURL):
    return baseURL + '/api/jsonws' + apiURL

def printErrors(response):
    status = response.status_code

    if status == 404:
        print('Not Found!')
    elif status == 403:
        print('Access denied!')
    else:
        print('Error ' + str(status) + ' encountered')
    raise Exception(response.text)

#requests

def post(params, apiURL):
    requestURL = buildRequestURL(apiURL)

    response = requests.post(requestURL, data=params, auth=('test@liferay.com', 'test'))

    if response.status_code == 200:
        return response.json()
    else:
        printErrors(response.status_code)

def request(params, apiURL):
    requestURL = buildRequestURL(apiURL)

    response = requests.get(requestURL, params=params, auth=('test@liferay.com', 'test'))

    if response.status_code == 200:
        return response.json()
    else:
        printErrors(response)