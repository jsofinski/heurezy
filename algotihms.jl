using TSPLIB;
using Random;
using Printf;
include("utils.jl")


function krandom(tsp, k)
  dimension = size(tsp.weights)[1]
  solutions = Vector{Vector{Int64}}(undef, k)
  allNodes = Vector(1:dimension)
  for i in 1:k
    solutions[i] = shuffle(allNodes)
  end
  bestK = 1
  minCost = objectiveFunction(tsp, solutions[1])
  for i in 2:k
    cost = objectiveFunction(tsp, solutions[i])
    if cost < minCost
      minCost = cost
      bestK = i
    end
  end
  return solutions[bestK]
end


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
  bestPathLength = 0
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

function twoOptAlgorithm(tsp, baseFunction)
  mySize = size(tsp.weights, 1)
  path = baseFunction(tsp)

  bestI = 1
  bestJ = 1
  beforeValue = 0
  bestWeight = objectiveFunction(tsp, path)
  currentWeight = objectiveFunction(tsp, path)

  while beforeValue != bestWeight
    beforeValue = bestWeight
    for i in 1:mySize
      for j in i+1:mySize
        # println(beforeValue)
        currentPath = copy(path)
        currentPath = invert(currentPath, i, j)
        difference = 0
        leftI = i-1
        if leftI == 0
            leftI = mySize
        end
        rightI = i+1
        leftJ = j-1
        rightJ = j+1
        if rightJ > mySize 
            rightJ = 1
        end
        difference -= tsp.weights[currentPath[leftI], currentPath[i]]
        difference -= tsp.weights[currentPath[j], currentPath[rightJ]]
    
        difference += tsp.weights[currentPath[leftI], currentPath[j]]
        difference += tsp.weights[currentPath[i], currentPath[rightJ]]
        currentWeight = beforeValue - difference
        # println(difference)
        # currentWeight = objectiveFunction(tsp, currentPath)

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
    path = invert(path, bestI, bestJ)
    # println(objectiveFunction(tsp, path))
  end
  return path
end
