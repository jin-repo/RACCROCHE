
###################################################
### This program take ancestral genomes (sets of contigs) and labeled ortholog gene families as input
### It parses gene labels in contigs and join them with other features of the same labeled gene 
### in all descendant genomes defined in GenomeIDs.txt
###################################################
### input: 1. genome IDs and ancestor tree nodes defined in Genomes.txt 
###        2. ortholog genes labeled with gene family IDS in ./GeneFamily/cleanedGeneFamilies.txt
###        3. ancestral genomes (sets of contigs) ./Contig*/ContigW*TreeNode*_*_*.txt
### output: contig gene feature files for each descendent genome in ./data/contigGFF/ContigGFF_gid_W*TreeNode*_*_*.txt

source("./module3/config.R")

## read in gene family database
# geneFamilyDB <- read.delim(file.path(GF.path,"cleanedGeneFamilies.txt", header=FALSE)
geneFamilyDB <- read.csv(file.path(GF.path,"CleanedGF.csv"), header=FALSE)

geneFamilyDB <- geneFamilyDB[!duplicated(geneFamilyDB),]
colnames(geneFamilyDB) <- c("geneName",	"geneFamilyID",	"chr",	"start",	"end",	"strand",	"no1",	"no2",	"genomeID",	"no3")


for (trn in trn.vector){
  
  # input contigs (check if the ancestral genome file exists. if not, break)
  contig.fname <- list.files(contig.path, pattern=paste0("ContigW",ws,"TreeNode",trn,"_",gf1,"_",gf2,".txt"))
  if (length(contig.fname)==0) {break}
  
  # check if the ContigGFF file exists; if already exists, break
  ContigGFF.fname <- list.files(contigGFF.path, pattern=paste0("*W",ws,"TreeNode",trn,"_",gf1,"_",gf2,".txt"))
  if(length(ContigGFF.fname)!=0) {break} # if file was already created, break
  
  
  print(contig.fname)
  
  
  ## read in contig file line by line
  con <- file(file.path(contig.path,contig.fname), "r")
  cat(paste0("\n---WS=",ws,"\tTreeNode=",trn,"\tgf1=",gf1,"\tgf2=",gf2))
  
  count <- nctg
  while ( count > 0 ) {
    count <- count - 1
    cat("\nCount ", count)
    
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    
    ## read in and parse the current contig: contigN
    contigN <- as.numeric(strsplit(line, " ")[[1]][2])
    line = trimws(readLines(con, n = 1))
    # print(line)
    
    # the original contig read in from file
    contig_origin = abs(as.numeric(strsplit(line, " +")[[1]]))
    
    if (length(contig_origin) >= ctgLen){
      cat ("\n",paste0("The length of contig", contigN, ": ", length(contig_origin)))
      
      ## loop to iterate through all genomes
      for(gid in gid.vector) {
        cat("\n... Genome ",gid, " ...")
        
        ## take intersect: remove genes families in the contig that are not in this genome
        contig <- contig_origin
        isIn <- contig %in% unique(geneFamilyDB[geneFamilyDB$genomeID==gid,]$geneFamilyID)
        if(length(which(isIn == FALSE))>0) contig <- contig[ - which(isIn == FALSE)]
        
        contig <- as.data.frame(contig)
        colnames(contig) <- c("geneFamilyID")
        
        contigGenes <- as.data.table(merge(contig, geneFamilyDB[geneFamilyDB$genomeID==gid,], by.x = "geneFamilyID", by.y = "geneFamilyID"))
        contigGenes[, mid:=(start+end)/2] ## add a mid postion column
        
        ## generate meta data for contig genes in the current genome
        ## columns: chr, geneFamilyID, pos, contig, start, end
        plotDF <- data.frame( chr=character(), geneFamilyID=numeric(), pos=numeric(), contig=numeric(), start=numeric(), end=numeric(), geneName=character(), stringsAsFactors = FALSE)
        
        for (geneID in as.list(contig)[[1]]) {
          numCopies <- nrow(contigGenes[contigGenes$geneFamilyID==geneID,])
          
          if(numCopies == 1) {
            ## only one copy of the gene family
            plotDF <- rbind( plotDF, data.frame(chr=contigGenes[contigGenes$geneFamilyID==geneID,chr], geneFamilyID=geneID, pos=contigGenes[contigGenes$geneFamilyID==geneID,mid], 
                                                contig=contigN, start=contigGenes[contigGenes$geneFamilyID==geneID,start], end=contigGenes[contigGenes$geneFamilyID==geneID,end], geneName=contigGenes[contigGenes$geneFamilyID==geneID,geneName]) )
          }  else {
            ## multiple copies of the gene family
            for (i in 1:numCopies) {
              plotDF <- rbind( plotDF, data.frame(chr=contigGenes[contigGenes$geneFamilyID==geneID,chr][i], geneFamilyID=geneID, pos=contigGenes[contigGenes$geneFamilyID==geneID,mid][i], 
                                                  contig=contigN, start=contigGenes[contigGenes$geneFamilyID==geneID,start][i], end=contigGenes[contigGenes$geneFamilyID==geneID,end][i], geneName=contigGenes[contigGenes$geneFamilyID==geneID,geneName][i]))
            }
          }
        }
        
        ## write most common ancestor contigs in this genome into file
        ContigGFF.fname <- file.path(contigGFF.path, paste0("ContigGFF_",gid,"_W",ws,"TreeNode",trn,"_",gf1,"_",gf2,".txt"))
        write.table(plotDF, file = ContigGFF.fname, append = TRUE, sep = "\t", col.names = F, row.names = F)
        
      } ## end of genomes
      
    } else {break} ## skip reading contigs in file, if the length of contig is less than the threshold ctgLen
  }
  
  close(con)
  
}  ## end of trn

message("\n~~~~~Rscript finished extracting gene family features")
