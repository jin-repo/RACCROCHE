# Module 2
This module 2 is designed to generate ancestors contig from the output of module 1.
### Dependencies
 - pandas
 - shutil
 - java
### Content 

### [Usage](../run_raccroche)
For a classic use of raccroche module 2, you can install the package by the following command. Then,
from anywhere in your computer, run::
```
$ cd /the/folder/which/include/all/input/data 
$ module2_main -g gf_file  -p parameters_file  -r results_dir
```
For example, in our monocots project, we can run:
`cd  ~/raccroche/project-monocots/data/MwmInput`
`module2_main  -g GeneFamily.csv  -p ContigParameters.txt  -r results`
## Input

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
## Output
* ``ancestor contigs``
* ``retained mwm adjacencies of ancestor``
* ``intermediate output in process``
All contigs of ancestors are stored in `project-monocots/data/Contig`
All files generated in process are stored in `project-monocots/results/InputPyfile/java` and `project-monocots/results/InputPyfile` two folders

## Installation

RACCROCH module 2 requires `python v3+` to run and some dependencies that introduced at `Dependencies` section. please make sure that you have isntalled those before you are going to install.
To install the package *raccroche*, and all its dependances, from the root directory, just do::  
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

Whatever the way you installed raccroche, you can uninstall it by running::
```
$ sudo pip3 uninstall module2 
```

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

[QiaojiXu]: <https://github.com/Qiaojilim>
[BSD]: <https://en.wikipedia.org/wiki/BSD_licenses>

  
