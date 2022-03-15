using TSPLIB;
using Printf;

function objectiveFunction(tsp, path)  
    length = 0
    for i in 1:size(path,1)-1
        length += tsp.weights[path[i], path[i+1]]
    end
    length += tsp.weights[path[end], path[1]]
    return length
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
