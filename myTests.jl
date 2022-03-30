include("algotihms.jl")
include("utils.jl")
include("randomtsp.jl")

NODES_STEP = 10
NODES_START = 20
NODES_LAST = 100
ITERATIONS = 50
K_START = 1
K_LAST = 1000000
K_STEP = 1000
LOWER_BOUND = 10
UPPER_BOUND = 100
MAX_X = 80
MAX_Y = 80

function getKrandom(k)

  function krandomSpecified(tsp)
    krandom(tsp, k)
  end

  return krandomSpecified
end

function test2optKrandomAsymmetrical()
  fileName = "test2optKrandomAsymmetrical.txt"
  file = open(fileName, "w")
  write(file, "numberOfNodes;k;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:50
      randomTsp = genAsymmetricalRandomTsp(numberOfNodes, LOWER_BOUND, UPPER_BOUND)
			k = K_START
			while k <= K_LAST
        krandomAlgorithm = getKrandom(k)
        print(@sprintf("%d, %d , %d\n", numberOfNodes, k, iteration))
        stats = @timed twoOptAlgorithm(randomTsp, krandomAlgorithm)
        write(file, @sprintf("%d;%d;%d;%.10f;%d\n", numberOfNodes, k, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
				k *= K_STEP
      end
    end
  end
  close(file)
end

function test2optKrandomSymmetrical()
  fileName = "test2optKrandomSymmetrical.txt"
  file = open(fileName, "w")
  write(file, "numberOfNodes;k;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:50
      randomTsp = genSymmetricalRandomTsp(numberOfNodes, LOWER_BOUND, UPPER_BOUND)
			k = K_START
			while k <= K_LAST
        krandomAlgorithm = getKrandom(k)
        print(@sprintf("%d, %d , %d\n", numberOfNodes, k, iteration))
        stats = @timed twoOptAlgorithm(randomTsp, krandomAlgorithm)
        write(file, @sprintf("%d;%d;%d;%.10f;%d\n", numberOfNodes, k, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
				k *= K_STEP
      end
    end
  end
  close(file)
end

function test2optKrandomEuclidian()
  fileName = "test2optKrandomEuclidian.txt"
  file = open(fileName, "w")
  write(file, "numberOfNodes;k;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:50
      randomTsp = genEuclidianRandomTsp(numberOfNodes, MAX_X, MAX_Y)
			k = K_START
			while k <= K_LAST
        krandomAlgorithm = getKrandom(k)
        print(@sprintf("%d, %d , %d\n", numberOfNodes, k, iteration))
        stats = @timed twoOptAlgorithm(randomTsp, krandomAlgorithm)
        write(file, @sprintf("%d;%d;%d;%.10f;%d\n", numberOfNodes, k, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
				k *= K_STEP
      end
    end
  end
  close(file)
end

function test2optNeighboursAsymmetrical()
  fileName = "test2optNeighboursAsymmetrical.txt"
  file = open(fileName, "w")
  write(file, "algorithm;numberOfNodes;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:100
      print(@sprintf("2optneighboursAs: %d, %d \n", numberOfNodes, iteration))
      randomTsp = genAsymmetricalRandomTsp(numberOfNodes, LOWER_BOUND, UPPER_BOUND)
      stats = @timed twoOptAlgorithm(randomTsp, closestNeighbourAlgorithm)
      write(file, @sprintf("closest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
      stats = @timed twoOptAlgorithm(randomTsp, betterClosestNeighbourAlgorithm)
      write(file, @sprintf("betterClosest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
    end
  end
  close(file)
end

function test2optNeighboursSymmetrical()
  fileName = "test2optNeighboursSymmetrical.txt"
  file = open(fileName, "w")
  write(file, "algorithm;numberOfNodes;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:100
      print(@sprintf("2optneighboursS: %d, %d\n", numberOfNodes, iteration))
      randomTsp = genSymmetricalRandomTsp(numberOfNodes, LOWER_BOUND, UPPER_BOUND)
      stats = @timed twoOptAlgorithm(randomTsp, closestNeighbourAlgorithm)
      write(file, @sprintf("closest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
      stats = @timed twoOptAlgorithm(randomTsp, betterClosestNeighbourAlgorithm)
      write(file, @sprintf("betterClosest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
    end
  end
  close(file)
end

function test2optNeighboursEuclidian()
  fileName = "test2optNeighboursEuclidian.txt"
  file = open(fileName, "w")
  write(file, "algorithm;numberOfNodes;iteration;time;effectiveness\n")
  for numberOfNodes = NODES_START:NODES_STEP:NODES_LAST
    for iteration = 1:100
      print(@sprintf("2optneighboursE: %d, %d\n", numberOfNodes, iteration))
      randomTsp = genEuclidianRandomTsp(numberOfNodes, MAX_X, MAX_Y)
      stats = @timed twoOptAlgorithm(randomTsp, closestNeighbourAlgorithm)
      write(file, @sprintf("closest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
      stats = @timed twoOptAlgorithm(randomTsp, betterClosestNeighbourAlgorithm)
      write(file, @sprintf("betterClosest;%d;%d;%.10f;%d\n", numberOfNodes, iteration, stats.time, objectiveFunction(randomTsp, stats.value)))
    end
  end
  close(file)

end

test2optKrandomAsymmetrical()
test2optKrandomSymmetrical()
test2optKrandomEuclidian()
#test2optNeighboursAsymmetrical()
#test2optNeighboursSymmetrical()
#test2optNeighboursEuclidian()

