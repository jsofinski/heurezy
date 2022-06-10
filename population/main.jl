include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")

using TSPLIB


# tsp - tsp instance from TSPLIB
# islandGetters - array of functions: () -> Array<Array<Int>>, function with index i returns the base population of island i. 
# The most basic one is a random population generator.
# memify - function (tsp, path) -> path, takes the path and tries to make it better. The most basic case is an identity function.
# maxIterations - stop condition
function populationSearch(tsp, islandGetters, memify, maxIterations)
  iteration = 0
  islands = Array{Array{Int}}[]
  for i in 1:length(islandGetters)
		push!(islands, islandGetters[i]())
  end


  currentIsland = islands[1]
  bestPath = currentIsland[1]
  
  bestFitness = objectiveFunction(tsp, currentIsland[1])
  bestIndex = 1
  for i in 2:length(currentIsland)
    if objectiveFunction(tsp, currentIsland[i]) < bestFitness
      bestIndex = i
      bestFitness = objectiveFunction(tsp, currentIsland[i])
    end
  end
  bestPath = currentIsland[bestIndex]
  println("Best fitness in first generation:")
  println(bestFitness)
  println(currentIsland[bestIndex])

  while true 
    # some crossover

    tempPath = orderedCrossover(currentIsland[1], currentIsland[2])
    # println(currentIsland[1])
    # println(currentIsland[2])
    # println(tempPath[1])
    # println(tempPath[2])

    size = length(currentIsland)
    for i in 1:size 
      randFirst = rand(1:size)
      randSecond = rand(1:size)
      tempchildren = orderedCrossover(currentIsland[randFirst], currentIsland[randSecond])
      

      # mutacja
      randFirst = rand(1:length(tempchildren[1]))
      randSecond = rand(1:length(tempchildren[1]))
      tempchildren[1] = swapNodesInPath(tempchildren[1], randFirst, randSecond)
      tempchildren[2] = swapNodesInPath(tempchildren[2], randFirst, randSecond)

      push!(currentIsland, tempchildren[1])
      push!(currentIsland, tempchildren[2])
    end
    
    # memify child
    

    # check maxIterations
    iteration += 1
    if iteration >= maxIterations
      println("koniec, tutej mozna wybrac najlepsza sciezke elo")
      bestFitness = objectiveFunction(tsp, currentIsland[1])
      bestIndex = 1
      for i in 2:length(currentIsland)
        println(objectiveFunction(tsp, currentIsland[i]))
        if objectiveFunction(tsp, currentIsland[i]) < bestFitness
          bestIndex = i
          bestFitness = objectiveFunction(tsp, currentIsland[i])
        end
      end
      println(bestFitness)
      println(currentIsland[bestIndex])
      break
    end

    # selection -> tournament: get random 2 paths and remove worse, should be faster than sorting, idk
    while length(currentIsland) > size 
      randFirst = rand(1:length(currentIsland))
      randSecond = rand(1:length(currentIsland))
      if objectiveFunction(tsp, currentIsland[randFirst]) < objectiveFunction(tsp, currentIsland[randSecond])
        deleteat!(currentIsland, randSecond)
      else 
        deleteat!(currentIsland, randFirst)
      end
    end

  end

  return bestPath

end




function orderedCrossover(firstParent, secondParent)
  size = length(firstParent)
  firstChild = zeros(Int, size, 1)
  secondChild = zeros(Int, size, 1)

  randPos = Int(rand(size*1/3:size*2/3))
  # println(randPos)
  for i in 1:randPos
    firstChild[i] = firstParent[i]
    secondChild[i] = secondParent[i]
  end

  for i in randPos:size-1
    currentNodeFirst = firstChild[i]
    currentNodeSecond = secondChild[i]

    j = 1
    while secondParent[j] != currentNodeFirst
      j += 1
    end
    j += 1 
    if j > size 
      j = 1
    end
    while (secondParent[j] in firstChild)
      j += 1 
      if j > size 
        j = 1
      end       
    end 
    firstChild[i+1] = secondParent[j]

    j = 1
    while firstParent[j] != currentNodeSecond
      j += 1
    end
    j += 1 
    if j > size 
      j = 1
    end
    while (firstParent[j] in secondChild)
      j += 1  
      if j > size 
        j = 1
      end 
    end 
    secondChild[i+1] = firstParent[j]
  end

  return [firstChild, secondChild]
end