export TerraYAXArraysExt
module TerraYAXArraysExt

using Terra
using YAXArrays

Base.names(ds::YAXArrays.Dataset) = string.(collect(keys(ds.cubes))) |> sort
Base.getindex(ds::YAXArrays.Dataset, i) = ds[names(ds)[i]]

Terra.chunksize(ds::YAXArrays.Dataset) = chunksize(ds[1])
Terra.chunksize(c) = Cubes.cubechunks(c)

Terra.st_bbox(ds::YAXArrays.Dataset) = st_bbox.(get_zarr(ds)) # multiple

function Terra.get_zarr(ds::YAXArrays.Dataset)
  vars = names(ds)
  zs = map(var -> ds[var].data, vars)
  zs
end

# 哪个grid被选中了
function Terra.which_grid(ds::YAXArrays.Dataset, (lon, lat))
  zs = get_zarr(ds)
  bs = st_bbox.(zs)
  inds = in_bbox(bs, (lon, lat)) |> findall
  !isempty(inds) ? names(ds)[inds[1]] : nothing
end

function Terra.read_ds(ds::YAXArrays.Dataset; index=nothing, missingval=0.0f0, crs=EPSG(4326), kw...)
  grids = names(ds)
  n = length(grids)
  res = Vector{Raster}(undef, n)

  Threads.@threads for i in 1:n
    grid = grids[i]
    z = ds[grid].data    
    b = st_bbox(z)

    index !== nothing && (z = z[index...])
    ra = Raster(z, b; missingval, crs, kw...)
    res[i] = ra
  end
  res
end

# 这里应该添加选择波段的功能
function Terra.st_mosaic(ds::YAXArrays.Dataset; index=nothing, missingval=0.0f0, crs=EPSG(4326), kw...)
  res = read_ds(ds)
  st_mosaic(res)
end

end
