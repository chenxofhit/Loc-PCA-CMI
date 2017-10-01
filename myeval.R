library(minet)
library(readr)
library(R.matlab)
library(Matrix)
library(igraph)

options(error=traceback) 

#set working direcotory based on your workspace
setwd("/media/chenx/Program/Exp/loc-PCA-CMI")

args <- commandArgs(trailingOnly = TRUE)
hybrid<-length(args) # switch variable  for debug in Rstudio or integrate running in bash

if(!hybrid){
  datafile <- "./db/Dream50/Dream50_Yeast.csv" #10,10,10, modify here
  goldenfile <- "./db/Dream50/Dream50_Yeast_golden.txt"
  adjmatrix <- "./result_cmim/Dream50_Yeast_adjmatrixg.mat"

}else{
  datafile <- args[1]
  goldenfile <- args[2]
  adjmatrix <- args[3]
}

dream3_golden <- read_delim(goldenfile,"\t", escape_double = FALSE, col_names = FALSE, 
                            trim_ws = TRUE)
mat <- readMat(adjmatrix)

dream3_net <- mat$G
dream3_net <- dream3_net/max(dream3_net)

dream3_net.tbl <- validate(as.matrix(dream3_net),as.matrix(dream3_golden))

#evaluation
cat("Network\tAUROC\tAUPR\n")
cat(datafile,'\t',auc.roc(dream3_net.tbl),'\t',auc.pr(dream3_net.tbl),'\n')

#visualization
# m = as.matrix(dream3_cmim) # coerces the data set as a matrix
# 
# net = graph.adjacency(m,mode="undirected",weighted=TRUE,diag=FALSE) #here is the first difference from the previous plot: we designate weighted=TRUE
# plot.igraph(net,vertex.label=V(net)$name,layout=layout.reingold.tilford(g, circular=T), edge.color="black",edge.width=E(net)$weight*10)
# 
# n = as.matrix(dream3_golden) # coerces the data set as a matrix
# 
# net=graph.adjacency(n,mode="undirected",weighted=TRUE,diag=FALSE) #here is the first difference from the previous plot: we designate weighted=TRUE
# plot.igraph(net,vertex.label=V(net)$name,layout=layout.reingold.tilford(g, circular=T), edge.color="black",edge.width=E(net)$weight*10)
