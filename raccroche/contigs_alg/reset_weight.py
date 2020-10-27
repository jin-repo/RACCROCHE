#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 17 12:05:50 2020

@author: qiaojixu
"""


import pandas as pd
import os


def iseven(number):
    """
    Checks if a number is even or odd
    >>> iseven(5)
    False
    >>> iseven(6)
    True
    """
    return number % 2 == 0


def compare(input_txt,gf1,gf2,input_newName, Check, results_dir):
    """ 
    initial computing candidate adjacencies for the smallest ws 
    and gf1, gf2

    Parameters
    ----------
    input_txt : tuple of all adjacency, each line is node1, node2, weight
        original adjacencies list for each tree node 
        i.e. 1252, 7869, 233
    gf1 : int
        smallest setting of NF, which is the largest total gene family size
        -- the smae as NF in paper
    gf2 : int  
        smallest setting of  NG, which is largest gene family size in any 
        genome -- the same as NG in paper      
    input_newName ： 
        newname of this output 
    Check : gene family csv file
    results_dir : results directory    
   
    Output
    ----------
    a list pf retainted adj in input_newName.txt under results directory 
    """
    for i in range(0, len(input_txt)):
       check_cut =Check[(Check['Size'] <= gf1) & (Check['Genome'] <= gf2)].reset_index(drop = True)
       if iseven(input_txt.loc[i,0]) == True:
           gf_id= input_txt.loc[i,0]/2 +1
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       else :
           gf_id = (input_txt.loc[i,0]+1) / 2
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       if iseven(input_txt.loc[i,1]) == True:
           gf_id= input_txt.loc[i,1]/2 +1
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       else:
           gf_id= (input_txt.loc[i,1]+1) / 2
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
    if input_txt[2].any() != 0:
           with open (results_dir + "InputPyfile/" + input_newName,"w") as f:
               print('maxWeightMatching([',file =f)
               for i in range(0,len(input_txt)):
                   line = tuple(input_txt.loc[i,:])
                   print(line, end=',',file =f)
               print('])',file=f)




#compare(input_txt,gf1=25, gf2 =6,input_newName )
def compare2(input_txt,gf1,gf2, Check):
    """ 
    computing candidate adjacencies after completed the initial compare()

    Parameters
    ----------
    input_txt : tuple of all adjacency, each line is node1, node2, weight
        original adjacencies list for each tree node 
        i.e. 1252, 7869, 233
    gf1 : int
        Non smallest setting of NF, which is the largest total gene family size
        -- the smae as NF in paper
    gf2 : int  
        Non smallest setting of  NG, which is largest gene family size in any 
        genome -- the same as NG in paper    
    Check : gene family csv file 
    """
    for i in range(0, len(input_txt)):
       check_cut =Check[(Check['Size'] <= gf1) & (Check['Genome'] <= gf2)].reset_index(drop = True)
       if iseven(input_txt.loc[i,0]) == True:
           gf_id= input_txt.loc[i,0]/2 +1
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       else :
           gf_id = (input_txt.loc[i,0]+1) / 2
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       if iseven(input_txt.loc[i,1]) == True:
           gf_id= input_txt.loc[i,1]/2 +1
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0
       else:
           gf_id= (input_txt.loc[i,1]+1) / 2
           if not gf_id in check_cut['GeneFamily'].to_list() :
               input_txt[2][i] =0

def reset_weight_input(input_txt,out_exist,input_newName, results_dir):
    """ 
    reset candidate adjacencies weight after running compare2()

    Parameters
    ----------
    input_txt : tuple of all adjacency, after completing compare2()
    input_newName ： 
        newname of this output 
    results_dir : results directory to save all retained adjacencies

    Output
    ----------
    a list pf retained adj in input_newName.txt under results directory 
    
    """
    input_txt[3]=[x in out_exist[0].values.tolist() for x in input_txt[0].values.tolist()]
    input_txt[4]=[x in out_exist[0].values.tolist() for x in input_txt[1].values.tolist()]
    input_txt.loc[input_txt[3]==True,2]=0
    input_txt.loc[input_txt[4]==True,2]=0
    if input_txt[2].any() != 0:
        with open (results_dir + "InputPyfile/" + input_newName, "w") as f:
            print('maxWeightMatching([',file =f)
            for i in range(0,len(input_txt)):
                line = tuple(input_txt.loc[i,0:2])
                print(line, end=',',file =f)
            print('])',file=f)

    
           

#initial running, for ws =2, 25_6
def ws2_25_6(WS, gf1, gf2,TreeNode, gf_data, results_dir):
    """
    initial maximum weight running under windowsize and gene family restrictions
    """
    infile ='afterW' + str(WS) + TreeNode + '.txt'
    cwd = os.getcwd()
    A2= pd.read_table(cwd + '/' + infile, header =None ,sep=',',engine = 'python')
    input_newName = "W" + str(WS) + "Input" +  TreeNode + "_" + str(gf1) + "_" + str(gf2) + ".txt"
    compare(input_txt=A2, gf1=gf1, gf2=gf2, input_newName=input_newName, Check=gf_data, results_dir=results_dir)



#for ws >=3, 25_6

# path = r'/Users/qiaojixu/Desktop/6Genomes_Project/TreeNode/MWMOutput/
def ws_30_6(WS1, WS2, gf1, gf2, TreeNode, gf_data, results_dir, gf1_old, gf2_old):
    """
    maximum weight running under larger windowsize and gene family restrictions
    """
    cwd = os.getcwd()
    infile = results_dir + 'W' + str(WS1) + TreeNode + '_'+ str(gf1_old) + '_' + str(gf2_old) + '.txt'
    #infile = results_dir + 'W' + str(WS1) + TreeNode + '_'+ str(gf1_old) + '_' + str(gf2_old) + '.txt'
   
    S=pd.read_csv(infile, header=None, sep =' ' ,engine = 'python')
    infile2 = 'afterW'+ str(WS2) + TreeNode + '.txt'
    A3= pd.read_table(cwd + '/' + infile2, header=None, sep=',', engine='python')
    
    compare2(input_txt=A3, gf1=gf1, gf2=gf2, Check= gf_data)
    
    m=pd.concat([S[0],S[1]],ignore_index=True).to_frame()
    input_newName = 'W' + str(WS2) + 'Input'+ TreeNode +'_' + str(gf1)+'_'+ str(gf2) + '.txt'
    reset_weight_input(input_txt=A3, out_exist=m, input_newName=input_newName, results_dir=results_dir)
    






    




