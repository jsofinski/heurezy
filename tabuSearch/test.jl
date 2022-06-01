include("main.jl")

function getKrandom(k)

  function krandomSpecified(tsp)
    krandom(tsp, k)
  end

  return krandomSpecified
end

function allInvertTest()
  tsp = readTSPLIB(:gr24)
  display(allInverts(tsp, [1, 2, 3, 4, 5, 6, 7, 8]))
end
function test()
  tsp = readTSPLIB(:gr24)
  tabuSearch(tsp, 1000, getKrandom(2), 200, 1000)
  println(tsp.optimal)
end

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

functions = [
  betterClosestNeighbourAlgorithm,
  closestNeighbourAlgorithm,
  getKrandom(1000)
]

functionNames = [
  "Better Closest Neighbour",
  "Closest Neighbour",
  "Krandom - 1000"
]

tabuSizes = [
  n -> 5,
  n -> 7,
  n -> Int(floor(sqrt(n))),
  n -> n
]

tabuNames = [
  "5",
  "7",
	"sqrt(n)",
  "n"
]

stagnationsIterations = [10, 100, 1000]
stopIterations = [100, 1000, 10000]

function testTspGr()
  fileName = "tspGraphsWithOptimalValues.txt"
  file = open(fileName, "w")
  write(file, "graphName;baseFunction;tabuSize;stagnationIterations;stopIterations;time;resultPathCost;optimalPathCost\n")
  for tspIndx = 1:length(tsps)
    for funcIndx = 1:length(functions)
      for tabuIndx = 1:length(tabuNames)
        for stopIterationsIndx = 1:length(stopIterations)
          for stagnationsIterationsIndx = 1:length(stagnationsIterations)
            print(@sprintf("%s ,%s, %s, %d , %d\n",
              tspsNames[tspIndx],
							functionNames[funcIndx],
							tabuNames[tabuIndx],
              stopIterations[stopIterationsIndx],
              stagnationsIterations[stagnationsIterationsIndx]))

            stats = @timed tabuSearch(
              tsps[tspIndx],
              stagnationsIterations[stagnationsIterationsIndx],
              functions[funcIndx],
              tabuSizes[tabuIndx](size(tsps[tspIndx].weights)[1]),
              stopIterations[stopIterationsIndx]
            )


            write(file, @sprintf("%s;%s;%s;%d;%d;%.10f;%d;%f\n",
              tspsNames[tspIndx],
              functionNames[funcIndx],
              tabuNames[tabuIndx],
              stagnationsIterations[stagnationsIterationsIndx],
              stopIterations[stopIterationsIndx],
              stats.time,
              stats.value,
              tsps[tspIndx].optimal))
          end
        end
      end
    end
  end
  close(file)
end

graphTypes = [
  ("Assymetrical", n -> genAsymmetricalRandomTsp(n, 20, 100)),
  ("Symmetrical", n -> genSymmetricalRandomTsp(n, 20, 100)),
  ("Euclidian", n -> genEuclidianRandomTsp(n, 10 * n, 10 * n)),
]

function testRandomGraphs()
  fileName = "tspRandomGraphs100.txt"
  file = open(fileName, "w")
  write(file, "graphType;numberOfNodes;baseFunction;tabuSize;stagnationIterations;stopIterations;time;resultPathCost\n")
  for numberOfNodes = 100:20:200
      for graphIndx = 1:length(graphTypes)
        tsp = graphTypes[graphIndx][2](numberOfNodes)
        for funcIndx = 1:length(functions)
          for tabuIndx = 1:length(tabuNames)
            for stopIterationsIndx = 1:length(stopIterations)
              for stagnationsIterationsIndx = 1:length(stagnationsIterations)
                print(@sprintf("%s ,%s, %s, %d, %d, %d\n",
									graphTypes[graphIndx][1],
									functionNames[funcIndx],
									tabuNames[tabuIndx],
                  numberOfNodes,
                  stopIterations[stopIterationsIndx],
                  stagnationsIterations[stagnationsIterationsIndx]))

                stats = @timed tabuSearch(
                  tsp,
                  stagnationsIterations[stagnationsIterationsIndx],
                  functions[funcIndx],
                  tabuSizes[tabuIndx](size(tsp.weights)[1]),
                  stopIterations[stopIterationsIndx]
                )


                write(file, @sprintf("%s;%d;%s;%s;%d;%d;%.10f;%d\n",
                  graphTypes[graphIndx][1],
                  numberOfNodes,
                  functionNames[funcIndx],
                  tabuNames[tabuIndx],
                  stagnationsIterations[stagnationsIterationsIndx],
                  stopIterations[stopIterationsIndx],
                  stats.time,
                  stats.value))
              end
            end
          end
        end
    end
  end
  close(file)
end
# allInvertTest()
#testTspGr()
testRandomGraphs()
