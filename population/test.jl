include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
include("main.jl")

using TSPLIB

function getArray(size) 
    getters = []
    for i in 1:size
        push!(getters, funcGetPopulation)
    end
    return getters
end

function funcGetPopulation()
    tsp = readTSPLIB(:gr24)
    return getPopulation(tsp, 1000)
end

function getPopulation(tsp, sizeOfPopulation) 
    population = Array{Int}[]
    for i in 1:sizeOfPopulation
        tempPath = krandom(tsp, 10)
        # println(tempPath)
        push!(population, tempPath)
        # population[i] = krandom(tsp, 10)
    end
    return population
end

function test() 
end

tsp = readTSPLIB(:gr24)
getPopulation(tsp, 10)

populationSearch(tsp, getArray(1), test, 1000)
println("optimal:")
println(TSPLIB.Optimals[:gr24])