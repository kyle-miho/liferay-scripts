def findValueInJSON(json, searchValueKey, searchValueMatcher, desiredValue):
    for i in json:
        if i[searchValueKey] == searchValueMatcher:
            return i[desiredValue]
    return 0
