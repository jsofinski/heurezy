include("utils.jl")
# include("draw.jl")
include("randomtsp.jl")
include("algotihms.jl")


tsp = readTSPLIB(:gr24)
path = [16, 11, 3, 7, 6, 24, 8, 21, 5, 10, 17, 22, 18, 19, 15, 2, 20, 14, 13, 9, 23, 4, 12, 1]


# 1
# read full_matrix, lower_diag_row, euc_2d  tsp = readTSPLIB(:gr24)

# 2
# randomtsp.jl

# 3
# print full_matrix     display(tsp.weights)
# print euc_2d          display(tsp.nodes)
# display(tsp.nodes)
# display(tsp.weights)

# 4
# printCycle(path)

# euc_2d only, 
# baygPath = [1,28,6,12,9,26,3,29,5,21,2,20,10,4,15,18,14,17,22,11,19,25,7,23,8,27,16,13,24]
# baygTsp = readTSPLIB(:bayg29)
# display(baygTsp.nodes)
# drawCycle(baygTsp.nodes, baygPath, "test.png")
# berlinPath = [1,49,32,45,19,41,8,9,10,43,33,51,11,52,14,13,47,26,27,28,12,25,4,6,15,5,24,48,38,37,40,39,36,35,34,44,46,16,29,50,20,23,30,2,7,42,21,17,3,18,31,22]
# berlinTsp = readTSPLIB(:berlin52)
# drawCycle(eucTsp, berlinPath, "test.png")

# 5
# objectiveFunction(tsp, path)

# 6
# println(PRD(1278, 1100))
# println(PRDString(1278, 1100))





# Optimal
println("Optimal:")
println(path)
println(TSPLIB.Optimals[:gr24])


# 1 k-random
newPath = krandom(tsp, 20000)
println("Krandom:")
println(newPath)
println(objectiveFunction(tsp, newPath))

# 2 najbliższego sąsiada
newPath = closestNeighbourAlgorithm(tsp)
println("Closest neighbour:")
println(newPath)
println(objectiveFunction(tsp, newPath))


# 3 rozszerzona najbliższego sąsiada
newPath = betterClosestNeighbourAlgorithm(tsp)
println("Better closest neighbour:")
println(newPath)
println(objectiveFunction(tsp, newPath))


# 2opt
newPath = twoOptAlgorithm(tsp, closestNeighbourAlgorithm)
println("2 opt:")
println(newPath)
println(objectiveFunction(tsp, newPath))
