using TSPLIB;
using Printf;


function genAsymmetricalRandomTsp(numOfNodes::Int, weightLowerBound::Int, weightUpperBound::Int)
  tsp = readTSPLIB(:gr17)
  tsp.name = @sprintf("asymmetrical%d-%d-%d", numOfNodes, weightLowerBound, weightUpperBound)
  tsp.dimension = numOfNodes
  tsp.weights = zeros(numOfNodes, numOfNodes)
  tsp.optimal = 0.0
  for i in 0:numOfNodes
    for j in 0:numOfNodes
      tsp.weights[i][j] = rand(weightLowerBound:weightUpperBound)
    end
  end
  return tsp
end

function genSymmetricalRandomTsp(numOfNodes::Int, weightLowerBound::Int, weightUpperBound::Int)
  tsp = readTSPLIB(:gr17)
  tsp.name = @sprintf("symmetrical%d-%d-%d", numOfNodes, weightLowerBound, weightUpperBound)
  tsp.dimension = numOfNodes
  tsp.weights = zeros(numOfNodes, numOfNodes)
  tsp.optimal = 0.0
  for i in 0:(numOfNodes+1)/2
    for j in 0:(numOfNodes+1)/2
      dist = rand(weightLowerBound:weightUpperBound)
      tsp.weights[i][j] = dist
      tsp.weights[j][i] = dist
    end
  end
  return tsp
end

function genEuclidianRandomTsp(numOfNodes::Int, maxX::Int, maxY::Int)
  tsp = readTSPLIB(:berlin52)
  tsp.name = @sprintf("euclidian%d-%d-%d", numOfNodes, maxX, maxY)
  tsp.dimension = numOfNodes
  tsp.weights = zeros(numOfNodes, numOfNodes)
  tsp.optimal = 0.0
  tsp.nodes = zeros(numOfNodes, 2)
  for i in 0:numOfNodes
    tsp.nodes[i, 0] = rand(0:maxX)
		tsp.nodes[i, 1] = rand(0:maxY)
  end
  for i in 0:numOfNodes
    for j in 0:numOfNodes
			tsp.weights[i][j] = round(
				sqrt(
					(tsp.nodes[i, 0] - tsp.nodes[j, 0])^2 + (tsp.nodes[i, 1] - tsp.nodes[j, 1])^2
				), RoundNearest
			)
    end
  end
  return tsp
end
