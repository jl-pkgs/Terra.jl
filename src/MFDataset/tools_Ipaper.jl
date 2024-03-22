using NetCDFTools.Ipaper

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

dist(p1, p2) = sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2)

dist(p1, points::AbstractVector) = [dist(p1, p2) for p2 in points]

# value
findnear(x::Real, values::AbstractVector) = findmin(abs.(values .- x))[2]

# point
findnear(p1, points::AbstractVector) = findmin(dist(p1, points))[2]

export findnear
