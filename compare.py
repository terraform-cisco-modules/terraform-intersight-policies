#!/usr/bin/env python3
from stringcase import snakecase
import json, yaml
yfile = open('./defaults.yaml', 'r')
yd1 = yaml.safe_load(yfile)
yfile.close()
yfile = open('./bios.yaml', 'r')
yd2 = yaml.safe_load(open('bios.yaml', 'r'))
yfile.close()
yd3 = {}
for k, v in yd2.items():
    yd3.update({snakecase(k): v})
for k, v in yd3.items():
    if not k in yd1['policies']['bios']: print(k)
    #is_match = False
    #for a, b in yd1['policies']['bios'].items():
    #    if k == a:
    #        print('matched')
    #        is_match = True
    #        break
    #if is_match == False: print(k)
