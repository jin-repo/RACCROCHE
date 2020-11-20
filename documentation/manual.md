# Dependencies
- Python 3
- Java
- R version 3.6.3

# Usage
Before running the pipeline, users need to set up a config file and have the project data in place. The file structure is depicted in the [diagram of program architechture and file structure](./documentation/program-vs-file-structure.svg). 

First, specify a project data folder where the project data is located and a set of parameters in the config file.

Second, depost the input data file into the project data folder.

### Config file
Before running the program, you need to make sure to edit the desired yaml config file (`config.yaml`) under the raccroche directory in order to set up parameters for the algorithms and point the program to appropriate data directory. 

`data.path`
> The path to the project data folder. For example, `~/RACCROCHE/project-monocots`.

`ws` 
> The window size to select candidate adjacencies. The default is `7`.

`gf1` 
> The maximum number of genes in a gene family in all genomes. The default is `50`.

`gf2` 
> The maximum number of genes in a gene family in every genome. The default is `10`.


`nctg`
> The number of contigs in each ancestor to be includeded in the downstream analysis.
> The `nctg` is selected to best by the length distribution of contigs


`DIS.threshold`
> The threshold of distance between two genes in the same contig on the same chromosome.
> If the distance between two genes is smaller than the threshold, merge them into one block
> The default is `1000000`, that is, 1 Mbp.

`blockLEN.threshold`
> The threshold to visualize the synteny blocks.
> If a block is shorter than this length, do not show it. This helps keep the chromosome plot clean.
> The default is `150000`, which only shows blocks longer than 150 Kbp.


`lenBLK.threshold`
> The threshold for coocurrence analysis.
> The default is `15000 `, which only counts blocks that are longer than 15 Kbp for cooccurrence.


### Project data input

All the input and output data is located in the project data folder (i.e. `~/RACCROCHE/project-monocots`).

`Genomes.txt`
> An example showing the format genomes data (note that they must be delimited by tab characters):

    genomeID    genomeName  ancestor  numChr       gff
    25734       Ananas         4        25      Ananas_comosus_pineapple_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid25734.gff
    33018       Elaeis         4        16      Elaeis_guineensis_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid33018.gff
    33908        Asparagus       3        10      Asparagus_officinalis_garden_asparagus_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid33908.gff
    51051        Dioscorea       2        21      Dioscorea_rotundata_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid51051.gff
    51364        Spirodela       1        20      Spirodela_polyrhiza_Greater_Duckweed_strain_9509_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid51364.gff
    54711        Acorus       1        12      Acorus_americanus_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid54711.gff

`karyotype` files
> Karyotype files of the extant genomes under the `karyotype` directory, following the naming convention `karyotype_[CoGe ID]_[genome name].txt`. For example, the karyotype of Acorus is in file `karyotype_54711_Acorus.txt`, with chromosome number and chromosome size/length (in bp) delimited by tab character:

      chr    size
      1    37743429
      2    34360390
      3    33772675
      4    31994915
      5    31167455
      6    30970160
      7    30771956
      8    28400560
      9    28235908
      10    25518903
      11    25169648
      12    24790462

`gff` gene feature files 
> The annotated gene features of the extant genomes under the `ContigGFF` directory.




### Run the raccroche pipeline

To run the whole pipline including 3 modules, please run:
```
$ git clone https://github.com/jin-repo/RACCROCHE.git
$ python3 run_raccroche.py
```


# Project Output

Raccroche produces results in the `results` folder under the project data directory. The results are partitioned into separate folders as follow.

`ancestorStats` directory
> The statistical measures of ancestral genomes and their matchings to extant genomes. We have developed several measurements, including
> - summary of ancestral contig lengths,
> - ancestral block measures: average block length, N50, genome coverage, average number of chromosomes, 
> - ancestral genome stats: total number of contig lengths and genes in each chromosome,
> - coherence among ancestors,
> - choppiness measures of chromosome painting.


`clustering` directory
> The clustering results, including
> - heatmaps,
> - clustering results in txt files.

`ordering` directory
> Ordering results from the linear ordering problem, including
> - contigs orders within each ancestral chromosome,
> - chromosome orders within each ancestor

`paintedChrs` directory
> Painted chromosome plots that match ancestral genomes to extant genomes

`InputPyfile` directory
> All process files during the maximum weight matching including
> - mwm adjacency output
> - java process files

`MCScanPairwise` directory  
> All pairwise syteny plot by applying [MCScan](https://github.com/tanghaibao/jcvi/wiki/MCscan-(Python-version)#macrosynteny-getting-fancy) with output including  
> - `instrcution.md` on explaining how to aplly MCScan
> - `mcdata` floder containg all necessary input data files
> - MCScan karyotype `plot` output
# Specifics of each module
Each module does specific task and could be run separately.

## Module 1
Module 1 is designed to generate original gene family and initial tree nodes adjacensies.

### Usage
For a classic use of raccroche module 1, you need to download the folder `raccroche/module1`
in terminal, we run::
```
$ cd /raccroche/dir
$ Python3 module1/main.py
```


### Contenet
 - *GF.jar* : the first java class to generate original gene family
 - *GetGenomes.jar* : the second java class to rewrite species gene as gene family number
 - *MWMInputTreeNode.jar* : the last java class to generate initail tree nodes adjacencies

### Input
  - Genomes.txt : inlude all genomes information
  - ContigGFF : contain all sytnteny comparison and genomes GFF3 files from CoGe
  - mwmatching.py : the algorithm to generate all initial ancestors adjacensies

You can also:
  - find examples of these files in the `project-monocots/data/ContigGFF` and  `project-monocots/data/GeneFamily` directory
### Output
* ``GeneFamily65.txt``
* ``genomes.txt``
* ``initial tree nodes adjacensies``

### Installation
RACCROCH module 1 do not need to install packages, the only thing we need is java and python3  enviroment.
You will then be able to use RACCROCHE module 1 by command.


## Module 2
This module 2 is designed to generate ancestors contig from the output of module 1.
### Usage
For a general use of raccroche module 2, you can install the package by the following command. Then,
from anywhere in your computer, run::
```
$ cd /the/folder/which/include/all/input/data 
$ module2_main -g gf_file  -p parameters_file  -r results_dir
```
For example, in our monocots project, we can run:
`cd  ~/raccroche/project-monocots/data/MwmInput`
`module2_main  -g GeneFamily.csv  -p ContigParameters.txt  -r results/`
### Input

  - a gene family size file, in csv format with 3 columns 'GeneFamly', 'Size', 'Genome' 
  - parameters txt file, containing all parameters for running this program, the format is:  
    *\#WindowSize = number$*
    *\#TreeNode_name = TreeNode_i$*  
    *\#GF1 = numbers$*  
    *\#GF2 = numbers$* 
  - candidate adjacencies of each ancestor for a specified windowsize:  
    The txt file name should follow the rule   
    `after` + `WindowSize` + `TreeNodeID`+`.txt`, such as `afterW7TreeNode1.txt`

You can also:
  - find examples of these files in the `project-monocots/data/MwmInput` directory
### Output
* ``ancestor contigs``
* ``retained mwm adjacencies of ancestor``
* ``intermediate output in process``
All contigs of ancestors are stored in `project-monocots/data/Contig`
All files generated in process are stored in `project-monocots/results/InputPyfile/java` and `project-monocots/results/InputPyfile` two folders

### Installation

RACCROCH module 2 requires `python v3+` to run and some dependencies that introduced at `Dependencies` section. please make sure that you have isntalled those before you are going to install.
To install the package *module2*, and all its dependances, from the root directory, just do::  
```
$ sudo pip3 install git+git://github.com/Qiaojilim/raccroche_module2.git
```

You will then be able to use RACCROCHE module 2 from any directory in your computer, just as any other software.  
Test whether it has been installed successfully:
```
$ module2_main -h
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

### Uninstalling raccroche
You can uninstall module 2 by running::
```
$ sudo pip3 uninstall module2
```

## Module 3
The program architeture of Module 3 is depicted in the [diagram of module 3 program architechture and file structure](./documentation/Module3-structure.svg). The R scripts in each step can be run separately.



