install.packages("RNeo4j")
library(RNeo4j)
#connect to graph
graph = startGraph("http://127.0.0.1:7474/db/data/", username="neo4j", password="820814")
#delete everything
clear(graph)

##7/7練習
# clear(graph)
# 
# install.packages("hflights")
# library(hflights)
# hflights = hflights[sample(nrow(hflights), 1000),]
# row.names(hflights) = NULL
# 
# data = hflights[1:500,]
# data1 = hflights[501:1000,]
# 
# t = newTransaction(graph)
#irtt
###merge :更改node標 {}新增properties
query = "
MERGE (origin:DBS {name:{origin_name},gg:{origin_name},gginin:{origin_name}})
MERGE (destination:NONDBS {name:{dest_name}})
CREATE (origin)-[:DESTINATION]->(destination)
"
for (i in 1:nrow(data)) {
  origin_name = data[i, ]$Origin
  dest_name = data[i, ]$Dest
  flight_num = data[i, ]$FlightNum
  
  appendCypher(t,
               query,
               origin_name = origin_name,
               dest_name = dest_name,
               flight_num = flight_num)
  cat("\r",round(i/nrow(data)*100,2), '%     ')
}
#ortt
###merge :更改node標 {}新增properties
query = "
MERGE (origin:DBS {name:{origin_name},gg:{origin_name},gginin:{origin_name}})
MERGE (destination:NONDBS {name:{dest_name}})
CREATE (destination)-[:DESTINATION]->(origin)
"
for (i in 1:nrow(data1)) {
  origin_name = data1[i, ]$Origin
  dest_name = data1[i, ]$Dest
  flight_num = data1[i, ]$FlightNum
  
  appendCypher(t,
               query,
               origin_name = origin_name,
               dest_name = dest_name,
               flight_num = flight_num)
  cat("\r",round(i/nrow(data1)*100,2), '%     ')
}
#幹上去neo4j
commit(t)
#畫圖邏輯
cypher(graph, "MATCH (o:DBS) <-[:DESTINATION]-> (d:NONDBS)
       RETURN o.name, d.name")

# ##
# class(greta)
# 
# nicole = createNode(graph, "Person", name="Nicole", age=24)
# greta = createNode(graph, "Person", name="Greta", age=24)
# kenny = createNode(graph, "Person", name="Kenny", age=27)
# shannon = createNode(graph, "Person", name="Shannon", age=23)
# 
# r1 = createRel(greta, "LIKES", nicole, weight=7)
# r2 = createRel(nicole, "LIKES", kenny, weight=1)
# r3 = createRel(kenny, "LIKES", shannon, weight=3)
# r4 = createRel(nicole, "LIKES", shannon, weight=5)
# 
# p = shortestPath(greta, "LIKES", shannon, max_depth=4, cost_property="weight")
# n = nodes(p)
# sapply(n, "[[", "name")
# 
# install.packages("igraph")
# library(igraph)
# query = "
# MATCH (n)-->(m)
# RETURN n.name, m.name
# "
# 
# edgelist = cypher(graph, query)
# ig = graph.data.frame(edgelist, directed=F)
# 
# betweenness(ig)
# closeness(ig)
# 
# plot(ig)
# 
# install.packages("network")
# install.packages("GGally")
# install.packages("sna")
# library(network)
# library(GGally)
# library(sna)
# 
# net = network(edgelist)
# ggnet(net, label.nodes=TRUE)
# install.packages("hflights")
# library(hflights)
# hflights = hflights[sample(nrow(hflights), 100), c("Origin","Dest")]
# row.names(hflights) = NULL
# 
# head(hflights)
# 
# addConstraint(graph, "Carrier", "name")
# addConstraint(graph, "Airport", "name")
# 
# query = "
# CREATE (flight:Flight {number: {FlightNum} })
# SET flight.year = TOINT({Year}),
# flight.month = TOINT({DayofMonth}),
# flight.day = TOINT({DayOfWeek})
# 
# MERGE (carrier:Carrier {name: {UniqueCarrier} })
# CREATE (flight)-[:OPERATED_BY]->(carrier)
# 
# MERGE (origin:Airport {name: {Origin} })
# MERGE (dest:Airport {name: {Dest} })
# 
# CREATE (flight)-[o:ORIGIN]->(origin)
# CREATE (flight)-[d:DESTINATION]->(dest)
# 
# SET o.delay = TOINT({DepDelay}),
# o.taxi_time = TOINT({TaxiOut})
# 
# SET d.delay = TOINT({ArrDelay}),
# d.taxi_time = TOINT({TaxiIn})
# "
# 
# tx = newTransaction(graph)
# 
# for(i in 1:nrow(hflights)) {
#   row = hflights[i, ]
#   
#   appendCypher(tx, query,
#                FlightNum=row$FlightNum,
#                Year=row$Year,
#                DayofMonth=row$DayofMonth,
#                DayOfWeek=row$DayOfWeek,
#                UniqueCarrier=row$UniqueCarrier,
#                Origin=row$Origin,
#                Dest=row$Dest,
#                DepDelay=row$DepDelay,
#                TaxiOut=row$TaxiOut,
#                ArrDelay=row$ArrDelay,
#                TaxiIn=row$TaxiIn)
# }
# 
# commit(tx)
# 
# summary(graph)
# getConstraint(graph)
# getIndex(graph)
# 
# install.packages("visNetwork")
# library(visNetwork)
# 
# visNetwork(n, edgelist)
# 
# tx

