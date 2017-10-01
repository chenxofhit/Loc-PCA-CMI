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
  datafile <- "./db/Dream50/Dream50_Ecoli.csv" #10,10,100, modify here
  goldenfile <- "./db/Dream50/Dream50_Ecoli_golden.txt"
  clusterfile<-  paste(getwd(),"/result_loc_pcacmi/Dream50_Ecoli_cluster.mat",sep = "")
  
  #immediate result from Matlab Runtime
  pcacmi_adjmatrix <- paste(getwd(),"/result_pca_cmi/Dream50_Ecoli_adjmatrixg.mat",sep = "")
  pcapmi_adjmatrix <- paste(getwd(),"/result_pca_pmi/Dream50_Ecoli_adjmatrixg.mat",sep = "")
  
}else{
  datafile <- args[[1]]
  goldenfile <- args[2]
  clusterfile <- args[3]
  
  pcacmi_adjmatrix <- args[4]
  pcapmi_adjmatrix <- args[5]
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

#initialize mrnet_data dataframe
mrnet_data <- inf.zeroPC[,1:2]
mrnet_data["weight"]<-0
mrnet_data["times"]<-0

#calculate and store
for(i in 1:dim(inf.zeropc.adj)[[1]]){
  idx <- which(inf.zeropc.adj[i,] > 0)
  library(gtools)
  mixOrderCluster <- mixedsort(colnames(inf.zeropc.adj)[c(i,idx)])
  cat(paste(i,"th/#",length(mixOrderCluster),sep = ""),":[",mixOrderCluster,"]\n")
  
  subnet <- data.exp[c(i,idx)]
  library(minet)
  mrnet_pearson <- minet::minet(subnet, method = "mrnet",estimator = "pearson")
  mrnet_pearson_edgelist <- adjmatrix2edgelist(mrnet_pearson,cutoff = 0)

  for (j in 1:nrow(mrnet_pearson_edgelist)) {
    from <-  lapply(mrnet_pearson_edgelist[j,1], as.character)[1]
    to <- lapply(mrnet_pearson_edgelist[j,2], as.character)[1]
    idx <- which(mrnet_data$from == from & mrnet_data$to == to)
    mrnet_data[idx,]$weight = mrnet_data[idx,]$weight + mrnet_pearson_edgelist[j,3]
    mrnet_data[idx,]$times = mrnet_data[idx,]$times + 1
  }
}

#summary
mrnet_data_filter <- mrnet_data[mrnet_data$weight>0,]
mrnet_data_filter$weight <- mrnet_data_filter$weight/mrnet_data_filter$times
mrnet_data_filter_edges <- mrnet_data_filter[,1:3]
mrnet_data_filter_net<-edgelist2adjmatrix(mrnet_data_filter_edges,genes)

#evaluation with MINET package
loc_mrnet.tbl <- validate(as.matrix(mrnet_data_filter_net),as.matrix(dream3_golden))

cat("Network\tAUROC\tAUPR\n")
cat(datafile,'\t',auc.roc(loc_mrnet.tbl),'\t',auc.pr(loc_mrnet.tbl),'\n')

mrnet_spearman <- minet::minet(dream3, method = "mrnet",estimator = "pearson")
mrnet_spearman.tbl <- validate(as.matrix(mrnet_spearman),as.matrix(dream3_golden))

cat(datafile,'\t',auc.roc(mrnet_spearman.tbl),'\t',auc.pr(mrnet_spearman.tbl),'\n')


adjmatrixg <- readMat(pcacmi_adjmatrix)
dream3_pcacmi <- adjmatrixg$G
dream3_pcacmi.tbl <- validate(dream3_pcacmi,as.matrix(dream3_golden))

adjmatrixgpmi <- readMat(pcapmi_adjmatrix)
dream3_pcapmi <- adjmatrixgpmi$G
dream3_pcapmi.tbl <- validate(dream3_pcapmi,as.matrix(dream3_golden))


cat("pca_pmi",'\t',auc.roc(dream3_pcapmi.tbl),'\t',auc.pr(dream3_pcapmi.tbl),'\n')
cat("pca_cmi",'\t',auc.roc(dream3_pcacmi.tbl),'\t',auc.pr(dream3_pcacmi.tbl),'\n')

#visulization with ggplot2
library(pROC)
library(ggplot2)

source('/media/chenx/Program/Exp/VIS/geom_roc_plot/ROC_Plot.R')
source('/media/chenx/Program/Exp/VIS/geom_roc_plot/Theme_Publication.R')

y <- as.matrix(dream3_golden)[lower.tri(as.matrix(dream3_golden))]

loc_mrnet_x <- as.matrix(mrnet_data_filter_net)[lower.tri(as.matrix(mrnet_data_filter_net))]
mrnet_x <-  as.matrix(mrnet_spearman)[lower.tri(as.matrix(mrnet_spearman))]
pca_pmi_x <- as.matrix(dream3_pcapmi )[lower.tri(as.matrix(dream3_pcapmi ))]
pca_cmi_x <- as.matrix(dream3_pcacmi )[lower.tri(as.matrix(dream3_pcacmi ))]

##library("pROC"),deprecated,not suitable for PR curve !!!
#R_locmrnet <- roc(y,loc_mrnet_x)
#R_mrnet <- roc(y,mrnet_x)
#R_pca_pmi <-  roc(y,pca_pmi_x)
#R_pca_cmi <-  roc(y,pca_cmi_x)
##
# dat_locmrnet <- data.frame(TruePositiveRate = R_locmrnet$sensitivities, 
#                            FalsePositiveRate = (1-R_locmrnet$specificities), 
#                            Model = rep("loc-MRNET",length(R_locmrnet$sensitivities)))
# 
# dat_mrnet <- data.frame(TruePositiveRate = R_mrnet$sensitivities, 
#                         FalsePositiveRate = (1-R_mrnet$specificities), 
#                         Model = rep("MRNET",length(R_mrnet$sensitivities)))
# 
# dat_pca_pmi <- data.frame(TruePositiveRate = R_pca_pmi$sensitivities, 
#                           FalsePositiveRate = (1-R_pca_pmi$specificities), 
#                           Model = rep("PCA_PMI",length(R_pca_pmi$sensitivities)))
# 
# dat_pca_cmi <- data.frame(TruePositiveRate = R_pca_cmi$sensitivities, 
#                           FalsePositiveRate = (1-R_pca_cmi$specificities), 
#                           Model = rep("PCA_CMI",length(R_pca_cmi$sensitivities)))
# 
# 
# dat <- rbind(dat_locmrnet,dat_mrnet,dat_pca_pmi,dat_pca_cmi)
# 
# ggplot(dat,aes(FalsePositiveRate,TruePositiveRate,colour = Model)) + geom_roc_plot()+
#   scale_colour_Publication() + theme_Publication()+
#   theme(panel.border = element_rect(colour = 'black'),legend.title = element_blank(),
#         legend.position = c(0.9,0.15),legend.direction = 'vertical')

library(ROCR)

R_locmrnet <- prediction(loc_mrnet_x,y)
perf_pr_locmrnet <- performance(R_locmrnet, "prec", "rec")
dat_locmrnet <- data.frame(Precision = perf_pr_locmrnet@y.values[[1]], 
                           Recall = perf_pr_locmrnet@x.values[[1]],  Model = rep("loc-MRNET",length(perf_pr_locmrnet@x.values[[1]])))


R_mrnet <- prediction(mrnet_x,y)
perf_pr_mrnet <- performance(R_mrnet, "prec", "rec")
dat_mrnet <- data.frame(Precision = perf_pr_mrnet@y.values[[1]], 
                        Recall = perf_pr_mrnet@x.values[[1]],  Model = rep("MRNET",length(perf_pr_mrnet@x.values[[1]])))



R_pca_pmi <-  prediction(pca_pmi_x,y)
perf_pr_pca_pmi <- performance(R_pca_pmi, "prec", "rec")
dat_pca_pmi <- data.frame(Precision = perf_pr_pca_pmi@y.values[[1]], 
                          Recall = perf_pr_pca_pmi@x.values[[1]],Model = rep("PCA-PMI",length(perf_pr_pca_pmi@x.values[[1]])))



R_pca_cmi <-  prediction(pca_cmi_x,y)
perf_pr_pca_cmi <- performance(R_pca_cmi, "prec", "rec")
dat_pca_cmi <- data.frame(Precision = perf_pr_pca_cmi@y.values[[1]], 
                          Recall = perf_pr_pca_cmi@x.values[[1]],Model = rep("PCA-CMI",length(perf_pr_pca_cmi@x.values[[1]])))


dat <- rbind(dat_locmrnet,dat_mrnet,dat_pca_pmi,dat_pca_cmi)

ggplot(dat,aes(Precision,Recall,colour = Model)) + geom_roc_plot()+
  scale_colour_Publication() + theme_Publication()+
  theme(panel.border = element_rect(colour = 'black'),legend.title = element_blank(),
        legend.position = c(0.9,0.15),legend.direction = 'vertical')