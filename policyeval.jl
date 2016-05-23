#Approximate dynamic programming by Powel
#Problem 9.1

importall ReinforcementLearning

function tdeval()
	v = 0
	γ = 0.9

	for i=1:20000
		pv = v
		α = 1/(i^0.7)
		c = rand(0:20)
		v = pv + α * (c + γ * pv - pv)
		println("iteration: $(i), updated v: $(v), previous v: $(pv), c: $(c)")
	end
end

function lstd()
	n = 100
	cs = rand(0:20, n)
	γ = 0.9
	v = (1 / (1 - γ))*((1/n)*sum(cs))
	println("v: $v")
end

function lspe()
	n = 100
	v = 0
	cs = Float64[]
	γ = 0.9

	for i=1:n
		pv = v
		c = rand(0:20)
		push!(cs, c)
		v = mean(cs) + γ * pv
		println("iteration: $(i), updated v: $(v), previous v: $(pv), c: $(c)")
	end
end

function main()
	#tdeval()
	println("LSTD")
	lstd()
	println("\nLSPE")
	lspe()
end

main()
