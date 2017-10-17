# get the file
my_file <- read.table("routes.txt", header = TRUE)

# a duplication so as to not work on the original file
temp <- routes_file

nrow(temp)  # number of rows/edges (routes)
#[1] 67663
nrow(unique(temp[,c("from", "to")]))  # number of unique routes (unique directed edges)
#[1] 37595
length(unique(temp$from))  # number of unique departing airports in the route list
#[1] 3409
length(unique(temp$to))   # number of unique destination airports in the route list
#[1] 3418

# because of duplicate routes, aggregate by frequency
routes <- aggregate(numeric(nrow(temp)), temp[c("from", "to")], length)

# create graph
library(igraph)
names(routes) <- c("from", "to", "weight")
net <- graph.data.frame(routes)

length(V(net)) # number of nodes
#[1] 3425
length(E(net)) # number of edges
#[1] 37595

# plot graph
plot.igraph(net,vertex.label=NA, vertex.color="light blue", vertex.size=5, edge.arrow.size=.4, edge.color="black",edge.width=E(net)$weight/10,edge.arrow.width=0.5, edge.curved=.1)

hist(routes$weight)
mean(routes$weight)
median(routes$weight)
sd(routes$weight)

# cut-off
cut_off <- mean(routes$weight)
net.sp <- delete.edges(net, E(net)[weight>cut_off])
plot.igraph(net.sp, vertex.label=NA, vertex.color="light blue", vertex.size=5, edge.arrow.size=.4, edge.color="black",edge.width=E(net.sp)$weight/10,edge.arrow.width=0.5, edge.curved=.1, main="Network Flight Routes, with cut-off")

# calculate edge density
ecount(net)/(vcount(net)*(vcount(net)-1))
#[1] 0.003205795

# calculate reciprocity
reciprocity(net)
#[1] 0.9755812

# calculate transitivity
triad_census(net)
#[1] 6625574892    3078257   60694988        578        548        987      24307      30324         16         73
#[11]     861602         98        173        259       3873      96625

# calculate diameter
diameter(net, directed=T, weights=NA)
#[1] 14
get_diameter(net, directed=T)
#HTN URC PVG HNL ANC ANI CHU CKD SLQ SRV

# calculate node degree
deg <- degree(net, mode="all")

# top 20 nodes with highest degree
sort(deg, decreasing=TRUE)[1:20]
#FRA CDG AMS IST ATL PEK ORD MUC DME DFW DXB LHR DEN IAH LGW BCN JFK FCO MAD STN 
#477 470 463 457 433 412 409 380 378 372 370 342 337 337 330 326 322 316 314 305 
# top 20 in-degree
sort(degree(net, mode="in"), decreasing=TRUE)[1:20]
#FRA CDG AMS IST ATL PEK ORD DME MUC DFW DXB LHR DEN IAH LGW BCN JFK FCO MAD PVG 
#238 233 231 230 216 206 203 189 189 185 182 171 168 168 165 163 160 159 156 153 
# top 20 out-degree
sort(degree(net, mode="out"), decreasing=TRUE)[1:20]
#FRA CDG AMS IST ATL ORD PEK MUC DME DXB DFW LHR DEN IAH LGW BCN JFK MAD FCO STN 
#239 237 232 227 217 206 206 191 189 188 187 171 169 169 165 163 162 158 157 153 

# top 20 weighted degree
a <- graph.data.frame(temp)
sort(degree(a, mode="all"), decreasing=TRUE)[1:20]
#ATL  ORD  PEK  LHR  CDG  LAX  FRA  DFW  JFK  AMS  PVG  SIN  BCN  ICN  DEN  MIA  MUC  IST  HKG  DXB 
#1826 1108 1069 1051 1041  990  990  936  911  903  825  820  783  740  735  734  728  719  710  710 
# top 20 weighted in-degree
sort(degree(a, mode="in"), decreasing=TRUE)[1:20]
#ATL ORD PEK LHR CDG LAX FRA DFW JFK AMS PVG SIN BCN DEN ICN MIA IST MUC HKG DXB 
#911 550 534 524 517 498 493 467 455 450 414 412 392 374 370 366 361 360 355 354 
# weighted out-degree
sort(degree(a, mode="out"), decreasing=TRUE)[1:20]
#ATL ORD PEK LHR CDG FRA LAX DFW JFK AMS PVG SIN BCN ICN MUC MIA DEN IST LGW DXB 
#915 558 535 527 524 497 492 469 456 453 411 408 391 370 368 368 361 358 356 356 


# histogram of node degree
hist(deg, breaks=1:vcount(net)-1, main="Histogram of node degree")

# degree distribution
deg.dist <- degree_distribution(net, cumulative=T, mode="all")
plot( x=0:max(deg), y=deg.dist, pch=19, cex=1.2, col="orange",
      xlab="Degree", ylab="Cumulative Frequency", main="Degree Distribution")
plot( x=0:max(deg), y=deg.dist, pch=19, cex=1.2, col="orange", 
      log="y", xlab="Degree", ylab="Cumulative Frequency (logarithmic)", main="Degree Distribution (log)")  # logarithmic

# calculate centralisation
degree(net, mode="in")   # degree (number of ties)
centr_degree(net, mode="in", normalized=T)

#$centralization
#[1] 0.06630355
#$theoretical_max
#[1] 11727200

# Closeness (centrality based on distance to others in the graph)
close <- closeness(net, mode="all", weights=NA)
sort(close, decreasing=TRUE)[1:20]

#FRA          CDG          LHR          AMS          DXB          LAX          JFK          YYZ          IST 
#9.583042e-06 9.578269e-06 9.574234e-06 9.565716e-06 9.564985e-06 9.557123e-06 9.552832e-06 9.543442e-06 9.539072e-06 
#ORD          PEK          MUC          FCO          NRT          EWR          DOH          ICN          ZRH 
#9.537798e-06 9.536252e-06 9.535434e-06 9.531071e-06 9.529981e-06 9.528256e-06 9.526894e-06 9.524444e-06 9.521542e-06 
#MAD          IAH 
#9.520273e-06 9.517736e-06

centr_clo(net, mode="all", normalized=T)
#$centralization
#[1] 0.003748188

#$theoretical_max
#[1] 1711.75

# Eigenvector (centrality proportional to the sum of connection centralities)
eigen_centrality(net, directed=T, weights=NA)
sort(eigen_centrality(net, directed=T, weights=NA)$vector, decreasing=TRUE)[1:20]
#AMS       FRA       CDG       MUC       LHR       FCO       IST       BCN       ZRH       MAD       BRU       DUB 
#1.0000000 0.9989855 0.9596674 0.8978758 0.8259622 0.8189349 0.7814552 0.7802331 0.7606253 0.7428368 0.7375816 0.7070025 
#DUS       LGW       VIE       MAN       CPH       JFK       MXP       DXB 
#0.6990770 0.6930084 0.6894696 0.6883916 0.6595425 0.6395904 0.6379203 0.6192385 

#$value
#[1] 176.6681
centr_eigen(net, directed=T, normalized=T)
#$value
#[1] 69.28393

# Betweenness (centrality based on a broker position connecting others)
bet <- betweenness(net, directed=T, weights=NA)
e_bet <- edge_betweenness(net, directed=T)
centr_betw(net, directed=T, normalized=T)
#ANC      LAX      CDG      DXB      FRA      PEK      ORD      SEA      AMS      YYZ      IST      GRU      LHR 
#822811.2 775462.5 723184.7 695608.3 597736.5 576260.1 555899.7 530561.7 499964.2 498430.6 483106.7 464611.7 449889.0 
#NRT      SYD      SIN      BNE      DME      ATL      YUL 
#416756.9 382198.8 365969.3 357719.9 344781.1 344528.7 328462.5 

#$centralization
#[1] 0.06933109

#$theoretical_max
#[1] 40130485248


# Clustering
hs <- hub_score(net)$vector
as <- authority_score(net)$vector

# Hubs and Authorities
par(mfrow=c(1,2))
plot(net, vertex.size=hs*50, vertex.color="light blue",vertex.label=NA, edge.arrow.size=.4, edge.color="black",edge.width=E(net)$weight/10,edge.arrow.width=0.5, edge.curved=.1, main="Hubs")
plot(net, vertex.size=as*30, vertex.color="light blue",vertex.label=NA, edge.arrow.size=.4, edge.color="black",edge.width=E(net)$weight/10,edge.arrow.width=0.5, edge.curved=.1, main="Authorities")


# Distances and paths
# calculate mean distance
mean_distance(net, directed=T)
#[1] 4.146205
distances(net)


# Subgroups and communities
# undirected network:
net.sym <- as.undirected(net, mode= "collapse",
                         edge.attr.comb=list(weight="sum", "ignore"))


# components (clusters)
SCC <- clusters(net, mode="strong")
V(net)$color <- rainbow(SCC$no)[SCC$membership]
plot.igraph(net, mark.groups = split(1:vcount(net), SCC$membership))
sort(SCC$membership, decreasing=TRUE)[1:30]
#SSB SPB MPA NDU OND ERS TKJ CKX KOC BMY ILP KNQ LIF MEE TGJ TOU UVE GEA GCW BLD CLM FRD BFI ESD DUT AKB IKO KQA ALG CDG 
#8   8   7   7   7   7   6   6   5   5   5   5   5   5   5   5   5   5   4   4   3   3   3   3   2   2   2   2   1   1

# identifying biggest component
gs <- induced.subgraph(net, SCC$membership==order(-SCC$csize)[1])
plot(gs, vertex.size=as*30, vertex.color="light blue",vertex.label=NA, edge.arrow.size=.4, edge.color="black",edge.width=E(net)$weight/10,edge.arrow.width=0.5, edge.curved=.1)

# articulation points
# for the whole network:
net2 <- net
V(net2)$color = "black"
articulation.points(net2)   # 362 nodes
V(net2)[articulation.points(net2)]$color = "red"
plot.igraph(net2, vertex.size=3, vertex.label=NA,edge.arrow.width=0.3, edge.color="light blue", edge.width = 0.1, edge.curved=.1, main="Articulation Points")
# for the strongest component
gs2 <- gs
V(gs2)$color = "black"
articulation.points(gs2)   # 358 nodes
V(gs2)[articulation.points(gs2)]$color = "red"
plot.igraph(gs2, vertex.size=3, vertex.label=NA,edge.arrow.width=0.3, edge.color="light blue", edge.width = 0.1, edge.curved=.1, main="Articulation Points")

# Assortativity and Homophily
routes_new <- routes
x <- ifelse(routes_new$weight < 5, "periferic", ifelse((routes_new$weight>=5) & (routes_new$weight<10),"small", "large"))
routes_new$type <- x
net2 <- graph.data.frame(routes_new)

assortativity_degree(net, directed=T)
#[1] -0.01044319