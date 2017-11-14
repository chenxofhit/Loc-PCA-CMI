options(digits=3)
library(gridExtra)
library(ggplot2)
library(grid)


prfile <- "/media/chenx/Program/Exp/loc-PCA-CMI/comparison/K_Dream50_Yeast.png"

res_yeast50_pmi <- "/media/chenx/Program/Exp/loc-PCA-CMI/result_pca_pmi_k/Dream50_Yeast.res"
dreamK_yeast50_pmi <- read.delim(res_yeast50_pmi, header=FALSE, stringsAsFactors=FALSE)
dreamK_yeast50_pmi$id <- 1:length(dreamK_yeast50_pmi$V1)
auroc_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V2)
aupr_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V3)
yeast50_pmi <-  data.frame(method="PCA-PMI",auroc = auroc_yeast50_pmi, aupr = aupr_yeast50_pmi, k =1:10)


res_yeast50_pmi <- "/media/chenx/Program/Exp/loc-PCA-CMI/result_pca_cmi_k/Dream50_Yeast.res"
dreamK_yeast50_pmi <- read.delim(res_yeast50_pmi, header=FALSE, stringsAsFactors=FALSE)
dreamK_yeast50_pmi$id <- 1:length(dreamK_yeast50_pmi$V1)
auroc_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V2)
aupr_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V3)
yeast50_cmi <-  data.frame(method="PCA-CMI",auroc = auroc_yeast50_pmi, aupr = aupr_yeast50_pmi, k =1:10)

res_yeast50_pmi <- "/media/chenx/Program/Exp/loc-PCA-CMI/result_loc_pcapmi_k/Dream50_Yeast.res"
dreamK_yeast50_pmi <- read.delim(res_yeast50_pmi, header=FALSE, stringsAsFactors=FALSE)
dreamK_yeast50_pmi$id <- 1:length(dreamK_yeast50_pmi$V1)
auroc_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V2)
aupr_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V3)
yeast50_lpmi <-  data.frame(method="Loc_PCA-PMI",auroc = auroc_yeast50_pmi, aupr = aupr_yeast50_pmi, k =1:10)


res_yeast50_pmi <- "/media/chenx/Program/Exp/loc-PCA-CMI/result_loc_pcacmi_k/Dream50_Yeast.res"
dreamK_yeast50_pmi <- read.delim(res_yeast50_pmi, header=FALSE, stringsAsFactors=FALSE)
dreamK_yeast50_pmi$id <- 1:length(dreamK_yeast50_pmi$V1)
auroc_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V2)
aupr_yeast50_pmi<- as.numeric(dreamK_yeast50_pmi[which(dreamK_yeast50_pmi$id%%2==0),]$V3)
yeast50_lcmi <-  data.frame(method="Loc_PCA-CMI",auroc = auroc_yeast50_pmi, aupr = aupr_yeast50_pmi, k =1:10)

fdf <- rbind(yeast50_pmi, yeast50_cmi,yeast50_lpmi,yeast50_lcmi)

## Create the top plot (with negative bottom margins)
g.top <-ggplot(data=fdf, aes(x=fdf$k, y=fdf$aupr, group=fdf$method,colour=fdf$method)) +
  geom_line() +
  geom_point()+ 
  labs(x="k",y="AUPR",color='Method')+ scale_x_continuous(breaks= c(seq(1,10,1))) + 
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank())

## Create the bottome plot (with no top margins)
g.bottom <-ggplot(data=fdf, aes(x=fdf$k, y=fdf$auroc, group=fdf$method,colour=fdf$method)) +
  geom_line() +
  geom_point()+ 
  labs(x="k",y="AUROC",color='Method')+ scale_x_continuous(breaks= c(seq(1,10,1))) +
  theme(legend.position = "bottom")

#grid.newpage()
#grid.draw(rbind(ggplotGrob(g.top), ggplotGrob(g.bottom), size = "last"))

## Plot graphs and set relative heights
g <- grid.arrange(g.top,g.bottom, heights = c(1/2, 1/2)) 

ggsave(prfile,plot = g,dpi = 96)
