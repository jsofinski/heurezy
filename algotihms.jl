using TSPLIB;
using Printf;
include("utils.jl")




function closestNeighbourAlgorithm(tsp)
    startPosition = 1
    mySize = size(tsp.weights, 1) 
    cycle = [1:mySize;]
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
    bestPath = [1:mySize;]
    bestPathLength = 0;
    for i in 1:mySize
        startPosition = i
        currentCycle = [1:mySize;]
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

function twoOptAlgorithm(tsp)
    mySize = size(tsp.weights, 1)
    path = [1:mySize;]
    
    bestI = 1
    bestJ = 1
    beforeValue = 0
    bestWeight = objectiveFunction(tsp, path)
    currentWeight = objectiveFunction(tsp, path)

    while beforeValue != bestWeight
        beforeValue = bestWeight
        for i in 1:mySize
            for j in i+1:mySize
                currentPath = copy(path)
                currentPath = swapNodesInPath(currentPath, i, j)
                currentWeight = objectiveFunction(tsp, currentPath) 
                if (currentWeight <= bestWeight)
                    bestWeight = currentWeight
                    bestI = i
                    bestJ = j
                end
                # print(currentWeight, " ")
                # println(bestWeight)
            end
        end
        # println(path)
        path = swapNodesInPath(path, bestI, bestJ)
        # println(objectiveFunction(tsp, path))
    end
    return path
end  