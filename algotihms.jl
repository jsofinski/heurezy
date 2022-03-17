using TSPLIB;
using Printf;
include("utils.jl")




function closestNeighbourAlgorithm(tsp)
    startPosition = 1
    mySize = size(tsp.weights, 1) 
    cycle = zeros(Int, mySize, 1)
    banned = ones(Int, mySize, 1)
    cycle[1] = startPosition
    banned[startPosition] = 1

    currentPostion = startPosition
    
    for i in 2:mySize 
        cycle[i] = getClosestNeighbourBanned(tsp, currentPostion, banned)
        currentPostion = cycle[i]
        banned[currentPostion] = 0
    end

    return cycle
end  

function betterClosestNeighbourAlgorithm(tsp)
    mySize = size(tsp.weights, 1) 
    bestPath = zeros(Int, mySize, 1)
    bestPathLength = 0;
    for i in 1:mySize
        startPosition = i
        currentCycle = zeros(Int, mySize, 1)
        currentCycle[1] = startPosition
        banned = ones(Int, mySize, 1)
        banned[startPosition] = 1

        currentPostion = startPosition
        
        for i in 2:mySize 
            currentCycle[i] = getClosestNeighbourBanned(tsp, currentPostion, banned)
            currentPostion = currentCycle[i]
            banned[currentPostion] = 0
        end

        currentPathLength = objectiveFunction(tsp, currentCycle)
        if bestPathLength == 0 || bestPathLength > currentPathLength
            bestPath = currentCycle
            bestPathLength = currentPathLength
        end
    end
    return bestPath
end  

# DOESNT WORK YET
function twoOptAlgorithm(tsp)
    mySize = size(tsp.weights, 1)
    path = [1:mySize;]
    # println(path)

    bestI = 1
    bestJ = 2
    bestWeight = objectiveFunction(tsp, path)
    currentWeight = objectiveFunction(tsp, path)
    while true
        for i in 1:mySize
            for j in i+1:mySize
                currentPath = path
                currentPath = swapNodesInPath(currentPath, path[i], path[j])
                currentWeight = objectiveFunction(tsp, currentPath) 
                # println(bestJ == j)
                # println(j, " ", typeof(j), " ", bestJ, " ", typeof(bestJ) )
                if (currentWeight < bestWeight)
                    bestWeight = currentWeight
                    bestI = path[i]
                    bestJ = path[j]
                end
            end
        end
        if currentWeight == bestWeight
            break
        end
        path = swapNodesInPath(path, bestI, bestJ)
        println(path)
    end
    return path
end  