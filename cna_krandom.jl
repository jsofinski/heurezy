include("utils.jl")
# include("draw.jl")
include("randomtsp.jl")
include("algotihms.jl")

using BenchmarkTools
using Plots

# tsp = readTSPLIB(:gr24)
minSize = 20
step = 20
maxSize = 200
numberOfSamples = 10

atsp = genAsymmetricalRandomTsp(200, 20, 1000)
tsp = genSymmetricalRandomTsp(200, 20, 1000)
etsp = genEuclidianRandomTsp(200, 707, 707)


function kRandom()
    numberOfTests = Int((maxSize-minSize)/step+1)
    # println(numberOfTests)
    println("kRandom")
    k = 20000
    minATSP = zeros(Int, numberOfTests, 1)
    avgATSP = zeros(Int, numberOfTests, 1)
    maxATSP = zeros(Int, numberOfTests, 1)

    minTSP = zeros(Int, numberOfTests, 1)
    avgTSP = zeros(Int, numberOfTests, 1)
    maxTSP = zeros(Int, numberOfTests, 1)

    minETSP = zeros(Int, numberOfTests, 1)
    avgETSP = zeros(Int, numberOfTests, 1)
    maxETSP = zeros(Int, numberOfTests, 1)


    minATSPTime = zeros(Float64, numberOfTests, 1)
    avgATSPTime = zeros(Float64, numberOfTests, 1)
    maxATSPTime = zeros(Float64, numberOfTests, 1)

    minTSPTime = zeros(Float64, numberOfTests, 1)
    avgTSPTime = zeros(Float64, numberOfTests, 1)
    maxTSPTime = zeros(Float64, numberOfTests, 1)

    minETSPTime = zeros(Float64, numberOfTests, 1)
    avgETSPTime = zeros(Float64, numberOfTests, 1)
    maxETSPTime = zeros(Float64, numberOfTests, 1)

    for i in 1:numberOfTests
        currentSize = minSize + step * (i-1)
        println(i)
        # println(currentSize)

        for j in 1:numberOfSamples
            atsp = genAsymmetricalRandomTsp(currentSize, 20, 1000)
            tsp = genSymmetricalRandomTsp(currentSize, 20, 1000)
            etsp = genEuclidianRandomTsp(currentSize, 707, 707)

            atspPath = krandom(atsp, k)
            atspTime = @elapsed krandom(atsp, k)
            atspWeight = objectiveFunction(atsp, atspPath)
            tspPath = krandom(tsp, k)
            tspTime = @elapsed krandom(tsp, k)
            tspWeight = objectiveFunction(tsp, tspPath)
            etspPath = krandom(etsp, k)
            etspTime = @elapsed krandom(etsp, k)
            etspWeight = objectiveFunction(etsp, etspPath)
           
            if (minATSP[i] == 0 || minATSP[i] > atspWeight)
                minATSP[i] = atspWeight
            end
            avgATSP[i] += atspWeight
            if (maxATSP[i] == 0 || maxATSP[i] < atspWeight)
                maxATSP[i] = atspWeight
            end

            if (minTSP[i] == 0 || minTSP[i] > tspWeight)
                minTSP[i] = tspWeight
            end
            avgTSP[i] += tspWeight
            if (maxTSP[i] == 0 || maxTSP[i] < tspWeight)
                maxTSP[i] = tspWeight
            end

            if (minETSP[i] == 0 || minETSP[i] > etspWeight)
                minETSP[i] = etspWeight
            end
            avgETSP[i] += etspWeight
            if (maxETSP[i] == 0 || maxETSP[i] < etspWeight)
                maxETSP[i] = etspWeight
            end


            if (minATSPTime[i] == 0 || minATSPTime[i] > atspTime)
                minATSPTime[i] = atspTime
            end
            avgATSPTime[i] += atspTime
            if (maxATSPTime[i] == 0 || maxATSPTime[i] < atspTime)
                maxATSPTime[i] = atspTime
            end

            if (minTSPTime[i] == 0 || minTSPTime[i] > tspTime)
                minTSPTime[i] = tspTime
            end
            avgTSPTime[i] += tspTime
            if (maxTSPTime[i] == 0 || maxTSPTime[i] < tspTime)
                maxTSPTime[i] = tspTime
            end

            if (minETSPTime[i] == 0 || minETSPTime[i] > etspTime)
                minETSPTime[i] = etspTime
            end
            avgETSPTime[i] += etspTime
            if (maxETSPTime[i] == 0 || maxETSPTime[i] < etspTime)
                maxETSPTime[i] = etspTime
            end

        end
        avgATSP[i] = round(avgATSP[i]/numberOfSamples)
        avgTSP[i] = round(avgTSP[i]/numberOfSamples)
        avgETSP[i] = round(avgETSP[i]/numberOfSamples)


        avgATSPTime[i] = (avgATSPTime[i]/numberOfSamples)
        avgTSPTime[i] = (avgTSPTime[i]/numberOfSamples)
        avgETSPTime[i] = (avgETSPTime[i]/numberOfSamples)
    end

    # println("atsp min:")
    # println(minATSP)
    # println("atsp avg:")
    # println(avgATSP)
    # println("atsp max:")
    # println(maxATSP)
    # println()
    # println("atsp min time:")
    # println(minATSPTime)
    # println("atsp avg time:")
    # println(avgATSPTime)
    # println("atsp max time:")
    # println(maxATSPTime)
    # println()
    # println()

    # println("tsp min:")
    # println(minTSP)
    # println("tsp avg:")
    # println(avgTSP)
    # println("tsp max:")
    # println(maxTSP)
    # println()
    # println("tsp min time:")
    # println(minTSPTime)
    # println("tsp avg time:")
    # println(avgTSPTime)
    # println("tsp max time:")
    # println(maxTSPTime)
    # println()
    # println()

    # println("etsp min:")
    # println(minETSP)
    # println("etsp avg:")
    # println(avgETSP)
    # println("etsp max:")
    # println(maxETSP)
    # println()
    # println("etsp min time:")
    # println(minETSPTime)
    # println("etsp avg time:")
    # println(avgETSPTime)
    # println("etsp max time:")
    # println(maxETSPTime)
    # println()
    # println()

    x = 20:20:200
    plot(x, minATSPTime, label = "min atsp", title = "atsp time", lw = 3, size=(1200,800))
    plot!(x, avgATSPTime, label = "avg atsp", lw = 3)
    plot!(x, maxATSPTime, label = "max atsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/krandom/atsptime.png")

    plot(x, minTSPTime, label = "min tsp", title = "tsp time", lw = 3, size=(1200,800))
    plot!(x, avgTSPTime, label = "avg tsp", lw = 3)
    plot!(x, maxTSPTime, label = "max tsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/krandom/tsptime.png")

    plot(x, minETSPTime, label = "min etsp", title = "etsp time", lw = 3, size=(1200,800))
    plot!(x, avgETSPTime, label = "avg etsp", lw = 3)
    plot!(x, maxETSPTime, label = "max etsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/krandom/etsptime.png")


    plot(x, minATSP, label = "min atsp", title = "atsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgATSP, label = "avg atsp", lw = 3)
    plot!(x, maxATSP, label = "max atsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/krandom/atspeff.png")

    plot(x, minTSP, label = "min tsp", title = "tsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgTSP, label = "avg tsp", lw = 3)
    plot!(x, maxTSP, label = "max tsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/krandom/tspeff.png")

    plot(x, minETSP, label = "min etsp", title = "etsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgETSP, label = "avg etsp", lw = 3)
    plot!(x, maxETSP, label = "max etsp", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/krandom/etspeff.png")


    # printPath = false
    # println("kRandom")
    # newPath = krandom(atsp, 20000)
    # println("atsp Krandom:")
    # if(printPath)
    #     println(newPath)
    # end
    # println(objectiveFunction(atsp, newPath))

    # newPath = krandom(tsp, 20000)
    # println("tsp Krandom:")
    # if(printPath)
    #     println(newPath)
    # end
    # println(objectiveFunction(tsp, newPath))

    # newPath = krandom(etsp, 20000)
    # println("etsp Krandom:")
    # if(printPath)
    #     println(newPath)
    # end
    # println(objectiveFunction(etsp, newPath))
end


function neighbours()
    println("neighbours")
    numberOfTests = Int((maxSize-minSize)/step+1)
    # println(numberOfTests)


    minCNATSP = zeros(Int, numberOfTests, 1)
    avgCNATSP = zeros(Int, numberOfTests, 1)
    maxCNATSP = zeros(Int, numberOfTests, 1)

    minCNTSP = zeros(Int, numberOfTests, 1)
    avgCNTSP = zeros(Int, numberOfTests, 1)
    maxCNTSP = zeros(Int, numberOfTests, 1)

    minCNETSP = zeros(Int, numberOfTests, 1)
    avgCNETSP = zeros(Int, numberOfTests, 1)
    maxCNETSP = zeros(Int, numberOfTests, 1)


    minBCNATSP = zeros(Int, numberOfTests, 1)
    avgBCNATSP = zeros(Int, numberOfTests, 1)
    maxBCNATSP = zeros(Int, numberOfTests, 1)

    minBCNTSP = zeros(Int, numberOfTests, 1)
    avgBCNTSP = zeros(Int, numberOfTests, 1)
    maxBCNTSP = zeros(Int, numberOfTests, 1)

    minBCNETSP = zeros(Int, numberOfTests, 1)
    avgBCNETSP = zeros(Int, numberOfTests, 1)
    maxBCNETSP = zeros(Int, numberOfTests, 1)


    minBCNATSPTime = zeros(Float64, numberOfTests, 1)
    avgBCNATSPTime = zeros(Float64, numberOfTests, 1)
    maxBCNATSPTime = zeros(Float64, numberOfTests, 1)

    minBCNTSPTime = zeros(Float64, numberOfTests, 1)
    avgBCNTSPTime = zeros(Float64, numberOfTests, 1)
    maxBCNTSPTime = zeros(Float64, numberOfTests, 1)

    minBCNETSPTime = zeros(Float64, numberOfTests, 1)
    avgBCNETSPTime = zeros(Float64, numberOfTests, 1)
    maxBCNETSPTime = zeros(Float64, numberOfTests, 1)

    minCNATSPTime = zeros(Float64, numberOfTests, 1)
    avgCNATSPTime = zeros(Float64, numberOfTests, 1)
    maxCNATSPTime = zeros(Float64, numberOfTests, 1)

    minCNTSPTime = zeros(Float64, numberOfTests, 1)
    avgCNTSPTime = zeros(Float64, numberOfTests, 1)
    maxCNTSPTime = zeros(Float64, numberOfTests, 1)

    minCNETSPTime = zeros(Float64, numberOfTests, 1)
    avgCNETSPTime = zeros(Float64, numberOfTests, 1)
    maxCNETSPTime = zeros(Float64, numberOfTests, 1)

    for i in 1:numberOfTests
        currentSize = minSize + step * (i-1)
        println(i)
        # println(currentSize)

        for j in 1:numberOfSamples
            atsp = genAsymmetricalRandomTsp(currentSize, 20, 1000)
            tsp = genSymmetricalRandomTsp(currentSize, 20, 1000)
            etsp = genEuclidianRandomTsp(currentSize, 707, 707)

            # closestNeighbourAlgorithm
            cnPathATSP = closestNeighbourAlgorithm(atsp)
            cnTimeATSP = @elapsed closestNeighbourAlgorithm(atsp)
            cnWeightATSP = objectiveFunction(atsp, cnPathATSP)

            cnPathTSP = closestNeighbourAlgorithm(tsp)
            cnTimeTSP = @elapsed closestNeighbourAlgorithm(tsp)
            cnWeightTSP = objectiveFunction(tsp, cnPathTSP)

            cnPathETSP = closestNeighbourAlgorithm(etsp)
            cnTimeETSP = @elapsed closestNeighbourAlgorithm(etsp)
            cnWeightETSP = objectiveFunction(etsp, cnPathETSP)

            
            # betterClosestNeighbourAlgorithm 
            bcnPathATSP = betterClosestNeighbourAlgorithm(atsp)
            bcnTimeATSP = @elapsed betterClosestNeighbourAlgorithm(atsp)
            bcnWeightATSP = objectiveFunction(atsp, bcnPathATSP)

            bcnPathTSP = betterClosestNeighbourAlgorithm(tsp)
            bcnTimeTSP = @elapsed betterClosestNeighbourAlgorithm(tsp)
            bcnWeightTSP = objectiveFunction(tsp, bcnPathTSP)

            bcnPathETSP = betterClosestNeighbourAlgorithm(etsp)
            bcnTimeETSP = @elapsed betterClosestNeighbourAlgorithm(etsp)
            bcnWeightETSP = objectiveFunction(etsp, bcnPathETSP)

            # closestNeighbourAlgorithm atsp
            if (minCNATSP[i] == 0 || minCNATSP[i] > cnWeightATSP)
                minCNATSP[i] = cnWeightATSP
            end
            avgCNATSP[i] += cnWeightATSP
            if (maxCNATSP[i] == 0 || maxCNATSP[i] < cnWeightATSP)
                maxCNATSP[i] = cnWeightATSP
            end
            # closestNeighbourAlgorithm tsp
            if (minCNTSP[i] == 0 || minCNTSP[i] > cnWeightTSP)
                minCNTSP[i] = cnWeightTSP
            end
            avgCNTSP[i] += cnWeightTSP
            if (maxCNTSP[i] == 0 || maxCNTSP[i] < cnWeightTSP)
                maxCNTSP[i] = cnWeightTSP
            end
            # closestNeighbourAlgorithm etsp
            if (minCNETSP[i] == 0 || minCNETSP[i] > cnWeightETSP)
                minCNETSP[i] = cnWeightETSP
            end
            avgCNETSP[i] += cnWeightETSP
            if (maxCNETSP[i] == 0 || maxCNETSP[i] < cnWeightETSP)
                maxCNETSP[i] = cnWeightETSP
            end

            # betterClosestNeighbourAlgorithm atsp
            if (minBCNATSP[i] == 0 || minBCNATSP[i] > bcnWeightATSP)
                minBCNATSP[i] = bcnWeightATSP
            end
            avgBCNATSP[i] += bcnWeightATSP
            if (maxBCNATSP[i] == 0 || maxBCNATSP[i] < bcnWeightATSP)
                maxBCNATSP[i] = bcnWeightATSP
            end
            # closestNeighbourAlgorithm tsp
            if (minBCNTSP[i] == 0 || minBCNTSP[i] > bcnWeightTSP)
                minBCNTSP[i] = bcnWeightTSP
            end
            avgBCNTSP[i] += bcnWeightTSP
            if (maxBCNTSP[i] == 0 || maxBCNTSP[i] < bcnWeightTSP)
                maxBCNTSP[i] = bcnWeightTSP
            end
            # closestNeighbourAlgorithm etsp
            if (minBCNETSP[i] == 0 || minBCNETSP[i] > bcnWeightETSP)
                minBCNETSP[i] = bcnWeightETSP
            end
            avgBCNETSP[i] += bcnWeightETSP
            if (maxBCNETSP[i] == 0 || maxBCNETSP[i] < bcnWeightETSP)
                maxBCNETSP[i] = bcnWeightETSP
            end




            # closestNeighbourAlgorithm atsp time
            if (minCNATSPTime[i] == 0 || minCNATSPTime[i] > cnTimeATSP)
                minCNATSPTime[i] = cnTimeATSP
            end
            avgCNATSPTime[i] += cnTimeATSP
            if (maxCNATSPTime[i] == 0 || maxCNATSPTime[i] < cnTimeATSP)
                maxCNATSPTime[i] = cnTimeATSP
            end
            # closestNeighbourAlgorithm tsp time
            if (minCNTSPTime[i] == 0 || minCNTSPTime[i] > cnTimeTSP)
                minCNTSPTime[i] = cnTimeTSP
            end
            avgCNTSPTime[i] += cnTimeTSP
            if (maxCNTSPTime[i] == 0 || maxCNTSPTime[i] < cnTimeTSP)
                maxCNTSPTime[i] = cnTimeTSP
            end
            # closestNeighbourAlgorithm etsp time
            if (minCNETSPTime[i] == 0 || minCNETSPTime[i] > cnTimeETSP)
                minCNETSPTime[i] = cnTimeETSP
            end
            avgCNETSPTime[i] += cnTimeETSP
            if (maxCNETSPTime[i] == 0 || maxCNETSPTime[i] < cnTimeET
                # println("atsp min:")
                # println(minATSP)
                # println("atsp avg:")
                # println(avgATSP)
                # println("atsp max:")
                # println(maxATSP)
                # println()
                # println("atsp min time:")
                # println(minATSPTime)
                # println("atsp avg time:")
                # println(avgATSPTime)
                # println("atsp max time:")
                # println(maxATSPTime)
                # println()
                # println()
            
                # println("tsp min:")
                # println(minTSP)
                # println("tsp avg:")
                # println(avgTSP)
                # println("tsp max:")
                # println(maxTSP)
                # println()
                # println("tsp min time:")
                # println(minTSPTime)
                # println("tsp avg time:")
                # println(avgTSPTime)
                # println("tsp max time:")
                # println(maxTSPTime)
                # println()
                # println()
            
                # println("etsp min:")
                # println(minETSP)
                # println("etsp avg:")
                # println(avgETSP)
                # println("etsp max:")
                # println(maxETSP)
                # println()
                # println("etsp min time:")
                # println(minETSPTime)
                # println("etsp avg time:")
                # println(avgETSPTime)
                # println("etsp max time:")
                # println(maxETSPTime)
                # println()
                # println()
            )
                maxCNETSPTime[i] = cnTimeETSP
            end


            # closestNeighbourAlgorithm atsp time
            if (minBCNATSPTime[i] == 0 || minBCNATSPTime[i] > bcnTimeATSP)
                minBCNATSPTime[i] = bcnTimeATSP
            end
            avgBCNATSPTime[i] += bcnTimeATSP
            if (maxBCNATSPTime[i] == 0 || maxBCNATSPTime[i] < bcnTimeATSP)
                maxBCNATSPTime[i] = bcnTimeATSP
            end
            # closestNeighbourAlgorithm tsp time
            if (minBCNTSPTime[i] == 0 || minBCNTSPTime[i] > bcnTimeTSP)
                minBCNTSPTime[i] = bcnTimeTSP
            end
            avgBCNTSPTime[i] += bcnTimeTSP
            if (maxBCNTSPTime[i] == 0 || maxBCNTSPTime[i] < bcnTimeTSP)
                maxBCNTSPTime[i] = bcnTimeTSP
            end
            # closestNeighbourAlgorithm etsp time
            if (minBCNETSPTime[i] == 0 || minBCNETSPTime[i] > bcnTimeETSP)
                minBCNETSPTime[i] = bcnTimeETSP
            end
            avgBCNETSPTime[i] += bcnTimeETSP
            if (maxBCNETSPTime[i] == 0 || maxBCNETSPTime[i] < bcnTimeETSP)
                maxBCNETSPTime[i] = bcnTimeETSP
            end


        end
        avgCNATSP[i] = round(avgCNATSP[i]/numberOfSamples)
        avgCNTSP[i] = round(avgCNTSP[i]/numberOfSamples)
        avgCNETSP[i] = round(avgCNETSP[i]/numberOfSamples)

        avgBCNATSP[i] = round(avgBCNATSP[i]/numberOfSamples)
        avgBCNTSP[i] = round(avgBCNTSP[i]/numberOfSamples)
        avgBCNETSP[i] = round(avgBCNETSP[i]/numberOfSamples)


        avgCNATSPTime[i] = (avgCNATSPTime[i]/numberOfSamples)
        avgCNTSPTime[i] = (avgCNTSPTime[i]/numberOfSamples)
        avgCNETSPTime[i] = (avgCNETSPTime[i]/numberOfSamples)

        avgBCNATSPTime[i] = (avgBCNATSPTime[i]/numberOfSamples)
        avgBCNTSPTime[i] = (avgBCNTSPTime[i]/numberOfSamples)
        avgBCNETSPTime[i] = (avgBCNETSPTime[i]/numberOfSamples)
    end

    x = 20:20:200
    # ATSP efficiency
    plot(x, minCNATSP, label = "min closest neighbour", title = "atsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgCNATSP, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNATSP, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNATSP, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNATSP, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNATSP, label = "max better closest neighbour", lw = 3, ls = :dot)

    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/atspneighbourseff.png")

    # TSP efficiency
    plot(x, minCNTSP, label = "min closest neighbour", title = "tsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgCNTSP, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNTSP, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNTSP, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNTSP, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNTSP, label = "max better closest neighbour", lw = 3, ls = :dot)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/tspneighbourseff.png")


    # ETSP efficiency
    plot(x, minCNETSP, label = "min closest neighbour", title = "etsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgCNETSP, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNETSP, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNETSP, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNETSP, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNETSP, label = "max better closest neighbour", lw = 3, ls = :dot)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/etspneighbourseff.png")


    # ATSP time
    plot(x, minCNATSPTime, label = "min closest neighbour", title = "atsp time", lw = 3, size=(1200,800))
    plot!(x, avgCNATSPTime, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNATSPTime, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNATSPTime, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNATSPTime, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNATSPTime, label = "max better closest neighbour", lw = 3, ls = :dot)

    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/atspneighbourtime.png")



    # TSP time
    plot(x, minCNTSPTime, label = "min closest neighbour", title = "tsp time", lw = 3, size=(1200,800))
    plot!(x, avgCNTSPTime, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNTSPTime, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNTSPTime, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNTSPTime, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNTSPTime, label = "max better closest neighbour", lw = 3, ls = :dot)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/tspneighbourstime.png")


    # ETSP time
    plot(x, minCNETSPTime, label = "min closest neighbour", title = "etsp time", lw = 3, size=(1200,800))
    plot!(x, avgCNETSPTime, label = "avg closest neighbour", lw = 3)
    plot!(x, maxCNETSPTime, label = "max closest neighbour", lw = 3)

    plot!(x, minBCNETSPTime, label = "min better closest neighbour", lw = 3, ls = :dot)
    plot!(x, avgBCNETSPTime, label = "avg better closest neighbour", lw = 3, ls = :dot)
    plot!(x, maxBCNETSPTime, label = "max better closest neighbour", lw = 3, ls = :dot)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/neighbours/etspneighbourstime.png")



end



function allCompared()
    numberOfTests = Int((maxSize-minSize)/step+1)
    # println(numberOfTests)
    println("kRandom, neighbours, 2opt")
    k = 10000
    avgATSPKRandom = zeros(Int, numberOfTests, 1)
    avgTSPKRandom = zeros(Int, numberOfTests, 1)
    avgETSPKRandom = zeros(Int, numberOfTests, 1)

    avgATSPTimeKRandom = zeros(Float64, numberOfTests, 1)
    avgTSPTimeKRandom = zeros(Float64, numberOfTests, 1)
    avgETSPTimeKRandom = zeros(Float64, numberOfTests, 1)


    avgATSPNeighbour = zeros(Int, numberOfTests, 1)
    avgTSPNeighbour = zeros(Int, numberOfTests, 1)
    avgETSPNeighbour = zeros(Int, numberOfTests, 1)

    avgATSPTimeNeighbour = zeros(Float64, numberOfTests, 1)
    avgTSPTimeNeighbour = zeros(Float64, numberOfTests, 1)
    avgETSPTimeNeighbour = zeros(Float64, numberOfTests, 1)


    avgATSP2Opt = zeros(Int, numberOfTests, 1)
    avgTSP2Opt = zeros(Int, numberOfTests, 1)
    avgETSP2Opt = zeros(Int, numberOfTests, 1)

    avgATSPTime2Opt = zeros(Float64, numberOfTests, 1)
    avgTSPTime2Opt = zeros(Float64, numberOfTests, 1)
    avgETSPTime2Opt = zeros(Float64, numberOfTests, 1)


    for i in 1:numberOfTests
        currentSize = minSize + step * (i-1)
        println(i)
        # println(currentSize)

        for j in 1:numberOfSamples
            atsp = genAsymmetricalRandomTsp(currentSize, 20, 1000)
            tsp = genSymmetricalRandomTsp(currentSize, 20, 1000)
            etsp = genEuclidianRandomTsp(currentSize, 707, 707)

            atspPathKRandom = krandom(atsp, k)
            atspTimeKRandom = @elapsed krandom(atsp, k)
            atspWeightKRandom = objectiveFunction(atsp, atspPathKRandom)

            tspPathKRandom = krandom(tsp, k)
            tspTimeKRandom = @elapsed krandom(tsp, k)
            tspWeightKRandom = objectiveFunction(tsp, tspPathKRandom)

            etspPathKRandom = krandom(etsp, k)
            etspTimeKRandom = @elapsed krandom(etsp, k)
            etspWeightKRandom = objectiveFunction(etsp, etspPathKRandom)



            atspPathNeighbour = betterClosestNeighbourAlgorithm(atsp)
            atspTimeNeighbour = @elapsed krandom(atsp, k)
            atspWeightNeighbour = objectiveFunction(atsp, atspPathNeighbour)

            tspPathNeighbour = betterClosestNeighbourAlgorithm(tsp)
            tspTimeNeighbour = @elapsed krandom(tsp, k)
            tspWeightNeighbour = objectiveFunction(tsp, tspPathNeighbour)

            etspPathNeighbour = betterClosestNeighbourAlgorithm(etsp)
            etspTimeNeighbour = @elapsed krandom(etsp, k)
            etspWeightNeighbour = objectiveFunction(etsp, etspPathNeighbour)



            atspPath2Opt = twoOptAlgorithm(atsp, closestNeighbourAlgorithm)
            atspTime2Opt = @elapsed krandom(atsp, k)
            atspWeight2Opt = objectiveFunction(atsp, atspPath2Opt)

            tspPath2Opt = twoOptAlgorithm(tsp, closestNeighbourAlgorithm)
            tspTime2Opt = @elapsed krandom(tsp, k)
            tspWeight2Opt = objectiveFunction(tsp, tspPath2Opt)

            etspPath2Opt= twoOptAlgorithm(etsp, closestNeighbourAlgorithm)
            etspTime2Opt = @elapsed krandom(etsp, k)
            etspWeight2Opt = objectiveFunction(etsp, etspPath2Opt)


           
            avgATSPKRandom[i] += atspWeightKRandom
            avgTSPKRandom[i] += tspWeightKRandom
            avgETSPKRandom[i] += etspWeightKRandom

            avgATSPTimeKRandom[i] += atspTimeKRandom
            avgTSPTimeKRandom[i] += tspTimeKRandom
            avgETSPTimeKRandom[i] += etspTimeKRandom


            avgATSPNeighbour[i] += atspWeightNeighbour
            avgTSPNeighbour[i] += tspWeightNeighbour
            avgETSPNeighbour[i] += etspWeightNeighbour

            avgATSPTimeNeighbour[i] += atspTimeNeighbour
            avgTSPTimeNeighbour[i] += tspTimeNeighbour
            avgETSPTimeNeighbour[i] += etspTimeNeighbour


            avgATSP2Opt[i] += atspWeight2Opt
            avgTSP2Opt[i] += tspWeight2Opt
            avgETSP2Opt[i] += etspWeight2Opt

            avgATSPTime2Opt[i] += atspTime2Opt
            avgTSPTime2Opt[i] += tspTime2Opt
            avgETSPTime2Opt[i] += etspTime2Opt

        end
        avgATSPKRandom[i] = round(avgATSPKRandom[i]/numberOfSamples)
        avgTSPKRandom[i] = round(avgTSPKRandom[i]/numberOfSamples)
        avgETSPKRandom[i] = round(avgETSPKRandom[i]/numberOfSamples)

        avgATSPTimeKRandom[i] = (avgATSPTimeKRandom[i]/numberOfSamples)
        avgTSPTimeKRandom[i] = (avgTSPTimeKRandom[i]/numberOfSamples)
        avgETSPTimeKRandom[i] = (avgETSPTimeKRandom[i]/numberOfSamples)


        avgATSPNeighbour[i] = round(avgATSPNeighbour[i]/numberOfSamples)
        avgTSPNeighbour[i] = round(avgTSPNeighbour[i]/numberOfSamples)
        avgETSPNeighbour[i] = round(avgETSPNeighbour[i]/numberOfSamples)

        avgATSPTimeNeighbour[i] = (avgATSPTimeNeighbour[i]/numberOfSamples)
        avgTSPTimeNeighbour[i] = (avgTSPTimeNeighbour[i]/numberOfSamples)
        avgETSPTimeNeighbour[i] = (avgETSPTimeNeighbour[i]/numberOfSamples)


        avgATSP2Opt[i] = round(avgATSP2Opt[i]/numberOfSamples)
        avgTSP2Opt[i] = round(avgTSP2Opt[i]/numberOfSamples)
        avgETSP2Opt[i] = round(avgETSP2Opt[i]/numberOfSamples)

        avgATSPTime2Opt[i] = (avgATSPTime2Opt[i]/numberOfSamples)
        avgTSPTime2Opt[i] = (avgTSPTime2Opt[i]/numberOfSamples)
        avgETSPTime2Opt[i] = (avgETSPTime2Opt[i]/numberOfSamples)
    end

    x = 20:20:200
    plot(x, avgATSPTimeKRandom, label = "KRandom", title = "atsp time", lw = 3, size=(1200,800))
    plot!(x, avgATSPTimeNeighbour, label = "Better closet neighbour", lw = 3)
    plot!(x, avgATSPTime2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/allCompared/atsptime.png")

    plot(x, avgTSPTimeKRandom, label = "KRandom", title = "tsp time", lw = 3, size=(1200,800))
    plot!(x, avgTSPTimeNeighbour, label = "Better closet neighbour", lw = 3)
    plot!(x, avgTSPTime2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/allCompared/tsptime.png")

    plot(x, avgETSPTimeKRandom, label = "KRandom", title = "etsp time", lw = 3, size=(1200,800))
    plot!(x, avgETSPTimeNeighbour, label = "Better closest neighbour", lw = 3)
    plot!(x, avgETSPTime2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Time")
    savefig("./plots/allCompared/etsptime.png")

    plot(x, avgATSPKRandom, label = "KRandom", title = "atsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgATSPNeighbour, label = "Better closest neighbour", lw = 3)
    plot!(x, avgATSP2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/allCompared/atspeff.png")

    plot(x, avgTSPKRandom, label = "KRandom", title = "tsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgTSPNeighbour, label = "Better closest neighbour", lw = 3)
    plot!(x, avgTSP2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/allCompared/tspeff.png")

    plot(x, avgETSPKRandom, label = "KRandom", title = "etsp efficiency", lw = 3, size=(1200,800))
    plot!(x, avgETSPNeighbour, label = "Better closest neighbour", lw = 3)
    plot!(x, avgETSP2Opt, label = "2 Opt", lw = 3)
    xlabel!("Number of nodes")
    ylabel!("Sum of weights")
    savefig("./plots/allCompared/etspeff.png")



end


# neighbours()
# kRandom()

allCompared()