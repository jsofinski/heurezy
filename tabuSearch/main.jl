include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
using DataStructures
using Printf
using TSPLIB
using Random
using Pkg

function tabuSearch(tsp, maxIterations, baseFunction, tabuSize)
  tenure = Queue{Tuple{Int}}()
  tenureSet = Set{Tuple{Int}}()
  path = baseFunction(tsp)
  bestPath = path

  bestWeight = objectiveFunction(tsp, path) #global best
  currentWeight = objectiveFunction(tsp, path) #iteration variable
  stopCondition = false
  iterationsWithoutImprovement = 0


  while !stopCondition
    beforeWeight = bestWeight #best weight at the beggining of itetarion
    iterationBestWeight = currentWeight #to check if improvement has been made
    neighbourhood = allInverts(tsp, path)
    bestCandidate = neighbourhood[0]
    for i in 2:length(neighbourhood)
      if neighbourhood[i].fitness < bestCandidate.fitness && !(Tuple(neighbourhood[i].from, neighbourhood[i].to) in tenureSet)
        bestCandidate = neighbourhood[i]
      end
    end

    tuple = Tuple(bestCandidate.from, bestCandidate.to) 
    push!(tenureSet, tuple)
    enqueue!(tenure, tuple)
    if length(tenureSet) >= tabuSize
      lastTuple = dequeue!(tenure)
      delete!(tenureSet, lastTuple)
    end
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


