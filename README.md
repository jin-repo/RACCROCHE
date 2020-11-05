# RACCROCHE (Reconstruction of AnCestral COntigs and CHromosomEs)

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Overview

Given the phylogenetic relationships of several extant species, the reconstruction of their ancestral genomes at the gene and chromosome level is made difficult by the cycles of whole genome doubling followed by fractionation in plant lineages. Fractionation scrambles the gene adjacencies that enable existing reconstruction methods. We propose an alternative approach that postpones the selection of gene adjacencies for reconstructing small ancestral segments and instead accumulates a very large number of syntenically validated candidate adjacencies to produce long ancestral contigs through maximum weight matching. Likewise, we do not construct chromosomes by successively piecing together contigs into larger segments, but instead count all contig co-occurrences on the input genomes and cluster these, so that chromosomal assemblies of contigs all emerge naturally ordered at each ancestral node of the phylogeny. These strategies result in substantially more complete reconstructions than existing methods. We deploy a number of quality measures: contig lengths, continuity of contig structure on successive ancestors, coverage of the reconstruction on the input genomes, and rearrangement implications of the chromosomal structures obtained. The reconstructed ancestors can be functionally annotated and are visualized by painting the ancestral projections on the descendant genomes, and by highlighting syntenic ancestor-descendant relationships. Our methods can be applied to genomes drawn from a broad range of clades or orders. Together with the pipeline, we provide our project data on six genomes of monocot orders, confirming the tetraploidization event “tau” in the stem lineage between the alismatids and the lilioids.

There are four major modules including seven steps in the RACCROCHE pipeline:
  
  # Module 1
  - Step 1: Pre-process gene families
  - Step 2: List generalized adjacencies
  - Step 3: List candidate adjacencies
  
  # Module 2
  - Step 4: Construct contigs
  
  # Module 3
  - Step 5: Match synteny blocks between ancestral genome and extant genomes
  - Step 6: Cluster ancestral contigs into ancestral chromosomes
  - Step 7: Painting the extant genomes according to the ancestral chromosomes
  
  # Module 4
  - Step 8: Adapting MCScanX to match ancestral genomes with extant genomes
  - Step 9: Measures of Quality

|  |  |
| ------ | ------ |
|Authors | Qiaoji Xu ([QiaojiXu]) |
|  | Lingling Jin ([LinglingJin]) |
|  | Chunfang Zheng |
|  | James H. Leeben-Mack |
|  | David Sankoff |
| Emails | limqiaojixu@gmail.com|
|  | lingling.jin@cs.usask.ca |
| License | [BSD] |

### Citations:   
  - If you use the raccroche pipline for ancestral contigs reconstruction, please cite:   
*RACCROCHE: ancestral flowering plantchromosomes and gene ordersbased on generalized adjacenciesand chromosomal gene co-occurrences* [need to add link]  
## Ancestors contigs generating
--------------------------------


### Input

  - a gene family size file, in csv format with 3 columns 'GeneFamly', 'Size', 'Genome' 
  - parameters txt file, containing all parameters for running this program, the format is:  
    \#WindowSize = number$  
    \#TreeNode_name = TreeNode_i$  
    \#GF1 = numbers$  
    \#GF2 = numbers$  
  - candidate adjacencies of each ancestor for a specified windowsize:  
    The txt file name should follow the rule   
    `after` + `WindowSize` + `TreeNodeID`+`.txt`, such as `afterW7TreeNode1.txt`

You can also:
  - find examples of these files in the "Examples" directory, and a description of those file formats in the pdf documentation **(not finish yet)**  
### Output
* ``ancestor contigs``
* ``retained mwm adjacencies of ancestor``
* ``intermediate output in process``
All files generated in process are stored in `java` and `InputPyfile` two folders

### Installation

raccroche requires `python v3+` to run.  
To install the package *raccroche*, and all its dependances, from the root directory, just do::  
```
$ sudo python3 setup.py install
```
You will then be able to use raccroche from any directory in your computer, just as any other software.  
Test whether it has been installed successfully:
```
$ raccroche_main -h
    usage: getcontigs.py [-h] -g GF_FILE -p PARAMETERS_FILE -r RESULTS_DIR

    To run all scripts

    optional arguments:
      -h, --help            show this help message and exit
      -g GF_FILE, --gf GF_FILE, --genefamily GF_FILE
                            Specify gene family file
      -p PARAMETERS_FILE, --pm PARAMETERS_FILE, --parameters PARAMETERS_FILE
                            Specify parameters file
      -r RESULTS_DIR, --rd RESULTS_DIR, --resultdir RESULTS_DIR
                            A directory where saving all outputs
```


### Using raccroche
For a classic use of raccroche, you can install the package by the following command. Then,
from anywhere in your computer, run::
```
$ raccroche_main -g gf_file  -p parameters_file  -r results_dir
```


### Uninstalling raccroche

Whatever the way you installed raccroche, you can uninstall it by running::
```
$ sudo pip3 uninstall raccroche
```

### Running tests

```sh
$ To Be Continued...
```
## Ancestors painting on genomes
----------------------------------
  ```
  Lingling could you do this ? thanks
  ```
  
   [QiaojiXu]: <https://github.com/Qiaojilim>
   [LinglingJIn]: <https://github.com/jin-repo/RACCROCHE>
   [BSD]: <https://en.wikipedia.org/wiki/BSD_licenses>





