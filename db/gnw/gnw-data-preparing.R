library(RLowPC)

#input files below are generated with "GeneNetWeaver 3.1.3 Beta Java version 1.8.0_65, Oracle Corporation"

#input
datafile_tsv <- "/media/chenx/Program/Exp/bmrnet/db/gnw/Ecoli-size500-5/Ecoli-500-5_knockouts.tsv"
goldenfile_tsv<-"/media/chenx/Program/Exp/bmrnet/db/gnw/Ecoli-size500-5/Ecoli-500-5_goldstandard.tsv"


#output
datafile_csv <- "/media/chenx/Program/Exp/bmrnet/db/gnw/Ecoli-size500-5/Ecoli-500-5_knockouts.csv"
resfile <-'/media/chenx/Program/Exp/bmrnet/db/gnw/Ecoli-size500-5/Ecoli-500-5_golden.txt'

Ecoli_knockouts <- read.delim(datafile_tsv)
Ecoli_goldstandard <- read.delim(goldenfile_tsv, header=FALSE)

genes <- colnames(Ecoli_knockouts)

adjmatrix <- edgelist2adjmatrix(edgelist = Ecoli_goldstandard,genes = genes,cutoff = 0, directed = F)

sum.adjmaxtrix <- sum(adjmatrix==1)
sum.goldstandard <- sum(Ecoli_goldstandard$V3==1)
if(sum.adjmaxtrix != sum.goldstandard*2){
  cat("!!! adjmatrix not equal to gold standard in this case, this occurs to GNW issue or bug...")
}

#persitence to output file,instead of using write.csv
write.table(Ecoli_knockouts, file=datafile_csv,  sep=",", row.names =  FALSE, col.names=FALSE)

write.table(adjmatrix, file=resfile, sep ="\t", row.names=FALSE,col.names = FALSE)
