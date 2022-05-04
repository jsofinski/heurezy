include("main.jl")

function allInvertTest()
  tsp = readTSPLIB(:gr24)
  display(allInverts(tsp, [1,2,3, 4, 5, 6, 7, 8]))
end
function test() 
    tsp = readTSPLIB(:gr24)
    tabuSearch(tsp,200,betterClosestNeighbourAlgorithm)
end


allInvertTest()
