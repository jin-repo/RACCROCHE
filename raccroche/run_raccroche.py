#!/usr/bin/env python3

import os
import subprocess
import sys
import yaml


def main(conf='config.yaml'):
    cwd = os.path.dirname(os.path.realpath(__file__)) 

    with open(conf, 'r') as stream:
        try:
            conf_dict = yaml.safe_load(stream)
            print(conf_dict['data.path'])
        except yaml.YAMLError as exc:
            print(exc)
            sys.exit(1)
    
    # module 1
    print('==== Generating gene families txt file and tree nodes input files====')
    print('==== This step is very slow ... ')
    # TODO - wrap the code in main.py in a main function so it can be imported.
    # subprocess.Popen('python3 module1/main.py')
    
    print(cwd)
    proc = subprocess.Popen(['Python3', 'module1/main1.py'], cwd=cwd)
    proc.wait()
    print(proc.returncode)
    
    # module 2
    print('==== Generating contigs for ancestors ==== ')
    print('==== This step is slow ... ')
    proc = subprocess.Popen(['Python', 'module2/main2.py'], cwd=cwd)
    proc.wait()
    print(proc.returncode)
    os.chdir(cwd)
    
    
    # module 3
    
    print('==== Parsing and cleaning up gene families ====')
    # python replace_gene_family.py
    print('Finished parsing and cleaning up gene families')

    print('=========================================================')
    print('==== Summarizing contig statistics for each ancestor ====')
    print(cwd)
    proc = subprocess.Popen(['Rscript', 'module3/summarizeCtgLen.R'], cwd=cwd)
    proc.wait()
    print(proc.returncode)

    print('===========================================================================')
    print('==== Extracting gene family features for each ancestor and each genome ====')
    print('==== This step is very slow ... ')
    proc = subprocess.Popen(['Rscript', 'module3/getContigGenes.R'], cwd=cwd)
    proc.wait()

    print('===================================================') 
    print('==== Analyzing contig co-occurence ====')
    print('==== This step is very slow ... ')
    proc = subprocess.Popen(['Rscript', 'module3/analyze.R'], cwd=cwd)
    proc.wait()
    print('==== Check out results/clustering folder for clustering results')

    print('==========================================================')
    print('==== Painting ancestors on extant genomes ====')
    proc = subprocess.Popen(['Rscript', 'module3/paintChr.R'], cwd=cwd)
    proc.wait()

    print('==================================================================')
    print('==== Sorting contigs within ancestral chromosomes ====')
    subprocess.Popen(['Rscript', 'module3/sortContigs.R'], cwd=cwd)
    proc.wait()

    print('===================================================')
    print('==== Sorting ancestral chromosomes ====')
    subprocess.Popen(['Rscript', 'module3/sortChromosomes.R'], cwd=cwd)
    proc.wait()


if __name__ == '__main__':
    main()
