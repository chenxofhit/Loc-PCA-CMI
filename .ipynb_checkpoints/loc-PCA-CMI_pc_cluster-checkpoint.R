library(readr)
library(R.matlab)
library(Matrix)
library(RLowPC)

options(error=traceback)

#set working direcotory based on your workspace
setwd("/media/chenx/Program/Exp/bmrnet")

args <- commandArgs(trailingOnly = TRUE)
hybrid<-length(args) # switch variable  for debug in Rstudio or integrate running in bash

if(!hybrid){
  datafile <- "./db/Dream100/Dream100_Yeast.csv" #10,10,100, modify here
  goldenfile <- "./db/Dream100/Dream100_Yeast_golden.txt"
  clusterfile<-  paste(getwd(),"/result_loc_pcacmi/Dream100_Yeast_cluster.mat",sep = "")
  
}else{
  datafile <- args[1]
  goldenfile <- args[2]
  clusterfile <- args[3]

}

dream3 <- read_csv(datafile, col_names = FALSE)
dream3_golden <- read_delim(goldenfile,"\t", escape_double = FALSE, col_names = FALSE, 
                            trim_ws = TRUE)

data.exp <- dream3
genes <- colnames(data.exp)

inf.zeroPC <- zeroPC(data.exp = data.exp, method = "pearson")

# cutoff <- 0.1
# cutat='pval'
# inf.edge <- inf.zeroPC[inf.zeroPC[, cutat] < cutoff, ]
#rownames(inf.edge) <- NULL

topN <- ceiling(0.2*(length(genes)*(length(genes)-1)/2))
#topn.edges<-na.omit(adjmatrix2edgelist(adjmatrix = inf.pcor,directed = F,order = T)[1:topN,])

inf.edge <- inf.zeroPC[1:topN, 1:3]

inf.zeropc.adj<-edgelist2adjmatrix(inf.edge,genes = genes,directed = F)
for( i in 1:dim(inf.zeropc.adj)[1]){
  idx <- which(inf.zeropc.adj[i,] > 0)
  library(gtools)
  mixOrderCluster <- mixedsort(colnames(inf.zeropc.adj)[c(i,idx)])
  cat(paste(i,"th/#",length(mixOrderCluster),sep = ""),":[",mixOrderCluster,"]\n")
}

writeMat(clusterfile, adj=inf.zeropc.adj)