include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
using DataStructures
using Printf
using TSPLIB
using Random
using Pkg

function tabuSearch(tsp, maxIterations, baseFunction, tabuSize)
  tenure = Queue{Tuple{Int, Int}}()
  tenureSet = Set{Tuple{Int, Int}}()
  path = baseFunction(tsp)
  bestPath = path

  # println(objectiveFunction(tsp, bestPath))
  # println(bestPath)


  bestWeight = objectiveFunction(tsp, path) #global best
  # currentWeight = objectiveFunction(tsp, path) #iteration variable
  stopCondition = false
  iterationsWithoutImprovement = 0


  while !stopCondition
    beforeWeight = bestWeight #best weight at the beggining of itetarion
    # if tenureSize is smaller than maxIterations it might not get out of the local minimum
    neighbourhood = allInverts(tsp, bestPath)
    bestCandidate = neighbourhood[1]
    # if neighbourhood[1] is in tenure
    if ((neighbourhood[1].from, neighbourhood[1].to) in tenureSet)
      bestCandidate = InvertResult(neighbourhood[1].from, neighbourhood[1].to, typemax(Float64))
    end
    
    for i in 2:length(neighbourhood)
      if neighbourhood[i].fitness < bestCandidate.fitness && !((neighbourhood[i].from, neighbourhood[i].to) in tenureSet)
        bestCandidate = neighbourhood[i]
      end
    end

    tuple = (bestCandidate.from, bestCandidate.to) 
    # tuple = Tuple(bestCandidate.from, bestCandidate.to) 

    # Check if got any improvement
    # Set iteration best 
    if (bestCandidate.fitness < bestWeight)
      bestWeight = bestCandidate.fitness
      iterationsWithoutImprovement = 0
    end

    push!(tenureSet, tuple)
    enqueue!(tenure, tuple)
    if length(tenureSet) >= tabuSize
      lastTuple = dequeue!(tenure)
      delete!(tenureSet, lastTuple)
    end
    # step closer to stop condition 
    if beforeWeight >= bestCandidate.fitness
      iterationsWithoutImprovement += 1
    end
    # check stopCondition
    if iterationsWithoutImprovement >= maxIterations
      stopCondition = true
    end
  end
  println(objectiveFunction(tsp, bestPath))
  println(bestPath)
end


