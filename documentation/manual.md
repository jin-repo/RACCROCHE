## Dependencies
The raccroche package requires `Python 3` and `R version 3.6.3`.


## Config file
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



## Files
The file structure is depicted in the [diagram of program architechture and file structure](./documentation/program-vs-file-structure.svg). 
All the input and output data is located in the project data folder (i.e. `~/RACCROCHE/project-monocots`).

### Input

`Genomes.txt`

> An example showing the format genomes data (note that they must be delimited by tab characters):

      genomeID    genomeName  ancestor  numChr
      54711       Acorus	      1	      12
      51364       Spirodela         1	      20
      51051       Dioscorea	      2	      21
      33908       Asparagus	      3	      10
      25734       Ananas	      4	      25
      33018       Elaeis	      4	      16




# Module 1: construct gene families and list candidate adjacencies
## Dependencies

## Content 

## Usage


## Input

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
## Output
* ``ancestor contigs``
* ``retained mwm adjacencies of ancestor``
* ``intermediate output in process``
All files generated in process are stored in `java` and `InputPyfile` two folders

## Installation

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

# Module 2: construct ancestral contigs by Maximum Weight Matching


# Module 3: match contigs, cluster and sort ancestral chromosomes, paint extant genomes with ancestral chromosomes



## Content 

## Usage

## Input

## Output



