import re
import os

def getIPinfo():
    pattern1=re.compile(r'^[0-9a-zA-Z]+')
    pattern2=re.compile(r'\d+\.\d+\.\d+\.\d+')
    ips={}
    cmdResult=os.popen('ifconfig').read()
    resultArray=cmdResult.split('\n\n')
    for netinfo in resultArray:
        nicName=pattern1.match(netinfo)
        ip = re.findall(pattern2, netinfo)
        if (nicName is not None) and (len(ip) !=0):
            ips[nicName.group()]=ip[0]
    return ips
if __name__=="__main__":
    print getIPinfo()
