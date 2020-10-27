#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 24 02:29:17 2020

@author: qiaojixu
"""

import os
import os.path
import shutil
from raccroche.contigs_alg.reset_weight import *
from raccroche.contigs_alg.mwm_rewrite import *
from raccroche.contigs_alg.save_mwmoutput import *
"""
    Module discription:
    --------------------
    Calculating MWM output step by step through concating all modules
"""


def check_mwm(W1,TreeNode, gf1, gf2, results_dir):
    """ 
    check the mwmInputWws_gf1_gf2_TreeNodei.py exists or not
    
    Parameters
    ----------
    W1 : int
        window size
    gf1 : int
        setting of NF, which is the largest total gene family size
        -- the smae as NF in paper
    gf2 : int  
        setting of  NG, which is largest gene family size in any 
        genome -- the same as NG in paper      
    TreeNode ： str 
        name of each ancestor in TreeNode_name
    results_dir : results directory    
   
    return
    ----------
    True : mwmInputWws_gf1_gf2_TreeNodei.py file exists
    False : mwmInputWws_gf1_gf2_TreeNodei.py does not exist
    """
    
    data_name ="W" + str(W1) + "Input" + TreeNode +'_'+ str(gf1) +'_' + str(gf2) + '.txt'
    if os.path.isfile(results_dir + "InputPyfile/"+ data_name):
        return True
    else:
        return False


def mwm_run(TreeNode_name, GF1, GF2, WindowSize, results_dir, gf_data):
    """ 
    major module to get mwm output
    
    Parameters
    ----------
    TreeNode_name : list
        list of strings containing all tree nodes
    GF1 : list
        a list of integers where each is an option of NF--the largest total 
        gene family size
    GF2 : list  
        a list of integers where each is an option of NG--largest gene family 
        size in any genome -- the same as NG in paper      
    WindowSize ： int
        window size number
    results_dir : results directory    
    gf_data : csv
        gene family file in csv format with 3 columns
    
    Output
    ----------
    all maximum weight matching adjacency output saved in results directory
    """
    for node in range(0, len(TreeNode_name)):
        tn = TreeNode_name[node]   
        TreeNode = tn
        ws = WindowSize
        #ws_min = 7
        for i in range(0, len(GF1)):
            gf1 = GF1[i]
            gf2 = GF2[i]
            if i == 0:
               ws2_25_6(WS=ws, gf1=gf1, gf2=gf2, TreeNode=tn, gf_data=gf_data, results_dir=results_dir ) 
            elif i >= 1:
               gf1_old = GF1[i-1]
               #gf2_old = GF2[i-1]
               if GF2[i-1] <= GF2[i]:
                   gf2_old = GF2[i-1]
               else:
                   gf2_old = GF2[i]
               ws_30_6(WS1=ws, WS2=ws, gf1=gf1, gf2=gf2, TreeNode=tn,gf1_old=gf1_old , gf2_old=gf2_old, gf_data=gf_data, results_dir=results_dir)
           
            #check if mwm input file exists or not, if it does exist, than run:   
            if check_mwm(W1=ws, TreeNode=tn, gf1=gf1, gf2=gf2, results_dir=results_dir)== True:
                MWM (WS=ws, gf1=gf1, gf2=gf2,TreeNode=tn, results_dir=results_dir)
                print("*"*50)
                print('W' + str(ws) + "_" + str(gf1) + "_" + str(gf2) + "_" +TreeNode + ' Output:')
                cmd = "python3 " + results_dir + "/InputPyfile/mwmInputW" + str(ws) + "_" + str(gf1) +"_" + str(gf2) + "_" +TreeNode + ".py"
                os.system(cmd)
                
                #save mwm output file
                if  i > 0:
                   gf1_old = GF1[i-1]
                #gf2_old = GF2[i-1]
                   if GF2[i-1] <= GF2[i]:
                       gf2_old = GF2[i-1]
                   else:
                       gf2_old = GF2[i]
                       
                   save_simple(WS1=ws, WS2=ws, TreeNode=tn, gf1=gf1, gf2=gf2, gf1_old=gf1_old , gf2_old=gf2_old, results_dir=results_dir)
            # if mwm input not exists, than we just copy the previous output    
            else:
                gf1_old = GF1[i-1]
                if GF2[i-1] <= GF2[i]:
                    gf2_old = GF2[i-1]
                else:
                    gf2_old = GF2[i]
                file = "W" + str(ws)  + TreeNode +'_'+ str(gf1_old) +'_' + str(gf2_old) + '.txt'
                out = "W" + str(ws) + TreeNode +'_'+ str(gf1) +'_' + str(gf2) + '.txt'
                shutil.copy2(results_dir+file,  results_dir+out)
                
                    
                    
    
                    
