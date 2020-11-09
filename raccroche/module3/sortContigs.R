#!/usr/bin/env Rscript

###################################################
### This program sorts the contigs within each ancestral chromosome, 
### based on the relative positions of contigs matched to extant genomes
###################################################
### input:  1. genome IDs and ancestor tree nodes defined in Genomes.txt 
###         2. contig gene feature files for each descendent genome in ./data/contigGFF/ContigGFF_gid_W*TreeNode*_*_*.txt
###         3. clustering results in ./data/clustering/cluster_trn+.txt
### output: 1. positional matrix for each chromosome in each ancestor: results/ordering/posMat_ancestor*Chr*.csv


source("./module3/config.R")
source("./module3/helper.R")


####################################################################################################################
####################  Cluster contigs based on their coocurrence on extant chromosomes ######################################
############


for(trn in trn.vector){
  
  message("\nSSSStart sorting contigs for ancestor ", trn, "\n\n")
  
   
  ###########################################
  ### ordering analysis for each ancestral chromosome
  ###########################################
  
  ## read in ancestral chromosomes from the clustering results
  clusterVector <- scan(file.path(results.path, "clustering", paste0("cluster_trn",trn,".txt")))
  clusters <- cbind(0:(nctg-1), as.data.frame(clusterVector))
  colnames(clusters)<-c("contig","ancestralChr")
  
  
  sortedCtg.ancestor <- data.frame( contig=character(), order=numeric(), chromosome=numeric(), stringsAsFactors = FALSE)
  
  
  ## collect positional data for each ancestral chromosome
  ## c1 is the ancestral chromosome of the current ancestor
  for (c1 in 1:K){ 

    aChr.ctgs <- clusters[clusters$ancestralChr==c1,]$contig ## all contigs in the current ancestral chromosome c1
    
    ## initialize a positional matrix for each ancestral chromosome of each ancestor
    ## row&col names are contigs in this ancestral chromosome
    matSize <- length(aChr.ctgs) ## number of contigs in the ancestral chromosome
    positionalMatrix.chr <- matrix(0,nrow=matSize, ncol=matSize, dimnames=list(paste0("ctg",aChr.ctgs), paste0("ctg",aChr.ctgs)))
    
    ## count positional ordering data in all extant genomes
    for(gID in gid.vector) {
      
      ######### Step 1: match synteny blocks
      
      ### read in extant genome karyotype: chr, size
      karyotype <- readIn.karyotype(karyotype.path, gID)
      
      ## read in contigGFF. Each row is one gene from ancestral contigg, sorted by extant chr #, then positions in extant chr
      # Colnames: chr of extant genome, geneFamilyID, pos on extant chr, ancestral contig#, 
      # start position on extant chr, end position on extant chr, distance between two genes
      contigGFF <- readIn.contigGFF(gID, ws, trn, gf1, gf2, nctg, contigGFF.path)
      
      ## summarize contig lengths in bp
      # contig.maxLen <- as.data.table(contigGFF [, c(4, 2, 5, 6)])
      # contig.maxLen [, "lenBP" := end-start]
      # contig.maxLen <- contig.maxLen[order(contig.maxLen$contig, contig.maxLen$geneFamilyID),]
      #   
      # contig.GF <- aggregate(contig.maxLen[,5], by = list(contig.maxLen$contig, contig.maxLen$geneFamilyID), FUN="max")
      # colnames(contig.GF) <- c("contig", "GF", "maxLen")
      # ancestral.contig.length <- aggregate(contig.GF[,3], by=list(contig.GF$contig), FUN="sum")
      # colnames(ancestral.contig.length) <- c("contig", "LenBP")
      
      
      
      
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
      
      blockDF.ac <- blockDF[blockDF$ancestralChr==c1,]         ## all blocks of current extant genome from the current ancestral chromosome
      
      # positionalMatrix.chr <- matrix(0,nrow=length(aChr.ctgs), ncol=length(aChr.ctgs), dimnames=list(paste0("ctg",aChr.ctgs), paste0("ctg",aChr.ctgs)))
      
      # c2 is the chromosome of the current extant genome
      for (c2 in sort(unique(blockDF.ac$chr))){ ## gather contig positional relationship within each chromosome of extant genome
        
        blockDF.ac.chr <- blockDF.ac[blockDF.ac$chr==c2,] ## blocks of current chromosome of extant genome from the current ancestral chromosome
        blockDF.ac.chr$idx <- seq.int(nrow(blockDF.ac.chr)) ## index blocks by their positions
        
        
        ## positional relationship: if any of aCtg appears before any of bCtg (aCtg.idx < bCtg.idx), then positionalMatrix.chr[aCtg,bCtg] += 1
        for (aCtg in aChr.ctgs){
        
          if ( !is.element(aCtg, blockDF.ac.chr$contig)) {next}
          
          minIdx <- min(blockDF.ac.chr[blockDF.ac.chr$contig==aCtg,]$idx)
          
          for(bCtg in aChr.ctgs[aChr.ctgs!=aCtg]){
            if (!is.null(dim(blockDF.ac.chr[blockDF.ac.chr$contig==bCtg,]))) {
              if (max(blockDF.ac.chr[blockDF.ac.chr$contig==bCtg,]$idx) > minIdx){
                
                  positionalMatrix.chr[paste0("ctg",aCtg), paste0("ctg",bCtg)] <- 1 + positionalMatrix.chr[paste0("ctg",aCtg), paste0("ctg",bCtg)]
              
                }
            }
          } ## end of bCtg
          
        } ## end of aCtg
        
      } ## end of c2: extant chromosomes of the current genome
      
    } ## loop through each genome
    
    
    
    
    ### export positional matrices
    # outputFile.1 <- file.path(results.path, "ordering", paste0("posMat_ancestor",trn,"Chr",c1,".csv"))
    # write.csv(positionalMatrix.chr, file=outputFile.1, row.names=TRUE)
    
    fileConn<-file.path(results.path, "ordering", paste0("posMat_ancestor",trn,"Chr",c1,".txt"))
    write.table(matSize, fileConn, row.names=FALSE, col.names=FALSE)
    write.table(positionalMatrix.chr, file=fileConn, append=TRUE, row.names=FALSE, col.names=FALSE, sep = "\t")
    
    TScmd <- paste0("chmod 755 module3/TSforLOP")
    system(TScmd, intern = TRUE)
    cmd <- paste0("module3/TSforLOP ", fileConn, " 100")
    permOrder <- tail(system(cmd, intern = TRUE), matSize)
    RMcmd <- paste0("rm ../project-monocots/results/ordering/posMat_ancestor",trn,"Chr",c1,".txt")
    system(RMcmd, intern = TRUE)
    
    
    sortedCtg.chr <- as.data.frame(aChr.ctgs)
    sortedCtg.chr$permOrder <- as.numeric(as.character(permOrder))
    sortedCtg.chr$chromosome <- c1
    sortedCtg.chr <- sortedCtg.chr [ order( sortedCtg.chr$permOrder), ]
    colnames(sortedCtg.chr) <- c("contig", "order", "chromosome")
    
    # file.contig <- file.path(results.path, "ordering", paste0("ancestor",trn,"Chr",c1,"_ordered.csv"))
    # write.csv(sortedCtg.chr, file.contig, row.names=FALSE)  ## contigs after ordering
    
    sortedCtg.ancestor <- rbind(sortedCtg.ancestor, sortedCtg.chr)
    
    message("\nFFFFinished sorting ancestral chromosome ", c1, " for ancestor ", trn, "\n\n")
    
  } ## end of c1: ancestral chromosomes
  
  
  
  file.ancestor <- file.path(results.path, "ordering", paste0("ancestor",trn,"_ordered.csv"))
  write.csv(sortedCtg.ancestor, file.ancestor, row.names=FALSE)  ## contigs after ordering
  
  
} ## loop through each ancestor tree node
  
message("\n~~~~~Rscript finished collecting relative positional data for contigs in chromosomes ~~~~~~ \n")
    
   
