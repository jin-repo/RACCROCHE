#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 08:39:20 2020

@author: qiaojixu
"""

import yaml
import os

with open('./config.yaml') as f:
    data = yaml.load(f, Loader=yaml.FullLoader)
    
#print(data["DIS.threshold"])
data_path = data['data.path']    
genomes = os.path.join(data_path, "Genomes.txt")
gffs = os.path.join(data_path, "data/gffs")
treenode = os.path.join(data_path, "data/MWMInput/TreeNodeParameters.txt")
#generate original gene family
os.system("java -jar module1/GF.jar  " +  genomes + "  " +  gffs)
#generate genomes.txt
os.system("java -jar module1/GetGenomes.jar  " +  genomes + "  " +  gffs)
#generate original andjacencies
os.system("java -jar module1/MWMInputTreeNode.jar  " +  treenode)

    
    
   
