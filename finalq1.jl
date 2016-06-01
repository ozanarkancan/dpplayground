#=
Related package is on https://github.com/ozanarkancan/ReinforcementLearning.jl
MDP definition is on src/MDP.jl
Policy Iteration is on src/DP.jl

Problem is by definition minimization of cost problem. However, code is written as maximization of rewards.
So, I defined the rewards as negative costs.
=#

using ReinforcementLearning

graph = Dict{State, Dict{Action,Array{Tuple{State, Float64, Float64}}}}()
p = 0.6

ss = [State(i) for i in 1:51]# state 51 represents destination
as = [Action(1), Action(2)]# park, do not park

#rewards are negative costs
for i=1:51
	graph[ss[i]] = Dict{Action, Array{Tuple{State, Float64, Float64}}}()
	if i < 50
		graph[ss[i]][as[1]] = [(ss[i+1], -2, p), (ss[51], -8*(50-i), 1-p)]#park action, occupied, not occupied
		graph[ss[i]][as[2]] = [(ss[i+1], -2, 1.0)]#do not park
	elseif i == 50
		graph[ss[i]][as[1]] = [(ss[i+1], -30, p), (ss[51], -8*(50-i), 1-p)]#if last slot is occupied, move to special lot
	else
		graph[ss[i]][as[1]] = [(ss[i], 0.0, 1.0)]#terminal state
	end
end

mdp = MDP(51, 2, graph)

policy, V = policy_iteration(mdp; Ɣ=1.0, verbose=true)
for s in ss
	println("State: $(s), Value: $(V[s]), Action: $(policy.mapping[s][1][1])")
end	
