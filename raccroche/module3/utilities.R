
## helper function to check if specific packagens have been installed
## if not, install them
check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    options(install.packages.compile.from.source = "always")
    install.packages(new.pkg, dependencies = TRUE, repos = "http://cran.us.r-project.org")
  }
  sapply(pkg, require, character.only = TRUE)
}


### -----------------------------------------------------------------
### helper function to calculate N50 
NXX <- function(lengths, XX=50){
  # if(file_ext(filepath) == "2bit"){
  #   lengths <- seqlengths(TwoBitFile(filepath))
  # }else if(file_ext(filepath) %in% c("fa", "fasta")){
  #   lengths <- fasta.seqlengths(filepath)
  # }else{
  #   stop("The suffix can only be .2bit, .fa, .fasta!")
  # }
  # lengths <- as.numeric(sort(lengths, decreasing=TRUE))
  index <- which(cumsum(lengths) / sum(lengths) >= XX/100)[1]
  return(lengths[index])
}
N10 <- function(fn){
  return(NXX(fn, XX=10))
}
N20 <- function(fn){
  return(NXX(fn, XX=20))
}
N30 <- function(fn){
  return(NXX(fn, XX=30))
}
N40 <- function(fn){
  return(NXX(fn, XX=40))
}
N50 <- function(fn){
  return(NXX(fn, XX=50))
}
N60 <- function(fn){
  return(NXX(fn, XX=60))
}
N70 <- function(fn){
  return(NXX(fn, XX=70))
}
N80 <- function(fn){
  return(NXX(fn, XX=80))
}
N90 <- function(fn){
  return(NXX(fn, XX=90))
}


## helper function to transform a number into fancy scientific format
fancy_scientific <- function(l) {
  # turn in to character string in scientific notation
  l <- format(l, scientific = TRUE)
  # quote the part before the exponent to keep all the digits
  l <- gsub("^(.*)e", "'\\1'e", l)
  # turn the 'e+' into plotmath format
  l <- gsub("e", "%*%10^", l)
  # return this as an expression
  parse(text=l)
}


## helper function to transform a number into Mbp
Ms <- function (x) { number_format(accuracy = 1,
                                   scale = 1/1000000,
                                   suffix = "Mbp",
                                   big.mark = ",")(x) }

## helper function to transform a number into Mbp
Ms2 <- function (x) { number_format(accuracy = 1,
                                   scale = 1/1000000,
                                   big.mark = ",")(x) }



## helper function to return the sign of a given number
signOf <- function(x, ...)
{
  if (x > 0)
  {
    sprintf("+"
            #fmt = "+ %s", 
            #format(x, ...)
    )
  } else if (x < 0)
  {
    sprintf("-")
  }
}


### Convert pairwise list to distance matrix
### row and columns are sorted by numerical order
list2dist.1 <-
  function(dat){
    dat.name1 <- dat[,1]
    dat.name2 <- dat[,2]
    dat.value <- dat[,3]
    names1 <- sort(unique(dat[,1]))
    names2 <- sort(unique(dat[,2]))
    total.names <- unique(c(names1, names2))
    elements <- rep(NA, length(total.names)^2)
    dim(elements) <- c(length(total.names),length(total.names))
    rownames(elements) <- total.names
    colnames(elements) <- total.names
    
    for(i in 1:length(total.names)){
      for(j in 1:length(total.names)){
        for(k in 1:length(dat.name1)){
          if((total.names[i] == dat.name1[k])&(total.names[j] == dat.name2[k])){
            elements[i,j] <- dat.value[k]
          }
        }
      }
    }
    res <- as.dist(t(elements))
    return(res)
  }



# unroll the data into a series of opening and closing events. Then you track how many intervals are open at a time. 
# This assume each group doesn't have any overlapping intervals.
sets<-function(start, end, group, overlap=length(unique(group))) {
  dd<-rbind(data.frame(pos=start, event=1), data.frame(pos=end, event=-1))
  dd<-aggregate(event~pos, dd, sum)
  dd<-dd[order(dd$pos),]
  dd$open <- cumsum(dd$event)
  r<-rle(dd$open>=overlap)
  ex<-cumsum(r$lengths-1 + rep(1, length(r$lengths))) 
  sx<-ex-r$lengths+1
  cbind(dd$pos[sx[r$values]],dd$pos[ex[r$values]+1])
  
} 

# Example: union
# with(df, sets(start, end, id,1))

# Example: overlap of 3 groups
# with(df, sets(start, end, id,3))


### expand data frame by column without restricting original size
cbind.all <- function (...) 
{
  nm <- list(...)
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow))
  do.call(cbind, lapply(nm, function(x) rbind(x, matrix(, n - nrow(x), ncol(x)))))
}
