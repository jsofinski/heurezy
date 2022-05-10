include("main.jl")

function getKrandom(k)

  function krandomSpecified(tsp)
    krandom(tsp, k)
  end

  return krandomSpecified
end

function allInvertTest()
  tsp = readTSPLIB(:gr24)
  display(allInverts(tsp, [1,2,3, 4, 5, 6, 7, 8]))
end
function test() 
    tsp = readTSPLIB(:gr24)
	tabuSearch(tsp,1000,getKrandom(2), 200, 1000)
	println(tsp.optimal)
end


# allInvertTest()
test()
