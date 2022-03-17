using TSPLIB;
using Printf;

function objectiveFunction(tsp, path)  
    length = 0.0
    for i in 1:size(path,1)-1
        length += tsp.weights[path[i], path[i+1]]
    end
    length += tsp.weights[path[end], path[1]]
    return length
end

function getDistance(tsp, nodeX::Int, nodeY::Int)  
    return tsp.weights[nodeX, nodeY]
end

function getNeighbourDistance(tsp, node::Int)
    return tsp.weights[node,:]
end

function getClosestNeighbour(tsp, node::Int)
    currentDistance = 0.0
    closestNeighbour = 1
    if node != 1
        currentDistance = tsp.weights[node, 1]
    else 
        currentDistance = tsp.weights[node, 2]
        getNeighbourDistance = 2
    end
    distances = getNeighbourDistance(tsp, node)

    for i in 1:size(distances, 1)
        if i != node 
            if distances[i] < currentDistance
                currentDistance = distances[i]
                closestNeighbour = i
            end
        end
    end
    return closestNeighbour
end

function getClosestNeighbourBanned(tsp, node::Int, banned::Array{Int})
    currentDistance = 0.0
    closestNeighbour = 1
    distances = getNeighbourDistance(tsp, node)

    for i in 1:size(distances, 1)
        if i != node && (banned[i] == 1)
            currentDistance = distances[i]
            closestNeighbour = i
        end
    end

    for i in 1:size(distances, 1)
        if i != node && (banned[i] == 1)
            if distances[i] < currentDistance
                currentDistance = distances[i]
                closestNeighbour = i
            end
        end
    end
    return closestNeighbour
end

function getPathFromInput() 
    print("Size:\n") 
    size = parse(Int, readline())

    print("Nodes:\n") 
    path = zeros(Int, size, 1)
    for i in 1:size
        path[i] = parse(Int, readline())
    end
    return path
end

function PRD(x, opt)  
    return (x - opt)/opt
end

function PRDString(x, opt)  
    value = 100 * (x - opt)/opt
    return string(round(value, digits=2),"%")
end

function printCycle(path::Array{Int}) 
    for i in 1:size(path,1)-1
        @printf("%d -> ", path[i])
    end
    @printf("%d\n", path[end])
end

function swapNodesInPath(path, i, j)
    temp = path[i]
    path[i] = path[j] 
    path[j] = temp
    return path
end