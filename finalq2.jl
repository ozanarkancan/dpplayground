#=
Related package is on https://github.com/ozanarkancan/ReinforcementLearning.jl
MDP definition is on src/MDP.jl
Value Iteration is on src/DP.jl

=#

using ReinforcementLearning

graph = Dict{State, Dict{Action,Array{Tuple{State, Float64, Float64}, 1}}}()
Ɣ = 0.9
b1 = 2.0
b2 = 3.0
N1 = 5
N2 = 7

probs_a1 = [0.4, 0.3, 0.2, 0.1]
probs_a2 = [0.1, 0.2, 0.3, 0.4]

ss = State[]
for n1=0:N1
	for n2=0:N2
		push!(ss, State(round(Int, n1*N2 + n2 + 1)))#indices start from zero
	end
end

as = [Action(1), Action(2)]# choose q1, choose q2

for n1=0:N1
	for n2=0:N2
		i = n1*N2 + n2 + 1
		graph[ss[i]] = Dict{Action, Array{Tuple{State, Float64, Float64}, 1}}()
		
		l1 = Array{Tuple{State, Float64, Float64}, 1}()
		l2 = Array{Tuple{State, Float64, Float64}, 1}()

		for a1=0:3
			for a2=0:3
				tmpi = n1 == 0 ? 1 : n1
				tmpj = n2

				tot1 = tmpi - 1 + a1
				tot2 = tmpj + a2

				k = tot1 > N1 ? N1 : tot1
				m = tot2 > N2 ? N2 : tot2
				

				cost = max(b1 * (n1 + a1 - N1), 0.0)
				cost += max(b2 * (n2 + a2 - N2), 0.0)
				
				push!(l1, (ss[k*N2 + m + 1], -1 * cost, probs_a1[a1 + 1] * probs_a2[a2 + 1]))
			end
		end
		graph[ss[i]][as[1]] = l1
		
		#choose q2
		for a1=0:3
			for a2=0:3
				tmpi = n1
				tmpj = n2 == 0 ? 1 : n2

				tot1 = tmpi + a1
				tot2 = tmpj - 1 + a2

				k = tot1 > N1 ? N1 : tot1
				m = tot2 > N2 ? N2 : tot2

				cost = max(b1 * (n1 + a1 - N1), 0.0)
				cost += max(b2 * (n2 + a2 - N2), 0.0)

				push!(l2, (ss[k*N2 + m + 1], -1 * cost, probs_a1[a1 + 1] * probs_a2[a2 + 1]))

			end
		end

		graph[ss[i]][as[2]] = l2
	end
end

mdp = MDP((N1 + 1) * (N2 + 1), 2, graph)

policy, V = synchronous_value_iteration(mdp; Ɣ=Ɣ, verbose=true)

for n1=0:N1
	for n2=0:N2
		s = ss[(n1*N2 + n2 + 1)]
		println("State: $((n1, n2)), Value: $(-1 * V[s]), Action: $(policy.mapping[s][1][1])")
		#println(-1 * V[s])
	end
end
