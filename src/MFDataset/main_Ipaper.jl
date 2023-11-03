macro par(parallel, ex)
  ex_par = :(Threads.@threads for _ in 1:1; end)
  ex_par.args[3] = ex
  
  expr = :(parallel ? $(ex_par) : $(ex))
  esc(expr)
end

macro par(ex)
  # default parallel
  ex_par = :(Threads.@threads for _ in 1:1; end)
  ex_par.args[3] = ex
  esc(ex_par)
end

get_clusters() = Threads.nthreads()


function r_chunk(n::Int, nchunk=5)
  chunk = fld(n, nchunk) 
  map(i -> begin
    if i < nchunk
      _inds = (i-1)*chunk+1:i*chunk
    else
      _inds = (i-1)*chunk+1:n
    end
  end, 1:nchunk)
end

function r_chunk(x::AbstractVector, nchunk=5)
  n = length(x)
  inds = r_chunk(n, nchunk)
  map(i -> x[i], inds)
end

# import DataStructures: OrderedDict
# merge Vector of Tuple
function Base.merge(xs::Vector{<:NamedTuple}; keys=nothing)
  keys === nothing && (keys = Base.keys(xs[1]))
  values = [vcat(map(x -> x[name], xs)...) for name in keys]
  (; zip(keys, values)...)
end

## extract data
function rm_empty(x::Vector)
  inds = findall(!isnothing, x)
  inds, x[inds]
end

# function findnear(values, x)
#   _, i = findmin(abs.(values .- x))
#   values[i], i
# end

dist(p1, p2) = sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2)

dist(p1, points::AbstractVector) = [dist(p1, p2) for p2 in points]

findnear(p1, points::AbstractVector) = findmin(dist(p1, points))[2]


export findnear
