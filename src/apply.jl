"""
  $(TYPEDSIGNATURES)

# Arguments

- `dims`: if `by` provided, the length of `dims` should be one!


# Examples
```julia
dates = make_date(2010, 1, 1):Day(1):make_date(2010, 12, 31)
yms = format.(dates, "yyyy-mm")

## example 01, some as R aggregate
x1 = rand(365)
apply(x1, 1, yms)
apply(x1, 1, by=yms)

## example 02
n = 100
x = rand(n, n, 365)

res = apply(x, 3, by=yms)
size(res) == (n, n, 12)

res = apply(x, 3)
size(res) == (n, n)

## example 03
dates = make_date(2010):Day(1):make_date(2013, 12, 31)
n = 100
ntime = length(dates)
x = rand(n, n, ntime)

years = year.(dates)
res = apply(x, 3; by=years, fun=nanquantile, combine=true, probs=[0.05, 0.95])
obj_size(res)

res = apply(x, 3; by=years, fun=nanmean, combine=true)
```
"""
function apply(x::AbstractArray, dims=3, args...; by=nothing, fun::Function=mean, combine=true, kw...)
  fun2(x) = fun(x, args...; kw...)

  if by === nothing
    res = mapslices(fun2, x, dims=dims)
    size(res)[end] == 1 && (res = selectdim(res, dims, 1))
  else
    grps = unique(by)
    res = map(grp -> begin
        ind = by .== grp
        data = selectdim(x, dims, ind)
        # ans = fun(data, args...; kw...)
        ans = mapslices(fun2, data, dims=dims)
        ans
      end, grps)
    # permutedims(A, perm)
    # may have bug
    along = size(res[1])[end] == 1 ? dims : ndims(res[1]) + 1
    combine && (res = cat(res..., dims=along))
  end
  res
end


"""
  $(TYPEDSIGNATURES)

# Examples
```julia
using Ipaper

range = [70, 140, 15, 55]
cellsize = 1.0

lon = range[1]+cellsize/2:cellsize:range[2]
lat = range[3]+cellsize/2:cellsize:range[4]
dates = make_date(2010):Day(1):make_date(2013, 12, 31)

# years = year.(dates)
ntime = length(dates)

data = rand(length(lon), length(lat), ntime)
dims = X(lon), Y(lat), Ti(dates)

ra = rast(data, dims)

probs = [0.05, 0.95]
dims_new = Dim{:prob}(probs)

res = rast_apply(ra, 3; by=date_year(dates), fun=NanQuantile, combine=true,
  probs, dims_new, name="quantile")
```

$(METHODLIST)
"""
function rast_apply(x::AbstractRaster, dims=3, args...;
  by=nothing, fun::Function=mean,
  name="", dims_new=[], missingval=NaN,
  rast_kw=(;),
  kw...)

  data = apply(x.data, dims, args...; by, fun, kw...)

  dimens_left = x.dims[setdiff(1:ndims(x), dims)]

  if by === nothing

    if !isempty(dims_new) && ndims(data) >= ndims(x)
      dimens = tuple(dimens_left..., dims_new)
    else
      dimens = x.dims[setdiff(1:ndims(x), dims)]
    end

  else
    
    grps = unique(by)
    if !isempty(dims_new) && ndims(data) > ndims(x)
      # 目前仅限最后一维的操作
      dimens = tuple(dimens_left..., dims_new, Ti(unique(by)))
    else
      dimens = collect(x.dims)
      dimens[dims] = Ti(grps)
    end

  end

  Raster(data, tuple(dimens...); name, missingval, rast_kw...)
end
