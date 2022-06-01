include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")

using TSPLIB


# tsp - tsp instance from TSPLIB
# islandGetters - array of functions: () -> Array<Array<Int>>, function with index i returns the base population of island i. The most basic one is a random population generator.
# memify - function (tsp, path) -> path, takes the path and tries to make it better. The most basic case is an identity function.
# maxIterations - stop condition
function populationSearch(tsp, islandGetters, memify, maxIterations)
  islands = Array{Array{Int}}[]
  for i in 1:length(islandGetters)
		push!(islands, islandGetters[i]())
  end
end
