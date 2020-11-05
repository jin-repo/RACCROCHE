#!/usr/bin/env Rscript

###################################################
### This program take ancestral genomes (sets of contigs) and labeled ortholog gene families as input
### It summarizes the contig number and length statistics
###################################################
### input: set of ancestral contigs under contig.path
### output: under "ancestorStats" folder under results.path
###       1. csv file containing first nctg ancestral contigs in each ancestor: contigs_W*.csv
###       2. csv file containing contig statistics: ctgStats.csv
###################################################

source("./module3/config.R")


## initialize data frame for contig statistics 
ctgStats <- data.frame( ws=numeric(), gf1=numeric(), gf2=numeric(), treeNode=numeric(), MaxCtgLen=numeric(), TotalNoCtg=numeric(),
                          CtgLen.N40=numeric(),nCtg.N40=numeric(),  CtgLen.N50=numeric(), nCtg.N50=numeric(), 
                          CtgLen.N60=numeric(), nCtg.N60=numeric(), CtgLen.N70=numeric(), nCtg.N70=numeric(), 
                          CtgLen.N80=numeric(), nCtg.N80=numeric(), stringsAsFactors = FALSE)

ancestor <- data.frame()

for (trn in trn.vector){ 
  
  ## initialize contigLen list for the current parameters
  CTG.list <- c()
  
  # input contigs
  contig.fname <- list.files(contig.path, pattern=paste0("ContigW",ws,"TreeNode",trn,"_",gf1,"_",gf2,".txt"))
  if (length(contig.fname)==0) {next}
  
  ## read in contig file line by line
  con <- file(file.path(contig.path, contig.fname), "r")
  
  while(TRUE){
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    
    ## read in and parse the current contig: contigN
    contigN <- as.numeric(strsplit(line, " ")[[1]][2])
    line = trimws(readLines(con, n = 1))
    #print(line)
    
    # the original contig read in from file
    contig_origin = abs(as.numeric(strsplit(line, " +")[[1]]))
    
    ## save the longest Contig
    if (contigN == 0){
      ctgStats <- rbind( ctgStats, data.frame(ws=ws, gf1=gf1, gf2=gf2, treeNode=trn, MaxCtgLen=length(contig_origin), TotalNoCtg=0, 
                                              CtgLen.N40=0, nCtg.N40=0, CtgLen.N50=0, nCtg.N50=0, CtgLen.N60=0, nCtg.N60=0, 
                                              CtgLen.N70=0, nCtg.N70=0, CtgLen.N80=0, nCtg.N80=0) )
    }
    
    
    CTG.list <- c(CTG.list, length(contig_origin))
  } # end of reading file line by line
  
  ctgStats[nrow(ctgStats),]$TotalNoCtg <- length(CTG.list)
  
  ctgStats[nrow(ctgStats),]$CtgLen.N40 <- N40(CTG.list);ctgStats[nrow(ctgStats),]$nCtg.N40 <- match(N40(CTG.list), CTG.list)
  ctgStats[nrow(ctgStats),]$CtgLen.N50 <- N50(CTG.list);ctgStats[nrow(ctgStats),]$nCtg.N50 <- match(N50(CTG.list), CTG.list)
  ctgStats[nrow(ctgStats),]$CtgLen.N60 <- N60(CTG.list);ctgStats[nrow(ctgStats),]$nCtg.N60 <- match(N60(CTG.list), CTG.list)
  ctgStats[nrow(ctgStats),]$CtgLen.N70 <- N70(CTG.list);ctgStats[nrow(ctgStats),]$nCtg.N70 <- match(N70(CTG.list), CTG.list)
  ctgStats[nrow(ctgStats),]$CtgLen.N80 <- N80(CTG.list);ctgStats[nrow(ctgStats),]$nCtg.N80 <- match(N80(CTG.list), CTG.list)
  
  ancestor <- cbind.all(ancestor,CTG.list[1:nctg])
  
  close(con)
  
} # end for trn

colnames(ancestor) <- paste0("ancestor",trn.vector)
## csv file containing first nctg ancestral contigs in each ancestor: contigs_W*.csv
write.csv(ancestor, file=file.path(results.path, "ancestorStats", paste0("contigs_W",ws,"(",gf1,",",gf2,").csv")), row.names=FALSE)
## csv file containing contig statistics: ctgStats.csv
write.csv(ctgStats, file=file.path(results.path, "ancestorStats", "ctgStats.csv"), row.names=FALSE)


message("\n~~~~~Rscript finished summarizing contig statistics for each ancestor \n")



