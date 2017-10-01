#conf
expression_data_file<- "/media/chenx/Program/Exp/bmrnet/db/DREAM5/Network3_expression_data.txt"
goldstandard_file <- "/media/chenx/Program/Exp/bmrnet/db/DREAM5/Network3_gold_standard.txt"

expression_data_csv_file <- "/media/chenx/Program/Exp/bmrnet/db/DREAM5/Network3_expression_data.csv"
goldstandard_matrix_file <- "/media/chenx/Program/Exp/bmrnet/db/DREAM5/Network3_gold_standard_matrix.txt"

Network1_expression_data <- read.delim(expression_data_file)
genenames <- colnames(Network1_expression_data)
#read gold standard file
Network1_gold_standard <- read.delim(goldstandard_file, header=FALSE)

require(RLowPC)
adjmatrix <- edgelist2adjmatrix(genes=genenames ,edgelist=Network1_gold_standard,directed=F)

print('Writeback...!')
write(as.matrix(Network1_expression_data),ncolumns = length(genenames), file=expression_data_csv_file,sep = ",")
write(adjmatrix,ncolumns = length(genenames), file = goldstandard_matrix_file)

print('Done!')