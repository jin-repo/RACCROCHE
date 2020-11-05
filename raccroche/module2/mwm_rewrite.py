#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 13 15:02:47 2020

@author: qiaojixu
"""
import inspect
from raccroche.module2 import Sample_MWM_Output  as sample
"""
    Module discription:
    --------------------
    module to rewrite mwm input py file
"""

def MWM (WS, gf1, gf2,TreeNode, results_dir) :
    """ 
    rewrite mwmInputWws_gf1_1gf2TreeNodei.py 
    
    Parameters
    ----------
    WS : int
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
    mwmInputWws_gf1_1gf2TreeNodei.py file in InputPyfile folder
    """
    #cwd = os.getcwd()
    #mwm_path = os.path.dirname(os.path.abspath(__file__))
    #fin = open (mwm_path + "/Sample_MWM_Output.py","rt")
    fin = inspect.getsource(sample)
    fout = open (results_dir + "InputPyfile/mwmInputW"+str(WS)+'_'+str( gf1)+'_'+str(gf2)+'_' + TreeNode+'.py',"wt")
    fin = fin.replace("/test.txt", results_dir +"InputPyfile/mwmOutput/W" + str(WS) + TreeNode + "_"+ str( gf1)+"_"+str(gf2) +".txt")
    fout.write(fin)
    fout.close()

    with open(results_dir + "InputPyfile/" + "W" + str(WS) + "Input"+TreeNode + "_"+ str( gf1)+"_"+str(gf2) +".txt") as f:
        with open(results_dir + "InputPyfile/mwmInputW" +str(WS)+"_"+ str( gf1)+"_"+str(gf2)+"_"+ TreeNode+".py","a") as f1:
            for line in f:
                f1.write(line)
            print("end = time.perf_counter()"+"\n"+"print (end - start)",file =f1)
   







