__author__ = 'WeiJuMac01'
import yaml
import os
import glob
def main():
    #path=os.getcwd()
    filelist=glob.glob("*.yaml")
    for fileName in filelist:
        yamlToPlist(fileName)
def yamlToPlist(fileName):
    inobj = yaml.loadFile(fileName)
    inobj



main()