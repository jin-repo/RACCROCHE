# Module 1
This module 1 is designed to generate original gene family and initial tree nodes adjacensies.
### [config.yaml](../config.yaml)
You can change the input paramenters from here.
### Dependencies
 - java
 - python>=3
### [Usage](../run_raccroche)
For a classic use of raccroche module 1, you need to download the folder `raccroche/module1`
in terminal, we run::
```
$ cd /raccroche/dir
$ Python3 module1/main.py
```
You can also check the usage in the file [run_raccroche](../run_raccroche)

### Contenet
 - *GF.jar* : the first java class to generate original gene family
 - *GetGenomes.jar* : the second java class to rewrite species gene as gene family number
 - *MWMInputTreeNode.jar* : the last java class to generate initail tree nodes adjacencies

## Input
  - Genomes.txt : inlude all genomes information
  - ContigGFF : contain all sytnteny comparison and genomes GFF3 files from CoGe
  - mwmatching.py : the algorithm to generate all initial ancestors adjacensies

You can also:
  - find examples of these files in the `project-monocots/data/ContigGFF` and  `project-monocots/data/GeneFamily` directory
## Output
* ``GeneFamily65.txt``
* ``genomes.txt``
* ``initial tree nodes adjacensies``

## Installation
RACCROCH module 1 do not need to install packages, the only thing we need is java and python3  enviroment.
You will then be able to use RACCROCHE module 1 by command.


