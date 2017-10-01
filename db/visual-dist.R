require(igraph)

goldenfile <- "/media/chenx/Program/Exp/bmrnet/db/Dream100/Dream100_Yeast_golden.txt"

dat <- read.delim(goldenfile, header=FALSE)

m = as.matrix(dat) # coerces the data set as a matrix
g = graph.adjacency(m,mode="undirected",weighted=NULL) # this will create an 'igraph object'

#recomend
plot.igraph(g,layout = layout.kamada.kawai, layout.par = list(), 
            labels = NULL, label.color = "darkblue", label.font = NULL, 
            label.degree = -pi/4, label.dist = 0, vertex.color = "SkyBlue2", 
            vertex.size = 10, edge.color = "darkgrey", edge.width = 1,
            edge.labels = NA, edge.lty=1, vertex.frame.color="black")

deg <- degree(g, mode= "all")
cat(paste("MEAN DEGREE:",mean(deg),"\n"))
cat(paste("MAX DEGREE:",max(deg),"\n"))
plot(g,vertex.size=deg*3)
hist(deg, breaks=1:vcount(g)-1, main="Histogram of node degree")