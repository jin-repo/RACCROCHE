#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 17 19:57:16 2020

@author: qiaojixu
"""

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
    

data_path = data['data.path']

os.system("pip3 install pandas")
#install it first according to the manual 
os.system("sudo pip3 install git+git://github.com/Qiaojilim/raccroche_module2.git")

input_path = os.path.join(data_path,"data/MwmInput")
#os.chdir(data_path + "/data/MwmInput")
os.chdir(os.path.expanduser(input_path))

genefamily_file = "GeneFamily.csv"
parameters_file = "ContigParameters.txt"
results_dir = "results/"

#cd /which folder/contain/all/mwm/input/files
os.system("module2_main  -g " + genefamily_file + " -p "+ parameters_file + " -r " + results_dir)


    
   
