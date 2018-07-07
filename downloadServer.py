#!/usr/bin/env python

import argparse
import httplib2
import os
import platform
import shutil
import subprocess
import sys
import urllib
import zipfile
import re

import properties

from bs4 import BeautifulSoup, SoupStrainer


def checkLatest(zipString):
    current_gitID = getCurrentBundleID(zipString)

    if current_gitID == gitID:
        return True
    else:
        return False


def cleanUp(zipString, directory):
    dirs = os.listdir(".")

    oldDirectory = re.sub('-tomcat', '', zipString)

    for d in dirs:
        if oldDirectory in d or directory in d:
            if os.path.isdir(os.path.join(".", d)):
                if platform.system() == "Windows":
                    # hack to bypass windows path length limit. forces unicode,
                    # absolute, UNC filepath
                    shutil.rmtree(u"\\\\?\\" + os.path.abspath(d))
                else:
                    shutil.rmtree("./" + d)

                print "Old bundle removed."

        elif zipString in d and not checkLatest(zipString):
            os.remove("./" + d)
            print "Old zip removed."


def downloadBundle(url):
    fileName = url.rsplit("/", 1)[-1]

    bundleFile = urllib.URLopener()
    bundleFile.retrieve(url, fileName)

    print "...download complete."


def getBundle(url):
    http = httplib2.Http()
    status, response = http.request(url)
    zipName = ""

    for link in BeautifulSoup(response, "html.parser",
                              parse_only=SoupStrainer("a")):
        if (link.has_attr("href")
                and "tomcat" in link["href"]
                and "view" not in link["href"]
                and "fingerprint" not in link["href"]
                and "MD5" not in link["href"]):
            zipName = link["href"]

    if zipName:
        final_url = url + zipName

        return final_url
    else:
        return None


def getCurrentBundleID(versionString):
    dirs = os.listdir(".")
    currentFileName = None

    for d in dirs:
        if versionString in d and ".zip" in d:
            currentFileName = d

    if currentFileName:
        gitID = currentFileName.rsplit("-", 1)[1]
        gitID = gitID.rsplit(".", 1)[0]

        return gitID
    else:
        return "0"


def startTomcat(folder):
    if platform.system() == "Windows":
        os.chdir("%s/tomcat-8.0.32/bin/" % (folder))

        subprocess.call("catalina run", shell=True)
    else:
        subprocess.call("sh ./%s/tomcat-8.0.32/bin/catalina.sh run" % (folder),
                        shell=True)


def unzipBundle(fileName):
    zip_ref = zipfile.ZipFile("./" + fileName, "r")
    zip_ref.extractall()
    zip_ref.close()

    print "...unzip complete."

    return zip_ref.namelist()[0]

#modify to call ant with argument of bundle etc. Dont have it reset db tho.
def configureDatabases(version):
    if os.path.isfile("build.xml"):
        print "configuring portal-ext from ANT"

        if version == "master":
            command = "link-ce"
        elif version == "7.0.x-private":
            command = "link-ee"
        else:
            print "Invalid version"

            sys.exit()

        rc = os.system("ant -buildfile build.xml " + command)

        if rc != 0:
            print "Error on ant compile"

            sys.exit(1)
    else:
        print "For automatic database and portal-ext configuration, download build.xml file"


if __name__ == "__main__":
    releaseServer = properties.releaseServer
    description = "Download and setup the lastest bundle \
		from the release server. Please make sure to read the documentation and \
		add your mysql.jar and portal-ext to the same directory as this script"
    helpTag = "Version of Liferay you want to download"

    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("version", help=helpTag)
    parser.add_argument("-s", "--startup", help="Starts tomcat after everything \
		else is complete", action="store_true")
    parser.add_argument("-c", "--check", help="Checks if you are up to date with \
		the latest version of the bundle on the server", action="store_true")
    parser.add_argument(
        "-a",
        "--ant",
        help="Uses Apache Ant to generate new SQl Databases and point portal-ext at them",
        action="store_true")

    args = parser.parse_args()

    version = args.version

    if not any(version == v for v in properties.versions):
        print "Invalid version. Only versions from properties.py are supported."
        sys.exit()

    serverFolder = properties.versions[version]["nameOnServer"]
    zipString = properties.versions[version]["fileOnServer"]
    folder = properties.bundlesFolder + properties.versions[version]["finalDirectory"]

    zipURL = getBundle(releaseServer + serverFolder)

    if not zipURL:
        print "Unable to find current %s bundle on the server" % (version)
        sys.exit()

    fileName = zipURL.rsplit("/", 1)[-1]
    gitID = fileName.rsplit("-", 1)[1]
    gitID = gitID.rsplit(".", 1)[0]

    #change dir to bundles folder
    os.chdir(properties.bundlesFolder);

    if not args.check and not args.ant:
        cleanUp(zipString, folder)

    if args.check:
        if checkLatest(zipString):
            print "You already have the latest version"
        else:
            print "There is a newer version available"

        sys.exit()

    else:
        if not checkLatest(zipString):
            print "Downloading Tomcat bundle for latest %s" % (version)

            downloadBundle(zipURL)
        else:
            print "You already have the newest version, using existing zip file"

        print "Unzipping"

        originalFolder = unzipBundle(fileName)
    os.chdir("L:/apacheScripts")
    if version=="master":
        subprocess.call("ant -Dbundle.type=ce7",shell=True);
    else:
        subprocess.call("ant -Dbundle.type=dxp7",shell=True);
    os.chdir("%s/tomcat-8.0.32/bin/" % (folder))
    subprocess.call("catalina run", shell=True)