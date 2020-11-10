#!/usr/bin/env Rscript

###################################################
### This program sorts ancestral chromosomes, 
### based on the relative positions of contigs matched to extant genomes
###################################################
### input:  1. genome IDs and ancestor tree nodes defined in Genomes.txt 
###         2. contig gene feature files for each descendent genome in ./data/contigGFF/ContigGFF_gid_W*TreeNode*_*_*.txt
###         3. clustering results in ./data/clustering/cluster_trn+.txt
### output: 1. positional matrix for each chromosome in each ancestor: results/ordering/ancestor*_chromosomes_ordered.csv

source("./module3/config.R")
source("./module3/helper.R")


####################################################################################################################
####################  Cluster contigs based on their coocurrence on extant chromosomes ######################################
############


for(trn in trn.vector){
  
  message("\n\n\nSSSSStart sorting chromosomes for ancestor ", trn, "\n\n")
  
  ## initialize a positional matrix for each ancestor
  positionalMatrix.ancestor <- matrix(0,nrow=K, ncol=K, dimnames=list(paste0("chr",1:K), paste0("chr",1:K)))
  
  ## read in ancestral chromosomes from the clustering results
  clusterVector <- scan(file.path(results.path, "clustering", paste0("cluster_trn",trn,".txt")))
  clusters <- cbind(0:(nctg-1), as.data.frame(clusterVector))
  colnames(clusters)<-c("contig","ancestralChr")
  
  
  
  ###########################################
  ### ordering analysis for each ancestral chromosome
  ###########################################
  
  ## local sorting based on extant genomes connected to the ancestor
  ## comment this gid.vector if perform global sorting based on ALL extant genomes
  gid.vector <- genomeCoGeID[genomeCoGeID$ancestor == trn, ]$genomeID 
  
  ## count positional ordering data in all extant genomes
  for(gID in gid.vector) {
    
    ######### Step 1: match synteny blocks
    
    ### read in extant genome karyotype: chr, size
    karyotype <- readIn.karyotype(karyotype.path, gID)
    
    ## read in contigGFF. Each row is one gene from ancestral contigg, sorted by extant chr #, then positions in extant chr
    # Colnames: chr of extant genome, geneFamilyID, pos on extant chr, ancestral contig#, 
    # start position on extant chr, end position on extant chr, distance between two genes
    contigGFF <- readIn.contigGFF(gID, ws, trn, gf1, gf2, nctg, contigGFF.path)
    
    
    ## generate synteny block data from contigGFF
    ## 7 cloumns in contigGFF: "chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "distance"
    ## blockDF columns: chr, start, end, contig --> make sure they are all numeric
    ### merge genes in contigGFF that are within a DIS.threshold distance in extant genome into blocks
    blockDF <- generate.blockDF.2(contigGFF, DIS.threshold, ws)
    
    
    
    ## add one column: ancestralChr from corresponding cl$cluster
    blockDF[,"contig"] <- as.numeric(as.character(blockDF$contig)) ## unfactorize column contig
    blockDF <- merge(blockDF, clusters)
    blockDF <- blockDF[order(blockDF$chr,blockDF$start),]
    blockDF <- blockDF[ , c("chr", "start", "end", "contig", "ancestralChr")]
    
    
    ######### Step 2: count relative positional frequencies

    # c2 is the chromosome of the current extant genome
    for (c2 in sort(unique(blockDF$chr))){ ## gather contig positional relationship within each chromosome of extant genome
      
      blockDF.chr <- blockDF[blockDF$chr==c2,] ## blocks of current chromosome of extant genome from the current ancestral chromosome
      blockDF.chr$idx <- seq.int(nrow(blockDF.chr)) ## index blocks by their positions
      
      aChr.ctgs <- blockDF.chr$contig
      
      ## positional relationship: if any of aCtg appears before any of bCtg (aCtg.idx < bCtg.idx), then positionalMatrix.chr[aCtg,bCtg] += 1
      for (aCtg in aChr.ctgs){
        # aCtg=0
        aChr <- clusters[clusters$contig==aCtg,]$ancestralChr
        minIdx <- min(blockDF.chr[blockDF.chr$contig==aCtg,]$idx)
        
        for(bCtg in aChr.ctgs[aChr.ctgs!=aCtg]){
          if (!is.null(dim(blockDF.chr[blockDF.chr$contig==bCtg,]))) {
            if (max(blockDF.chr[blockDF.chr$contig==bCtg,]$idx) > minIdx){
              
              bChr <- clusters[clusters$contig==bCtg,]$ancestralChr
              
              positionalMatrix.ancestor[paste0("chr",aChr), paste0("chr",bChr)] <- 1 + positionalMatrix.ancestor[paste0("chr",aChr), paste0("chr",bChr)]
              
            }
          }
        } ## end of bCtg
        
      } ## end of aCtg
      
    } ## end of c2: extant chromosomes of the current genome
    
  } ## loop through each genome
  
  #write.csv(positionalMatrix.ancestor, file=file.path(results.path, "ordering", paste0("posMat_ancestor",trn,".csv")), row.names=TRUE)
  
  fileConn<-file.path(results.path, "ordering", paste0("posMat_ancestor",trn,".txt"))
  write.table(K, fileConn, row.names=FALSE, col.names=FALSE)
  write.table(positionalMatrix.ancestor, file=fileConn, append=TRUE, row.names=FALSE, col.names=FALSE, sep = "\t")
  
  TScmd <- paste0("chmod 755 module3/TSforLOP")
  system(TScmd, intern = TRUE)
  cmd <- paste0("module3/TSforLOP ", fileConn, " 100")
  permOrder <- tail(system(cmd, intern = TRUE), K)
  RMcmd <- paste0("rm ", fileConn)
  system(RMcmd, intern = TRUE)
  
  
  sortedChr <- as.data.frame(1:K)
  sortedChr$permOrder <- as.numeric(as.character(permOrder))
  sortedChr <- sortedChr [ order( sortedChr$permOrder), ]
  colnames(sortedChr) <- c("chromosome", "order")
  
  file.ancestor <- file.path(results.path, "ordering", paste0("ancestor",trn,"_chromosomes_ordered.csv"))
  write.csv(sortedChr, file.ancestor, row.names=FALSE)  ## contigs after ordering
  
  
} ## loop through each ancestor tree node

message("\n~~~~~Rscript finished collecting relative positional data for ancestral chromosomes ~~~~~~ \n")