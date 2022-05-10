include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
using DataStructures
using Printf
using TSPLIB
using Random
using Pkg

struct LongTermMemoryObject
  path::Vector{Int64}
  localBestPath::Vector{Int64}
  localBestWeight::Float64
end

function tabuSearch(tsp, maxIterations, baseFunction, tabuSize, allIterationsMax)
	println("starting tabu search")
  tenure = Queue{Tuple{Int,Int}}()
  tenureSet = Set{Tuple{Int,Int}}()
  longTermMemory = Queue{LongTermMemoryObject}()
  path = baseFunction(tsp)
  bestPath = path
  globalBestPath = path
  nextPath = path
  allIterations = 0

  # println(objectiveFunction(tsp, bestPath))
  # println(bestPath)

  bestWeight = objectiveFunction(tsp, path) #local best
  globalBestWeight = bestWeight

  # currentWeight = objectiveFunction(tsp, path) #iteration variable
  stopCondition = false
  iterationsWithoutImprovement = 0


  while !stopCondition
    allIterations += 1
    beforeWeight = bestWeight #best weight at the beggining of itetarion
    # if tenureSize is smaller than maxIterations it might not get out of the local minimum
    neighbourhood = allInverts(tsp, nextPath)
    bestCandidate = neighbourhood[1]
    # if neighbourhood[1] is in tenure
    if ((neighbourhood[1].from, neighbourhood[1].to) in tenureSet)
      bestCandidate = InvertResult(neighbourhood[1].from, neighbourhood[1].to, typemax(Float64))
    end

    for i in 2:length(neighbourhood)
      if !((neighbourhood[i].from, neighbourhood[i].to) in tenureSet)
        if neighbourhood[i].fitness < bestCandidate.fitness
          newRecord = LongTermMemoryObject(
            invert(deepcopy(nextPath), neighbourhood[i].from, neighbourhood[i].to),
            deepcopy(bestPath),
            bestWeight)
          enqueue!(longTermMemory, newRecord)
        end
        if neighbourhood[i].fitness < bestCandidate.fitness
          bestCandidate = neighbourhood[i]
        end
      end
    end

    tuple = (bestCandidate.from, bestCandidate.to)
    # tuple = Tuple(bestCandidate.from, bestCandidate.to) 

    # Check if got any improvement
    # Set iteration best 
    nextPath = invert(nextPath, bestCandidate.from, bestCandidate.to)
    if (bestCandidate.fitness < bestWeight)
      bestWeight = bestCandidate.fitness
      bestPath = nextPath
      iterationsWithoutImprovement = 0
      if bestWeight < globalBestWeight
        globalBestWeight = bestWeight
				globalBestPath = deepcopy(nextPath)
      end
    else
      iterationsWithoutImprovement += 1
    end

    push!(tenureSet, tuple)
    enqueue!(tenure, tuple)
    if length(tenureSet) >= tabuSize
      lastTuple = dequeue!(tenure)
      delete!(tenureSet, lastTuple)
    end


    # check stopCondition
    if iterationsWithoutImprovement >= maxIterations
      if !isempty(longTermMemory)
        previousRecord = dequeue!(longTermMemory)
        nextPath = previousRecord.path
        bestPath = previousRecord.localBestPath
        bestWeight = previousRecord.localBestWeight
      else
        stopCondition = true
      end
    end

    if allIterations >= allIterationsMax
      stopCondition = true
    end

  end
  println(objectiveFunction(tsp, globalBestPath))
  println(globalBestPath)
end


