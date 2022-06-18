include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")

using TSPLIB


# tsp - tsp instance from TSPLIB
# islandGetters - array of functions: () -> Array<Array<Int>>, function with index i returns the base population of island i. 
# The most basic one is a random population generator.
# memify - function (tsp, path) -> path, takes the path and tries to make it better. The most basic case is an identity function.
# maxIterations - stop condition
function populationSearch(tsp, islandGetters, crossoverFunc, memify, maxIterations, migrationIterations, populationSize, toMigrate)
  iteration = 0
  islands = Array{Array{Int}}[]
  for i in 1:length(islandGetters)
		push!(islands, islandGetters[i](populationSize))
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
  #println("Best fitness in first generation:")
  #println(bestFitness)
  #println(currentIsland[bestIndex])

  NOIslands = length(islands)
  while true 
    # some crossover


    # tempchildren = partiallyMappedCrossover(currentIsland[1], currentIsland[2])
    # tempchildren = partiallyMappedCrossover([1,2,3,4,5,6,7,8,9], [3,1,6,2,8,7,4,5,9])
    # println(currentIsland[1])
    # println(currentIsland[2])
    # println(tempchildren[1])
    # println(tempchildren[2])
    # break
    
    for i in 1:NOIslands
      currentIsland = islands[i]
      size = length(currentIsland)
      for j in 1:size 
        randFirst = rand(1:size)
        randSecond = rand(1:size)
        # tempchildren = partiallyMappedCrossover(currentIsland[randFirst], currentIsland[randSecond])
        tempchildren = crossoverFunc(currentIsland[randFirst], currentIsland[randSecond])

        # mutacja
        randFirst = rand(1:length(tempchildren[1]))
        randSecond = rand(1:length(tempchildren[1]))
        tempchildren[1] = swapNodesInPath(tempchildren[1], randFirst, randSecond)
        tempchildren[2] = swapNodesInPath(tempchildren[2], randFirst, randSecond)
				memify(tsp, tempchildren[1])
				memify(tsp, tempchildren[2])
        # println(tempchildren[1])
        push!(currentIsland, tempchildren[1])
        push!(currentIsland, tempchildren[2])
      end
    end

    # check maxIterations
    iteration += 1

		if toMigrate && (iteration % migrationIterations == 0)
			popsToMigrate = max(populationSize / 10, 1)
			for i in 1:NOIslands
				for j in 1:popsToMigrate
					fromIndex = rand(1:length(islands[i]))
					newIslandIndex = rand(1:length(islands))
					push!(islands[newIslandIndex], islands[i][fromIndex])
					deleteat!(islands[i], fromIndex)
				end
			end
		end
    
    if iteration >= maxIterations
      #println("koniec, tutej mozna wybrac najlepsza sciezke elo")
      for i in 1:NOIslands
        currentIsland = islands[i]
        bestFitness = objectiveFunction(tsp, currentIsland[1])
        bestIndex = 1
        currentIsland = islands[i]
        for i in 2:length(currentIsland)
          if objectiveFunction(tsp, currentIsland[i]) < bestFitness
            bestIndex = i
            bestFitness = objectiveFunction(tsp, currentIsland[i])
          end
        end
        #println("Island: ", i)
        #println(bestFitness)
        #println(currentIsland[bestIndex])
      end
    break

    end

    # selection -> tournament: get random 2 paths and remove worse, should be faster than sorting, idk
    for i in 1:NOIslands
      currentIsland = islands[i]
      while (length(currentIsland) > populationSize)
        randFirst = rand(1:populationSize)
        randSecond = rand(1:populationSize)
        if objectiveFunction(tsp, currentIsland[randFirst]) < objectiveFunction(tsp, currentIsland[randSecond])
          deleteat!(currentIsland, randSecond)
        else 
          deleteat!(currentIsland, randFirst)
        end
      end
    end

  end

  return bestPath

end




function orderedCrossover(firstParent, secondParent)
  size = length(firstParent)
  firstChild = zeros(Int, size, 1)
  secondChild = zeros(Int, size, 1)

	randPos = Int(round(rand(size*1/3:size*2/3)))
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

function partiallyMappedCrossover(firstParent, secondParent)
  size = length(firstParent)
  firstChild = zeros(Int, size, 1)
  secondChild = zeros(Int, size, 1)


  randPos = Int(floor(rand(size/3:(size-size/3))))
  firstMap = zeros(Int, randPos, 1)
  secondMap = zeros(Int, randPos, 1)
  # println(randPos)
  
  for i in 1:randPos
    firstChild[i] = firstParent[i]
    secondChild[i] = secondParent[i]
    firstMap[i] = firstParent[i]
    secondMap[i] = secondParent[i]
  end

  for i in randPos+1:size
    temp = secondParent[i]
    while temp in firstMap
      for j in 1:randPos
        if temp == firstMap[j]
          temp = secondMap[j]
          break
        end
      end
    end
    firstChild[i] = temp

    temp = firstParent[i]
    while temp in secondMap
      for j in 1:randPos
        if temp == secondMap[j]
          temp = firstMap[j]
          break
        end
      end
    end
    secondChild[i] = temp

  end

  return [firstChild, secondChild]
end
