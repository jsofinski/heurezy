using TSPLIB;
using Printf;


function genAsymmetricalRandomTsp(numOfNodes::Int, weightLowerBound::Int, weightUpperBound::Int)
  tsp = readTSPLIB(:gr17)
  name = @sprintf("asymmetrical%d-%d-%d", numOfNodes, weightLowerBound, weightUpperBound)
  dimension = numOfNodes
  weights = zeros(Int64,numOfNodes, numOfNodes)
  for i in 1:numOfNodes
    for j in 1:numOfNodes
      weights[i, j] = rand(weightLowerBound:weightUpperBound)
    end
  end
	return TSP(name, dimension, tsp.weight_type, weights, tsp.nodes, tsp.Dnodes, tsp.ffx, tsp.pfx, 0.0)
end

function genSymmetricalRandomTsp(numOfNodes::Int, weightLowerBound::Int, weightUpperBound::Int)
  tsp = readTSPLIB(:gr17)
  name = @sprintf("symmetrical%d-%d-%d", numOfNodes, weightLowerBound, weightUpperBound)
  dimension = numOfNodes
  weights = zeros(Int64 ,numOfNodes, numOfNodes)
	for i in 1:numOfNodes
		for j in i:numOfNodes
      dist = rand(weightLowerBound:weightUpperBound)
      weights[i, j] = dist
      weights[j, i] = dist
    end
  end
	return TSP(name, dimension, tsp.weight_type, weights, tsp.nodes, tsp.Dnodes, tsp.ffx, tsp.pfx, 0.0)
end

function genEuclidianRandomTsp(numOfNodes::Int, maxX::Int, maxY::Int)
  tsp = readTSPLIB(:berlin52)
  name = @sprintf("euclidian%d-%d-%d", numOfNodes, maxX, maxY)
  dimension = numOfNodes
  weights = zeros(Int64 ,numOfNodes, numOfNodes)
  nodes = zeros(numOfNodes, 2)
  for i in 1:numOfNodes
    nodes[i, 1] = rand(0:maxX)
		nodes[i, 2] = rand(0:maxY)
  end
  for i in 1:numOfNodes
    for j in 1:numOfNodes
			weights[i, j] = round(
				sqrt(
					(nodes[i, 1] - nodes[j, 1])^2 + (nodes[i, 2] - nodes[j, 2])^2
				), RoundNearest
			)
    end
  end
	return TSP(name, dimension, tsp.weight_type, weights, nodes, tsp.Dnodes, tsp.ffx, tsp.pfx, 0.0)
end
