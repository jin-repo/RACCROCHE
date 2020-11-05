
##### read in karyotype chromosome
readIn.karyotype <- function(karyotype.path, gID){
  ## read in karyotype chromosome
  karyotype.fname <- list.files(karyotype.path, pattern=paste0("*_",gID,"_*"))
  print(karyotype.fname)
  if (length(karyotype.fname)==0) {next}
  karyotype <- read.delim(file.path(karyotype.path, karyotype.fname), header=TRUE)
  
  return(karyotype)
}

##### read in gene features in contig
readIn.contigGFF <- function(gID, ws, trn, gf1, gf2, Nctg, contigGFF.path){
  
    contigGFF.fname <- list.files(contigGFF.path, pattern=paste0("*",gID,"_W",ws,"TreeNode",trn,"_",gf1,"_",gf2,".txt"))
    print(contigGFF.fname)
    if (length(contigGFF.fname)==0) {return ()}
    
    contigGFF <- read.delim(file.path(contigGFF.path, contigGFF.fname), header=FALSE, row.names=NULL, stringsAsFactors = FALSE)
    colnames(contigGFF) <- c("chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "geneName")
    
    ## clean up data: remove invalid chromosome numbers
    if(length(which(contigGFF$chr>max(karyotype$chr))) >0) {
      contigGFF <- contigGFF[ - which(contigGFF$chr>max(karyotype$chr)) , ]
    }
    # if(length(which(contigGFF$chr==0 )) >0) {  ## 33827_Chenopodium chromosomes start from 0
    #   contigGFF <- contigGFF[ - which(contigGFF$chr==0) , ]
    # }
    ## remove invalid contig number
    if(length(which(contigGFF$contig>=Nctg)) > 0) { contigGFF <- contigGFF [ - which(contigGFF$contig>=Nctg) , ]}

    
    ## process data and calculate distance between genes
    contigGFF$contig <- as.factor(contigGFF$contig)
    ## sort genes by chromosome number, then by their positions within chromosome
    contigGFF <- as.data.table(contigGFF)[order(contigGFF$chr,contigGFF$pos),]
    
    # Create column distance by subtracting column start by the value from the previous row of column end
    # this will result in the first gene in a chromosome having negative distance
    contigGFF[, distance := as.numeric(start - shift(end, 1L, type="lag"))]
    # change negative distance to NA, then replace all NAs with 0
    # a gene with distance 0 is the first gene in a chromosome.
    contigGFF<-contigGFF[distance < 0, distance := NA]
    contigGFF[is.na(contigGFF)] <- 0
 
    for(c in unique(contigGFF$chr)){
      contigGFF[which(contigGFF$chr == c), geneOrder := 1:nrow(contigGFF[which(contigGFF$chr == c),])]
    }
      
    return(contigGFF)   
    ## 9 cloumns in contig GFF: "chr",	"geneFamilyID",	"contig", "start", "end", "geneName", "distance", "geneOrder"
}


## Generate block data frame by merging only adjacent genes
## The first step initializes a syntenic block by merging two adjacent genes given a distance threshold DIS: merge two genes, g_1 and g_2, forming one ancestral syntenic block on G_i if g_1 and g_2 satisfy the following conditions:
## 1. g_1 and g_2 locate the same chromosome of G_i;
## 2. g_1 and g_2 are adjacent to each other; in other words, there could be a non-coding region but no other gene(s) between g_1 and g_2;
## 3. The distance between g_1 and g_2 must be less than or equal to the distance threshold DIS (i.e. DIS=1 MB)
## The second step extends the above identified ancestral syntenic block by merging flanking gene(s) into the block if the gene(s) satisfies the above three conditions. It stops extending the block if no flanking gene could be merged into the block.

generate.blockDF <- function(contigGFF, DIS.threshold) {
  ## merge genes in contigGFF that are within a DIS.threshold distance in extant genome into blocks
  ## columns: chr, start, end, contig --> make sure they are all numeric
  blockDF <- data.frame( chr=numeric(),  start=numeric(), end=numeric(), contig=numeric(), stringsAsFactors = FALSE) 
  
  ## asign block numbers
  # block.no <- 1
  # block.vector <- c(block.no)
  ## 8 cloumns in contig GFF: "chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "geneName", "distance", "geneOrder", "geneOrder"
  blockDF <- rbind( blockDF, contigGFF[1, c("chr","start","end","contig")] )
  
  for (r in 2:nrow(contigGFF)) {
    if (contigGFF[r]$chr != contigGFF[r-1]$chr) { 
      ## the start of a new chromosome
      # block.no <- 1;  
      # block.vector <- c(block.vector, block.no); 
      blockDF <- rbind( blockDF, contigGFF[r, c("chr","start","end","contig")] )
      next;
    }
    
    if (contigGFF[r]$distance <= DIS.threshold && contigGFF[r]$contig == contigGFF[r-1]$contig) { ## ???? remove DIS.threshold?
      ## when this gene and the previous gene blong to the same block 
      ## their distance is less than the threshold,
      # block.vector <- c(block.vector, block.no)
      blockDF[nrow(blockDF),]$end <- contigGFF[r]$end
    }  
    else {
      # block.no <- block.no + 1
      # block.vector <- c(block.vector, block.no)
      blockDF <- rbind( blockDF, contigGFF[r, c("chr","start","end","contig")] )
    }
  }
  
  return(blockDF)
}

## Generate block data frame by allowing a window size to merge adjacent genes
## The first step initializes a syntenic block by merging two adjacent genes given a distance threshold DIS: merge two genes, g_1 and g_2, forming one ancestral syntenic block on G_i if g_1 and g_2 satisfy the following conditions:
## 1. g_1 and g_2 locate the same chromosome of G_i;
## 2. g_1 and g_2 are adjacent to each other with in WS; in other words, there could be less than WS gene(s) between g_1 and g_2;
## 3. The distance between every pair of adjacnet genes between g_1 and g_2 must be less than or equal to the distance threshold DIS (i.e. DIS=1 MB)
## The second step extends the above identified ancestral syntenic block by merging flanking gene(s) into the block if the gene(s) satisfies the above three conditions. It stops extending the block if no flanking gene could be merged into the block.

generate.blockDF.2 <- function(contigGFF, DIS.threshold, WS) {
  
  ## 9 cloumns in contig GFF now: "chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "geneName", "distance", "geneOrder"
  
  ## merge genes in contigGFF that are within a DIS.threshold distance in extant genome into blocks
  ## columns: chr, start, end, contig --> make sure they are all numeric
  blockDF <- data.frame( chr=numeric(),  start=numeric(), end=numeric(), contig=numeric(), stringsAsFactors = FALSE) 
  
    
    for (current.ctg in unique(as.numeric(as.character(contigGFF$contig)))){
      ## loop through every contig
      # current.ctg <- 238
      # cat("\ncurrent.ctg=",current.ctg)
      current.ctg.gff <- contigGFF[which(contig==current.ctg),]
      current.ctg.gff[, distanceInCtg := as.numeric(start - shift(end, 1L, type="lag"))]
      # change alternating chr to NA, then replace all NAs with 0
      # a gene with distance 0 is the first gene in a chromosome.
      current.ctg.gff<-current.ctg.gff[as.numeric(chr - shift(chr, 1L, type="lag")) > 0, distanceInCtg := NA]
      current.ctg.gff[is.na(current.ctg.gff)] <- 0
      ## 10 cloumns in contig GFF: "chr",	"geneFamilyID",	"pos",	"contig", "start", "end", "geneName", "distance", "geneOrder, "distanceInCtg"
      
      ## start the first block from the first gene
      blockDF <- rbind( blockDF, current.ctg.gff[1, c("chr","start","end","contig")] )
      if(nrow(current.ctg.gff)<2) {next; }
      for (r in 2:nrow(current.ctg.gff)) {
        ## the start of a new chromosome, start a new block
        if (current.ctg.gff[r]$chr != current.ctg.gff[r-1]$chr) { 
          # block.no <- 1;  
          # block.vector <- c(block.vector, block.no); 
          blockDF <- rbind( blockDF, current.ctg.gff[r, c("chr","start","end","contig")] )
          next;
        }
  
        # if (current.ctg.gff[r]$distanceInCtg <= DIS.threshold && current.ctg.gff[r]$geneOrder < WS) { ## consider both distance and window size
        
        if ((current.ctg.gff[r]$geneOrder - current.ctg.gff[r-1]$geneOrder)  < WS) { ## only consider window size
          ## when this gene and the previous gene blong to the same block 
          ## their distance is less than the threshold,
          # block.vector <- c(block.vector, block.no)
          blockDF[nrow(blockDF),]$end <- current.ctg.gff[r]$end
        }  
        else {
          # block.no <- block.no + 1
          # block.vector <- c(block.vector, block.no)
          blockDF <- rbind( blockDF, current.ctg.gff[r, c("chr","start","end","contig")] )
        }
      }
      
    } ## end of loop through contigs
  
  blockDF<-blockDF[order(blockDF$chr,blockDF$start),]
  
  return(blockDF)
}



#### merge together blocks within distance threshold that are from the same ancestral chromosome cluster into the same block
#### blockDF ("chr", "start", "end", "contig", "ancestralChr")
mergeBlockDF <- function (blockDF, DIS.threshold) {
  blockDF<-blockDF[order(blockDF$chr,blockDF$start),]  # sort 
  
  ## columns: chr, start, end, ancestralChr --> make sure they are all numeric
  mergedDF <- data.frame( chr=numeric(),  start=numeric(), end=numeric(), ancestralChr=numeric(), stringsAsFactors = FALSE) 
  
  
  mergedDF <- rbind( mergedDF, blockDF[1, c("chr","start","end","ancestralChr")] )
  for(r in 2:nrow(blockDF)) {
    
    if (blockDF[r]$chr != blockDF[r-1]$chr) { 
      ## the start of a new chromosome
      mergedDF <- rbind( mergedDF, blockDF[r, c("chr","start","end","ancestralChr")] )
      next;
    }
    
    if ((blockDF[r]$start-blockDF[r-1]$end) <= DIS.threshold && (blockDF[r]$ancestralChr == blockDF[r-1]$ancestralChr)) { 
      ## when this block and the previous block blong to the same ancestral chromosome
      ## their distance is less than the threshold, merge them together
      mergedDF[nrow(mergedDF),]$end <- blockDF[r]$end
    }  
    else {
      # block.no <- block.no + 1
      # block.vector <- c(block.vector, block.no)
      mergedDF <- rbind( mergedDF, blockDF[r, c("chr","start","end","ancestralChr")] )
    } 
    
  }
  
  mergedDF <- mergedDF[order(mergedDF$chr,mergedDF$start),]
  
  return(mergedDF)
}



plotMyHeatMap <- function(data, title) {
  
  heatmap.2 (data,
             main = title, # heat map title
             lhei=c(3, 10), lwid=c(3,10), 
             cexRow=1,cexCol=1,margins=c(12,8),
             dendrogram="none",     # only draw a row dendrogram
             Rowv=FALSE, Colv=FALSE, 
             srtCol=0,   adjCol = c(0.5,1),
             col = brewer.pal(9, "Reds"), trace = "none",
             cellnote=round(data, 2),
             notecex=1.0,
             notecol="gray",
             na.color=par("bg"))
  
}
