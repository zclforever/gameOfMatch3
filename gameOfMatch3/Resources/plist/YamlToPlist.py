#!/usr/bin/ python
__author__ = 'WeiJuMac01'
import yaml
import os
import glob
import plistlib
def main():
    #path=os.getcwd()
    filelist=glob.glob("*.yaml")
    for fileName in filelist:
        yamlToPlist(fileName)

def yamlToPlist(fileName):
    name,ext=os.path.splitext(fileName)
    data = yaml.load(open(fileName))
    plistlib.writePlist(data,open(name+'.plist','wb'))
    return data





main()