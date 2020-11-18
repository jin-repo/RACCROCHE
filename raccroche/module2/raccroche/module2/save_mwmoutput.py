#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 13 15:16:43 2020

@author: qiaojixu
"""
"""
 Module discription:
    --------------------
    module to save all mwm adjacency output:

"""


def save_simple (WS1,WS2, TreeNode, gf1, gf2,gf1_old, gf2_old, results_dir):
    with open (results_dir +'InputPyfile/mwmOutput/W'+ str(WS1)+ TreeNode + '_' + str(gf1_old) + '_' + str(gf2_old) + '.txt') as f:
        with open (results_dir +'InputPyfile/mwmOutput/W'+ str(WS2)+ TreeNode + '_' + str(gf1) + '_' + str(gf2) + '.txt','a') as f1:
             for line in f:
                f1.write(line)     
            


    
    
