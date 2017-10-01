library(RLowPC)
library(readr)

#input
Dream_Ecoli_golden <- read_delim("/media/chenx/Program/Exp/bmrnet/db/DREAM3RAR/gold standard/DREAM3GoldStandard_InSilicoSize100_Ecoli1.txt", 
                                   "\t", escape_double = FALSE, col_names = c("from","to","weight"), 
 
                                                                     trim_ws = TRUE)
resfile <-'/media/chenx/Program/Exp/bmrnet/db/Dream100/Dream100-Ecoli_golden.txt'
genenumber <-100


#start
genes <-c()
for(i in 1:genenumber){
  genes[i] <- paste("G",i,sep = "")
}

edgelist <- as.data.frame(Dream_Ecoli_golden)
adjmatrix <- matrix(0, ncol = length(genes), nrow = length(genes))
dimnames(adjmatrix) <- list(genes, genes)
for (i in 1:nrow(edgelist)) {
  from <- edgelist[i, 1]
  to <- edgelist[i,2]
  adjmatrix[from,to] <- edgelist[i, 3]
}
directed <-F
if (!directed) {
  adjmatrix <- pmax(adjmatrix, t(adjmatrix))
}

write.csv(adjmatrix, file=resfile, sep = "\t", row.names=FALSE,col.names = FALSE)


