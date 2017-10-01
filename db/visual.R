require(igraph)


# library(igraph)
# nexus.info("Davis") # 查看Davis数据集的信息；
# gD<-nexus.get("Davis") # 获取Davis数据集,此时获得的是一个二分图，可用bipartite.mapping(gD)来查验；
# g<-bipartite.projection(gD)$proj2 # 将二分图变成两个一模网络,并提取以事件为节点的网络；
# g2<-delete.edges(g,E(g)[E(g)$weight<3]) # 对网络的边取阀值为3，提取边权仅大于或等于3的部分；
# events=paste("e",1:14,sep="") # 给出14个节点的标签；
# tkid<-tkplot(g2) # 按照PPT，拖动相应数据点到相应位置
# lay<-tkplot.getcoords(tkid)
# pdf("events14.pdf") # 输出PDF格式结果到当前目录
# plot(g2, edge.width=E(g)$weight,
#      layout=lay,
#      vertex.color="green",
#      vertex.shape="square",
#      vertex.frame.color="grey",
#      vertex.label=events,
#      vertex.label.font=2,
#      vertex.label.color="black",
#      vertex.label.dist=1,
#      vertex.label.degree=pi/2)
# dev.off()

library(igraph)

goldenfile <- "/media/chenx/Program/Exp/bmrnet/db/Dream50/Dream50_Yeast_golden.txt"

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
mean(deg)
max(deg)
edge_density(g,loops = FALSE)
plot(g,vertex.size=deg*3)
hist(deg, breaks=1:vcount(g)-1, main="Histogram of node degree")

# plot.igraph(g,layout = layout.reingold.tilford, layout.par = list(), 
#             labels = NULL, label.color = "darkblue", label.font = NULL, 
#             label.degree = -pi/4, label.dist = 0, vertex.color = "SkyBlue2", 
#             vertex.size = 10, edge.color = "darkgrey", edge.width = 1,
#             edge.labels = NA, edge.lty=1, vertex.frame.color="black")


# tkid<-tkplot(g) # 按照PPT，拖动相应数据点到相应位置
# lay<-tkplot.getcoords(tkid)
# pdf("events1.pdf") # 输出PDF格式结果到当前目录
# 
# events=paste("v",1:50,sep="") # 给出14个节点的标签
# 
# plot(g,
#      layout=lay,
#      vertex.color="black",
#      vertex.shape="square",
#      vertex.frame.color="white",
#      vertex.label = events,
#      vertex.label.font=2,
#      vertex.label.color="red",
#      vertex.label.dist=1,
#      vertex.label.degree=pi/2)
# tkid<-tkplot(g)
# lay<-tkplot.getcoords(tkid)
# plot(g,layout = lay, layout.par = list(), 
#             labels = NULL, label.color = "darkblue", label.font = NULL, 
#             label.degree = -pi/4, label.dist = 0, vertex.color = "SkyBlue2", 
#             vertex.size = 10, edge.color = "darkgrey", edge.width = 1,
#             edge.labels = NA, edge.lty=1, vertex.frame.color="black")
# dev.off()
