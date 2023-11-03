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

"""
    Base.map(fun::Function, ds::YAXArrays.Dataset; 
        index=nothing, missingval=0.0f0, crs=EPSG(4326), kw...)

# Arguments
- `type`: type of return values 
- `kw`: others to `fun`

# Examples
```julia
function _writeRaster(ra, grid; prefix = "", outdir=".", overwrite=false)
  grid2 = replace(grid, "grid."=>"grid")
  fout = "\$outdir/\$(prefix)_\$grid2.tif"

  if !isfile(fout) || overwrite
    @show basename(fout)
    @time write(fout, ra;
      options=Dict("COMPRESS" => "DEFLATE"), # or LZW; not support the default
      force=true)
  end
  nothing
end

map(_writeRaster, ds; prefix, outdir, overwrite, kw...)
```
"""
function Base.map(fun::Function, ds::YAXArrays.Dataset; 
  index=nothing, missingval=0.0f0, crs=EPSG(4326), type=Raster, lazy=true, kw...)

  grids = names(ds)
  n = length(grids)
  res = Vector{type}(undef, n)

  Threads.@threads for i in 1:n
    grid = grids[i]
    z = ds[grid].data
    b = st_bbox(z)

    if index !== nothing
      z = lazy ? @view(z[index...]) : z[index...]
    end
    ra = Raster(z, b; missingval, crs)
    r = fun(ra, grid; kw...) 
    r !== nothing && (res[i] = r)
  end
  res
end

function Terra.readRaster(ds::YAXArrays.Dataset; kw...)
  self(ra, grid; kw...) = ra
  map(self, ds; kw...)
end

function _writeRaster(ra, grid; prefix = "", outdir=".", overwrite=false)
  grid2 = replace(grid, "grid."=>"grid")
  fout = "$outdir/$(prefix)_$grid2.tif"

  if !isfile(fout) || overwrite
    @show basename(fout)
    @time write(fout, ra;
      options=Dict("COMPRESS" => "DEFLATE"), # or LZW; not support the default
      force=true)
  end
  nothing
end

function Terra.writeRaster(ds::YAXArrays.Dataset; prefix = "", outdir=".", overwrite=false, kw...)
  map(_writeRaster, ds; prefix, outdir, overwrite, kw...)
end


function Terra.st_mosaic(ds::YAXArrays.Dataset; index=nothing, missingval=0.0f0, crs=EPSG(4326), kw...)
  res = read_ds(ds; index, missingval, crs, kw...)
  st_mosaic(res)
end


end
