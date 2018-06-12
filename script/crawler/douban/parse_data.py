# coding = utf-8

import json

filepath = "data.txt"

def print_dict(parse_dict):
    for key in parse_dict:
        print u"{}:{}".format(key,parse_dict[key]).encode("utf-8")

with open(filepath,"r") as fp:
    line = fp.readline()
    while line:
        data = json.loads(line)
        print "================================================="
        print_dict(data)
        print "=================================================\n\n\n"
        line = fp.readline()
