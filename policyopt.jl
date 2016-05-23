#Powel 7.2
using HypothesisTests
using PyPlot

function policy(pu, pl)
	function xt(pt)
		if pt <= pl
			return 1
		elseif pt >= pu
			return -1
		else
			return 0
		end
	end

	p = 40
	r = 0
	cs = Float64[]
	performances = Float64[]

	for t=1:50000
		pp = p
		pr = r
		p = pp + 0.7*(0 - pp) + 40 * rand(-0.5:0.5)
		r = max(0, pr + xt(pp))
		push!(cs, p*r)
		if t % 200 == 0
			push!(performances, mean(cs[t-199:t]))
		end
	end

	return mean(performances)
end

function main()
	println("Policy A")
	samples = [policy(45, 25) for i=1:100]
	println("Average: $(mean(samples)), sample variance: $(var(samples)), the variance of the average: $(var(samples) / 100)")
	
	println("Policy B")
	samples2 = [policy(50, 25) for i=1:100]
	println("Average: $(mean(samples2)), sample variance: $(var(samples2)), the variance of the average: $(var(samples2) / 100)")
	
	p = pvalue(OneSampleTTest(samples, samples2))
	println("P value: $p")
	
	ciresult = ci(OneSampleTTest(samples, samples2))
	println("Confidence Interval: $ciresult")

	Grid  = zeros(4, 4)
	mx = 0
	for pu=1:4
		for pl=1:4

			val = policy(45 + (pu-1)*5, 20 + (pl-1)*5)
			Grid[pu, pl] = val

			if val > mx
				mx = val
				println("(pu, pl): $((45 + (pu-1)*5, 20 + (pl-1)*5))")
			end
		end
	end

	x = linspace(45, 60, 4)
	y = linspace(20, 35, 4)

	xgrid = repmat(x', 4, 1)
	ygrid = repmat(y, 1, 4)

	fig = figure("Grid Policy Performance")
	ax = fig[:add_subplot](1,1,1, projection="3d")
	ax[:plot_surface](xgrid, ygrid, Grid, rstride=2,edgecolors="k", cstride=2, cmap=ColorMap("gray"), alpha=0.8, linewidth=0.25)
	xlabel("PU")
	ylabel("PL")
	title("Policy Performance")
	PyPlot.show()
end

main()
