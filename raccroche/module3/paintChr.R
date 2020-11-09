#!/usr/bin/env Rscript

###################################################
### This program matches and paints ancestral chromosomes to extant genomes
### It also summarizes measures for choppiness
###################################################
### input:  1. genome IDs and ancestor tree nodes defined in Genomes.txt 
###         2. extant genome karyotypes defined in "karyotype" folder: karyotype_genomeID_genomeName.txt, 
###             where genomeID and genomeName match the info in Genomes.txt 
###         3. contig gene feature files for each descendent genome in ./data/contigGFF/ContigGFF_gid_W*TreeNode*_*_*.txt
###         4. clustering results in ./data/clustering/
### output: 1. painted chromosomes: results/paintedChrs/ancestor[trn]-[genomeName].pdf
###         2. choppinness : results/ancestorStats/choppiness_sum.csv

source("./module3/config.R")
source("./module3/helper.R")

## 7 ancestral chromosomes
myClr <- c("green", "red", "blue", "purple", "yellow", "cyan", "orange" )  


#######################
### paint extant genomes with ancestral contigs at each ancestor tree node
### then perform choppiness analysis

choppiness <- data.frame(genome=character(), ancestor=character(), chr=character(), t=numeric(), r=numeric(), x=numeric())

for(trn in trn.vector){
  
  for(gID in gid.vector) {
    
    gName <- genomeCoGeID[genomeCoGeID$genomeID == gID,]$genomeName
    myTrn <- genomeCoGeID[genomeCoGeID$genomeID == gID,]$ancestor
    

    ### read in extant genome karyotype: chr, size
    karyotype <- readIn.karyotype(karyotype.path, gID)
    chrMaxLen <- max(karyotype$size)+100
    
    ## read in contigGFF. Each row is one gene from ancestral contigg, sorted by extant chr #, then positions in extant chr
    # Colnames: chr of extant genome, geneFamilyID, pos on extant chr, ancestral contig#, 
    # start position on extant chr, end position on extant chr, distance between two genes
    contigGFF <- readIn.contigGFF(gID, ws, trn, gf1, gf2, nctg, contigGFF.path)
    
    
    ## generate plotting data from contigGFF !!!
    ## 7 cloumns in contigGFF: "chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "distance"
    ## blockDF columns: chr, start, end, contig --> make sure they are all numeric
    ### merge genes in contigGFF that are within a DIS.threshold distance in extant genome into blocks
    blockDF <- generate.blockDF.2(contigGFF, DIS.threshold, ws)
    
    
    ## read in ancestral chromosomes from the clustering results
    clusterVector <- scan(file.path(results.path, "clustering", paste0("cluster_trn",trn,".txt")))
    clusters <- cbind(0:(nctg-1), as.data.frame(clusterVector))
    colnames(clusters)<-c("contig","ancestralChr")
    
    
    
    ## add one column: ancestralChr from corresponding cl$cluster
    blockDF[,"contig"] <- as.numeric(as.character(blockDF$contig)) ## unfactorize column contig
    blockDF <- merge(blockDF, clusters)
    blockDF <- blockDF[order(blockDF$chr,blockDF$start),]
    blockDF <- blockDF[ , c("chr", "start", "end", "contig", "ancestralChr")]
    
    
    # ### export synteny blocks before merging
    # ### this will be used to order contigs within each ancestral chromosome using LOP
    # write.csv(blockDF, file=file.path(results.path, "clustering", "AncestralSyntenyBlocks.csv"), row.names=FALSE)
    
    ##############################################
    ### generate plots of painted extant genomes
    ##############################################
    
    ## merge adjancent blocks if their distance is within DIS.threshold (i.e. 1 MB)
    ## only choose blocks longer than blockLEN threshold to merge
    mergedDF <- mergeBlockDF(blockDF[(end-start) > blockLEN.threshold,], DIS.threshold)
    mergedDF <- as.data.table(mergedDF)
    mergedDF[, len := end - start ]
    
    if(trn == myTrn){
      ## output plot file
      pdf(file = file.path(results.path, "paintedChrs", paste0("ancestor", myTrn, "-", gName, ".pdf")),paper = "a4r", width = 0, height = 0)
      
      ## magic number to draw rectangle
      offset = ifelse (max(karyotype$chr)<=7, 0.05, ifelse (max(karyotype$chr)<=11, 0.07, ifelse (max(karyotype$chr)<=16, 0.11, ifelse (max(karyotype$chr)<=25,0.18,0.3)))) 
    
      #########################
      p <- ggplot() +
        geom_segment(data = karyotype,
                     aes(y = chr, yend = chr, x = 0, xend = size),
                     lineend = "round", color = "lightgrey", size = 6) +
        scale_x_continuous("Length (Mbp)", breaks = seq(1,chrMaxLen,by=5000000), labels = Ms2, limits=c(0,chrMaxLen))+
        scale_y_continuous("Chromosome", breaks = karyotype$chr, labels = karyotype$chr ) +
        
        geom_rect(data=mergedDF, mapping=aes(xmin=start, xmax=end, ymin=as.integer(chr)-offset, 
                                             ymax=as.integer(chr)+offset, alpha=0.5), 
                  fill=myClr[mergedDF$ancestralChr], show.legend = FALSE,  alpha=0.5)+
        ##### Show ancestral chromosome number 
        #geom_text(data=mergedDF, aes(x=start+(end-start)/2, y=chr, label=ancestralChr), size=2) +
        coord_flip()  +
        theme(plot.title = element_text(size=15, face="bold"), 
              text = element_text(size=15),
              panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
              panel.background = element_blank(), 
              axis.line = element_line(colour = "black", size = .5, linetype = "solid")) # enable axis lines #, axis.ticks = element_blank() )
      
      print(p)
      
      dev.off()
    }
    
    #######################
    ## choppiness analysis
    #######################
    for(c in karyotype$chr){
      df.chr <- mergedDF[mergedDF$chr==c,]
      
      ## T_i = the number of different colours on each chromosome - 1
      t <- length(unique(df.chr$ancestralChr)) - 1
      
      ## R_i = the number of single-colour regions on each chromosome
      r <- length(df.chr$ancestralChr) 
      
      ## the number of stripes less than a certain threshold size 
      x <- nrow(df.chr[df.chr$len <= 2*blockLEN.threshold,])
      
      choppiness <- rbind(choppiness, data.frame(genome=gID, ancestor=trn, 
                                                 chr=as.numeric(as.character(c)), 
                                                 t=as.numeric(as.character(t)), 
                                                 r=as.numeric(as.character(r)), 
                                                 x=as.numeric(as.character(x))))
      
    } ## end of looping through chromosomes
  } ## end of looping through all genome ids
} ## end of looping through tree nodes

choppiness.sum <- as.data.table(aggregate(choppiness[,4:6], by=list(genomeID = choppiness$genome, Ancestor.map = choppiness$ancestor), FUN = "sum"))
choppiness.sum[, "R-T" := r-t]
choppiness.sum[, "R-X" := r-x]

choppiness.sum <- merge(genomeCoGeID[,1:2], choppiness.sum, by = "genomeID")
setorder(choppiness.sum, genomeID, Ancestor.map)

###################################
## output choppiness stats to file
## details for debuging
# write.csv(choppiness, file=file.path(results.path, "ancestorStats", "choppiness_raw.csv"), row.names=TRUE) 
## summarized results
write.csv(choppiness.sum, file=file.path(results.path, "ancestorStats", "choppiness_sum.csv"), row.names=TRUE)  

message("\n~~~~~Rscript finished paiting extant chromosomes \n")
