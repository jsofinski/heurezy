include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
include("main.jl")

using TSPLIB

function getArray(NOislands) 
    getters = []
    for i in 1:NOislands
        push!(getters, funcGetPopulation)
    end
    return getters
end

function funcGetPopulation(size)
    tsp = readTSPLIB(:gr24)
    return getPopulation(tsp, size)
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

populationSearch(tsp, getArray(3), test, 100, 1000)
println("optimal:")
println(TSPLIB.Optimals[:gr24])