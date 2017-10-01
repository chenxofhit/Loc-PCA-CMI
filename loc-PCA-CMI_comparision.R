library(readr)
library(R.matlab)
library(Matrix)
library(RLowPC)

print.picture.exp <- function(p.p1, p.fname)
{
  dpi <- 96
  scaling <- 5.0 / (900)
  wid <- 1600 * scaling * dpi
  ht <- 600 * scaling * dpi
  png(p.fname, width = wid, height = ht, res = dpi)
  print(p.p1)
  dev.off()
}

#options(error=traceback)

#set working direcotory based on your workspace
setwd("/media/chenx/Program/Exp/bmrnet")

args <- commandArgs(trailingOnly = TRUE)
hybrid<-length(args) # switch variable  for debug in Rstudio or integrate running in bash

if(!hybrid){
  datafile <- "./db/Dream10/Dream10_Yeast.csv" #10,50,100, modify here
  goldenfile <- "./db/Dream10/Dream10_Yeast_golden.txt"
  clusterfile<-  paste(getwd(),"/result_loc_pcacmi/Dream10_Yeast_cluster.mat",sep = "")
  
  #immediate result from Matlab Runtime
  pcacmi_adjmatrix <- paste(getwd(),"/result_pca_cmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  pcapmi_adjmatrix <- paste(getwd(),"/result_pca_pmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  
  loc_pca_cmi_adjmatrix <- paste(getwd(),"/result_loc_pcacmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  
  prfile <-  paste(getwd(),"/result_loc_pcacmi/Dream10_Yeast_AUPR_AUROC.png",sep = "")
  
}else{
  datafile <- args[[1]]
  goldenfile <- args[2]
  clusterfile <- args[3]
  
  pcacmi_adjmatrix <- args[4]
  pcapmi_adjmatrix <- args[5]
  
  loc_pca_cmi_adjmatrix<- args[6]
  prfile <- args[7]
  
}

dream3 <- read_csv(datafile, col_names = FALSE)
dream3_golden <- read_delim(goldenfile,"\t", escape_double = FALSE, col_names = FALSE, 
                            trim_ws = TRUE)

data.exp <- dream3
genes <- colnames(data.exp)

inf.zeroPC <- zeroPC(data.exp = data.exp, method = "pearson")

cutoff <- 0.5
cutat='pval'
inf.edge <- inf.zeroPC[inf.zeroPC[, cutat] < cutoff, ]
rownames(inf.edge) <- NULL
inf.edge <- inf.edge[, 1:3]

inf.zeropc.adj<-edgelist2adjmatrix(inf.edge,genes = genes,directed = F)

# #initialize mrnet_data dataframe
# mrnet_data <- inf.zeroPC[,1:2]
# mrnet_data["weight"]<-0
# mrnet_data["times"]<-0
# 
# #calculate and store
# for(i in 1:dim(inf.zeropc.adj)[[1]]){
#   idx <- which(inf.zeropc.adj[i,] > 0)
#   library(gtools)
#   mixOrderCluster <- mixedsort(colnames(inf.zeropc.adj)[c(i,idx)])
#   cat(paste(i,"th/#",length(mixOrderCluster),sep = ""),":[",mixOrderCluster,"]\n")
#   
#   subnet <- data.exp[c(i,idx)]
#   library(minet)
#   mrnet_pearson <- minet::minet(subnet, method = "mrnet",estimator = "spearman")
#   mrnet_pearson_edgelist <- adjmatrix2edgelist(mrnet_pearson,cutoff = 0)
# 
#   for (j in 1:nrow(mrnet_pearson_edgelist)) {
#     from <-  lapply(mrnet_pearson_edgelist[j,1], as.character)[1]
#     to <- lapply(mrnet_pearson_edgelist[j,2], as.character)[1]
#     idx <- which(mrnet_data$from == from & mrnet_data$to == to)
#     mrnet_data[idx,]$weight = mrnet_data[idx,]$weight + mrnet_pearson_edgelist[j,3]
#     mrnet_data[idx,]$times = mrnet_data[idx,]$times + 1
#   }
# }
# 
# #summary
# mrnet_data_filter <- mrnet_data[mrnet_data$weight>0,]
# mrnet_data_filter$weight <- mrnet_data_filter$weight/mrnet_data_filter$times
# mrnet_data_filter_edges <- mrnet_data_filter[,1:3]
# mrnet_data_filter_net<-edgelist2adjmatrix(mrnet_data_filter_edges,genes)
# 
# #evaluation with MINET package
# loc_mrnet.tbl <- validate(as.matrix(mrnet_data_filter_net),as.matrix(dream3_golden))
# 
# cat("Network\tAUROC\tAUPR\n")
# cat(datafile,'\t',auc.roc(loc_mrnet.tbl),'\t',auc.pr(loc_mrnet.tbl),'\n')

aracne<-minet::minet(dream3, method = "aracne")
aracne.tbl <- validate(as.matrix(aracne),as.matrix(dream3_golden))

mrnet_spearman <- minet::minet(dream3, method = "mrnet")
mrnet_spearman.tbl <- validate(as.matrix(mrnet_spearman),as.matrix(dream3_golden))

adjmatrixg <- readMat(pcacmi_adjmatrix)
dream3_pcacmi <- adjmatrixg$G
dream3_pcacmi.tbl <- validate(dream3_pcacmi,as.matrix(dream3_golden))

adjmatrixgpmi <- readMat(pcapmi_adjmatrix)
dream3_pcapmi <- adjmatrixgpmi$G
dream3_pcapmi.tbl <- validate(dream3_pcapmi,as.matrix(dream3_golden))

adjmatrix_locpcacmi <- readMat(loc_pca_cmi_adjmatrix)
dream3_loc_pcacmi <- adjmatrix_locpcacmi$G
dream3_loc_pcacmi.tbl <- validate(dream3_loc_pcacmi,as.matrix(dream3_golden))

cat("aracne","\t",datafile,'\t',auc.roc(aracne.tbl),'\t',auc.pr(aracne.tbl),'\n')
cat("mrnet","\t",datafile,'\t',auc.roc(mrnet_spearman.tbl),'\t',auc.pr(mrnet_spearman.tbl),'\n')
cat("pca_pmi",'\t',datafile,'\t',auc.roc(dream3_pcapmi.tbl),'\t',auc.pr(dream3_pcapmi.tbl),'\n')
cat("pca_cmi",'\t',datafile,'\t',auc.roc(dream3_pcacmi.tbl),'\t',auc.pr(dream3_pcacmi.tbl),'\n')
cat("loc_pca_cmi",'\t',datafile,'\t',auc.roc(dream3_loc_pcacmi.tbl),'\t',auc.pr(dream3_loc_pcacmi.tbl),'\n')

y <- as.matrix(dream3_golden)[lower.tri(as.matrix(dream3_golden))]

loc_mrnet_x <- as.matrix(mrnet_data_filter_net)[lower.tri(as.matrix(mrnet_data_filter_net))]
aracne_x <-  as.matrix(aracne)[lower.tri(as.matrix(aracne))]
mrnet_x <-  as.matrix(mrnet_spearman)[lower.tri(as.matrix(mrnet_spearman))]
pca_pmi_x <- as.matrix(dream3_pcapmi )[lower.tri(as.matrix(dream3_pcapmi ))]
pca_cmi_x <- as.matrix(dream3_pcacmi )[lower.tri(as.matrix(dream3_pcacmi ))]
loc_pca_cmi_x <- as.matrix(dream3_loc_pcacmi )[lower.tri(as.matrix(dream3_loc_pcacmi ))]

#visulization with precrec and ggplot2
library(precrec)
library(ggplot2)
library(grid)


# R_locmrnet <- mmdata(scores = loc_mrnet_x,labels =y)
# R_mrnet <- mmdata(scores = mrnet_x,labels =y)
# R_pca_pmi <-  mmdata(scores = pca_pmi_x,labels =y)
# R_pca_cmi <-  mmdata(scores = pca_cmi_x,labels =y)
# R_loc_pca_cmi <-  mmdata(scores = loc_pca_cmi_x,labels =y)

scoreall <- list(loc_pca_cmi_x,pca_pmi_x,pca_cmi_x,mrnet_x,aracne_x)
R_all <- mmdata(scores = scoreall,labels = y, modnames = c("Loc-PCA-CMI","PCA-PMI","PCA-CMI","MRNET","ARACNE"))
mscurves <- evalmod(R_all)
p<-autoplot(mscurves) + theme(legend.position="bottom")
p
print.picture.exp(p, prfile)
