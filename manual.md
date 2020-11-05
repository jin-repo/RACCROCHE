
## Dependencies

## Content 

## Usage

### yaml config file

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
## Ancestors painting on genomes
----------------------------------
  ```
  Lingling could you do this ? thanks
  ```
  
