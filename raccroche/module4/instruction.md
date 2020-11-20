# MCScan plot 
Here is the jcvi install detailed intrcution https://github.com/tanghaibao/jcvi. After you have installed it on your laptop then you just need two sections: 
`Pairwise synteny search` and `Macrosynteny visualization`

### Usage
- You need to get the convert gff to bed and fatsa to cds by functions of MCScan or by coding yourself        

For example:   
Convert the GFF to BED file and rename them.
```
$ python -m jcvi.formats.gff bed --type=mRNA --key=Name Vvinifera_145_Genoscope.12X.gene.gff3.gz -o grape.bed
$ python -m jcvi.formats.gff bed --type=mRNA --key=Name Ppersica_298_v2.1.gene.gff3.gz -o peach.bed
```
Reformat the Phytozome FASTA files as well.
```
$ python -m jcvi.formats.fasta format Vvinifera_145_Genoscope.12X.cds.fa.gz grape.cds
$ python -m jcvi.formats.fasta format Ppersica_298_v2.1.cds.fa.gz peach.cds
```
In this monocots project, you can find all preprocessed cds and bed files in `MCScanPairwise` folder in the results folder under the project data directory

 - Next use the jcvi commends to get synteny blocks:
```
#get syteny blocks
$ ls *.???
acorus.bed acorus.cds ancestor1.bed ancestor1.cds
$ python -m jcvi.compara.catalog ortholog acorus ancestor1 --cscore=.60 --no_strip_names
```

- Final step is to run `jcvi.graphics.karyotype` module of MCScan to plot syteny blocks from last step

Before running the commend, we need to prepare the `seqids` and `layout` two input files which:
`seqids` file, which tells the plotter which set of chromosomes to include. 
`layout` file, which tells the plotter where to draw what. 
see details [here](https://github.com/tanghaibao/jcvi/wiki/MCscan-(Python-version)#macrosynteny-getting-fancy)
Once we have those files, then we can run:
`$ python -m jcvi.compara.synteny screen --minspan=30 --simple acorus.ancestor1.anchors acorus.ancestor1.anchors.new` 
With all input files ready, let's plot.
`$ python -m jcvi.graphics.karyotype seqids layout`
This generates our karyotype figure:

![image](./documentation/image/a1_aco.jpeg)

