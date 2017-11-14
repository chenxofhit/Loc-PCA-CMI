library(readr)
library(R.matlab)
library(Matrix)
library(RLowPC)
library(minet)

print.picture.exp <- function(pplot, p.fname)
{
  #dev.new()
  dpi <- 96
  scaling <- 5.0 / (900)
  wid <- 1600 * scaling * dpi
  ht <- 600 * scaling * dpi
  png(p.fname, width = wid, height = ht, res = dpi)
  print(pplot)
  dev.off()
}

#options(error=traceback)

#set working direcotory based on your workspace
setwd("/media/chenx/Program/Exp/loc-PCA-CMI/comparison/")

args <- commandArgs(trailingOnly = TRUE)
hybrid<-length(args) # switch variable  for debug in Rstudio or integrate running in bash

if(!hybrid){
  datafile <- "../db/Dream10/Dream10_Yeast.csv" #10,50,100, modify here
  goldenfile <- "../db/Dream10/Dream10_Yeast_golden.txt"
  clusterfile<-  paste(getwd(),"/../result_loc_pcacmi/Dream10_Yeast_cluster.mat",sep = "")
  
  #immediate result from Matlab Runtime
  pcacmi_adjmatrix <- paste(getwd(),"/../result_pca_cmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  pcapmi_adjmatrix <- paste(getwd(),"/../result_pca_pmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  
  loc_pca_cmi_adjmatrix <- paste(getwd(),"/../result_loc_pcacmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  loc_pca_pmi_adjmatrix <- paste(getwd(),"/../result_loc_pcapmi/Dream10_Yeast_adjmatrixg.mat",sep = "")
  
  
  prfile <-  paste(getwd(),"/Dream10_Yeast_AUPR_AUROC.png",sep = "")

}else{
  datafile <- args[[1]]
  goldenfile <- args[2]
  clusterfile <- args[3]
  
  pcacmi_adjmatrix <- args[4]
  pcapmi_adjmatrix <- args[5]
  
  loc_pca_cmi_adjmatrix<- args[6]
  loc_pca_pmi_adjmatrix<- args[7]
  prfile <- args[8]

}

dream3 <- read_csv(datafile, col_names = FALSE)
dream3_golden <- read_delim(goldenfile,"\t", escape_double = FALSE, col_names = FALSE, 
                            trim_ws = TRUE)

data.exp <- dream3
genes <- colnames(data.exp)

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


adjmatrix_locpcapmi <- readMat(loc_pca_pmi_adjmatrix)
dream3_loc_pcapmi <- adjmatrix_locpcapmi$G
dream3_loc_pcapmi.tbl <- validate(dream3_loc_pcapmi,as.matrix(dream3_golden))

cat("aracne",'\t',auc.roc(aracne.tbl),'\t',auc.pr(aracne.tbl),'\n')
cat("mrnet",'\t',auc.roc(mrnet_spearman.tbl),'\t',auc.pr(mrnet_spearman.tbl),'\n')
cat("pca_pmi",'\t',auc.roc(dream3_pcapmi.tbl),'\t',auc.pr(dream3_pcapmi.tbl),'\n')
cat("pca_cmi",'\t',auc.roc(dream3_pcacmi.tbl),'\t',auc.pr(dream3_pcacmi.tbl),'\n')
cat("loc_pca_pmi",'\t',auc.roc(dream3_loc_pcapmi.tbl),'\t',auc.pr(dream3_loc_pcapmi.tbl),'\n')
cat("loc_pca_cmi",'\t',auc.roc(dream3_loc_pcacmi.tbl),'\t',auc.pr(dream3_loc_pcacmi.tbl),'\n')

y <- as.matrix(dream3_golden)[lower.tri(as.matrix(dream3_golden))]
                                                                                                                                                                                                                                                                                                                                                                                                      
#loc_mrnet_x <- as.matrix(mrnet_data_filter_net)[lower.tri(as.matrix(mrnet_data_filter_net))]
aracne_x <-  as.matrix(aracne)[lower.tri(as.matrix(aracne))]
mrnet_x <-  as.matrix(mrnet_spearman)[lower.tri(as.matrix(mrnet_spearman))]
pca_pmi_x <- as.matrix(dream3_pcapmi )[lower.tri(as.matrix(dream3_pcapmi ))]
pca_cmi_x <- as.matrix(dream3_pcacmi )[lower.tri(as.matrix(dream3_pcacmi ))]
loc_pca_pmi_x <- as.matrix(dream3_loc_pcapmi )[lower.tri(as.matrix(dream3_loc_pcapmi ))]
loc_pca_cmi_x <- as.matrix(dream3_loc_pcacmi )[lower.tri(as.matrix(dream3_loc_pcacmi ))]

#visulization with precrec and ggplot2
library(precrec)
library(ggplot2)
library(grid)


scoreall <- list(loc_pca_cmi_x,loc_pca_pmi_x,pca_pmi_x,pca_cmi_x,mrnet_x,aracne_x)
R_all <- mmdata(scores = scoreall,labels = y, modnames = c("Loc-PCA-CMI","Loc-PCA-PMI","PCA-PMI","PCA-CMI","MRNET","ARACNE"))
mscurves <- evalmod(R_all)
ggsave(prfile,plot = autoplot(mscurves),dpi = 96)


