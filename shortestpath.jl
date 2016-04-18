using Graphs

g = simple_inclist(9)
inputs = [
	(1, 2, 1),
	(1, 3, 2),
	(2, 5, 12),
	(2, 4, 6),
	(3, 4, 3),
	(3, 6, 4),
	(4, 5, 4),
	(4, 7, 15),
	(4, 8, 7),
	(4, 6, 3),
	(5, 7, 7),
	(6, 8, 7),
	(6, 9, 15),
	(7, 9, 3),
	(8, 9, 10)
	]

distances = zeros(length(inputs))
for i=1:length(inputs)
	e = inputs[i]
	add_edge!(g, e[1], e[2])
	distances[i] = e[3]
end


function path(t, p, ps)
	unshift!(p, t)
	if t == 1
		return p
	else
		return path(ps[t], p, ps)
	end
end

#recursive function for the shortest path
function f(fs, ps, ts, g, t)
	m = 1e6
	if fs[t] == 0
		for u in out_neighbors(t, g)
			fc = f(fs, ps, ts, g, u)
			if fc + ts[t, u] < m
				fs[u] = fc
				ps[t] = u
				fs[t] = ts[t, u] + fc
				m = fc + ts[t, u]
			end
		end
	end
	return fs[t]
end

#r = dijkstra_shortest_paths(g, distances, 1)
#println(r)
#println(path(9, [], r.parent_indices))

ts = zeros(9,9)
ts[1,2] = 1
ts[1,3] = 2
ts[2,5] = 12
ts[2,4] = 6
ts[3,4] = 3
ts[3,6] = 4
ts[4,5] = 4
ts[4,7] = 15
ts[4,8] = 7
ts[4,6] = 3
ts[5,7] = 7
ts[6,8] = 7
ts[6,9] = 15
ts[7,9] = 3
ts[8,9] = 10

fs = zeros(9,)
ps = zeros(Int, 9,)
#f(fs, ps, ts, g, 1)
#println(fs)
#println(ps)

#recursive function for minimum of maximum altitude
function fm(fs, ps, ts, g, t)
	m = 1e6
	if fs[t] == 0
		for u in out_neighbors(t, g)
			fc = fm(fs, ps, ts, g, u)
			ma = max(fc, ts[t, u])
			if ma < m
				fs[u] = fc
				ps[t] = u
				fs[t] = ma
				m = ma
			end
		end
	end
	return fs[t]
end


fm(fs, ps, ts, g, 1)
println(fs)
println(ps)

