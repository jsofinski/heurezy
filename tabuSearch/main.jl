include("../utils.jl")
include("../algotihms.jl")
using DataStructures
using Printf
using TSPLIB
using Random
using Pkg
Pkg.add("DataStructures");
using DataStructures;

function tabuSearch(tsp, maxIterations, baseFunction) 
    tenure = Queue(Int)
    path = baseFunction(tsp)
    bestPath = path

    bestWeight = objectiveFunction(tsp, path) #global best
    currentWeight = objectiveFunction(tsp, path) #iteration variable
    stopCondition = false
    iterationsWithoutImprovement = 0

    
    while !stopCondition 
        beforeWeight = bestWeight #best weight at the beggining of itetarion
        iterationBestWeight = currentWeight #to check if improvement has been made


        # step closer to stop condition 
        if beforeWeight >= iterationBestWeight
            iterationsWithoutImprovement += 1
        end
        # check stopCondition
        if iterationsWithoutImprovement >= maxIterations
            stopCondition = true
        end
    end
    
end


