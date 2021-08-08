#!/usr/bin/python
import re

pattern = ".*LDR*"

def match(cmd):
    hexCode = 0
    imm = 0
    if(re.match(pattern,cmd) != None):
        regPattern = "R[01]"
        result = re.findall(regPattern,cmd)
        hexCode = 5

        for reg in result:
            hexCode = hexCode << 1
            if(reg == 'R1'):
                hexCode += 1
        hexCode = hexCode << 3
    else:
        return -1

    return hexCode





