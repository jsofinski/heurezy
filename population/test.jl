include("../utils.jl")
include("../algotihms.jl")
include("../randomtsp.jl")
include("main.jl")

using TSPLIB

function getArray(tsp, NOislands)
  getters = []
  for i in 1:NOislands
    push!(getters, (size) -> getPopulation(tsp, size))
  end
  return getters
end
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
    tempPath = krandom(tsp, 1)
    # println(tempPath)
    push!(population, tempPath)
    # population[i] = krandom(tsp, 10)
  end
  return population
end

function test() end

graphTypes = [
  ("Assymetrical", n -> genAsymmetricalRandomTsp(n, 20, 100)),
  ("Symmetrical", n -> genSymmetricalRandomTsp(n, 20, 100)),
  ("Euclidian", n -> genEuclidianRandomTsp(n, 10 * n, 10 * n)),
]

crossoverTypes = [
  ("Ordered crossover", orderedCrossover),
  ("Partialy mapped crossover", partiallyMappedCrossover),
]


stopIterations = [100, 1000, 10000]
migrationIterations = [0, 10, 100, 1000]
toMigrate = [false, true, true, true]
numberOfIslands = [20, 40, 60, 80, 100]
populationSize = [20, 40, 60, 80, 100]

tsps = [
  readTSPLIB(:gr17),
  readTSPLIB(:gr21),
  readTSPLIB(:gr48),
  readTSPLIB(:gr120),
  readTSPLIB(:gr202)
]

tspsNames = [
  "gr17",
  "gr21",
  "gr48",
  "gr120",
  "gr202"
]

function mem(tsp, path)
  return
end

function testTspGraphs()
  fileName = "tspGraphsWithOptimals.txt"
  file = open(fileName, "w")
  write(file, "graphName;crossoverTypes;migrationIterations;numberOfIslands;populationSize;stopIterations;time;resultPathCost;optimal\n")
  for tspIndx = 1:length(tsps)
    for crossoverIndx = 1:length(crossoverTypes)
      for numberOfIslandsIndx = 1:length(numberOfIslands)
        for popSizeIndx = 1:length(populationSize)
          for stopIterationsIndx = 1:length(stopIterations)
            for migrationIndx = 1:length(migrationIterations)
							if migrationIterations[migrationIndx] >= stopIterations[stopIterationsIndx]
                continue
              end
              print(@sprintf("%s ,%s, %d, %d, %d, %d\n",
                tspsNames[tspIndx],
                crossoverTypes[crossoverIndx][1],
                stopIterations[stopIterationsIndx],
                migrationIterations[migrationIndx],
                numberOfIslands[numberOfIslandsIndx],
                populationSize[popSizeIndx]
              ))

              stats = @timed populationSearch(tsps[tspIndx],
                getArray(tsps[tspIndx], numberOfIslands[numberOfIslandsIndx]),
                crossoverTypes[crossoverIndx][2],
                mem,
                stopIterations[stopIterationsIndx],
                migrationIterations[migrationIndx],
                populationSize[popSizeIndx],
								toMigrate[migrationIndx]
              )


              write(file, @sprintf("%s;%s;%d;%d;%d;%d;%.10f;%d;%d\n",
                tspsNames[tspIndx],
                crossoverTypes[crossoverIndx][1],
                migrationIterations[migrationIndx],
                numberOfIslands[numberOfIslandsIndx],
                populationSize[popSizeIndx],
                stopIterations[stopIterationsIndx],
                stats.time,
                objectiveFunction(tsps[tspIndx], stats.value),
                tsps[tspIndx].optimal))
            end
          end
        end
      end
    end
  end
  close(file)
end

function testRandomGraphs()
  fileName = "tspRandomGraphs100.txt"
  file = open(fileName, "w")
  write(file, "graphType;numberOfNodes;crossoverTypes;migrationIterations;numberOfIslands;populationSize;stopIterations;time;resultPathCost\n")
  for numberOfNodes = 100:20:200
    for graphIndx = 1:length(graphTypes)
      tsp = graphTypes[graphIndx][2](numberOfNodes)
      for crossoverIndx = 1:length(crossoverTypes)
        for numberOfIslandsIndx = 1:length(numberOfIslands)
          for popSizeIndx = 1:length(populationSize)
            for stopIterationsIndx = 1:length(stopIterations)
              for migrationIndx = 1:length(migrationIterations)
                if migrationIndx >= stopIterationsIndx
                  continue
                end
                print(@sprintf("%s ,%s, %d, %d, %d, %d, %d\n",
                  graphTypes[graphIndx][1],
                  crossoverTypes[crossoverIndx][1],
                  numberOfNodes,
                  stopIterations[stopIterationsIndx],
                  migrationIterations[migrationIndx],
                  numberOfIslands[numberOfIslandsIndx],
                  populationSize[popSizeIndx]
                ))

                stats = @timed populationSearch(tsp,
                  getArray(tsp, numberOfIslands[numberOfIslandsIndx]),
                  crossoverTypes[crossoverIndx][2],
                  mem,
                  stopIterations[stopIterationsIndx],
                  migrationIterations[migrationIndx],
                  populationSize[popSizeIndx]
                )


                write(file, @sprintf("%s;%d;%s;%d;%d;%d;%d;%.10f;%d\n",
                  graphTypes[graphIndx][1],
                  numberOfNodes,
                  crossoverTypes[crossoverIndx][1],
                  migrationIterations[migrationIndx],
                  numberOfIslands[numberOfIslandsIndx],
                  populationSize[popSizeIndx],
                  stopIterations[stopIterationsIndx],
                  stats.time,
                  objectiveFunction(tsp, stats.value)))
              end
            end
          end
        end
      end
    end
  end
  close(file)
end

testTspGraphs()
testRandomGraphs()

