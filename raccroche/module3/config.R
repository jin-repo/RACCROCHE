source("./module3/utilities.R")
source("./module3/helper.R")

#### Install reqired packages in R Console
packages<-c("yaml","gplots", "ggplot2", "dplyr", "scales", "grid", "gridExtra", "data.table", "RColorBrewer", "varhandle", "cowplot", "plyr", "spaa","CRPClustering", "taRifx")
cat("\n\n*********Checking Dependencies *********\n\n")
check.packages(packages)
cat("*********Finished checking dependencies*********\n\n\n\n")

current_wd <- getwd() ## run Rscript in command line
# current_wd <- dirname(rstudioapi::getSourceEditorContext()$path) ## run Rscript in RStudio

############################################################
################## Read in parameters from yaml file ####################
config.obj <- read_yaml('./config.yaml')


ws <- config.obj$ws # window size
gf1 <- config.obj$gf1  # gene family size para1: the maximum number of genes in a gene family
gf2 <- config.obj$gf2  # gene family size para2: the maximum number of genomes in a gene family




############################################################
################## check input directories ####################


## input: read in CoGeIDs for all genomes
genomeCoGeID <- readIn.genomes (config.obj$data.path, "Genomes.txt")
## tree nodes to analyze
trn.vector <- sort(unique(genomeCoGeID$ancestor)) 
## genomes to analyze
gid.vector <- genomeCoGeID$genomeID

## input: path to karyotypes
karyotype.path <- file.path(config.obj$data.path, "karyotype")

## input: path to contigs of the ancestral genome
contig.path <- file.path(config.obj$data.path, "data", "Contig")

## input: path to labelled gene families 
GF.path <- file.path(config.obj$data.path, "data", "GeneFamily")


############################################################
################## check output directories ####################

## path to contig GFF files (output of getContigGenes.R)
contigGFF.path <- file.path(config.obj$data.path, "data", "contigGFF")

## path to results
results.path <- file.path(config.obj$data.path,"results")

## create output directories if they don't exist
dir.create(file.path(config.obj$data.path, "data", "contigGFF"), showWarnings = FALSE)
dir.create(file.path(config.obj$data.path,"results"), showWarnings = FALSE)

dir.create(file.path(results.path, "ancestorStats"), showWarnings = FALSE)
dir.create(file.path(results.path, "clustering"), showWarnings = FALSE)
dir.create(file.path(results.path, "paintedChrs"), showWarnings = FALSE)



############################################################
################## set thresholds ####################

ctgLen <- config.obj$ctgLen   ## minimum length in each contig, an option to select contig length according to N50
nctg <- config.obj$nctg    ## only include first nctg contigs

## threshold of distance between two genes in the same contig on the same chromosome
## if the distance between two genes is smaller than the threshold, merge them into one block
DIS.threshold <- config.obj$DIS.threshold

## threshold to visualize the gene/block
## if a block is less than this length, do not show it --> keep the plot clean
blockLEN.threshold <- config.obj$blockLEN.threshold

## threshold for coocurrence analysis
## only count blocks that are longer than 15KB
lenBLK.threshold <- config.obj$lenBLK.threshold



